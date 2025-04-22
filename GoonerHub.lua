--[[
    GoonerHub - By Goonerman
    This LocalScript creates a draggable main GUI with rounded corners and a title bar.
    The GUI contains two toggle buttons to enable/disable:
      • The red highlight effect on all player characters.
      • The name tag (BillboardGui) above player heads.
    Press "Insert" to show/hide the GUI.
    DISCLAIMER: Use only in your own games and with proper permissions.
--]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-----------------------------------
-- Global toggles for visual features
local highlightEnabled = true
local nameTagEnabled = true

-- Function to update/remove effects on a given character based on toggles
local function updateEffectsForCharacter(character, player)
    -- Red Highlight effect
    local highlight = character:FindFirstChild("PlayerHighlight")
    if highlightEnabled then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "PlayerHighlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)  -- red color
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0.8
            highlight.Parent = character
        end
    else
        if highlight then
            highlight:Destroy()
        end
    end

    -- Name Tag (BillboardGui)
    local nameTag = character:FindFirstChild("NameTag")
    if nameTagEnabled then
        local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 5)
        if head and not nameTag then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "NameTag"
            billboard.Adornee = head
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = character

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            textLabel.TextScaled = true
            textLabel.Font = Enum.Font.SourceSansBold
            textLabel.Text = player.Name
            textLabel.Parent = billboard
        end
    else
        if nameTag then
            nameTag:Destroy()
        end
    end
end

-- Called when a player's character spawns or respawns
local function onCharacterAdded(character, player)
    if not character:FindFirstChild("Head") then
        character:WaitForChild("Head", 5)
    end
    updateEffectsForCharacter(character, player)
end

-- Process players already in the game and attach character-added events
local function onPlayerAdded(player)
    if player.Character then
        onCharacterAdded(player.Character, player)
    end
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(character, player)
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end
Players.PlayerAdded:Connect(onPlayerAdded)

-- Helper that updates all players' characters whenever toggles change.
local function updateAllPlayerEffects()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            updateEffectsForCharacter(player.Character, player)
        end
    end
end

-----------------------------------
-- Create the Main GUI

-- Create a ScreenGui which will hold all UI elements and parent it to the player's PlayerGui.
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GoonerHubGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Create the main GUI frame
local mainGUI = Instance.new("Frame")
mainGUI.Name = "MainGUI"
mainGUI.Size = UDim2.new(0, 300, 0, 150)
mainGUI.Position = UDim2.new(0, 10, 0, 10)
mainGUI.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
mainGUI.BorderSizePixel = 0
mainGUI.Parent = screenGui

-- Add rounded corners to the main GUI
local mainGuiCorner = Instance.new("UICorner")
mainGuiCorner.CornerRadius = UDim.new(0, 10)
mainGuiCorner.Parent = mainGUI

-----------------------------------
-- Title Bar

-- Create the title bar at the top of the main GUI
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainGUI

-- Add rounded corners to the title bar (applied on the top corners)
local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 10)
titleBarCorner.Parent = titleBar

-- Title text label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "GoonerHub    By Goonerman"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = titleBar

-----------------------------------
-- Make the Main GUI draggable via the Title Bar

local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainGUI.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainGUI.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

-----------------------------------
-- Container for Toggle Buttons

local toggleFrame = Instance.new("Frame")
toggleFrame.Name = "ToggleFrame"
toggleFrame.Size = UDim2.new(1, -20, 1, -50)
toggleFrame.Position = UDim2.new(0, 10, 0, 40)
toggleFrame.BackgroundTransparency = 1
toggleFrame.Parent = mainGUI

-- Toggle button for the red highlight feature
local highlightButton = Instance.new("TextButton")
highlightButton.Name = "HighlightButton"
highlightButton.Size = UDim2.new(1, 0, 0, 40)
highlightButton.Position = UDim2.new(0, 0, 0, 0)
highlightButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
highlightButton.TextColor3 = Color3.new(1, 1, 1)
highlightButton.TextScaled = true
highlightButton.Font = Enum.Font.SourceSansBold
highlightButton.Text = "Red Highlight: Enabled"
highlightButton.Parent = toggleFrame

-- Toggle button for the name tag feature
local nameTagButton = Instance.new("TextButton")
nameTagButton.Name = "NameTagButton"
nameTagButton.Size = UDim2.new(1, 0, 0, 40)
nameTagButton.Position = UDim2.new(0, 0, 0, 50)
nameTagButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
nameTagButton.TextColor3 = Color3.new(1, 1, 1)
nameTagButton.TextScaled = true
nameTagButton.Font = Enum.Font.SourceSansBold
nameTagButton.Text = "Name Tags: Enabled"
nameTagButton.Parent = toggleFrame

-- Button events for toggling features on/off.
highlightButton.MouseButton1Click:Connect(function()
    highlightEnabled = not highlightEnabled
    highlightButton.Text = "Red Highlight: " .. (highlightEnabled and "Enabled" or "Disabled")
    updateAllPlayerEffects()
end)

nameTagButton.MouseButton1Click:Connect(function()
    nameTagEnabled = not nameTagEnabled
    nameTagButton.Text = "Name Tags: " .. (nameTagEnabled and "Enabled" or "Disabled")
    updateAllPlayerEffects()
end)

-----------------------------------
-- Toggle the visibility of the Main GUI when pressing the "Insert" key.
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        mainGUI.Visible = not mainGUI.Visible
    end
end)
