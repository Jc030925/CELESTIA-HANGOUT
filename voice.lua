local ReplicatedStorage = game:GetService("ReplicatedStorage") 
local TeleportService = game:GetService("TeleportService")
local lp = game.Players.LocalPlayer

-- Siguraduhin nating load na ang GachaClient folder
local GachaClient = ReplicatedStorage:WaitForChild("GachaClient", 10)
if not GachaClient then 
    warn("GachaClient folder not found!")
    return 
end

-- Stealth Mode: Anti-Log Hook (Hinarang ang detection remotes)
local blockKeywords = {"Log", "Webhook", "Report", "Detection", "Check"}
local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if (method == "FireServer" or method == "InvokeServer") and self then
        for _, k in pairs(blockKeywords) do
            if self.Name:find(k) then return nil end
        end
    end
    return oldNamecall(self, ...)
end)

-- Targets (Inalis ang mga common items para focus sa rare)
local targets = {
    Rod = {"NexusDivaRod", "NexusAlphaRod", "AngelRod", "SakuraRod", "LightningRod"},
    Wings = {"NexusAlphaWings", "NexusDivaWings", "LightningWings", "SakuraWings", "QueenFloraWings"},
    Sword = {"SakuraKatana", "NexusAlphaSword", "NexusDivaSword"}
}

_G.AutoGacha = false

-- UI Setup
local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "GachaMasterV9"
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 240, 0, 320)
frame.Position = UDim2.new(0.5, -120, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true; frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "STEALTH GACHA V9"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local function createBtn(name, pos, color)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 220, 0, 35); btn.Position = pos
    btn.Text = name; btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.SourceSansBold
    return btn
end

-- Buttons
local rodBtn = createBtn("START ROD GACHA", UDim2.new(0, 10, 0, 40), Color3.fromRGB(0, 100, 200))
local wingBtn = createBtn("START WINGS GACHA", UDim2.new(0, 10, 0, 80), Color3.fromRGB(100, 0, 150))
local swordBtn = createBtn("START SWORD GACHA", UDim2.new(0, 10, 0, 120), Color3.fromRGB(180, 50, 0))
local moneyBtn = createBtn("ADD COINS (STEALTH)", UDim2.new(0, 10, 0, 170), Color3.fromRGB(218, 165, 32))
local stopBtn = createBtn("STOP ALL", UDim2.new(0, 10, 0, 220), Color3.fromRGB(150, 0, 0))
local hopBtn = createBtn("REFRESH SERVER", UDim2.new(0, 10, 0, 270), Color3.fromRGB(50, 50, 50))

-- Unified Gacha Logic (Module Based)
local function startGacha(moduleName)
    if _G.AutoGacha then return end
    _G.AutoGacha = true
    
    local moduleScript = GachaClient:FindFirstChild(moduleName)
    if not moduleScript then return end
    local module = require(moduleScript)
    
    task.spawn(function()
        while _G.AutoGacha do
            local success, result = pcall(function()
                -- Sinusubukan ang iba't ibang tawag depende sa module structure
                if module.Gacha then return module:Gacha()
                elseif module.Roll then return module:Roll()
                elseif typeof(module) == "function" then return module()
                end
            end)

            if success and result then
                print("Rolled: " .. tostring(result))
                for _, t in pairs(targets[moduleName]) do
                    if tostring(result):find(t) then _G.AutoGacha = false break end
                end
            end
            -- Stealth delay para hindi ma-kick
            task.wait(0.7 + math.random() * 0.4) 
        end
    end)
end

-- Connections
rodBtn.MouseButton1Click:Connect(function() startGacha("Rod") end)
wingBtn.MouseButton1Click:Connect(function() startGacha("Wings") end)
swordBtn.MouseButton1Click:Connect(function() startGacha("Sword") end)

moneyBtn.MouseButton1Click:Connect(function()
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj and typeof(obj) == "Instance" and obj:IsA("RemoteEvent") then
            pcall(function() obj:FireServer(5000000) end)
        end
    end
end)

stopBtn.MouseButton1Click:Connect(function() _G.AutoGacha = false end)
hopBtn.MouseButton1Click:Connect(function() TeleportService:Teleport(game.PlaceId, lp) end)
