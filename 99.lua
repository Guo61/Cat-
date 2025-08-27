-- 加载 CatHub UI 框架（仅用UI结构，剔除原有功能）
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

-- 初始化 99夜 核心服务与变量
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()
local Features = { -- 功能开关状态
    KillAura = false,
    AutoChop = false,
    AutoEat = false,
    ChildESP = false,
    ChestESP = false,
    InstantInteract = false
}
local BONFIRE_POSITION = Vector3.new(0.189, 7.831, -0.341) -- 固定篝火位置
local itemConfig = { -- 物品配置表（名称/显示名/ESP颜色）
    {name = "Log", display = "木头", espColor = Color3.fromRGB(139, 69, 19)},
    {name = "Carrot", display = "胡萝卜", espColor = Color3.fromRGB(255, 165, 0)},
    {name = "Berry", display = "浆果", espColor = Color3.fromRGB(255, 0, 0)},
    {name = "Chest", display = "普通宝箱", espColor = Color3.fromRGB(210, 180, 140)},
    {name = "Alien Chest", display = "外星宝箱", espColor = Color3.fromRGB(0, 255, 0)},
    {name = "Lost Child", display = "走失孩子", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Dino Kid", display = "恐龙孩子", espColor = Color3.fromRGB(0, 255, 255)},
    {name = "Crossbow Cultist", display = "敌人", espColor = Color3.fromRGB(255, 0, 0)},
    {name = "Bear", display = "熊", espColor = Color3.fromRGB(139, 69, 19)},
    {name = "Wolf", display = "狼", espColor = Color3.fromRGB(192, 192, 192)}
}

-- ====================== 99夜 核心工具函数 ======================
-- 1. 获取客户端模块与进食远程函数
local function GetClientModule()
    local ClientModule = require(LP:WaitForChild("PlayerScripts"):WaitForChild("Client"))
    local EatRemote = ClientModule.Events.RequestConsumeItem
    return ClientModule, EatRemote
end

-- 2. 查找地图物品（支持传送/ESP/召唤）
local function FindMapItems(itemName)
    local found = {}
    local itemFolders = {Workspace:FindFirstChild("Items"), Workspace:FindFirstChild("MapItems")}
    for _, folder in ipairs(itemFolders) do
        if folder then
            for _, item in ipairs(folder:GetDescendants()) do
                if item.Name == itemName and item:IsA("Model") then
                    local part = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart")
                    if part then table.insert(found, {model = item, part = part}) end
                end
            end
        end
    end
    return found
end

-- 3. 自动进食逻辑
local function AutoEat()
    local _, EatRemote = GetClientModule()
    local Inventory = LP:FindFirstChild("Inventory")
    if not Inventory or not EatRemote then return end

    -- 优先吃浆果/胡萝卜（恢复饥饿）
    for _, foodName in ipairs({"Berry", "Carrot"}) do
        local food = Inventory:FindFirstChild(foodName)
        if food then
            food.Parent = ReplicatedStorage.TempStorage
            local success = pcall(function() EatRemote:InvokeServer(food) end)
            if success then
                Library:Notify({Title = "99夜", Desc = "✅ 已吃"..foodName, Time = 3})
            end
            return
        end
    end
end

-- 4. 杀戮光环逻辑（自动攻击范围内敌人）
local function KillAura()
    local ToolHandle = Character:FindFirstChild("ToolHandle")
    if not ToolHandle then return end
    local Tool = ToolHandle.OriginalItem.Value
    local ValidTools = {"Spear", "Old Axe", "Bone Club"} -- 有效武器列表
    if not table.find(ValidTools, Tool.Name) then return end

    -- 攻击100范围内敌人
    for _, Enemy in ipairs(Workspace.Characters:GetChildren()) do
        local EnemyRoot = Enemy:FindFirstChild("HumanoidRootPart")
        local EnemyHumanoid = Enemy:FindFirstChild("Humanoid")
        if EnemyRoot and EnemyHumanoid and EnemyHumanoid.Health > 0 then
            local Dist = (Character.HumanoidRootPart.Position - EnemyRoot.Position).Magnitude
            if Dist <= 100 then
                ReplicatedStorage.RemoteEvents.ToolDamageObject:InvokeServer(Enemy, Tool, true, Character.HumanoidRootPart.CFrame)
            end
        end
    end
end

-- 5. 自动砍树逻辑
local function AutoChop()
    local ToolHandle = Character:FindFirstChild("ToolHandle")
    if not ToolHandle then return end
    local Tool = ToolHandle.OriginalItem.Value
    if Tool.Name ~= "Old Axe" and Tool.Name ~= "Stone Axe" then return end

    -- 砍100范围内树木
    for _, Tree in ipairs(Workspace.Trees:GetChildren()) do
        local TreePart = Tree:FindFirstChild("Trunk") or Tree.PrimaryPart
        if TreePart then
            local Dist = (Character.HumanoidRootPart.Position - TreePart.Position).Magnitude
            if Dist <= 100 then
                ReplicatedStorage.RemoteEvents.ToolDamageObject:InvokeServer(Tree, Tool, true, Character.HumanoidRootPart.CFrame)
            end
        end
    end
end

-- 6. ESP生成函数（支持宝箱/孩子/敌人）
local function CreateESP(target, displayName, color)
    local RootPart = target.PrimaryPart or target:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end

    -- 创建BillboardGui
    local Billboard = Instance.new("BillboardGui")
    Billboard.Adornee = RootPart
    Billboard.Size = UDim2.new(0, 120, 0, 50)
    Billboard.StudsOffset = Vector3.new(0, 2, 0)
    Billboard.AlwaysOnTop = true
    Billboard.MaxDistance = 300

    -- 文字标签
    local Text = Instance.new("TextLabel")
    Text.Text = displayName
    Text.Size = UDim2.new(1, 0, 1, 0)
    Text.TextColor3 = color
    Text.BackgroundTransparency = 1
    Text.Font = Enum.Font.GothamBold
    Text.TextSize = 16
    Text.TextStrokeTransparency = 0.5
    Text.TextStrokeColor3 = Color3.new(0, 0, 0)
    Text.Parent = Billboard

    Billboard.Parent = RootPart
    return Billboard
end

-- 7. 批量ESP开关（按类型控制）
local function ToggleBatchESP(typeKey, displayType, targetNames, color)
    if Features[typeKey] then -- 关闭ESP
        for _, name in ipairs(targetNames) do
            for _, item in ipairs(FindMapItems(name)) do
                local Billboard = item.part:FindFirstChild("BillboardGui")
                if Billboard then Billboard:Destroy() end
            end
        end
        Features[typeKey] = false
        Library:Notify({Title = "99夜", Desc = "❌ 关闭"..displayType.."ESP", Time = 3})
    else -- 开启ESP
        for _, name in ipairs(targetNames) do
            for _, item in ipairs(FindMapItems(name)) do
                CreateESP(item.model, displayType.."("..name..")", color)
            end
        end
        Features[typeKey] = true
        Library:Notify({Title = "99夜", Desc = "✅ 开启"..displayType.."ESP", Time = 3})
    end
end

-- 8. 传送功能（传送到物品/篝火）
local function TeleportTo(targetType, targetName)
    local CharacterRoot = Character:FindFirstChild("HumanoidRootPart")
    if not CharacterRoot then return end

    if targetType == "Bonfire" then -- 传篝火
        Character:MoveTo(BONFIRE_POSITION)
        Library:Notify({Title = "99夜", Desc = "✅ 已传送到篝火", Time = 3})
        return
    end

    -- 传送到物品
    local Items = FindMapItems(targetName)
    if #Items == 0 then
        Library:Notify({Title = "99夜", Desc = "❌ 未找到"..targetName, Time = 3})
        return
    end
    -- 找最近的物品
    local ClosestItem = Items[1]
    local MinDist = (CharacterRoot.Position - Items[1].part.Position).Magnitude
    for _, item in ipairs(Items) do
        local Dist = (CharacterRoot.Position - item.part.Position).Magnitude
        if Dist < MinDist then
            MinDist = Dist
            ClosestItem = item
        end
    end
    Character:MoveTo(ClosestItem.part.Position + Vector3.new(0, 2, 0))
    Library:Notify({Title = "99夜", Desc = "✅ 已传送到"..targetName, Time = 3})
end

-- ====================== CatHub UI 集成 99夜 功能 ======================
-- 1. 创建主窗口
local MainWindow = Library:CreateWindow({
    Title = "99夜 辅助",
    Center = true,
    Size = UDim2.new(0, 500, 0, 400)
})

-- 2. 自动功能标签页
local AutoTab = MainWindow:AddTab("自动功能")
-- 杀戮光环开关
AutoTab:AddToggle({
    Text = "杀戮光环（自动攻击敌人）",
    Default = false,
    Callback = function(state)
        Features.KillAura = state
        local tip = state and "✅ 开启杀戮光环" or "❌ 关闭杀戮光环"
        Library:Notify({Title = "99夜", Desc = tip, Time = 3})
    end
})
-- 自动砍树开关
AutoTab:AddToggle({
    Text = "自动砍树（需装备斧头）",
    Default = false,
    Callback = function(state)
        Features.AutoChop = state
        local tip = state and "✅ 开启自动砍树" or "❌ 关闭自动砍树"
        Library:Notify({Title = "99夜", Desc = tip, Time = 3})
    end
})
-- 自动进食开关
AutoTab:AddToggle({
    Text = "自动进食（优先浆果/胡萝卜）",
    Default = false,
    Callback = function(state)
        Features.AutoEat = state
        local tip = state and "✅ 开启自动进食" or "❌ 关闭自动进食"
        Library:Notify({Title = "99夜", Desc = tip, Time = 3})
    end
})
-- 瞬间互动开关（取消长按）
AutoTab:AddToggle({
    Text = "瞬间互动（无需长按提示）",
    Default = false,
    Callback = function(state)
        Features.InstantInteract = state
        local tip = state and "✅ 开启瞬间互动" or "❌ 关闭瞬间互动"
        Library:Notify({Title = "99夜", Desc = tip, Time = 3})
    end
})

-- 3. ESP功能标签页
local ESPTab = MainWindow:AddTab("ESP功能")
-- 孩子ESP（所有孩子类型）
ESPTab:AddButton({
    Text = "孩子ESP 开关",
    Callback = function()
        ToggleBatchESP(
            "ChildESP", 
            "孩子", 
            {"Lost Child", "Dino Kid", "kraken kid", "Squid kid"}, 
            Color3.fromRGB(0, 255, 255)
        )
    end
})
-- 宝箱ESP（普通+外星）
ESPTab:AddButton({
    Text = "宝箱ESP 开关",
    Callback = function()
        ToggleBatchESP(
            "ChestESP", 
            "宝箱", 
            {"Chest", "Alien Chest", "Item Chest"}, 
            Color3.fromRGB(255, 215, 0)
        )
    end
})
-- 敌人ESP（敌人+野兽）
ESPTab:AddButton({
    Text = "敌人ESP 开关",
    Callback = function()
        ToggleBatchESP(
            "EnemyESP", 
            "敌人", 
            {"Crossbow Cultist", "Bear", "Wolf", "Alpha Wolf"}, 
            Color3.fromRGB(255, 0, 0)
        )
    end
})
-- 清除所有ESP
ESPTab:AddButton({
    Text = "清除所有ESP",
    Callback = function()
        for _, item in ipairs(FindMapItems("")) do
            local Billboard = item.part:FindFirstChild("BillboardGui")
            if Billboard then Billboard:Destroy() end
        end
        Library:Notify({Title = "99夜", Desc = "✅ 已清除所有ESP", Time = 3})
    end
})

-- 4. 传送功能标签页
local TeleTab = MainWindow:AddTab("传送功能")
-- 传送到篝火
TeleTab:AddButton({
    Text = "传送到篝火（复活点）",
    Callback = function() TeleportTo("Bonfire") end
})
-- 传送到木头
TeleTab:AddButton({
    Text = "传送到最近木头",
    Callback = function() TeleportTo("Item", "Log") end
})
-- 传送到宝箱
TeleTab:AddButton({
    Text = "传送到最近宝箱",
    Callback = function() TeleportTo("Item", "Chest") end
})
-- 传送到外星宝箱
TeleTab:AddButton({
    Text = "传送到最近外星宝箱",
    Callback = function() TeleportTo("Item", "Alien Chest") end
})

-- 5. 其他功能标签页
local OtherTab = MainWindow:AddTab("其他功能")
-- 召唤木头到身边
OtherTab:AddButton({
    Text = "召唤木头到身边",
    Callback = function()
        local Woods = FindMapItems("Log")
        if #Woods == 0 then
            Library:Notify({Title = "99夜", Desc = "❌ 未找到木头", Time = 3})
            return
        end
        local CharPos = Character.HumanoidRootPart.Position
        -- 围绕玩家生成（避免重叠）
        for i, wood in ipairs(Woods) do
            local Angle = (2 * math.pi / #Woods) * i
            local TargetPos = CharPos + Vector3.new(math.cos(Angle)*5, 0, math.sin(Angle)*5)
            wood.part.CFrame = CFrame.new(TargetPos)
        end
        Library:Notify({Title = "99夜", Desc = "✅ 已召唤"..#Woods.."个木头", Time = 3})
    end
})
-- 清除所有功能（紧急关闭）
OtherTab:AddButton({
    Text = "紧急关闭所有功能",
    Callback = function()
        Features = {KillAura=false, AutoChop=false, AutoEat=false, ChildESP=false, ChestESP=false, InstantInteract=false}
        clearAllESP() -- 调用之前的清除ESP函数
        Library:Notify({Title = "99夜", Desc = "✅ 已关闭所有功能", Time = 3})
    end
})

-- ====================== 功能主循环（实时运行） ======================
-- 瞬间互动逻辑（取消长按）
local InstantConn = nil
RunService.Heartbeat:Connect(function()
    local Now = tick()
    local CharRoot = Character:FindFirstChild("HumanoidRootPart")
    if not CharRoot then return end

    -- 1. 瞬间互动（动态修改长按时间）
    if Features.InstantInteract then
        if not InstantConn then
            InstantConn = ProximityPromptService.PromptButtonHoldBegan:Connect(function(Prompt)
                Prompt.HoldDuration = 0
            end)
        end
    else
        if InstantConn then
            InstantConn:Disconnect()
            InstantConn = nil
        end
    end