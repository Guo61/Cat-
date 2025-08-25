--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Cat Hub",
    Text = "欢迎使用",
    Icon = "star",
    Duration = 5
})

local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Cat Hub",
    Text = "加载完毕",
    Icon = "star",
    Duration = 8
})

-- Create Main Window
local Window = Library:Window({
    Title = "Cat Hub",
    Desc = "感谢游玩与支持",
    Icon = 105059922903197,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 350)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "关闭/打开"
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

--Tab
local Tab = Window:Tab({Title = "主页", Icon = "star"}) do
    -- Section
    Tab:Section({Title = "感谢游玩\nBy Ccat\nQQ3395858053\n感谢Gz-神明支持"})

    -- Toggle
    Tab:Toggle({
        Title = "Enable Feature",
        Desc = "Toggle to enable or disable the feature",
        Value = false,
        Callback = function(v)
            print("Toggle:", v)
        end
    })

    -- Button
    Tab:Button({
        Title = "Run Action",
        Desc = "Click to perform something",
        Callback = function()
            print("Button clicked!")
            Window:Notify({
                Title = "Button",
                Desc = "Action performed successfully.",
                Time = 3
            })
        end
    })

    -- Textbox
    Tab:Textbox({
        Title = "Input Text",
        Desc = "Type something here",
        Placeholder = "Enter value",
        Value = "",
        ClearTextOnFocus = false,
        Callback = function(text)
            print("Textbox value:", text)
        end
    })

    -- Slider
    Tab:Slider({
        Title = "设置速度",
        Min = 0,
        Max = 100,
        Rounding = 0,
        Value = 25,
        Callback = function(val)
            print("Slider:", val)
        end
    })

    -- Dropdown
    Tab:Dropdown({
        Title = "Choose Option",
        List = {"Option 1", "Option 2", "Option 3"},
        Value = "Option 1",
        Callback = function(choice)
            print("Selected:", choice)
        end
    })

    -- Code Display
    local CodeBlock = Tab:Code({
        Title = "Example Code",
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
local Extra = Window:Tab({Title = "Extra", Icon = "tag"}) do
    Extra:Section({Title = "传送"})
    Extra:Button({
        Title = "传送到城市",
        Desc = "传送至指定城市坐标",
        Callback = function()
            -- 检查玩家是否存在且有角色
            local player = game.Players.LocalPlayer
            if not player or not player.Character then
                Window:Notify({
                    Title = "错误",
                    Desc = "玩家角色不存在，无法传送",
                    Time = 3
                })
                return
            end

            -- 定义目标 CFrame（使用你提供的城市坐标参数）
            local targetCFrame = CFrame.new(-9682.98828, 74.8522873, 3099.03394, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)

            -- 获取角色的 HumanoidRootPart 并设置其 CFrame
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CFrame = targetCFrame
                Window:Notify({
                    Title = "传送成功",
                    Desc = "已传送到城市指定位置",
                    Time = 3
                })
            else
                Window:Notify({
                    Title = "错误",
                    Desc = "未找到 HumanoidRootPart，无法传送",
                    Time = 3
                })
            end
        end
    })
end
Window:Line()

local Extra = Window:Tab({Title = "设置", Icon = "wrench"}) do
    Extra:Section({Title = "Config"})
    Extra:Button({
        Title = "Show Message",
        Desc = "Display a popup",
        Callback = function()
            Window:Notify({
                Title = "Fluent UI"
                Desc = "Everything works fine!",
                Time = 3
            })
        end
    })
end
-- Final Notification
Window:Notify({
    Title = "x2zu",
    Desc = "All components loaded successfully! Credits leak: @x2zu",
    Time = 4
})