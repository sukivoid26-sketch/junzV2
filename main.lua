--[[

--]]

-- LOAD LIBRARY KAVO UI (YANG PALING KEREN)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("JUNZXSEC ULTIMATE HUB V5", "Synapse")

-- VARIABLES
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- CONFIG
local Config = {
    -- Player
    Walkspeed = 16,
    JumpPower = 50,
    Gravity = 196.2,
    HipHeight = 0,
    FOV = 70,
    
    -- Combat
    Aimbot = false,
    SilentAim = false,
    ESP = false,
    Tracer = false,
    Boxes = false,
    HealthBar = false,
    NameTags = false,
    
    -- Movement
    Fly = false,
    Noclip = false,
    InfJump = false,
    ClickTP = false,
    
    -- Visual
    Fullbright = false,
    NightMode = false,
    XRay = false,
    WalksOnWater = false,
    
    -- Farm
    AutoFarm = false,
    AutoCollect = false,
    AutoSell = false,
    AutoRebirth = false,
    
    -- Misc
    AntiAFK = false,
    FPSBoost = false,
    Rejoin = false,
    ServerHop = false
}

-- FUNGSI UTAMA =================================================================

-- PLAYER FUNCTIONS
function updateWalkspeed()
    spawn(function()
        while Config.Walkspeed do
            pcall(function()
                humanoid.WalkSpeed = Config.Walkspeed
            end)
            wait(1)
        end
    end)
end

function updateJumpPower()
    spawn(function()
        while Config.JumpPower do
            pcall(function()
                humanoid.JumpPower = Config.JumpPower
            end)
            wait(1)
        end
    end)
end

function updateGravity()
    spawn(function()
        while Config.Gravity do
            pcall(function()
                workspace.Gravity = Config.Gravity
            end)
            wait(1)
        end
    end)
end

function updateFOV()
    spawn(function()
        while Config.FOV do
            pcall(function()
                camera.FieldOfView = Config.FOV
            end)
            wait(1)
        end
    end)
end

-- FLY FUNCTION (KEREN BANGET)
function startFly()
    spawn(function()
        local flying = false
        local speed = 50
        local bodyVelocity = Instance.new("BodyVelocity")
        local bodyGyro = Instance.new("BodyGyro")
        
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.MaxForce = Vector3.new(1,1,1) * math.huge
        bodyGyro.MaxTorque = Vector3.new(1,1,1) * math.huge
        bodyGyro.P = 1000
        
        while Config.Fly do
            pcall(function()
                if not flying then
                    bodyVelocity.Parent = rootPart
                    bodyGyro.Parent = rootPart
                    flying = true
                end
                
                local moveDir = Vector3.new(0,0,0)
                
                if mouse then
                    bodyGyro.CFrame = CFrame.new(rootPart.Position, mouse.Hit.p)
                    
                    if player:GetMouse().X then
                        moveDir = workspace.CurrentCamera.CFrame.LookVector * speed
                    end
                    
                    -- WSAD Controls
                    if player:GetMouse().X then
                        if player:GetMouse().X > 0 then
                            moveDir = workspace.CurrentCamera.CFrame.RightVector * speed
                        end
                    end
                end
                
                bodyVelocity.Velocity = moveDir
            end)
            wait()
        end
        
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end)
end

-- NOCLIP FUNCTION
function startNoclip()
    spawn(function()
        while Config.Noclip do
            pcall(function()
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
            wait(0.1)
        end
    end)
end

-- INFINITE JUMP
function startInfJump()
    spawn(function()
        while Config.InfJump do
            pcall(function()
                humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
                    if Config.InfJump then
                        humanoid.Jump = true
                    end
                end)
            end)
            wait(1)
        end
    end)
end

-- CLICK TP
function startClickTP()
    spawn(function()
        mouse.Button1Down:Connect(function()
            if Config.ClickTP then
                rootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0,5,0))
            end
        end)
    end)
end

-- ESP FUNCTIONS (SUPER LENGKAP)
function createESP()
    spawn(function()
        while Config.ESP do
            pcall(function()
                for _, plr in pairs(game.Players:GetPlayers()) do
                    if plr ~= player then
                        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = plr.Character.HumanoidRootPart
                            
                            -- Box ESP
                            if Config.Boxes then
                                if not hrp:FindFirstChild("ESP_Box") then
                                    local box = Instance.new("BoxHandleAdornment")
                                    box.Name = "ESP_Box"
                                    box.Size = plr.Character:GetExtentsSize()
                                    box.Adornee = hrp
                                    box.Color3 = Color3.new(1,0,0)
                                    box.Transparency = 0.5
                                    box.AlwaysOnTop = true
                                    box.ZIndex = 10
                                    box.Parent = hrp
                                end
                            end
                            
                            -- Name Tags
                            if Config.NameTags then
                                if not hrp:FindFirstChild("ESP_Name") then
                                    local billboard = Instance.new("BillboardGui")
                                    local textLabel = Instance.new("TextLabel")
                                    
                                    billboard.Name = "ESP_Name"
                                    billboard.Adornee = hrp
                                    billboard.Size = UDim2.new(0, 200, 0, 50)
                                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                                    
                                    textLabel.Size = UDim2.new(1,0,1,0)
                                    textLabel.BackgroundTransparency = 1
                                    textLabel.TextColor3 = Color3.new(1,1,0)
                                    textLabel.Text = plr.Name .. " [" .. math.floor(plr.Character.Humanoid.Health) .. "]"
                                    textLabel.Font = Enum.Font.SourceSansBold
                                    textLabel.TextSize = 14
                                    
                                    textLabel.Parent = billboard
                                    billboard.Parent = hrp
                                end
                            end
                            
                            -- Health Bar
                            if Config.HealthBar then
                                if not hrp:FindFirstChild("ESP_Health") then
                                    local healthBar = Instance.new("BillboardGui")
                                    local frame = Instance.new("Frame")
                                    local fill = Instance.new("Frame")
                                    
                                    healthBar.Name = "ESP_Health"
                                    healthBar.Adornee = hrp
                                    healthBar.Size = UDim2.new(0, 50, 0, 10)
                                    healthBar.StudsOffset = Vector3.new(0, 4, 0)
                                    
                                    frame.Size = UDim2.new(1,0,1,0)
                                    frame.BackgroundColor3 = Color3.new(0,0,0)
                                    frame.BorderSizePixel = 0
                                    
                                    fill.Size = UDim2.new(plr.Character.Humanoid.Health/100, 0, 1,0)
                                    fill.BackgroundColor3 = Color3.new(0,1,0)
                                    fill.BorderSizePixel = 0
                                    
                                    fill.Parent = frame
                                    frame.Parent = healthBar
                                    healthBar.Parent = hrp
                                end
                            end
                            
                            -- Tracers
                            if Config.Tracer then
                                if not hrp:FindFirstChild("ESP_Tracer") then
                                    local tracer = Instance.new("Part")
                                    tracer.Name = "ESP_Tracer"
                                    tracer.Anchored = true
                                    tracer.CanCollide = false
                                    tracer.Material = Enum.Material.Neon
                                    tracer.BrickColor = BrickColor.new("Bright red")
                                    tracer.Size = Vector3.new(0.1, 0.1, 0)
                                    tracer.Parent = workspace
                                    
                                    game:GetService("RunService").RenderStepped:Connect(function()
                                        if hrp and tracer then
                                            local from = camera.CFrame.Position
                                            local to = hrp.Position
                                            local dist = (from - to).Magnitude
                                            tracer.Size = Vector3.new(0.1, 0.1, dist)
                                            tracer.CFrame = CFrame.lookAt(from, to) * CFrame.new(0,0,-dist/2)
                                        else
                                            tracer:Destroy()
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
            end)
            wait(1)
        end
        
        -- Cleanup
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name:match("ESP_") then
                v:Destroy()
            end
        end
    end)
end

-- FULLBRIGHT
function toggleFullbright()
    spawn(function()
        while Config.Fullbright do
            pcall(function()
                game:GetService("Lighting").Ambient = Color3.new(1,1,1)
                game:GetService("Lighting").Brightness = 2
                game:GetService("Lighting").ClockTime = 12
                game:GetService("Lighting").FogEnd = 100000
            end)
            wait(1)
        end
    end)
end

-- NIGHT MODE
function toggleNightMode()
    spawn(function()
        while Config.NightMode do
            pcall(function()
                game:GetService("Lighting").Ambient = Color3.new(0,0,0)
                game:GetService("Lighting").Brightness = 0.5
                game:GetService("Lighting").ClockTime = 0
            end)
            wait(1)
        end
    end)
end

-- XRAY
function toggleXRay()
    spawn(function()
        while Config.XRay do
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and not v:IsDescendantOf(player.Character) then
                        v.Transparency = 0.7
                        v.Material = Enum.Material.ForceField
                    end
                end
            end)
            wait(5)
        end
    end)
end

-- WALK ON WATER
function walkOnWater()
    spawn(function()
        while Config.WalksOnWater do
            pcall(function()
                if rootPart.Position.Y < 0 then
                    rootPart.Velocity = Vector3.new(rootPart.Velocity.X, 10, rootPart.Velocity.Z)
                end
            end)
            wait()
        end
    end)
end

-- AUTO FARM (GENERIC)
function startAutoFarm()
    spawn(function()
        while Config.AutoFarm do
            pcall(function()
                -- Cari nearest enemy/mob
                local nearest = nil
                local nearestDist = math.huge
                
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= character then
                        if v:FindFirstChild("HumanoidRootPart") then
                            local dist = (rootPart.Position - v.HumanoidRootPart.Position).Magnitude
                            if dist < nearestDist then
                                nearestDist = dist
                                nearest = v
                            end
                        end
                    end
                end
                
                if nearest then
                    -- Move to target
                    rootPart.CFrame = CFrame.new(nearest.HumanoidRootPart.Position + Vector3.new(0,5,0))
                    
                    -- Attack
                    local tool = player.Character:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Handle") then
                        tool:Activate()
                    end
                    
                    wait(1)
                end
            end)
            wait(0.5)
        end
    end)
end

-- AUTO COLLECT
function startAutoCollect()
    spawn(function()
        while Config.AutoCollect do
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Part") and (v.Name:lower():match("drop") or v.Name:lower():match("coin") or v.Name:lower():match("gem")) then
                        if (rootPart.Position - v.Position).Magnitude < 50 then
                            firetouchinterest(rootPart, v, 0)
                            wait(0.1)
                            firetouchinterest(rootPart, v, 1)
                        end
                    end
                end
            end)
            wait(2)
        end
    end)
end

-- ANTI AFK
function startAntiAFK()
    spawn(function()
        while Config.AntiAFK do
            pcall(function()
                humanoid:MoveTo(rootPart.Position + Vector3.new(1,0,0))
                wait(0.1)
                humanoid:MoveTo(rootPart.Position - Vector3.new(1,0,0))
            end)
            wait(600)
        end
    end)
end

-- FPS BOOST
function toggleFPSBoost()
    spawn(function()
        while Config.FPSBoost do
            pcall(function()
                settings().Rendering.QualityLevel = 1
                game:GetService("RunService"):Set3dRenderingEnabled(false)
                
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and not v:IsDescendantOf(player.Character) then
                        v.Material = Enum.Material.Plastic
                        v.Reflectance = 0
                    end
                end
            end)
            wait(10)
        end
    end)
end

-- REJOIN
function rejoinGame()
    local ts = game:GetService("TeleportService")
    local placeId = game.PlaceId
    ts:Teleport(placeId, player)
end

-- SERVER HOP
function serverHop()
    local placeId = game.PlaceId
    local servers = {}
    
    local success, cursor = pcall(function()
        return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?limit=100"))
    end)
    
    if success and cursor and cursor.data then
        for _, server in ipairs(cursor.data) do
            if server.playing < server.maxPlayers then
                table.insert(servers, server.id)
            end
        end
    end
    
    if #servers > 0 then
        local randomServer = servers[math.random(1, #servers)]
        game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, randomServer, player)
    end
end

-- GUI CREATION =================================================================

-- MAIN TAB
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Player Controls")

MainSection:NewSlider("Walkspeed", "Speed karakter", 500, 16, function(speed)
    Config.Walkspeed = speed
    humanoid.WalkSpeed = speed
end)

MainSection:NewSlider("Jump Power", "Ketinggian lompat", 500, 50, function(jump)
    Config.JumpPower = jump
    humanoid.JumpPower = jump
end)

MainSection:NewSlider("Gravity", "Gravitasi dunia", 500, 196, function(grav)
    Config.Gravity = grav
    workspace.Gravity = grav
end)

MainSection:NewSlider("FOV", "Field of View", 120, 70, function(fov)
    Config.FOV = fov
    camera.FieldOfView = fov
end)

-- MOVEMENT TAB
local MoveTab = Window:NewTab("Movement")
local MoveSection = MoveTab:NewSection("Movement Hacks")

MoveSection:NewToggle("Fly", "Terbang bebas", function(state)
    Config.Fly = state
    startFly()
end)

MoveSection:NewToggle("Noclip", "Tembus tembok", function(state)
    Config.Noclip = state
    startNoclip()
end)

MoveSection:NewToggle("Infinite Jump", "Lompat terus", function(state)
    Config.InfJump = state
    startInfJump()
end)

MoveSection:NewToggle("Click TP", "Klik buat teleport", function(state)
    Config.ClickTP = state
    startClickTP()
end)

MoveSection:NewToggle("Walk on Water", "Jalan di atas air", function(state)
    Config.WalksOnWater = state
    walkOnWater()
end)

-- COMBAT TAB
local CombatTab = Window:NewTab("Combat")
local CombatSection = CombatTab:NewSection("Combat Features")

CombatSection:NewToggle("ESP", "Lihat player lain", function(state)
    Config.ESP = state
    if state then createESP() end
end)

CombatSection:NewToggle("Box ESP", "Kotak di sekitar player", function(state)
    Config.Boxes = state
end)

CombatSection:NewToggle("Name Tags", "Nama player", function(state)
    Config.NameTags = state
end)

CombatSection:NewToggle("Health Bar", "Bar kesehatan", function(state)
    Config.HealthBar = state
end)

CombatSection:NewToggle("Tracers", "Garis ke player", function(state)
    Config.Tracer = state
end)

-- VISUAL TAB
local VisualTab = Window:NewTab("Visual")
local VisualSection = VisualTab:NewSection("Visual Effects")

VisualSection:NewToggle("Fullbright", "Terang terus", function(state)
    Config.Fullbright = state
    toggleFullbright()
end)

VisualSection:NewToggle("Night Mode", "Mode malam", function(state)
    Config.NightMode = state
    toggleNightMode()
end)

VisualSection:NewToggle("X-Ray", "Lihat tembus", function(state)
    Config.XRay = state
    toggleXRay()
end)

-- FARM TAB
local FarmTab = Window:NewTab("Farming")
local FarmSection = FarmTab:NewSection("Auto Farm")

FarmSection:NewToggle("Auto Farm", "Auto farming", function(state)
    Config.AutoFarm = state
    if state then startAutoFarm() end
end)

FarmSection:NewToggle("Auto Collect", "Ambil item auto", function(state)
    Config.AutoCollect = state
    if state then startAutoCollect() end
end)

FarmSection:NewToggle("Auto Sell", "Jual otomatis", function(state)
    Config.AutoSell = state
end)

FarmSection:NewToggle("Auto Rebirth", "Rebirth otomatis", function(state)
    Config.AutoRebirth = state
end)

-- MISC TAB
local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("Extra Features")

MiscSection:NewToggle("Anti AFK", "Gak bakal di kick", function(state)
    Config.AntiAFK = state
    if state then startAntiAFK() end
end)

MiscSection:NewToggle("FPS Boost", "Tingkatin FPS", function(state)
    Config.FPSBoost = state
    if state then toggleFPSBoost() end
end)

MiscSection:NewButton("Rejoin Server", "Masuk lagi ke server", function()
    rejoinGame()
end)

MiscSection:NewButton("Server Hop", "Pindah server", function()
    serverHop()
end)

-- TELEPORT TAB
local TeleportTab = Window:NewTab("Teleport")
local TeleportSection = TeleportTab:NewSection("Teleport Options")

TeleportSection:NewButton("Save Position", "Simpen posisi", function()
    _G.savedPos = rootPart.Position
    Library:Notify("Position Saved!", 2)
end)

TeleportSection:NewButton("Load Position", "Balik ke posisi simpenan", function()
    if _G.savedPos then
        rootPart.CFrame = CFrame.new(_G.savedPos)
        Library:Notify("Teleported!", 2)
    end
end)

TeleportSection:NewButton("Teleport to Spawn", "Balik ke spawn", function()
    local spawns = workspace:FindPartsInRegion3(
        Region3.new(Vector3.new(-1000,-1000,-1000), Vector3.new(1000,1000,1000)),
        character,
        100
    )
    for _, v in pairs(spawns) do
        if v:IsA("Part") and v.Name:lower():match("spawn") then
            rootPart.CFrame = CFrame.new(v.Position + Vector3.new(0,5,0))
            break
        end
    end
end)

-- CREDITS TAB
local CreditsTab = Window:NewTab("Credits")
local CreditsSection = CreditsTab:NewSection("About")

CreditsSection:NewLabel("JUNZXSEC ULTIMATE HUB V5")
CreditsSection:NewLabel("━━━━━━━━━━━━━━━━━━━━")
CreditsSection:NewLabel("Created by: JUNZXSEC")
CreditsSection:NewLabel("Version: 5.0")
CreditsSection:NewLabel("Release: Feb 2026")
CreditsSection:NewLabel("━━━━━━━━━━━━━━━━━━━━")
CreditsSection:NewLabel("Telegram: @junzsukanasgor")
CreditsSection:NewLabel("Team: BABAYO EROR SYSTEM (BES)")
CreditsSection:NewLabel("━━━━━━━━━━━━━━━━━━━━")
CreditsSection:NewLabel("Thanks for using!")

-- NOTIFICATION
Library:Notify("JUNZXSEC HUB V5 LOADED!", 3)

-- WELCOME MESSAGE
print([[
╔══════════════════════════════════════════════════════════════╗
║     ██╗██╗   ██╗███╗   ██╗███████╗██╗  ██╗███████╗░█████╗░   ║
║     ██║██║   ██║████╗  ██║╚══███╔╝╚██╗██╔╝██╔════╝██╔══██╗   ║
║     ██║██║   ██║██╔██╗ ██║  ███╔╝░░╚███╔╝░█████╗░░██║░░╚═╝   ║
║     ██║╚██╗ ██╔╝██║╚██╗██║ ███╔╝░░░░██╔██╗░██╔══╝░░██║░░██╗   ║
║     ██║░╚████╔╝░██║░╚████║███████╗██╔╝╚██╗███████╗╚█████╔╝   ║
║     ╚═╝░░╚═══╝░░╚═╝░░╚═══╝╚══════╝╚═╝░░╚═╝╚══════╝░╚════╝░   ║
║══════════════════════════════════════════════════════════════║
║                    ULTIMATE HUB V5                           ║
║                 Pwned By JUNZXSEC                            ║
║            Telegram: @junzsukanasgor                         ║
║══════════════════════════════════════════════════════════════║
║                    FEATURES LOADED:                          ║
║  ✅ Movement Hacks    ✅ Combat Features    ✅ Visual       ║
║  ✅ Auto Farm         ✅ ESP System         ✅ Teleport     ║
║  ✅ Anti AFK          ✅ FPS Boost          ✅ Server Hop   ║
║  ✅ Click TP          ✅ Infinite Jump      ✅ X-Ray        ║
║══════════════════════════════════════════════════════════════║
║                    TOTAL: 30+ FEATURES!                      ║
╚══════════════════════════════════════════════════════════════╝
]])