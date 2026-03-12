-- [[ NUCLEAR GOD MODE + TRAIN SNIPER ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")

-- Remote path
local trainRemote = RS:WaitForChild("Remote"):WaitForChild("TrainSystem"):WaitForChild("ReqClickTrain")

-- === UI SETUP ===
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 180, 0, 110)
MainFrame.Position = UDim2.new(0, 10, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
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

local godBtn = createBtn("GHOST GOD: OFF", UDim2.new(0, 5, 0, 5), Color3.fromRGB(100, 0, 0))
local trainBtn = createBtn("OP TRAIN: OFF", UDim2.new(0, 5, 0, 55), Color3.fromRGB(0, 80, 180))

-- === GHOST GOD MODE (Hitbox Destroyer) ===
local ghostEnabled = false
godBtn.MouseButton1Click:Connect(function()
    ghostEnabled = not ghostEnabled
    godBtn.Text = ghostEnabled and "GHOST GOD: ON" or "GHOST GOD: OFF"
    godBtn.BackgroundColor3 = ghostEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 0, 0)
    
    if ghostEnabled then
        local char = LP.Character
        if char then
            -- Itatago natin ang HumanoidRootPart sa server
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                    v.CanTouch = false -- Hindi ka na matatamaan ng attacks
                end
            end
            -- Anti-Void protection
            char.HumanoidRootPart.Anchored = false
        end
    end
end)

-- === OP TRAIN (Adaptive Spam) ===
local training = false
trainBtn.MouseButton1Click:Connect(function()
    training = not training
    trainBtn.Text = training and "OP TRAIN: ON" or "OP TRAIN: OFF"
    trainBtn.BackgroundColor3 = training and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 80, 180)
    
    task.spawn(function()
        while training do
            pcall(function()
                -- I-fire ang Remote
                trainRemote:FireServer()
                
                -- Isabay natin ang local click animation para "legit" tignan
                local tool = LP.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end)
            
            -- Binagalan natin konti (0.07) para hindi ma-flag ng server anticheat
            task.wait(0.07) 
        end
    end)
end)
