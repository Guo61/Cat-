本地CoreGui=游戏：GetService("StarterGui")

CoreGui:SetCore("SendNotification"，{
标题="猫脚本"，
文本="正在加载（反挂机已开启）"，
持续时间=6，
})

CoreGui:SetCore("SendNotification"，{
标题="猫脚本"，
文本="永久免费缝合"，
持续时间=7，
})

CoreGui:SetCore("SendNotification"，{
标题="猫脚本"，
文本="感谢使用Cat脚本"，
持续时间=8，
})

打印("反挂机开启")
本地vu=游戏：GetService("虚拟用户")
游戏：GetService(“玩家”)。LocalPlayer.idled：连接(函数()
vu:Button2Down(向量2.新建(0，0)，工作区.CurrentCamera.cframe)
等待(1)
vu:Button2Up(向量2.新建(0，0)，工作区.CurrentCamera.cframe)
结束)

本地LBLG=Instance.new("ScreenGui"，getParent)
本地LBL=Instance.new("TextLabel"，getParent)
本地玩家=game.Players.LocalPlayer

LBLG.Name="LBLG"
LBLG.Parent=game.CoreGuui
LBLG.ZIndexBehavior=枚举.ZIndexBehavior.Sibling
LBLG.Enabled=true
LBL.Name="LBL"
LBL.Parent=LBLG
LBL.BackgroundColor3=Color3.new(1，1，1)
LBL.BackgroundTransparency=1
LBL.BorderColor3=Color3.new(0，0，0)
LBL.位置=UDim2.new(0.75,0,0.010,0)
LBL.Size=UDim2.new(0，133，0，30)
LBL.Font=枚举。字体.哥谭半粗体
LBL.Text="TextLabel"
LBL.TextColor3=Color3.new(1，1，1)
LBL.TextScaled=true
LBL.TextSize=14
LBL.TextWrapped=true
LBL.Visible=true

本地FpsLabel=LBL
本地心跳=游戏：GetService(“RunService”)。心跳
本机LastIteration，开始
本地FrameUpdateTable={}

本地函数HeartbeatUpdate()
LastIteration=tick()
对于索引=#FrameUpdateTable，1，-1do
FrameUpdateTable[索引+1]=(FrameUpdateTable[指数]>=LastIteration-1)和FrameUpdateTable[指数]或零
结束
FrameUpdateTable[1]=LastIteration
本地当前FPS=(tick()-开始>=1和#FrameUpdateTable)或(#FrameUpdateTable/(tick()-开始))
CurrentFPS=CurrentFPS-CurrentFPS%1
FpsLabel.Text=("北京时间："..os.date("%H").."时"..操作系统日期("%M").."分"..操作系统日期("%S"))
结束
start=tick()
heartbeat：连接(HeartbeatUpdate)

本地OrionLib=loadstring(游戏：HttpGet("https://pastebin.com/raw/v9Pdp6kx"))()
本地窗口=OrionLib:MakeWindow({Name="Cat脚本"，HidePremium=false，saveconfig=true，introtext="欢迎使用Cat脚本"，configFolder="欢迎使用Cat脚本"})
本地关于=窗口：MakeTab({
name="Cat脚本"，
PremiumOnly=false
})

CoreGui:SetCore("SendNotification"，{
标题="猫脚本"，
文本="加载成动，祝您游戏愉快"，
持续时间=10，
})

关于：addParagraph("您的用户名："，""..game.Players.LocalPlayer.Name.."")
关于：addParagraph("您的注入器："，""..标识执行器().."")
about:addParagraph("您当前服务器的ID"，""..game.GameId.."")

本地选项卡=窗口：MakeTab({
姓名="公告"，

	PremiumOnly=false
})

选项卡：addParagraph("永久免费缝合脚本（作者：.")


本地选项卡=窗口：MakeTab({
姓名="其它脚本"，

	PremiumOnly=false
})

选项卡：addButton({
姓名="鸭"，
回调=函数()
loadstring(游戏：HttpGet(utf8.char(function())返回table.unpack({104,116,116,112,115,58,47,47,112,97,115,116,101,98,105,110,46,99,111,109,47,114,97,119,47,81,89,49,113,112,99,115,106})end)())))()
结束
})
选项卡：addButton({
name="XK"
回调=函数()
loadstring(游戏：HttpGet(('https://github.com/devslopo/DVES/raw/main/XK%20Hub')))()
结束
})
