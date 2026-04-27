-- Fast Auto-Gacha (No Animation)
local rs = game:GetService("ReplicatedStorage")
local lp = game.Players.LocalPlayer
local target = "LightningRod"

-- Hanapin ang Remote para sa Gacha base sa GachaResources folder
local gachaRemote = rs:WaitForChild("GachaResources"):FindFirstChildOfClass("RemoteFunction") 
    or rs:WaitForChild("GachaResources"):FindFirstChildOfClass("RemoteEvent")

_G.AutoGacha = true -- Gawing false kung gusto mong itigil

print("Auto-Gacha Started. Looking for: " .. target)

task.spawn(function()
    while _G.AutoGacha do
        -- I-check muna kung nakuha na natin para hindi masayang ang coins
        local myData = rs.PlayersData:FindFirstChild(lp.Name)
        if myData and myData.FishingData.Rods:FindFirstChild(target) then
            print("SUCCESS! LightningRod obtained. Stopping Auto-Gacha.")
            _G.AutoGacha = false
            break
        end

        -- I-trigger ang Gacha nang walang animation
        if gachaRemote:IsA("RemoteFunction") then
            gachaRemote:InvokeServer("Roll") -- Depende sa name ng action sa game
        else
            gachaRemote:FireServer("Roll")
        end
        
        task.wait(0.1) -- Sobrang bilis na draw
    end
end)
