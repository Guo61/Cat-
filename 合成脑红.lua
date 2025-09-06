local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Guo61/Cat-/refs/heads/main/main.lua"))()

local Confirmed = false

WindUI:Popup({
    Title = "Cat脚盆 v1.20",
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    Content = "By:Ccat\nQQ:3395858053 合成大鸡巴",
    Buttons = {
        {
            Title = "进入脚盆。",
            Icon = "arrow-right",
            Callback = function() Confirmed = true end,
            Variant = "Primary",
        }
    }
})

repeat task.wait() until Confirmed

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
    Title = "v1.20",
    Color = Color3.fromHex("#30ff6a")
})
Window:Tag({
    Title = "合成大鸡巴", 
    Color = Color3.fromHex("#315dff")
})
local TimeTag = Window:Tag({
    Title = "正在开发更多服务器",
    Color = Color3.fromHex("#000000")
})

local Tabs = {
    Home = Window:Tab({ Title = "主页", Icon = "crown" }),
    NaturalDisastersTab = Window:Tab({ Title = "主要功能", Icon = "cloud-rain" }),
    Misc = Window:Tab({ Title = "杂项", Icon = "settings" }),
}

Window:SelectTab(1)

local autoLoops = {}

local function startLoop(name, callback, delay)
    if autoLoops[name] then return end
    autoLoops[name] = true
    task.spawn(function()
        while autoLoops[name] do
            pcall(callback)
            task.wait(delay)
        end
    end)
end

local function stopLoop(name)
    autoLoops[name] = false
end

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

Tabs.Home:Toggle({
    Title = "显示FPS",
    Desc = "在屏幕上显示当前FPS",
    Callback = function(state)
        local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        local FpsGui = playerGui:FindFirstChild("FPSGui")
        if state then
            if not FpsGui then
                FpsGui = Instance.new("ScreenGui")
                FpsGui.Name = "FPSGui"
                FpsGui.ResetOnSpawn = false
                FpsGui.Parent = playerGui
                
                local FpsXS = Instance.new("TextLabel")
                FpsXS.Name = "FpsXS"
                FpsXS.Size = UDim2.new(0, 100, 0, 50)
                FpsXS.Position = UDim2.new(0, 10, 0, 10)
                FpsXS.BackgroundTransparency = 1
                FpsXS.Font = Enum.Font.SourceSansBold
                FpsXS.Text = "FPS: 0"
                FpsXS.TextSize = 20
                FpsXS.TextColor3 = Color3.new(1, 1, 1)
                FpsXS.Parent = FpsGui
                
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

Tabs.Home:Toggle({
    Title = "显示范围",
    Desc = "显示玩家范围",
    Callback = function(state)
        local highlightTemplate = Instance.new("Highlight")
        highlightTemplate.OutlineTransparency = 0
        highlightTemplate.FillTransparency = 0.7
        highlightTemplate.FillColor = Color3.fromHex("#0000FF")

        local function applyHighlight(character)
            if not character:FindFirstChild("WindUI_RangeHighlight") then
                local clone = highlightTemplate:Clone()
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
                if player ~= game.Players.LocalPlayer and player.Character then
                    applyHighlight(player.Character)
                end
            end
            local charAddedConn = game.Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    task.wait(1)
                    applyHighlight(character)
                end)
            end)
            local playerRemovingConn = game.Players.PlayerRemoving:Connect(function(player)
                if player.Character then
                    removeHighlight(player.Character)
                end
            end)
            -- Store connections to disconnect later if needed
        else
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character then
                    removeHighlight(player.Character)
                end
            end
        end
    end
})

Tabs.Home:Button({
    Title = "半隐身",
    Desc = "从GitHub加载并执行隐身脚本",
    Callback = function()
        pcall(function() 
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Invisible-35376"))() 
        end)
    end
})

Tabs.Home:Button({
    Title = "玩家入退提示",
    Desc = "从GitHub加载并执行提示脚本",
    Callback = function()
        pcall(function() 
            loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))() 
        end)
    end
})

Tabs.Home:Button({
    Title = "甩飞",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zqyDSUWX"))()
    end
})

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
            if antiWalkFlingConn then 
                antiWalkFlingConn:Disconnect() 
                antiWalkFlingConn = nil
            end
        end
    end
})

local function setPlayerHealth(healthValue)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.Health = healthValue
    
    WindUI:Notify({
        Title = "血量设置",
        Content = "血量已设置为: " .. healthValue,
        Duration = 3
    })
end

Tabs.Home:Slider({
    Title = "设置血量",
    Desc = "可输入",
    Value = { Min = 0, Max = 1000, Default = 100 },
    Callback = function(val)
        setPlayerHealth(val)
    end
})

Tabs.Home:Button({
    Title = "满血",
    Desc = "将血量设置为最大值",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        setPlayerHealth(humanoid.MaxHealth)
    end
})

Tabs.Home:Button({
    Title = "半血",
    Desc = "将血量设置为一半",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        setPlayerHealth(humanoid.MaxHealth / 2)
    end
})

local godModeEnabled = false
local originalHealth
local godModeConnection

Tabs.Home:Toggle({
    Title = "无敌模式",
    Desc = "开启后血量不会减少",
    Default = false,
    Callback = function(state)
        godModeEnabled = state
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        
        if state then
            originalHealth = humanoid.Health
            godModeConnection = humanoid.HealthChanged:Connect(function(newHealth)
                if godModeEnabled and newHealth < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
            humanoid.Health = humanoid.MaxHealth
            WindUI:Notify({
                Title = "无敌模式",
                Content = "无敌模式已开启",
                Duration = 3
            })
        else
            if godModeConnection then
                godModeConnection:Disconnect()
                godModeConnection = nil
            end
            if originalHealth then
                humanoid.Health = originalHealth
            end
            WindUI:Notify({
                Title = "无敌模式",
                Content = "无敌模式已关闭",
                Duration = 3
            })
        end
    end
})

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
            local mass = rootPart.AssemblyMass
            personalGravity.Force = Vector3.new(0, mass * (workspace.Gravity - val), 0)
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

local playersDropdown = Tabs.Home:Dropdown({
    Title = "选择要传送的玩家",
    Values = getPlayerNames(),
})

local function refreshPlayerDropdown()
    if not playersDropdown then return end
    local currentValues = playersDropdown:GetValues() or {}
    local newValues = getPlayerNames()
    
    local currentSet = {}
    for _, name in ipairs(currentValues) do
        currentSet[name] = true
    end
    
    for _, name in ipairs(newValues) do
        if not currentSet[name] then
            playersDropdown:AddValue(name)
        end
    end
    
    for _, name in ipairs(currentValues) do
        if not table.find(newValues, name) then
            playersDropdown:RemoveValue(name)
        end
    end
end

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

game.Players.PlayerAdded:Connect(refreshPlayerDropdown)
game.Players.PlayerRemoving:Connect(refreshPlayerDropdown)

Tabs.Home:Button({
    Title = "飞行",
    Desc = "从GitHub加载并执行飞行脚本",
    Callback = function()
        pcall(function()
            local response = game:HttpGet("https://raw.githubusercontent.com/Guo61/Cat-/refs/heads/main/%E9%A3%9E%E8%A1%8C%E8%84%9A%E6%9C%AC.lua", true)
            if response and #response > 100 then
                loadstring(response)()
            else
                WindUI:Notify({Title = "飞行", Content = "脚本加载失败或内容为空", Duration = 3})
            end
        end)
    end
})

Tabs.Home:Button({
    Title = "无限跳",
    Desc = "开启后无法关闭",
    Callback = function()
        pcall(function() 
            loadstring(game:HttpGet("https://pastebin.com/raw/V5PQy3y0", true))() 
        end)
    end
})

Tabs.Home:Button({
    Title = "自瞄",
    Desc = "宙斯自瞄",
    Callback = function()
        pcall(function() 
            loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/Arceus%20Aimbot.lua"))() 
        end)
    end
})

local trackData = { enabled = false, bulletConns = {}, workspaceConn = nil }
Tabs.Home:Toggle({
    Title = "子弹追踪",
    Default = false,
    Callback = function(state)
        trackData.enabled = state
        if not state then
            if trackData.workspaceConn then trackData.workspaceConn:Disconnect() end
            for _, conn in pairs(trackData.bulletConns) do conn:Disconnect() end
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
                    local headlight = Instance.new("PointLight")
                    headlight.Brightness = 1
                    headlight.Range = 60
                    headlight.Parent = humanoidRootPart
                    nightVisionData.pointLight = headlight
                end
            end)
        else
            if nightVisionData.originalAmbient then lighting.Ambient = nightVisionData.originalAmbient end
            if nightVisionData.originalBrightness then lighting.Brightness = nightVisionData.originalBrightness end
            if nightVisionData.originalFogEnd then lighting.FogEnd = nightVisionData.originalFogEnd end
            if nightVisionData.changedConnection then nightVisionData.changedConnection:Disconnect() end
            if nightVisionData.pointLight then nightVisionData.pointLight:Destroy() end
            nightVisionData = {}
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
            if noclipConn then 
                noclipConn:Disconnect() 
                noclipConn = nil
            end
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

local espEnabled = false
local espConnections = {}
local espHighlights = {}
local espNameTags = {}

local function createESP(player)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "WindUI_ESP"
    highlight.Adornee = char
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
    espHighlights[player] = highlight

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
    if espHighlights[player] then
        espHighlights[player]:Destroy()
        espHighlights[player] = nil
    end
    if espNameTags[player] then
        espNameTags[player]:Destroy()
        espNameTags[player] = nil
    end
end

local function toggleESP(state)
    espEnabled = state
    if state then
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                pcall(createESP, player)
            end
        end

        espConnections.playerAdded = game.Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Wait()
            pcall(createESP, player)
        end)
        espConnections.playerRemoving = game.Players.PlayerRemoving:Connect(function(player)
            removeESP(player)
        end)
    else
        if espConnections.playerAdded then espConnections.playerAdded:Disconnect() end
        if espConnections.playerRemoving then espConnections.playerRemoving:Disconnect() end
        for player in pairs(espHighlights) do
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

Tabs.NaturalDisastersTab:Section({ Title = "秒孵化", Icon = "toggle" })

Tabs.NaturalDisastersTab:Button({
    Title = "孵化鸡蛋",
    Desc = "1号位",
    Callback = function()
        local args = { "BuildSlot1" }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Packages")
            :WaitForChild("Knit")
            :WaitForChild("Services")
            :WaitForChild("BrainrotCareService")
            :WaitForChild("RF")
            :WaitForChild("FinishedAnimation")
            :InvokeServer(unpack(args))
    end
})
  
Tabs.NaturalDisastersTab:Button({
    Title = "2号位",
    Callback = function()
        local args = { "BuildSlot2" }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Packages")
            :WaitForChild("Knit")
            :WaitForChild("Services")
            :WaitForChild("BrainrotCareService")
            :WaitForChild("RF")
            :WaitForChild("FinishedAnimation")
            :InvokeServer(unpack(args))
    end
})

local autoBuyEnabled = false

local section = Window:Section({ Title = "自动购买功能" })

local statusLabel = section:Label({
    Title = "当前状态: 已关闭",
    Description = "自动购买 Simple Egg"
})

section:Toggle({
    Title = "自动购买鸡蛋",
    Description = "检测到鸡蛋生成时自动购买并删除装备",
    Default = false,
    Callback = function(state)
        autoBuyEnabled = state
        if autoBuyEnabled then
            print("⚡ 自动购买鸡蛋功能: 已开启")
            if section and section.UpdateToggle then
                section:UpdateToggle("自动购买鸡蛋", { Title = "关闭自动购买 Simple Egg" })
            end
            if statusLabel and statusLabel.Update then
                statusLabel:Update({ Title = "当前状态: 已开启" })
            end
        else
            print("⚡ 自动购买鸡蛋功能: 已关闭")
            if section and section.UpdateToggle then
                section:UpdateToggle("自动购买鸡蛋", { Title = "开启自动购买 Simple Egg" })
            end
            if statusLabel and statusLabel.Update then
                statusLabel:Update({ Title = "当前状态: 已关闭" })
            end
        end
    end
})

game:GetService("ReplicatedStorage").ChildAdded:Connect(function(child)
    if autoBuyEnabled and child.Name == "Simple Egg|Normal" then
        print("📦 检测到目标鸡蛋:", child.Name)
        
        game:GetService("ReplicatedStorage").Packages.Knit.Services.EquipmentService.RF.EquipItem:InvokeServer(
            "Simple Egg|Normal",
            "17571667613808174333"
        )
        print("✅ 已装备鸡蛋")

        -- 购买
        game:GetService("ReplicatedStorage").Packages.Knit.Services.EggService.RF.BuyEgg:InvokeServer(
            "67db913e-1615-427b-a4b8-6da654c27b71"
        )
        print("✅ 已购买鸡蛋")

        local player = game.Players.LocalPlayer
        local backpack = player:WaitForChild("Backpack")
        for _, item in ipairs(backpack:GetChildren()) do
            if item.Name == "Simple Egg|Normal" then
                item:Destroy()
                print("🗑️ 已删除装备鸡蛋")
            end
        end
    end
end)

Tabs.NaturalDisastersTab:Toggle({
    Title = "自动买黑客",
    Callback = function()
        local args = {
    "8301050e-9639-40c6-908b-457431537bfa"
}

local MAX_RETRIES = 3
local retryCount = 0

local function attemptPurchase()
    local buySuccess, buyResult = pcall(function()
        return game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("EggService"):WaitForChild("RF"):WaitForChild("BuyEgg"):InvokeServer(unpack(args))
    end)
    
    if buySuccess then
        print("购买成功！")
        return true
    else
        warn("购买尝试失败:", buyResult)
        return false
    end
end

local function buyGoldenHackerEgg()
    print("检测Hacker Egg...")
    
    local function checkAndBuy(model)
        print("已检测到Hacker Egg")
        
        local success = pcall(function()
            model:WaitForChild("HumanoidRootPart", 5)
        end)
        
        if success then
            print("模型加载完成，尝试购买...")
            wait(0.3) -- 短暂延迟
            
            for i = 1, MAX_RETRIES do
                print("购买尝试 " .. i .. "/" .. MAX_RETRIES)
                if attemptPurchase() then
                    return true
                end
                wait(1) -- 等待1秒后重试
            end
        else
            warn("模型加载失败")
        end
        return false
    end
    
    local existingModel = game.Workspace:FindFirstChild("Golden Hacker Egg")
    if existingModel then
        return checkAndBuy(existingModel)
    end
    
    local connection
    local purchaseMade = false
    
    connection = game.Workspace.ChildAdded:Connect(function(child)
        if not purchaseMade and child.Name == "Hacker Egg" then
            purchaseMade = checkAndBuy(child)
            if connection then
                connection:Disconnect()
            end
        end
    end)
    
    delay(30, function()
        if connection then
            connection:Disconnect()
            if not purchaseMade then
                print("检测超时，未找到目标模型")
            end
        end
    end)
end

pcall(buyGoldenHackerEgg)
    end
})

Tabs.Misc:Button({
    Title = "复制作者QQ",
    Callback = function()
        setclipboard("3395858053")
        WindUI:Notify({Title = "QQ群号", Content = "群号已复制到剪贴板", Duration = 3})
    end
})

Tabs.Misc:Button({
    Title = "脚本信息",
    Desc = "显示脚本相关信息",
    Callback = function()
        WindUI:Notify({
            Title = "脚本信息",
            Content = "Cat Hub v1.15\n作者: Ccat\nQQ:3395858053",
            Duration = 10
        })
    end
})

Tabs.Misc:Button({
    Title = "检查更新",
    Desc = "检查脚本是否有更新",
    Callback = function()
        WindUI:Notify({
            Title = "更新检查",
            Content = "当前版本: v1.15\n已是最新版本",
            Duration = 5
        })
    end
})

WindUI:Notify({
    Title = "Cat Hub 已加载",
    Content = "欢迎使用合成大鸡巴 v1.20",
    Duration = 5
})