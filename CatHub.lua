--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

-- Create Main Window
local Window = Library:Window({
    Title = "Cat Hub",
    Desc = "放挂机已开启",
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
local Tab = Window:Tab({Title = "主页", Icon = 105059922903197}) do

    -- Section
    Tab:Section({Title = "By Ccat\n脚本免费 请勿倒卖"})

    -- Button
     Tab:Button({
        Title = "传送到极速传奇",
        Desc = "单击以执行",
        Callback = function()
        print("Button clicked!")
            Window:Notify({
                Title = "正在运行",
                Desc = "",
                Time = 1
            })
        end
    })

-- 假设 Tab 是已经创建好的选项卡对象
Tab:Slider({
    Title = "设置速度",
    Min = 0,
    Max = 100,
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
-- 透视功能按钮
Tab:Button({
    Title = "透视",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "Highlight"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- 保证透视高亮始终可见

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
                textLabel.TextSize = 9 -- 名字缩小到9
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
        RunService.Heartbeat:Connect(function()
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
                            textLabel.TextSize = 9 -- 名字缩小到9
                            textLabel.TextScaled = false

                            billboardGui.Parent = humanoidRootPart
                            task.wait()
                        end
                    end
                end
            end
        end)
    end
})
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
    Extra:Section({Title = "传送", Icon = "wrench"})
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

local hoo = Tab:AddSection("圈")
spawn(function()
    local plr = game:GetService("Players").LocalPlayer -- 获取本地玩家
    while wait() do
        pcall(function()
            hoo:Set("圈:" .. plr.leaderstats.Hoops.Value)
        end)
    end
end)

local Extra = Window:Tab({Title = "力量传奇", Icon = 105059922903197}) do
    Extra:Section({Title = "传送"})
    Extra:Button({
        Title = "出生点",
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