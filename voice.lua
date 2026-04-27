-- Stealth Coin Injector (Custom Amount)
local ScreenGui = Instance.new("ScreenGui")
local MainBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 200, 0, 50)
MainBtn.Position = UDim2.new(0.5, -100, 0.1, 0)
MainBtn.Text = "ADD 500,000 COINS"
MainBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100) -- Green for Money
MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainBtn.Draggable = true

-- CONFIGURATION
local COIN_AMOUNT = 500000 -- Dito mo pwede palitan ang amount

local function addMoney()
    local rs = game:GetService("ReplicatedStorage")
    local remotesFound = 0
    
    for _, obj in pairs(rs:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            -- Susubukan natin ang iba't ibang format ng pag-send ng coins
            obj:FireServer(COIN_AMOUNT)
            obj:FireServer("Coins", COIN_AMOUNT)
            obj:FireServer("Add", COIN_AMOUNT)
            
            remotesFound = remotesFound + 1
        end
    end
    print("Fired " .. remotesFound .. " remotes with amount: " .. COIN_AMOUNT)
end

MainBtn.MouseButton1Click:Connect(addMoney)
