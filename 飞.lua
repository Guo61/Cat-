-- 飞行控制脚本
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- 飞行相关变量
local isFlying = false
local flySpeed = 15
local riseSpeed = 8
local fallSpeed = 5

-- 创建飞行控制的 BodyVelocity 和 BodyGyro
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
bodyVelocity.Velocity = Vector3.new(0, 0, 0)
bodyVelocity.Parent = rootPart

local bodyGyro = Instance.new("BodyGyro")
bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
bodyGyro.CFrame = rootPart.CFrame
bodyGyro.Parent = rootPart

-- 输入控制变量
local moveDirection = Vector3.new(0, 0, 0)
local isRising = false
local isFalling = false

-- 处理键盘输入
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then
        return
    end

    if input.KeyCode == Enum.KeyCode.E then
        isRising = true
    elseif input.KeyCode == Enum.KeyCode.Q then
        isFalling = true
    elseif input.KeyCode == Enum.KeyCode.F then
        -- 切换飞行状态
        isFlying = not isFlying
        if isFlying then
            -- 进入飞行模式，禁用重力
            humanoid.PlatformStand = true
            bodyVelocity.Enabled = true
            bodyGyro.Enabled = true
        else
            -- 退出飞行模式，启用重力
            humanoid.PlatformStand = false
            bodyVelocity.Enabled = false
            bodyGyro.Enabled = false
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then
        return
    end

    if input.KeyCode == Enum.KeyCode.E then
        isRising = false
    elseif input.KeyCode == Enum.KeyCode.Q then
        isFalling = false
    end
end)

-- 处理移动方向输入
UserInputService.InputChanged:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement then
        -- 这里可以添加鼠标控制方向的逻辑，比如旋转人物朝向
        -- 简化起见，暂时不实现
    end
end)

-- 运行时循环，处理飞行逻辑
RunService.RenderStepped:Connect(function()
    if not isFlying then
        return
    end

    -- 获取移动方向
    local forward = 0
    local backward = 0
    local left = 0
    local right = 0

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        forward = 1
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        backward = 1
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        left = 1
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        right = 1
    end

    -- 计算移动的方向向量
    local camera = workspace.CurrentCamera
    local cameraCFrame = camera.CFrame
    local lookVector = cameraCFrame.LookVector
    local rightVector = cameraCFrame.RightVector

    moveDirection = (lookVector * (forward-backward) + rightVector * (right-left)).Unit

    -- 处理上升和下降
    local verticalVelocity = 0
    if isRising then
        verticalVelocity = riseSpeed
    elseif isFalling then
        verticalVelocity = -fallSpeed
    end

    -- 设置 BodyVelocity 的速度
    bodyVelocity.Velocity = moveDirection * flySpeed + Vector3.new(0, verticalVelocity, 0)

    -- 设置 BodyGyro 的朝向为相机朝向
    bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + lookVector)
end)