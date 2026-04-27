-- Precision Rod Injector (Exact Path)
local ScreenGui = Instance.new("ScreenGui")
local MainBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 200, 0, 50)
MainBtn.Position = UDim2.new(0.5, -100, 0.4, 0)
MainBtn.Text = "EQUIP LIGHTNING ROD"
MainBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
MainBtn.Draggable = true

-- EXACT NAMES BASED ON YOUR DEX SCREENSHOT
local ROD_PATH = game.ReplicatedStorage.FishingResources.Rods
local TARGET_NAME = "LightningRod" -- Pakicheck sa Dex kung may space ba ito sa baba, pero base sa listahan mo, dikit-dikit sila.

MainBtn.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local rs = game:GetService("ReplicatedStorage")
    
    print("Attempting to force equip from FishingResources...")

    -- STEP 1: Hanapin ang Remote sa Controllers (dahil may folder na Controllers sa Dex mo)
    local controllers = rs:FindFirstChild("Controllers")
    
    for _, remote in pairs(rs:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            pcall(function()
                -- Sinusubukan nating i-send yung mismong Object mula sa Rods folder
                local rodObj = ROD_PATH:FindFirstChild(TARGET_NAME)
                if rodObj then
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(rodObj)
                        remote:FireServer("Equip", rodObj)
                        remote:FireServer(TARGET_NAME)
                    else
                        remote:InvokeServer(rodObj)
                    end
                end
            end)
        end
    end
    
    -- STEP 2: Local Visual Swap (Para sigurado)
    local char = player.Character
    if char then
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool then
            currentTool.Name = TARGET_NAME
            print("Visual swap complete!")
        end
    end
end)
