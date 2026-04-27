-- Lightning Rod Force-Unlock & Equip
local ScreenGui = Instance.new("ScreenGui")
local MainBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 200, 0, 50)
MainBtn.Position = UDim2.new(0.5, -100, 0.3, 0)
MainBtn.Text = "FORCE UNLOCK LIGHTNING"
MainBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
MainBtn.Draggable = true

local function forceUnlock()
    local target = "Lightning Rod"
    local rs = game:GetService("ReplicatedStorage")
    
    print("Executing Force-Unlock Sequence...")

    -- STEP 1: Hanapin ang "Shop" o "Purchase" Remote
    -- Maraming games ang may butas sa 'Buy' remote kung isesend mo ay 0 na price
    for _, remote in pairs(rs:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            -- Susubukan nating lokohin ang purchase system
            pcall(function()
                remote:FireServer(target, 0) -- Bilhin ng 0 coins
                remote:FireServer(target, true) -- I-set ang 'Owned' status sa true
                remote:FireServer("Buy", target)
                remote:FireServer("Unlock", target)
                
                -- Kung RemoteFunction, kailangan ng Invoke
                if remote:IsA("RemoteFunction") then
                    remote:InvokeServer(target)
                end
            end)
        end
    end

    -- STEP 2: Character Refresh
    -- Minsan kailangan i-reset ang character para lumabas ang bagong skin
    local player = game.Players.LocalPlayer
    if player.Character then
        print("Wait 2 seconds and check your inventory...")
    end
end

MainBtn.MouseButton1Click:Connect(forceUnlock)
