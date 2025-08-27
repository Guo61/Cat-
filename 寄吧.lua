local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

local Window = Library:Window({
    Title = "Cat Hub",
    Desc = "需要时开启反挂机",
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

local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(0, 140, 0, 0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Name = "SidebarLine"
SidebarLine.Parent = game:GetService("CoreGui")

-- 从99夜.lua移植的核心功能
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()

local Features = {
    KillAura = false,
    AutoChop = false,
    AutoEat = false,
    ChildESP = false,
    ChestESP = false,
    InstantInteract = false
}

local Blacklist = {}

local ClientModule
local EatRemote
local function GetClientModule()
    if not ClientModule then
        ClientModule = require(LP:WaitForChild("PlayerScripts"):WaitForChild("Client"))
        EatRemote = ClientModule and ClientModule.Events and ClientModule.Events.RequestConsumeItem
    end
    return ClientModule, EatRemote
end

local function AddESP(target, name, distance, enabled)
    local rootPart = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")
    if not rootPart then return end

    local billboard = rootPart:FindFirstChild("BillboardGui") or Instance.new("BillboardGui")
    billboard.Adornee = rootPart
    billboard.Size = UDim2.new(0, 100, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = enabled
    billboard.Parent = rootPart

    if not billboard:FindFirstChild("TextLabel") then
        local label = Instance.new("TextLabel")
        label.Text = name .. "\n" .. math.floor(distance) .. "m"
        label.Size = UDim2.new(1, 0, 0, 40)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0.3
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Parent = billboard
        
        if name:match("Chest") then
            local image = Instance.new("ImageLabel")
            image.Position = UDim2.new(0, 20, 0, 40)
            image.Size = UDim2.new(0, 60, 0, 60)
            image.Image = "rbxassetid://18660563116"
            image.BackgroundTransparency = 1
            image.Parent = billboard
        end
    else
        billboard.TextLabel.Text = name .. "\n" .. math.floor(distance) .. "m"
    end
end

local function TryEatFood(food)
    local _, remote = GetClientModule()
    if not remote then 
        return false
    end

    if not ReplicatedStorage:FindFirstChild("TempStorage") then
        return false
    end

    food.Parent = ReplicatedStorage.TempStorage
    local success, result = pcall(function()
        return remote:InvokeServer(food)
    end)

    return success and result and result.Success
end

local itemConfig = {
    {name = "Log", display = "木头", espColor = Color3.fromRGB(139, 69, 19)},
    {name = "Carrot", display = "胡萝卜", espColor = Color3.fromRGB(255, 165, 0)},
    {name = "Berry", display = "浆果", espColor = Color3.fromRGB(255, 0, 0)},
    {name = "Bolt", display = "螺栓", espColor = Color3.fromRGB(255, 255, 0)},
    {name = "Broken Fan", display = "风扇", espColor = Color3.fromRGB(100, 100, 100)},
    {name = "Coal", display = "煤炭", espColor = Color3.fromRGB(0, 0, 0)},
    {name = "Coin Stack", display = "钱堆", espColor = Color3.fromRGB(255, 215, 0)},
    {name = "Fuel Canister", display = "燃料罐", espColor = Color3.fromRGB(255, 50, 50)},
    {name = "Item Chest", display = "宝箱", espColor = Color3.fromRGB(210, 180, 140)},
    {name = "Old Flashlight", display = "手电筒", espColor = Color3.fromRGB(200, 200, 200)},
    {name = "Old Radio", display = "收音机", espColor = Color3.fromRGB(150, 150, 150)},
    {name = "Rifle Ammo", display = "步枪子弹", espColor = Color3.fromRGB(150, 75, 0)},
    {name = "Revolver Ammo", display = "左轮子弹", espColor = Color3.fromRGB(150, 75, 0)},
    {name = "Sheet Metal", display = "金属板", espColor = Color3.fromRGB(192, 192, 192)},
    {name = "Revolver", display = "左轮", espColor = Color3.fromRGB(75, 75, 75)},
    {name = "Rifle", display = "步枪", espColor = Color3.fromRGB(75, 75, 75)},
    {name = "Bandage", display = "绷带", espColor = Color3.fromRGB(255, 240, 245)},
    {name = "Crossbow Cultist", display = "敌人", espColor = Color3.fromRGB(255, 0, 0)},
    {name = "Bear", display = "熊", espColor = Color3.fromRGB(139, 69, 19)},
    {name = "Alpha Wolf", display = "阿尔法狼", espColor = Color3.fromRGB(128, 128, 128)},
    {name = "Wolf", display = "狼", espColor = Color3.fromRGB(192, 192, 192)},
    {name = "Chair", display = "椅子", espColor = Color3.fromRGB(160, 82, 45)},
    {name = "Tyre", display = "轮胎", espColor = Color3.fromRGB(20, 20, 20)},
    {name = "Alien Chest", display = "外星宝箱", espColor = Color3.fromRGB(0, 255, 0)},
    {name = "Chest", display = "宝箱", espColor = Color3.fromRGB(210, 180, 140)},
    {name = "Lost Child", display = "走失的孩子", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Lost Child1", display = "走失的孩子1", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Lost Child2", display = "走失的孩子2", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Lost Child3", display = "走失的孩子3", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Dino Kid", display = "恐龙孩子", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "kraken kid", display = "海怪孩子", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Squid kid", display = "鱿鱼孩子", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Koala Kid", display = "考拉孩子", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "koala", display = "考拉", espColor = Color3.fromRGB(0, 255, 255)}
}

local BONFIRE_POSITION = Vector3.new(0.189, 7.831, -0.341)

local function findItems(itemName)
    local found = {}
    local folders = {"ltems", "Items", "MapItems", "WorldItems"}
    
    for _, folderName in ipairs(folders) do
        local folder = workspace:FindFirstChild(folderName)
        if folder then
            for _, item in ipairs(folder:GetDescendants()) do
                if item.Name == itemName and item:IsA("Model") then
                    local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart")
                    if primaryPart then
                        table.insert(found, {model = item, part = primaryPart})
                    end
                end
            end
        end
    end
    
    return found
end

local function teleportToItem(itemName, displayName)
    local character = Character
    if not character then return end
    
    local items = findItems(itemName)
    if #items == 0 then
        return
    end
    
    local closest = nil
    local minDist = math.huge
    local charPos = character.PrimaryPart.Position
    
    for _, item in ipairs(items) do
        local dist = (item.part.Position - charPos).Magnitude
        if dist < minDist then
            minDist = dist
            closest = item.part
        end
    end
    
    if closest then
        character:MoveTo(closest.Position + Vector3.new(0, 3, 0))
    end
end

local function teleportToBonfire()
    local character = Character
    if not character then return end
    
    character:MoveTo(BONFIRE_POSITION)
end

local function teleportItemsToPlayer(itemName, displayName)
    local character = Character
    if not character then return end
    
    local items = findItems(itemName)
    if #items == 0 then
        return
    end
    
    local charPos = character.PrimaryPart.Position
    local radius = 5
    local angleStep = (2 * math.pi) / #items
    
    for i, item in ipairs(items) do
        local angle = angleStep * i
        local x = math.cos(angle) * radius
        local z = math.sin(angle) * radius
        local targetPos = charPos + Vector3.new(x, 0, z)
        
        if item.model:FindFirstChild("Handle") then
            item.model.Handle.CFrame = CFrame.new(targetPos)
        elseif item.part then
            item.part.CFrame = CFrame.new(targetPos)
        end
    end
end

local function toggleESP(itemName, displayName, color)
    if _G["ESP_"..itemName] then
        for _, gui in ipairs(_G["ESP_"..itemName].guis) do
            gui:Destroy()
        end
        _G["ESP_"..itemName].conn:Disconnect()
        _G["ESP_"..itemName] = nil
        return
    end
    
    local items = findItems(itemName)
    _G["ESP_"..itemName] = {guis = {}}
    
    local function createESP(itemPart)
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = itemPart
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = 300
        
        local text = Instance.new("TextLabel")
        text.Text = displayName
        text.Size = UDim2.new(1, 0, 1, 0)
        text.Font = Enum.Font.SourceSansBold
        text.TextSize = 18
        text.TextColor3 = color
        text.BackgroundTransparency = 1
        text.TextStrokeTransparency = 0.5
        text.TextStrokeColor3 = Color3.new(0, 0, 0)
        text.Parent = billboard
        
        billboard.Parent = itemPart
        table.insert(_G["ESP_"..itemName].guis, billboard)
    end
    
    for _, item in ipairs(items) do
        createESP(item.part)
    end
    
    _G["ESP_"..itemName].conn = workspace.DescendantAdded:Connect(function(descendant)
        if descendant.Name == itemName and descendant:IsA("Model") then
            local primaryPart = descendant.PrimaryPart or descendant:FindFirstChild("HumanoidRootPart")
            if primaryPart then
                createESP(primaryPart)
            end
        end
    end)
end

-- 自动功能主循环
local lastKillAura, lastAutoChop, lastAutoEat = 0, 0, 0
local connection
RunService.Heartbeat:Connect(function()
    local now = tick()
    
    -- 瞬间互动
    if Features.InstantInteract then
        if not connection then
            connection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                prompt.HoldDuration = 0
            end)
        end
    else
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end

    -- 杀戮光环
    if Features.KillAura and now - lastKillAura >= 0.7 then
        lastKillAura = now
        if Character and Character:FindFirstChild("ToolHandle") then
            local tool = Character.ToolHandle.OriginalItem.Value
            if tool and ({["Old Axe"] = true, ["Good Axe"] = true, ["Spear"] = true, ["Hatchet"] = true, ["Bone Club"] = true})[tool.Name] then
                for _, target in next, Workspace.Characters:GetChildren() do
                    if target:IsA("Model") and target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("HitRegisters") then
                        if (Character.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude <= 100 then
                            ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject"):InvokeServer(target, tool, true, Character.HumanoidRootPart.CFrame)
                        end
                    end
                end
            end
        end
    end

    -- 自动砍树
    if Features.AutoChop and now - lastAutoChop >= 0.7 then
        lastAutoChop = now
        if Character and Character:FindFirstChild("ToolHandle") then
            local tool = Character.ToolHandle.OriginalItem.Value
            if tool and ({["Old Axe"] = true, ["Stone Axe"] = true, ["Iron Axe"] = true})[tool.Name] then
                local function ChopTree(path)
                    for _, tree in next, path:GetChildren() do
                        task.wait(.1)
                        if tree:IsA("Model") and ({["Small Tree"] = true, ["TreeBig1"] = true, ["TreeBig2"] = true, ["TreeBig3"] = true})[tree.Name] and tree:FindFirstChild("HitRegisters") then
                            local trunk = tree:FindFirstChild("Trunk") or tree:FindFirstChild("HumanoidRootPart") or tree.PrimaryPart
                            if trunk and (Character.HumanoidRootPart.Position - trunk.Position).Magnitude <= 100 then
                                ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject"):InvokeServer(tree, tool, true, Character.HumanoidRootPart.CFrame)
                            end
                        end
                    end
                end
                ChopTree(Workspace.Map.Foliage)
                ChopTree(Workspace.Map.Landmarks)
            end
        end
    end

    -- 自动进食
    if Features.AutoEat and now - lastAutoEat >= 10 then
        lastAutoEat = now
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in pairs(Workspace.Items:GetChildren()) do
                if obj:IsA("Model") and ({["Carrot"] = true, ["Berry"] = true, ["Morsel"] = false, ["Cooked Morsel"] = true, ["Steak"] = false, ["Cooked Steak"] = true})[obj.Name] then
                    local mainPart = obj:FindFirstChild("Handle") or obj.PrimaryPart
                    if mainPart and (mainPart.Position - Character.HumanoidRootPart.Position).Magnitude < 25 then
                        TryEatFood(obj)
                        break
                    end
                end
            end
        end
    end

    -- ESP更新
    if Features.ChestESP then
        for _, chest in next, Workspace.Items:GetChildren() do
            if chest.Name:match("Chest") and chest:IsA("Model") and not table.find(Blacklist, chest) and chest:FindFirstChild("Main") then
                AddESP(chest, "宝箱", (Character.HumanoidRootPart.Position - chest.Main.Position).Magnitude, true)
            end
        end
    end

    if Features.ChildESP then
        for _, child in next, Workspace.Characters:GetChildren() do
            if table.find({"Lost Child", "Lost Child1", "Lost Child2", "Lost Child3", "Dino Kid", "kraken kid", "Squid kid", "Koala Kid", "koala"}, child.Name) 
               and child:FindFirstChild("HumanoidRootPart") and not table.find(Blacklist, child) then
                AddESP(child, "孩子", (Character.HumanoidRootPart.Position - child.HumanoidRootPart.Position).Magnitude, true)
            end
        end
    end
end)

-- 玩家列表管理
local PlayerList = {}
local function UpdatePlayerList()
    PlayerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(PlayerList, player.Name)
    end
end

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
UpdatePlayerList()

-- 原有的CatHub UI代码
local Tab = Window:Tab({Title = "主页", Icon = "star"}) do
    Tab:Section({Title = "By Ccat\n脚本免费 请勿倒卖"})

    -- 原有的按钮功能保持不变...
    Tab:Button({  
        Title = "反挂机",  
        Desc = "不要随意开启!",  
        Description = "从Github加载并执行反挂机",  
        Callback = function()  
            Window:Notify({  
                Title = "Cat Hub",  
                Desc = "正在加载反挂机脚本...",  
                Time = 3  
            })  
            -- ... 原有代码
        end  
    })

    -- 添加99夜功能按钮
    Tab:Section({Title = "99夜功能"})

    Tab:Toggle({
        Title = "杀戮光环",
        Desc = "自动攻击附近敌人",
        Default = false,
        Callback = function(value)
            Features.KillAura = value
        end
    })

    Tab:Toggle({
        Title = "自动砍树",
        Desc = "自动砍伐附近树木",
        Default = false,
        Callback = function(value)
            Features.AutoChop = value
        end
    })

    Tab:Toggle({
        Title = "自动进食",
        Desc = "自动吃附近食物",
        Default = false,
        Callback = function(value)
            Features.AutoEat = value
        end
    })

    Tab:Toggle({
        Title = "瞬间互动",
        Desc = "立即完成所有互动",
        Default = false,
        Callback = function(value)
            Features.InstantInteract = value
        end
    })

    Tab:Toggle({
        Title = "宝箱透视",
        Desc = "显示宝箱位置",
        Default = false,
        Callback = function(value)
            Features.ChestESP = value
        end
    })

    Tab:Toggle({
        Title = "孩子透视",
        Desc = "显示走失的孩子位置",
        Default = false,
        Callback = function(value)
            Features.ChildESP = value
        end
    })

    Tab:Button({
        Title = "传送回篝火",
        Desc = "返回安全位置",
        Callback = teleportToBonfire
    })

    -- 物品传送按钮
    for _, item in ipairs(itemConfig) do
        if item.display then
            Tab:Button({
                Title = "传送到"..item.display,
                Callback = function()
                    teleportToItem(item.name, item.display)
                end
            })
        end
    end

    -- 物品召唤按钮
    for _, item in ipairs(itemConfig) do
        if item.display then
            Tab:Button({
                Title = "召唤"..item.display,
                Callback = function()
                    teleportItemsToPlayer(item.name, item.display)
                end
            })
        end
    end

    -- 物品透视按钮
    for _, item in ipairs(itemConfig) do
        if item.display then
            Tab:Button({
                Title = item.display.."透视",
                Callback = function()
                    toggleESP(item.name, item.display, item.espColor)
                end
            })
        end
    end

    Tab:Button({
        Title = "清除所有透视",
        Callback = function()
            for _, item in ipairs(itemConfig) do
                if _G["ESP_"..item.name] then
                    for _, gui in ipairs(_G["ESP_"..item.name].guis) do
                        gui:Destroy()
                    end
                    _G["ESP_"..item.name].conn:Disconnect()
                    _G["ESP_"..item.name] = nil
                end
            end
        end
    })
end

-- 原有的其他标签页代码保持不变...
local Extra = Window:Tab({Title = "极速传奇", Icon = "zap"}) do
    -- ... 原有代码
end

local Extra = Window:Tab({Title = "99夜", Icon = "105059922903197"}) do
    Extra:Section({Title = "传送"})
    Extra:Button({
        Title = "篝火",
        Desc = "单击以执行",
        Callback = teleportToBonfire
    })
end

Window:Notify({
    Title = "Cat Hub",
    Desc = "感谢您的游玩",
    Time = 5
})