--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui")

--// Local Player
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

--// Intro Text
local IntroText = Instance.new("TextLabel")
IntroText.Text = "NYRETHS SCRIPTS"
IntroText.Size = UDim2.new(1, 0, 1, 0)
IntroText.Position = UDim2.new(0, 0, 0, 0)
IntroText.BackgroundTransparency = 1
IntroText.TextScaled = true
IntroText.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroText.Font = Enum.Font.Garamond
IntroText.Parent = ScreenGui

-- Fade Animation
local fadeIn = TweenService:Create(IntroText, TweenInfo.new(1.5), {TextTransparency = 0})
local fadeOut = TweenService:Create(IntroText, TweenInfo.new(1.5), {TextTransparency = 1})

fadeIn:Play()
fadeIn.Completed:Wait()
task.wait(1)
fadeOut:Play()
fadeOut.Completed:Wait()
IntroText:Destroy()

--// Transparent Top Text
local TopText = Instance.new("TextLabel")
TopText.Text = "Made by nyreth_\nDiscord: https://discord.gg/FzANVJNtJT"
TopText.Size = UDim2.new(1, 0, 0, 40)
TopText.Position = UDim2.new(0, 0, 0.02, 0) -- Top Middle
TopText.BackgroundTransparency = 1
TopText.TextTransparency = 0.5 -- 50% Transparent
TopText.TextColor3 = Color3.fromRGB(255, 255, 255)
TopText.TextScaled = true
TopText.Font = Enum.Font.GothamBold
TopText.Parent = ScreenGui

--// Menu Creation
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 270, 0, 220)
Frame.Position = UDim2.new(0.5, -135, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.3
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Visible = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = Frame

--// Title Bar
local TitleBar = Instance.new("TextLabel")
TitleBar.Text = "🎯 Aimbot Menu V1 by nyreth_"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleBar

--// Dragging
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
TitleBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position - dragStart).X, startPos.Y.Scale, startPos.Y.Offset + (input.Position - dragStart).Y) end end)

--// Button Creation
local function createButton(text, yOffset)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, yOffset)
    Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 16
    Button.Parent = Frame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = Button

    return Button
end

local ToggleButton = createButton("Enable Aimbot", 40)
local NearestAimbotButton = createButton("Enable Nearest Aimbot", 90)

local InputField = Instance.new("TextBox")
InputField.Size = UDim2.new(1, -20, 0, 30)
InputField.Position = UDim2.new(0, 10, 0, 140)
InputField.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
InputField.TextColor3 = Color3.fromRGB(255, 255, 255)
InputField.Text = "Enter Player Name"
InputField.Font = Enum.Font.Gotham
InputField.TextSize = 14
InputField.Parent = Frame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 10)
InputCorner.Parent = InputField

local HintText = Instance.new("TextLabel")
HintText.Text = "Press K to Open/Close Menu"
HintText.Size = UDim2.new(1, 0, 0, 20)
HintText.Position = UDim2.new(0, 0, 1, -20)
HintText.BackgroundTransparency = 1
HintText.TextColor3 = Color3.fromRGB(200, 200, 200)
HintText.Font = Enum.Font.Gotham
HintText.TextSize = 12
HintText.Parent = Frame

--// Aimbot Variables
local aimbotEnabled = false
local nearestAimbot = false
local targetPlayerName = nil
local smoothness = 0.1

--// Toggle Aimbot
ToggleButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    nearestAimbot = false
    ToggleButton.Text = aimbotEnabled and "Disable Aimbot" or "Enable Aimbot"
    NearestAimbotButton.Text = "Enable Nearest Aimbot"
    ToggleButton.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(80, 80, 80)
end)

NearestAimbotButton.MouseButton1Click:Connect(function()
    nearestAimbot = not nearestAimbot
    aimbotEnabled = false
    NearestAimbotButton.Text = nearestAimbot and "Disable Nearest Aimbot" or "Enable Nearest Aimbot"
    ToggleButton.Text = "Enable Aimbot"
    NearestAimbotButton.BackgroundColor3 = nearestAimbot and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(80, 80, 80)
end)

InputField.FocusLost:Connect(function()
    targetPlayerName = InputField.Text
end)

--// Find Nearest Player
local function getNearestPlayer()
    local nearestDist, nearestPlayer = math.huge, nil
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local dist = (player.Character.Head.Position - Camera.CFrame.Position).magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearestPlayer = player
            end
        end
    end
    return nearestPlayer
end

RunService.RenderStepped:Connect(function()
    local target = nearestAimbot and getNearestPlayer() or Players:FindFirstChild(targetPlayerName)
    if aimbotEnabled or nearestAimbot and target and target.Character then
        local head = target.Character:FindFirstChild("Head")
        if head then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, head.Position), smoothness)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.K then
        Frame.Visible = not Frame.Visible
    end
end)
