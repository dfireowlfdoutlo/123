-- Fling Script for Natural Disasters (Works in Any Executor)
local flingEnabled = true
local flingForce = 5000

-- Function to get the HumanoidRootPart after the character has loaded
local function getHumanoidRootPart(character)
    if character then
        return character:WaitForChild("HumanoidRootPart", 5) -- Wait for HumanoidRootPart with a timeout
    end
end

-- Function to apply fling force when another player touches the player's character
local function flingOnTouch(otherPart)
    -- Make sure we are flinging and that the other part is from a player's character
    if flingEnabled and otherPart.Parent:FindFirstChild("Humanoid") then
        -- Ensure we get the other player's HumanoidRootPart
        local targetHumanoidRootPart = otherPart.Parent:FindFirstChild("HumanoidRootPart")
        if targetHumanoidRootPart then
            -- Apply BodyVelocity to fling the player
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)  -- Max force applied for fling
            bodyVelocity.Velocity = (targetHumanoidRootPart.Position - otherPart.Parent.HumanoidRootPart.Position).unit * flingForce
            bodyVelocity.Parent = targetHumanoidRootPart
            game:GetService("Debris"):AddItem(bodyVelocity, 0.1)  -- Clean up BodyVelocity after 0.1 seconds
        end
    end
end

-- Detect if another player touches any part of the player's character
local function connectTouchDetection(character)
    -- Ensure the character exists and is fully loaded
    if character then
        -- Disconnect previous connections to avoid multiple handlers
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Touched:Connect(flingOnTouch)
            end
        end
    end
end

-- Main function to set up the fling behavior
local function setupFlingForPlayer(player)
    -- Ensure that the player character exists
    local character = player.Character or player.CharacterAdded:Wait()

    -- Wait for HumanoidRootPart to load
    local humanoidRootPart = getHumanoidRootPart(character)
    if humanoidRootPart then
        connectTouchDetection(character)  -- Set up touch detection
    else
        character:WaitForChild("HumanoidRootPart")  -- Wait for it to load if not immediately available
        connectTouchDetection(character)
    end

    -- Listen to player respawn
    player.CharacterAdded:Connect(function(char)
        local newHumanoidRootPart = getHumanoidRootPart(char)
        if newHumanoidRootPart then
            connectTouchDetection(char)
        else
            char:WaitForChild("HumanoidRootPart")
            connectTouchDetection(char)
        end
    end)
end

-- Setup fling for all players when they join
game.Players.PlayerAdded:Connect(function(player)
    setupFlingForPlayer(player)
end)

-- Create the UI Button to toggle fling effect for local player (if needed in client)
if game:GetService("Players").LocalPlayer then
    -- For local players (client-side) we can add a UI button for toggling
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.2, 0, 0.1, 0)
    button.Position = UDim2.new(0.4, 0, 0.85, 0)
    button.Text = "Toggle Fling"
    button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Green Button
    button.Parent = screenGui

    -- Toggle the fling effect on button press (client-side)
    button.MouseButton1Click:Connect(function()
        flingEnabled = not flingEnabled
        button.Text = flingEnabled and "Disable Fling" or "Enable Fling"
        button.BackgroundColor3 = flingEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end)
end
