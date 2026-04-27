-- [ VOICE.LUA CONTENT ]
print("Voice Tools Loaded!")

-- Dito natin isisingit yung Dupe/Sell logic na gusto mo
local function startDupe()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    -- PAALALA: Siguraduhin mong tama ang name ng RemoteEvent dito!
    -- Gamit ka ng RemoteSpy para mahanap ang "Sell" event
    local sellRemote = ReplicatedStorage:FindFirstChild("SellItem") 

    if sellRemote then
        settings().Network.IncomingReplicationLag = 999 -- Simulang mag-lag
        for i = 1, 100 do
            sellRemote:FireServer("UnknownCrystal") -- Spam ang sell
        end
        task.wait(1)
        settings().Network.IncomingReplicationLag = 0 -- Balik sa normal
    else
        print("Remote not found. Use a RemoteSpy to find the correct event name.")
    end
end

-- Pwede mo itong i-trigger gamit ang isang button sa GUI mo
startDupe()
