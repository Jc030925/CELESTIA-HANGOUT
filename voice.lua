-- Pinabilis na Auto-Gacha (No Animation)
local rs = game:GetService("ReplicatedStorage")
local lp = game.Players.LocalPlayer
local target = "LightningRod"

-- Mas malalim na paghahanap sa Remote base sa Dex folders mo
local gachaFolder = rs:WaitForChild("GachaResources")
local remote = gachaFolder:FindFirstChild("GachaRemote") or gachaFolder:FindFirstChildOfClass("RemoteFunction") or gachaFolder:FindFirstChildOfClass("RemoteEvent")

_G.AutoGacha = true 

if remote then
    print("Remote Found! Starting Fast Draw...")
    task.spawn(function()
        while _G.AutoGacha do
            -- Check kung nakuha na para mag-save sa server
            local myData = rs.PlayersData:FindFirstChild(lp.Name)
            if myData and myData.FishingData.Rods:FindFirstChild(target) then
                print("LIGIT! Nakuha na ang LightningRod sa server.")
                _G.AutoGacha = false
                break
            end

            -- Direct Server Call para malampasan ang "Hold E"
            if remote:IsA("RemoteFunction") then
                remote:InvokeServer("Roll") 
            elseif remote:IsA("RemoteEvent") then
                remote:FireServer("Roll")
            end
            
            task.wait(0.1) -- Sobrang bilis na draw
        end
    end)
else
    warn("Hindi pa rin mahanap ang Gacha Remote. Pakicheck ang name sa loob ng GachaResources folder via Dex.")
end
