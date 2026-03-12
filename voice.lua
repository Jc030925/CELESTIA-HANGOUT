-- [[ ANTI-1-HIT GOD MODE ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- === UI SETUP ===
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local GodButton = Instance.new("TextButton", ScreenGui)

GodButton.Size = UDim2.new(0, 160, 0, 50)
GodButton.Position = UDim2.new(0, 10, 0.5, 0)
GodButton.Text = "Anti-1-Hit: OFF"
GodButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
GodButton.TextColor3 = Color3.new(1, 1, 1)
GodButton.Draggable = true
GodButton.Active = true

-- === THE BYPASS LOGIC ===
local godEnabled = false

GodButton.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    
    if godEnabled then
        GodButton.Text = "Anti-1-Hit: ON"
        GodButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        local char = LP.Character
        if char and char:FindFirstChild("Humanoid") then
            -- 1. Gagawin nating imortal ang Humanoid locally
            char.Humanoid.Name = "Immortality" -- Pinapalitan ang pangalan para malito ang server scripts
            
            -- 2. Anti-Death Loop
            task.spawn(function()
                while godEnabled do
                    if char:FindFirstChild("Immortality") then
                        if char.Immortality.Health < 0.1 then
                            char.Immortality.Health = char.Immortality.MaxHealth
                        end
                    end
                    task.wait()
                end
            end)
        end
    else
        GodButton.Text = "Anti-1-Hit: OFF"
        GodButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        -- Reset Character para bumalik sa normal
        if LP.Character and LP.Character:FindFirstChild("Immortality") then
            LP.Character.Immortality.Health = 0
        end
    end
end)
