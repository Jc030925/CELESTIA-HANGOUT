-- [[ UPDATED: STABLE FLY + VOICE DISTORTER ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- === PART 1: VOICE DISTORTER (ANTI-AI) ===
local function applyVoice(char)
    task.wait(1)
    local mic = char:FindFirstChildOfClass("AudioDeviceInput") or char.PrimaryPart:FindFirstChildOfClass("AudioDeviceInput")
    if mic then
        local shifter = Instance.new("AudioPitchShifter")
        shifter.Pitch = 0.94 + (math.random() * 0.12)
        shifter.Parent = mic
        
        local comp = Instance.new("AudioCompressor")
        comp.Threshold = -10
        comp.Parent = mic
        print("Voice Distortion Active")
    end
end

-- === PART 2: STABLE FLY (NO TALSICK) ===
local flying = false
local speed = 50
local flyPart = nil

local function toggleFly()
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    flying = not flying

    if flying then
        hum.PlatformStand = true
        -- Gagawa tayo ng "FlyPart" para stable ang position
        flyPart = Instance.new("BodyVelocity")
        flyPart.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyPart.Velocity = Vector3.new(0,0,0)
        flyPart.Name = "StableFly"
        flyPart.Parent = root
        
        local gyro = Instance.new("BodyGyro")
        gyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        gyro.P = 10000
        gyro.Name = "StableGyro"
        gyro.Parent = root

        task.spawn(function()
            while flying do
                -- Susunod sa Camera pero hindi mag-vibrate/talsik
                local direction = workspace.CurrentCamera.CFrame.LookVector
                flyPart.Velocity = direction * speed
                gyro.CFrame = workspace.CurrentCamera.CFrame
                task.wait()
            end
        end)
        print("Fly ON (Stable)")
    else
        -- Clean up para bumalik sa normal
        hum.PlatformStand = false
        if root:FindFirstChild("StableFly") then root.StableFly:Destroy() end
        if root:FindFirstChild("StableGyro") then root.StableGyro:Destroy() end
        print("Fly OFF")
    end
end

-- Keybind F
Mouse.KeyDown:Connect(function(key)
    if key:lower() == "f" then toggleFly() end
end)

LP.CharacterAdded:Connect(applyVoice)
if LP.Character then applyVoice(LP.Character) end
