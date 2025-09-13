local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Guo61/Cat-/main/main.lua"))()

local Confirmed = false

WindUI:Popup({
    Title = "Cat 脚盆 v1.30",
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    Content = "By:Ccat\nQQ:3395858053 元素力量大亨",
    Buttons = {
        {
            Title = "进入脚盆。",
            Icon = "arrow-right",
            Callback = function()
                Confirmed = true
            end,
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
    Title = "v1.30",
    Color = Color3.fromHex("#30ff6a")
})
 local Tabs = {
    Home = Window:Tab({ Title = "主页", Icon = "crown" })
    }

local BlinkDist = 5
local Cooldown = 1
local IsCooling = false
local BlinkButton
local DistLabel
local IgnoreWalls = false 


BTabs.Home:Slider({
    Title = "瞬移距离",
    Description = "选择 1~10 studs",
    Default = BlinkDist,
    Min = 1,
    Max = 10,
    Callback = function(value)
        BlinkDist = value
        if DistLabel then
            DistLabel:SetTitle("当前距离：" .. BlinkDist .. " stud")
        end
    end,
})

Tabs.Home:Toggle({
    Title = "忽略障碍物 (穿墙)",
    Description = "开启后传送不会被墙体阻挡",
    Default = false,
    Callback = function(state)
        IgnoreWalls = state
    end,
})

Tabs.Home:Button({
    Title = "瞬移",
    Icon = "zap",
    Variant = "Primary",
    Callback = function()
        if not IsCooling then
            IsCooling = true

            local player = game.Players.LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")

            if hrp then
                local targetPos = hrp.CFrame * CFrame.new(0, 0, -BlinkDist)

                if IgnoreWalls then
                    hrp.CFrame = targetPos
                else
                    local ray = RaycastParams.new()
                    ray.FilterDescendantsInstances = {char}
                    ray.FilterType = Enum.RaycastFilterType.Blacklist

                    local result = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * BlinkDist, ray)

                    if result then
                        hrp.CFrame = CFrame.new(result.Position - hrp.CFrame.LookVector * 2, hrp.CFrame.LookVector + Vector3.new(0, 1, 0))
                    else
                        hrp.CFrame = targetPos
                    end
                end
            end
            
            local startTime = tick()
            local endTime = startTime + Cooldown

            BlinkButton:SetVariant("Secondary")

            task.spawn(function()
                while tick() < endTime do
                    local remaining = math.max(0, endTime - tick())
                    BlinkButton:SetTitle(string.format("冷却中 %.1fs", remaining))
                    task.wait(0.1)
                end

                IsCooling = false
                BlinkButton:SetVariant("Primary")
                BlinkButton:SetTitle("瞬移")
            end)
        end
    end,
})

Tabs.Home:Label({
    Title = "当前距离：" .. Desc =  .. " stud",
    Description = "滑条调整后实时更新",
})