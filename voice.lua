local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

local flying = false
local speed = 50 -- Baguhin mo rito kung gusto mo mas mabilis/mabagal

local function toggleFly()
    flying = not flying
    local char = LP.Character
    local hum = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")

    if flying then
        -- Gagawa ng BodyVelocity at BodyGyro para sa paglipad
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = root

        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyGyro"
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 9e4
        bg.CFrame = root.CFrame
        bg.Parent = root

        hum.PlatformStand = true -- Para hindi gumalaw ang paa habang lumilipad

        task.spawn(function()
            while flying do
                -- Susunod ang lipad kung saan nakaturo ang camera mo
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
                bg.CFrame = workspace.CurrentCamera.CFrame
                task.wait()
            end
        end)
        print("Fly ON")
    else
        -- Tatanggalin ang fly forces kapag OFF
        if root:FindFirstChild("FlyVelocity") then root.FlyVelocity:Destroy() end
        if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
        hum.PlatformStand = false
        print("Fly OFF")
    end
end

-- Detection para sa Letter F
Mouse.KeyDown:Connect(function(key)
    if key:lower() == "f" then
        toggleFly()
    end
end)
