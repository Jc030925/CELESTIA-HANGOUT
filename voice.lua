-- [[ FE INVISIBLE + WASD FLY + VOICE DISTORTER ]] --
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- === PART 1: UI SETUP ===
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
local MainButton = Instance.new("TextButton", ScreenGui)
MainButton.Size = UDim2.new(0, 150, 0, 50)
MainButton.Position = UDim2.new(0, 10, 0.5, 0)
MainButton.Text = "FE Invisible: OFF"
MainButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.Draggable = true 
MainButton.Active = true

-- === PART 2: THE REAL FE INVISIBLE (UNDERWORLD GLITCH) ===
local isInvisible = false
local savedC0 = nil

MainButton.MouseButton1Click:Connect(function()
    local char = LP.Character
    if not char or not char:FindFirstChild("LowerTorso") then return end
    local rootJoint = char.LowerTorso:FindFirstChild("RootIt") or char.LowerTorso:FindFirstChild("Root")
    
    if not rootJoint then return end
    isInvisible = not isInvisible
    
    if isInvisible then
        MainButton.Text = "FE Invisible: ON"
        MainButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        -- Itatago ang buong character model sa -50,000 blocks sa ilalim
        savedC0 = rootJoint.C0
        rootJoint.C0 = rootJoint.C0 * CFrame.new(0, 50000, 0) 
        -- Mawawala ka sa paningin ng iba pati nametag mo sasama sa ilalim
    else
        MainButton.Text = "FE Invisible: OFF"
        MainButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        -- Ibabalik ang character sa normal
        if savedC0 then
            rootJoint.C0 = savedC0
        end
    end
end)

-- === PART 3: VOICE PROTECTOR ===
local function applyVoice(char)
    task.wait(1)
    local mic = char:FindFirstChildOfClass("AudioDeviceInput") or char.PrimaryPart:FindFirstChildOfClass("AudioDeviceInput")
    if mic then
        local shifter = Instance.new("AudioPitchShifter", mic)
        shifter.Pitch = 0.94 + (math.random() * 0.12)
    end
end

-- === PART 4: WASD FLY (F) ===
local flying = false
local speed = 50
local bv, bg

local function toggleFly()
    local char = LP.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    flying = not flying
    if flying then
        hum.PlatformStand = true
        bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bg = Instance.new("BodyGyro", root)
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 15000
        task.spawn(function()
            while flying do
                local dir = Vector3.new(0,0,0)
                local cam = workspace.CurrentCamera.CFrame
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.LookVector end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.LookVector end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.RightVector end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.RightVector end
                bv.Velocity = dir.Unit * speed
                if dir.Magnitude == 0 then bv.Velocity = Vector3.new(0,0.1,0) end
                bg.CFrame = cam
                task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            hum.PlatformStand = false
        end)
    end
end

Mouse.KeyDown:Connect(function(key) if key:lower() == "f" then toggleFly() end end)
LP.CharacterAdded:Connect(applyVoice)
if LP.Character then applyVoice(LP.Character) end
