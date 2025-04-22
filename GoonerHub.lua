local function applyHighlight(player)
    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.FillColor = Color3.new(1, 0, 0) -- Red color
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end

local function highlightAllPlayers()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            applyHighlight(player)
        end
    end
end

-- Apply highlight when a player joins
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        applyHighlight(player)
    end)
end)

-- Apply highlight to all existing players
highlightAllPlayers()
