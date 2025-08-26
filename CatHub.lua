--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

-- Create Main Window
local Window = Library:Window({
    Title = "Cat Hub",
    Desc = "感谢游玩",
    Icon = "star",
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
    Tab:Section({Title = "By Ccat\nQQ3395858053"})

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

-- 创建 ESP 控制按钮
local ESPButton = Tab:Button({
    Title = "Toggle ESP",
    Callback = function()
        espEnabled = not espEnabled
        print("ESP 已" .. (espEnabled and "开启" or "关闭"))
        -- 更新所有绘制对象的可见性
        for _, obj in ipairs(drawingObjects) do
            obj.Box.Visible = espEnabled
            obj.NameLabel.Visible = espEnabled
        end
    end
})

-- 以下是同服务器人物 ESP 代码
-- 引入必要的服务
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- ESP 相关配置
local espEnabled = false
local boxColor = Color3.fromRGB(255, 0, 0) -- 方框颜色，设为红色
local nameColor = Color3.fromRGB(255, 255, 255) -- 名字颜色，设为白色

-- 存储绘制对象的表，方便后续管理
local drawingObjects = {}

-- 绘制单个人物 ESP 的函数
local function drawCharacterESP(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local head = character:FindFirstChild("Head")
    if not humanoid or not head or humanoid.Health <= 0 then
        return
    end

    -- 创建方框绘制对象
    local box = Drawing.new("Square")
    box.Color = boxColor
    box.Thickness = 2
    box.Filled = false
    box.Visible = espEnabled

    -- 创建名字文本绘制对象
    local nameLabel = Drawing.new("Text")
    nameLabel.Color = nameColor
    nameLabel.Size = 18
    nameLabel.Center = true
    nameLabel.Visible = espEnabled

    -- 将绘制对象存入表中
    table.insert(drawingObjects, {Box = box, NameLabel = nameLabel, Character = character})

    -- 每帧更新绘制对象
    local connection
    connection = RunService.RenderStepped:Connect(function()
        -- 检查人物是否有效且 ESP 是否开启
        if not character:IsDescendantOf(workspace) or not espEnabled then
            box:Remove()
            nameLabel:Remove()
            connection:Disconnect()
            -- 从存储表中移除该人物的绘制对象
            for i, obj in ipairs(drawingObjects) do
                if obj.Character == character then
                    table.remove(drawingObjects, i)
                    break
                end
            end
            return
        end

        -- 获取人物头部在屏幕上的位置
        local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
        if not onScreen then
            box.Visible = false
            nameLabel.Visible = false
            return
        end

        -- 获取人物的边界框
        local minBounds, maxBounds = character:GetBoundingBox()
        local topPos = Camera:WorldToScreenPoint(minBounds.Position)
        local bottomPos = Camera:WorldToScreenPoint(maxBounds.Position)

        if topPos.Z > 0 and bottomPos.Z > 0 then
            -- 计算方框尺寸
            local width = 100 * (maxBounds.Position - minBounds.Position).Magnitude / screenPos.Z
            local height = (bottomPos.Y - topPos.Y)

            -- 更新方框属性
            box.Position = Vector2.new(screenPos.X - width / 2, screenPos.Y - height / 2)
            box.Size = Vector2.new(width, height)
            box.Visible = true

            -- 更新名字文本属性
            nameLabel.Text = character.Name
            nameLabel.Position = Vector2.new(screenPos.X, screenPos.Y - height / 2 - 20)
            nameLabel.Visible = true
        else
            box.Visible = false
            nameLabel.Visible = false
        end
    end)
end

-- 为已存在的玩家人物添加 ESP（初始不开启，点击按钮后才会生效）
local function addExistingPlayerESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            drawCharacterESP(player.Character)
        end
        -- 监听玩家人物加载完成事件
        player.CharacterAdded:Connect(drawCharacterESP)
    end
end

-- 监听新玩家加入事件
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(drawCharacterESP)
end)

-- Code Display
local CodeBlock = Tab:Code({
Title = "Love Code",
Code = "-- This is a code preview\nprint('Hello world')"
})

    -- Simulate update
    task.delay(5, function()
        CodeBlock:SetCode("-- Updated!\nprint('New content loaded')")
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