local function highlightPlayers()
    local highlightColor = Color3.fromRGB(255, 0, 0) -- Red highlight

    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    if not part:FindFirstChild("Highlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Adornee = part
                        highlight.FillColor = highlightColor
                        highlight.Parent = part
                    end
                end
            end
        end
    end
end

-- Continuously update every 5 seconds
while true do
    highlightPlayers()
    task.wait(5) -- Wait 5 seconds before refreshing
end
