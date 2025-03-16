local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local userInputService = game:GetService("UserInputService")

local playerGui = localPlayer:WaitForChild("PlayerGui")

-- ESP SETTINGS
local espEnabled = true
local tracersEnabled = true
local espColor = Color3.new(1, 1, 1) -- Default: White

local espBoxes = {}
local tracers = {}

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- Bootup Text
local textLabel = Instance.new("TextLabel")
textLabel.Parent = screenGui
textLabel.Text = "NYRETHS SCRIPTS"
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.Position = UDim2.new(0, 0, 0, 0)
textLabel.Font = Enum.Font.Garamond
textLabel.TextSize = 50
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.BackgroundTransparency = 1
textLabel.TextTransparency = 1

local fadeIn = tweenService:Create(textLabel, TweenInfo.new(2, Enum.EasingStyle.Sine), {TextTransparency = 0})
fadeIn:Play()
fadeIn.Completed:Wait()

wait(2)

local fadeOut = tweenService:Create(textLabel, TweenInfo.new(2, Enum.EasingStyle.Sine), {TextTransparency = 1})
fadeOut:Play()
fadeOut.Completed:Wait()
textLabel:Destroy()

-- Создаем меню ESP
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 300, 0, 220)
menuFrame.Position = UDim2.new(0.5, -150, 0.3, 0)
menuFrame.BackgroundTransparency = 0.3
menuFrame.BackgroundColor3 = Color3.new(0, 0, 0)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = true
menuFrame.Active = true -- Включаем возможность перетаскивания

-- UI Corner (скругленные края)
local corner = Instance.new("UICorner", menuFrame)
corner.CornerRadius = UDim.new(0, 10)

-- Заголовок меню
local title = Instance.new("TextLabel", menuFrame)
title.Text = "nyreths esp menu"
title.Size = UDim2.new(1, 0, 0, 30)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

-- Кнопка включения/выключения ESP боксов
local toggleBoxes = Instance.new("TextButton", menuFrame)
toggleBoxes.Size = UDim2.new(0.9, 0, 0, 30)
toggleBoxes.Position = UDim2.new(0.05, 0, 0.2, 0)
toggleBoxes.Text = "Toggle Boxes: ON"
toggleBoxes.Font = Enum.Font.SourceSans
toggleBoxes.TextSize = 18
toggleBoxes.TextColor3 = Color3.new(1, 1, 1)
toggleBoxes.BackgroundTransparency = 0.5
toggleBoxes.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

toggleBoxes.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    toggleBoxes.Text = "Toggle Boxes: " .. (espEnabled and "ON" or "OFF")
end)

-- Кнопка включения/выключения трассеров
local toggleTracers = Instance.new("TextButton", menuFrame)
toggleTracers.Size = UDim2.new(0.9, 0, 0, 30)
toggleTracers.Position = UDim2.new(0.05, 0, 0.4, 0)
toggleTracers.Text = "Toggle Tracers: ON"
toggleTracers.Font = Enum.Font.SourceSans
toggleTracers.TextSize = 18
toggleTracers.TextColor3 = Color3.new(1, 1, 1)
toggleTracers.BackgroundTransparency = 0.5
toggleTracers.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

toggleTracers.MouseButton1Click:Connect(function()
    tracersEnabled = not tracersEnabled
    toggleTracers.Text = "Toggle Tracers: " .. (tracersEnabled and "ON" or "OFF")
end)

-- Кнопка смены цвета ESP
local changeColor = Instance.new("TextButton", menuFrame)
changeColor.Size = UDim2.new(0.9, 0, 0, 30)
changeColor.Position = UDim2.new(0.05, 0, 0.6, 0)
changeColor.Text = "Change Color"
changeColor.Font = Enum.Font.SourceSans
changeColor.TextSize = 18
changeColor.TextColor3 = Color3.new(1, 1, 1)
changeColor.BackgroundTransparency = 0.5
changeColor.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

changeColor.MouseButton1Click:Connect(function()
    espColor = Color3.new(math.random(), math.random(), math.random())
end)

-- Текстовая метка для клавиши открытия/закрытия меню
local keybindLabel = Instance.new("TextLabel", menuFrame)
keybindLabel.Text = "Press K to Open/Close Menu"
keybindLabel.Size = UDim2.new(1, 0, 0, 20)
keybindLabel.Position = UDim2.new(0, 0, 0.9, 0)
keybindLabel.Font = Enum.Font.SourceSans
keybindLabel.TextSize = 14
keybindLabel.TextColor3 = Color3.new(1, 1, 1)
keybindLabel.BackgroundTransparency = 1

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.K and not gameProcessed then
        menuFrame.Visible = not menuFrame.Visible
    end
end)

-- ДЕЛАЕМ МЕНЮ ПЕРЕТАСКИВАЕМЫМ
local dragging
local dragStart
local startPos

menuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = menuFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

menuFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        userInputService.InputChanged:Connect(function(input)
            if dragging then
                local delta = input.Position - dragStart
                menuFrame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end
end)

-- ESP Logic
local function createESP(player)
    if player == localPlayer then return end

    local box = Drawing.new("Square")
    box.Visible = false
    box.Thickness = 2
    box.Filled = false

    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Thickness = 1

    espBoxes[player] = box
    tracers[player] = tracer
end

local function updateESP()
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local screenPosition, onScreen = camera:WorldToViewportPoint(rootPart.Position)

            local box = espBoxes[player]
            local tracer = tracers[player]

            if onScreen then
                box.Size = Vector2.new(50, 100)
                box.Position = Vector2.new(screenPosition.X - 25, screenPosition.Y - 50)
                box.Color = espColor
                box.Visible = espEnabled

                tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                tracer.To = Vector2.new(screenPosition.X, screenPosition.Y)
                tracer.Color = espColor
                tracer.Visible = tracersEnabled
            else
                box.Visible = false
                tracer.Visible = false
            end
        end
    end
end

runService.RenderStepped:Connect(updateESP)
players.PlayerAdded:Connect(createESP)
for _, player in pairs(players:GetPlayers()) do createESP(player) end
