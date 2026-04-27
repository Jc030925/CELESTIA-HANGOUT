-- Lightning Rod Specific Injector
local ScreenGui = Instance.new("ScreenGui")
local MainBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 200, 0, 50)
MainBtn.Position = UDim2.new(0.5, -100, 0.3, 0)
MainBtn.Text = "GET LIGHTNING ROD"
MainBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow for Lightning
MainBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MainBtn.Font = Enum.Font.SourceSansBold
MainBtn.TextSize = 18
MainBtn.Draggable = true

-- TARGET ITEM
local TARGET = "Lightning Rod"

local function getLightning()
    local rs = game:GetService("ReplicatedStorage")
    print("Attempting to force-equip: " .. TARGET)
    
    -- Gagamit tayo ng maikling lag para mas kumagat ang request
    settings().Network.IncomingReplicationLag = 0.5 
    
    for _, obj in pairs(rs:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            -- Sinusubukan ang iba't ibang paraan para tanggapin ng server
            obj:FireServer(TARGET)
            obj:FireServer("Equip", TARGET)
            obj:FireServer("Unlock", TARGET)
            obj:FireServer("Select", TARGET)
            obj:FireServer("Claim", TARGET)
        end
    end
    
    task.wait(0.5)
    settings().Network.IncomingReplicationLag = 0
    print("Lightning Rod request finished.")
end

MainBtn.MouseButton1Click:Connect(getLightning)
