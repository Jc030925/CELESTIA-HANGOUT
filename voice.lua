local ScreenGui = Instance.new("ScreenGui")
local MainBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 250, 0, 50)
MainBtn.Position = UDim2.new(0.5, -125, 0.4, 0)
MainBtn.Text = "RE-RENDER LIGHTNING ROD"
MainBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
MainBtn.Draggable = true

local function reRenderRod()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    local rs = game:GetService("ReplicatedStorage")
    local target = "LightningRod"
    
    -- 1. Siguraduhin ang Data Path base sa Dex mo
    local myData = rs.PlayersData:FindFirstChild(lp.Name)
    if myData and myData:FindFirstChild("FishingData") then
        myData.FishingData.CurrentRod.Value = target
        print("Data confirmed.")
    end

    -- 2. Visual Swap logic
    -- Hahanapin ang actual model sa Resources folder na nakita natin
    local rodModel = rs.FishingResources.Rods:FindFirstChild(target)
    local tool = char:FindFirstChildOfClass("Tool") or lp.Backpack:FindFirstChildOfClass("Tool")

    if tool and rodModel then
        -- Tatanggalin natin yung lumang mesh/itsura sa kamay mo
        for _, v in pairs(tool:GetDescendants()) do
            if v:IsA("MeshPart") or v:IsA("SpecialMesh") or v:IsA("SelectionBox") then
                v:Destroy()
            end
        end

        -- Kukunin natin ang itsura ng LightningRod at ilalagay sa kasalukuyan mong tool
        for _, part in pairs(rodModel:GetChildren()) do
            local clone = part:Clone()
            clone.Parent = tool
            
            -- I-weld natin sa Handle para sumunod sa galaw ng kamay
            if clone:IsA("BasePart") or clone:IsA("MeshPart") then
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = tool:FindFirstChild("Handle")
                weld.Part1 = clone
                weld.Parent = clone
                clone.CanCollide = false
            end
        end
        print("Lightning Mesh Applied!")
    else
        print("Equip your rod first!")
    end
end

MainBtn.MouseButton1Click:Connect(reRenderRod)
