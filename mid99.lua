local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Guo61/Cat-/main/main.lua"))()

local Confirmed = false

WindUI:Popup({
    Title = "Cat脚盆 v1.15",
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    Content = "By:Ccat\nQQ群:1061490197 欢迎使用自然灾害",
    Buttons = {
        {
            Title = "进入脚盆。",
            Icon = "arrow-right",
            Callback = function() Confirmed = true end,
            Variant = "Primary",
        }
    }
})

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
        Title = "v1.20",
        Color = Color3.fromHex("#30ff6a")
    })
    Window:Tag({
        Title = "99夜", 
        Color = Color3.fromHex("#315dff")
    })
    local TimeTag = Window:Tag({
        Title = "正在开发更多服务器",
        Color = Color3.fromHex("#000000")
    })
        
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

 Confirmed = true end,
            Variant = "Primary",
        }
    }
})

local Tabs = {
    Main = Window:Tab({ Title = "主页", Icon = "star" }),
    Esp = Window:Tab({ Title = "绘制", Icon = "eye" }),
    Teleport = Window:Tab({ Title = "传送", Icon = "rocket" }),
    Bring = Window:Tab({ Title = "物品吸附", Icon = "package" }),
    Hitbox = Window:Tab({ Title = "透视", Icon = "target" }),
    Player = Window:Tab({ Title = "玩家", Icon = "user" }),
    Misc = Window:Tab({ Title = "杂项", Icon = "file-cog" })
}

Tabs.Main:Label({ Title = "欢迎使用99夜！", Subtitle = "作者：CatHUB" })

local infHungerActive = false
local infHungerThread
Tabs.Main:Toggle({
    Title = "无限饥饿值",
    Default = false,
    Callback = function(state)
        infHungerActive = state
        if state then
            infHungerThread = task.spawn(function()
                local RequestConsumeItem = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestConsumeItem")
                while infHungerActive do
                    local args = { Instance.new("Model", nil) }
                    RequestConsumeItem:InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        else
            if infHungerThread then
                task.cancel(infHungerThread)
                infHungerThread = nil
            end
        end
    end
})


Tabs.Main:Button({
    Title = "自动烤肉",
    Callback = function()
        local campfirePos = Vector3.new(1.87, 4.33, -3.67)
        for _, item in pairs(workspace.Items:GetChildren()) do
            if item:IsA("Model") or item:IsA("BasePart") then
                local name = item.Name:lower()
                if name:find("meat") then
                    local part = item:FindFirstChildWhichIsA("BasePart") or item
                    if part then
                        part.CFrame = CFrame.new(campfirePos + Vector3.new(math.random(-2,2), 0.5, math.random(-2,2)))
                    end
                end
            end
        end
    end
})


local autoTreeFarmActive = false
local autoTreeFarmThread
Tabs.Main:Toggle({
    Title = "自动砍树 (老斧子)",
    Default = false,
    Callback = function(state)
        autoTreeFarmActive = state
        if state then
            autoTreeFarmThread = task.spawn(function()
                local ToolDamageObject = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject")
                local Backpack = LocalPlayer:WaitForChild("Backpack")

                local function getAllTrees()
                    local map = workspace:FindFirstChild("Map")
                    if not map then return {} end
                    local landmarks = map:FindFirstChild("Landmarks") or map:FindFirstChild("Foliage")
                    if not landmarks then return {} end
                    local trees = {}
                    for _, tree in ipairs(landmarks:GetChildren()) do
                        if tree.Name == "Small Tree" and tree:IsA("Model") and tree.Parent then
                            local trunk = tree:FindFirstChild("Trunk") or tree.PrimaryPart
                            if trunk then
                                table.insert(trees, {tree = tree, trunk = trunk})
                            end
                        end
                    end
                    return trees
                end

                local function getAxe()
                    local inv = LocalPlayer:FindFirstChild("Inventory")
                    if not inv then return nil end
                    return inv:FindFirstChild("Old Axe") or inv:FindFirstChildWhichIsA("Tool")
                end

                while autoTreeFarmActive do
                    local trees = getAllTrees()
                    for _, t in ipairs(trees) do
                        if not autoTreeFarmActive then break end
                        if t.tree and t.tree.Parent then
                            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                            local hrp = char:FindFirstChild("HumanoidRootPart", 3)
                            if hrp and t.trunk then
                                local treeCFrame = t.trunk.CFrame
                                local rightVector = treeCFrame.RightVector
                                local targetPosition = treeCFrame.Position + rightVector * 3
                                hrp.CFrame = CFrame.new(targetPosition)
                                task.wait(0.25)
                                local axe = getAxe()
                                if axe then
                                    if axe.Parent == Backpack then
                                        axe.Parent = char
                                        task.wait(0.15)
                                    end
                                    while t.tree.Parent and autoTreeFarmActive do
                                        pcall(function() axe:Activate() end)
                                        local args = { t.tree, axe, "1_8264699301", t.trunk.CFrame }
                                        pcall(function() ToolDamageObject:InvokeServer(unpack(args)) end)
                                        task.wait(1)
                                    end
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                    task.wait(1)
                end
            end)
        else
            if autoTreeFarmThread then
                task.cancel(autoTreeFarmThread)
                autoTreeFarmThread = nil
            end
        end
    end
})


local autoBreakActive = false
local autoBreakSpeed = 1
local autoBreakThread
Tabs.Main:Slider({
    Title = "自动攻击速度",
    Min = 0.1,
    Max = 2,
    Default = 1,
    Callback = function(val) autoBreakSpeed = val end
})
Tabs.Main:Toggle({
    Title = "自动攻击",
    Default = false,
    Callback = function(state)
        autoBreakActive = state
        if state then
            autoBreakThread = task.spawn(function()
                while autoBreakActive do
                    local function getWeapon()
                        local inv = LocalPlayer:FindFirstChild("Inventory")
                        return inv and (inv:FindFirstChild("Spear")
                            or inv:FindFirstChild("Strong Axe")
                            or inv:FindFirstChild("Good Axe")
                            or inv:FindFirstChild("Old Axe"))
                    end
                    local weapon = getWeapon()
                    if weapon then
                        local ray = workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 15)
                        if ray and ray.Instance and ray.Instance.Name == "Trunk" then
                            ReplicatedStorage.RemoteEvents.ToolDamageObject:InvokeServer(
                                ray.Instance.Parent, weapon, "4_7591937906", CFrame.new(ray.Position)
                            )
                        end
                    end
                    task.wait(autoBreakSpeed)
                end
            end)
        else
            if autoBreakThread then
                task.cancel(autoBreakThread)
                autoBreakThread = nil
            end
        end
    end
})

local function CreateEsp(Char, Color, Text, Parent, numberOffset)
    if not Char then return end
    if Char:FindFirstChildOfClass("Highlight") then Char:FindFirstChildOfClass("Highlight"):Destroy() end
    if Parent:FindFirstChildOfClass("BillboardGui") then Parent:FindFirstChildOfClass("BillboardGui"):Destroy() end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = Char
    highlight.FillColor = Color
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.Parent = Char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(0, 50, 0, 25)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, numberOffset or 3, 0)
    billboard.Adornee = Parent
    billboard.Enabled = true
    billboard.Parent = Parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = Text
    label.TextColor3 = Color
    label.TextScaled = true
    label.Parent = billboard
end

local ActiveEspPlayer = false
local ActiveEspItems = false
local ActiveEspEnemy = false
local ActiveEspChildren = false
local ActiveEspPeltTrader = false

Tabs.Esp:Toggle({
    Title = "玩家 ESP",
    Default = false,
    Callback = function(state)
        ActiveEspPlayer = state
        task.spawn(function()
            while ActiveEspPlayer do
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local char = player.Character
                        if not char:FindFirstChildOfClass("Highlight") and not char.HumanoidRootPart:FindFirstChildOfClass("BillboardGui") then
                            CreateEsp(char, Color3.fromRGB(0, 255, 0), player.Name, char.HumanoidRootPart, 2)
                        end
                    end
                end
                task.wait(0.1)
            end
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local char = player.Character
                    if char:FindFirstChildOfClass("Highlight") then char:FindFirstChildOfClass("Highlight"):Destroy() end
                    if char.HumanoidRootPart:FindFirstChildOfClass("BillboardGui") then char.HumanoidRootPart:FindFirstChildOfClass("BillboardGui"):Destroy() end
                end
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "物品 ESP",
    Default = false,
    Callback = function(state)
        ActiveEspItems = state
        task.spawn(function()
            while ActiveEspItems do
                for _, Obj in pairs(workspace.Items:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(255, 255, 0), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(workspace.Items:GetChildren()) do
                if Obj:FindFirstChildOfClass("Highlight") then Obj:FindFirstChildOfClass("Highlight"):Destroy() end
                if Obj.PrimaryPart and Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui"):Destroy() end
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "敌人 ESP",
    Default = false,
    Callback = function(state)
        ActiveEspEnemy = state
        task.spawn(function()
            while ActiveEspEnemy do
                for _, Obj in pairs(workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        if not string.find(Obj.Name, "Lost Child") and Obj.Name ~= "Pelt Trader" then
                            CreateEsp(Obj, Color3.fromRGB(255, 0, 0), Obj.Name, Obj.PrimaryPart, 2)
                        end
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(workspace.Characters:GetChildren()) do
                if Obj:FindFirstChildOfClass("Highlight") then Obj:FindFirstChildOfClass("Highlight"):Destroy() end
                if Obj.PrimaryPart and Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui"):Destroy() end
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Lost Child ESP",
    Default = false,
    Callback = function(state)
        ActiveEspChildren = state
        task.spawn(function()
            while ActiveEspChildren do
                for _, Obj in pairs(workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and string.find(Obj.Name, "Lost Child") and not Obj:FindFirstChildOfClass("Highlight") then
                        CreateEsp(Obj, Color3.fromRGB(0, 255, 0), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Pelt Trader ESP",
    Default = false,
    Callback = function(state)
        ActiveEspPeltTrader = state
        task.spawn(function()
            while ActiveEspPeltTrader do
                for _, Obj in pairs(workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and Obj.Name == "Pelt Trader" and not Obj:FindFirstChildOfClass("Highlight") then
                        CreateEsp(Obj, Color3.fromRGB(0, 255, 255), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})


local espTypes = {
    ["Fuel All"] = { color = Color3.fromRGB(255, 140, 0), items = { "Log", "Fuel Canister", "Coal", "Oil Barrel" } },
    ["Scraps All"] = { color = Color3.fromRGB(169, 169, 169), items = { "Sheet Metal", "Broken Fan", "UFO Junk", "Bolt", "Old Radio", "UFO Scrap", "Broken Microwave" } },
    ["Ammo All"] = { color = Color3.fromRGB(0, 255, 0), items = { "Rifle Ammo", "Revolver Ammo" } },
    ["Guns All"] = { color = Color3.fromRGB(255, 0, 0), items = { "Rifle", "Revolver" } },
    ["Food All"] = { color = Color3.fromRGB(255, 255, 0), items = { "Meat? Sandwich", "Cake", "Carrot", "Morsel" } },
    ["body All"] = { color = Color3.fromRGB(255, 255, 255), items = { "Leather Body", "Iron Body" } },
    ["Bandage"] = { color = Color3.fromRGB(255, 192, 203), items = { "Bandage" } },
    ["Medkit"] = { color = Color3.fromRGB(255, 0, 255), items = { "MedKit" } },
    ["Coin"] = { color = Color3.fromRGB(255, 215, 0), items = { "Coin Stack" } },
    ["Radio"] = { color = Color3.fromRGB(135, 206, 235), items = { "Old Radio" } },
    ["tyre"] = { color = Color3.fromRGB(105, 105, 105), items = { "Tyre" } },
    ["broken fan"] = { color = Color3.fromRGB(112, 128, 144), items = { "Broken Fan" } },
    ["broken microwave"] = { color = Color3.fromRGB(47, 79, 79), items = { "Broken Microwave" } },
    ["bolt"] = { color = Color3.fromRGB(0, 191, 255), items = { "Bolt" } },
    ["Sheet Metal"] = { color = Color3.fromRGB(192, 192, 192), items = { "Sheet Metal" } },
    ["SeedBox"] = { color = Color3.fromRGB(124, 252, 0), items = { "Seed Box" } },
    ["Chair"] = { color = Color3.fromRGB(210, 180, 140), items = { "Chair" } }
}

for category, data in pairs(espTypes) do
    Tabs.Esp:Toggle({
        Title = "ESP (" .. category .. ")",
        Default = false,
        Callback = function(state)
            local active = state
            task.spawn(function()
                while active do
                    for _, obj in pairs(workspace.Items:GetChildren()) do
                        if obj:IsA("Model") and obj.PrimaryPart then
                            for _, itemName in pairs(data.items) do
                                if string.lower(obj.Name) == string.lower(itemName) then
                                    if not obj:FindFirstChildOfClass("Highlight") then
                                        CreateEsp(obj, data.color, obj.Name, obj.PrimaryPart, 2)
                                    end
                                    break
                                end
                            end
                        end
                    end
                    task.wait(0.25)
                end
                for _, obj in pairs(workspace.Items:GetChildren()) do
                    for _, itemName in pairs(data.items) do
                        if string.lower(obj.Name) == string.lower(itemName) then
                            if obj:FindFirstChildOfClass("Highlight") then obj:FindFirstChildOfClass("Highlight"):Destroy() end
                            if obj.PrimaryPart and obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then obj.PrimaryPart:FindFirstChildOfClass("BillboardGui"):Destroy() end
                            break
                        end
                    end
                end
            end)
        end
    })
end

Tabs.Teleport:Button({
    Title = "传送到篝火",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(
                13.287, 3.999, 0.362,
                0.602, 0, 0.798,
                0, 1, 0,
                -0.798, 0, 0.602
            )
        end
    end
})

Tabs.Teleport:Button({
    Title = "传送到NPC商人",
    Callback = function()
        local pos = Vector3.new(-37.08, 3.98, -16.33)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(pos)
    end
})

Tabs.Teleport:Button({
    Title = "传送到随机树木",
    Callback = function()
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart", 3)
        if not hrp then return end

        local map = workspace:FindFirstChild("Map")
        if not map then return end
        local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
        if not foliage then return end

        local trees = {}
        for _, obj in ipairs(foliage:GetChildren()) do
            if obj.Name == "Small Tree" and obj:IsA("Model") then
                local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                if trunk then table.insert(trees, trunk) end
            end
        end
        if #trees > 0 then
            local trunk = trees[math.random(1, #trees)]
            local treeCFrame = trunk.CFrame
            local targetPosition = treeCFrame.Position + treeCFrame.RightVector * 3
            hrp.CFrame = CFrame.new(targetPosition)
        end
    end
})

local lostChildNames = {"Lost Child","Lost Child2","Lost Child3","Lost Child4"}
for i, name in ipairs(lostChildNames) do
    Tabs.Teleport:Button({
        Title = "传送到 " .. name,
        Callback = function()
            local target = workspace.Characters:FindFirstChild(name)
            if target and target:IsA("Model") and target.PrimaryPart then
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = target.PrimaryPart.CFrame
            end
        end
    })
end


local function bringItemsByName(name)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find(name:lower()) then
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                part.CFrame = root.CFrame + Vector3.new(0, 3, 0) + root.CFrame.LookVector * 5
            end
        end
    end
end

Tabs.Bring:Button({
    Title="吸附所有物品",
    Callback=function()
        for _, item in ipairs(workspace.Items:GetChildren()) do
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-44,44), 0, math.random(-44,44))
            end
        end
    end
})


for i, name in ipairs(lostChildNames) do
    Tabs.Bring:Button({
        Title = "吸附 " .. name,
        Callback=function()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            for _, item in pairs(workspace.Characters:GetChildren()) do
                if item.Name == name and item:IsA("Model") then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                    end
                end
            end
        end
    })
end


local bringList = {
    "Logs","Fuel Canister","Oil Barrel","Coal","Meat","Flashlight","Nails","Fan","Rope","Scrap","Wood","Cloth","Rock","Stone Pickaxe","Knife","Spear",
    "Leather Body","Iron Body","Revolver","Rifle","Bandage","MedKit","Old Radio","Coin Stack","UFO Junk","UFO Scrap","Broken Microwave","Bolt","Chair",
    "Seed Box","Meat? Sandwich","Cake","Carrot","Morsel","Tyre","Broken Fan","Sheet Metal","Strong Axe","Good Axe","Old Axe","Rifle Ammo","Revolver Ammo"
}
for _, name in ipairs(bringList) do
    Tabs.Bring:Button({
        Title = "吸附 " .. name,
        Callback = function() bringItemsByName(name) end
    })
end

local hitboxSettings = {
    Wolf = false,
    Bunny = false,
    Cultist = false,
    All = false,
    Show = false,
    Size = 10
}

local function updateHitboxForModel(model)
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local name = model.Name:lower()

    if hitboxSettings.All then
        root.Size = Vector3.new(hitboxSettings.Size, hitboxSettings.Size, hitboxSettings.Size)
        root.Transparency = hitboxSettings.Show and 0.5 or 1
        root.Color = Color3.fromRGB(255, 255, 255)
        root.Material = Enum.Material.Neon
        root.CanCollide = false
        return
    end

    local shouldResize =
        (hitboxSettings.Wolf and (name:find("wolf") or name:find("alpha"))) or
        (hitboxSettings.Bunny and name:find("bunny")) or
        (hitboxSettings.Cultist and (name:find("cultist") or name:find("cross")))

    if shouldResize then
        root.Size = Vector3.new(hitboxSettings.Size, hitboxSettings.Size, hitboxSettings.Size)
        root.Transparency = hitboxSettings.Show and 0.5 or 1
        root.Color = Color3.fromRGB(255, 255, 255)
        root.Material = Enum.Material.Neon
        root.CanCollide = false
    end
end

task.spawn(function()
    while true do
        for _, model in ipairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
                updateHitboxForModel(model)
            end
        end
        task.wait(2)
    end
end)

Tabs.Hitbox:Toggle({Title="扩展狼Hitbox", Default=false, Callback=function(val) hitboxSettings.Wolf=val end})
Tabs.Hitbox:Toggle({Title="扩展兔子Hitbox", Default=false, Callback=function(val) hitboxSettings.Bunny=val end})
Tabs.Hitbox:Toggle({Title="扩展邪教徒Hitbox", Default=false, Callback=function(val) hitboxSettings.Cultist=val end})
Tabs.Hitbox:Toggle({Title="扩展所有Hitbox", Default=false, Callback=function(val) hitboxSettings.All=val end})
Tabs.Hitbox:Slider({Title="Hitbox大小", Value={Min=2, Max=250, Default=10}, Step=1, Callback=function(val) hitboxSettings.Size=val end})
Tabs.Hitbox:Toggle({Title="显示Hitbox", Default=false, Callback=function(val) hitboxSettings.Show=val end})


Tabs.Player:Slider({
    Title = "移动速度",
    Min = 5,
    Max = 500,
    Default = 16,
    Callback = function(val)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = val end
    end
})

Tabs.Player:Slider({
    Title = "跳跃力",
    Min = 10,
    Max = 500,
    Default = 50,
    Callback = function(val)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.JumpPower = val end
    end
})

local speedBoostEnabled = false
Tabs.Player:Button({
    Title = "加速模式",
    Callback = function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            speedBoostEnabled = not speedBoostEnabled
            humanoid.WalkSpeed = speedBoostEnabled and 100 or 16
        end
    end
})

Tabs.Player:Button({
    Title = "飞行模式",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/Dupe-Anime-Rails/refs/heads/main/Dly"))()
    end
})

local noclipConnection
Tabs.Player:Toggle({
    Title = "穿墙",
    Default = false,
    Callback = function(state)
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local Character = LocalPlayer.Character
                if Character then
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local Character = LocalPlayer.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

Tabs.Player:Toggle({
    Title = "无CD (仅限Good Axe)",
    Default = false,
    Callback = function(state)
        local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then Humanoid.BreakJointsOnDeath = not state end
    end
})

Tabs.Player:Toggle({
    Title = "假无敌模式",
    Default = false,
    Callback = function(state)
        local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then Humanoid.BreakJointsOnDeath = not state end
    end
})

Tabs.Player:Toggle({
    Title = "无限跳",
    Default = false,
    Callback = function(state)
        local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            if state then
                Humanoid.JumpPower = math.huge
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                local jumpConnection = Humanoid.StateChanged:Connect(function(_, newState)
                    if newState == Enum.HumanoidStateType.Landed and Humanoid.JumpPower == math.huge then
                        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
                Humanoid:SetAttribute("InfinityJumpConnection", jumpConnection)
            else
                Humanoid.JumpPower = 50
                local jumpConnection = Humanoid:GetAttribute("InfinityJumpConnection")
                if jumpConnection then
                    jumpConnection:Disconnect()
                    Humanoid:SetAttribute("InfinityJumpConnection", nil)
                end
            end
        end
    end
})


local instantPrompt = false
local connection
Tabs.Misc:Button({
    Title = "快速交互 (0秒)",
    Callback = function()
        instantPrompt = not instantPrompt
        if instantPrompt then
            for _, prompt in ipairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    prompt.HoldDuration = 0
                end
            end
            if not connection then
                connection = workspace.DescendantAdded:Connect(function(descendant)
                    if descendant:IsA("ProximityPrompt") then
                        descendant.HoldDuration = 0
                    end
                end)
            end
        else
            for _, prompt in ipairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    prompt.HoldDuration = 0.5
                end
            end
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end
})

Tabs.Misc:Button({
    Title = "FPS优化",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 0
            lighting.FogEnd = 100
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0,0,0)
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
    end
})


local showFPS, showPing = true, true
local fpsText, msText = Drawing.new("Text"), Drawing.new("Text")
fpsText.Size, fpsText.Position, fpsText.Color, fpsText.Center, fpsText.Outline, fpsText.Visible =
    16, Vector2.new(Camera.ViewportSize.X-100, 10), Color3.fromRGB(0,255,0), false, true, showFPS
msText.Size, msText.Position, msText.Color, msText.Center, msText.Outline, msText.Visible =
    16, Vector2.new(Camera.ViewportSize.X-100, 30), Color3.fromRGB(0,255,0), false, true, showPing

local fpsCounter, fpsLastUpdate = 0, tick()
RunService.RenderStepped:Connect(function()
    fpsCounter += 1
    if tick() - fpsLastUpdate >= 1 then
        if showFPS then
            fpsText.Text = "FPS: " .. tostring(fpsCounter)
            fpsText.Visible = true
        else
            fpsText.Visible = false
        end
        if showPing then
            local pingStat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
            local ping = pingStat and math.floor(pingStat:GetValue()) or 0
            msText.Text = "Ping: " .. ping .. " ms"
            if ping <= 60 then
                msText.Color = Color3.fromRGB(0,255,0)
            elseif ping <= 120 then
                msText.Color = Color3.fromRGB(255,165,0)
            else
                msText.Color = Color3.fromRGB(255,0,0)
                msText.Text = "网络延迟: " .. ping .. " ms"
            end
            msText.Visible = true
        else
            msText.Visible = false
        end
        fpsCounter = 0
        fpsLastUpdate = tick()
    end
end)

Tabs.Misc:Toggle({
    Title="显示FPS",
    Default=true,
    Callback=function(val) showFPS=val; fpsText.Visible=val end
})

Tabs.Misc:Toggle({
    Title="显示Ping",
    Default=true,
    Callback=function(val) showPing=val; msText.Visible=val end
})