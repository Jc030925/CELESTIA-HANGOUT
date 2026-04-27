local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 200, 0, 50)
ToggleBtn.Position = UDim2.new(0.5, -100, 0.4, 0)
ToggleBtn.Text = "START SPYING"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
ToggleBtn.Draggable = true

local isSpying = false

ToggleBtn.MouseButton1Click:Connect(function()
    isSpying = not isSpying
    ToggleBtn.Text = isSpying and "SPYING ON..." or "START SPYING"
    
    if isSpying then
        print("--- SPY ACTIVE: Mag-equip ka ng kahit anong rod ngayon ---")
        
        -- Hooking into RemoteEvents
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local old = mt.__namecall
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if isSpying and method == "FireServer" then
                print("REMOTE FIRED: " .. self.FullName)
                print("ARGUMENTS: ", unpack(args))
            end
            
            return old(self, ...)
        end)
    end
end)
