local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local gui = script.Parent -- The parent should be a ScreenGui.
local frame = gui:FindFirstChild("MainGUI") -- Make sure this frame exists in the GUI.

-- Function to add a highlight to a player's character
local function addHighlight(character)
    if character and not character:FindFirstChild("PlayerHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerHighlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)   -- Red fill
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0) -- Red outline
        highlight.Parent = character
    end
end

-- Listen for players joining and add highlights
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        addHighlight(character)
    end)
    if player.Character then
        addHighlight(player.Character)
    end
end

-- Apply highlights to existing players
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded) -- Monitor new players

-- Enable dragging for the MainGUI
if frame then
    frame.Active = true
    frame.Draggable = true

    -- Toggle GUI visibility when "Insert" key is pressed
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
            frame.Visible = not frame.Visible -- Toggle visibility
        end
    end)
end
