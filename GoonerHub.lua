local function highlightPlayers()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = part
                    highlight.FillColor = Color3.new(1, 0, 0) 
                    highlight.OutlineColor = Color3.new(0, 0, 0) 
                end
            end
        end
    end
end

-- Run the function when players join
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAppearanceLoaded:Connect(function()
        highlightPlayers()
    end)
end)

-- Highlight existing players
highlightPlayers()
