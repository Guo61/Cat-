-- 防反挂机脚本 by GitHub
local P,U,R=game:GetService('Players'),game:GetService('UserInputService'),game:GetService('RunService')
local p,m=P.LocalPlayer,P:GetMouse()
local settings={Enabled=true,AutoMove=true,AutoCamera=true}
local isActive,lastMoveTime=true,0

local function random(min,max)return math.random()*(max-min)+min end

local function simulateMovement()
    if not settings.Enabled or not isActive then return end
    local char=p.Character if not char then return end
    local humanoid=char:FindFirstChild('Humanoid')
    local rootPart=char:FindFirstChild('HumanoidRootPart')
    if humanoid and rootPart then
        local angle=math.random()*2*math.pi
        local distance=random(2,8)
        local direction=Vector3.new(math.cos(angle)*distance,0,math.sin(angle)*distance)
        humanoid:MoveTo(rootPart.Position+direction)
        delay(random(0.5,2),function()
            if humanoid and humanoid.Parent then
                humanoid:MoveTo(rootPart.Position)
            end
        end)
    end
end

local function simulateCamera()
    if not settings.Enabled then return end
    local cam=workspace.CurrentCamera
    if cam then
        local xAngle=random(-25,25)
        local yAngle=random(-25,25)
        cam.CFrame=cam.CFrame*CFrame.Angles(math.rad(xAngle),math.rad(yAngle),0)
    end
end

local function onRealInput()
    lastMoveTime=tick()
end

U.InputBegan:Connect(onRealInput)
m.Move:Connect(onRealInput)

while wait() do
    if settings.Enabled and isActive then
        local currentTime=tick()
        if currentTime-lastMoveTime>random(20,60) and settings.AutoMove then
            simulateMovement()
            lastMoveTime=currentTime
        end
        if math.random()<0.4 and settings.AutoCamera then
            simulateCamera()
        end
    end
    wait(random(2,8))
end

return settings