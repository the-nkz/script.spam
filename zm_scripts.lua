
--// esse código foi feito por IA sim, pq é um script de brookhaven, eu não iria aprender lua só para um scriptzinho de spam 💀💀💀

--// SERVIÇOS

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

--// FPS CAP

pcall(function()
if setfpscap then
setfpscap(60)
end
end)

--// CONFIG

local CONFIG_FOLDER = "PainelComandos"
local CONFIG_FILE = CONFIG_FOLDER .. "/config.json"

local DefaultConfig = {

Commands = {

    "`/Mat - χάος'",
    "`/PD Perm - χάος'",
    "`/Furar Pneu - χάος'",
    "`/Kit - χάος'",
    "`/Pegar",
    "`/000",
    "`/script by thenkz_0"
},

AutoPD = {

    Enabled = false,
    Count = 5,
    Delay = 1.5
}

}

local Config

local function SaveConfig()

if not writefile then
    return
end

writefile(
    CONFIG_FILE,
    HttpService:JSONEncode(Config)
)

end

local function LoadConfig()

if makefolder and not isfolder(CONFIG_FOLDER) then
    makefolder(CONFIG_FOLDER)
end

if isfile and isfile(CONFIG_FILE) then

    local success,data = pcall(function()

        return HttpService:JSONDecode(
            readfile(CONFIG_FILE)
        )

    end)

    if success and data then

        Config = data
        return
    end
end

Config = DefaultConfig
SaveConfig()

end

LoadConfig()

--// CHAT

local function enviarChat(texto)

if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then

    local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")

    if channel then
        channel:SendAsync(texto)
    end

else

    game.ReplicatedStorage
        .DefaultChatSystemChatEvents
        .SayMessageRequest
        :FireServer(texto,"All")

end

end

--// AUTO PD

local MatCounter = 0
local AutoPDToken = 0

local function CancelAutoPD()

    AutoPDToken += 1
    MatCounter = 0

end

local function ScheduleAutoPD()

if not Config.AutoPD.Enabled then
    return
end

AutoPDToken += 1

local Token = AutoPDToken

task.delay(Config.AutoPD.Delay,function()

    if Token ~= AutoPDToken then
        return
    end

    enviarChat(
        Config.Commands[2]
    )
end)

end

local function RegisterMat()

MatCounter += 1

if MatCounter >= Config.AutoPD.Count then

    MatCounter = 0

    ScheduleAutoPD()
end

end

--// FUNÇÃO DE EXECUÇÃO

local function ExecuteCommand(Index)

local Command = Config.Commands[Index]

if not Command then
    return
end

if Index == 1 then

    RegisterMat()

else

    CancelAutoPD()

end

enviarChat(Command)

end
--// GUI

local gui = Instance.new("ScreenGui")
gui.Name = "PainelComandos"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = player:WaitForChild("PlayerGui")

--// BOTÃO PRINCIPAL

local icon = Instance.new("TextButton")
icon.Name = "MainButton"
icon.Size = UDim2.new(0,80,0,30)
icon.Position = UDim2.new(0.05,0,0.4,0)

icon.BackgroundColor3 = Color3.fromRGB(10,10,10)
icon.BackgroundTransparency = 0.75

icon.Text = "FPS\n60"
icon.TextColor3 = Color3.fromRGB(255,255,255)
icon.TextSize = 13
icon.TextWrapped = true
icon.Font = Enum.Font.GothamBold

icon.BorderSizePixel = 0
icon.Active = true
icon.ZIndex = 10
icon.Parent = gui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0,8)
iconCorner.Parent = icon

local iconStroke = Instance.new("UIStroke")
iconStroke.Color = Color3.fromRGB(255,255,255)
iconStroke.Thickness = 1
iconStroke.Transparency = 0.85
iconStroke.Parent = icon

--// PAINEL

local panel = Instance.new("Frame")
panel.Name = "CommandsPanel"

panel.Size = UDim2.new(0,120,0,0)

panel.Position = UDim2.new(
icon.Position.X.Scale,
icon.Position.X.Offset + 90,
icon.Position.Y.Scale,
icon.Position.Y.Offset
)

panel.BackgroundColor3 = Color3.fromRGB(10,10,10)
panel.BackgroundTransparency = 0.80

panel.Visible = false
panel.BorderSizePixel = 0
panel.ZIndex = 10
panel.Parent = gui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0,8)
panelCorner.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(255,255,255)
panelStroke.Thickness = 1
panelStroke.Transparency = 0.85
panelStroke.Parent = panel

--// FPS COUNTER

local FPS = 60
local Frames = 0
local LastTick = tick()

RunService.RenderStepped:Connect(function()

Frames += 1

if tick() - LastTick >= 1 then

    FPS = Frames
    Frames = 0
    LastTick = tick()

    icon.Text = "FPS\n"..tostring(FPS)
end

end)

--// COMANDO /0

local function processarComando(msg)

msg = string.lower(msg)

if msg == "/0" then

    icon.Visible = not icon.Visible

    if not icon.Visible then
        panel.Visible = false
    end

end

end

if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then

local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")

if channel then

    channel.MessageReceived:Connect(function(message)

        if message.TextSource
        and message.TextSource.UserId == player.UserId then

            processarComando(message.Text)

        end
    end)
end

else

player.Chatted:Connect(processarComando)

end

--// BOTÕES

local alturaTotal = 0
local Buttons = {}

for Index,Command in ipairs(Config.Commands) do

local btn = Instance.new("TextButton")

btn.Size = UDim2.new(1,-8,0,20)
btn.Position = UDim2.new(0,4,0,alturaTotal + 4)

btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
btn.BackgroundTransparency = 0.60

btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
btn.Font = Enum.Font.Gotham

btn.Text = Command

btn.BorderSizePixel = 0
btn.ZIndex = 11

btn.Parent = panel

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0,6)
btnCorner.Parent = btn

Buttons[Index] = btn

alturaTotal += 22

end

local OPEN_SIZE = UDim2.new(
0,
120,
0,
alturaTotal + 4
)

--// ABRIR E FECHAR

local Opened = false

icon.Activated:Connect(function()

Opened = not Opened

if Opened then

    panel.Visible = true

    panel.Size = UDim2.new(0,120,0,0)

    TweenService:Create(
        panel,
        TweenInfo.new(0.15),
        {
            Size = OPEN_SIZE
        }
    ):Play()

else

    local tween = TweenService:Create(
        panel,
        TweenInfo.new(0.15),
        {
            Size = UDim2.new(0,120,0,0)
        }
    )

    tween:Play()

    task.spawn(function()

        tween.Completed:Wait()

        if not Opened then
            panel.Visible = false
        end

    end)
end

end)

--// DRAG

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)

local delta = input.Position - dragStart

icon.Position = UDim2.new(
    startPos.X.Scale,
    startPos.X.Offset + delta.X,
    startPos.Y.Scale,
    startPos.Y.Offset + delta.Y
)

panel.Position = UDim2.new(
    icon.Position.X.Scale,
    icon.Position.X.Offset + 90,
    icon.Position.Y.Scale,
    icon.Position.Y.Offset
)

end

icon.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.Touch
or input.UserInputType == Enum.UserInputType.MouseButton1 then

    dragging = true
    dragStart = input.Position
    startPos = icon.Position

    input.Changed:Connect(function()

        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end

end)

icon.InputChanged:Connect(function(input)

if input.UserInputType == Enum.UserInputType.Touch
or input.UserInputType == Enum.UserInputType.MouseMovement then

    dragInput = input
end

end)

UserInputService.InputChanged:Connect(function(input)

if dragging and input == dragInput then
    update(input)
end

end)
--// EDITOR

local EditorFrame = Instance.new("Frame")
EditorFrame.Size = UDim2.new(0,220,0,170)
EditorFrame.Position = UDim2.new(0.5,-110,0.5,-85)

EditorFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
EditorFrame.BackgroundTransparency = 0.80

EditorFrame.Visible = false
EditorFrame.ZIndex = 100
EditorFrame.Parent = gui

local EditorCorner = Instance.new("UICorner")
EditorCorner.CornerRadius = UDim.new(0,8)
EditorCorner.Parent = EditorFrame

local EditorStroke = Instance.new("UIStroke")
EditorStroke.Transparency = 0.85
EditorStroke.Color = Color3.new(1,1,1)
EditorStroke.Parent = EditorFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,25)
Title.BackgroundTransparency = 1
Title.Text = "Editar Comando"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = EditorFrame

local CommandBox = Instance.new("TextBox")
CommandBox.Size = UDim2.new(1,-20,0,30)
CommandBox.Position = UDim2.new(0,10,0,35)

CommandBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
CommandBox.TextColor3 = Color3.new(1,1,1)
CommandBox.PlaceholderText = "Comando..."
CommandBox.Text = ""

CommandBox.Parent = EditorFrame

local EditingIndex = nil

local AutoToggle = Instance.new("TextButton")
AutoToggle.Size = UDim2.new(1,-20,0,25)
AutoToggle.Position = UDim2.new(0,10,0,75)

AutoToggle.Text = "Auto PD: OFF"
AutoToggle.Parent = EditorFrame

local CountBox = Instance.new("TextBox")
CountBox.Size = UDim2.new(0.45,-15,0,25)
CountBox.Position = UDim2.new(0,10,0,110)

CountBox.Text = tostring(Config.AutoPD.Count)
CountBox.PlaceholderText = "Qtd"

CountBox.Parent = EditorFrame

local DelayBox = Instance.new("TextBox")
DelayBox.Size = UDim2.new(0.45,-15,0,25)
DelayBox.Position = UDim2.new(0.55,0,0,110)

DelayBox.Text = tostring(Config.AutoPD.Delay)
DelayBox.PlaceholderText = "Delay"

DelayBox.Parent = EditorFrame

local SaveButton = Instance.new("TextButton")
SaveButton.Size = UDim2.new(1,-20,0,30)
SaveButton.Position = UDim2.new(0,10,1,-40)

SaveButton.Text = "Salvar"
SaveButton.Parent = EditorFrame

local function UpdateAutoText()

AutoToggle.Text =
    "Auto PD: "
    .. (Config.AutoPD.Enabled and "ON" or "OFF")

end

UpdateAutoText()

AutoToggle.Activated:Connect(function()

Config.AutoPD.Enabled =
    not Config.AutoPD.Enabled

UpdateAutoText()

end)

SaveButton.Activated:Connect(function()

if EditingIndex then

    Config.Commands[EditingIndex] =
        CommandBox.Text

    Buttons[EditingIndex].Text =
        CommandBox.Text

    local Count =
        tonumber(CountBox.Text)

    local Delay =
        tonumber(DelayBox.Text)

    if Count then
        Config.AutoPD.Count = Count
    end

    if Delay then
        Config.AutoPD.Delay = Delay
    end

    SaveConfig()

    EditorFrame.Visible = false
end

end)

local function OpenEditor(Index)

EditingIndex = Index

CommandBox.Text =
    Config.Commands[Index]

CountBox.Text =
    tostring(Config.AutoPD.Count)

DelayBox.Text =
    tostring(Config.AutoPD.Delay)

UpdateAutoText()

EditorFrame.Visible = true

end

--// BOTÃO FECHAR

local CloseButton = Instance.new("TextButton")

CloseButton.Size = UDim2.new(0,20,0,20)
CloseButton.Position = UDim2.new(1,-25,0,3)

CloseButton.Text = "X"
CloseButton.TextSize = 12

CloseButton.BackgroundTransparency = 1
CloseButton.TextColor3 = Color3.new(1,1,1)

CloseButton.Parent = EditorFrame

CloseButton.Activated:Connect(function()

EditorFrame.Visible = false

end)

--// BARRA DE PROGRESSO

local HoldBar = Instance.new("Frame")

HoldBar.Size = UDim2.new(0,0,0,3)
HoldBar.Position = UDim2.new(0,0,1,-3)

HoldBar.BackgroundColor3 = Color3.new(1,1,1)
HoldBar.BorderSizePixel = 0

HoldBar.Parent = panel

local HoldTween

--// AUTO PD APENAS NO PD PERM

local OldOpenEditor = OpenEditor

OpenEditor = function(Index)

OldOpenEditor(Index)

local IsPD = (Index == 2)

AutoToggle.Visible = IsPD
CountBox.Visible = IsPD
DelayBox.Visible = IsPD

end

--// IMPEDIR EXECUTAR AO EDITAR

for Index,Button in ipairs(Buttons) do

local Holding = false
local OpenedEditor = false

Button.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then

        Holding = true
        OpenedEditor = false

        HoldBar.Size = UDim2.new(0,0,0,3)

        HoldTween = TweenService:Create(
            HoldBar,
            TweenInfo.new(3),
            {
                Size = UDim2.new(1,0,0,3)
            }
        )

        HoldTween:Play()

        task.spawn(function()

            task.wait(3)

            if Holding then

                OpenedEditor = true

                OpenEditor(Index)
            end
        end)
    end
end)

Button.InputEnded:Connect(function(input)

    if input.UserInputType ~= Enum.UserInputType.Touch
    and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return
    end

    Holding = false

    if HoldTween then
        HoldTween:Cancel()
    end

    HoldBar.Size = UDim2.new(0,0,0,3)

    if OpenedEditor then
        return
    end

    ExecuteCommand(Index)

end)

end
