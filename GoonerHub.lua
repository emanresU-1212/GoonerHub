--[[
    GoonerHub - By Goonerman

    This LocalScript creates a draggable MainGUI with rounded corners and a title bar.
    It provides toggleable features including:
      • Red Highlight effect on all player characters.
      • Name Tags (BillboardGui) above player heads.
      • Camera Lock: 
            – Displays a circular FOV outline in the center of the screen.
            – Allows you to adjust the circle size via a text box.
            – When enabled and while holding Mouse Button 2, the camera tracks the player head 
              closest to the circle's center.
    
    Press "Insert" to show/hide the MainGUI.
    
    DISCLAIMER: Use only in games you own or with proper permissions.
--]]

---------------------
-- Services and Variables
---------------------
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Feature toggles
local highlightEnabled = true
local nameTagEnabled = true
local cameraLockEnabled = false  -- Default off; toggle via the UI
local cameraLockActive = false   -- True only when you hold right mouse button (MouseButton2)
local cameraLockFOV = 200        -- Default diameter (in pixels) for the FOV circle

---------------------
-- Existing Effects Functions
---------------------
local function addHighlight(character)
    if character:FindFirstChild("PlayerHighlight") then
        return
    end
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red color
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0.8
    highlight.Parent = character
end

local function addNameTag(character, player)
    local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 5)
    if not head then return end
    if character:FindFirstChild("NameTag") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NameTag"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = character

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Text = player.Name
    textLabel.Parent = billboard
end

local function updateEffectsForCharacter(character, player)
    -- Red Highlight Handler
    local highlight = character:FindFirstChild("PlayerHighlight")
    if highlightEnabled then
        if not highlight then
            addHighlight(character)
        end
    else
        if highlight then
            highlight:Destroy()
        end
    end

    -- Name Tag Handler
    local nameTag = character:FindFirstChild("NameTag")
    if nameTagEnabled then
        local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 5)
        if head and not nameTag then
            addNameTag(character, player)
        end
    else
        if nameTag then
            nameTag:Destroy()
        end
    end
end

local function onCharacterAdded(character, player)
    if not character:FindFirstChild("Head") then
        character:WaitForChild("Head", 5)
    end
    updateEffectsForCharacter(character, player)
end

local function onPlayerAdded(player)
    if player.Character then
        onCharacterAdded(player.Character, player)
    end
    player.CharacterAdded:Connect(function(character)
        onCharacterAdded(character, player)
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end
Players.PlayerAdded:Connect(onPlayerAdded)

-- Helper: Update effects on every player character when toggles change
local function updateAllPlayerEffects()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            updateEffectsForCharacter(player.Character, player)
        end
    end
end

---------------------
-- Create the Main GUI and its Elements
---------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GoonerHubGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main GUI frame (adjusted to be taller to hold extra UI elements)
local mainGUI = Instance.new("Frame")
mainGUI.Name = "MainGUI"
mainGUI.Size = UDim2.new(0, 300, 0, 240)
mainGUI.Position = UDim2.new(0, 10, 0, 10)
mainGUI.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
mainGUI.BorderSizePixel = 0
mainGUI.Parent = screenGui

local mainGuiCorner = Instance.new("UICorner")
mainGuiCorner.CornerRadius = UDim.new(0, 10)
mainGuiCorner.Parent = mainGUI

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainGUI

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 10)
titleBarCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "GoonerHub    By Goonerman"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = titleBar

-- Make the Main GUI draggable via the Title Bar
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainGUI.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainGUI.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateDrag(input)
    end
end)

-- Toggle container inside Main GUI
local toggleFrame = Instance.new("Frame")
toggleFrame.Name = "ToggleFrame"
toggleFrame.Position = UDim2.new(0, 10, 0, 35)
toggleFrame.Size = UDim2.new(1, -20, 0, 200)
toggleFrame.BackgroundTransparency = 1
toggleFrame.Parent = mainGUI

-- Row 1: Red Highlight Toggle Button
local highlightButton = Instance.new("TextButton")
highlightButton.Name = "HighlightButton"
highlightButton.Size = UDim2.new(1, 0, 0, 40)
highlightButton.Position = UDim2.new(0, 0, 0, 0)
highlightButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
highlightButton.TextColor3 = Color3.new(1, 1, 1)
highlightButton.TextScaled = true
highlightButton.Font = Enum.Font.SourceSansBold
highlightButton.Text = "Red Highlight: Enabled"
highlightButton.Parent = toggleFrame

-- Row 2: Name Tag Toggle Button
local nameTagButton = Instance.new("TextButton")
nameTagButton.Name = "NameTagButton"
nameTagButton.Size = UDim2.new(1, 0, 0, 40)
nameTagButton.Position = UDim2.new(0, 0, 0, 45)
nameTagButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
nameTagButton.TextColor3 = Color3.new(1, 1, 1)
nameTagButton.TextScaled = true
nameTagButton.Font = Enum.Font.SourceSansBold
nameTagButton.Text = "Name Tags: Enabled"
nameTagButton.Parent = toggleFrame

-- Row 3: Camera Lock Toggle Button
local cameraLockButton = Instance.new("TextButton")
cameraLockButton.Name = "CameraLockButton"
cameraLockButton.Size = UDim2.new(1, 0, 0, 40)
cameraLockButton.Position = UDim2.new(0, 0, 0, 90)
cameraLockButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
cameraLockButton.TextColor3 = Color3.new(1, 1, 1)
cameraLockButton.TextScaled = true
cameraLockButton.Font = Enum.Font.SourceSansBold
cameraLockButton.Text = "Camera Lock: Disabled"
cameraLockButton.Parent = toggleFrame

-- Row 4: FOV Setting (Label and TextBox)
local fovFrame = Instance.new("Frame")
fovFrame.Name = "FOVFrame"
fovFrame.Position = UDim2.new(0, 0, 0, 135)
fovFrame.Size = UDim2.new(1, 0, 0, 40)
fovFrame.BackgroundTransparency = 1
fovFrame.Parent = toggleFrame

local fovLabel = Instance.new("TextLabel")
fovLabel.Name = "FOVLabel"
fovLabel.Size = UDim2.new(0, 50, 1, 0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV:"
fovLabel.TextScaled = true
fovLabel.Font = Enum.Font.SourceSansBold
fovLabel.TextColor3 = Color3.new(1, 1, 1)
fovLabel.Parent = fovFrame

local fovTextBox = Instance.new("TextBox")
fovTextBox.Name = "FOVTextBox"
fovTextBox.Size = UDim2.new(0, 60, 0.8, 0)
fovTextBox.Position = UDim2.new(0, 55, 0.1, 0)
fovTextBox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
fovTextBox.TextScaled = true
fovTextBox.Font = Enum.Font.SourceSansBold
fovTextBox.TextColor3 = Color3.new(1, 1, 1)
fovTextBox.Text = tostring(cameraLockFOV)
fovTextBox.Parent = fovFrame

---------------------
-- UI Button Events for Toggles
---------------------
highlightButton.MouseButton1Click:Connect(function()
    highlightEnabled = not highlightEnabled
    highlightButton.Text = "Red Highlight: " .. (highlightEnabled and "Enabled" or "Disabled")
    updateAllPlayerEffects()
end)

nameTagButton.MouseButton1Click:Connect(function()
    nameTagEnabled = not nameTagEnabled
    nameTagButton.Text = "Name Tags: " .. (nameTagEnabled and "Enabled" or "Disabled")
    updateAllPlayerEffects()
end)

cameraLockButton.MouseButton1Click:Connect(function()
    cameraLockEnabled = not cameraLockEnabled
    cameraLockButton.Text = "Camera Lock: " .. (cameraLockEnabled and "Enabled" or "Disabled")
    -- Show or hide the FOV circle accordingly.
    cameraLockCircle.Visible = cameraLockEnabled
end)

fovTextBox.FocusLost:Connect(function(enterPressed)
    local newFov = tonumber(fovTextBox.Text)
    if newFov then
        cameraLockFOV = newFov
        fovTextBox.Text = tostring(newFov)
        cameraLockCircle.Size = UDim2.new(0, cameraLockFOV, 0, cameraLockFOV)
    else
        fovTextBox.Text = tostring(cameraLockFOV)
    end
end)

---------------------
-- Toggle the visibility of the Main GUI using the Insert key
---------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        mainGUI.Visible = not mainGUI.Visible
    end
end)

---------------------
-- Create a Centered FOV Circle for the Camera Lock Feature
---------------------
local cameraLockCircle = Instance.new("Frame")
cameraLockCircle.Name = "CameraLockCircle"
cameraLockCircle.AnchorPoint = Vector2.new(0.5, 0.5)
cameraLockCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
cameraLockCircle.Size = UDim2.new(0, cameraLockFOV, 0, cameraLockFOV)
cameraLockCircle.BackgroundTransparency = 1
cameraLockCircle.BorderSizePixel = 3
cameraLockCircle.BorderColor3 = Color3.new(1, 1, 1)
cameraLockCircle.Visible = cameraLockEnabled
cameraLockCircle.Parent = screenGui

local circleUICorner = Instance.new("UICorner")
circleUICorner.CornerRadius = UDim.new(0.5, 0)
circleUICorner.Parent = cameraLockCircle

---------------------
-- Camera Lock Functionality
---------------------
-- Returns the head of the player (not local) whose screen position is closest to the center.
local function findClosestTarget()
    local cam = Workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local closestTarget = nil
    local closestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local screenPoint, onScreen = cam:WorldToViewportPoint(head.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestTarget = head
                    end
                end
            end
        end
    end
    return closestTarget
end

-- Right Mouse Button (MouseButton2) controls camera lock activation.
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if cameraLockEnabled then
            cameraLockActive = true
            local cam = Workspace.CurrentCamera
            cam.CameraType = Enum.CameraType.Scriptable
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        cameraLockActive = false
        local cam = Workspace.CurrentCamera
        cam.CameraType = Enum.CameraType.Custom
    end
end)

-- Update camera every frame while camera lock is active.
RunService.RenderStepped:Connect(function()
    if cameraLockActive and cameraLockEnabled then
        local cam = Workspace.CurrentCamera
        local targetHead = findClosestTarget()
        if targetHead then
            local currentPos = cam.CFrame.Position
            cam.CFrame = CFrame.new(currentPos, targetHead.Position)
        end
    end
end)
