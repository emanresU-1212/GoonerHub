local function highlightPlayers()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            local highlight = Instance.new("SelectionBox")
            highlight.Adornee = player.Character
            highlight.Parent = player.Character
            highlight.LineThickness = 0.05
            highlight.Color3 = Color3.new(1, 0, 0) -- Red highlight
        end
    end
end

highlightPlayers()
