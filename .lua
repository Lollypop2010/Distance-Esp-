local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- Configuration settings
local ESPColor = Color3.fromRGB(255, 255, 255)  -- Color of the distance text
local TextSize = 18  -- Size of the distance text
local MaxDistance = 500  -- Max distance for ESP visibility

-- Create and update ESP
local function CreateDistanceESP(Player)
    if Player == LocalPlayer then return end

    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Adornee = Player.Character:WaitForChild("Head")
    BillboardGui.Size = UDim2.new(0, 100, 0, 25)
    BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
    BillboardGui.AlwaysOnTop = true

    local TextLabel = Instance.new("TextLabel", BillboardGui)
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = ESPColor
    TextLabel.TextStrokeTransparency = 0.5
    TextLabel.TextScaled = true
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.TextSize = TextSize

    BillboardGui.Parent = Player.Character:WaitForChild("Head")

    -- Update the distance label
    local function UpdateDistance()
        if Player.Character and Player.Character:FindFirstChild("Head") then
            local playerPos = Player.Character.Head.Position
            local distance = (LocalPlayer.Character.Head.Position - playerPos).Magnitude

            -- Update text and visibility based on distance
            TextLabel.Text = string.format("Distance: %.1f", distance)
            TextLabel.Visible = distance <= MaxDistance
        end
    end

    -- Run update loop
    RunService.RenderStepped:Connect(UpdateDistance)

    -- Remove the ESP if the player leaves
    Player.CharacterRemoving:Connect(function()
        BillboardGui:Destroy()
    end)
end

-- Add ESP for each player in the game
for _, Player in ipairs(Players:GetPlayers()) do
    if Player ~= LocalPlayer then
        CreateDistanceESP(Player)
    end
end

-- Update ESP when a new player joins
Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function()
        CreateDistanceESP(Player)
    end)
end)
