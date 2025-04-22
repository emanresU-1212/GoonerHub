local Players = game:GetService("Players")

local toggleESP = true

-- Function to apply or remove highlight
local function updateHighlight(player)
    if not player.Character then return end
    local highlight = player.Character:FindFirstChild("Highlight")

    if toggleESP then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.FillColor = Color3.new(1, 0, 0) -- Red color
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        end
    else
        if highlight then
            highlight:Destroy()
        end
    end
end

-- Function to update all players
local function updateAllPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        updateHighlight(player)
    end
end

-- GUI setup
local function createGui(player)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 150, 0, 50)
    frame.Position = UDim2.new(0, 0.01, 0, 0.01)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.Parent = screenGui

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = "ESP"
    button.TextScaled = true
    button.BackgroundColor3 = Color3.new(0.8, 0, 0)
    button.Parent = frame

    -- Toggle ESP effect
    button.MouseButton1Click:Connect(function()
        toggleESP = not toggleESP
        updateAllPlayers()
        button.BackgroundColor3 = toggleESP and Color3.new(0.8, 0, 0) or Color3.new(0.2, 0.2, 0.2)
    end)
end

-- Apply effect when players join or respawn
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        updateHighlight(player)
    end)
    player:WaitForChild("PlayerGui")
    createGui(player)
end)

-- Apply effect to existing players
for _, player in pairs(Players:GetPlayers()) do
    updateHighlight(player)
    createGui(player)
end
