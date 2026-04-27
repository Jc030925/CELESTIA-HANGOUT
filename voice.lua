-- Final Gacha Fix for Lightning Rod
local ScreenGui = Instance.new("ScreenGui")
local MainBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 220, 0, 50)
MainBtn.Position = UDim2.new(0.5, -110, 0.4, 0)
MainBtn.Text = "ACTIVATE LIGHTNING ROD"
MainBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
MainBtn.TextColor3 = Color3.fromRGB(0,0,0)
MainBtn.Draggable = true

local function forceGachaRod()
    local target = "Lightning Rod"
    local rs = game:GetService("ReplicatedStorage")
    local workspaceGacha = workspace:FindFirstChild("GACHA")
    
    print("Executing Gacha Fix...")

    -- 1. I-fire ang lahat ng Remotes sa ReplicatedStorage (Safe check)
    for _, obj in pairs(rs:GetDescendants()) do
        pcall(function()
            if obj:IsA("RemoteEvent") then
                obj:FireServer("Equip", target)
                obj:FireServer(target)
            elseif obj:IsA("RemoteFunction") then
                -- Inayos natin dito: InvokeServer ang gamit sa Functions
                obj:InvokeServer("Equip", target)
                obj:InvokeServer(target)
            end
        end)
    end

    -- 2. I-target ang folder na nakita mo sa console (Workspace.GACHA)
    if workspaceGacha then
        local rodFolder = workspaceGacha:FindFirstChild("Rod")
        if rodFolder then
            print("Workspace GACHA Rod Folder Found!")
            for _, obj in pairs(rodFolder:GetDescendants()) do
                pcall(function()
                    if obj:IsA("RemoteEvent") then
                        obj:FireServer(target)
                    elseif obj:IsA("RemoteFunction") then
                        obj:InvokeServer(target)
                    end
                end)
            end
        end
    end
    
    print("Check your Rod Index now.")
end

MainBtn.MouseButton1Click:Connect(forceGachaRod)
