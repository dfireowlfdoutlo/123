-- Fling Script (Client Side / Executor)
local flingEnabled = true
local flingForce = 5000
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- function to fling touched players
local function flingOnTouch(otherPart)
    if not flingEnabled then return end
    local otherChar = otherPart.Parent
    local humanoid = otherChar:FindFirstChildOfClass("Humanoid")
    local root = otherChar:FindFirstChild("HumanoidRootPart")
    if humanoid and root then
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Unit * flingForce
        bv.Parent = root
        game:GetService("Debris"):AddItem(bv, 0.1)
    end
end

-- connect touch to all parts of your char
local function connectCharacter(char)
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Touched:Connect(flingOnTouch)
        end
    end
end

LocalPlayer.CharacterAdded:Connect(connectCharacter)
if LocalPlayer.Character then
    connectCharacter(LocalPlayer.Character)
end

-- simple toggle UI
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.2, 0, 0.1, 0)
button.Position = UDim2.new(0.4, 0, 0.85, 0)
button.Text = "Disable Fling"
button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
button.Parent = screenGui

button.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    button.Text = flingEnabled and "Disable Fling" or "Enable Fling"
    button.BackgroundColor3 = flingEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
