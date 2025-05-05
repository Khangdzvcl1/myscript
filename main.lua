local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- Icon con mắt
local eyeButton = Instance.new("ImageButton", gui)
eyeButton.Size = UDim2.new(0, 50, 0, 50)
eyeButton.Position = UDim2.new(0, 10, 0, 10)
eyeButton.Image = "rbxassetid://6035047409"

-- Logo Discord dưới con mắt
local discordLogo = Instance.new("ImageLabel", gui)
discordLogo.Size = UDim2.new(0, 30, 0, 30)
discordLogo.Position = UDim2.new(0, 15, 0, 65)
discordLogo.Image = "rbxassetid://6034978715"
discordLogo.BackgroundTransparency = 1

-- Đường link đến server Discord
local discordLink = "https://discord.gg/tSVP4W6U"

-- Chuyển qua Discord khi nhấn vào logo
discordLogo.MouseButton1Click:Connect(function()
    game:GetService("GuiService"):OpenBrowserWindow(discordLink)
end)

-- Menu Frame
local menuFrame = Instance.new("Frame", gui)
menuFrame.Visible = false
menuFrame.Size = UDim2.new(0, 300, 0, 400)
menuFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
menuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

-- Toggle menu
eyeButton.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)

-- Auto Farm
local autoFarm = false
local btnFarm = Instance.new("TextButton", menuFrame)
btnFarm.Size = UDim2.new(1, -20, 0, 50)
btnFarm.Position = UDim2.new(0, 10, 0, 10)
btnFarm.Text = "Auto Farm: OFF"
btnFarm.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btnFarm.TextColor3 = Color3.fromRGB(255, 255, 255)

btnFarm.MouseButton1Click:Connect(function()
	autoFarm = not autoFarm
	btnFarm.Text = "Auto Farm: " .. (autoFarm and "ON" or "OFF")
end)

-- Nút Auto Thay Gas
local autoGas = false
local btnGas = Instance.new("TextButton", menuFrame)
btnGas.Size = UDim2.new(1, -20, 0, 50)
btnGas.Position = UDim2.new(0, 10, 0, 70)
btnGas.Text = "Auto Thay Gas: OFF"
btnGas.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btnGas.TextColor3 = Color3.fromRGB(255, 255, 255)

btnGas.MouseButton1Click:Connect(function()
	autoGas = not autoGas
	btnGas.Text = "Auto Thay Gas: " .. (autoGas and "ON" or "OFF")
end)

-- Nút Auto Thay Kiếm
local autoBlade = false
local btnBlade = Instance.new("TextButton", menuFrame)
btnBlade.Size = UDim2.new(1, -20, 0, 50)
btnBlade.Position = UDim2.new(0, 10, 0, 130)
btnBlade.Text = "Auto Thay Kiếm: OFF"
btnBlade.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btnBlade.TextColor3 = Color3.fromRGB(255, 255, 255)

btnBlade.MouseButton1Click:Connect(function()
	autoBlade = not autoBlade
	btnBlade.Text = "Auto Thay Kiếm: " .. (autoBlade and "ON" or "OFF")
end)

-- Chức năng auto tấn công Titan
game:GetService("RunService").RenderStepped:Connect(function()
	if autoFarm then
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("Model") and obj.Name:lower():find("titan") and obj:FindFirstChild("HumanoidRootPart") then
				local char = player.Character
				if char and char:FindFirstChild("HumanoidRootPart") then
					-- Di chuyển đến Titan
					char.HumanoidRootPart.CFrame = obj.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
					
					-- Tự động tấn công Titan
					local sword = char:FindFirstChild("Sword")
					if sword and sword:IsA("Tool") then
						-- Tự động chém Titan
						sword:Activate() 
					end
					
					-- Nếu đủ gần Titan, thực hiện chém
					break
				end
			end
		end
	end
end)

-- Tự động thay gas và kiếm
game:GetService("RunService").RenderStepped:Connect(function()
	local char = player.Character
	if not char then return end

	if autoGas and char:FindFirstChild("Gas") then
		local gasValue = char:FindFirstChild("Gas")
		if gasValue:IsA("NumberValue") and gasValue.Value < 15 then
			local refillGasEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Events"):FindFirstChild("RefillGas")
			if refillGasEvent then
				refillGasEvent:FireServer()
			end
		end
	end

	if autoBlade and char:FindFirstChild("BladeDurability") then
		local bladeValue = char:FindFirstChild("BladeDurability")
		if bladeValue:IsA("NumberValue") and bladeValue.Value < 10 then
			local refillBladeEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Events"):FindFirstChild("RefillBlade")
			if refillBladeEvent then
				refillBladeEvent:FireServer()
			end
		end
	end
end)

-- Hàm tạo ESP cho Titan
local function createESP(target)
	if not target:FindFirstChild("Head") then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "TitanESP"
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.Adornee = target.Head
	billboard.AlwaysOnTop = true
	billboard.StudsOffset = Vector3.new(0, 3, 0)

	local label = Instance.new("TextLabel", billboard)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "TITAN"
	label.TextColor3 = Color3.fromRGB(255, 0, 0)
	label.TextStrokeTransparency = 0.5
	label.TextScaled = true

	billboard.Parent = target
end

-- Duyệt và tạo ESP
game:GetService("RunService").RenderStepped:Connect(function()
	if not autoFarm then return end

	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name:lower():find("titan") and not obj:FindFirstChild("TitanESP") then
			createESP(obj)
		end
	end
end)

