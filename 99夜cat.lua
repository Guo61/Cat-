local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Guo61/Cat-/refs/heads/main/main.lua"))()

local Confirmed = false

WindUI:Popup({
    Title = "Cat脚盆 v1.0",
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    Content = "By:Ccat\nQQ:3395858053 欢迎使用99夜",
    Buttons = {
        {
            Title = "进入脚盆。",
            Icon = "arrow-right",
            Callback = function() Confirmed = true end,
            Variant = "Primary",
        }
    }
})

repeat wait() until Confirmed

-- 初始化 99夜 核心服务与变量
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()

local Features = { -- 功能开关状态
    KillAura = false,
    AutoChop = false,
    AutoEat = false,
    ChildESP = false,
    ChestESP = false,
    InstantInteract = false
}

local BONFIRE_POSITION = Vector3.new(0.189, 7.831, -0.341) -- 固定篝火位置
local itemConfig = { -- 物品配置表（名称/显示名/ESP颜色）
    {name = "Log", display = "木头", espColor = Color3.fromRGB(139, 69, 19)},
    {name = "Carrot", display = "胡萝卜", espColor = Color3.fromRGB(255, 165, 0)},
    {name = "Berry", display = "浆果", espColor = Color3.fromRGB(255, 0, 0)},
    {name = "Chest", display = "普通宝箱", espColor = Color3.fromRGB(210, 180, 140)},
    {name = "Alien Chest", display = "外星宝箱", espColor = Color3.fromRGB(0, 255, 0)},
    {name = "Lost Child", display = "走失孩子", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Dino Kid", display = "恐龙孩子", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Crossbow Cultist", display = "敌人", espColor = Color3.fromRGB(255, 0, 0)},
    {name = "Bear", display = "熊", espColor = Color3.fromRGB(139, 69, 19)},
    {name = "Wolf", display = "狼", espColor = Color3.fromRGB(192, 192, 192)}
}

-- ====================== 99夜 核心工具函数 ======================
-- 1. 获取客户端模块与进食远程函数
local function GetClientModule()
    local ClientModule = require(LP:WaitForChild("PlayerScripts"):WaitForChild("Client"))
    local EatRemote = ClientModule.Events.RequestConsumeItem
    return ClientModule, EatRemote
end

-- 2. 查找地图物品（支持传送/ESP/召唤）
local function FindMapItems(itemName)
    local found = {}
    local itemFolders = {Workspace:FindFirstChild("Items"), Workspace:FindFirstChild("MapItems")}
    for _, folder in ipairs(itemFolders) do
        if folder then
            for _, item in ipairs(folder:GetDescendants()) do
                if item.Name == itemName and item:IsA("Model") then
                    local part = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart")
                    if part then table.insert(found, {model = item, part = part}) end
                end
            end
        end
    end
    return found
end

-- 3. 自动进食逻辑
local function AutoEat()
    local _, EatRemote = GetClientModule()
    local Inventory = LP:FindFirstChild("Inventory")
    if not Inventory or not EatRemote then return end

    -- 优先吃浆果/胡萝卜（恢复饥饿）
    for _, foodName in ipairs({"Berry", "Carrot"}) do
        local food = Inventory:FindFirstChild(foodName)
        if food then
            food.Parent = ReplicatedStorage.TempStorage
            local success = pcall(function() EatRemote:InvokeServer(food) end)
            if success then
                WindUI:Notify({Title = "99夜", Content = "✅ 已吃"..foodName, Duration = 3})
            end
            return
        end
    end
end

-- 4. 杀戮光环逻辑（自动攻击范围内敌人）
local function KillAura()
    local ToolHandle = Character:FindFirstChild("ToolHandle")
    if not ToolHandle then return end
    local Tool = ToolHandle.OriginalItem.Value
    local ValidTools = {"Spear", "Old Axe", "Bone Club"} -- 有效武器列表
    if not table.find(ValidTools, Tool.Name) then return end

    -- 攻击100范围内敌人
    for _, Enemy in ipairs(Workspace.Characters:GetChildren()) do
        local EnemyRoot = Enemy:FindFirstChild("HumanoidRootPart")
        local EnemyHumanoid = Enemy:FindFirstChild("Humanoid")
        if EnemyRoot and EnemyHumanoid and EnemyHumanoid.Health > 0 then
            local Dist = (Character.HumanoidRootPart.Position - EnemyRoot.Position).Magnitude
            if Dist <= 100 then
                ReplicatedStorage.RemoteEvents.ToolDamageObject:InvokeServer(Enemy, Tool, true, Character.HumanoidRootPart.CFrame)
            end
        end
    end
end

-- 5. 自动砍树逻辑
local function AutoChop()
    local ToolHandle = Character:FindFirstChild("ToolHandle")
    if not ToolHandle then return end
    local Tool = ToolHandle.OriginalItem.Value
    if Tool.Name ~= "Old Axe" and Tool.Name ~= "Stone Axe" then return end

    -- 砍100范围内树木
    for _, Tree in ipairs(Workspace.Trees:GetChildren()) do
        local TreePart = Tree:FindFirstChild("Trunk") or Tree.PrimaryPart
        if TreePart then
            local Dist = (Character.HumanoidRootPart.Position - TreePart.Position).Magnitude
            if Dist <= 100 then
                ReplicatedStorage.RemoteEvents.ToolDamageObject:InvokeServer(Tree, Tool, true, Character.HumanoidRootPart.CFrame)
            end
        end
    end
end

-- 6. ESP生成函数（支持宝箱/孩子/敌人）
local function CreateESP(target, displayName, color)
    local RootPart = target.PrimaryPart or target:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end

    -- 创建BillboardGui
    local Billboard = Instance.new("BillboardGui")
    Billboard.Adornee = RootPart
    Billboard.Size = UDim2.new(0, 120, 0, 50)
    Billboard.StudsOffset = Vector3.new(0, 2, 0)
    Billboard.AlwaysOnTop = true
    Billboard.MaxDistance = 300

    -- 文字标签
    local Text = Instance.new("TextLabel")
    Text.Text = displayName
    Text.Size = UDim2.new(1, 0, 1, 0)
    Text.TextColor3 = color
    Text.BackgroundTransparency = 1
    Text.Font = Enum.Font.GothamBold
    Text.TextSize = 16
    Text.TextStrokeTransparency = 0.5
    Text.TextStrokeColor3 = Color3.new(0, 0, 0)
    Text.Parent = Billboard

    Billboard.Parent = RootPart
    return Billboard
end

-- 7. 批量ESP开关（按类型控制）
local function ToggleBatchESP(typeKey, displayType, targetNames, color)
    if Features[typeKey] then -- 关闭ESP
        for _, name in ipairs(targetNames) do
            for _, item in ipairs(FindMapItems(name)) do
                local Billboard = item.part:FindFirstChild("BillboardGui")
                if Billboard then Billboard:Destroy() end
            end
        end
        Features[typeKey] = false
        WindUI:Notify({Title = "99夜", Content = "❌ 关闭"..displayType.."ESP", Duration = 3})
    else -- 开启ESP
        for _, name in ipairs(targetNames) do
            for _, item in ipairs(FindMapItems(name)) do
                CreateESP(item.model, displayType.."("..name..")", color)
            end
        end
        Features[typeKey] = true
        WindUI:Notify({Title = "99夜", Content = "✅ 开启"..displayType.."ESP", Duration = 3})
    end
end

-- 8. 传送功能（传送到物品/篝火）
local function TeleportTo(targetType, targetName)
    local CharacterRoot = Character:FindFirstChild("HumanoidRootPart")
    if not CharacterRoot then return end

    if targetType == "Bonfire" then -- 传篝火
        Character:MoveTo(BONFIRE_POSITION)
        WindUI:Notify({Title = "99夜", Content = "✅ 已传送到篝火", Duration = 3})
        return
    end

    -- 传送到物品
    local Items = FindMapItems(targetName)
    if #Items == 0 then
        WindUI:Notify({Title = "99夜", Content = "❌ 未找到"..targetName, Duration = 3})
        return
    end
    -- 找最近的物品
    local ClosestItem = Items[1]
    local MinDist = (CharacterRoot.Position - Items[1].part.Position).Magnitude
    for _, item in ipairs(Items) do
        local Dist = (CharacterRoot.Position - item.part.Position).Magnitude
        if Dist < MinDist then
            MinDist = Dist
            ClosestItem = item
        end
    end
    Character:MoveTo(ClosestItem.part.Position + Vector3.new(0, 2, 0))
    WindUI:Notify({Title = "99夜", Content = "✅ 已传送到"..targetName, Duration = 3})
end

-- 9. 清除所有ESP
local function clearAllESP()
    for _, item in ipairs(FindMapItems("")) do
        local Billboard = item.part:FindFirstChild("BillboardGui")
        if Billboard then Billboard:Destroy() end
    end
end

-- 修复后的代码将所有功能整合到一个统一的 WindUI 窗口中
local Window = WindUI:CreateWindow({
    Title = "Cat Hub",
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    Author = "感谢游玩",
    Folder = "CatHub",
    Size = UDim2.fromOffset(580, 340),
    Transparent = true,
    Theme = "Dark",
    User = { Enabled = true },
    SideBarWidth = 200,
    ScrollBarEnabled = true,
})

Window:Tag({
        Title = "v1.10",
        Color = Color3.fromHex("#30ff6a")
    })
    Window:Tag({
        Title = "99夜", 
        Color = Color3.fromHex("#315dff")
    })
    local TimeTag = Window:Tag({
        Title = "正在开发更多服务器",
        Color = Color3.fromHex("#000000")
    })

-- 创建指定的大类（作为标签页）
local Tabs = {
    Home = Window:Tab({ Title = "主页", Icon = "crown" }),
    LegendsOfSpeed = Window:Tab({ Title = "主要功能", Icon = "zap" }),
    NinjaLegends = Window:Tab({ Title = "传送", Icon = "user" }),
    StrengthLegends = Window:Tab({ Title = "透视", Icon = "dumbbell" }),
    Misc = Window:Tab({ Title = "其他", Icon = "settings" })
}

Window:SelectTab(1)

-- 全局控制变量
local autoLoops = {}

local function startLoop(name, callback, delay)
    if autoLoops[name] then return end
    autoLoops[name] = coroutine.wrap(function()
        while autoLoops[name] do
            pcall(callback)
            task.wait(delay)
        end
    end)
    task.spawn(autoLoops[name])
end

local function stopLoop(name)
    if not autoLoops[name] then return end
    autoLoops[name] = nil
end

--- 主页 Tab ---
Tabs.Home:Paragraph({
    Title = "666这么帅",
    Desc = "必须帅",
    Image = "https://raw.githubusercontent.com/Guo61/Cat-/refs/heads/main/1756468599211.png",
    ImageSize = 42,
    Thumbnail = "https://raw.githubusercontent.com/Guo61/Cat-/refs/heads/main/1756468641440.jpg",
    ThumbnailSize = 120
})

Tabs.Home:Paragraph({
    Title = "欢迎",
    Desc = "需要时开启反挂机。脚本仍在更新中... 作者: Ccat\n脚本免费, 请勿倒卖。",
})
-- 反挂机 (通过外部链接加载)
Tabs.Home:Button({
    Title = "反挂机",
    Desc = "从GitHub加载并执行反挂机",
    Callback = function()
        pcall(function()
            local response = game:HttpGet("https://raw.githubusercontent.com/Guo61/Cat-/refs/heads/main/%E5%8F%8D%E6%8C%82%E6%9C%BA.lua", true)
            if response and #response > 100 then
                loadstring(response)()
            end
        end)
    end
})

-- FPS 显示
Tabs.Home:Toggle({
    Title = "显示FPS",
    Desc = "在屏幕上显示当前FPS",
    Callback = function(state)
        local FpsGui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("FPSGui")
        if state then
            if not FpsGui then
                FpsGui = Instance.new("ScreenGui")
                local FpsXS = Instance.new("TextLabel")
                FpsGui.Name = "FPSGui"
                FpsGui.ResetOnSpawn = false
                FpsXS.Name = "FpsXS"
                FpsXS.Size = UDim2.new(0, 100, 0, 50)
                FpsXS.Position = UDim2.new(0, 10, 0, 10)
                FpsXS.BackgroundTransparency = 1
                FpsXS.Font = Enum.Font.SourceSansBold
                FpsXS.Text = "FPS: 0"
                FpsXS.TextSize = 20
                FpsXS.TextColor3 = Color3.new(1, 1, 1)
                FpsXS.Parent = FpsGui
                FpsGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                
                game:GetService("RunService").Heartbeat:Connect(function()
                    local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
                    FpsXS.Text = "FPS: " .. fps
                end)
            end
            FpsGui.Enabled = true
        else
            if FpsGui then
                FpsGui.Enabled = false
            end
        end
    end
})

-- 范围显示
Tabs.Home:Toggle({
    Title = "显示范围",
    Desc = "显示玩家范围",
    Callback = function(state)
        local HeadSize = 20
        local highlight = Instance.new("Highlight")
        highlight.Adornee = nil
        highlight.OutlineTransparency = 0
        highlight.FillTransparency = 0.7
        highlight.FillColor = Color3.fromHex("#0000FF")

        local function applyHighlight(character)
            if not character:FindFirstChild("WindUI_RangeHighlight") then
                local clone = highlight:Clone()
                clone.Adornee = character
                clone.Name = "WindUI_RangeHighlight"
                clone.Parent = character
            end
        end

        local function removeHighlight(character)
            local h = character:FindFirstChild("WindUI_RangeHighlight")
            if h then
                h:Destroy()
            end
        end

        if state then
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Name ~= game.Players.LocalPlayer.Name and player.Character then
                    applyHighlight(player.Character)
                end
            end
            game.Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    task.wait(1)
                    applyHighlight(character)
                end)
            end)
            game.Players.PlayerRemoving:Connect(function(player)
                if player.Character then
                    removeHighlight(player.Character)
                end
            end)
        else
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character then
                    removeHighlight(player.Character)
                end
            end
        end
    end
})

-- 半隐身, 玩家入退提示, 甩飞
Tabs.Home:Button({
    Title = "半隐身",
    Desc = "从GitHub加载并执行隐身脚本",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Invisible-35376"))() end)
    end
})
Tabs.Home:Button({
    Title = "玩家入退提示",
    Desc = "从GitHub加载并执行提示脚本",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))() end)
    end
})

-- 甩飞功能 (修复版)
Tabs.Home:Toggle({
    Title = "甩飞",
    Desc = "开启后会使角色高速移动",
    Default = false,
    Callback = function(state)
        if state then
            -- 启动甩飞
            local walkflinging = true
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local Root = Character:WaitForChild("HumanoidRootPart")
            local Humanoid = Character:WaitForChild("Humanoid")
            
            -- 监听角色死亡
            Humanoid.Died:Connect(function()
                walkflinging = false
            end)
            
            -- 设置初始状态
            Root.CanCollide = false
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            
            -- 甩飞循环
            task.spawn(function()
                while walkflinging and Root and Root.Parent do
                    game:GetService("RunService").Heartbeat:Wait()
                    local vel = Root.Velocity
                    Root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                    game:GetService("RunService").RenderStepped:Wait()
                    Root.Velocity = vel
                    game:GetService("RunService").Stepped:Wait()
                    Root.Velocity = vel + Vector3.new(0, 0.1, 0)
                    
                    -- 短暂延迟防止卡顿
                    task.wait(0.01)
                end
            end)
            
            -- 存储引用以便后续关闭
            autoLoops["walkFling"] = {stop = function() walkflinging = false end}
        else
            -- 停止甩飞
            if autoLoops["walkFling"] then
                autoLoops["walkFling"].stop()
                autoLoops["walkFling"] = nil
                
                -- 恢复角色正常状态
                local LocalPlayer = game:GetService("Players").LocalPlayer
                if LocalPlayer.Character then
                    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    local Root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    
                    if Humanoid then
                        Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end
                    
                    if Root then
                        Root.Velocity = Vector3.new(0, 0, 0)
                        Root.CanCollide = true
                    end
                end
            end
        end
    end
})
-- 防甩飞 (Toggle)
local antiWalkFlingConn
Tabs.Home:Toggle({
    Title = "防甩飞",
    Desc = "不要和甩飞同时开启!",
    Callback = function(state)
        local player = game.Players.LocalPlayer
        if state then
            if antiWalkFlingConn then antiWalkFlingConn:Disconnect() end
            local lastVelocity = Vector3.new()
            antiWalkFlingConn = game:GetService("RunService").Stepped:Connect(function()
                local character = player.Character
                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local currentVelocity = hrp.Velocity
                if (currentVelocity - lastVelocity).Magnitude > 100 then
                    hrp.Velocity = lastVelocity
                end
                lastVelocity = currentVelocity
            end)
        else
            if antiWalkFlingConn then antiWalkFlingConn:Disconnect() end
        end
    end
})

-- 速度, 重力, 跳跃
Tabs.Home:Slider({
    Title = "设置速度",
    Desc = "可输入",
    Value = { Min = 0, Max = 520, Default = 25 },
    Callback = function(val)
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = val
            end
        end
    end
})
Tabs.Home:Slider({
    Title = "设置个人重力",
    Desc = "默认值即为最大值",
    Value = { Min = 0, Max = 196.2, Default = 196.2, Rounding = 1 },
    Callback = function(val)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local oldGravity = rootPart:FindFirstChild("PersonalGravity")
        if oldGravity then oldGravity:Destroy() end

        if val ~= workspace.Gravity then
            local personalGravity = Instance.new("BodyForce")
            personalGravity.Name = "PersonalGravity"
            local mass = rootPart:GetMass()
            local force = Vector3.new(0, mass * (workspace.Gravity - val), 0)
            personalGravity.Force = force
            personalGravity.Parent = rootPart
        end
    end
})
Tabs.Home:Slider({
    Title = "设置跳跃高度",
    Desc = "可输入",
    Value = { Min = 0, Max = 200, Default = 50 },
    Callback = function(val)
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = val
            end
        end
    end
})

local function getPlayerNames()
    local names = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

-- 创建一个函数来刷新下拉菜单
local function refreshPlayerDropdown()
    -- 增加了一个检查，确保playersDropdown存在
    if not playersDropdown then return end

    local currentValues = playersDropdown:GetValues()
    local newValues = getPlayerNames()
    local added = {}
    local removed = {}
    
    local newSet = {}
    for _, name in ipairs(newValues) do
        newSet[name] = true
    end
    
    for _, name in ipairs(currentValues) do
        if not newSet[name] then
            table.insert(removed, name)
        end
    end
    
    local currentSet = {}
    for _, name in ipairs(currentValues) do
        currentSet[name] = true
    end
    
    for _, name in ipairs(newValues) do
        if not currentSet[name] then
            table.insert(added, name)
        end
    end
    
    for _, name in ipairs(removed) do
        playersDropdown:RemoveValue(name)
    end
    
    for _, name in ipairs(added) do
        playersDropdown:AddValue(name)
    end
end

-- **将下拉菜单的创建代码保持在此处，这是原始代码中的位置**
local playersDropdown = Tabs.Home:Dropdown({
    Title = "选择要传送的玩家",
    Values = getPlayerNames(), -- 初始填充
})

Tabs.Home:Button({
    Title = "传送至玩家",
    Desc = "传送到选中的玩家",
    Callback = function()
        local selectedPlayerName = playersDropdown.Value
        local targetPlayer = game.Players:FindFirstChild(selectedPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            humanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        end
    end
})

-- **修复：将事件连接代码移动到这里，确保playersDropdown已经创建**
game.Players.PlayerAdded:Connect(refreshPlayerDropdown)
game.Players.PlayerRemoving:Connect(refreshPlayerDropdown)

-- 修复后的部分，使用 AddValue 和 RemoveValue 方法来更新
game.Players.PlayerAdded:Connect(refreshPlayerDropdown)
game.Players.PlayerRemoving:Connect(refreshPlayerDropdown)


-- 飞行, 无限跳, 自瞄, 子弹追踪, 夜视, 穿墙
Tabs.Home:Button({
    Title = "飞行",
    Desc = "从GitHub加载并执行飞行脚本",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Guo61/Cat-/refs/heads/main/%E9%A3%9E%E8%A1%8C%E8%84%9A%E6%9C%AC.lua"))() end)
    end
})
Tabs.Home:Button({
    Title = "无限跳",
    Desc = "开启后无法关闭",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/V5PQy3y0", true))() end)
    end
})
Tabs.Home:Button({
    Title = "自瞄",
    Desc = "宙斯自瞄",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/Arceus%20Aimbot.lua"))() end)
    end
})

local trackData = {}
Tabs.Home:Toggle({
    Title = "子弹追踪",
    Default = false,
    Callback = function(state)
        trackData.enabled = state
        if not state then
            if trackData.workspaceConn then trackData.workspaceConn:Disconnect() end
            for _, conn in pairs(trackData.bulletConns or {}) do conn:Disconnect() end
            trackData.bulletConns = {}
            return
        end
        local function getTarget(bulletPos)
            local nearestTarget, nearestDist = nil, math.huge
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    local char = player.Character
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if humanoid and humanoid.Health > 0 and root then
                        local dist = (bulletPos - root.Position).Magnitude
                        if dist <= 70 and dist < nearestDist then
                            nearestDist = dist
                            nearestTarget = root
                        end
                    end
                end
            end
            return nearestTarget
        end

        local function attachTrack(bullet)
            local bulletPart = bullet:IsA("BasePart") and bullet or bullet:FindFirstChildWhichIsA("BasePart")
            if not bulletPart then return end
            local bodyVel = bulletPart:FindFirstChildOfClass("BodyVelocity")
            if not bodyVel then
                bodyVel = Instance.new("BodyVelocity")
                bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVel.Velocity = bulletPart.Velocity
                bodyVel.Parent = bulletPart
            end

            local bulletConn = game:GetService("RunService").Heartbeat:Connect(function()
                if not bulletPart.Parent or not trackData.enabled then
                    bulletConn:Disconnect()
                    trackData.bulletConns[bulletConn] = nil
                    return
                end
                local target = getTarget(bulletPart.Position)
                if target then
                    local trackDir = (target.Position - bulletPart.Position).Unit
                    bodyVel.Velocity = trackDir * bulletPart.Velocity.Magnitude
                    bulletPart.CFrame = CFrame.new(bulletPart.Position, target.Position)
                end
            end)
            trackData.bulletConns[bulletConn] = true
        end
        trackData.workspaceConn = workspace.ChildAdded:Connect(function(child)
            local isLocalBullet = (child.Name:lower():find("bullet") or child.Name:lower():find("projectile") or child.Name:lower():find("missile")) and (child:FindFirstChild("Owner") and child.Owner.Value == game.Players.LocalPlayer)
            if isLocalBullet then
                task.wait(0.05)
                attachTrack(child)
            end
        end)
    end
})

local nightVisionData = {}
Tabs.Home:Toggle({
    Title = "夜视",
    Default = false,
    Callback = function(isEnabled)
        local lighting = game:GetService("Lighting")
        if isEnabled then
            pcall(function()
                nightVisionData.originalAmbient = lighting.Ambient
                nightVisionData.originalBrightness = lighting.Brightness
                nightVisionData.originalFogEnd = lighting.FogEnd
                lighting.Ambient = Color3.fromRGB(255, 255, 255)
                lighting.Brightness = 1
                lighting.FogEnd = 1e10
                for _, v in pairs(lighting:GetDescendants()) do
                    if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
                        v.Enabled = false
                    end
                end
                nightVisionData.changedConnection = lighting.Changed:Connect(function()
                    lighting.Ambient = Color3.fromRGB(255, 255, 255)
                    lighting.Brightness = 1
                    lighting.FogEnd = 1e10
                end)
                local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                if not humanoidRootPart:FindFirstChildWhichIsA("PointLight") then
                    local headlight = Instance.new("PointLight", humanoidRootPart)
                    headlight.Brightness = 1
                    headlight.Range = 60
                    nightVisionData.pointLight = headlight
                end
            end)
        else
            if nightVisionData.originalAmbient then lighting.Ambient = nightVisionData.originalAmbient end
            if nightVisionData.originalBrightness then lighting.Brightness = nightVisionData.originalBrightness end
            if nightVisionData.originalFogEnd then lighting.FogEnd = nightVisionData.originalFogEnd end
            if nightVisionData.changedConnection then nightVisionData.changedConnection:Disconnect() end
            if nightVisionData.pointLight and nightVisionData.pointLight.Parent then nightVisionData.pointLight:Destroy() end
        end
    end
})

local noclipConn
Tabs.Home:Toggle({
    Title = "穿墙",
    Default = false,
    Callback = function(state)
        local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        if state then
            noclipConn = game:GetService("RunService").Stepped:Connect(function()
                if character then
                    for _, v in pairs(character:GetChildren()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() end
            if character then
                for _, v in pairs(character:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = true
                    end
                end
            end
        end
    end
})

-- 人物透视 (ESP) 功能
local espEnabled = false
local espConnections = {}
local espHighlights = {}
local espNameTags = {}

local function createESP(player)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    -- Create Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "WindUI_ESP"
    highlight.Adornee = char
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
    espHighlights[player] = highlight

    -- Create Name Tag
    local nameTag = Instance.new("BillboardGui")
    nameTag.Name = "WindUI_NameTag"
    nameTag.Adornee = humanoidRootPart
    nameTag.Size = UDim2.new(0, 150, 0, 20)
    nameTag.StudsOffset = Vector3.new(0, 2.8, 0)
    nameTag.AlwaysOnTop = true
    nameTag.Parent = humanoidRootPart
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.Name
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 14
    textLabel.TextScaled = false
    textLabel.Parent = nameTag
    espNameTags[player] = nameTag
end

local function removeESP(player)
    if espHighlights[player] and espHighlights[player].Parent then
        espHighlights[player]:Destroy()
        espHighlights[player] = nil
    end
    if espNameTags[player] and espNameTags[player].Parent then
        espNameTags[player]:Destroy()
        espNameTags[player] = nil
    end
end

local function toggleESP(state)
    espEnabled = state
    if state then
        -- Add ESP for all current players
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                pcall(createESP, player)
            end
        end
        -- Connect to player added event
        espConnections.playerAdded = game.Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                if espEnabled then
                    pcall(createESP, player)
                end
            end)
        end)
        -- Connect to player removing event
        espConnections.playerRemoving = game.Players.PlayerRemoving:Connect(function(player)
            pcall(removeESP, player)
        end)
    else
        -- Remove ESP from all players
        for _, player in ipairs(game.Players:GetPlayers()) do
            pcall(removeESP, player)
        end
        -- Disconnect events
        for _, conn in pairs(espConnections) do
            conn:Disconnect()
        end
        espConnections = {}
    end
end

Tabs.Home:Toggle({
    Title = "人物透视",
    Desc = "显示其他玩家的位置和名称",
    Default = false,
    Callback = toggleESP
})

Tabs.Home:Button({
    Title = "服务器信息",
    Desc = "显示当前服务器的信息",
    Callback = function()
        local players = game.Players:GetPlayers()
        local maxPlayers = game.Players.MaxPlayers
        local placeId = game.PlaceId
        local jobId = game.JobId
        local serverType = game:GetService("RunService"):IsStudio() and "Studio" or "Live"
        
        WindUI:Notify({
            Title = "服务器信息",
            Content = string.format("玩家数量: %d/%d\nPlace ID: %d\nJob ID: %s\n服务器类型: %s", #players, maxPlayers, placeId, jobId, serverType),
            Duration = 10
        })
    end
})

Tabs.Home:Button({
    Title = "复制服务器ID",
    Desc = "复制当前服务器的Job ID到剪贴板",
    Callback = function()
        setclipboard(game.JobId)
        WindUI:Notify({
            Title = "服务器ID已复制",
            Content = "Job ID: " .. game.JobId,
            Duration = 3
        })
    end
})

Tabs.Home:Button({
    Title = "复制服务器邀请链接",
    Desc = "复制当前服务器的邀请链接到剪贴板",
    Callback = function()
        local inviteLink = "roblox://experiences/start?placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId
        setclipboard(inviteLink)
        WindUI:Notify({
            Title = "邀请链接已复制",
            Content = "链接已复制到剪贴板",
            Duration = 3
        })
    end
})

Tabs.Home:Paragraph({
    Title = "提示",
    Desc = "以下功能小心使用!!!",
})

Tabs.Home:Button({
    Title = "重新加入服务器",
    Desc = "尝试重新加入当前服务器",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local placeId = game.PlaceId
        local jobId = game.JobId
        
        TeleportService:TeleportToPlaceInstance(placeId, jobId, game.Players.LocalPlayer)
    end
})

Tabs.Home:Button({
    Title = "切换服务器",
    Desc = "切换到相同游戏的另一个服务器",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local placeId = game.PlaceId
        
        TeleportService:Teleport(placeId, game.Players.LocalPlayer)
    end
})

Tabs.Home:Button({
    Title = "复制玩家列表",
    Desc = "复制当前服务器所有玩家名称到剪贴板",
    Callback = function()
        local players = game.Players:GetPlayers()
        local playerNames = {}
        for _, player in ipairs(players) do
            table.insert(playerNames, player.Name)
        end
        setclipboard(table.concat(playerNames, ", "))
        WindUI:Notify({
            Title = "玩家列表已复制",
            Content = "共 " .. #players .. " 名玩家",
            Duration = 3
        })
    end
})

Tabs.Home:Button({
    Title = "显示玩家列表",
    Desc = "显示当前服务器所有玩家名称",
    Callback = function()
        local players = game.Players:GetPlayers()
        local playerList = {}
        for _, player in ipairs(players) do
            table.insert(playerList, player.Name)
        end
        WindUI:Notify({
            Title = "玩家列表 (" .. #players .. " 人)",
            Content = table.concat(playerList, "\n"),
            Duration = 10
        })
    end
})

--- 主要功能 Tab ---
Tabs.LegendsOfSpeed:Section({
    Title = "99夜 主要功能",
    Content = "99夜 主要功能"
})

-- 杀戮光环
Tabs.LegendsOfSpeed:Toggle({
    Title = "杀戮光环",
    Desc = "自动攻击范围内的敌人",
    Callback = function(state)
        Features.KillAura = state
        if state then
            WindUI:Notify({Title = "99夜", Content = "✅ 开启杀戮光环", Duration = 3})
            startLoop("KillAura", KillAura, 0.5)
        else
            WindUI:Notify({Title = "99夜", Content = "❌ 关闭杀戮光环", Duration = 3})
            stopLoop("KillAura")
        end
    end
})

-- 自动砍树
Tabs.LegendsOfSpeed:Toggle({
    Title = "自动砍树",
    Desc = "自动砍伐范围内的树木",
    Callback = function(state)
        Features.AutoChop = state
        if state then
            WindUI:Notify({Title = "99夜", Content = "✅ 开启自动砍树", Duration = 3})
            startLoop("AutoChop", AutoChop, 0.5)
        else
            WindUI:Notify({Title = "99夜", Content = "❌ 关闭自动砍树", Duration = 3})
            stopLoop("AutoChop")
        end
    end
})

-- 自动进食
Tabs.LegendsOfSpeed:Toggle({
    Title = "自动进食",
    Desc = "自动吃食物恢复饥饿度",
    Callback = function(state)
        Features.AutoEat = state
        if state then
            WindUI:Notify({Title = "99夜", Content = "✅ 开启自动进食", Duration = 3})
            startLoop("AutoEat", AutoEat, 5)
        else
            WindUI:Notify({Title = "99夜", Content = "❌ 关闭自动进食", Duration = 3})
            stopLoop("AutoEat")
        end
    end
})

-- 瞬间交互
Tabs.LegendsOfSpeed:Toggle({
    Title = "瞬间交互",
    Desc = "瞬间完成所有交互动作",
    Callback = function(state)
        Features.InstantInteract = state
        if state then
            WindUI:Notify({Title = "99夜", Content = "✅ 开启瞬间交互", Duration = 3})
            ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                fireproximityprompt(prompt)
            end)
        else
            WindUI:Notify({Title = "99夜", Content = "❌ 关闭瞬间交互", Duration = 3})
        end
    end
})

--- 传送 Tab ---
Tabs.NinjaLegends:Section({
    Title = "99夜 传送功能",
    Content = "快速传送到各种资源点"
})

-- 传送按钮组
local teleportItems = {
    {name = "Log", display = "木头"},
    {name = "Carrot", display = "胡萝卜"},
    {name = "Berry", display = "浆果"},
    {name = "Chest", display = "普通宝箱"},
    {name = "Alien Chest", display = "外星宝箱"},
    {name = "Lost Child", display = "走失孩子"},
    {name = "Dino Kid", display = "恐龙孩子"}
}

for _, item in ipairs(teleportItems) do
    Tabs.NinjaLegends:Button({
        Title = "传送到"..item.display,
        Desc = "传送到最近的"..item.display,
        Callback = function()
            TeleportTo("Item", item.name)
        end
    })
end

-- 传送到篝火
Tabs.NinjaLegends:Button({
    Title = "传送到篝火",
    Desc = "传送到主篝火位置",
    Callback = function()
        TeleportTo("Bonfire", "")
    end
})

--- 透视 Tab ---
Tabs.StrengthLegends:Section({
    Title = "99夜 透视功能",
    Content = "显示各种资源的ESP"
})

-- 孩子ESP
Tabs.StrengthLegends:Toggle({
    Title = "孩子ESP",
    Desc = "显示走失孩子的ESP",
    Callback = function(state)
        ToggleBatchESP("ChildESP", "孩子", {"Lost Child", "Dino Kid"}, Color3.fromRGB(0, 255, 255))
    end
})

-- 宝箱ESP
Tabs.StrengthLegends:Toggle({
    Title = "宝箱ESP",
    Desc = "显示所有宝箱的ESP",
    Callback = function(state)
        ToggleBatchESP("ChestESP", "宝箱", {"Chest", "Alien Chest"}, Color3.fromRGB(210, 180, 140))
    end
})

-- 资源ESP
Tabs.StrengthLegends:Toggle({
    Title = "资源ESP",
    Desc = "显示木头和食物的ESP",
    Callback = function(state)
        ToggleBatchESP("ResourceESP", "资源", {"Log", "Carrot", "Berry"}, Color3.fromRGB(255, 165, 0))
    end
})

-- 敌人ESP
Tabs.StrengthLegends:Toggle({
    Title = "敌人ESP",
    Desc = "显示敌人和动物的ESP",
    Callback = function(state)
        ToggleBatchESP("EnemyESP", "敌人", {"Crossbow Cultist", "Bear", "Wolf"}, Color3.fromRGB(255, 0, 0))
    end
})

-- 清除所有ESP
Tabs.StrengthLegends:Button({
    Title = "清除所有ESP",
    Desc = "清除所有已显示的ESP",
    Callback = function()
        clearAllESP()
        WindUI:Notify({Title = "99夜", Content = "✅ 已清除所有ESP", Duration = 3})
    end
})

--- 其他 Tab ---
Tabs.Misc:Section({
    Title = "99夜 其他功能",
    Content = "其他实用功能"
})

-- 重新出生
Tabs.Misc:Button({
    Title = "重新出生",
    Desc = "让角色重新出生",
    Callback = function()
        ReplicatedStorage.RemoteEvents.ResetCharacter:FireServer()
        WindUI:Notify({Title = "99夜", Content = "✅ 角色已重新出生", Duration = 3})
    end
})

-- 自杀
Tabs.Misc:Button({
    Title = "自杀",
    Desc = "让角色死亡",
    Callback = function()
        Character:BreakJoints()
        WindUI:Notify({Title = "99夜", Content = "✅ 角色已死亡", Duration = 3})
    end
})

-- 无限耐力
local infiniteStamina = false
Tabs.Misc:Toggle({
    Title = "无限耐力",
    Desc = "角色不会消耗耐力",
    Callback = function(state)
        infiniteStamina = state
        if state then
            WindUI:Notify({Title = "99夜", Content = "✅ 开启无限耐力", Duration = 3})
            startLoop("InfiniteStamina", function()
                if Character and Character:FindFirstChild("Stamina") then
                    Character.Stamina.Value = 100
                end
            end, 0.1)
        else
            WindUI:Notify({Title = "99夜", Content = "❌ 关闭无限耐力", Duration = 3})
            stopLoop("InfiniteStamina")
        end
    end
})

-- 上帝模式
local godMode = false
Tabs.Misc:Toggle({
    Title = "上帝模式",
    Desc = "角色不会受到伤害",
    Callback = function(state)
        godMode = state
        if state then
            WindUI:Notify({Title = "99夜", Content = "✅ 开启上帝模式", Duration = 3})
            if Character and Character:FindFirstChild("Humanoid") then
                Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end
        else
            WindUI:Notify({Title = "99夜", Content = "❌ 关闭上帝模式", Duration = 3})
            if Character and Character:FindFirstChild("Humanoid") then
                Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            end
        end
    end
})

-- 自动收集掉落物
local autoCollect = false
Tabs.Misc:Toggle({
    Title = "自动收集掉落物",
    Desc = "自动收集附近的掉落物品",
    Callback = function(state)
        autoCollect = state
        if state then
            WindUI:Notify({Title = "99夜", Content = "✅ 开启自动收集", Duration = 3})
            startLoop("AutoCollect", function()
                for _, item in ipairs(Workspace:FindFirstChild("Items"):GetChildren()) do
                    if item:IsA("Model") and (Character.HumanoidRootPart.Position - item.PrimaryPart.Position).Magnitude < 20 then
                        firetouchinterest(Character.HumanoidRootPart, item.PrimaryPart, 0)
                        firetouchinterest(Character.HumanoidRootPart, item.PrimaryPart, 1)
                    end
                end
            end, 1)
        else
            WindUI:Notify({Title = "99夜", Content = "❌ 关闭自动收集", Duration = 3})
            stopLoop("AutoCollect")
        end
    end
})

-- 脚本状态显示
Tabs.Misc:Paragraph({
    Title = "脚本状态",
    Desc = "99夜脚本已成功加载\n版本: v1.0\n作者: Ccat",
    Image = "rbxassetid://129260712070622",
    ImageSize = 42
})

-- 初始化完成提示
WindUI:Notify({
    Title = "99夜脚本加载成功",
    Content = "欢迎使用99夜脚本！\n作者: Ccat\nQQ: 3395858053",
    Duration = 5
})

-- 自动重新应用ESP的监听器
workspace.DescendantAdded:Connect(function(descendant)
    if not descendant:IsA("Model") then return end
    
    -- 孩子ESP
    if Features.ChildESP and (descendant.Name == "Lost Child" or descendant.Name == "Dino Kid") then
        CreateESP(descendant, "孩子("..descendant.Name..")", Color3.fromRGB(0, 255, 255))
    end
    
    -- 宝箱ESP
    if Features.ChestESP and (descendant.Name == "Chest" or descendant.Name == "Alien Chest") then
        CreateESP(descendant, "宝箱("..descendant.Name..")", Color3.fromRGB(210, 180, 140))
    end
    
    -- 资源ESP
    if Features.ResourceESP and (descendant.Name == "Log" or descendant.Name == "Carrot" or descendant.Name == "Berry") then
        CreateESP(descendant, "资源("..descendant.Name..")", Color3.fromRGB(255, 165, 0))
    end
    
    -- 敌人ESP
    if Features.EnemyESP and (descendant.Name == "Crossbow Cultist" or descendant.Name == "Bear" or descendant.Name == "Wolf") then
        CreateESP(descendant, "敌人("..descendant.Name..")", Color3.fromRGB(255, 0, 0))
    end
end)

-- 角色死亡时重新初始化
LP.CharacterAdded:Connect(function(newChar)
    Character = newChar
    task.wait(1) -- 等待角色完全加载
    
    -- 重新应用上帝模式
    if godMode and Character:FindFirstChild("Humanoid") then
        Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
end)