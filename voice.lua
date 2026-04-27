-- Hybrid Injector: Data Patch + Visual Force
local ScreenGui = Instance.new("ScreenGui")
local MainBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 250, 0, 50)
MainBtn.Position = UDim2.new(0.5, -125, 0.4, 0)
MainBtn.Text = "FORCE & EQUIP LIGHTNING"
MainBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
MainBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
MainBtn.Draggable = true

local function startInjection()
    local target = "LightningRod"
    local lp = game.Players.LocalPlayer
    local rs = game:GetService("ReplicatedStorage")
    local char = lp.Character or lp.CharacterAdded:Wait()
    
    -- PART 1: DATABASE PATCH (Base sa Dex Screenshot mo)
    local myData = rs:WaitForChild("PlayersData"):FindFirstChild(lp.Name)
    if myData then
        local fishing = myData:FindFirstChild("FishingData")
        if fishing then
            -- Update CurrentRod StringValue
            local currentRodValue = fishing:FindFirstChild("CurrentRod")
            if currentRodValue then
                currentRodValue.Value = target
            end
            
            -- Add to Rods Inventory Folder
            local rodsFolder = fishing:FindFirstChild("Rods")
            if rodsFolder then
                if not rodsFolder:FindFirstChild(target) then
                    local newRod = Instance.new("BoolValue")
                    newRod.Name = target
                    newRod.Value = true
                    newRod.Parent = rodsFolder
                end
            end
            print("Database Patched!")
        end
    end

    -- PART 2: VISUAL FORCE EQUIP
    -- Kunin ang model mula sa FishingResources.Rods
    local rodModel = rs.FishingResources.Rods:FindFirstChild(target)
    
    if rodModel then
        -- Linisin ang luma mong rod
        for _, tool in pairs(lp.Backpack:GetChildren()) do
            if tool:IsA("Tool") then tool:Destroy() end
        end
        if char:FindFirstChildOfClass("Tool") then
            char:FindFirstChildOfClass("Tool"):Destroy()
        end

        -- I-clone at i-equip ang bago
        local newRod = rodModel:Clone()
        newRod.Parent = lp.Backpack
        char.Humanoid:EquipTool(newRod)
        print("Lightning Rod Visuals Forced!")
    end

    -- PART 3: SERVER SYNC
    for _, remote in pairs(rs:GetDescendants()) do
        if remote:IsA("RemoteEvent") and (remote.Name:find("Save") or remote.Name:find("Update")) then
            remote:FireServer()
        end
    end
end

MainBtn.MouseButton1Click:Connect(startInjection)
