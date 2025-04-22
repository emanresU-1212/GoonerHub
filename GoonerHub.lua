local Players = game:GetService("Players")

local toggleESP = false

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

-- GUI Setup inside `StarterPlayerScripts`
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0, 0.01, 0, 0.01)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.Active = true -- Allows input events
frame.Parent = screenGui

-- UI Constraint to smooth dragging
local uiConstraint = Instance.new("UIAspectRatioConstraint")
uiConstraint.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.Text = "ESP"
button.TextScaled = true
button.BackgroundColor3 = Color3.new(0.8, 0, 0)
button.Parent = frame -- Ensuring button is inside the frame

-- Dragging functionality
local dragging
local dragInput
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle ESP effect
button.MouseButton1Click:Connect(function()
    toggleESP = not toggleESP
    updateAllPlayers()
    button.BackgroundColor3 = toggleESP and Color3.new(0.8, 0, 0) or Color3.new(0.2, 0.2, 0.2)
end)

-- Update ESP when players join
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        updateHighlight(player)
    end)
end)

updateAllPlayers() -- Ensure all players have ESP applied
