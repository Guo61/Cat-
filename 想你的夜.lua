local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Guo61/Cat-/refs/heads/main/main.lua"))()

local Confirmed = false

WindUI:Popup({
    Title = "Cat脚盆 v1.0",
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    Content = "By:Ccat\nQQ:3395858053 欢迎使用",
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
        Title = "v1.0",
        Color = Color3.fromHex("#30ff6a")
    })
    Window:Tag({
        Title = "三传奇", 
        Color = Color3.fromHex("#315dff")
    })
    local TimeTag = Window:Tag({
        Title = "正在开发更多服务器",
        Color = Color3.fromHex("#000000")
    })
-- 创建指定的大类（作为标签页）
local Tabs = {
    Home = Window:Tab({ Title = "主页", Icon = "crown" }),
    LegendsOfSpeed = Window:Tab({ Title = "极速传奇", Icon = "zap" }),
    NinjaLegends = Window:Tab({ Title = "忍者传奇", Icon = "user" }),
    StrengthLegends = Window:Tab({ Title = "力量传奇", Icon = "dumbbell" }),
    Misc = Window:Tab({ Title = "杂项", Icon = "settings" }),
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

        -- Connect events for new players
        espConnections.playerAdded = game.Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Wait()
            pcall(createESP, player)
        end)
        espConnections.playerRemoving = game.Players.PlayerRemoving:Connect(function(player)
            removeESP(player)
        end)
    else
        -- Clean up existing ESP and disconnect events
        if espConnections.playerAdded then espConnections.playerAdded:Disconnect() end
        if espConnections.playerRemoving then espConnections.playerRemoving:Disconnect() end
        for player, _ in pairs(espHighlights) do
            removeESP(player)
        end
        espHighlights = {}
        espNameTags = {}
    end
end

Tabs.Home:Toggle({
    Title = "人物透视 (ESP)",
    Desc = "显示其他玩家的透视框和名字。",
    Default = false,
    Callback = toggleESP,
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

--- 极速传奇 Tab ---
Tabs.LegendsOfSpeed:Code({
    Title = "提示!!!",
    Code = "传送功能请勿在其他服务器执行\n该服务器功能暂未补全"
})

Tabs.LegendsOfSpeed:Section({ Title = "传送", Icon = "map-pin" })
local legendOfSpeedTeleports = {
    { "城市", CFrame.new(-534.38, 4.07, 437.75) },
    { "神秘洞穴", CFrame.new(-9683.05, 59.25, 3136.63) },
    { "草地挑战", CFrame.new(-1550.49, 34.51, 87.48) },
    { "海市蜃楼挑战", CFrame.new(1414.31, 90.44, -2058.34) },
    { "冰霜挑战", CFrame.new(2045.63, 64.57, 993.17) },
    { "绿色水晶", CFrame.new(385.60, 65.02, 19.00) },
    { "蓝色水晶", CFrame.new(-581.56, 4.12, 495.92) },
    { "紫色水晶", CFrame.new(-428.17, 4.12, 203.52) },
    { "黄色水晶", CFrame.new(-313.23, 4.12, -375.43) },
    { "欧米茄水晶", CFrame.new(4532.49, 74.45, 6398.68) },
}
for _, teleport in ipairs(legendOfSpeedTeleports) do
    Tabs.LegendsOfSpeed:Button({
        Title = "传送到" .. teleport[1],
        Desc = "单击以执行",
        Callback = function()
            local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            humanoidRootPart.CFrame = teleport[2]
        end
    })
end

Tabs.LegendsOfSpeed:Section({ Title = "自动", Icon = "toggle" })
Tabs.LegendsOfSpeed:Toggle({
    Title = "自动重生",
    Desc = "自动重生",
    Callback = function(state)
        if state then
            startLoop("rebirth", function()
                game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
            end, 0.5)
        else
            stopLoop("rebirth")
        end
    end
})

Tabs.LegendsOfSpeed:Button({
    Title = "自动重生和自动刷等级",
    Desc = "从Pastebin加载并执行",
    Callback = function()
        pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/T9wTL150"))() end)
    end
})

local orbTeleports = {
    { "橙球", "Orange Orb", "City" },
    { "红球", "Red Orb", "City" },
    { "黄球", "Yellow Orb", "City" },
    { "宝石", "Gem", "City" },
    { "蓝球", "Blue Orb", "City" },
}
for _, orb in ipairs(orbTeleports) do
    Tabs.LegendsOfSpeed:Toggle({
        Title = "自动吃" .. orb[1] .. " (city)",
        Desc = "自动收集 " .. orb[1],
        Callback = function(state)
            if state then
                startLoop("orb_" .. orb[1], function()
                    local args = { "collectOrb", orb[2], orb[3] }
                    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args))
                end, 0.5)
            else
                stopLoop("orb_" .. orb[1])
            end
        end
    })
end

--- 忍者传奇 Tab ---
Tabs.NinjaLegends:Section({ Title = "自动", Icon = "toggle" })
local ranks = {"Rank 1", "Rank 2", "Rank 3", "Rank 4", "Rank 5", "Rank 6", "Rank 7", "Rank 8", "Rank 9", "Rank 10"}
local ninjaAutoToggles = {
    { "自动挥剑", "autoswing", function()
        for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if tool:FindFirstChild("ninjitsuGain") then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
                break
            end
        end
        game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("swingKatana")
    end, 0.1 },
    { "自动售卖", "autosell", function()
        local sellArea = game:GetService("Workspace").sellAreaCircles["sellAreaCircle16"]
        if sellArea then
            sellArea.circleInner.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end, 0.1 },
    { "自动购买排名", "autobuyranks", function()
        for _, rank in ipairs(ranks) do
            game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("buyRank", rank)
        end
    end, 0.1 },
    { "自动购买腰带", "autobuybelts", function()
        game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("buyAllBelts", "Inner Peace Island")
    end, 0.5 },
    { "自动购买技能", "autobuyskills", function()
        game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("buyAllSkills", "Inner Peace Island")
    end, 0.5 },
    { "自动购买剑", "autobuy", function()
        game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("buyAllSwords", "Inner Peace Island")
    end, 0.5 },
}
for _, item in ipairs(ninjaAutoToggles) do
    Tabs.NinjaLegends:Toggle({
        Title = item[1],
        Default = false,
        Callback = function(state)
            if state then
                startLoop(item[2], item[3], item[4])
            else
                stopLoop(item[2])
            end
        end
    })
end

Tabs.NinjaLegends:Button({
    Title = "解锁所有岛",
    Desc = "传送到所有岛屿以解锁",
    Callback = function()
        local originalCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        for _, v in next, game.workspace.islandUnlockParts:GetChildren() do
            if v then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.islandSignPart.CFrame
                wait(0.5)
            end
        end
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = originalCFrame
    end
})

Tabs.NinjaLegends:Section({ Title = "传送", Icon = "map-pin" })
local ninjaTeleports = {
    { "出生点", CFrame.new(25.6655, 3.4228, 29.9199) },
    { "附魔岛", CFrame.new(51.172, 766.18, -138.44) },
    { "神秘岛", CFrame.new(171.97, 4047.38, 42.06) },
    { "太空岛", CFrame.new(148.83, 5657.18, 73.50) },
    { "冻土岛", CFrame.new(139.28, 9285.18, 77.36) },
    { "永恒岛", CFrame.new(149.34, 13680.03, 73.38) },
    { "沙暴岛", CFrame.new(133.37, 17686.32, 72.00) },
    { "雷暴岛", CFrame.new(143.19, 24070.02, 78.05) },
    { "远古炼狱岛", CFrame.new(141.27, 28256.29, 69.37) },
    { "午夜暗影岛", CFrame.new(132.74, 33206.98, 57.49) },
    { "神秘灵魂岛", CFrame.new(137.76, 39317.57, 61.06) },
    { "冬季奇迹岛", CFrame.new(137.27, 46010.55, 55.94) },
    { "黄金大师岛", CFrame.new(128.32, 52607.76, 56.69) },
    { "龙传奇岛", CFrame.new(146.35, 59594.67, 77.53) },
    { "赛博传奇岛", CFrame.new(137.33, 66669.16, 72.21) },
    { "天岚超能岛", CFrame.new(135.48, 70271.15, 57.02) },
    { "混沌传奇岛", CFrame.new(148.58, 74442.85, 69.31) },
    { "灵魂融合岛", CFrame.new(136.97, 79746.98, 58.54) },
    { "黑暗元素岛", CFrame.new(141.69, 83198.98, 72.73) },
    { "内心和平岛", CFrame.new(135.31, 87051.06, 66.78) },
    { "炽烈涡流岛", CFrame.new(135.08, 91246.07, 69.56) },
    { "35倍金币区域", CFrame.new(86.29, 91245.76, 120.54) },
    { "死亡宠物", CFrame.new(4593.21, 130.87, 1430.22) },
}
for _, teleport in ipairs(ninjaTeleports) do
    Tabs.NinjaLegends:Button({
        Title = "传送到" .. teleport[1],
        Callback = function()
            local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
            character:WaitForChild("HumanoidRootPart").CFrame = teleport[2]
        end
    })
end

--- 力量传奇 Tab ---
Tabs.StrengthLegends:Section({ Title = "自动", Icon = "toggle" })
Tabs.StrengthLegends:Toggle({
    Title = "自动比赛开关",
    Desc = "自动加入比赛",
    Callback = function(state)
        if state then
            startLoop("autoBrawl", function()
                game:GetService("ReplicatedStorage").Events.brawlEvent:FireServer("joinBrawl")
            end, 2)
        else
            stopLoop("autoBrawl")
        end
    end
})

local strengthAutoToggles = {
    { "自动举哑铃", "autoWeight", "Weight" },
    { "自动俯卧撑", "autoPushups", "Pushups" },
    { "自动仰卧起坐", "autoSitups", "Situps" },
    { "自动倒立身体", "autoHandstands", "Handstands" },
}
for _, item in ipairs(strengthAutoToggles) do
    Tabs.StrengthLegends:Toggle({
        Title = item[1],
        Desc = "自动执行 " .. item[3],
        Callback = function(state)
            if state then
                startLoop(item[2], function()
                    local part = Instance.new("Part", workspace)
                    part.Size = Vector3.new(500, 20, 530.1)
                    part.Position = Vector3.new(0, 100000, 133.15)
                    part.CanCollide = true
                    part.Anchored = true
                    part.Transparency = 1
                    
                    local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                    character:WaitForChild("HumanoidRootPart").CFrame = part.CFrame + Vector3.new(0, 50, 0)
                    local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(item[3])
                    if tool and tool:IsA("Tool") then
                        tool.Parent = character
                    end
                    game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
                    part:Destroy()
                end, 0) -- No wait needed in loop
            else
                stopLoop(item[2])
            end
        end
    })
end

Tabs.StrengthLegends:Toggle({
    Title = "自动锻炼",
    Desc = "自动循环所有锻炼",
    Callback = function(state)
        if state then
            startLoop("autoTrain", function()
                local part = Instance.new("Part", workspace)
                part.Size = Vector3.new(500, 20, 530.1)
                part.Position = Vector3.new(0, 100000, 133.15)
                part.CanCollide = true
                part.Anchored = true
                part.Transparency = 1
                
                local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                character:WaitForChild("HumanoidRootPart").CFrame = part.Cframe + Vector3.new(0, 50, 0)
                
                local exercises = {"Weight", "Pushups", "Situps", "Handstands"}
                for _, exerciseName in ipairs(exercises) do
                    local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(exerciseName)
                    if tool and tool:IsA("Tool") then
                        tool.Parent = character
                        game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
                    end
                end
                
                part:Destroy()
            end, 0)
        else
            stopLoop("autoTrain")
        end
    end
})

Tabs.StrengthLegends:Toggle({
    Title = "自动重生",
    Desc = "自动重生",
    Callback = function(state)
        if state then
            startLoop("autoRebirth", function()
                game:GetService("ReplicatedStorage").Events.rebirthRemote:InvokeServer("rebirthRequest")
            end, 0.5)
        else
            stopLoop("autoRebirth")
        end
    end
})

Tabs.StrengthLegends:Section({ Title = "自动打石头", Icon = "dumbbell" })

-- 辅助函数：执行打石头操作
local function punchRock(cframe)
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- 装备拳套
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.Name == "Punch" then
            humanoid:EquipTool(v)
            break
        end
    end

    -- 激活拳套
    task.wait(0.1)
    for _, h in pairs(character:GetChildren()) do
        if h:IsA("Tool") and h.Name == "Punch" then
            h:Activate()
        end
    end
end

-- 石头0
Tabs.StrengthLegends:Toggle({
    Title = "石头0",
    Desc = "自动打耐久度0的石头",
    Default = false,
    Callback = function(state)
        if state then
            startLoop("RK0", function()
                punchRock(CFrame.new(7.60643005, 4.02632904, 2104.54004, -0.23040159, -8.53662385e-08, -0.973095655, -4.68743764e-08, 1, -7.66279342e-08, 0.973095655, 2.79580536e-08, -0.23040159))
            end, 0.5)
        else
            stopLoop("RK0")
            -- 停止时取消装备工具
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
})

-- 石头10
Tabs.StrengthLegends:Toggle({
    Title = "石头10",
    Desc = "需要耐久度≥10",
    Default = false,
    Callback = function(state)
        if state then
            if game.Players.LocalPlayer.Durability.Value >= 10 then
                startLoop("RK10", function()
                    punchRock(CFrame.new(-157.680908, 3.72453046, 434.871185, 0.923298299, -1.81774684e-09, -0.384083599, 3.45247031e-09, 1, 3.56670582e-09, 0.384083599, -4.61917082e-09, 0.923298299))
                end, 0.5)
            else
                Tabs.StrengthLegends:GetToggle("石头10"):Set(false)
            end
        else
            stopLoop("RK10")
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
})

-- 石头100
Tabs.StrengthLegends:Toggle({
    Title = "石头100",
    Desc = "需要耐久度≥100",
    Default = false,
    Callback = function(state)
        if state then
            if game.Players.LocalPlayer.Durability.Value >= 100 then
                startLoop("RK100", function()
                    punchRock(CFrame.new(162.233673, 3.66615629, -164.686783, -0.921312928, -1.80826774e-07, -0.38882193, -9.13036544e-08, 1, -2.48719346e-07, 0.38882193, -1.93647494e-07, -0.921312928))
                end, 0.5)
            else
                Tabs.StrengthLegends:GetToggle("石头100"):Set(false)
            end
        else
            stopLoop("RK100")
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
})

-- 石头5000
Tabs.StrengthLegends:Toggle({
    Title = "石头5000",
    Desc = "需要耐久度≥5000",
    Default = false,
    Callback = function(state)
        if state then
            if game.Players.LocalPlayer.Durability.Value >= 5000 then
                startLoop("RK5000", function()
                    punchRock(CFrame.new(329.831482, 3.66450214, -618.48407, -0.806075394, -8.67358096e-08, 0.591812849, -1.05715522e-07, 1, 2.57029176e-09, -0.591812849, -6.04919563e-08, -0.806075394))
                end, 0.5)
            else
                Tabs.StrengthLegends:GetToggle("石头5000"):Set(false)
            end
        else
            stopLoop("RK5000")
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
})

-- 石头150000
Tabs.StrengthLegends:Toggle({
    Title = "石头150000",
    Desc = "需要耐久度≥150000",
    Default = false,
    Callback = function(state)
        if state then
            if game.Players.LocalPlayer.Durability.Value >= 150000 then
                startLoop("RK150000", function()
                    punchRock(CFrame.new(-2566.78076, 3.97019577, -277.503235, -0.923934579, -4.11600105e-08, -0.382550538, -3.38838042e-08, 1, -2.57576183e-08, 0.382550538, -1.08360858e-08, -0.923934579))
                end, 0.5)
            else
                Tabs.StrengthLegends:GetToggle("石头150000"):Set(false)
            end
        else
            stopLoop("RK150000")
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
})

-- 石头400000
Tabs.StrengthLegends:Toggle({
    Title = "石头400000",
    Desc = "需要耐久度≥400000",
    Default = false,
    Callback = function(state)
        if state then
            if game.Players.LocalPlayer.Durability.Value >= 400000 then
                startLoop("RK400000", function()
                    punchRock(CFrame.new(2155.61743, 3.79830337, 1227.06482, -0.551303148, -9.16796949e-09, -0.834304988, -5.61318245e-08, 1, 2.61027839e-08, 0.834304988, 6.12216127e-08, -0.551303148))
                end, 0.5)
            else
                Tabs.StrengthLegends:GetToggle("石头400000"):Set(false)
            end
        else
            stopLoop("RK400000")
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
})

-- 石头750000
Tabs.StrengthLegends:Toggle({
    Title = "石头750000",
    Desc = "需要耐久度≥750000",
    Default = false,
    Callback = function(state)
        if state then
            if game.Players.LocalPlayer.Durability.Value >= 750000 then
                startLoop("RK750000", function()
                    punchRock(CFrame.new(-7285.6499, 3.66624784, -1228.27417, 0.857643783, -1.58175091e-08, -0.514244199, -1.22581563e-08, 1, -5.12025977e-08, 0.514244199, 5.02172774e-08, 0.857643783))
                end, 0.5)
            else
                Tabs.StrengthLegends:GetToggle("石头750000"):Set(false)
            end
        else
            stopLoop("RK750000")
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
})

-- 石头100万
Tabs.StrengthLegends:Toggle({
    Title = "石头100万",
    Desc = "需要耐久度≥1000000",
    Default = false,
    Callback = function(state)
        if state then
            if game.Players.LocalPlayer.Durability.Value >= 1000000 then
                startLoop("RK1M", function()
                    punchRock(CFrame.new(4160.87109, 987.829102, -4136.64502, -0.893115997, 1.25481356e-05, 0.44982639, 5.02490684e-06, 1, -1.79187136e-05, -0.44982639, -1.37431543e-05, -0.893115997))
                end, 0.5)
            else
                Tabs.StrengthLegends:GetToggle("石头100万"):Set(false)
            end
        else
            stopLoop("RK1M")
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
})

-- 石头500万
Tabs.StrengthLegends:Toggle({
    Title = "石头500万",
    Desc = "需要耐久度≥5000000",
    Default = false,
    Callback = function(state)
        if state then
            if game.Players.LocalPlayer.Durability.Value >= 5000000 then
                startLoop("RK5M", function()
                    punchRock(CFrame.new(-8957.54395, 5.53625107, -6126.90186, -0.803919137, 6.6065212e-08, 0.594738603, -8.93136143e-09, 1, -1.23155459e-07, -0.594738603, -1.04318865e-07, -0.803919137))
                end, 0.5)
            else
                Tabs.StrengthLegends:GetToggle("石头500万"):Set(false)
            end
        else
            stopLoop("RK5M")
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:UnequipTools()
            end
        end
    end
})

Tabs.StrengthLegends:Section({ Title = "传送", Icon = "map-pin" })
local strengthTeleports = {
    { "出生点", CFrame.new(7, 3, 108) },
    { "冰霜健身房", CFrame.new(-2543, 13, -410) },
    { "神话健身房", CFrame.new(2177, 13, 1070) },
    { "永恒健身房", CFrame.new(-6686, 13, -1284) },
    { "传说健身房", CFrame.new(4676, 997, -3915) },
    { "肌肉之王健身房", CFrame.new(-8554, 22, -5642) },
    { "安全岛", CFrame.new(-39, 10, 1838) },
    { "幸运抽奖区域", CFrame.new(-2606, -2, 5753) },
}
for _, teleport in ipairs(strengthTeleports) do
    Tabs.StrengthLegends:Button({
        Title = "传送到" .. teleport[1],
        Callback = function()
            local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
            character:WaitForChild("HumanoidRootPart").CFrame = teleport[2]
        end
    })
end

Tabs.Misc:Paragraph({
    Title = "无",
    Desc = "这里存放一些不属于特定游戏的功能。"
})
Tabs.Misc:Code({
    Title = "感谢游玩",
    Code = "QQ号:3395858053"
})