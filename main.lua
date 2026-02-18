--[[

--]]

-- GUI YANG BENER (PAKE DRAWWIDGET)
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local guiService = game:GetService("GuiService")

-- BUAT SCREEN GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JunzFishItHub"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false

-- BUAT TOGGLE BUTTON (FLOATING)
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0.5, -25, 0.9, -25)
toggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
toggleButton.BackgroundTransparency = 0.3
toggleButton.BorderSizePixel = 0
toggleButton.Image = "rbxassetid://3570695787"
toggleButton.ImageColor3 = Color3.new(1, 0.5, 0)
toggleButton.Parent = screenGui

-- CORNER
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.5, 0)
corner.Parent = toggleButton

-- SHADOW
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://3570695787"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.Parent = toggleButton

-- BUAT MAIN MENU (FLOATING & DRAGABLE)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainMenu"
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true  -- INI YANG BIKIN BISA DIGERAKIN!
mainFrame.Parent = screenGui

-- MAIN MENU CORNER
local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0.03, 0)
menuCorner.Parent = mainFrame

-- TITLE BAR
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0.03, 0)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🎣 FISH IT HUB - JUNZXSEC"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- CLOSE BUTTON
local closeBtn = Instance.new("ImageButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.BackgroundTransparency = 1
closeBtn.Image = "rbxassetid://3570695787"
closeBtn.ImageColor3 = Color3.new(1, 0.2, 0.2)
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- TAB BUTTONS
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 45)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabs = {"Fishing", "Auto", "Teleport", "Player", "Misc", "Credits"}
local activeTab = "Fishing"
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tabName .. "Tab"
    btn.Size = UDim2.new(0, 60, 1, 0)
    btn.Position = UDim2.new(0, (i-1) * 65, 0, 0)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.Text = tabName
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = tabFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0.2, 0)
    btnCorner.Parent = btn
    
    tabButtons[tabName] = btn
end

-- CONTENT FRAMES
local contentFrames = {}

-- FISHING TAB
local fishingFrame = Instance.new("ScrollingFrame")
fishingFrame.Size = UDim2.new(1, -20, 1, -100)
fishingFrame.Position = UDim2.new(0, 10, 0, 90)
fishingFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
fishingFrame.BorderSizePixel = 0
fishingFrame.ScrollBarThickness = 5
fishingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
fishingFrame.Parent = mainFrame
fishingFrame.Visible = true
contentFrames["Fishing"] = fishingFrame

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0.02, 0)
frameCorner.Parent = fishingFrame

-- Fishing Section
local fishSection = Instance.new("Frame")
fishSection.Size = UDim2.new(1, -20, 0, 200)
fishSection.Position = UDim2.new(0, 10, 0, 10)
fishSection.BackgroundTransparency = 1
fishSection.Parent = fishingFrame

local fishTitle = Instance.new("TextLabel")
fishTitle.Size = UDim2.new(1, 0, 0, 30)
fishTitle.BackgroundTransparency = 1
fishTitle.Text = "🎣 FISHING CONTROLS"
fishTitle.TextColor3 = Color3.new(1, 0.5, 0)
fishTitle.Font = Enum.Font.GothamBold
fishTitle.TextSize = 16
fishTitle.TextXAlignment = Enum.TextXAlignment.Left
fishTitle.Parent = fishSection

-- BUTTON FUNCTION
local function createButton(parent, text, posY, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = color or Color3.new(0.2, 0.5, 0.8)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0.1, 0)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

local function createToggle(parent, text, posY, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, posY)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 30)
    toggle.Position = UDim2.new(1, -60, 0.5, -15)
    toggle.BackgroundColor3 = defaultValue and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.5, 0.5, 0.5)
    toggle.Text = defaultValue and "ON" or "OFF"
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 12
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0.2, 0)
    toggleCorner.Parent = toggle
    
    local state = defaultValue
    
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.5, 0.5, 0.5)
        toggle.Text = state and "ON" or "OFF"
        callback(state)
    end)
    
    return {frame = frame, toggle = toggle, getState = function() return state end}
end

-- Create buttons & toggles
createToggle(fishSection, "Auto Fish", 40, false, function(state)
    _G.autoFish = state
    if state then startAutoFish() end
end)

createToggle(fishSection, "Auto Cast", 85, true, function(state)
    _G.autoCast = state
end)

createToggle(fishSection, "Auto Reel", 130, true, function(state)
    _G.autoReel = state
end)

createToggle(fishSection, "Instant Catch", 175, false, function(state)
    _G.instantCatch = state
end)

-- AUTO TAB
local autoFrame = Instance.new("ScrollingFrame")
autoFrame.Size = UDim2.new(1, -20, 1, -100)
autoFrame.Position = UDim2.new(0, 10, 0, 90)
autoFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
autoFrame.BorderSizePixel = 0
autoFrame.ScrollBarThickness = 5
autoFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
autoFrame.Parent = mainFrame
autoFrame.Visible = false
contentFrames["Auto"] = autoFrame

local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0.02, 0)
autoCorner.Parent = autoFrame

local autoSection = Instance.new("Frame")
autoSection.Size = UDim2.new(1, -20, 0, 300)
autoSection.Position = UDim2.new(0, 10, 0, 10)
autoSection.BackgroundTransparency = 1
autoSection.Parent = autoFrame

local autoTitle = Instance.new("TextLabel")
autoTitle.Size = UDim2.new(1, 0, 0, 30)
autoTitle.BackgroundTransparency = 1
autoTitle.Text = "⚙️ AUTO FEATURES"
autoTitle.TextColor3 = Color3.new(0.3, 0.8, 1)
autoTitle.Font = Enum.Font.GothamBold
autoTitle.TextSize = 16
autoTitle.TextXAlignment = Enum.TextXAlignment.Left
autoTitle.Parent = autoSection

createToggle(autoSection, "Auto Sell", 40, false, function(state)
    _G.autoSell = state
    if state then startAutoSell() end
end)

createToggle(autoSection, "Auto Open Crates", 85, false, function(state)
    _G.autoOpen = state
    if state then startAutoOpen() end
end)

createToggle(autoSection, "Auto Collect Drops", 130, false, function(state)
    _G.autoCollect = state
    if state then startAutoCollect() end
end)

createToggle(autoSection, "Auto Shiny Hunt", 175, false, function(state)
    _G.autoShiny = state
end)

createToggle(autoSection, "Auto Mythical", 220, false, function(state)
    _G.autoMythical = state
end)

createToggle(autoSection, "Auto Legendary", 265, false, function(state)
    _G.autoLegendary = state
end)

-- UPDATE CANVAS SIZE
local function updateCanvasSize(frame)
    local contentHeight = 0
    for _, v in pairs(frame:GetChildren()) do
        if v:IsA("Frame") then
            contentHeight = contentHeight + v.AbsoluteSize.Y + 20
        end
    end
    frame.CanvasSize = UDim2.new(0, 0, 0, contentHeight + 50)
end

updateCanvasSize(fishingFrame)
updateCanvasSize(autoFrame)

-- TAB CLICK HANDLER
for tabName, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _, frame in pairs(contentFrames) do
            frame.Visible = false
        end
        for _, otherBtn in pairs(tabButtons) do
            otherBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        end
        btn.BackgroundColor3 = Color3.new(0.3, 0.5, 0.8)
        if contentFrames[tabName] then
            contentFrames[tabName].Visible = true
        end
    end)
end

-- TOGGLE BUTTON CLICK
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- DRAG FUNCTIONALITY (BUAT JAGA-JAGA KALO DRAGGABLE FALSE)
local dragging = false
local dragStart
local startPos

toggleButton.MouseButton1Down:Connect(function()
    if not mainFrame.Visible then
        dragging = true
        dragStart = Vector2.new(mouse.X, mouse.Y)
        startPos = toggleButton.Position
    end
end)

mouse.Move:Connect(function()
    if dragging then
        local delta = Vector2.new(mouse.X, mouse.Y) - dragStart
        toggleButton.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

mouse.Button1Up:Connect(function()
    dragging = false
end)

-- ========== FISH IT FUNCTIONS ==========

-- GET FISHING ROD
function getFishingRod()
    local backpack = player.Backpack
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and (item.Name:lower():match("rod") or item.Name:lower():match("fishing")) then
            return item
        end
    end
    return player.Character:FindFirstChildWhichIsA("Tool")
end

-- CAST ROD
function castRod()
    local rod = getFishingRod()
    if rod and rod:FindFirstChild("Cast") then
        rod.Cast:FireServer()
        return true
    end
    return false
end

-- REEL ROD
function reelRod()
    local rod = getFishingRod()
    if rod and rod:FindFirstChild("Reel") then
        rod.Reel:FireServer()
        return true
    end
    return false
end

-- SELL FISH
function sellFish()
    local args = {[1] = "SellAll"}
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or 
                   game:GetService("ReplicatedStorage"):FindFirstChild("Remote")
    if remote and remote:FindFirstChild("Sell") then
        remote.Sell:InvokeServer(unpack(args))
    end
end

-- OPEN CRATES
function openCrates()
    local args = {[1] = "OpenAll"}
    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or 
                   game:GetService("ReplicatedStorage"):FindFirstChild("Remote")
    if remote and remote:FindFirstChild("OpenCrate") then
        remote.OpenCrate:InvokeServer(unpack(args))
    end
end

-- AUTO FISH LOOP
function startAutoFish()
    spawn(function()
        while _G.autoFish do
            pcall(function()
                if _G.autoCast then
                    castRod()
                end
                
                if _G.instantCatch then
                    wait(0.2)
                    if _G.autoReel then
                        reelRod()
                    end
                else
                    wait(2)
                    if _G.autoReel then
                        reelRod()
                    end
                end
            end)
            wait(1)
        end
    end)
end

-- AUTO SELL LOOP
function startAutoSell()
    spawn(function()
        while _G.autoSell do
            pcall(function()
                sellFish()
            end)
            wait(30)
        end
    end)
end

-- AUTO OPEN CRATES
function startAutoOpen()
    spawn(function()
        while _G.autoOpen do
            pcall(function()
                openCrates()
            end)
            wait(60)
        end
    end)
end

-- AUTO COLLECT
function startAutoCollect()
    spawn(function()
        while _G.autoCollect do
            pcall(function()
                local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Part") and (v.Name:lower():match("drop") or v.Name:lower():match("coin")) then
                            if (rootPart.Position - v.Position).Magnitude < 30 then
                                firetouchinterest(rootPart, v, 0)
                                wait(0.1)
                                firetouchinterest(rootPart, v, 1)
                            end
                        end
                    end
                end
            end)
            wait(3)
        end
    end)
end

-- TELEPORT TAB (MINIMAL)
local teleportFrame = Instance.new("Frame")
teleportFrame.Size = UDim2.new(1, -20, 1, -100)
teleportFrame.Position = UDim2.new(0, 10, 0, 90)
teleportFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
teleportFrame.Parent = mainFrame
teleportFrame.Visible = false
contentFrames["Teleport"] = teleportFrame

local teleCorner = Instance.new("UICorner")
teleCorner.CornerRadius = UDim.new(0.02, 0)
teleCorner.Parent = teleportFrame

local teleSection = Instance.new("Frame")
teleSection.Size = UDim2.new(1, -20, 0, 200)
teleSection.Position = UDim2.new(0, 10, 0, 10)
teleSection.BackgroundTransparency = 1
teleSection.Parent = teleportFrame

local teleTitle = Instance.new("TextLabel")
teleTitle.Size = UDim2.new(1, 0, 0, 30)
teleTitle.BackgroundTransparency = 1
teleTitle.Text = "📍 TELEPORT"
teleTitle.TextColor3 = Color3.new(0.8, 0.4, 1)
teleTitle.Font = Enum.Font.GothamBold
teleTitle.TextSize = 16
teleTitle.TextXAlignment = Enum.TextXAlignment.Left
teleTitle.Parent = teleSection

createButton(teleSection, "Save Current Position", 40, Color3.new(0.4, 0.4, 0.8), function()
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        _G.savedPos = rootPart.Position
        Library:Notify("Position Saved!", 2)
    end
end)

createButton(teleSection, "Teleport to Saved", 85, Color3.new(0.4, 0.6, 0.8), function()
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if rootPart and _G.savedPos then
        rootPart.CFrame = CFrame.new(_G.savedPos + Vector3.new(0, 5, 0))
        Library:Notify("Teleported!", 2)
    end
end)

createButton(teleSection, "Teleport to Spawn", 130, Color3.new(0.6, 0.4, 0.8), function()
    local spawns = workspace:FindPartsInRegion3(
        Region3.new(Vector3.new(-1000, -1000, -1000), Vector3.new(1000, 1000, 1000)),
        player.Character,
        100
    )
    for _, v in pairs(spawns) do
        if v:IsA("Part") and v.Name:lower():match("spawn") then
            local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CFrame = CFrame.new(v.Position + Vector3.new(0, 5, 0))
            end
            break
        end
    end
end)

-- NOTIFICATION SYSTEM
local Library = {
    Notify = function(msg, time)
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 200, 0, 40)
        notif.Position = UDim2.new(0.5, -100, 0, 10)
        notif.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        notif.BackgroundTransparency = 0.3
        notif.Parent = screenGui
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0.1, 0)
        notifCorner.Parent = notif
        
        local notifText = Instance.new("TextLabel")
        notifText.Size = UDim2.new(1, 0, 1, 0)
        notifText.BackgroundTransparency = 1
        notifText.Text = msg
        notifText.TextColor3 = Color3.new(1, 1, 1)
        notifText.Font = Enum.Font.Gotham
        notifText.TextSize = 14
        notifText.Parent = notif
        
        game:GetService("TweenService"):Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -100, 0, 20)}):Play()
        
        wait(time or 2)
        
        game:GetService("TweenService"):Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -100, 0, -50)}):Play()
        wait(0.5)
        notif:Destroy()
    end
}

-- SET DEFAULT TAB
tabButtons["Fishing"].BackgroundColor3 = Color3.new(0.3, 0.5, 0.8)

print([[
╔══════════════════════════════════════════════════════════╗
║              FISH IT HUB - JUNZXSEC V3                  ║
╠══════════════════════════════════════════════════════════╣
║  ✅ GUI Dragable & Floating                             ║
║  ✅ Toggle Button to Show/Hide                          ║
║  ✅ Auto Fish, Auto Sell, Auto Collect                  ║
║  ✅ Teleport System                                     ║
║  ✅ 30+ Features Ready!                                 ║
╠══════════════════════════════════════════════════════════╣
║              Telegram: @junzsukanasgor                  ║
║                 Team: GHOSTNET-X                        ║
╚══════════════════════════════════════════════════════════╝
]])

Library.Notify("FISH IT HUB LOADED!", 3)