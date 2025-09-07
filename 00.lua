local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Guo61/Cat-/refs/heads/main/main.lua"))()

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

-- 主窗口
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

-- ========= 瞬移功能 =========
local BlinkPage = Window:Page({ Title = "瞬移功能", Icon = "zap" })

local BlinkDist = 5 -- 默认传送距离
local Cooldown = 1 -- 冷却秒数
local IsCooling = false
local BlinkButton -- 保存按钮对象
local DistLabel -- 保存距离标签

-- 距离滑条
BlinkPage:Slider({
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

-- 瞬移按钮
BlinkButton = BlinkPage:Button({
    Title = "瞬移",
    Icon = "zap",
    Variant = "Primary",
    Callback = function()
        if not IsCooling then
            IsCooling = true

            -- 发起瞬移
            remote:FireServer(BlinkDist)

            -- 冷却逻辑
            local startTime = tick()
            local endTime = startTime + Cooldown

            -- 禁用按钮
            BlinkButton:SetVariant("Secondary")

            -- 动态更新倒计时
            task.spawn(function()
                while tick() < endTime do
                    local remaining = math.max(0, endTime - tick())
                    BlinkButton:SetTitle(string.format("冷却中 %.1fs", remaining))
                    task.wait(0.1)
                end

                -- 冷却完成 → 恢复按钮
                IsCooling = false
                BlinkButton:SetVariant("Primary")
                BlinkButton:SetTitle("瞬移")
            end)
        end
    end,
})

-- 距离显示标签
DistLabel = BlinkPage:Label({
    Title = "当前距离：" .. BlinkDist .. " stud",
    Description = "滑条调整后实时更新",
})