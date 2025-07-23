-- Clean up old GUI if it exists
pcall(function() game.CoreGui:FindFirstChild("TeleportGUI"):Destroy() end)

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "TeleportGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.Size = UDim2.new(0, 260, 0, 270)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Teleport & Fling GUI"
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

-- Tabs frame
local TabsFrame = Instance.new("Frame", Frame)
TabsFrame.Size = UDim2.new(1, 0, 0, 30)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Position = UDim2.new(0, 0, 0, 30)

local TeleportTabButton = Instance.new("TextButton", TabsFrame)
TeleportTabButton.Text = "Teleport"
TeleportTabButton.Size = UDim2.new(0.5, 0, 1, 0)
TeleportTabButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
TeleportTabButton.TextColor3 = Color3.new(1,1,1)
TeleportTabButton.Font = Enum.Font.SourceSansBold
TeleportTabButton.TextSize = 16
TeleportTabButton.BorderSizePixel = 0

local FlingTabButton = Instance.new("TextButton", TabsFrame)
FlingTabButton.Text = "Fling"
FlingTabButton.Size = UDim2.new(0.5, 0, 1, 0)
FlingTabButton.Position = UDim2.new(0.5, 0, 0, 0)
FlingTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlingTabButton.TextColor3 = Color3.new(1,1,1)
FlingTabButton.Font = Enum.Font.SourceSansBold
FlingTabButton.TextSize = 16
FlingTabButton.BorderSizePixel = 0

-- Teleport UI container
local TeleportUI = Instance.new("Frame", Frame)
TeleportUI.Size = UDim2.new(1, 0, 1, -30)
TeleportUI.Position = UDim2.new(0, 0, 0, 30)
TeleportUI.BackgroundTransparency = 1

local TextBox = Instance.new("TextBox", TeleportUI)
TextBox.Position = UDim2.new(0.1, 0, 0.3, 0)
TextBox.Size = UDim2.new(0.8, 0, 0, 30)
TextBox.PlaceholderText = "Enter player name..."
TextBox.Text = ""
TextBox.Font = Enum.Font.SourceSans
TextBox.TextSize = 16
TextBox.TextColor3 = Color3.new(1,1,1)
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.BorderSizePixel = 0

local Button = Instance.new("TextButton", TeleportUI)
Button.Position = UDim2.new(0.1, 0, 0.6, 0)
Button.Size = UDim2.new(0.8, 0, 0, 30)
Button.Text = "Teleport"
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 16
Button.TextColor3 = Color3.new(1,1,1)
Button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
Button.BorderSizePixel = 0

local ErrorLabel = Instance.new("TextLabel", TeleportUI)
ErrorLabel.Position = UDim2.new(0.1, 0, 0.75, 0)
ErrorLabel.Size = UDim2.new(0.8, 0, 0, 30)
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Font = Enum.Font.SourceSansItalic
ErrorLabel.TextSize = 14

-- Fling UI container
local FlingUI = Instance.new("Frame", Frame)
FlingUI.Size = UDim2.new(1, 0, 1, -30)
FlingUI.Position = UDim2.new(0, 0, 0, 30)
FlingUI.BackgroundTransparency = 1
FlingUI.Visible = false

-- Player list for fling selection
local PlayerListFrame = Instance.new("ScrollingFrame", FlingUI)
PlayerListFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
PlayerListFrame.Size = UDim2.new(0.8, 0, 0, 150)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListFrame.ScrollBarThickness = 6

local UIListLayout = Instance.new("UIListLayout", PlayerListFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

local selectedPlayerName = nil

local function updatePlayerList()
    PlayerListFrame:ClearAllChildren()
    UIListLayout.Parent = PlayerListFrame -- Re-add after ClearAllChildren

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 16
            btn.Text = player.Name
            btn.Parent = PlayerListFrame
            btn.AutoButtonColor = true

            btn.MouseButton1Click:Connect(function()
                selectedPlayerName = player.Name
                -- Highlight selection
                for _, sibling in pairs(PlayerListFrame:GetChildren()) do
                    if sibling:IsA("TextButton") then
                        sibling.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    end
                end
                btn.BackgroundColor3 = Color3.fromRGB(100, 150, 100)
            end)
        end
    end
    -- Update canvas size for scrolling
    local contentSize = UIListLayout.AbsoluteContentSize
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y)
end

-- Update player list on join/leave
updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

local FlingButton = Instance.new("TextButton", FlingUI)
FlingButton.Position = UDim2.new(0.1, 0, 0.65, 0)
FlingButton.Size = UDim2.new(0.8, 0, 0, 30)
FlingButton.Text = "Fling Player"
FlingButton.Font = Enum.Font.SourceSansBold
FlingButton.TextSize = 16
FlingButton.TextColor3 = Color3.new(1,1,1)
FlingButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
FlingButton.BorderSizePixel = 0

local FlingErrorLabel = Instance.new("TextLabel", FlingUI)
FlingErrorLabel.Position = UDim2.new(0.1, 0, 0.8, 0)
FlingErrorLabel.Size = UDim2.new(0.8, 0, 0, 30)
FlingErrorLabel.Text = ""
FlingErrorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
FlingErrorLabel.BackgroundTransparency = 1
FlingErrorLabel.Font = Enum.Font.SourceSansItalic
FlingErrorLabel.TextSize = 14

local TouchFlingToggle = Instance.new("TextButton", FlingUI)
TouchFlingToggle.Position = UDim2.new(0.1, 0, 0.05, 0)
TouchFlingToggle.Size = UDim2.new(0.8, 0, 0, 30)
TouchFlingToggle.Text = "Enable Touch Fling"
TouchFlingToggle.Font = Enum.Font.SourceSansBold
TouchFlingToggle.TextSize = 16
TouchFlingToggle.TextColor3 = Color3.new(1,1,1)
TouchFlingToggle.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
TouchFlingToggle.BorderSizePixel = 0

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

-- Teleport autocomplete
TextBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = TextBox.Text
    local closest = getClosestName(text)
    if closest and closest:lower() ~= text:lower() and text ~= "" then
        TextBox.Text = closest
        TextBox.CursorPosition = #closest + 1
    end
end)

-- Teleport function
Button.MouseButton1Click:Connect(function()
    local nameInput = TextBox.Text
    local targetName = getClosestName(nameInput)
    local target = targetName and Players:FindFirstChild(targetName)

    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
            ErrorLabel.Text = ""
            print("Teleported to " .. targetName)
        else
            ErrorLabel.Text = "Your character is not loaded yet."
        end
    else
        ErrorLabel.Text = "Player not found."
    end
end)

-- Fling logic function
local function flingPlayer(targetPlayer)
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return false, "Your character is not loaded."
    end
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return false, "Target player not found or character missing."
    end

    -- Move local player near the target first (optional)
    hrp.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)

    -- Apply a strong velocity impulse to fling
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = (hrp.Position - targetPlayer.Character.HumanoidRootPart.Position).unit * 100 + Vector3.new(0, 50, 0)
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Parent = hrp

    Debris:AddItem(bodyVelocity, 0.5)

    return true
end

-- Manual fling button
FlingButton.MouseButton1Click:Connect(function()
    if not selectedPlayerName then
        FlingErrorLabel.Text = "Select a player from the list!"
        return
    end
    local targetPlayer = Players:FindFirstChild(selectedPlayerName)
    local success, err = flingPlayer(targetPlayer)
    if success then
        FlingErrorLabel.Text = ""
        print("Flinged player " .. selectedPlayerName)
    else
        FlingErrorLabel.Text = err or "Unknown error."
    end
end)

-- Touch fling toggle
local touchFlingEnabled = false
local flingCooldown = false
local touchConnection = nil

local function onTouch(otherPart)
    if not touchFlingEnabled or flingCooldown then return end

    local touchedCharacter = otherPart.Parent
    if not touchedCharacter then return end

    local targetHumanoid = touchedCharacter:FindFirstChildOfClass("Humanoid")
    if not targetHumanoid or targetHumanoid.Health <= 0 then return end

    local targetPlayer = Players:GetPlayerFromCharacter(touchedCharacter)
    if not targetPlayer or targetPlayer == LocalPlayer then return end

    local success, err = flingPlayer(targetPlayer)
    if success then
        flingCooldown = true
        wait(1) -- cooldown to prevent spamming
        flingCooldown = false
    end
end

TouchFlingToggle.MouseButton1Click:Connect(function()
    touchFlingEnabled = not touchFlingEnabled

    if touchFlingEnabled then
        TouchFlingToggle.Text = "Disable Touch Fling"
        TouchFlingToggle.BackgroundColor3 = Color3.fromRGB(130, 70, 70)
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            touchConnection = hrp.Touched:Connect(onTouch)
        else
            TouchFlingToggle.Text = "Enable Touch Fling"
            TouchFlingToggle.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
            touchFlingEnabled = false
            warn("HumanoidRootPart not found, cannot enable touch fling.")
        end
    else
        TouchFlingToggle.Text = "Enable Touch Fling"
        TouchFlingToggle.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
        if touchConnection then
            touchConnection:Disconnect()
            touchConnection = nil
        end
    end
end)

-- Handle reconnecting touch event on respawn
Players.LocalPlayer.CharacterAdded:Connect(function(char)
    if touchConnection then
        touchConnection:Disconnect()
        touchConnection = nil
    end
    if touchFlingEnabled then
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            touchConnection = hrp.Touched:Connect(onTouch)
        else
            warn("HumanoidRootPart not found after respawn.")
        end
    end
end)

-- Tab switching
TeleportTabButton.MouseButton1Click:Connect(function()
    TeleportUI.Visible = true
    FlingUI.Visible = false
    TeleportTabButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    FlingTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ErrorLabel.Text = ""
end)

FlingTabButton.MouseButton1Click:Connect(function()
    TeleportUI.Visible = false
    FlingUI.Visible = true
    TeleportTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    FlingTabButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    FlingErrorLabel.Text = ""
end)

-- Toggle GUI with RightShift and close with Escape
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightShift then
            ScreenGui.Enabled = not ScreenGui.Enabled
            ErrorLabel.Text = ""
            FlingErrorLabel.Text = ""
        elseif input.KeyCode == Enum.KeyCode.Escape and ScreenGui.Enabled then
            ScreenGui.Enabled = false
        end
    end
end)
