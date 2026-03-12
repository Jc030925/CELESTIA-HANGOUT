-- [[ MVS DUELS: SILENT AIM + ESP ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- === SETTINGS ===
local AimSettings = {
    Enabled = true,
    TargetPart = "Head", -- Pwedeng "HumanoidRootPart" kung ayaw mo halatang headshot lagi
    FOV = 150 -- Distansya ng pag-lock ng aim
}

-- === UI SETUP ===
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 150, 0, 60)
MainFrame.Position = UDim2.new(0, 10, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Draggable = true
MainFrame.Active = true

local aimBtn = Instance.new("TextButton", MainFrame)
aimBtn.Size = UDim2.new(1, -10, 1, -10)
aimBtn.Position = UDim2.new(0, 5, 0, 5)
aimBtn.Text = "SILENT AIM: ON"
aimBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
aimBtn.TextColor3 = Color3.new(1, 1, 1)
aimBtn.Font = Enum.Font.SourceSansBold

aimBtn.MouseButton1Click:Connect(function()
    AimSettings.Enabled = not AimSettings.Enabled
    aimBtn.Text = AimSettings.Enabled and "SILENT AIM: ON" or "SILENT AIM: OFF"
    aimBtn.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
end)

-- === SILENT AIM LOGIC ===
function getClosestPlayer()
    local target = nil
    local shortestDist = AimSettings.FOV

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild(AimSettings.TargetPart) then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character[AimSettings.TargetPart].Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < shortestDist then
                    target = v.Character[AimSettings.TargetPart]
                    shortestDist = dist
                end
            end
        end
    end
    return target
end

-- Dinadaya natin ang "Target" ng mouse mo
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, index)
    if self == Mouse and (index == "Hit" or index == "Target") and AimSettings.Enabled then
        local target = getClosestPlayer()
        if target then
            return (index == "Hit" and target.CFrame or target)
        end
    end
    return oldIndex(self, index)
end)

-- === SIMPLE ESP (Para makita mo sila sa likod ng pader) ===
RunService.RenderStepped:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and not v.Character:FindFirstChild("Highlight") then
            local hl = Instance.new("Highlight", v.Character)
            hl.FillColor = Color3.new(1, 0, 0)
            hl.FillTransparency = 0.5
            hl.OutlineColor = Color3.new(1, 1, 1)
        end
    end
end)
