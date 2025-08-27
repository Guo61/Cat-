local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- 配置设置
local settings = {
    Enabled = true,
    AutoMovement = true,
    AutoCamera = true,
    RandomActions = true,
    HumanLikeDelay = true,
    DetectionAvoidance = true,
    
    -- 行为参数
    MovementInterval = {min = 15, max = 45}, -- 移动间隔(秒)
    CameraMoveInterval = {min = 5, max = 20}, -- 相机移动间隔(秒)
    ActionInterval = {min = 30, max = 120}, -- 随机动作间隔(秒)
    
    -- 移动参数
    MoveDistance = {min = 2, max = 8}, -- 移动距离
    MoveDuration = {min = 0.5, max = 2.0}, -- 移动持续时间
    
    -- 相机参数
    CameraAngle = {min = 5, max = 30}, -- 相机转动角度
    CameraDuration = {min = 0.3, max = 1.5}, -- 相机转动持续时间
}

-- 状态变量
local isActive = true
local lastMovementTime = 0
local lastCameraTime = 0
local lastActionTime = 0
local currentTargetPosition = nil

-- 获取随机值
local function getRandom(min, max)
    return math.random() * (max - min) + min
end

-- 获取随机延迟
local function getRandomDelay()
    if settings.HumanLikeDelay then
        return getRandom(0.1, 0.5) * math.random(1, 3)
    end
    return 0
end

-- 模拟人类移动
local function simulateHumanMovement()
    if not settings.AutoMovement or not isActive then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not humanoidRootPart then return end
    
    -- 随机移动方向
    local angle = math.random() * 2 * math.pi
    local distance = getRandom(settings.MoveDistance.min, settings.MoveDistance.max)
    local duration = getRandom(settings.MoveDuration.min, settings.MoveDuration.max)
    
    local moveDirection = Vector3.new(
        math.cos(angle) * distance,
        0,
        math.sin(angle) * distance
    )
    
    currentTargetPosition = humanoidRootPart.Position + moveDirection
    
    -- 模拟移动输入
    humanoid:MoveTo(currentTargetPosition)
    
    -- 随机延迟后停止
    delay(duration + getRandomDelay(), function()
        if humanoid and humanoid.Parent then
            humanoid:MoveTo(humanoidRootPart.Position)
        end
        currentTargetPosition = nil
    end)
end

-- 模拟相机移动
local function simulateCameraMovement()
    if not settings.AutoCamera or not isActive then return end
    
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    -- 随机相机转动
    local angleX = getRandom(-settings.CameraAngle.max, settings.CameraAngle.max)
    local angleY = getRandom(-settings.CameraAngle.max, settings.CameraAngle.max)
    local duration = getRandom(settings.CameraDuration.min, settings.CameraDuration.max)
    
    -- 平滑转动相机
    local startCFrame = camera.CFrame
    local endCFrame = startCFrame * CFrame.Angles(
        math.rad(angleX),
        math.rad(angleY),
        0
    )
    
    local startTime = tick()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        if elapsed >= duration then
            connection:Disconnect()
            return
        end
        
        local alpha = elapsed / duration
        camera.CFrame = startCFrame:Lerp(endCFrame, alpha)
    end)
end

-- 模拟随机动作
local function simulateRandomAction()
    if not settings.RandomActions or not isActive then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- 随机动作类型
    local actions = {
        "Jump",
        "Sit",
        "Wave",
        "Dance",
        "Point"
    }
    
    local randomAction = actions[math.random(#actions)]
    
    -- 执行动作
    if randomAction == "Jump" and humanoid.FloorMaterial ~= Enum.Material.Air then
        humanoid.Jump = true
    elseif randomAction == "Sit" then
        humanoid.Sit = not humanoid.Sit
    end
end

-- 检测反检测系统
local function avoidDetection()
    if not settings.DetectionAvoidance or not isActive then return end
    
    -- 随机变化行为模式
    if math.random() < 0.3 then
        settings.MovementInterval = {
            min = math.random(10, 25),
            max = math.random(35, 60)
        }
        
        settings.CameraMoveInterval = {
            min = math.random(3, 15),
            max = math.random(18, 35)
        }
    end
end

-- 主循环
local function mainLoop()
    while isActive and settings.Enabled do
        local currentTime = tick()
        
        -- 移动检测
        if currentTime - lastMovementTime > getRandom(settings.MovementInterval.min, settings.MovementInterval.max) then
            simulateHumanMovement()
            lastMovementTime = currentTime
        end
        
        -- 相机移动检测
        if currentTime - lastCameraTime > getRandom(settings.CameraMoveInterval.min, settings.CameraMoveInterval.max) then
            simulateCameraMovement()
            lastCameraTime = currentTime
        end
        
        -- 随机动作检测
        if currentTime - lastActionTime > getRandom(settings.ActionInterval.min, settings.ActionInterval.max) then
            simulateRandomAction()
            lastActionTime = currentTime
        end
        
        -- 反检测
        avoidDetection()
        
        wait(getRandom(1, 3)) -- 随机等待
    end
end

-- 真实玩家输入处理（覆盖自动化）
local function onRealInput()
    lastMovementTime = tick()
    lastCameraTime = tick()
    lastActionTime = tick()
end

-- 绑定真实输入事件
UserInputService.InputBegan:Connect(onRealInput)
mouse.Move:Connect(onRealInput)

-- GUI控制界面
local function createControlGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AntiAntiAFK_GUI"
    screenGui.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 150)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "防检测系统"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    title.Parent = frame
    
    -- 启用/禁用开关
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.8, 0, 0, 25)
    toggleButton.Position = UDim2.new(0.1, 0, 0.25, 0)
    toggleButton.Text = settings.Enabled and "已启用 ✓" or "已禁用 ✗"
    toggleButton.TextColor3 = settings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggleButton.Parent = frame
    
    toggleButton.MouseButton1Click:Connect(function()
        settings.Enabled = not settings.Enabled
        toggleButton.Text = settings.Enabled and "已启用 ✓" or "已禁用 ✗"
        toggleButton.TextColor3 = settings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        isActive = settings.Enabled
        if settings.Enabled then
            coroutine.wrap(mainLoop)()
        end
    end)
    
    -- 状态显示
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.8, 0, 0, 20)
    statusLabel.Position = UDim2.new(0.1, 0, 0.55, 0)
    statusLabel.Text = "状态: 运行中"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Parent = frame
    
    -- 关闭按钮
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.3, 0, 0, 20)
    closeButton.Position = UDim2.new(0.35, 0, 0.75, 0)
    closeButton.Text = "隐藏"
    closeButton.Parent = frame
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
    end)
end

-- 初始化
player.CharacterAdded:Connect(function()
    if settings.Enabled then
        coroutine.wrap(mainLoop)()
    end
end)

-- 创建控制界面
if player.PlayerGui then
    createControlGUI()
else
    player:WaitForChild("PlayerGui")
    createControlGUI()
end

-- 启动主循环
if settings.Enabled then
    coroutine.wrap(mainLoop)()
end

print("防反挂机检测系统已加载")