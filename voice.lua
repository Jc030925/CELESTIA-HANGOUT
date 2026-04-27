-- Roblox Inventory Dupe Script (Lag Method)
local ScreenGui = Instance.new("ScreenGui")
local DupeBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
DupeBtn.Parent = ScreenGui
DupeBtn.Size = UDim2.new(0, 150, 0, 50)
DupeBtn.Position = UDim2.new(0.5, -75, 0.4, 0)
DupeBtn.Text = "DUPE ITEM (EQUIP)"
DupeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
DupeBtn.Draggable = true

-- DITO ANG LOGIC NG PAGPAPADAMI NG ITEM
DupeBtn.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character
    
    -- Hanapin ang item na hawak mo (Dapat naka-equip ang UnknownCrystal)
    local item = character:FindFirstChild("UnknownCrystal") or player.Backpack:FindFirstChild("UnknownCrystal")
    
    if item then
        print("Starting inventory dupe for: " .. item.Name)
        
        -- STEP 1: Simulan ang matinding LAG
        settings().Network.IncomingReplicationLag = 999 
        
        -- STEP 2: I-spam ang Equip/Unequip/Drop logic
        -- Ito ang nagpapalito sa server kung nasaan ang item
        for i = 1, 30 do
            -- Sinusubukang i-fire ang event ng item habang lag
            if item:FindFirstChild("RemoteEvent") then -- Maraming items may sariling remote sa loob
                item.RemoteEvent:FireServer() 
            end
            
            -- I-force unequip at equip
            item.Parent = player.Backpack
            task.wait(0.01)
            item.Parent = character
        end
        
        -- STEP 3: Sync back to server
        task.wait(0.5)
        settings().Network.IncomingReplicationLag = 0
        print("Dupe attempt finished. Check inventory!")
    else
        warn("Dapat naka-equip o nasa Backpack ang UnknownCrystal!")
    end
end)
