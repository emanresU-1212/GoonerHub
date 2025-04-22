while true do
    wait(0.5)
    print('hi')
end
local Players = game:GetService("Players")

-- Function to add a red highlight to the player's character
local function addHighlight(character)
    if character:FindFirstChild("PlayerHighlight") then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)       -- Red color
    highlight.FillTransparency = 0.5                      -- Adjust as desired
    highlight.OutlineTransparency = 0.2                   -- Adjust the outline if needed
    highlight.Parent = character
end

-- Function to add a BillboardGui name tag to the player's head
local function addNameTag(character, player)
    local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 5)
    if not head then
        return
    end

    -- Prevent duplicate name tags
    if head:FindFirstChild("NameTag") then
        return
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NameTag"
    billboard.Adornee = head
    billboard.Parent = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)  -- Positions label slightly above the head
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel", billboard)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)       -- White text
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Text = player.Name
end

-- Sets up a player's character when they join or respawn
local function setupCharacter(player)
    if player.Character then
        addHighlight(player.Character)
        addNameTag(player.Character, player)
    end
    player.CharacterAdded:Connect(function(character)
        addHighlight(character)
        addNameTag(character, player)
    end)
end

-- Apply the functions to all current players
for _, player in pairs(Players:GetPlayers()) do
    setupCharacter(player)
end

-- Ensure new players are set up when they join
Players.PlayerAdded:Connect(setupCharacter)
