local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

local Window = Library:Window({
    Title = "Cat Hub",
    Desc = "需要时开启反挂机",
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

local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(0, 140, 0, 0) -- adjust if needed
SidebarLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Name = "SidebarLine"
SidebarLine.Parent = game:GetService("CoreGui")

local Tab = Window:Tab({Title = "主页", Icon = "star"}) do

    Tab:Section({Title = "By Ccat\n脚本免费 请勿倒卖"})

Tab:Button({  
    Title = "反挂机",  
    Desc = "不要随意开启!",  
    Description = "从Github加载并执行反挂机",  
    Callback = function()  
       
        Window:Notify({  
            Title = "Cat Hub",  
            Desc = "正在加载反挂机脚本...",  
            Time = 3  
        })  

        print("开始加载反挂机脚本...")  

        local url = "https://raw.githubusercontent.com/Guo61/Cat-/refs/heads/main/%E5%8F%8D%E6%8C%82%E6%9C%BA.lua"

        -- 添加错误处理  
        local success, response = pcall(function()  
            return game:HttpGet(url, true)  
        end)  

        if success and response and #response > 100 then  
            print("GitHub脚本加载成功")  

            -- 执行脚本  
            local executeSuccess, executeError = pcall(function()  
                loadstring(response)()  
            end)  

            if executeSuccess then  
                Window:Notify({  
                    Title = "Cat Hub",  
                    Desc = "反挂机脚本加载并执行成功!",  
                    Time = 5  
                })  
                print("反挂机脚本执行成功")  
            else  
                Window:Notify({  
                    Title = "Cat Hub",  
                    Desc = "脚本执行错误: " .. tostring(executeError),  
                    Time = 5  
                })  
                warn("脚本执行失败:", executeError)  
            end  

        else  
            Window:Notify({  
                Title = "Cat Hub",  
                Desc = "反挂机脚本加载失败，请检查网络",  
                Time = 5  
            })  
            warn("GitHub脚本加载失败")  
        end  

        print("加载完毕并执行")  
    end  
})

Tab:Button({
    Title = "半隐身",
    Desc = "悬浮窗关不掉",
    Description = "从GitHub加载并执行隐身脚本",
    Callback = function()
        -- 从指定URL加载并执行隐身脚本
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Invisible-35376"))()
        print("隐身脚本已加载并执行")
    end
})

Tab:Button({
    Title = "玩家入退提示",
    Description = "从GitHub加载并执行提示脚本",
    Callback = function()
        -- 从指定URL加载并执行提示脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/boyscp/scriscriptsc/main/bbn.lua"))()
        print("提示脚本已加载并执行")
    end
})

Tab:Button({
    Title = "甩飞",
    Description = "从GitHub加载并执行甩飞脚本",
    Callback = function()
        -- 从指定URL加载并执行甩飞脚本
        loadstring(game:HttpGet("https://pastebin.com/raw/GnvPVBE"))()
        print("甩飞脚本已加载并执行")
    end
})

local maxSafeVelocity = 100
-- 获取本地玩家
local player = game.Players.LocalPlayer

-- 用于存储 Stepped 连接
local antiWalkFlingConn

local function enableAntiWalkFling()
    if antiWalkFlingConn then
        antiWalkFlingConn:Disconnect()
    end
    local lastVelocity = Vector3.new()
    antiWalkFlingConn = game:GetService("RunService").Stepped:Connect(function()
        local character = player.Character
        if not character then
            return
        end
        local hrp = character.FindFirstChild("HumanoidRootPart")
        if not hrp then
            return
        end
        local currentVelocity = hrp.Velocity
        if (currentVelocity - lastVelocity).Magnitude > maxSafeVelocity then
            hrp.Velocity = lastVelocity
            -- 这里用 print 提示，若有自定义 notify 函数可替换
            print("Anti-WalkFling activated!");
        end
        lastVelocity = currentVelocity
    end)
end

local function disableAntiWalkFling()
    if antiWalkFlingConn then
        antiWalkFlingConn:Disconnect()
        antiWalkFlingConn = nil
    end
end

-- 假设 Tab 是通过 UI 库创建的标签页对象
Tab:Button({
    Title = "防甩飞",
    Desc = "不要和甩飞同时开启",
    Description = "启用/禁用反 WalkFling",
    -- 用于标记当前是否启用
    IsEnabled = false,
    Callback = function(self)
        if self.IsEnabled then
            disableAntiWalkFling()
            self.IsEnabled = false
            print("Anti-WalkFling 已禁用")
        else
            enableAntiWalkFling()
            self.IsEnabled = true
            print("Anti-WalkFling 已启用")
        end
    end
})

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
    Title = "设置个人重力",
    Desc = "默认值即为最大值",
    Min = 0,
    Max = 196.2,
    Rounding = 1,
    Value = 196.2,
    Callback = function(val)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        -- 确保HumanoidRootPart加载完成
        local rootPart = character:WaitForChild("HumanoidRootPart", 10) 
        if not rootPart then
            print("等待HumanoidRootPart超时")
            return
        end

        -- 移除旧的个人重力
        local oldGravity = rootPart:FindFirstChild("PersonalGravity")
        if oldGravity then
            oldGravity:Destroy()
        end

        if val ~= workspace.Gravity then
            local personalGravity = Instance.new("BodyForce")
            personalGravity.Name = "PersonalGravity"

            local mass = rootPart:GetMass()
            -- 关键修复：力的方向与重力方向相反，需用“世界重力 - 目标重力”计算
            local force = Vector3.new(0, mass * (workspace.Gravity - val), 0)

            personalGravity.Force = force
            personalGravity.Parent = rootPart
            print("个人重力已设置为:", val, "，力大小：", force.Y)
        else
            print("个人重力已恢复默认")
        end
    end
})

-- 角色重置时清理个人重力
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart", 10)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local oldGravity = rootPart:FindFirstChild("PersonalGravity")
        if oldGravity then
            oldGravity:Destroy()
            print("角色重置，旧个人重力已清理")
        end
    end

    character.DescendantRemoving:Connect(function(descendant)
        if descendant.Name == "PersonalGravity" then
            print("个人重力效果已清理")
        end
    end)
end)

        Tab:Slider({
Title = "设置跳跃高度",
Desc = "可输入",
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

Tab:Button({
    Title = "无限跳",
    Desc = "概率关不了",
    Description = "从GitHub加载并执行无限跳脚本",
    Callback = function()
       loadstring(game:HttpGet("https://pastebin.com/raw/V5PQy3y0", true))()
        print("无限跳已加载并执行")
    end
})

Tab:Button({
    Title = "自瞄",
    Desc = "宙斯自瞄",
    Description = "从GitHub加载并执行自瞄脚本",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/Arceus%20Aimbot.lua"))()
        print("自瞄已加载并执行")
    end
})

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
local Extra = Window:Tab({Title = "极速传奇", Icon = "zap"}) do
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
-- 定义全局变量标记自动重生状态
_G.auto_nobs = false
-- 存储自动重生的线程，用于停止时销毁
local autoNobsThread = nil

-- 自动重生的核心逻辑
local function autoNobs()
    while _G.auto_nobs do
        task.wait()
        local rebirthRemote = game:GetService("ReplicatedStorage"):FindFirstChild("rEvents"):FindFirstChild("rebirthRemote")
        if rebirthRemote then
            rebirthRemote:InvokeServer("rebirthRequest")
        end
    end
end

lcal CodeBlock = Tab:Code({
Title = "Love Players",
Code = "传送功能请勿在其他服务器执行\n该服务器功能暂未补全"
})

    -- Simulate update
    task.delay(5, function()
        CodeBlock:SetCode("传送功能请勿在其他服务器执行\n该服务器功能暂未补全")
    end)

local Tab = Window:Tab({Title = "忍者传奇", Icon = "map-pin"}) do

    Tab:Section({Title = "By Ccat\n传送功能请勿在其他服务器执行"})

Window:Notify({
    Title = "Cat Hub",
    Desc = "感谢您的游玩",
    Time = 5
})
