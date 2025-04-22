local Players = game:GetService("Players")

-- Adds a Highlight to the given character.
local function addHighlight(character)
    -- Check if the character exists and doesn't already have a highlight.
    if character and not character:FindFirstChild("PlayerHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerHighlight"
        -- Customize these colors as desired.
        highlight.FillColor = Color3.fromRGB(1, 0, 0)   
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0) 
        highlight.Parent = character
    end
end

-- Called whenever a new player joins.
local function onPlayerAdded(player)
    -- When this player's character appears, add the highlight.
    player.CharacterAdded:Connect(function(character)
        addHighlight(character)
    end)
    -- If the character already exists, highlight it immediately.
    if player.Character then
        addHighlight(player.Character)
    end
end

-- Highlight all players that are currently in the game.
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- Listen for and highlight any new players.
Players.PlayerAdded:Connect(onPlayerAdded)
