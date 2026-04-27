local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlinkClient = require(ReplicatedStorage:WaitForChild("Blink").Client)
local lp = game.Players.LocalPlayer

-- Listahan ng mga rods na gusto nating makuha
local targetRods = {
    "NexusDivaRod", "NexusAlphaRod", "AngelRod", 
    "HoneyDipperRod", "SakuraRod", "RobuxRod", 
    "LightningRod", "GingerbreadSpatulaRod", "BamboopandaRod"
}

_G.AutoGacha = true 

-- UI para sa Stop Button
local sg = Instance.new("ScreenGui", game.CoreGui)
local stopBtn = Instance.new("TextButton", sg)
stopBtn.Size = UDim2.new(0, 200, 0, 50)
stopBtn.Position = UDim2.new(0.5, -100, 0.1, 0)
stopBtn.Text = "STOP AUTO GACHA"
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
stopBtn.TextColor3 = Color3.new(1, 1, 1)

stopBtn.MouseButton1Click:Connect(function()
    _G.AutoGacha = false
    stopBtn.Text = "STOPPING..."
    task.wait(1)
    sg:Destroy()
end)

print("Auto-Gacha Started via Blink. Multiple targets active.")

task.spawn(function()
    while _G.AutoGacha do
        -- 1. Check ang PlayersData sa bawat target rod
        local myData = ReplicatedStorage:WaitForChild("PlayersData"):FindFirstChild(lp.Name)
        if myData then
            local rodsFolder = myData.FishingData.Rods
            for _, targetName in pairs(targetRods) do
                local foundRod = rodsFolder:FindFirstChild(targetName)
                if foundRod and foundRod.Value == true then
                    print("SUCCESS! Nakuha na ang: " .. targetName)
                    _G.AutoGacha = false
                    sg:Destroy()
                    return -- Titigil ang buong script
                end
            end
        end

        -- 2. Direct Call sa Gacha Function base sa script name na "Rod"
        local success, result = pcall(function()
            -- Base sa decompiled script, "Rod" ang ina-invoke
            return BlinkClient.GachaFunc.Invoke("Rod")
        end)

        if success then
            print("Rolled: " .. tostring(result))
            
            -- Check result agad para kung sakaling nakuha na, mag-stop na
            for _, targetName in pairs(targetRods) do
                if result == targetName then
                    print("JACKPOT! Nakuha ang: " .. targetName)
                    _G.AutoGacha = false
                    sg:Destroy()
                    return
                end
            end
        else
            warn("Failed to roll: " .. tostring(result))
        end

        task.wait(0.6) -- Safe delay para iwas kick at iwas ubos-pera agad
    end
end)
