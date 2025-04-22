--[[
    Toggleable Features: Red Highlight and NameTag
    Press the "Insert" key to toggle the settings panel.
    This LocalScript allows you to enable or disable:
      • A red Highlight effect on all player characters.
      • A BillboardGui that displays player names above their heads.
    DISCLAIMER: Use only in your own games and with proper permissions.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Global toggle flags
local highlightEnabled = true
local nameTagEnabled = true

-- Function to update (or remove) effects on a given character according to the toggles
local function updateEffectsForCharacter(character, player)
    -- Handle Red Highlight effect
    local highlight = character:FindFirstChild("PlayerHighlight")
    if highlightEnabled then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "PlayerHighlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)  -- red color
            highlight.FillTransparency = 0.5                -- adjust transparency as needed
            highlight.OutlineTransparency = 0.8
            highlight.Parent = character
        end
    else
        if highlight then
            highlight:Destroy()
        end
    end

    -- Handle NameTag effect
    local nameTag = character:FindFirstChild("NameTag")
    if nameTagEnabled then
        -- Ensure the character has a "Head" part
        local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 5)
        if head and not nameTag then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "NameTag"
            billboard.Adornee = head
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 2, 0)  -- positions the label slightly above the head
            billboard.AlwaysOnTop = true
            billboard.Parent = character

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.new(1, 1, 1)       -- white text
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

-- Called whenever a player's character spawns (or respawns)
local function onCharacterAdded(character, player)
    -- Optional: wait to ensure the Head exists.
    if not character:FindFirstChild("Head") then
        character:WaitForChild("Head", 5)
    end
    updateEffectsForCharacter(character, player)
end

-- Setup event to process players' characters when joining
local function onPlayerAdded(player)
    if player.Character then
        onCharacterAdded(player.Character, player)
    end
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(character, player)
    end)
end

-- Process current players
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)

-- Helper: Update effects on every player character when toggles change
local function updateAllPlayerEffects()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            updateEffectsForCharacter(player.Character, player)
        end
    end
end

--------------------------------------------------------------------------------
-- Create Toggle UI elements

-- Create a ScreenGui that will hold our toggle panel
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FeatureToggleGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Create the panel (a Frame) to contain our buttons.
local toggleFrame = Instance.new("Frame")
toggleFrame.Name = "TogglePanel"
toggleFrame.Size = UDim2.new(0, 260, 0, 100)
toggleFrame.Position = UDim2.new(0, 10, 0, 10)  -- top-left of the screen; adjust as desired
toggleFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
toggleFrame.BorderSizePixel = 0
toggleFrame.Visible = true
toggleFrame.Parent = screenGui

-- Create the toggle button for the red highlight feature.
local highlightButton = Instance.new("TextButton")
highlightButton.Name = "HighlightButton"
highlightButton.Size = UDim2.new(1, -20, 0, 40)
highlightButton.Position = UDim2.new(0, 10, 0, 10)
highlightButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
highlightButton.TextColor3 = Color3.new(1, 1, 1)
highlightButton.TextScaled = true
highlightButton.Font = Enum.Font.SourceSansBold
highlightButton.Text = "Red Highlight: Enabled"
highlightButton.Parent = toggleFrame

-- Create the toggle button for the name tag feature.
local nameTagButton = Instance.new("TextButton")
nameTagButton.Name = "NameTagButton"
nameTagButton.Size = UDim2.new(1, -20, 0, 40)
nameTagButton.Position = UDim2.new(0, 10, 0, 55)
nameTagButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
nameTagButton.TextColor3 = Color3.new(1, 1, 1)
nameTagButton.TextScaled = true
nameTagButton.Font = Enum.Font.SourceSansBold
nameTagButton.Text = "Name Tags: Enabled"
nameTagButton.Parent = toggleFrame

--------------------------------------------------------------------------------
-- Button events: Toggle features and update buttons accordingly.

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

--------------------------------------------------------------------------------
-- Toggle the visibility of the settings panel using the "Insert" key.
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        toggleFrame.Visible = not toggleFrame.Visible
    end
end)
