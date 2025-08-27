-- 服务引用
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- 本地玩家与基础变量
local LocalPlayer = Players.LocalPlayer
local FlingUI = nil -- 存储UI实例
local TargetPlayer = nil -- 存储选中的目标玩家
local FlingForce = 800 -- 默认甩飞力度
local FlingDirection = Vector3.new(0, 2, 5) -- 默认甩飞方向（上+前）

-- ====================== UI 创建函数 ======================
local function createFlingUI()
    -- 销毁旧UI（避免重复创建）
    if FlingUI then FlingUI:Destroy() end

    -- 主UI容器
    FlingUI = Instance.new("ScreenGui")
    FlingUI.Name = "FlingToolUI"
    FlingUI.Parent = CoreGui -- 挂载到CoreGui（本地可见）
    FlingUI.IgnoreGuiInset = true -- 忽略屏幕边缘 inset

    -- 1. 主面板
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 350, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200) -- 屏幕居中
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.fromRGB(255, 150, 0)
    MainFrame.Parent = FlingUI

    -- 添加圆角
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    -- 2. 标题
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Title.Text = "玩家甩飞工具"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.Parent = MainFrame

    -- 3. 目标玩家选择下拉框
    local TargetLabel = Instance.new("TextLabel")
    TargetLabel.Name = "TargetLabel"
    TargetLabel.Size = UDim2.new(0.4, 0, 0, 30)
    TargetLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
    TargetLabel.BackgroundTransparency = 1
    TargetLabel.Text = "目标玩家："
    TargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TargetLabel.TextScaled = true
    TargetLabel.Parent = MainFrame

    local TargetDropdown = Instance.new("TextButton")
    TargetDropdown.Name = "TargetDropdown"
    TargetDropdown.Size = UDim2.new(0.5, 0, 0, 30)
    TargetDropdown.Position = UDim2.new(0.45, 0, 0.15, 0)
    TargetDropdown.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    TargetDropdown.Text = "选择玩家"
    TargetDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    TargetDropdown.TextScaled = true
    TargetDropdown.Parent = MainFrame

    -- 下拉框选项列表（默认隐藏）
    local DropdownList = Instance.new("ScrollingFrame")
    DropdownList.Name = "DropdownList"
    DropdownList.Size = UDim2.new(0.5, 0, 0, 120)
    DropdownList.Position = UDim2.new(0.45, 0, 0.22, 0)
    DropdownList.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    DropdownList.Visible = false
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
    DropdownList.ScrollBarThickness = 4
    DropdownList.Parent = MainFrame

    local ListLayout = Instance.new("ThListLayout")
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.Parent = DropdownList

    -- 4. 甩飞力度调节滑块
    local ForceLabel = Instance.new("TextLabel")
    ForceLabel.Name = "ForceLabel"
    ForceLabel.Size = UDim2.new(1, 0, 0, 25)
    ForceLabel.Position = UDim2.new(0, 0, 0.45, 0)
    ForceLabel.BackgroundTransparency = 1
    ForceLabel.Text = "甩飞力度：" .. FlingForce
    ForceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ForceLabel.TextScaled = true
    ForceLabel.Parent = MainFrame

    local ForceSlider = Instance.new("ScrollingFrame")
    ForceSlider.Name = "ForceSlider"
    ForceSlider.Size = UDim2.new(0.9, 0, 0, 10)
    ForceSlider.Position = UDim2.new(0.05, 0, 0.52, 0)
    ForceSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    ForceSlider.Parent = MainFrame

    local SliderHandle = Instance.new("Frame")
    SliderHandle.Name = "SliderHandle"
    SliderHandle.Size = UDim2.new(0, 20, 1, 2)
    SliderHandle.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    SliderHandle.Position = UDim2.new((FlingForce - 200)/1600, 0, 0, -1) -- 力度范围200-1800
    SliderHandle.Parent = ForceSlider

    -- 5. 执行甩飞按钮
    local FlingButton = Instance.new("TextButton")
    FlingButton.Name = "FlingButton"
    FlingButton.Size = UDim2.new(0.8, 0, 0, 40)
    FlingButton.Position = UDim2.new(0.1, 0, 0.65, 0)
    FlingButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    FlingButton.Text = "执行甩飞"
    FlingButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    FlingButton.TextScaled = true
    FlingButton.Parent = MainFrame

    -- 添加圆角
    local FlingButtonCorner = Instance.new("UICorner")
    FlingButtonCorner.CornerRadius = UDim.new(0, 4)
    FlingButtonCorner.Parent = FlingButton

    -- 6. UI开关按钮（最小化/关闭）
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextScaled = true
    CloseButton.Parent = MainFrame

    -- 添加圆角
    local CloseButtonCorner = Instance.new("UICorner")
    CloseButtonCorner.CornerRadius = UDim.new(0, 15)
    CloseButtonCorner.Parent = CloseButton

    -- ====================== UI 交互逻辑 ======================
    -- 1. 下拉框加载玩家列表
    local function updatePlayerList()
        -- 清空旧列表
        for _, child in ipairs(DropdownList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        -- 加载所有在线玩家（排除本地玩家）
        local playerList = Players:GetPlayers()
        for _, player in ipairs(playerList) do
            if player ~= LocalPlayer then
                local PlayerButton = Instance.new("TextButton")
                PlayerButton.Name = player.Name
                PlayerButton.Size = UDim2.new(1, 0, 0, 28)
                PlayerButton.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                PlayerButton.Text = player.Name
                PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                PlayerButton.TextScaled = true
                PlayerButton.Parent = DropdownList

                -- 选中玩家
                PlayerButton.MouseButton1Click:Connect(function()
                    TargetPlayer = player
                    TargetDropdown.Text = player.Name
                    DropdownList.Visible = false
                end)
            end
        end

        -- 调整列表高度
        ListLayout:ApplyLayout()
        DropdownList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
    end

    -- 初始加载玩家列表
    updatePlayerList()
    -- 监听玩家加入/离开，更新列表
    Players.PlayerAdded:Connect(updatePlayerList)
    Players.PlayerRemoving:Connect(updatePlayerList)

    -- 2. 下拉框显示/隐藏切换
    TargetDropdown.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
    end)

    -- 3. 力度滑块交互
    local isDraggingSlider = false
    SliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDraggingSlider = true
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDraggingSlider = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if isDraggingSlider then
            -- 获取鼠标在滑块上的位置
            local mousePos = UIS:GetMouseLocation()
            local sliderAbsPos = ForceSlider.AbsolutePosition
            local sliderAbsSize = ForceSlider.AbsoluteSize

            -- 计算滑块手柄位置（限制在0-1范围内）
            local handleX = math.clamp((mousePos.X - sliderAbsPos.X) / sliderAbsSize.X, 0, 1)
            SliderHandle.Position = UDim2.new(handleX, 0, 0, -1)

            -- 计算对应力度（范围200-1800）
            FlingForce = math.floor(200 + handleX * 1600)
            ForceLabel.Text = "甩飞力度：" .. FlingForce
        end
    end)

    -- 4. 执行甩飞逻辑
    local function flingTarget()
        if not TargetPlayer then
            warn("未选择目标玩家！")
            return
        end

        -- 检查目标角色是否存在
        local targetChar = TargetPlayer.Character
        if not targetChar then
            warn("目标玩家角色未加载！")
            return
        end

        -- 检查目标HumanoidRootPart
        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
        if not targetHRP then
            warn("目标角色缺少HumanoidRootPart！")
            return
        end

        -- 计算最终甩飞力（方向归一化+力度缩放）
        local finalForce = FlingDirection.Unit * FlingForce
        -- 施加脉冲力（甩飞核心）
        targetHRP:ApplyImpulse(finalForce)

        print("已成功甩飞玩家：" .. TargetPlayer.Name .. "（力度：" .. FlingForce .. "）")
    end

    FlingButton.MouseButton1Click:Connect(flingTarget)

    -- 5. 关闭UI
    CloseButton.MouseButton1Click:Connect(function()
        FlingUI:Destroy()
        FlingUI = nil
    end)
end

-- ====================== 启动UI ======================
-- 执行此函数创建并显示甩飞工具UI
createFlingUI()
print("玩家甩飞工具已加载，UI已显示！")