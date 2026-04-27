-- Gacha Engine Rod Injector
local ScreenGui = Instance.new("ScreenGui")
local MainBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 200, 0, 50)
MainBtn.Position = UDim2.new(0.5, -100, 0.4, 0)
MainBtn.Text = "GACHA BYPASS: LIGHTNING"
MainBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
MainBtn.Draggable = true

local function forceGachaRod()
    local targetRod = "Lightning Rod"
    local rf = game:GetService("ReplicatedFirst")
    local rs = game:GetService("ReplicatedStorage")
    
    print("Bypassing GachaClient components...")

    -- STEP 1: Subukan i-trigger ang Gacha Remote directly
    -- Dahil ang script ay nasa GachaClient, hahanapin natin ang kaukulang Remote
    for _, remote in pairs(rs:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            -- Susubukan ang Gacha-specific arguments
            remote:FireServer("Gacha", "Equip", targetRod)
            remote:FireServer("UpdateRod", targetRod)
            remote:FireServer(targetRod, true) -- Force 'Owned' status
        end
    end

    -- STEP 2: Local Override (Para magbago ang skin sa screen mo)
    -- Minsan kailangan i-update ang value sa loob ng ClientEngine
    local player = game.Players.LocalPlayer
    local char = player.Character
    if char and char:FindFirstChildOfClass("Tool") then
        char:FindFirstChildOfClass("Tool").Name = targetRod
        print("Local Tool name updated to: " .. targetRod)
    end
end

MainBtn.MouseButton1Click:Connect(forceGachaRod)
