-- Moon-Zen V5 (Moon Edition🌕)

-- Load Rayfield GUI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create GUI window with Moon theme
local window = Rayfield:CreateWindow("Moon-Zen V5🌕", {
    Size = UDim2.new(0, 400, 0, 300),
    Title = "Moon-Zen V5🌕",
    Theme = {
        BackgroundColor = Color3.fromRGB(15, 15, 30), -- Dark night sky
        TextColor = Color3.fromRGB(255, 255, 255), -- White text for contrast
        AccentColor = Color3.fromRGB(200, 200, 255), -- Light blue for moonlight
        ButtonColor = Color3.fromRGB(50, 50, 100), -- Slightly lighter dark blue
    }
})

-- Add Discord label
local discordLabel = window:CreateLabel({
    Text = "discord - meowbucks",
    Position = UDim2.new(0.5, 0, 0, 20),
    AnchorPoint = Vector2.new(0.5, 0),
    TextColor = Rayfield.Themes.TextColor,
    Font = Enum.Font.Gotham
})

-- Utility functions
local function safeExecute(func, ...)
    local success, result = xpcall(func, debug.traceback, ...)
    if not success then
        warn("Error: " .. result)
    end
    return result
end

local function asyncTask(func, ...)
    coroutine.wrap(function()
        safeExecute(func, ...)
    end)()
end

local function executeWithWait(func, delay, ...)
    task.wait(delay)
    safeExecute(func, ...)
end

-- Enemy Detection
local function isEnemy(player)
    local localPlayer = game.Players.LocalPlayer
    return player.Team ~= localPlayer.Team
end

-- Aimbot
local function aimbot()
    asyncTask(function()
        local localPlayer = game.Players.LocalPlayer
        local mouse = localPlayer:GetMouse()
        
        while true do
            local nearestEnemy = nil
            local shortestDistance = math.huge
            
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= localPlayer and isEnemy(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestEnemy = player
                    end
                end
            end
            
            if nearestEnemy then
                local enemyPosition = nearestEnemy.Character.HumanoidRootPart.Position
                localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(enemyPosition, enemyPosition + (enemyPosition - localPlayer.Character.HumanoidRootPart.Position).unit)
            end
            
            task.wait(0.1)
        end
    end)
end

-- Silent Aim
local function silentAim()
    asyncTask(function()
        local localPlayer = game.Players.LocalPlayer
        
        while true do
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= localPlayer and isEnemy(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local character = player.Character
                    local humanoidRootPart = character.HumanoidRootPart
                    local head = character:FindFirstChild("Head")

                    -- Determine target position (head or torso)
                    local targetPosition = head and head.Position or humanoidRootPart.Position
                    local aimDirection = (targetPosition - localPlayer.Character.Head.Position).unit

                    -- Create a ray from the player's head to the target
                    local ray = Ray.new(localPlayer.Character.Head.Position, aimDirection * 500)
                    local hitPart, hitPosition = workspace:FindPartOnRay(ray, localPlayer.Character)

                    if hitPart and hitPart.Parent == character then
                        -- Smoothly adjust the aim
                        local currentCFrame = localPlayer.Character.HumanoidRootPart.CFrame
                        local targetCFrame = CFrame.new(targetPosition, targetPosition + aimDirection)
                        
                        -- Update CFrame with a smooth transition
                        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                            currentCFrame.Position, 
                            currentCFrame.Position + (targetPosition - currentCFrame.Position).unit
                        )
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end

-- Rainbow FOV
local function rainbowFOV()
    asyncTask(function()
        local localPlayer = game.Players.LocalPlayer
        local fovVisual = localPlayer.PlayerGui:FindFirstChild("FOVVisual") or Instance.new("Frame")
        
        if not fovVisual.Parent then
            fovVisual.Name = "FOVVisual"
            fovVisual.Size = UDim2.new(1, 0, 1, 0)
            fovVisual.BackgroundTransparency = 0.5
            fovVisual.BackgroundColor3 = Color3.fromHSV(0, 1, 1)
            fovVisual.Parent = localPlayer.PlayerGui
        end

        while true do
            local hue = tick() % 10 / 10
            fovVisual.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
            task.wait(0.1)
        end
    end)
end

-- Rainbow Visuals
local function rainbowVisuals()
    asyncTask(function()
        while true do
            local hue = tick() % 10 / 10
            local color = Color3.fromHSV(hue, 1, 1)
            for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.BrickColor = BrickColor.new(color)
                end
            end
            task.wait(0.1)
        end
    end)
end

-- Spinbot
local function spinbot()
    asyncTask(function()
        local localPlayer = game.Players.LocalPlayer
        while true do
            localPlayer.Character.HumanoidRootPart.CFrame = localPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(5), 0)
            task.wait(0.05)
        end
    end)
end

-- Add feature tabs
local featuresTab = window:CreateTab("Lunar Features")

featuresTab:CreateButton({
    Name = "Spinbot",
    Callback = function()
        asyncTask(spinbot)
    end
})

featuresTab:CreateButton({
    Name = "Aimbot",
    Callback = function()
        asyncTask(aimbot)
    end
})

featuresTab:CreateButton({
    Name = "Silent Aim",
    Callback = function()
        asyncTask(silentAim)
    end
})

featuresTab:CreateButton({
    Name = "Rainbow FOV",
    Callback = function()
        asyncTask(rainbowFOV)
    end
})

featuresTab:CreateButton({
    Name = "Rainbow Visuals",
    Callback = function()
        asyncTask(rainbowVisuals)
    end
})

-- Error handling for all features
local function executeMainFunction()
    pcall(function()
        print("Running main function")
        -- Main functionality initialization
    end)
end

executeMainFunction()
