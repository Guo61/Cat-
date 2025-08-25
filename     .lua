local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
WindUI:local Window = OrionLib:MakeWindow({

Name = "Cat", 

HidePremium = false,
SaveConfig = true,
IntroText = "欢迎使用Cat Hub",
ConfigFolder = "520"})

local Tab = Window:MakeTab({

Name = "速度传奇",

Icon = "rbxassetid://108453362719381",
PremiumOnly = false})

Tab:AddButton({

Name = "钻石",

Callback = function()

while true do
local args = {
	"collectOrb",
	"Gem",
	"City"
}
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args))
wait(0.5)
end
end})      

Tab:AddButton({

Name="步",

Callback = function()

while true do
local args = {
	"collectOrb",
	"Orange Orb",
	"City"
}
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer(unpack(args))
wait(0.5)
end
end})