local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create the ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Create the Draggable Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 150, 0, 50)
Frame.Position = UDim2.new(0.5, -75, 0.1, 0)
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Create the Button
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, 0, 1, 0)
Button.Text = "Toggle Highlight"
Button.TextColor3 = Color3.new(1, 1, 1)
Button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
Button.Parent = Frame

-- Function to toggle highlight effect
local function toggleHighlight()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local highlight = player.Character:FindFirstChild("Highlight")
            if highlight then
                highlight:Destroy()
            else
                local newHighlight = Instance.new("Highlight")
                newHighlight.Parent = player.Character
                newHighlight.FillColor = Color3.new(1, 1, 0) -- Yellow highlight
            end
        end
    end
end

-- Connect button click to toggle function
Button.MouseButton1Click:Connect(toggleHighlight)
