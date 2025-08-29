local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Guo61/Cat-/refs/heads/main/main.lua"))()

local Confirmed = false

WindUI:Popup({
    Title = "Cat脚盆 v1.10",
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    Content = "By:Ccat\nQQ群:1061490197 欢迎使用99夜",
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
    Main = Window:Tab({ Title = "主要功能", Icon = "zap" }),
    Ninja = Window:Tab({ Title = "传送", Icon = "user" }),
    ESP = Window:Tab({ Title = "透视", Icon = "dumbbell" }),
    Misc = Window:Tab({ Title = "其他", Icon = "settings" }),
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

Tabs.Misc:Code({
    Title = "感谢游玩",
    Code = "QQ号:3395858053"
})

-- ====================== 99夜 核心功能集成 ======================

-- 核心变量和常量
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
    InstantInteract = false,
    ChildrenESP = false,
    ChestESP = false,
    EnemyESP = false
}
local BONFIRE_POSITION = Vector3.new(0.189, 7.831, -0.341) -- 固定篝火位置

-- 1. 获取客户端模块与进食远程函数
local function GetClientModule()
    local ClientModule = require(LP:WaitForChild("PlayerScripts"):WaitForChild("Client"))
    local EatRemote = ClientModule.Events.RequestConsumeItem
    return ClientModule, EatRemote
end

-- 2. 查找地图物品（支持传送/ESP/召唤）
local function FindMapItems(itemName)
    local found = {}
    local itemFolders = {Workspace:FindFirstChild("Items"), Workspace:FindFirstChild("MapItems"), Workspace:FindFirstChild("Trees"), Workspace:FindFirstChild("Characters")}
    for _, folder in ipairs(itemFolders) do
        if folder then
            for _, item in ipairs(folder:GetDescendants()) do
                if item.Name == itemName and (item:IsA("Model") or item:IsA("Part")) then
                    local part = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart") or item
                    if part then table.insert(found, {model = item, part = part}) end
                end
            end
        end
    end
    return found
end

-- 3. 自动进食逻辑 (在后台循环运行)
local function AutoEat()
    local _, EatRemote = GetClientModule()
    local Inventory = LP:FindFirstChild("Inventory")
    if not Inventory or not EatRemote then return end

    -- 优先吃浆果/胡萝卜（恢复饥饿）
    for _, foodName in ipairs({"Berry", "Carrot"}) do
        local food = Inventory:FindFirstChild(foodName)
        if food then
            -- 确保 food 能够被移动
            food.Parent = ReplicatedStorage.TempStorage
            pcall(function() EatRemote:InvokeServer(food) end)
            WindUI:Notify({Title = "99夜", Content = "已吃"..foodName, Duration = 3})
            return
        end
    end
end

-- 4. 杀戮光环逻辑（自动攻击范围内敌人） (在后台循环运行)
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
        if EnemyRoot and EnemyHumanoid and EnemyHumanoid.Health > 0 and Enemy ~= Character then
            local Dist = (Character.HumanoidRootPart.Position - EnemyRoot.Position).Magnitude
            if Dist <= 100 then
                ReplicatedStorage.RemoteEvents.ToolDamageObject:InvokeServer(Enemy, Tool, true, Character.HumanoidRootPart.CFrame)
            end
        end
    end
end

-- 5. 自动砍树逻辑 (在后台循环运行)
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

-- 6. ESP生成/清除函数
local espObjects = {}
local function clearAllESP()
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    espObjects = {}
end

local function toggleBatchESP(typeKey, targetNames, color)
    Features[typeKey] = not Features[typeKey]
    if Features[typeKey] then
        for _, name in ipairs(targetNames) do
            local items = FindMapItems(name)
            for _, item in ipairs(items) do
                local billboard = Instance.new("BillboardGui")
                billboard.Adornee = item.part
                billboard.Name = "99ESP"
                billboard.Size = UDim2.new(0, 100, 0, 30)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.AlwaysOnTop = true
                billboard.MaxDistance = 500

                local textLabel = Instance.new("TextLabel")
                textLabel.Text = name
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.TextColor3 = color
                textLabel.BackgroundTransparency = 1
                textLabel.Font = Enum.Font.SourceSans
                textLabel.TextSize = 14
                textLabel.TextStrokeTransparency = 0.5
                textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                textLabel.Parent = billboard

                billboard.Parent = item.part
                table.insert(espObjects, billboard)
            end
        end
        WindUI:Notify({Title = "99夜", Content = "开启 "..typeKey, Duration = 3})
    else
        for _, obj in pairs(espObjects) do
            if obj.Name == "99ESP" then
                obj:Destroy()
            end
        end
        espObjects = {}
        WindUI:Notify({Title = "99夜", Content = "关闭 "..typeKey, Duration = 3})
    end
end

-- 7. 传送功能
local function TeleportTo(targetType, targetName)
    local CharacterRoot = Character:FindFirstChild("HumanoidRootPart")
    if not CharacterRoot then return end

    if targetType == "Bonfire" then
        CharacterRoot.CFrame = CFrame.new(BONFIRE_POSITION)
        WindUI:Notify({Title = "99夜", Content = "已传送到篝火", Duration = 3})
        return
    end

    local Items = FindMapItems(targetName)
    if #Items == 0 then
        WindUI:Notify({Title = "99夜", Content = "未找到 "..targetName, Duration = 3})
        return
    end
    
    local ClosestItem = Items[1]
    local MinDist = (CharacterRoot.Position - Items[1].part.Position).Magnitude
    for _, item in ipairs(Items) do
        local Dist = (CharacterRoot.Position - item.part.Position).Magnitude
        if Dist < MinDist then
            MinDist = Dist
            ClosestItem = item
        end
    end
    CharacterRoot.CFrame = CFrame.new(ClosestItem.part.Position + Vector3.new(0, 5, 0))
    WindUI:Notify({Title = "99夜", Content = "已传送到 "..targetName, Duration = 3})
end

-- 8. 紧急关闭所有功能
local function emergencyShutdown()
    for name, loop in pairs(autoLoops) do
        stopLoop(name)
    end
    if InstantInteractConnection then
        InstantInteractConnection:Disconnect()
        InstantInteractConnection = nil
    end
    clearAllESP()
    WindUI:Notify({Title = "99夜", Content = "所有99夜功能已关闭", Duration = 5})
end

-- ====================== 集成到 WindUI ======================

-- 主要功能 (Main)
Tabs.Main:Toggle({
    Title = "杀戮光环（自动攻击敌人）",
    Desc = "需装备武器，自动攻击100米内敌人",
    Callback = function(state)
        Features.KillAura = state
        if state then
            startLoop("KillAura", KillAura, 0.5)
        else
            stopLoop("KillAura")
        end
    end
})

Tabs.Main:Toggle({
    Title = "自动砍树（需装备斧头）",
    Desc = "需装备斧头，自动砍伐100米内树木",
    Callback = function(state)
        Features.AutoChop = state
        if state then
            startLoop("AutoChop", AutoChop, 0.5)
        else
            stopLoop("AutoChop")
        end
    end
})

Tabs.Main:Toggle({
    Title = "自动进食（浆果/胡萝卜）",
    Desc = "自动吃掉背包里的浆果和胡萝卜",
    Callback = function(state)
        Features.AutoEat = state
        if state then
            startLoop("AutoEat", AutoEat, 5)
        else
            stopLoop("AutoEat")
        end
    end
})

local InstantInteractConnection = nil
Tabs.Main:Toggle({
    Title = "瞬间互动（无需长按）",
    Desc = "取消需要长按的交互，例如砍树、收集",
    Callback = function(state)
        Features.InstantInteract = state
        if state then
            if not InstantInteractConnection then
                InstantInteractConnection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                    prompt.HoldDuration = 0
                end)
            end
        else
            if InstantInteractConnection then
                InstantInteractConnection:Disconnect()
                InstantInteractConnection = nil
            end
        end
    end
})

-- 透视功能 (ESP)
Tabs.ESP:Button({
    Title = "孩子ESP 开关",
    Desc = "显示走失的孩子和恐龙孩子",
    Callback = function()
        toggleBatchESP("ChildrenESP", {"Lost Child", "Dino Kid"}, Color3.fromRGB(0, 255, 255))
    end
})
Tabs.ESP:Button({
    Title = "宝箱ESP 开关",
    Desc = "显示普通和外星宝箱",
    Callback = function()
        toggleBatchESP("ChestESP", {"Chest", "Alien Chest"}, Color3.fromRGB(255, 215, 0))
    end
})
Tabs.ESP:Button({
    Title = "敌人ESP 开关",
    Desc = "显示十字弓邪教徒、熊和狼",
    Callback = function()
        toggleBatchESP("EnemyESP", {"Crossbow Cultist", "Bear", "Wolf"}, Color3.fromRGB(255, 0, 0))
    end
})
Tabs.ESP:Button({
    Title = "清除所有ESP",
    Desc = "关闭所有99夜透视功能",
    Callback = clearAllESP
})


-- 传送功能 (Ninja)
Tabs.Ninja:Button({
    Title = "传送到篝火",
    Desc = "传送到复活点",
    Callback = function()
        TeleportTo("Bonfire")
    end
})
Tabs.Ninja:Button({
    Title = "传送到最近木头",
    Desc = "传送到最近的木头资源",
    Callback = function()
        TeleportTo("Item", "Log")
    end
})
Tabs.Ninja:Button({
    Title = "传送到最近宝箱",
    Desc = "传送到最近的普通宝箱",
    Callback = function()
        TeleportTo("Item", "Chest")
    end
})
Tabs.Ninja:Button({
    Title = "传送到最近外星宝箱",
    Desc = "传送到最近的外星宝箱",
    Callback = function()
        TeleportTo("Item", "Alien Chest")
    end
})

-- 其他功能 (Misc)
Tabs.Misc:Button({
    Title = "召唤木头到身边",
    Desc = "将地图上所有的木头传送到你身边",
    Callback = function()
        local Woods = FindMapItems("Log")
        if #Woods == 0 then
            WindUI:Notify({Title = "99夜", Content = "未找到木头", Duration = 3})
            return
        end
        local CharPos = Character.HumanoidRootPart.Position
        
        for i, wood in ipairs(Woods) do
            local Angle = (2 * math.pi / #Woods) * i
            local TargetPos = CharPos + Vector3.new(math.cos(Angle) * 5, 0, math.sin(Angle) * 5)
            wood.part.CFrame = CFrame.new(TargetPos)
        end
        WindUI:Notify({Title = "99夜", Content = "已召唤"..#Woods.."个木头", Duration = 3})
    end
})

Tabs.Misc:Button({
    Title = "紧急关闭所有99夜功能",
    Desc = "立即关闭所有自动功能和透视",
    Callback = emergencyShutdown
})