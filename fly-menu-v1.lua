local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local flying = false
local noclip = false
local speed = 50
local bodyGyro, bodyVelocity

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- Intro Text
local introLabel = Instance.new("TextLabel", screenGui)
introLabel.Size = UDim2.new(1, 0, 1, 0)
introLabel.BackgroundTransparency = 1
introLabel.TextColor3 = Color3.new(1, 1, 1)
introLabel.Text = "NYRETHS SCRIPTS"
introLabel.TextScaled = true
introLabel.Visible = true
introLabel.TextTransparency = 1
introLabel.Font = Enum.Font.Garamond

local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 180, 0, 160)
menuFrame.Position = UDim2.new(0, 10, 0, 10)
menuFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menuFrame.BackgroundTransparency = 0.5
menuFrame.Active = true
menuFrame.Draggable = true
menuFrame.Visible = false

local uiCorner = Instance.new("UICorner", menuFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

local titleLabel = Instance.new("TextLabel", menuFrame)
titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Fly Menu V1 by nyreth_"
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.TextScaled = true

local flyButton = Instance.new("TextButton", menuFrame)
flyButton.Size = UDim2.new(0.9, 0, 0.25, 0)
flyButton.Position = UDim2.new(0.05, 0, 0.3, 0)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.BorderSizePixel = 0
flyButton.AutoButtonColor = true

local flyButtonCorner = Instance.new("UICorner", flyButton)
flyButtonCorner.CornerRadius = UDim.new(0, 8)

local noclipButton = Instance.new("TextButton", menuFrame)
noclipButton.Size = UDim2.new(0.9, 0, 0.25, 0)
noclipButton.Position = UDim2.new(0.05, 0, 0.6, 0)
noclipButton.Text = "Noclip: OFF"
noclipButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.BorderSizePixel = 0
noclipButton.AutoButtonColor = true

local noclipButtonCorner = Instance.new("UICorner", noclipButton)
noclipButtonCorner.CornerRadius = UDim.new(0, 8)

local infoLabel = Instance.new("TextLabel", menuFrame)
infoLabel.Size = UDim2.new(1, 0, 0.15, 0)
infoLabel.Position = UDim2.new(0, 0, 0.85, 0)
infoLabel.Text = "Press K to Open/Close Menu"
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.new(1,1,1)
infoLabel.TextScaled = true

local userInputService = game:GetService("UserInputService")

userInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.K then
		menuFrame.Visible = not menuFrame.Visible
	end
end)

spawn(function()
	for i = 1, 0, -0.05 do
		introLabel.TextTransparency = i
		wait(0.05)
	end
	wait(1)
	for i = 0, 1, 0.05 do
		introLabel.TextTransparency = i
		wait(0.05)
	end
	introLabel.Visible = false
	menuFrame.Visible = true
end)

local userInputService = game:GetService("UserInputService")

local function updateFly()
	if flying then
		bodyGyro = Instance.new("BodyGyro", humanoidRootPart)
		bodyGyro.maxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bodyGyro.cframe = humanoidRootPart.CFrame

		bodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)
		bodyVelocity.maxForce = Vector3.new(math.huge, math.huge, math.huge)

		while flying do
			wait()
			bodyGyro.cframe = workspace.CurrentCamera.CFrame

			local moveDir = Vector3.new()
			if userInputService:IsKeyDown(Enum.KeyCode.W) then
				moveDir += workspace.CurrentCamera.CFrame.LookVector
			end
			if userInputService:IsKeyDown(Enum.KeyCode.S) then
				moveDir -= workspace.CurrentCamera.CFrame.LookVector
			end
			if userInputService:IsKeyDown(Enum.KeyCode.A) then
				moveDir -= workspace.CurrentCamera.CFrame.RightVector
			end
			if userInputService:IsKeyDown(Enum.KeyCode.D) then
				moveDir += workspace.CurrentCamera.CFrame.RightVector
			end
			if userInputService:IsKeyDown(Enum.KeyCode.Space) then
				moveDir += Vector3.new(0, 1, 0)
			end
			if userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
				moveDir -= Vector3.new(0, 1, 0)
			end

			bodyVelocity.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * speed or Vector3.new()
		end
	else
		if bodyGyro then bodyGyro:Destroy() end
		if bodyVelocity then bodyVelocity:Destroy() end
	end
end

game:GetService("RunService").Stepped:Connect(function()
	if noclip then
		for _, part in pairs(character:GetChildren()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

noclipButton.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipButton.Text = noclip and "Noclip: ON" or "Noclip: OFF"
end)

flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	flyButton.Text = flying and "Fly: ON" or "Fly: OFF"
	updateFly()
end)

-- fly-menu by nyreth_
