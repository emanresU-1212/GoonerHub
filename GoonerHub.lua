local Players = game:GetService("Players")

local function addHighlight(character)
    -- Avoid duplicate highlights
    if character:FindFirstChild("PlayerHighlight") then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)       -- Set to red
    highlight.FillTransparency = 0.5                      -- Adjust as needed (0 = opaque, 1 = invisible)
    highlight.OutlineTransparency = 0.2                   -- Optionally adjust the outline
    highlight.Parent = character
end

local function setupCharacter(player)
    if player.Character then
        addHighlight(player.Character)
    end
    player.CharacterAdded:Connect(addHighlight)
end

-- Apply highlights to all current players
for _, player in pairs(Players:GetPlayers()) do
    setupCharacter(player)
end

-- Ensure new players get highlighted upon joining
Players.PlayerAdded:Connect(setupCharacter)
