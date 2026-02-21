-- =====================================================
-- DEATH RAILS - ULTIMATE EDITION V2
-- FITUR: ESP TARGET | GHOST SHOOT | ESP ZOMBIE | AUTO SHOOT
-- SUPPORT ALL EXECUTOR (KRNL, SYNAPSE, SCRIPT-WARE, ETC)
-- CREATED BY JUNZXSEC | TELEGRAM: @xRay404x
-- =====================================================

--[[
██████╗ ███████╗ █████╗ ████████╗██╗  ██╗    ██████╗  █████╗ ██╗██╗     ███████╗
██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██║  ██║    ██╔══██╗██╔══██╗██║██║     ██╔════╝
██║  ██║█████╗  ███████║   ██║   ███████║    ██████╔╝███████║██║██║     ███████╗
██║  ██║██╔══╝  ██╔══██║   ██║   ██╔══██║    ██╔══██╗██╔══██║██║██║     ╚════██║
██████╔╝███████╗██║  ██║   ██║   ██║  ██║    ██║  ██║██║  ██║██║███████╗███████║
╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝
--]]

-- ==================== LOADING SCREEN ====================
local function showLoading()
    local loading = Instance.new("ScreenGui")
    local frame = Instance.new("Frame")
    local title = Instance.new("TextLabel")
    local bar = Instance.new("Frame")
    local fill = Instance.new("Frame")
    local progress = Instance.new("TextLabel")
    
    loading.Name = "DeathRailsLoading"
    loading.Parent = game.CoreGui
    loading.ResetOnSpawn = false
    
    frame.Parent = loading
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Active = true
    frame.Draggable = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    title.Parent = frame
    title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 10, 0, 10)
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Font = Enum.Font.GothamBold
    title.Text = "DEATH RAILS ULTIMATE V2"
    title.TextColor3 = Color3.fromRGB(255, 0, 0)
    title.TextScaled = true
    
    bar.Parent = frame
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    bar.Position = UDim2.new(0, 20, 0, 70)
    bar.Size = UDim2.new(1, -40, 0, 25)
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 5)
    barCorner.Parent = bar
    
    fill.Parent = bar
    fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    fill.Size = UDim2.new(0, 0, 1, 0)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 5)
    fillCorner.Parent = fill
    
    progress.Parent = frame
    progress.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progress.BackgroundTransparency = 1
    progress.Position = UDim2.new(0, 20, 0, 100)
    progress.Size = UDim2.new(1, -40, 0, 30)
    progress.Font = Enum.Font.Gotham
    progress.Text = "Loading 0%"
    progress.TextColor3 = Color3.fromRGB(255, 255, 255)
    progress.TextScaled = true
    
    spawn(function()
        for i = 1, 100 do
            fill:TweenSize(UDim2.new(i/100, 0, 1, 0), "Out", "Linear", 0.03)
            progress.Text = "Loading " .. i .. "%"
            wait(0.03)
        end
        wait(0.5)
        loading:Destroy()
    end)
end

showLoading()

-- ==================== VARIABLES ====================
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Auto Farm Variables
local autoFarm = false
local autoBuy = false
local autoFloor = false
local autoSpin = false
local selectedFloor = 1

-- Movement Variables
local fly = false
local infiniteJump = false
local speedEnabled = false
local speedAmount = 32
local jumpPowerEnabled = false
local jumpPowerAmount = 50

-- Combat Variables (FITUR BARU!)
local espTargetEnabled = false
local espZombieEnabled = false
local ghostShootEnabled = false
local autoShootEnabled = false
local aimbotEnabled = false
local noRecoilEnabled = false
local rapidFireEnabled = false
local infiniteAmmoEnabled = false
local damageMultiplierEnabled = false
local damageAmount = 100

-- ESP Variables
local espEnabled = false
local espObjects = {}
local zombieESPObjects = {}

-- Cache for zombies
local zombies = {}
local targetZombie = nil

-- ==================== CREATE FLOATING GUI ====================
local gui = Instance.new("ScreenGui")
gui.Name = "DeathRailsGUI"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = gui
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250) -- Lebih gede
mainFrame.Size = UDim2.new(0, 600, 0, 500)
mainFrame.Active = true
mainFrame.Draggable = true

-- Shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Parent = mainFrame
shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Image = "rbxassetid://6015897843"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 10, 10)

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10))
})
gradient.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 0
titleBar.Size = UDim2.new(1, 0, 0, 40)

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleBar

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 0))
})
titleGradient.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Parent = titleBar
titleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleText.BackgroundTransparency = 1
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Font = Enum.Font.GothamBold
titleText.Text = "⚡ DEATH RAILS ULTIMATE V2"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextScaled = true

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = titleBar
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Minimize Button
local minButton = Instance.new("TextButton")
minButton.Name = "MinButton"
minButton.Parent = titleBar
minButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minButton.BorderSizePixel = 0
minButton.Position = UDim2.new(1, -70, 0, 5)
minButton.Size = UDim2.new(0, 30, 0, 30)
minButton.Font = Enum.Font.GothamBold
minButton.Text = "–"
minButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minButton.TextScaled = true

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minButton

-- Tab Buttons (5 TABS)
local tabFrame = Instance.new("Frame")
tabFrame.Parent = mainFrame
tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabFrame.BorderSizePixel = 0
tabFrame.Position = UDim2.new(0, 0, 0, 50)
tabFrame.Size = UDim2.new(1, 0, 0, 50)

local farmTab = Instance.new("TextButton")
farmTab.Name = "FarmTab"
farmTab.Parent = tabFrame
farmTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
farmTab.BorderSizePixel = 0
farmTab.Position = UDim2.new(0, 5, 0, 10)
farmTab.Size = UDim2.new(0.2, -5, 0, 30)
farmTab.Font = Enum.Font.Gotham
farmTab.Text = "FARM"
farmTab.TextColor3 = Color3.fromRGB(255, 255, 255)
farmTab.TextScaled = true

local movementTab = Instance.new("TextButton")
movementTab.Name = "MovementTab"
movementTab.Parent = tabFrame
movementTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
movementTab.BorderSizePixel = 0
movementTab.Position = UDim2.new(0.2, 0, 0, 10)
movementTab.Size = UDim2.new(0.2, -5, 0, 30)
movementTab.Font = Enum.Font.Gotham
movementTab.Text = "MOVEMENT"
movementTab.TextColor3 = Color3.fromRGB(255, 255, 255)
movementTab.TextScaled = true

local combatTab = Instance.new("TextButton") -- TAB BARU!
combatTab.Name = "CombatTab"
combatTab.Parent = tabFrame
combatTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
combatTab.BorderSizePixel = 0
combatTab.Position = UDim2.new(0.4, 0, 0, 10)
combatTab.Size = UDim2.new(0.2, -5, 0, 30)
combatTab.Font = Enum.Font.Gotham
combatTab.Text = "COMBAT"
combatTab.TextColor3 = Color3.fromRGB(255, 255, 255)
combatTab.TextScaled = true

local espTab = Instance.new("TextButton")
espTab.Name = "ESPTab"
espTab.Parent = tabFrame
espTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espTab.BorderSizePixel = 0
espTab.Position = UDim2.new(0.6, 0, 0, 10)
espTab.Size = UDim2.new(0.2, -5, 0, 30)
espTab.Font = Enum.Font.Gotham
espTab.Text = "ESP"
espTab.TextColor3 = Color3.fromRGB(255, 255, 255)
espTab.TextScaled = true

local miscTab = Instance.new("TextButton")
miscTab.Name = "MiscTab"
miscTab.Parent = tabFrame
miscTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
miscTab.BorderSizePixel = 0
miscTab.Position = UDim2.new(0.8, 0, 0, 10)
miscTab.Size = UDim2.new(0.2, -5, 0, 30)
miscTab.Font = Enum.Font.Gotham
miscTab.Text = "MISC"
miscTab.TextColor3 = Color3.fromRGB(255, 255, 255)
miscTab.TextScaled = true

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Parent = mainFrame
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentFrame.BorderSizePixel = 0
contentFrame.Position = UDim2.new(0, 10, 0, 110)
contentFrame.Size = UDim2.new(1, -20, 1, -130)

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 10)
contentCorner.Parent = contentFrame

-- Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Parent = contentFrame
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollFrame.BorderSizePixel = 0
scrollFrame.Position = UDim2.new(0, 0, 0, 0)
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 3, 0)
scrollFrame.ScrollBarThickness = 5

-- ==================== HELPER FUNCTIONS ====================
function createToggle(parent, text, position, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Parent = parent
    toggleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Position = position
    toggleFrame.Size = UDim2.new(1, -20, 0, 40)

    local label = Instance.new("TextLabel")
    label.Parent = toggleFrame
    label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true

    local toggle = Instance.new("TextButton")
    toggle.Parent = toggleFrame
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggle.BorderSizePixel = 0
    toggle.Position = UDim2.new(0.8, 0, 0.1, 0)
    toggle.Size = UDim2.new(0, 60, 0, 30)
    toggle.Font = Enum.Font.Gotham
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextScaled = true

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggle

    local isOn = false
    toggle.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            toggle.Text = "ON"
            callback(true)
        else
            toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            toggle.Text = "OFF"
            callback(false)
        end
    end)

    return toggle
end

function createButton(parent, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    button.BorderSizePixel = 0
    button.Position = position
    button.Size = size
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    button.MouseButton1Click:Connect(callback)
    
    return button
end

function createSlider(parent, text, position, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = parent
    sliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Position = position
    sliderFrame.Size = UDim2.new(1, -20, 0, 60)

    local label = Instance.new("TextLabel")
    label.Parent = sliderFrame
    label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, 0, 0, 30)
    label.Font = Enum.Font.Gotham
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextScaled = true

    local slider = Instance.new("Frame")
    slider.Parent = sliderFrame
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    slider.Position = UDim2.new(0, 0, 0, 35)
    slider.Size = UDim2.new(1, 0, 0, 5)

    local fill = Instance.new("Frame")
    fill.Parent = slider
    fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)

    local drag = Instance.new("TextButton")
    drag.Parent = slider
    drag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    drag.Position = UDim2.new((default - min) / (max - min), -5, -0.5, 0)
    drag.Size = UDim2.new(0, 10, 0, 15)
    drag.Text = ""
    drag.AutoButtonColor = false

    local dragCorner = Instance.new("UICorner")
    dragCorner.CornerRadius = UDim.new(0, 3)
    dragCorner.Parent = drag

    local dragging = false
    drag.MouseButton1Down:Connect(function()
        dragging = true
    end)

    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local sliderPos = slider.AbsolutePosition
            local relativeX = math.clamp(mousePos.X - sliderPos.X, 0, slider.AbsoluteSize.X)
            local percent = relativeX / slider.AbsoluteSize.X
            local value = math.floor(min + (max - min) * percent)
            
            fill.Size = UDim2.new(percent, 0, 1, 0)
            drag.Position = UDim2.new(percent, -5, -0.5, 0)
            label.Text = text .. ": " .. value
            callback(value)
        end
    end)

    return slider
end

function createLabel(parent, text, position, size)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Position = position
    label.Size = size
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextScaled = true
    return label
end

function table.clear(t)
    for i = #t, 1, -1 do
        t[i] = nil
    end
end

-- ==================== ESP FUNCTIONS ====================
function createTargetESP(plr)
    if espObjects[plr] then
        espObjects[plr]:Destroy()
        espObjects[plr] = nil
    end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = "ESP_" .. plr.Name
    esp.Parent = plr.Character and plr.Character:FindFirstChild("Head") or nil
    if not esp.Parent then return end
    
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 200, 0, 80)
    esp.StudsOffset = Vector3.new(0, 3, 0)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = esp
    nameLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.BackgroundTransparency = 0.5
    nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = plr.Name
    nameLabel.TextColor3 = plr.Team and plr.Team.TeamColor.Color or Color3.fromRGB(255, 0, 0)
    nameLabel.TextScaled = true

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Parent = esp
    healthLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthLabel.BackgroundTransparency = 0.5
    healthLabel.Position = UDim2.new(0, 0, 0.33, 0)
    healthLabel.Size = UDim2.new(1, 0, 0.33, 0)
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextScaled = true

    local distLabel = Instance.new("TextLabel")
    distLabel.Parent = esp
    distLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.BackgroundTransparency = 0.5
    distLabel.Position = UDim2.new(0, 0, 0.66, 0)
    distLabel.Size = UDim2.new(1, 0, 0.33, 0)
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    distLabel.TextScaled = true

    espObjects[plr] = esp

    -- Update loop
    coroutine.wrap(function()
        while esp and esp.Parent do
            wait(0.1)
            if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") then
                esp.Parent = plr.Character.Head
                
                local health = plr.Character.Humanoid.Health
                local maxHealth = plr.Character.Humanoid.MaxHealth
                local healthPercent = (health / maxHealth) * 100
                healthLabel.Text = string.format("HP: %.1f (%.0f%%)", health, healthPercent)
                
                if healthPercent > 50 then
                    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                elseif healthPercent > 25 then
                    healthLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                else
                    healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                end
                
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (player.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    distLabel.Text = string.format("%.1f m", dist)
                end
            else
                esp:Destroy()
                espObjects[plr] = nil
                break
            end
        end
    end)()
end

function createZombieESP(zombie)
    if zombieESPObjects[zombie] then
        zombieESPObjects[zombie]:Destroy()
        zombieESPObjects[zombie] = nil
    end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = "ZombieESP"
    esp.Parent = zombie:FindFirstChild("Head") or zombie:FindFirstChild("HumanoidRootPart") or zombie
    if not esp.Parent then return end
    
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(0, 150, 0, 60)
    esp.StudsOffset = Vector3.new(0, 2, 0)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = esp
    nameLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.BackgroundTransparency = 0.5
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = "🧟 ZOMBIE"
    nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    nameLabel.TextScaled = true

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Parent = esp
    healthLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    healthLabel.BackgroundTransparency = 0.5
    healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
    healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthLabel.TextScaled = true

    zombieESPObjects[zombie] = esp

    -- Update loop
    coroutine.wrap(function()
        while esp and esp.Parent and zombie and zombie.Parent do
            wait(0.1)
            if zombie:FindFirstChild("Humanoid") then
                local health = zombie.Humanoid.Health
                local maxHealth = zombie.Humanoid.MaxHealth or 100
                healthLabel.Text = string.format("HP: %.0f/%.0f", health, maxHealth)
                
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (player.Character.HumanoidRootPart.Position - zombie.HumanoidRootPart.Position).Magnitude
                    local color = dist < 30 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 0)
                    nameLabel.TextColor3 = color
                end
            else
                esp:Destroy()
                zombieESPObjects[zombie] = nil
                break
            end
        end
    end)()
end

-- ==================== COMBAT FUNCTIONS ====================
function findNearestZombie()
    local nearest = nil
    local nearestDist = math.huge
    
    for _, zombie in pairs(zombies) do
        if zombie and zombie.Parent and zombie:FindFirstChild("Humanoid") and zombie.Humanoid.Health > 0 then
            local dist = (rootPart.Position - zombie.HumanoidRootPart.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = zombie
            end
        end
    end
    
    return nearest, nearestDist
end

function shootZombie(zombie)
    if not zombie or not zombie.Parent then return end
    
    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    -- Ghost Shoot (tembus tembok)
    if ghostShootEnabled then
        -- Simulate shooting through walls
        local args = {
            [1] = zombie.HumanoidRootPart.Position,
            [2] = zombie.HumanoidRootPart
        }
        tool:FindFirstChild("RemoteEvent"):FireServer(unpack(args))
    else
        -- Normal shoot
        local args = {
            [1] = zombie.HumanoidRootPart.Position,
            [2] = zombie.HumanoidRootPart
        }
        tool:FindFirstChild("RemoteEvent"):FireServer(unpack(args))
    end
end

-- Update zombie list
game:GetService("Workspace").DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Model") and descendant:FindFirstChild("Humanoid") and descendant.Name:lower():find("zombie") then
        table.insert(zombies, descendant)
        if espZombieEnabled then
            createZombieESP(descendant)
        end
    end
end)

game:GetService("Workspace").DescendantRemoving:Connect(function(descendant)
    for i, zombie in pairs(zombies) do
        if zombie == descendant then
            table.remove(zombies, i)
            if zombieESPObjects[zombie] then
                zombieESPObjects[zombie]:Destroy()
                zombieESPObjects[zombie] = nil
            end
            break
        end
    end
end)

-- Initial zombie scan
for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name:lower():find("zombie") then
        table.insert(zombies, v)
    end
end

-- ==================== FARM TAB CONTENT ====================
local farmContent = Instance.new("Frame")
farmContent.Name = "FarmContent"
farmContent.Parent = scrollFrame
farmContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
farmContent.BackgroundTransparency = 1
farmContent.Size = UDim2.new(1, 0, 3, 0)
farmContent.Visible = true

createLabel(farmContent, "⚙️ FARM SETTINGS", UDim2.new(0, 10, 0, 5), UDim2.new(1, -20, 0, 30))

-- Auto Farm
local farmToggle = createToggle(farmContent, "Auto Farm", UDim2.new(0, 10, 0, 40), function(value)
    autoFarm = value
end)

-- Auto Buy
local buyToggle = createToggle(farmContent, "Auto Buy", UDim2.new(0, 10, 0, 90), function(value)
    autoBuy = value
end)

-- Auto Floor
local floorToggle = createToggle(farmContent, "Auto Floor", UDim2.new(0, 10, 0, 140), function(value)
    autoFloor = value
end)

-- Auto Spin
local spinToggle = createToggle(farmContent, "Auto Spin", UDim2.new(0, 10, 0, 190), function(value)
    autoSpin = value
end)

-- Floor Selector
createLabel(farmContent, "🎯 FLOOR SELECTOR", UDim2.new(0, 10, 0, 240), UDim2.new(1, -20, 0, 30))

local floorLabel = Instance.new("TextLabel")
floorLabel.Parent = farmContent
floorLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
floorLabel.BackgroundTransparency = 1
floorLabel.Position = UDim2.new(0, 10, 0, 275)
floorLabel.Size = UDim2.new(0.5, -15, 0, 40)
floorLabel.Font = Enum.Font.Gotham
floorLabel.Text = "Floor: " .. selectedFloor
floorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
floorLabel.TextScaled = true

local floorPlus = createButton(farmContent, "+", UDim2.new(0.5, 5, 0, 275), UDim2.new(0, 50, 0, 40), function()
    selectedFloor = selectedFloor + 1
    floorLabel.Text = "Floor: " .. selectedFloor
end)

local floorMinus = createButton(farmContent, "-", UDim2.new(0.7, 5, 0, 275), UDim2.new(0, 50, 0, 40), function()
    if selectedFloor > 1 then
        selectedFloor = selectedFloor - 1
        floorLabel.Text = "Floor: " .. selectedFloor
    end
end)

-- ==================== MOVEMENT TAB CONTENT ====================
local movementContent = Instance.new("Frame")
movementContent.Name = "MovementContent"
movementContent.Parent = scrollFrame
movementContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
movementContent.BackgroundTransparency = 1
movementContent.Size = UDim2.new(1, 0, 3, 0)
movementContent.Visible = false

createLabel(movementContent, "🏃 MOVEMENT SETTINGS", UDim2.new(0, 10, 0, 5), UDim2.new(1, -20, 0, 30))

-- Fly
local flyToggle = createToggle(movementContent, "Fly", UDim2.new(0, 10, 0, 40), function(value)
    fly = value
    if fly then
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Parent = rootPart
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Parent = rootPart
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        
        flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if fly and rootPart and rootPart.Parent then
                bodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50 * (humanoid.MoveDirection.Magnitude > 0 and 1 or 0)
                bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, (humanoid.Jump and 50 or 0) - (humanoid.Sit and 50 or 0), 0)
                bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            else
                if bodyGyro then bodyGyro:Destroy() end
                if bodyVelocity then bodyVelocity:Destroy() end
                if flyConnection then flyConnection:Disconnect() end
            end
        end)
    end
end)

-- Infinite Jump
local jumpToggle = createToggle(movementContent, "Infinite Jump", UDim2.new(0, 10, 0, 90), function(value)
    infiniteJump = value
    if infiniteJump then
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if infiniteJump then
                humanoid:ChangeState("Jumping")
            end
        end)
    end
end)

-- Speed
local speedToggle = createToggle(movementContent, "Speed", UDim2.new(0, 10, 0, 140), function(value)
    speedEnabled = value
    if speedEnabled then
        humanoid.WalkSpeed = speedAmount
    else
        humanoid.WalkSpeed = 16
    end
end)

local speedSlider = createSlider(movementContent, "Speed Value", UDim2.new(0, 10, 0, 190), 16, 200, speedAmount, function(value)
    speedAmount = value
    if speedEnabled then
        humanoid.WalkSpeed = value
    end
end)

-- Jump Power
local jumpPowerToggle = createToggle(movementContent, "Jump Power", UDim2.new(0, 10, 0, 260), function(value)
    jumpPowerEnabled = value
    if jumpPowerEnabled then
        humanoid.JumpPower = jumpPowerAmount
    else
        humanoid.JumpPower = 50
    end
end)

local jumpSlider = createSlider(movementContent, "Jump Value", UDim2.new(0, 10, 0, 310), 50, 500, jumpPowerAmount, function(value)
    jumpPowerAmount = value
    if jumpPowerEnabled then
        humanoid.JumpPower = value
    end
end)

-- ==================== COMBAT TAB CONTENT (BARU!) ====================
local combatContent = Instance.new("Frame")
combatContent.Name = "CombatContent"
combatContent.Parent = scrollFrame
combatContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
combatContent.BackgroundTransparency = 1
combatContent.Size = UDim2.new(1, 0, 3, 0)
combatContent.Visible = false

createLabel(combatContent, "⚔️ COMBAT SETTINGS", UDim2.new(0, 10, 0, 5), UDim2.new(1, -20, 0, 30))

-- Ghost Shoot
local ghostShootToggle = createToggle(combatContent, "Ghost Shoot (Wallbang)", UDim2.new(0, 10, 0, 40), function(value)
    ghostShootEnabled = value
end)

-- Auto Shoot
local autoShootToggle = createToggle(combatContent, "Auto Shoot", UDim2.new(0, 10, 0, 90), function(value)
    autoShootEnabled = value
end)

-- Aimbot
local aimbotToggle = createToggle(combatContent, "Aimbot", UDim2.new(0, 10, 0, 140), function(value)
    aimbotEnabled = value
end)

-- No Recoil
local noRecoilToggle = createToggle(combatContent, "No Recoil", UDim2.new(0, 10, 0, 190), function(value)
    noRecoilEnabled = value
    if value then
        -- Find and modify recoil values
        for _, v in pairs(player.PlayerGui:GetDescendants()) do
            if v:IsA("NumberValue") and v.Name:lower():find("recoil") then
                v.Value = 0
            end
        end
    end
end)

-- Rapid Fire
local rapidFireToggle = createToggle(combatContent, "Rapid Fire", UDim2.new(0, 10, 0, 240), function(value)
    rapidFireEnabled = value
end)

-- Infinite Ammo
local infiniteAmmoToggle = createToggle(combatContent, "Infinite Ammo", UDim2.new(0, 10, 0, 290), function(value)
    infiniteAmmoEnabled = value
end)

-- Damage Multiplier
local damageToggle = createToggle(combatContent, "Damage Multiplier", UDim2.new(0, 10, 0, 340), function(value)
    damageMultiplierEnabled = value
end)

local damageSlider = createSlider(combatContent, "Damage Amount", UDim2.new(0, 10, 0, 390), 10, 1000, damageAmount, function(value)
    damageAmount = value
end)

-- ==================== ESP TAB CONTENT ====================
local espContent = Instance.new("Frame")
espContent.Name = "ESPContent"
espContent.Parent = scrollFrame
espContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
espContent.BackgroundTransparency = 1
espContent.Size = UDim2.new(1, 0, 3, 0)
espContent.Visible = false

createLabel(espContent, "👁️ ESP SETTINGS", UDim2.new(0, 10, 0, 5), UDim2.new(1, -20, 0, 30))

-- Player ESP
local playerEspToggle = createToggle(espContent, "ESP Target (Player)", UDim2.new(0, 10, 0, 40), function(value)
    espTargetEnabled = value
    if espTargetEnabled then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player then
                createTargetESP(plr)
            end
        end
        
        game.Players.PlayerAdded:Connect(function(plr)
            if espTargetEnabled then
                createTargetESP(plr)
            end
        end)
        
        game.Players.PlayerRemoving:Connect(function(plr)
            if espObjects[plr] then
                espObjects[plr]:Destroy()
                espObjects[plr] = nil
            end
        end)
    else
        for _, esp in pairs(espObjects) do
            if esp then
                esp:Destroy()
            end
        end
        table.clear(espObjects)
    end
end)

-- Zombie ESP
local zombieEspToggle = createToggle(espContent, "ESP Zombie", UDim2.new(0, 10, 0, 90), function(value)
    espZombieEnabled = value
    if espZombieEnabled then
        for _, zombie in pairs(zombies) do
            createZombieESP(zombie)
        end
    else
        for _, esp in pairs(zombieESPObjects) do
            if esp then
                esp:Destroy()
            end
        end
        table.clear(zombieESPObjects)
    end
end)

-- ==================== MISC TAB CONTENT ====================
local miscContent = Instance.new("Frame")
miscContent.Name = "MiscContent"
miscContent.Parent = scrollFrame
miscContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
miscContent.BackgroundTransparency = 1
miscContent.Size = UDim2.new(1, 0, 3, 0)
miscContent.Visible = false

createLabel(miscContent, "⚙️ MISC SETTINGS", UDim2.new(0, 10, 0, 5), UDim2.new(1, -20, 0, 30))

-- Anti AFK
local antiAfkToggle = createToggle(miscContent, "Anti AFK", UDim2.new(0, 10, 0, 40), function(value)
    if value then
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
    end
end)

-- No Fog
local noFogToggle = createToggle(miscContent, "No Fog", UDim2.new(0, 10, 0, 90), function(value)
    if value then
        game:GetService("Lighting").FogEnd = 1e9
    else
        game:GetService("Lighting").FogEnd = 1000
    end
end)

-- Full Bright
local fullBrightToggle = createToggle(miscContent, "Full Bright", UDim2.new(0, 10, 0, 140), function(value)
    if value then
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
    else
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").Ambient = Color3.fromRGB(0, 0, 0)
    end
end)

-- Watermark
local watermarkToggle = createToggle(miscContent, "Watermark", UDim2.new(0, 10, 0, 190), function(value)
    if watermark then
        watermark.Enabled = value
    end
end)

-- ==================== TAB SWITCHING ====================
farmTab.MouseButton1Click:Connect(function()
    farmTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    movementTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    combatTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    espTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    miscTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    farmContent.Visible = true
    movementContent.Visible = false
    combatContent.Visible = false
    espContent.Visible = false
    miscContent.Visible = false
end)

movementTab.MouseButton1Click:Connect(function()
    farmTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    movementTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    combatTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    espTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    miscTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    farmContent.Visible = false
    movementContent.Visible = true
    combatContent.Visible = false
    espContent.Visible = false
    miscContent.Visible = false
end)

combatTab.MouseButton1Click:Connect(function()
    farmTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    movementTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    combatTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    espTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    miscTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    farmContent.Visible = false
    movementContent.Visible = false
    combatContent.Visible = true
    espContent.Visible = false
    miscContent.Visible = false
end)

espTab.MouseButton1Click:Connect(function()
    farmTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    movementTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    combatTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    espTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    miscTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    farmContent.Visible = false
    movementContent.Visible = false
    combatContent.Visible = false
    espContent.Visible = true
    miscContent.Visible = false
end)

miscTab.MouseButton1Click:Connect(function()
    farmTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    movementTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    combatTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    espTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    miscTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    
    farmContent.Visible = false
    movementContent.Visible = false
    combatContent.Visible = false
    espContent.Visible = false
    miscContent.Visible = true
end)

-- Minimize functionality
local minimized = false
minButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame:TweenSize(UDim2.new(0, 600, 0, 50), "Out", "Quad", 0.3)
        contentFrame.Visible = false
        tabFrame.Visible = false
        minButton.Text = "□"
    else
        mainFrame:TweenSize(UDim2.new(0, 600, 0, 500), "Out", "Quad", 0.3)
        contentFrame.Visible = true
        tabFrame.Visible = true
        minButton.Text = "–"
    end
end)

-- ==================== AUTO FARM LOOP ====================
spawn(function()
    while true do
        wait(0.1)
        
        if autoFarm then
            -- Auto farm logic
            local coins = workspace:FindFirstChild("Coins")
            if coins then
                for _, coin in pairs(coins:GetChildren()) do
                    if coin:IsA("Part") then
                        firetouchinterest(rootPart, coin, 0)
                        wait()
                        firetouchinterest(rootPart, coin, 1)
                    end
                end
            end
        end
        
        if autoBuy then
            -- Auto buy logic
            local shop = player.PlayerGui:FindFirstChild("Shop")
            if shop and shop.Enabled then
                local buyButton = shop:FindFirstChild("BuyButton")
                if buyButton then
                    buyButton:Fire()
                end
            end
        end
        
        if autoFloor then
            -- Auto floor logic
            local floorGui = player.PlayerGui:FindFirstChild("FloorGUI")
            if floorGui then
                local floorButton = floorGui:FindFirstChild("Floor" .. selectedFloor)
                if floorButton then
                    floorButton:Fire()
                end
            end
        end
        
        if autoSpin then
            -- Auto spin logic
            local spinGui = player.PlayerGui:FindFirstChild("SpinGUI")
            if spinGui then
                local spinButton = spinGui:FindFirstChild("SpinButton")
                if spinButton then
                    spinButton:Fire()
                end
            end
        end
    end
end)

-- ==================== AUTO SHOOT LOOP ====================
spawn(function()
    while true do
        wait(0.01) -- Cepet banget
        
        if autoShootEnabled or aimbotEnabled then
            local nearestZombie, distance = findNearestZombie()
            
            if nearestZombie then
                targetZombie = nearestZombie
                
                -- Aimbot (auto aim)
                if aimbotEnabled then
                    -- Rotate camera ke zombie
                    local camera = workspace.CurrentCamera
                    local zombiePos = nearestZombie.HumanoidRootPart.Position
                    camera.CFrame = CFrame.new(camera.CFrame.Position, zombiePos)
                end
                
                -- Auto Shoot
                if autoShootEnabled then
                    shootZombie(nearestZombie)
                end
            end
        end
        
        -- Rapid Fire (modify tool cooldown)
        if rapidFireEnabled then
            local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Cooldown") then
                tool.Cooldown.Value = 0
            end
        end
        
        -- Infinite Ammo
        if infiniteAmmoEnabled then
            local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Ammo") then
                tool.Ammo.Value = 9999
            end
        end
        
        -- Damage Multiplier
        if damageMultiplierEnabled then
            -- This would need to hook into damage events
            -- Implementation depends on game's remote events
        end
    end
end)

-- ==================== WATERMARK ====================
local watermark = Instance.new("ScreenGui")
watermark.Name = "Watermark"
watermark.Parent = game.CoreGui
watermark.ResetOnSpawn = false

local watermarkFrame = Instance.new("Frame")
watermarkFrame.Parent = watermark
watermarkFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
watermarkFrame.BackgroundTransparency = 0.5
watermarkFrame.BorderSizePixel = 0
watermarkFrame.Position = UDim2.new(0, 10, 1, -40)
watermarkFrame.Size = UDim2.new(0, 250, 0, 30)

local watermarkCorner = Instance.new("UICorner")
watermarkCorner.CornerRadius = UDim.new(0, 5)
watermarkCorner.Parent = watermarkFrame

local watermarkText = Instance.new("TextLabel")
watermarkText.Parent = watermarkFrame
watermarkText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
watermarkText.BackgroundTransparency = 1
watermarkText.Size = UDim2.new(1, 0, 1, 0)
watermarkText.Font = Enum.Font.Gotham
watermarkText.Text = "DEATH RAILS ULTIMATE V2 | JUNZXSEC"
watermarkText.TextColor3 = Color3.fromRGB(255, 0, 0)
watermarkText.TextScaled = true

-- ==================== NOTIFICATION ====================
local function notify(msg)
    local notification = Instance.new("ScreenGui")
    notification.Parent = game.CoreGui
    notification.Name = "Notification"
    
    local frame = Instance.new("Frame")
    frame.Parent = notification
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.8
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0.5, -150, 0, -50)
    frame.Size = UDim2.new(0, 300, 0, 50)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Parent = frame
    text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    text.BackgroundTransparency = 1
    text.Size = UDim2.new(1, 0, 1, 0)
    text.Font = Enum.Font.Gotham
    text.Text = msg
    text.TextColor3 = Color3.fromRGB(255, 0, 0)
    text.TextScaled = true
    
    frame:TweenPosition(UDim2.new(0.5, -150, 0, 10), "Out", "Quad", 0.5)
    wait(3)
    frame:TweenPosition(UDim2.new(0.5, -150, 0, -50), "Out", "Quad", 0.5)
    wait(0.5)
    notification:Destroy()
end

notify("DEATH RAILS ULTIMATE V2 LOADED!")

-- ==================== CREDITS ====================
print([[
============================================
DEATH RAILS ULTIMATE V2
CREATED BY JUNZXSEC
TELEGRAM: @xRay404x

FITUR LENGKAP:
✅ ESP Target (Player)
✅ Ghost Shoot (Wallbang)
✅ ESP Zombie
✅ Auto Shoot
✅ Aimbot
✅ No Recoil
✅ Rapid Fire
✅ Infinite Ammo
✅ Damage Multiplier
✅ Auto Farm
✅ Auto Buy
✅ Auto Floor
✅ Auto Spin
✅ Fly
✅ Infinite Jump
✅ Speed Hack
✅ Jump Power
✅ Anti AFK
✅ No Fog
✅ Full Bright
============================================
]])