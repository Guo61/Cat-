--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

-- Create Main Window
local Window = Library:Window({
    Title = "Cat Hub",
    Desc = "防挂机已开启",
    Icon = "skull",
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 350)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "打开/关闭"
    }
})

-- Sidebar Vertical Separator
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(0, 140, 0, 0) -- adjust if needed
SidebarLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Name = "SidebarLine"
SidebarLine.Parent = game:GetService("CoreGui") -- Or Window.Gui if accessible

-- Tab
local Tab = Window:Tab({Title = "主页", Icon = "star"}) do

    -- Section
    Tab:Section({Title = "By Ccat\n脚本免费 请勿倒卖"})

-- 假设 Tab 是已经创建好的选项卡对象
Tab:Slider({
    Title = "设置速度",
    Desc = "可输入",
    Min = 0,
    Max = 520,
    Rounding = 0,
    Value = 25,
    Callback = function(val)
        -- 获取本地玩家的人物
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then
            character = player.CharacterAdded:Wait() -- 等待人物加载
        end
        -- 获取人类oid对象，用于设置行走速度
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- 将滑块的值设置为人类oid的行走速度
            humanoid.WalkSpeed = val
            print("人物行走速度已设置为:", val)
        else
            print("未找到人类oid对象，无法设置速度")
        end
    end
})

        Tab:Slider({
Title = "设置跳跃高度",
Desc = "可输入设置",
Min = 0,
Max = 200, -- 跳跃力量的合理范围，可根据需要调整
Rounding = 0,
Value = 50, -- 初始跳跃力量，Roblox 默认一般是 50 左右
Callback = function(val)
    -- 获取本地玩家的人物
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then
        character = player.CharacterAdded:Wait() -- 等待人物加载
    end
    -- 获取人类oid对象
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- 设置人类oid的跳跃力量，从而改变跳跃高度
        humanoid.JumpPower = val
        print("人物跳跃力量已设置为:", val)
    else
        print("未找到人类oid对象，无法设置跳跃高度")
    end
end
})
-- 添加飞行脚本控制按钮
Tab:Button({
    Title = "飞行",
    Description = "从GitHub加载并执行飞行脚本",
    Callback = function()
        -- 从指定URL加载并执行飞行脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Guo61/Cat-/refs/heads/main/%E9%A3%9E%E8%A1%8C%E8%84%9A%E6%9C%AC.lua"))()
        print("飞行脚本已加载并执行")
    end
})
-- 1. 补充核心服务与玩家对象（原代码依赖项）
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer  -- 确保获取本地玩家

-- 2. 原有全局变量（保留）
local airJumpConn = nil
local airJumpCooldown = false

-- 3. 原有启用踏空跳函数（核心逻辑不变）
local function enableAirJump()
	if airJumpConn then airJumpConn:Disconnect() end
	airJumpConn = UIS.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard 
			and input.KeyCode == Enum.KeyCode.Space 
			and not airJumpCooldown 
		then
			local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
			if not hrp or not humanoid then return end
			if humanoid.FloorMaterial == Enum.Material.Air then
				humanoid.Jump = true
				airJumpCooldown = true
				task.delay(0.5, function() airJumpCooldown = false end)
			end
		end
	end)
end

-- 4. 原有禁用踏空跳函数（核心逻辑不变）
local function disableAirJump()
	if airJumpConn then
		airJumpConn:Disconnect()
		airJumpConn = nil
	end
end

-- 5. 核心：直接绑定Tab:Toggle（无MainTab，简化结构）
Tab:Toggle({
    Title = "踏空跳",  -- Toggle开关显示名称
    Default = false,      -- 默认关闭状态
    Callback = function(isToggledOn)
        if isToggledOn then
            -- 开启逻辑：执行启用函数+提示
            enableAirJump()
            print("踏空跳已开启（空中按空格，0.5秒冷却）")
        else
            -- 关闭逻辑：执行禁用函数+重置冷却
            disableAirJump()
            airJumpCooldown = false  -- 避免下次开启残留冷却
            print("踏空跳已关闭")
        end
    end
})

-- 6. 角色重生适配（补充稳定性，避免重生后功能失效）
player.CharacterAdded:Connect(function()
    if airJumpConn then  -- 若已开启，重生后重新绑定监听
        enableAirJump()
    end
end)

Tab:Toggle({
    Title = "子弹追踪",
    Default = false,
    Callback = function(state)
        -- 局部存储追踪核心数据（避免全局冲突）
        local trackData = {
            enabled = state,
            workspaceConn = nil,  -- 监听子弹生成的连接
            bulletConns = {},     -- 存储单个子弹的追踪连接（用于关闭清理）
            maxDist = 70,         -- 子弹最大追踪距离
            force = 14,           -- 追踪推力（越大转向越灵敏）
            localPlayer = game.Players.LocalPlayer,
            rs = game:GetService("RunService")
        }

        -- 1. 关闭逻辑：断开所有连接，停止追踪
        if not state then
            -- 断开 workspace 监听
            if trackData.workspaceConn then
                trackData.workspaceConn:Disconnect()
                trackData.workspaceConn = nil
            end
            -- 断开所有子弹的追踪连接（避免残留）
            for _, conn in pairs(trackData.bulletConns) do
                conn:Disconnect()
            end
            trackData.bulletConns = {}
            return
        end

        -- 2. 辅助函数：筛选当前子弹的追踪目标
        local function getTarget(bulletPos)
            local nearestTarget = nil
            local nearestDist = math.huge

            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= trackData.localPlayer then
                    local char = player.Character
                    if char then
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        local root = char:FindFirstChild("HumanoidRootPart")
                        -- 目标需满足：存活+有根部件+在追踪距离内
                        if humanoid and humanoid.Health > 0 and root then
                            local dist = (bulletPos - root.Position).Magnitude
                            if dist <= trackData.maxDist and dist < nearestDist then
                                nearestDist = dist
                                nearestTarget = root
                            end
                        end
                    end
                end
            end
            return nearestTarget
        end

        -- 3. 辅助函数：给单个子弹附加追踪逻辑（核心驱动）
        local function attachTrack(bullet)
            -- 校验子弹有效性（必须是部件或包含部件）
            local bulletPart = bullet:IsA("BasePart") and bullet or bullet:FindFirstChildWhichIsA("BasePart")
            if not bulletPart then return end

            -- 确保子弹有物理控制器（BodyVelocity），否则无法转向
            local bodyVel = bulletPart:FindFirstChildOfClass("BodyVelocity")
            if not bodyVel then
                bodyVel = Instance.new("BodyVelocity")
                bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)  -- 解锁最大推力
                bodyVel.Velocity = bulletPart.Velocity  -- 继承初始速度
                bodyVel.Parent = bulletPart
            end

            -- 每帧更新子弹朝向（驱动追踪）
            local bulletConn = trackData.rs.Heartbeat:Connect(function()
                -- 终止条件：子弹消失/追踪关闭/无目标
                if not bulletPart.Parent or not trackData.enabled then
                    bulletConn:Disconnect()
                    trackData.bulletConns[bulletConn] = nil  -- 清理连接
                    return
                end

                -- 获取目标并驱动子弹追踪
                local target = getTarget(bulletPart.Position)
                if target then
                    local trackDir = (target.Position - bulletPart.Position).Unit
                    -- 保持子弹原有速度大小，只改变方向
                    bodyVel.Velocity = trackDir * bulletPart.Velocity.Magnitude
                    -- 同步子弹朝向（避免“子弹飞但朝向不对”的视觉问题）
                    bulletPart.CFrame = CFrame.new(bulletPart.Position, target.Position)
                end
            end)

            -- 存储子弹连接，便于关闭时清理
            trackData.bulletConns[bulletConn] = true
        end

        -- 4. 开启逻辑：监听 workspace，识别本地玩家子弹并附加追踪
        trackData.workspaceConn = workspace.ChildAdded:Connect(function(child)
            -- 子弹识别规则（适配多数游戏）：含关键词+属于本地玩家
            local isLocalBullet = (child.Name:lower():find("bullet") 
                or child.Name:lower():find("projectile") 
                or child.Name:lower():find("missile"))
                and (child:FindFirstChild("Owner") and child.Owner.Value == trackData.localPlayer)

            if isLocalBullet then
                task.wait(0.05)  -- 等待子弹部件加载完成（避免漏追）
                attachTrack(child)
            end
        end)
    end
})

local nightVisionData = {
    pointLight = nil,
    changedConnection = nil
}

Tab:Toggle({
    Title = "夜视",
    Default = false,
    Callback = function(isEnabled)
        local lighting = game:GetService("Lighting")
        local players = game:GetService("Players")
        local localPlayer = players.LocalPlayer

        if isEnabled then
            -- 开启夜视逻辑
            pcall(function()
                -- 保存原始的 Lighting 属性，方便关闭时恢复
                nightVisionData.originalAmbient = lighting.Ambient
                nightVisionData.originalBrightness = lighting.Brightness
                nightVisionData.originalFogEnd = lighting.FogEnd

                lighting.Ambient = Color3.fromRGB(255, 255, 255)
                lighting.Brightness = 1
                lighting.FogEnd = 1e10

                -- 禁用 Lighting 中的特效
                for _, v in pairs(lighting:GetDescendants()) do
                    if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
                        v.Enabled = false
                    end
                end

                -- 监听 Lighting 变化，保持夜视效果
                nightVisionData.changedConnection = lighting.Changed:Connect(function()
                    lighting.Ambient = Color3.fromRGB(255, 255, 255)
                    lighting.Brightness = 1
                    lighting.FogEnd = 1e10
                end)

                -- 给角色添加 PointLight
                spawn(function()
                    local character = localPlayer.Character
                    repeat wait() until character ~= nil
                    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                    if not humanoidRootPart:FindFirstChildWhichIsA("PointLight") then
                        local headlight = Instance.new("PointLight", humanoidRootPart)
                        headlight.Brightness = 1
                        headlight.Range = 60
                        nightVisionData.pointLight = headlight
                    end
                end)
            end)
        else
            -- 关闭夜视逻辑，恢复原始设置
            if nightVisionData.originalAmbient then
                lighting.Ambient = nightVisionData.originalAmbient
            end
            if nightVisionData.originalBrightness then
                lighting.Brightness = nightVisionData.originalBrightness
            end
            if nightVisionData.originalFogEnd then
                lighting.FogEnd = nightVisionData.originalFogEnd
            end

            -- 断开 Lighting 变化的连接
            if nightVisionData.changedConnection then
                nightVisionData.changedConnection:Disconnect()
                nightVisionData.changedConnection = nil
            end

            -- 移除添加的 PointLight
            if nightVisionData.pointLight and nightVisionData.pointLight.Parent then
                nightVisionData.pointLight:Destroy()
                nightVisionData.pointLight = nil
            end
        end
    end
})

Tab:Toggle({
    Title = "穿墙",
    Flag = "NoClip", -- 用于标识该 Toggle 的状态，需确保 UI 库支持 Flag 参数
    Default = false,
    Callback = function(NC)
        -- 定义全局变量（或在合适作用域）存储连接和状态，避免多次触发重复创建
        if not _G.Stepped then
            _G.Stepped = nil
        end
        if not _G.Clipon then
            _G.Clipon = false
        end
        
        local Workspace = game:GetService("Workspace")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        if NC then
            _G.Clipon = true
            -- 如果之前有连接，先断开，避免重复
            if _G.Stepped then
                _G.Stepped:Disconnect()
            end
            _G.Stepped = game:GetService("RunService").Stepped:Connect(function()
                if _G.Clipon then
                    local character = LocalPlayer.Character
                    if character then
                        for _, v in pairs(character:GetChildren()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                else
                    if _G.Stepped then
                        _G.Stepped:Disconnect()
                        _G.Stepped = nil
                    end
                end
            end)
        else
            _G.Clipon = false
            -- 断开连接，恢复碰撞
            if _G.Stepped then
                _G.Stepped:Disconnect()
                _G.Stepped = nil
            end
            local character = LocalPlayer.Character
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

-- 透视功能按钮
Tab:Button({
    Title = "透视",
    Callback = function()
        -- 状态变量，跟踪透视是否开启
        local isEspEnabled = not isEspEnabled

        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")

        local highlight = Instance.new("Highlight")
        highlight.Name = "Highlight"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- 保证透视高亮始终可见

        -- 清理函数，用于关闭透视时移除相关效果
        local function cleanupEsp()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        if humanoidRootPart:FindFirstChild("Highlight") then
                            humanoidRootPart.Highlight:Destroy()
                        end
                        if humanoidRootPart:FindFirstChild("PlayerNameDisplay") then
                            humanoidRootPart.PlayerNameDisplay:Destroy()
                        end
                    end
                end
            end
        end

        if isEspEnabled then
            -- 为已有玩家添加透视和小尺寸名字
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    local humanoidRootPart = player.Character.HumanoidRootPart

                    -- 添加/维护透视高亮
                    if not humanoidRootPart:FindFirstChild("Highlight") then
                        local highlightClone = highlight:Clone()
                        highlightClone.Adornee = player.Character
                        highlightClone.Parent = humanoidRootPart
                    end

                    -- 添加小尺寸名字显示（TextSize=9）
                    if not humanoidRootPart:FindFirstChild("PlayerNameDisplay") then
                        local billboardGui = Instance.new("BillboardGui")
                        billboardGui.Name = "PlayerNameDisplay"
                        billboardGui.Adornee = humanoidRootPart
                        billboardGui.Size = UDim2.new(0, 150, 0, 20) -- 适配小文字的Gui尺寸
                        billboardGui.StudsOffset = Vector3.new(0, 2.8, 0) -- 微调位置避免遮挡
                        billboardGui.AlwaysOnTop = true

                        local textLabel = Instance.new("TextLabel")
                        textLabel.Parent = billboardGui
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.Text = player.Name
                        textLabel.TextColor3 = Color3.new(1, 1, 1)
                        textLabel.TextSize = 9 -- 名字缩小到9
                        textLabel.TextScaled = false -- 关闭自动缩放，确保尺寸固定

                        billboardGui.Parent = humanoidRootPart
                    end
                end
            end

            -- 新玩家加入时添加透视和名字
            game.Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function(character)
                    repeat task.wait() until character:FindFirstChild("HumanoidRootPart")
                    local humanoidRootPart = character.HumanoidRootPart

                    -- 透视高亮
                    if not humanoidRootPart:FindFirstChild("Highlight") then
                        local highlightClone = highlight:Clone()
                        highlightClone.Adornee = character
                        highlightClone.Parent = humanoidRootPart
                    end

                    -- 小尺寸名字
                    local billboardGui = Instance.new("BillboardGui")
                    billboardGui.Name = "PlayerNameDisplay"
                    billboardGui.Adornee = humanoidRootPart
                    billboardGui.Size = UDim2.new(0, 150, 0, 20)
                    billboardGui.StudsOffset = Vector3.new(0, 2.8, 0)
                    billboardGui.AlwaysOnTop = true

                    local textLabel = Instance.new("TextLabel")
                    textLabel.Parent = billboardGui
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = player.Name
                    textLabel.TextColor3 = Color3.new(1, 1, 1)
                    textLabel.TextSize = 5 -- 名字缩小到5
                    textLabel.TextScaled = false

                    billboardGui.Parent = humanoidRootPart
                end)
            end)

            -- 玩家离开时清理资源
            game.Players.PlayerRemoving:Connect(function(player)
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local humanoidRootPart = player.Character.HumanoidRootPart
                    if humanoidRootPart:FindFirstChild("Highlight") then
                        humanoidRootPart.Highlight:Destroy()
                    end
                    if humanoidRootPart:FindFirstChild("PlayerNameDisplay") then
                        humanoidRootPart.PlayerNameDisplay:Destroy()
                    end
                end
            end)

            -- 每帧维护透视和名字显示
            local heartbeatConnection
            heartbeatConnection = RunService.Heartbeat:Connect(function()
                if not isEspEnabled then
                    heartbeatConnection:Disconnect()
                    cleanupEsp()
                    return
                end
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character then
                        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart then
                            -- 维护透视
                            if not humanoidRootPart:FindFirstChild("Highlight") then
                                local highlightClone = highlight:Clone()
                                highlightClone.Adornee = player.Character
                                highlightClone.Parent = humanoidRootPart
                                task.wait()
                            end

                            -- 维护小尺寸名字
                            if not humanoidRootPart:FindFirstChild("PlayerNameDisplay") then
                                local billboardGui = Instance.new("BillboardGui")
                                billboardGui.Name = "PlayerNameDisplay"
                                billboardGui.Adornee = humanoidRootPart
                                billboardGui.Size = UDim2.new(0, 150, 0, 20)
                                billboardGui.StudsOffset = Vector3.new(0, 2.8, 0)
                                billboardGui.AlwaysOnTop = true

                                local textLabel = Instance.new("TextLabel")
                                textLabel.Parent = billboardGui
                                textLabel.Size = UDim2.new(1, 0, 1, 0)
                                textLabel.BackgroundTransparency = 1
                                textLabel.Text = player.Name
                                textLabel.TextColor3 = Color3.new(1, 1, 1)
                                textLabel.TextSize = 5 -- 名字缩小到5
                                textLabel.TextScaled = false

                                billboardGui.Parent = humanoidRootPart
                                task.wait()
                            end
                        end
                    end
                end
            end)
        else
            -- 关闭透视，清理相关效果
            cleanupEsp()
        end
    end
})
local aimbotConnection

-- Code Display
local CodeBlock = Tab:Code({
Title = "Love Players",
Code = "感谢游玩\nQQ号:3395858053"
})

    -- Simulate update
    task.delay(5, function()
        CodeBlock:SetCode("感谢游玩\nQQ号:3395858053")
    end)
end

-- Line Separator
Window:Line()

-- Another Tab Example
local Extra = Window:Tab({Title = "极速传奇", Icon = 105059922903197}) do
    Extra:Section({Title = "传送(请勿在其他服务器中执行!)", Icon = "wrench"})
    Extra:Button({
        Title = "城市",
        Desc = "单击以执行",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            humanoidRootPart.CFrame = CFrame.new(-534.38, 4.07, 437.75)
            Window:Notify({
                Title = "通知",
                Desc = "传送成功",
                Time = 1
            })
        end
    })
end
        
    Extra:Button({
        Title = "神秘洞穴",
        Desc = "单击以执行",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            humanoidRootPart.CFrame = CFrame.new(-9683.05, 59.25, 3136.63)
            Window:Notify({
                Title = "通知",
                Desc = "传送成功",
                Time = 1
            })
        end
    })
    
    Extra:Button({
        Title = "草地挑战",
        Desc = "单击以执行",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            humanoidRootPart.CFrame = CFrame.new(-1550.49, 34.51, 87.48)
            Window:Notify({
                Title = "通知",
                Desc = "传送成功",
                Time = 1
            })
        end
    })
    
    Extra:Button({
        Title = "海市蜃楼挑战",
        Desc = "单击以执行",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            humanoidRootPart.CFrame = CFrame.new(1414.31, 90.44, -2058.34)
            Window:Notify({
                Title = "通知",
                Desc = "传送成功",
                Time = 1
            })
        end
    })
    
    Extra:Button({
        Title = "冰霜挑战",
        Desc = "单击以执行",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            humanoidRootPart.CFrame = CFrame.new(2045.63, 64.57, 993.17)
            Window:Notify({
                Title = "通知",
                Desc = "传送成功",
                Time = 1
            })
        end
    })
    
    Extra:Button({
        Title = "绿色水晶",
        Desc = "单击以执行",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            humanoidRootPart.CFrame = CFrame.new(385.60, 65.02, 19.00)
            Window:Notify({
                Title = "通知",
                Desc = "传送成功",
                Time = 1
            })
        end
    })
    
    Extra:Button({
        Title = "蓝色水晶",
        Desc = "单击以执行",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            humanoidRootPart.CFrame = CFrame.new(-581.56, 4.12, 495.92)
            Window:Notify({
                Title = "通知",
                Desc = "传送成功",
                Time = 1
            })
        end
    })
    
    Extra:Button({
        Title = "紫色水晶",
        Desc = "单击以执行",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            humanoidRootPart.CFrame = CFrame.new(-428.17, 4.12, 203.52)
            Window:Notify({
                Title = "通知",
                Desc = "传送成功",
                Time = 1
            })
        end
    })
    
    Extra:Button({
        Title = "黄色水晶",
        Desc = "单击以执行",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            humanoidRootPart.CFrame = CFrame.new(-313.23, 4.12, -375.43)
            Window:Notify({
                Title = "通知",
                Desc = "传送成功",
                Time = 1
            })
        end
    })
    
Extra:Section({Title = "自动", Icon = "wrench"})

-- 状态变量，标记是否正在执行自动吃黄球
local isRunning = false
-- 用于在停止时退出循环的标志
local shouldStop = false

Extra:Button({
    Title = "自动吃橙球(city)",
    Desc = "单击以执行/停止",
    Callback = function()
        if not isRunning then
            -- 启动新线程，避免阻塞
            spawn(function()
                shouldStop = false
                while true do
                    -- 检测是否需要停止
                    if shouldStop then
                        break
                    end
                    local args = {
                        "collectOrb",
                        "Orange Orb",
                        "City"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args))
                    wait(0.5)
                end
                -- 执行停止后的清理，将状态设为未运行
                isRunning = false
            end)
            isRunning = true
            Window:Notify({
                Title = "通知",
                Desc = "正在执行",
                Time = 1
            })
        else
            -- 设置停止标志
            shouldStop = true
            isRunning = false
            Window:Notify({
                Title = "通知",
                Desc = "已停止执行",
                Time = 1
            })
        end
    end
})

Extra:Button({
    Title = "自动吃红球(city)",
    Desc = "单击以执行/停止",
    Callback = function()
        if not isRunning then
            spawn(function()
                shouldStop = false
                while true do
                    if shouldStop then
                        break
                    end
                    local args = {
                        "collectOrb",
                        "Red Orb",
                        "City"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args))
                    wait(0.5)
                end
                isRunning = false
            end)
            isRunning = true
            Window:Notify({
                Title = "通知",
                Desc = "正在执行",
                Time = 1
            })
        else
            shouldStop = true
            isRunning = false
            Window:Notify({
                Title = "通知",
                Desc = "已停止执行",
                Time = 1
            })
        end
    end
})
-- 记得在合适的位置定义 isRunning 和 shouldStop 变量，比如在按钮代码上方
local isRunning = false
local shouldStop = false

-- 定义全局变量，标记是否正在运行以及停止标志
local isRunning = false
local shouldStop = false

Extra:Button({
    Title = "自动吃黄球(city)",
    Desc = "单击以执行/停止",
    Callback = function()
        if not isRunning then
            -- 启动新线程，避免阻塞主线程
            spawn(function()
                shouldStop = false
                while true do
                    -- 检测是否需要停止
                    if shouldStop then
                        break
                    end
                    local args = {
                        "collectOrb",
                        "Yellow Orb",
                        "City"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args))
                    wait(0.5)
                end
                -- 执行停止后的清理，将状态设为未运行
                isRunning = false
            end)
            isRunning = true
            Window:Notify({
                Title = "通知",
                Desc = "正在执行",
                Time = 1
            })
        else
            -- 设置停止标志
            shouldStop = true
            isRunning = false
            Window:Notify({
                Title = "通知",
                Desc = "已停止执行",
                Time = 1
            })
        end
    end
})

Extra:Button({
    Title = "自动收集宝石(City)",
    Desc = "单击以执行/停止",
    Callback = function()
        if not isRunning then
            -- 启动新线程，避免阻塞主线程
            spawn(function()
                shouldStop = false
                while true do
                    -- 检测是否需要停止
                    if shouldStop then
                        break
                    end
                    local args = {
                        "collectOrb",
                        "Gem",
                        "City"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args))
                    wait(0.5)
                end
                -- 执行停止后的清理，将状态设为未运行
                isRunning = false
            end)
            isRunning = true
            Window:Notify({
                Title = "通知",
                Desc = "正在执行自动收集宝石",
                Time = 1
            })
        else
            -- 设置停止标志
            shouldStop = true
            isRunning = false
            Window:Notify({
                Title = "通知",
                Desc = "已停止自动收集宝石",
                Time = 1
            })
        end
    end
})

-- 定义全局变量，标记是否正在运行以及停止标志
local isRunning = false
local shouldStop = false

Extra:Button({
    Title = "自动吃蓝球(city)",
    Desc = "单击以执行/停止",
    Callback = function()
        if not isRunning then
            -- 启动新线程，避免阻塞主线程
            spawn(function()
                shouldStop = false
                while true do
                    -- 检测是否需要停止
                    if shouldStop then
                        break
                    end
                    local args = {
                        "collectOrb",
                        "Blue Orb",
                        "City"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args))
                    wait(0.5)
                end
                -- 执行停止后的清理，将状态设为未运行
                isRunning = false
            end)
            isRunning = true
            Window:Notify({
                Title = "通知",
                Desc = "正在执行",
                Time = 1
            })
        else
            -- 设置停止标志
            shouldStop = true
            isRunning = false
            Window:Notify({
                Title = "通知",
                Desc = "已停止执行",
                Time = 1
            })
        end
    end
})

local Extra = Window:Tab({Title = "99夜", Icon = 105059922903197}) do
    Extra:Section({Title = "传送"})
    Extra:Button({
        Title = "篝火",
        Desc = "单击以执行",
        Callback = function()
            Window:Notify({
                Title = "通知",
                Desc = "传送成功",
                Time = 1
            })
        end
    })
end

Window:Notify({
    Title = "Cat Hub",
    Desc = "感谢您的游玩",
    Time = 5
})

script.Destroying:Connect(function()
    Window:Notify({
        Title = "Cat Hub",
        Desc = "关闭",
        Time = 5
    })
end)