-- Clean up old GUI if it exists
pcall(function() game.CoreGui:FindFirstChild("TeleportGUI"):Destroy() end)

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "TeleportGUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.Size = UDim2.new(0, 260, 0, 170)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Teleport to Player"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

local Close = Instance.new("TextButton", Frame)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -30, 0, 0)
Close.Text = "X"
Close.Font = Enum.Font.SourceSansBold
Close.TextSize = 18
Close.TextColor3 = Color3.new(1, 1, 1)
Close.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
Close.BorderSizePixel = 0
Close.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

local TextBox = Instance.new("TextBox", Frame)
TextBox.Position = UDim2.new(0.1, 0, 0.4, 0)
TextBox.Size = UDim2.new(0.8, 0, 0, 30)
TextBox.PlaceholderText = "Enter player name..."
TextBox.Text = ""
TextBox.Font = Enum.Font.SourceSans
TextBox.TextSize = 16
TextBox.TextColor3 = Color3.new(1,1,1)
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.BorderSizePixel = 0

local Button = Instance.new("TextButton", Frame)
Button.Position = UDim2.new(0.1, 0, 0.7, 0)
Button.Size = UDim2.new(0.8, 0, 0, 30)
Button.Text = "Teleport"
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 16
Button.TextColor3 = Color3.new(1,1,1)
Button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
Button.BorderSizePixel = 0

-- Autocomplete name (match first partial name)
local function getClosestName(partial)
    partial = partial:lower()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Name:lower():sub(1, #partial) == partial then
            return player.Name
        end
    end
    return nil
end

-- Teleport function
Button.MouseButton1Click:Connect(function()
    local nameInput = TextBox.Text
    local targetName = getClosestName(nameInput)
    local target = targetName and Players:FindFirstChild(targetName)

    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
        print("Teleported to " .. targetName)
    else
        warn("Player not found.")
    end
end)

-- Toggle GUI with RightShift
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
