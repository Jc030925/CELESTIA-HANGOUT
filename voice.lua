-- [[ GOD MODE ONLY ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- === UI SETUP ===
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local GodButton = Instance.new("TextButton", ScreenGui)

GodButton.Size = UDim2.new(0, 150, 0, 50)
GodButton.Position = UDim2.new(0, 10, 0.5, 0)
GodButton.Text = "God Mode: OFF"
GodButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
GodButton.TextColor3 = Color3.new(1, 1, 1)
GodButton.Font = Enum.Font.SourceSansBold
GodButton.TextSize = 18
GodButton.Draggable = true
GodButton.Active = true

-- === GOD MODE LOGIC ===
local godEnabled = false

GodButton.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    
    if godEnabled then
        GodButton.Text = "God Mode: ON"
        GodButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Loop para laging full ang HP (506/506)
        task.spawn(function()
            while godEnabled do
                local char = LP.Character
                if char and char:FindFirstChild("Humanoid") then
                    -- Ibabalik sa MaxHealth tuwing mababawasan
                    if char.Humanoid.Health < char.Humanoid.MaxHealth then
                        char.Humanoid.Health = char.Humanoid.MaxHealth
                    end
                end
                task.wait(0.1) -- Refresh rate para mabilis mag-heal
            end
        end)
    else
        GodButton.Text = "God Mode: OFF"
        GodButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)
