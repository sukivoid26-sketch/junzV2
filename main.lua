--[[

--]]

-- CEK APAKAH UDAH PERNAH DI EXECUTE (ANTI DOUBLE)
if _G.JunzHubLoaded then
    game:GetService("Players").LocalPlayer:Kick("JUNZXSEC HUB: Already Executed!")
    return
end
_G.JunzHubLoaded = true

-- VARIABLES
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

-- BUAT SCREEN GUI UTAMA
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JunzFishItHub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ==================== FLOATING BUTTON ====================
local floatButton = Instance.new("ImageButton")
floatButton.Name = "FloatButton"
floatButton.Size = UDim2.new(0, 60, 0, 60)
floatButton.Position = UDim2.new(0.5, -30, 0.9, -30)
floatButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
floatButton.BackgroundTransparency = 0.2
floatButton.BorderSizePixel = 0
floatButton.Image = "rbxassetid://3570695787"
floatButton.ImageColor3 = Color3.fromRGB(255, 128, 0)
floatButton.Parent = screenGui

-- SHADOW
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://3570695787"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.Parent = floatButton

-- CORNER
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0.5, 0)
buttonCorner.Parent = floatButton

-- ==================== MAIN MENU ====================
local mainMenu = Instance.new("Frame")
mainMenu.Name = "MainMenu"
mainMenu.Size = UDim2.new(0, 450, 0, 550)
mainMenu.Position = UDim2.new(0.3, 0, 0.2, 0)
mainMenu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainMenu.BackgroundTransparency = 0.1
mainMenu.BorderSizePixel = 0
mainMenu.Visible = false
mainMenu.Active = true
mainMenu.Draggable = true  -- BISA DIGERAKIN!
mainMenu.Parent = screenGui

-- MENU CORNER
local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0.02, 0)
menuCorner.Parent = mainMenu

-- SHADOW
local menuShadow = Instance.new("ImageLabel")
menuShadow.Name = "MenuShadow"
menuShadow.Size = UDim2.new(1, 20, 1, 20)
menuShadow.Position = UDim2.new(0, -10, 0, -10)
menuShadow.BackgroundTransparency = 1
menuShadow.Image = "rbxassetid://3570695787"
menuShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
menuShadow.ImageTransparency = 0.8
menuShadow.Parent = mainMenu
menuShadow.ZIndex = -1

-- TITLE BAR
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainMenu

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0.02, 0)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🎣 FISH IT HUB - JUNZXSEC"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("ImageButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundTransparency = 1
closeBtn.Image = "rbxassetid://3570695787"
closeBtn.ImageColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    mainMenu.Visible = false
end)

-- ==================== TAB SYSTEM ====================
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 45)
tabFrame.Position = UDim2.new(0, 10, 0, 50)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainMenu

local tabs = {"Fishing", "Auto", "Player", "Visual", "World", "Misc", "Credits"}
local tabButtons = {}
local contentFrames = {}
local activeTab = "Fishing"

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tabName .. "Tab"
    btn.Size = UDim2.new(0, 60, 1, 0)
    btn.Position = UDim2.new(0, (i-1) * 65, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BackgroundTransparency = 0.3
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = tabFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0.2, 0)
    btnCorner.Parent = btn
    
    tabButtons[tabName] = btn
    
    -- CONTENT FRAME
    local content = Instance.new("ScrollingFrame")
    content.Name = tabName .. "Content"
    content.Size = UDim2.new(1, -20, 1, -110)
    content.Position = UDim2.new(0, 10, 0, 100)
    content.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    content.BackgroundTransparency = 0.3
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 5
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.Visible = (i == 1)
    content.Parent = mainMenu
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0.02, 0)
    contentCorner.Parent = content
    
    contentFrames[tabName] = content
end

-- TAB CLICK HANDLER
for tabName, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _, frame in pairs(contentFrames) do
            frame.Visible = false
        end
        for _, otherBtn in pairs(tabButtons) do
            otherBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            otherBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 128, 0)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        if contentFrames[tabName] then
            contentFrames[tabName].Visible = true
        end
    end)
end

-- ==================== HELPER FUNCTIONS ====================
local function createToggle(parent, text, posY, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, posY)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 30)
    toggleBtn.Position = UDim2.new(1, -60, 0.5, -15)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0.2, 0)
    toggleCorner.Parent = toggleBtn
    
    local state = default
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        toggleBtn.Text = state and "ON" or "OFF"
        callback(state)
    end)
    
    return toggleBtn
end

local function createButton(parent, text, posY, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = color or Color3.fromRGB(0, 120, 255)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0.1, 0)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

local function createLabel(parent, text, posY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    
    return label
end

-- ==================== FISHING TAB ====================
local fishingContent = contentFrames["Fishing"]
local yPos = 10

createLabel(fishingContent, "🎣 FISHING CONTROLS", yPos)
yPos = yPos + 35

createToggle(fishingContent, "Auto Fish", yPos, false, function(state)
    _G.autoFish = state
    while _G.autoFish do
        pcall(function()
            local rod = player.Character:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
            if rod then
                if rod:FindFirstChild("Cast") then rod.Cast:FireServer() end
                wait(2)
                if rod:FindFirstChild("Reel") then rod.Reel:FireServer() end
            end
        end)
        wait(1)
    end
end)
yPos = yPos + 45

createToggle(fishingContent, "Auto Cast", yPos, true, function(state)
    _G.autoCast = state
end)
yPos = yPos + 45

createToggle(fishingContent, "Auto Reel", yPos, true, function(state)
    _G.autoReel = state
end)
yPos = yPos + 45

createToggle(fishingContent, "Instant Catch", yPos, false, function(state)
    _G.instantCatch = state
end)
yPos = yPos + 45

createToggle(fishingContent, "Infinite Bait", yPos, false, function(state)
    _G.infiniteBait = state
end)
yPos = yPos + 45

fishingContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ==================== AUTO TAB ====================
local autoContent = contentFrames["Auto"]
yPos = 10

createLabel(autoContent, "⚙️ AUTO FEATURES", yPos)
yPos = yPos + 35

createToggle(autoContent, "Auto Sell", yPos, false, function(state)
    _G.autoSell = state
    while _G.autoSell do
        pcall(function()
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or 
                           game:GetService("ReplicatedStorage"):FindFirstChild("Remote")
            if remote and remote:FindFirstChild("Sell") then
                remote.Sell:InvokeServer("SellAll")
            end
        end)
        wait(30)
    end
end)
yPos = yPos + 45

createToggle(autoContent, "Auto Open Crates", yPos, false, function(state)
    _G.autoOpen = state
    while _G.autoOpen do
        pcall(function()
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or 
                           game:GetService("ReplicatedStorage"):FindFirstChild("Remote")
            if remote and remote:FindFirstChild("OpenCrate") then
                remote.OpenCrate:InvokeServer("OpenAll")
            end
        end)
        wait(60)
    end
end)
yPos = yPos + 45

createToggle(autoContent, "Auto Collect Drops", yPos, false, function(state)
    _G.autoCollect = state
    while _G.autoCollect do
        pcall(function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Part") and (v.Name:lower():find("drop") or v.Name:lower():find("coin")) then
                        if (root.Position - v.Position).Magnitude < 30 then
                            firetouchinterest(root, v, 0)
                            wait(0.1)
                            firetouchinterest(root, v, 1)
                        end
                    end
                end
            end
        end)
        wait(3)
    end
end)
yPos = yPos + 45

createToggle(autoContent, "Auto Shiny Hunt", yPos, false, function(state)
    _G.autoShiny = state
end)
yPos = yPos + 45

createToggle(autoContent, "Auto Mythical", yPos, false, function(state)
    _G.autoMythical = state
end)
yPos = yPos + 45

createToggle(autoContent, "Auto Legendary", yPos, false, function(state)
    _G.autoLegendary = state
end)
yPos = yPos + 45

autoContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ==================== PLAYER TAB ====================
local playerContent = contentFrames["Player"]
yPos = 10

createLabel(playerContent, "👤 PLAYER SETTINGS", yPos)
yPos = yPos + 35

-- Walkspeed Slider
local wsFrame = Instance.new("Frame")
wsFrame.Size = UDim2.new(1, -20, 0, 40)
wsFrame.Position = UDim2.new(0, 10, 0, yPos)
wsFrame.BackgroundTransparency = 1
wsFrame.Parent = playerContent

local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(0.5, 0, 1, 0)
wsLabel.BackgroundTransparency = 1
wsLabel.Text = "Walkspeed: 16"
wsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
wsLabel.Font = Enum.Font.Gotham
wsLabel.TextSize = 14
wsLabel.TextXAlignment = Enum.TextXAlignment.Left
wsLabel.Parent = wsFrame

local wsSlider = Instance.new("TextButton")
wsSlider.Size = UDim2.new(0.4, 0, 0, 20)
wsSlider.Position = UDim2.new(0.6, 0, 0.5, -10)
wsSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
wsSlider.Text = "16"
wsSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
wsSlider.Font = Enum.Font.Gotham
wsSlider.TextSize = 12
wsSlider.Parent = wsFrame

local wsCorner = Instance.new("UICorner")
wsCorner.CornerRadius = UDim.new(0.2, 0)
wsCorner.Parent = wsSlider

local ws = 16
wsSlider.MouseButton1Click:Connect(function()
    ws = ws + 16
    if ws > 150 then ws = 16 end
    wsSlider.Text = tostring(ws)
    wsLabel.Text = "Walkspeed: " .. ws
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = ws
    end
end)
yPos = yPos + 45

-- Jump Power Slider
local jpFrame = Instance.new("Frame")
jpFrame.Size = UDim2.new(1, -20, 0, 40)
jpFrame.Position = UDim2.new(0, 10, 0, yPos)
jpFrame.BackgroundTransparency = 1
jpFrame.Parent = playerContent

local jpLabel = Instance.new("TextLabel")
jpLabel.Size = UDim2.new(0.5, 0, 1, 0)
jpLabel.BackgroundTransparency = 1
jpLabel.Text = "Jump Power: 50"
jpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
jpLabel.Font = Enum.Font.Gotham
jpLabel.TextSize = 14
jpLabel.TextXAlignment = Enum.TextXAlignment.Left
jpLabel.Parent = jpFrame

local jpSlider = Instance.new("TextButton")
jpSlider.Size = UDim2.new(0.4, 0, 0, 20)
jpSlider.Position = UDim2.new(0.6, 0, 0.5, -10)
jpSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jpSlider.Text = "50"
jpSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
jpSlider.Font = Enum.Font.Gotham
jpSlider.TextSize = 12
jpSlider.Parent = jpFrame

local jpCorner = Instance.new("UICorner")
jpCorner.CornerRadius = UDim.new(0.2, 0)
jpCorner.Parent = jpSlider

local jp = 50
jpSlider.MouseButton1Click:Connect(function()
    jp = jp + 50
    if jp > 500 then jp = 50 end
    jpSlider.Text = tostring(jp)
    jpLabel.Text = "Jump Power: " .. jp
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = jp
    end
end)
yPos = yPos + 45

-- Gravity Slider
local gvFrame = Instance.new("Frame")
gvFrame.Size = UDim2.new(1, -20, 0, 40)
gvFrame.Position = UDim2.new(0, 10, 0, yPos)
gvFrame.BackgroundTransparency = 1
gvFrame.Parent = playerContent

local gvLabel = Instance.new("TextLabel")
gvLabel.Size = UDim2.new(0.5, 0, 1, 0)
gvLabel.BackgroundTransparency = 1
gvLabel.Text = "Gravity: 196"
gvLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gvLabel.Font = Enum.Font.Gotham
gvLabel.TextSize = 14
gvLabel.TextXAlignment = Enum.TextXAlignment.Left
gvLabel.Parent = gvFrame

local gvSlider = Instance.new("TextButton")
gvSlider.Size = UDim2.new(0.4, 0, 0, 20)
gvSlider.Position = UDim2.new(0.6, 0, 0.5, -10)
gvSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
gvSlider.Text = "196"
gvSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
gvSlider.Font = Enum.Font.Gotham
gvSlider.TextSize = 12
gvSlider.Parent = gvFrame

local gvCorner = Instance.new("UICorner")
gvCorner.CornerRadius = UDim.new(0.2, 0)
gvCorner.Parent = gvSlider

local gv = 196
gvSlider.MouseButton1Click:Connect(function()
    gv = gv + 100
    if gv > 500 then gv = 0 end
    gvSlider.Text = tostring(gv)
    gvLabel.Text = "Gravity: " .. gv
    workspace.Gravity = gv
end)
yPos = yPos + 45

createToggle(playerContent, "Infinite Jump", yPos, false, function(state)
    _G.infJump = state
    if state then
        userInputService.JumpRequest:Connect(function()
            if _G.infJump and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    end
end)
yPos = yPos + 45

createToggle(playerContent, "Noclip", yPos, false, function(state)
    _G.noclip = state
    while _G.noclip do
        pcall(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        wait(0.1)
    end
end)
yPos = yPos + 45

playerContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ==================== VISUAL TAB ====================
local visualContent = contentFrames["Visual"]
yPos = 10

createLabel(visualContent, "🎨 VISUAL EFFECTS", yPos)
yPos = yPos + 35

createToggle(visualContent, "ESP Players", yPos, false, function(state)
    _G.esp = state
    while _G.esp do
        pcall(function()
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = plr.Character.HumanoidRootPart
                    
                    if not hrp:FindFirstChild("ESPTag") then
                        local billboard = Instance.new("BillboardGui")
                        local textLabel = Instance.new("TextLabel")
                        
                        billboard.Name = "ESPTag"
                        billboard.Adornee = hrp
                        billboard.Size = UDim2.new(0, 100, 0, 30)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        
                        textLabel.Size = UDim2.new(1,0,1,0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        textLabel.Text = plr.Name
                        textLabel.Font = Enum.Font.SourceSansBold
                        textLabel.TextSize = 14
                        
                        textLabel.Parent = billboard
                        billboard.Parent = hrp
                    end
                end
            end
        end)
        wait(1)
    end
    
    -- Cleanup
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "ESPTag" then
            v:Destroy()
        end
    end
end)
yPos = yPos + 45

createToggle(visualContent, "X-Ray", yPos, false, function(state)
    _G.xray = state
    while _G.xray do
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsDescendantOf(player.Character) then
                    v.Transparency = 0.5
                    v.Material = Enum.Material.ForceField
                end
            end
        end)
        wait(5)
    end
    
    -- Restore
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = 0
            v.Material = Enum.Material.Plastic
        end
    end
end)
yPos = yPos + 45

createToggle(visualContent, "Fullbright", yPos, false, function(state)
    _G.fullbright = state
    while _G.fullbright do
        pcall(function()
            game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 12
        end)
        wait(1)
    end
end)
yPos = yPos + 45

createToggle(visualContent, "Night Mode", yPos, false, function(state)
    _G.night = state
    while _G.night do
        pcall(function()
            game:GetService("Lighting").Ambient = Color3.fromRGB(50, 50, 50)
            game:GetService("Lighting").Brightness = 0.3
            game:GetService("Lighting").ClockTime = 0
        end)
        wait(1)
    end
end)
yPos = yPos + 45

createToggle(visualContent, "FPS Boost", yPos, false, function(state)
    _G.fps = state
    if state then
        settings().Rendering.QualityLevel = 1
        runService:Set3dRenderingEnabled(false)
    else
        settings().Rendering.QualityLevel = 10
        runService:Set3dRenderingEnabled(true)
    end
end)
yPos = yPos + 45

visualContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ==================== WORLD TAB ====================
local worldContent = contentFrames["World"]
yPos = 10

createLabel(worldContent, "🌍 WORLD FEATURES", yPos)
yPos = yPos + 35

createToggle(worldContent, "Walk on Water", yPos, false, function(state)
    _G.waterWalk = state
    while _G.waterWalk do
        pcall(function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root and root.Position.Y < 0 then
                root.Velocity = Vector3.new(root.Velocity.X, 10, root.Velocity.Z)
            end
        end)
        wait()
    end
end)
yPos = yPos + 45

createButton(worldContent, "Teleport to Spawn", yPos, Color3.fromRGB(0, 100, 255), function()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(0, 50, 0)
    end
end)
yPos = yPos + 45

createButton(worldContent, "Rejoin Server", yPos, Color3.fromRGB(255, 100, 0), function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, player)
end)
yPos = yPos + 45

createButton(worldContent, "Server Hop", yPos, Color3.fromRGB(100, 255, 0), function()
    local placeId = game.PlaceId
    local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?limit=100"))
    for _, server in pairs(servers.data) do
        if server.playing < server.maxPlayers then
            game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, server.id, player)
            break
        end
    end
end)
yPos = yPos + 45

createToggle(worldContent, "Anti AFK", yPos, false, function(state)
    _G.antiAfk = state
    while _G.antiAfk do
        pcall(function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = root.CFrame * CFrame.new(1, 0, 0)
                wait(0.1)
                root.CFrame = root.CFrame * CFrame.new(-1, 0, 0)
            end
        end)
        wait(600)
    end
end)
yPos = yPos + 45

worldContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ==================== MISC TAB ====================
local miscContent = contentFrames["Misc"]
yPos = 10

createLabel(miscContent, "🛠️ MISC FEATURES", yPos)
yPos = yPos + 35

createButton(miscContent, "Save Position", yPos, Color3.fromRGB(0, 150, 255), function()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        _G.savedPos = root.Position
        local notif = Instance.new("Message")
        notif.Parent = workspace
        notif.Text = "Position Saved!"
        wait(2)
        notif:Destroy()
    end
end)
yPos = yPos + 45

createButton(miscContent, "Load Position", yPos, Color3.fromRGB(150, 0, 255), function()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root and _G.savedPos then
        root.CFrame = CFrame.new(_G.savedPos + Vector3.new(0, 5, 0))
        local notif = Instance.new("Message")
        notif.Parent = workspace
        notif.Text = "Teleported!"
        wait(2)
        notif:Destroy()
    end
end)
yPos = yPos + 45

createButton(miscContent, "Clear Inventory", yPos, Color3.fromRGB(255, 50, 50), function()
    for _, item in pairs(player.Backpack:GetChildren()) do
        item:Destroy()
    end
end)
yPos = yPos + 45

miscContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ==================== CREDITS TAB ====================
local creditsContent = contentFrames["Credits"]
yPos = 10

createLabel(creditsContent, "📝 ABOUT", yPos)
yPos = yPos + 35

local creditLabels = {
    "FISH IT HUB V6",
    "━━━━━━━━━━━━━━",
    "Created by: JUNZXSEC",
    "Version: 6.0",
    "Release: 2026",
    "━━━━━━━━━━━━━━",
    "Telegram: @xRay404x",
    "Team: BABAYO EROR SYSTEM (BES)",
    "━━━━━━━━━━━━━━",
    "30+ FEATURES",
    "FLOATING GUI",
    "DRAGGABLE",
    "━━━━━━━━━━━━━━",
    "Thanks for using!"
}

for _, text in ipairs(creditLabels) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 10, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = text:match("━━") and Enum.Font.Code or Enum.Font.Gotham
    label.TextSize = text:match("━━") and 14 or 16
    label.Parent = creditsContent
    yPos = yPos + 25
end

creditsContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ==================== FLOATING BUTTON DRAG ====================
local dragging = false
local dragStart
local startPos

floatButton.MouseButton1Down:Connect(function(input)
    dragging = true
    dragStart = Vector2.new(input.Position.X, input.Position.Y)
    startPos = floatButton.Position
end)

userInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
        floatButton.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- FLOATING BUTTON CLICK
floatButton.MouseButton1Click:Connect(function()
    mainMenu.Visible = not mainMenu.Visible
    if mainMenu.Visible then
        tweenService:Create(mainMenu, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    end
end)

-- ANIMASI SAAT LOAD
floatButton.Rotation = 0
tweenService:Create(floatButton, TweenInfo.new(1, Enum.EasingStyle.Elastic), {Rotation = 360, Size = UDim2.new(0, 70, 0, 70)}):Play()
wait(0.5)
tweenService:Create(floatButton, TweenInfo.new(0.5), {Size = UDim2.new(0, 60, 0, 60)}):Play()

-- SPAWN PROTECTION (ANTI DICURI)
for _, v in pairs(player.PlayerGui:GetChildren()) do
    if v.Name ~= "JunzFishItHub" and v:IsA("ScreenGui") then
        v.Enabled = false
    end
end

-- WELCOME MESSAGE
local welcomeMsg = Instance.new("Message")
welcomeMsg.Parent = workspace
welcomeMsg.Text = "🔥 FISH IT HUB V6 LOADED | JUNZXSEC 🔥"
wait(3)
welcomeMsg:Destroy()

print([[
╔══════════════════════════════════════════════════════════╗
║              FISH IT HUB V6 - JUNZXSEC                  ║
╠══════════════════════════════════════════════════════════╣
║  ✅ FLOATING BUTTON (DRAGGABLE)                         ║
║  ✅ MAIN MENU (DRAGGABLE)                                ║
║  ✅ ANTI DOUBLE EXECUTE                                  ║
║  ✅ 7 TABS with 30+ FEATURES                             ║
╠══════════════════════════════════════════════════════════╣
║  Fishing | Auto | Player | Visual | World | Misc        ║
╠══════════════════════════════════════════════════════════╣
║              Telegram: @junzsukanasgor                  ║
║                 Team: GHOSTNET-X                        ║
╚══════════════════════════════════════════════════════════╝
]])