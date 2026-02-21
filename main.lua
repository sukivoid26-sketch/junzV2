-- =====================================================
-- DEATH RAILS - FIXED VERSION
-- FITUR: BUTTON MINIMIZE | FLOATING GUI | ESP | GHOST SHOOT
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

-- ==================== VARIABLES ====================
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- GUI Variables
local guiOpen = false
local mainGui = nil

-- Farm Variables
local autoFarm = false
local autoBuy = false
local autoFloor = false
local autoSpin = false
local selectedFloor = 1

-- Movement Variables
local fly = false
local flyConnection = nil
local infiniteJump = false
local infiniteJumpConnection = nil
local speedEnabled = false
local speedAmount = 32
local jumpPowerEnabled = false
local jumpPowerAmount = 50

-- Combat Variables
local ghostShootEnabled = false
local autoShootEnabled = false
local aimbotEnabled = false
local rapidFireEnabled = false
local infiniteAmmoEnabled = false
local damageMultiplierEnabled = false
local damageAmount = 100

-- ESP Variables
local espTargetEnabled = false
local espZombieEnabled = false
local espObjects = {}
local zombieESPObjects = {}

-- Zombie List
local zombies = {}
local targetZombie = nil

-- ==================== LOADING SCREEN ====================
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "DeathRailsLoading"
loadingGui.Parent = game.CoreGui
loadingGui.ResetOnSpawn = false

local loadingFrame = Instance.new("Frame")
loadingFrame.Parent = loadingGui
loadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
loadingFrame.BorderSizePixel = 0
loadingFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
loadingFrame.Size = UDim2.new(0, 300, 0, 150)
loadingFrame.Active = true
loadingFrame.Draggable = true

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 10)
loadingCorner.Parent = loadingFrame

local loadingTitle = Instance.new("TextLabel")
loadingTitle.Parent = loadingFrame
loadingTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loadingTitle.BackgroundTransparency = 1
loadingTitle.Position = UDim2.new(0, 10, 0, 10)
loadingTitle.Size = UDim2.new(1, -20, 0, 30)
loadingTitle.Font = Enum.Font.GothamBold
loadingTitle.Text = "DEATH RAILS ULTIMATE"
loadingTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
loadingTitle.TextScaled = true

local loadingBar = Instance.new("Frame")
loadingBar.Parent = loadingFrame
loadingBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loadingBar.Position = UDim2.new(0, 20, 0, 70)
loadingBar.Size = UDim2.new(1, -40, 0, 25)

local loadingBarCorner = Instance.new("UICorner")
loadingBarCorner.CornerRadius = UDim.new(0, 5)
loadingBarCorner.Parent = loadingBar

local loadingFill = Instance.new("Frame")
loadingFill.Parent = loadingBar
loadingFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
loadingFill.Size = UDim2.new(0, 0, 1, 0)

local loadingFillCorner = Instance.new("UICorner")
loadingFillCorner.CornerRadius = UDim.new(0, 5)
loadingFillCorner.Parent = loadingFill

local loadingProgress = Instance.new("TextLabel")
loadingProgress.Parent = loadingFrame
loadingProgress.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loadingProgress.BackgroundTransparency = 1
loadingProgress.Position = UDim2.new(0, 20, 0, 100)
loadingProgress.Size = UDim2.new(1, -40, 0, 30)
loadingProgress.Font = Enum.Font.Gotham
loadingProgress.Text = "Loading 0%"
loadingProgress.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingProgress.TextScaled = true

-- Loading animation
spawn(function()
    for i = 1, 100 do
        loadingFill:TweenSize(UDim2.new(i/100, 0, 1, 0), "Out", "Linear", 0.03)
        loadingProgress.Text = "Loading " .. i .. "%"
        wait(0.03)
    end
    wait(0.5)
    loadingGui:Destroy()
end)

-- ==================== CREATE MINIMIZE BUTTON ====================
local minimizeButton = Instance.new("ScreenGui")
minimizeButton.Name = "DeathRailsMinimize"
minimizeButton.Parent = game.CoreGui
minimizeButton.ResetOnSpawn = false

local buttonFrame = Instance.new("Frame")
buttonFrame.Parent = minimizeButton
buttonFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
buttonFrame.BorderSizePixel = 0
buttonFrame.Position = UDim2.new(0, 20, 0.5, -25)
buttonFrame.Size = UDim2.new(0, 50, 0, 50)
buttonFrame.Active = true
buttonFrame.Draggable = true
buttonFrame.BackgroundTransparency = 0.2

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0) -- Circle
buttonCorner.Parent = buttonFrame

local buttonIcon = Instance.new("TextLabel")
buttonIcon.Parent = buttonFrame
buttonIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
buttonIcon.BackgroundTransparency = 1
buttonIcon.Size = UDim2.new(1, 0, 1, 0)
buttonIcon.Font = Enum.Font.GothamBold
buttonIcon.Text = "⚡"
buttonIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonIcon.TextScaled = true

local buttonGlow = Instance.new("ImageLabel")
buttonGlow.Parent = buttonFrame
buttonGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
buttonGlow.BackgroundTransparency = 1
buttonGlow.Size = UDim2.new(1.5, 0, 1.5, 0)
buttonGlow.Position = UDim2.new(-0.25, 0, -0.25, 0)
buttonGlow.Image = "rbxassetid://6015897843"
buttonGlow.ImageColor3 = Color3.fromRGB(255, 0, 0)
buttonGlow.ImageTransparency = 0.5
buttonGlow.ScaleType = Enum.ScaleType.Slice
buttonGlow.SliceCenter = Rect.new(10, 10, 10, 10)

-- ==================== CREATE MAIN GUI FUNCTION ====================
function createMainGUI()
    if mainGui then
        mainGui:Destroy()
        mainGui = nil
    end
    
    mainGui = Instance.new("ScreenGui")
    mainGui.Name = "DeathRailsMain"
    mainGui.Parent = game.CoreGui
    mainGui.ResetOnSpawn = false

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = mainGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
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
    titleText.Text = "⚡ DEATH RAILS ULTIMATE"
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
        mainGui:Destroy()
        mainGui = nil
        guiOpen = false
    end)

    -- Minimize Button (inside GUI)
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

    -- Tab Buttons
    local tabFrame = Instance.new("Frame")
    tabFrame.Parent = mainFrame
    tabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabFrame.BorderSizePixel = 0
    tabFrame.Position = UDim2.new(0, 0, 0, 50)
    tabFrame.Size = UDim2.new(1, 0, 0, 50)

    local farmTab = createTabButton(tabFrame, "FARM", UDim2.new(0, 5, 0, 10), UDim2.new(0.2, -5, 0, 30))
    local combatTab = createTabButton(tabFrame, "COMBAT", UDim2.new(0.2, 0, 0, 10), UDim2.new(0.2, -5, 0, 30))
    local movementTab = createTabButton(tabFrame, "MOVEMENT", UDim2.new(0.4, 0, 0, 10), UDim2.new(0.2, -5, 0, 30))
    local espTab = createTabButton(tabFrame, "ESP", UDim2.new(0.6, 0, 0, 10), UDim2.new(0.2, -5, 0, 30))
    local miscTab = createTabButton(tabFrame, "MISC", UDim2.new(0.8, 0, 0, 10), UDim2.new(0.2, -5, 0, 30))

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
    scrollFrame.CanvasSize = UDim2.new(0, 0, 4, 0)
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)

    -- Create all tab contents
    createFarmContent(scrollFrame)
    createCombatContent(scrollFrame)
    createMovementContent(scrollFrame)
    createESPContent(scrollFrame)
    createMiscContent(scrollFrame)

    -- Tab switching
    local tabs = {farmTab, combatTab, movementTab, espTab, miscTab}
    local contents = {farmContent, combatContent, movementContent, espContent, miscContent}
    
    for i, tab in pairs(tabs) do
        tab.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do
                t.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end
            tab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            
            for _, c in pairs(contents) do
                c.Visible = false
            end
            contents[i].Visible = true
        end)
    end
    
    -- Set default tab
    farmTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    farmContent.Visible = true
    combatContent.Visible = false
    movementContent.Visible = false
    espContent.Visible = false
    miscContent.Visible = false

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
end

-- ==================== HELPER FUNCTIONS ====================
function createTabButton(parent, text, position, size)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.BorderSizePixel = 0
    button.Position = position
    button.Size = size
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    return button
end

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
    esp.Parent = plr.Character and plr.Character:FindFirstChild("Head")
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
    
    local head = zombie:FindFirstChild("Head") or zombie:FindFirstChild("HumanoidRootPart")
    if not head then return end
    
    local esp = Instance.new("BillboardGui")
    esp.Name = "ZombieESP"
    esp.Parent = head
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
        if zombie and zombie.Parent and zombie:FindFirstChild("Humanoid") and zombie.Humanoid.Health > 0 and zombie:FindFirstChild("HumanoidRootPart") then
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
    
    -- Cari remote event untuk shooting
    local remote = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("ShootEvent") or tool:FindFirstChild("Fire")
    if not remote then return end
    
    -- Ghost Shoot (tembus tembok)
    if ghostShootEnabled then
        -- Simulate shooting through walls
        local args = {
            [1] = zombie.HumanoidRootPart.Position,
            [2] = zombie.HumanoidRootPart,
            [3] = true -- wallbang flag
        }
        remote:FireServer(unpack(args))
    else
        -- Normal shoot
        local args = {
            [1] = zombie.HumanoidRootPart.Position,
            [2] = zombie.HumanoidRootPart
        }
        remote:FireServer(unpack(args))
    end
end

-- Update zombie list
game:GetService("Workspace").DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Model") and descendant:FindFirstChild("Humanoid") and (descendant.Name:lower():find("zombie") or descendant.Name:lower():find("enemy")) then
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
    if v:IsA("Model") and v:FindFirstChild("Humanoid") and (v.Name:lower():find("zombie") or v.Name:lower():find("enemy")) then
        table.insert(zombies, v)
    end
end

-- ==================== TAB CONTENTS ====================

-- Farm Content
function createFarmContent(parent)
    farmContent = Instance.new("Frame")
    farmContent.Name = "FarmContent"
    farmContent.Parent = parent
    farmContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    farmContent.BackgroundTransparency = 1
    farmContent.Size = UDim2.new(1, 0, 4, 0)
    farmContent.Visible = false

    createLabel(farmContent, "⚙️ FARM SETTINGS", UDim2.new(0, 10, 0, 5), UDim2.new(1, -20, 0, 30))

    createToggle(farmContent, "Auto Farm", UDim2.new(0, 10, 0, 40), function(value)
        autoFarm = value
    end)

    createToggle(farmContent, "Auto Buy", UDim2.new(0, 10, 0, 90), function(value)
        autoBuy = value
    end)

    createToggle(farmContent, "Auto Floor", UDim2.new(0, 10, 0, 140), function(value)
        autoFloor = value
    end)

    createToggle(farmContent, "Auto Spin", UDim2.new(0, 10, 0, 190), function(value)
        autoSpin = value
    end)

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

    createButton(farmContent, "+", UDim2.new(0.5, 5, 0, 275), UDim2.new(0, 50, 0, 40), function()
        selectedFloor = selectedFloor + 1
        floorLabel.Text = "Floor: " .. selectedFloor
    end)

    createButton(farmContent, "-", UDim2.new(0.7, 5, 0, 275), UDim2.new(0, 50, 0, 40), function()
        if selectedFloor > 1 then
            selectedFloor = selectedFloor - 1
            floorLabel.Text = "Floor: " .. selectedFloor
        end
    end)
end

-- Combat Content
function createCombatContent(parent)
    combatContent = Instance.new("Frame")
    combatContent.Name = "CombatContent"
    combatContent.Parent = parent
    combatContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    combatContent.BackgroundTransparency = 1
    combatContent.Size = UDim2.new(1, 0, 4, 0)
    combatContent.Visible = false

    createLabel(combatContent, "⚔️ COMBAT SETTINGS", UDim2.new(0, 10, 0, 5), UDim2.new(1, -20, 0, 30))

    createToggle(combatContent, "Ghost Shoot (Wallbang)", UDim2.new(0, 10, 0, 40), function(value)
        ghostShootEnabled = value
    end)

    createToggle(combatContent, "Auto Shoot", UDim2.new(0, 10, 0, 90), function(value)
        autoShootEnabled = value
    end)

    createToggle(combatContent, "Aimbot", UDim2.new(0, 10, 0, 140), function(value)
        aimbotEnabled = value
    end)

    createToggle(combatContent, "Rapid Fire", UDim2.new(0, 10, 0, 190), function(value)
        rapidFireEnabled = value
    end)

    createToggle(combatContent, "Infinite Ammo", UDim2.new(0, 10, 0, 240), function(value)
        infiniteAmmoEnabled = value
    end)

    createToggle(combatContent, "Damage Multiplier", UDim2.new(0, 10, 0, 290), function(value)
        damageMultiplierEnabled = value
    end)

    createSlider(combatContent, "Damage Amount", UDim2.new(0, 10, 0, 340), 10, 1000, damageAmount, function(value)
        damageAmount = value
    end)
end

-- Movement Content
function createMovementContent(parent)
    movementContent = Instance.new("Frame")
    movementContent.Name = "MovementContent"
    movementContent.Parent = parent
    movementContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    movementContent.BackgroundTransparency = 1
    movementContent.Size = UDim2.new(1, 0, 4, 0)
    movementContent.Visible = false

    createLabel(movementContent, "🏃 MOVEMENT SETTINGS", UDim2.new(0, 10, 0, 5), UDim2.new(1, -20, 0, 30))

    createToggle(movementContent, "Fly", UDim2.new(0, 10, 0, 40), function(value)
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

    createToggle(movementContent, "Infinite Jump", UDim2.new(0, 10, 0, 90), function(value)
        infiniteJump = value
        if infiniteJump then
            infiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if infiniteJump then
                    humanoid:ChangeState("Jumping")
                end
            end)
        else
            if infiniteJumpConnection then
                infiniteJumpConnection:Disconnect()
            end
        end
    end)

    createToggle(movementContent, "Speed", UDim2.new(0, 10, 0, 140), function(value)
        speedEnabled = value
        if speedEnabled then
            humanoid.WalkSpeed = speedAmount
        else
            humanoid.WalkSpeed = 16
        end
    end)

    createSlider(movementContent, "Speed Value", UDim2.new(0, 10, 0, 190), 16, 200, speedAmount, function(value)
        speedAmount = value
        if speedEnabled then
            humanoid.WalkSpeed = value
        end
    end)

    createToggle(movementContent, "Jump Power", UDim2.new(0, 10, 0, 260), function(value)
        jumpPowerEnabled = value
        if jumpPowerEnabled then
            humanoid.JumpPower = jumpPowerAmount
        else
            humanoid.JumpPower = 50
        end
    end)

    createSlider(movementContent, "Jump Value", UDim2.new(0, 10, 0, 310), 50, 500, jumpPowerAmount, function(value)
        jumpPowerAmount = value
        if jumpPowerEnabled then
            humanoid.JumpPower = value
        end
    end)
end

-- ESP Content
function createESPContent(parent)
    espContent = Instance.new("Frame")
    espContent.Name = "ESPContent"
    espContent.Parent = parent
    espContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    espContent.BackgroundTransparency = 1
    espContent.Size = UDim2.new(1, 0, 4, 0)
    espContent.Visible = false

    createLabel(espContent, "👁️ ESP SETTINGS", UDim2.new(0, 10, 0, 5), UDim2.new(1, -20, 0, 30))

    createToggle(espContent, "ESP Target (Player)", UDim2.new(0, 10, 0, 40), function(value)
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

    createToggle(espContent, "ESP Zombie", UDim2.new(0, 10, 0, 90), function(value)
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
end

-- Misc Content
function createMiscContent(parent)
    miscContent = Instance.new("Frame")
    miscContent.Name = "MiscContent"
    miscContent.Parent = parent
    miscContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    miscContent.BackgroundTransparency = 1
    miscContent.Size = UDim2.new(1, 0, 4, 0)
    miscContent.Visible = false

    createLabel(miscContent, "⚙️ MISC SETTINGS", UDim2.new(0, 10, 0, 5), UDim2.new(1, -20, 0, 30))

    createToggle(miscContent, "Anti AFK", UDim2.new(0, 10, 0, 40), function(value)
        if value then
            local vu = game:GetService("VirtualUser")
            player.Idled:Connect(function()
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end
    end)

    createToggle(miscContent, "No Fog", UDim2.new(0, 10, 0, 90), function(value)
        if value then
            game:GetService("Lighting").FogEnd = 1e9
        else
            game:GetService("Lighting").FogEnd = 1000
        end
    end)

    createToggle(miscContent, "Full Bright", UDim2.new(0, 10, 0, 140), function(value)
        if value then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
        else
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").Ambient = Color3.fromRGB(0, 0, 0)
        end
    end)
end

-- ==================== BUTTON CLICK HANDLER ====================
buttonFrame.MouseButton1Click:Connect(function()
    if guiOpen then
        if mainGui then
            mainGui:Destroy()
            mainGui = nil
        end
        guiOpen = false
    else
        createMainGUI()
        guiOpen = true
    end
end)

-- ==================== AUTO FARM LOOP ====================
spawn(function()
    while true do
        wait(0.1)
        
        if autoFarm then
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
            local shop = player.PlayerGui:FindFirstChild("Shop")
            if shop and shop.Enabled then
                local buyButton = shop:FindFirstChild("BuyButton")
                if buyButton then
                    buyButton:Fire()
                end
            end
        end
        
        if autoFloor then
            local floorGui = player.PlayerGui:FindFirstChild("FloorGUI")
            if floorGui then
                local floorButton = floorGui:FindFirstChild("Floor" .. selectedFloor)
                if floorButton then
                    floorButton:Fire()
                end
            end
        end
        
        if autoSpin then
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
        wait(0.05)
        
        if autoShootEnabled or aimbotEnabled then
            local nearestZombie, distance = findNearestZombie()
            
            if nearestZombie then
                targetZombie = nearestZombie
                
                if aimbotEnabled then
                    local camera = workspace.CurrentCamera
                    local zombiePos = nearestZombie.HumanoidRootPart.Position
                    camera.CFrame = CFrame.new(camera.CFrame.Position, zombiePos)
                end
                
                if autoShootEnabled then
                    shootZombie(nearestZombie)
                end
            end
        end
        
        if rapidFireEnabled then
            local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Cooldown") then
                tool.Cooldown.Value = 0
            end
        end
        
        if infiniteAmmoEnabled then
            local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Ammo") then
                tool.Ammo.Value = 9999
            end
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
watermarkText.Text = "DEATH RAILS ULTIMATE | JUNZXSEC"
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

notify("DEATH RAILS ULTIMATE LOADED! Klik tombol merah ⚡ untuk membuka GUI")

-- ==================== CREDITS ====================
print([[
============================================
DEATH RAILS ULTIMATE - FIXED VERSION
CREATED BY JUNZXSEC
TELEGRAM: @xRay404x

FITUR:
✅ Button Minimize (⚡) - Klik untuk buka/tutup
✅ Floating GUI - Bisa digerakin
✅ ESP Target + Zombie
✅ Ghost Shoot (Wallbang)
✅ Auto Shoot + Aimbot
✅ Rapid Fire + Infinite Ammo
✅ Damage Multiplier
✅ Auto Farm + Auto Buy
✅ Fly + Speed + Jump Power
============================================
]])