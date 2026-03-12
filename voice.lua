-- [[ GOD MODE + ULTRA SPEED BYPASS ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local SPlayer = game:GetService("StarterPlayer")

-- Paths base sa screenshots mo
local trainRemote = RS:WaitForChild("Remote"):WaitForChild("TrainSystem"):WaitForChild("ReqClickTrain")
local speedRemote = RS:WaitForChild("Remote"):WaitForChild("TrainSystem"):WaitForChild("ReqUpdateTrainSpeed")

-- === UI SETUP ===
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 180, 0, 110)
MainFrame.Position = UDim2.new(0, 10, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Draggable = true
MainFrame.Active = true

local function createBtn(name, pos, color)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(1, -10, 0, 45)
    b.Position = pos
    b.Text = name
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    return b
end

local godBtn = createBtn("ANTI 1-HIT: OFF", UDim2.new(0, 5, 0, 5), Color3.fromRGB(120, 0, 0))
local trainBtn = createBtn("INSTANT TRAIN: OFF", UDim2.new(0, 5, 0, 55), Color3.fromRGB(0, 100, 200))

-- === ANTI 1-HIT LOGIC ===
local godActive = false
godBtn.MouseButton1Click:Connect(function()
    godActive = not godActive
    godBtn.Text = godActive and "ANTI 1-HIT: ON" or "ANTI 1-HIT: OFF"
    godBtn.BackgroundColor3 = godActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(120, 0, 0)
    
    -- Pag-disable sa CombatCalcClient na nakita mo sa Dex
    local combatScript = LP.PlayerScripts:FindFirstChild("CombatCalcClient", true)
    if combatScript then
        combatScript.Disabled = godActive
    end

    task.spawn(function()
        while godActive do
            pcall(function()
                if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                    LP.Character.Humanoid.Health = LP.Character.Humanoid.MaxHealth
                end
            end)
            task.wait(0.1)
        end
    end)
end)

-- === INSTANT TRAIN LOGIC ===
local training = false
trainBtn.MouseButton1Click:Connect(function()
    training = not training
    trainBtn.Text = training and "INSTANT TRAIN: ON" or "INSTANT TRAIN: OFF"
    trainBtn.BackgroundColor3 = training and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 100, 200)
    
    task.spawn(function()
        while training do
            pcall(function()
                -- Sabay na pag-fire sa Click at Speed remotes para i-force ang bar
                trainRemote:FireServer()
                speedRemote:FireServer()
                
                -- Trigger Frenzy Mode multiplier kung available
                local frenzy = RS.Remote.TrainSystem:FindFirstChild("ResEnterFrenzyMode")
                if frenzy then frenzy:FireServer() end
            end)
            task.wait(0.01) -- Pinakamabilis na safe spam
        end
    end)
end)
