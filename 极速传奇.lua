local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/atoyayaya/REDz-ui/refs/heads/main/REDzGui"))()

local Window = redzlib:MakeWindow({
  Title = "安脚本",
  SubTitle = "极速传奇",
  SaveFolder = "安脚本"
})

print("反挂机已开启")
Start = tick()
		local vu = game:GetService("VirtualUser")
		game:GetService("Players").LocalPlayer.Idled:connect(function()
		   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		   wait(1)
		   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		end)

Window:AddMinimizeButton({
  Button = { Image = redzlib:GetIcon("close"), BackgroundTransparency = 0,Size = UDim2.fromOffset(60, 60), },
  Corner = { CornerRadius = UDim.new(0, 10) }
})

local day = game.Players.LocalPlayer.AccountAge
local week = (day / 7)
local mouth = (day / 30)
local year = (day / 365)


local Tab = Window:MakeTab({"公告", "cool"})

Tab:AddDiscordInvite({
    Title = "复制作者qq号",
    Logo = "rbxassetid://125659062095965",
    Invite = "2134702438"
})

Tab:AddDiscordInvite({
    Title = "复制安脚本QQ群号",
    Logo = "rbxassetid://76765190932500",
    Invite = "943291911"
})        

Tab:AddDiscordInvite({
    Title = "复制作者b站UID",
    Logo = "rbxassetid://121635082871067",
    Invite = "UID:3546736987474050"
})        

Tab:AddSection("脚本默认开启反挂机，请放心挂机")

local Tab = Window:MakeTab({"个人信息", "cool"})

local Section = Tab:AddSection("注册时间:"..day.."天")

local Section = Tab:AddSection("注册时间:"..week.."星期")

local Section = Tab:AddSection("注册时间:"..mouth.."月")

local Section = Tab:AddSection("注册时间:"..year.."年")

local Section = Tab:AddSection("游戏id:"..game.GameId)

local Section = Tab:AddSection("用户id:"..game.Players.LocalPlayer.UserId)

local Section = Tab:AddSection("客户端id:"..game:GetService("RbxAnalyticsService"):GetClientId())

local Section = Tab:AddSection("注入器:"..identifyexecutor())

local Section = Tab:AddSection("用户名:"..game.Players.LocalPlayer.Character.Name)

local Section = Tab:AddSection("服务器名称:"..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)

local Tab = Window:MakeTab({"个人数据", "cool"})

local bo = Tab:AddSection("步数")
spawn(function()
while wait() do
pcall(function()
bo:Set("步数:"..week)
end)
end
end)

local reb = Tab:AddSection("重生:")
spawn(function()
while wait() do
pcall(function()
reb:Set("重生:"..game:GetService("Players").LocalPlayer.leaderstats.Rebirths.Value)
end)
end
end)

local gem = Tab:AddSection("宝石:")
spawn(function()
while wait() do
pcall(function()
gem:Set("宝石:"..game:GetService("Players").LocalPlayer.Gems.Value)
end)
end
end)

local hoop = Tab:AddSection("圈")
spawn(function()
while wait() do
pcall(function()
hoop:Set("圈:"..game:GetService("Players").LocalPlayer.leaderstats.Hoops.Value)
end)
end
end)

local Tab = Window:MakeTab({"玩家数据", "cool"})

plr = ""

Tab:AddTextBox({
    Title = "请输入玩家用户名",
    Default = "",
    PlaceholderText = "请输入",
    ClearText = true,
    Callback = function(Value)
    plr = Value
end
})

local step = Tab:AddSection("步数")
spawn(function()
while wait() do
pcall(function()
step:Set("步数:"..game:GetService("Players")[plr].leaderstats.Steps.Value)

end)
end
end)

local rebs = Tab:AddSection("重生")
spawn(function()
while wait() do
pcall(function()
rebs:Set("重生:"..game:GetService("Players")[plr].leaderstats.Rebirths.Value)
end)
end
end)

local ge = Tab:AddSection("宝石")
spawn(function()
while wait() do
pcall(function()
ge:Set("宝石:"..game:GetService("Players")[plr].Gems.Value)
end)
end
end)

local hoo = Tab:AddSection("圈")
spawn(function()
while wait() do
pcall(function()
hoo:Set("圈:"..game:GetService("Players")[plr].leaderstats.Hoops.Value)
end)
end
end)

local Tab = Window:MakeTab({"自动功能", "cool"})

local xqb = 0

Tab:AddSection("你在什么图就选择什么图")

Tab:AddTextBox({
    Title = "请输入吸球倍数",
    Description = "设置太高会导致延迟高",
    Default = "",
    PlaceholderText = "请输入",
    ClearText = false,
    Callback = function(Value)
    xqb = Value
end
})

local cit = {"城市","白雪城","熔岩城"}

local xdt = Tab:AddDropdown({
  Name = "请选择地图",
  Options = cit,
  Default = "...",
  Callback = function(Value)
   ci = Value
   if ci == "城市" then
        city = "City"
   elseif ci == "白雪城" then
        city = "Snow City"
   elseif ci == "熔岩城" then
        city = "Magma City"
      end           
  end
})

local orb = {"黄球","橙球","蓝球","红球","宝石球"}

local cs = Tab:AddDropdown({
  Name = "请选择球的类型",
  Options = orb,
  Default = "...",
  Callback = function(Value)
      yo = Value
      if yo == "黄球" then
      col = "Yellow Orb"
      elseif yo == "蓝球" then
      col = "Blue Orb"
      elseif yo == "红球" then
      col = "Red Orb"
      elseif yo == "橙球" then
      col = "Orange Orb"
      elseif yo == "宝石球" then
      col = "Gem"
      end
  end
})

_G.zdxq = true

function zdxq()
	while _G.zdxq == true do
	wait(0.5)
	for i=1, (""..xqb) do
local A_1 = "collectOrb"
local A_2 = (""..col)
local A_3 = (""..city)
local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent
Event:FireServer(A_1, A_2, A_3)
end	
	end
end	

Tab:AddToggle({
  Name = "自动吸球",
  Default = false,
  Callback = function(Value)
    _G.zdxq = Value
        zdxq()
  end
})

_G.auto_hoop = true

function auto_hoop()
	while _G.auto_hoop == true do
	wait()
	local children = workspace.Hoops:GetChildren()
                    for i, child in ipairs(children) do
                        if child.Name == "Hoop" then
                        child.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    end    
                end
	end
end	

Tab:AddToggle({
  Name = "自动跳圈",
  Default = false,
  Callback = function(Value)
    _G.auto_hoop = Value
        auto_hoop()
  end
})

_G.race = true

function race()
	while _G.race == true do
	wait()
	local args = {
    [1] = "joinRace"
}

game:GetService("ReplicatedStorage").rEvents.raceEvent:FireServer(unpack(args))

	end
end	

Tab:AddToggle({
  Name = "自动比赛",  
  Default = false,
  Callback = function(Value)
    _G.race = Value
        race()
  end
})

local Tab = Window:MakeTab({"传送", "cool"})

Tab:AddButton({"城市", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9682.98828, 74.8522873, 3099.03394, 0.087131381, 0, 0.996196866, 0, 1, 0, -0.996196866, 0, 0.087131381)
end})

Tab:AddButton({"白雪城", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9676.13867, 74.8522873, 3782.69385, 0, 0, -1, 0, 1, 0, 1, 0, 0)
end})

Tab:AddButton({"熔岩城", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-11054.9688, 232.791656, 4898.62842, -0.0872479677, 0.000158954252, -0.996186614, -0.00054083002, 0.999999821, 0.00020692969, 0.996186495, 0.000556821818, -0.0872478485)
end})

Tab:AddButton({"传奇公路", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-13098.8711, 232.791656, 5907.62793, -0.0872479677, 0.000158954252, -0.996186614, -0.00054083002, 0.999999821, 0.00020692969, 0.996186495, 0.000556821818, -0.0872478485)
end})

local Tab = Window:MakeTab({"重生功能", "cool"})

local yes = "false"

Tab:AddTextBox({
    Title = "请输入指定重生次数",
    Default = "默认",
    PlaceholderText = "请输入",
    ClearText = false,
    Callback = function(Value)
    grcs = Value
end
})

_G.auto_grred = true

function auto_grred()
	while _G.auto_grred == true do
	if game:GetService("Players").LocalPlayer.leaderstats.Rebirths.Value >= (""..grcs) then
	print("已达到")
	else 
	  game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")   
end  
	end
end	

local grct = Tab:AddToggle({
  Name = "自动重生",
  Description = "重生到你所输入的重生次数自动停止（不踢你）",
  Default = false,
  Callback = function(Value)
    _G.auto_grred = Value
        auto_grred()
  end
})

_G.auto_nobs = true

function auto_nobs()
	while _G.auto_nobs == true do
	wait()
	game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")   
	end
end	

Tab:AddToggle({
  Name = "自动重生",  
  Description = "无限制重生",
  Default = false,
  Callback = function(Value)
    _G.auto_nobs = Value
        auto_nobs()
  end
})

local Tab = Window:MakeTab({"宠物商店", "cool"})

local jc = {"火焰刺猬"}

Tab:AddSection("尾迹或宠物满了都会导致功能失效")

local cs = Tab:AddDropdown({
  Name = "传说",
  Options = jc,
  Default = "...",
  Callback = function(Value)
   jin = Value
   if jin == "火焰刺猬" then
   jp = "Flaming Hedgehog"
   end           
  end
})

local hc = {"融魂小狗","黑魂小鸟","永恒星云龙","超音速飞马","影锋小猫","终极超速小兔",}

local cs = Tab:AddDropdown({
  Name = "欧米茄",
  Options = hc,
  Default = "...",
  Callback = function(Value)
   jin = Value
   if jin == "融魂小狗" then
   jp = "Soul Fusion Dog"
   elseif jin == "黑魂小鸟" then
   jp = "Dark Soul Birdie"
   elseif jin == "永恒星云龙" then
   jp = "Eternal Nebula Dragon"
   elseif jin == "超音速飞马" then
   jp = "Hypersonic Pegasus"
   elseif jin == "影锋小猫" then
   jp = "Shadows Edge Kitty"
   elseif jin == "终极超速小兔" then
   jp = "Ultimate Overdrive Bunny"
   end           
  end
})

local wj = {"第一尾迹"}

local cs = Tab:AddDropdown({
  Name = "传说",
  Options = wj,
  Default = "...",
  Callback = function(Value)
   jin = Value
   if jin == "第一尾迹" then
   jp = "1st Trail"
   end           
  end
})


local sxbs = Tab:AddSection("所需宝石:")
spawn(function()
while wait() do
pcall(function()
sxbs:Set("所需宝石:"..game:GetService("ReplicatedStorage").cPetShopFolder:FindFirstChild(""..jp).priceValue.Value)
end)
end
end)

local qq = Tab:AddSection("当前所购买")
spawn(function()
while wait() do
pcall(function()
qq:Set("当前所购买:"..jin)
end)
end
end)

_G.autobuy = true

function autobuy()
	while _G.autobuy == true do
	wait()
	game:GetService("ReplicatedStorage").cPetShopRemote:InvokeServer(game:GetService("ReplicatedStorage").cPetShopFolder:FindFirstChild(""..jp))
	end
end	

Tab:AddToggle({
  Name = "自动购买宠物",  
  Default = false,
  Callback = function(Value)
    _G.autobuy = Value
        autobuy()
  end
})