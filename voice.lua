-- Advanced Dupe Button (Remote Focus)
local ScreenGui = Instance.new("ScreenGui")
local DupeBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
DupeBtn.Parent = ScreenGui
DupeBtn.Size = UDim2.new(0, 150, 0, 50)
DupeBtn.Position = UDim2.new(0.5, -75, 0.4, 0)
DupeBtn.Text = "FORCE DUPE ITEM"
DupeBtn.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
DupeBtn.Draggable = true

DupeBtn.MouseButton1Click:Connect(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local itemToDupe = "UnknownCrystal"
    
    print("Attempting to force dupe...")

    -- Hahanapin natin ang mga common na 'Events' folder sa mga simulator/hangout
    -- para subukang i-trigger ang "GiveItem" o "Claim" function
    local events = ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
    
    -- Susubukan nating i-fire ang lahat ng posibleng 'Give' remotes
    -- PAALALA: Kung alam mo ang pangalan ng Remote sa RemoteSpy, ilagay mo rito.
    for _, remote in pairs(events:GetDescendants()) do
        if remote:IsA("RemoteEvent") and (remote.Name:find("Give") or remote.Name:find("Claim") or remote.Name:find("Add")) then
            print("Found potential dupe remote: " .. remote.Name)
            
            -- I-spam ang remote habang naka-lag
            settings().Network.IncomingReplicationLag = 999
            for i = 1, 20 do
                -- Sinusubukang i-fire ang remote gamit ang name ng item
                remote:FireServer(itemToDupe)
            end
            task.wait(0.5)
            settings().Network.IncomingReplicationLag = 0
        end
    end
end)
