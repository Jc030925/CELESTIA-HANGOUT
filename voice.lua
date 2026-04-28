local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BlinkClient = require(ReplicatedStorage:WaitForChild("Blink").Client)
local lp = game.Players.LocalPlayer

-- STEALTH MODE: Anti-Log Hook (Haharangin ang mga detection/log remotes)
local blockKeywords = {"Log", "Webhook", "Report", "Detection", "Check", "Anticheat"}
local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if (method == "FireServer" or method == "InvokeServer") then
        for _, k in pairs(blockKeywords) do
            if self.Name:find(k) then return nil end
        end
    end
    return oldNamecall(self, ...)
end)

-- CONFIGURATIONS
local targetRods = {"NexusDivaRod", "NexusAlphaRod", "AngelRod", "SakuraRod", "LightningRod"}
local targetWings = {"NexusAlphaWings", "NexusDivaWings", "LightningWings", "SakuraWings", "QueenFloraWings"}
local targetSwords = {"SakuraKatana", "NexusAlphaSword", "NexusDivaSword"} -- Inalis ang mga Nameless Sword (50%)

_G.AutoGacha = false
_G.GachaType = "Rod" -- Default

-- UI SETUP
local sg = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 240, 0, 310)
frame.Position = UDim2.new(0.5, -120, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.Active = true; frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "STEALTH GACHA MASTER"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local function createBtn(name, pos, color)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 220, 0, 35); btn.Position = pos
    btn.Text = name; btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.SourceSansBold
    return btn
end

-- BUTTONS
local rodBtn = createBtn("AUTO ROD GACHA", UDim2.new(0, 10, 0, 40), Color3.fromRGB(0, 100, 200))
local wingBtn = createBtn("AUTO WINGS GACHA", UDim2.new(0, 10, 0, 80), Color3.fromRGB(100, 0, 150))
local swordBtn = createBtn("AUTO SWORD GACHA", UDim2.new(0, 10, 0, 120), Color3.fromRGB(180, 50, 0))
local moneyBtn = createBtn("ADD COINS (STEALTH)", UDim2.new(0, 10, 0, 170), Color3.fromRGB(218, 165, 32))
local stopBtn = createBtn("STOP ALL GACHA", UDim2.new(0, 10, 0, 220), Color3.fromRGB(150, 0, 0))
local refreshBtn = createBtn("REFRESH & CLEAR SESSION", UDim2.new(0, 10, 0, 265), Color3.fromRGB(50, 50, 50))

-- UNIVERSAL GACHA LOGIC
local function runGacha(gType, targets)
    if _G.AutoGacha then return end
    _G.AutoGacha = true
    print("Stealth Gacha Started: " .. gType)
    
    task.spawn(function()
        while _G.AutoGacha do
            -- Remote Call via Blink (Invoking the correct type)
            local success, result = pcall(function()
                return BlinkClient.GachaFunc.Invoke(gType)
            end)

            if success and result then
                -- Check if jackpot
                for _, t in pairs(targets) do
                    if result:find(t) or result == t then
                        print("JACKPOT! Nakuha ang: " .. result)
                        _G.AutoGacha = false
                        break
                    end
                end
            end
            
            -- Stealth Delay: Random wait para magmukhang tao at hindi ma-flag
            task.wait(0.6 + math.random() * 0.4) 
        end
    end)
end

-- CONNECTIONS
rodBtn.MouseButton1Click:Connect(function() runGacha("Rod", targetRods) end)
wingBtn.MouseButton1Click:Connect(function() runGacha("Wings", targetWings) end)
swordBtn.MouseButton1Click:Connect(function() runGacha("Sword", targetSwords) end)

moneyBtn.MouseButton1Click:Connect(function()
    local COIN_AMOUNT = 5000000
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            obj:FireServer(COIN_AMOUNT)
            obj:FireServer("Coins", COIN_AMOUNT)
        end
    end
end)

stopBtn.MouseButton1Click:Connect(function() _G.AutoGacha = false end)

refreshBtn.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
end)
