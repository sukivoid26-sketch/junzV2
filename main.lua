--[
--]]

-- LOAD LIBRARY
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sukivoid26/junzV2/main/main.lua"))()
local Window = Library.CreateLib("FISH IT BY - JUNZXSEC", "DarkTheme")

-- VARIABLES
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- CONFIG
local Config = {
    AutoFish = false,
    AutoCast = false,
    AutoReel = false,
    AutoSell = false,
    AutoOpenCrates = false,
    AutoUpgrade = false,
    AutoShiny = false,
    AutoMythical = false,
    AutoLegendary = false,
    AutoFarm = false,
    SpeedBoost = 16,
    JumpBoost = 50,
    ESP = false,
    InfiniteBait = false,
    InstantCatch = false,
    AutoCollect = false
}

-- FUNGSI UTAMA
function getFishingRod()
    local backpack = player.Backpack
    for _, item in pairs(backpack:GetChildren()) do
        if item.Name:lower():match("rod") or item.Name:lower():match("fishing") then
            return item
        end
    end
    return nil
end

function castRod()
    local rod = getFishingRod()
    if rod and rod:FindFirstChild("Cast") then
        rod.Cast:FireServer()
        return true
    end
    return false
end

function reelRod()
    local rod = getFishingRod()
    if rod and rod:FindFirstChild("Reel") then
        rod.Reel:FireServer()
        return true
    end
    return false
end

function sellFish()
    local args = {
        [1] = "SellAll"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Sell"):InvokeServer(unpack(args))
end

function openCrates()
    local args = {
        [1] = "OpenAll"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("OpenCrate"):InvokeServer(unpack(args))
end

function collectDrops()
    local drops = workspace:FindPartsInRegion3(
        Region3.new(
            rootPart.Position - Vector3.new(50, 50, 50),
            rootPart.Position + Vector3.new(50, 50, 50)
        ),
        character,
        100
    )
    
    for _, drop in pairs(drops) do
        if drop:IsA("Part") and drop.Name:lower():match("drop") then
            firetouchinterest(rootPart, drop, 0)
            wait(0.1)
            firetouchinterest(rootPart, drop, 1)
        end
    end
end

-- AUTO FISH LOOP
function startAutoFish()
    spawn(function()
        while Config.AutoFish do
            pcall(function()
                castRod()
                wait(0.5)
                
                if Config.InstantCatch then
                    wait(0.1)
                    reelRod()
                else
                    wait(2)
                    reelRod()
                end
                
                wait(0.5)
                
                if Config.AutoCollect then
                    collectDrops()
                end
                
                if Config.AutoSell then
                    sellFish()
                end
                
                if Config.AutoOpenCrates then
                    openCrates()
                end
            end)
            wait(1)
        end
    end)
end

-- AUTO FARM LOOP
function startAutoFarm()
    spawn(function()
        while Config.AutoFarm do
            pcall(function()
                -- Farm XP
                local args = {
                    [1] = "Farm"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Farm"):InvokeServer(unpack(args))
            end)
            wait(5)
        end
    end)
end

-- SPEED BOOST
function applySpeedBoost()
    spawn(function()
        while Config.SpeedBoost > 0 do
            pcall(function()
                humanoid.WalkSpeed = Config.SpeedBoost
                humanoid.JumpPower = Config.JumpBoost
            end)
            wait(1)
        end
    end)
end

-- INFINITE BAIT
function infiniteBait()
    spawn(function()
        while Config.InfiniteBait do
            pcall(function()
                local baitItem = player.Backpack:FindFirstChild("Bait")
                if baitItem then
                    baitItem.Value = 9999
                end
            end)
            wait(1)
        end
    end)
end

-- ESP FUNCTION
function createESP()
    spawn(function()
        while Config.ESP do
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                        if not v:FindFirstChild("ESP") then
                            local billboard = Instance.new("BillboardGui")
                            local textLabel = Instance.new("TextLabel")
                            
                            billboard.Name = "ESP"
                            billboard.Adornee = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                            billboard.Size = UDim2.new(0, 200, 0, 50)
                            billboard.StudsOffset = Vector3.new(0, 3, 0)
                            
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.BackgroundTransparency = 1
                            textLabel.TextColor3 = Color3.new(1, 0, 0)
                            textLabel.Text = v.Name
                            textLabel.Font = Enum.Font.SourceSansBold
                            textLabel.TextSize = 14
                            
                            textLabel.Parent = billboard
                            billboard.Parent = v
                        end
                    end
                end
            end)
            wait(5)
        end
    end)
end

-- AUTO SHINY/MYTHICAL/LEGENDARY
function autoRare()
    spawn(function()
        while Config.AutoShiny or Config.AutoMythical or Config.AutoLegendary do
            pcall(function()
                local args = {}
                if Config.AutoShiny then
                    table.insert(args, "Shiny")
                end
                if Config.AutoMythical then
                    table.insert(args, "Mythical")
                end
                if Config.AutoLegendary then
                    table.insert(args, "Legendary")
                end
                
                if #args > 0 then
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Rare"):InvokeServer(args)
                end
            end)
            wait(10)
        end
    end)
end

-- AUTO UPGRADE
function autoUpgrade()
    spawn(function()
        while Config.AutoUpgrade do
            pcall(function()
                local args = {
                    [1] = "Upgrade"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Upgrade"):InvokeServer(unpack(args))
            end)
            wait(30)
        end
    end)
end

-- MAIN TAB
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Fishing Controls")

MainSection:NewToggle("Auto Fish", "Otomatis mancing", function(state)
    Config.AutoFish = state
    if state then startAutoFish() end
end)

MainSection:NewToggle("Auto Cast", "Otomatis cast", function(state)
    Config.AutoCast = state
end)

MainSection:NewToggle("Auto Reel", "Otomatis narik", function(state)
    Config.AutoReel = state
end)

MainSection:NewToggle("Instant Catch", "Langsung dapet ikan", function(state)
    Config.InstantCatch = state
end)

-- FARM TAB
local FarmTab = Window:NewTab("Farming")
local FarmSection = FarmTab:NewSection("Farm Settings")

FarmSection:NewToggle("Auto Farm", "Auto farming mode", function(state)
    Config.AutoFarm = state
    if state then startAutoFarm() end
end)

FarmSection:NewToggle("Auto Sell", "Otomatis jual ikan", function(state)
    Config.AutoSell = state
end)

FarmSection:NewToggle("Auto Open Crates", "Otomatis buka crate", function(state)
    Config.AutoOpenCrates = state
end)

FarmSection:NewToggle("Auto Collect Drops", "Otomatis ambil item", function(state)
    Config.AutoCollect = state
end)

-- UPGRADE TAB
local UpgradeTab = Window:NewTab("Upgrade")
local UpgradeSection = UpgradeTab:NewSection("Upgrade Settings")

UpgradeSection:NewToggle("Auto Upgrade", "Auto upgrade equipment", function(state)
    Config.AutoUpgrade = state
    if state then autoUpgrade() end
end)

UpgradeSection:NewToggle("Auto Shiny", "Kejar ikan shiny", function(state)
    Config.AutoShiny = state
    if state then autoRare() end
end)

UpgradeSection:NewToggle("Auto Mythical", "Kejar ikan mythical", function(state)
    Config.AutoMythical = state
    if state then autoRare() end
end)

UpgradeSection:NewToggle("Auto Legendary", "Kejar ikan legendary", function(state)
    Config.AutoLegendary = state
    if state then autoRare() end
end)

-- PLAYER TAB
local PlayerTab = Window:NewTab("Player")
local PlayerSection = PlayerTab:NewSection("Player Settings")

PlayerSection:NewSlider("Walk Speed", "Speed player", 200, 16, function(speed)
    Config.SpeedBoost = speed
    applySpeedBoost()
end)

PlayerSection:NewSlider("Jump Power", "Ketinggian lompat", 200, 50, function(jump)
    Config.JumpBoost = jump
    applySpeedBoost()
end)

PlayerSection:NewToggle("Infinite Bait", "Umpan gak abis", function(state)
    Config.InfiniteBait = state
    if state then infiniteBait() end
end)

PlayerSection:NewToggle("ESP", "Lihat player lain", function(state)
    Config.ESP = state
    if state then createESP() end
end)

-- TELEPORT TAB
local TeleportTab = Window:NewTab("Teleport")
local TeleportSection = TeleportTab:NewSection("Teleport Locations")

-- Save current position
TeleportSection:NewButton("Save Position", "Simpan posisi sekarang", function()
    _G.savedPos = rootPart.Position
    Library:Notify("Position Saved!", 2)
end)

-- Teleport to saved position
TeleportSection:NewButton("Teleport to Saved", "Pindah ke posisi tersimpan", function()
    if _G.savedPos then
        rootPart.CFrame = CFrame.new(_G.savedPos)
        Library:Notify("Teleported!", 2)
    end
end)

-- Teleport to fishing spot
TeleportSection:NewButton("Teleport to Fishing Spot", "Pindah ke spot mancing", function()
    local fishingSpots = workspace:FindPartsInRegion3(
        Region3.new(
            Vector3.new(-1000, -1000, -1000),
            Vector3.new(1000, 1000, 1000)
        ),
        character,
        1000
    )
    
    for _, spot in pairs(fishingSpots) do
        if spot:IsA("Part") and spot.Name:lower():match("water") then
            rootPart.CFrame = CFrame.new(spot.Position + Vector3.new(0, 5, 0))
            break
        end
    end
end)

-- AUTO FISH LOCATIONS
local locations = {
    "Spawn",
    "Ocean",
    "River",
    "Pond",
    "Mountain Lake"
}

for i, loc in ipairs(locations) do
    TeleportSection:NewButton("Go to " .. loc, "Pindah ke " .. loc, function()
        -- Cari location di workspace
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Part") and v.Name:lower():match(loc:lower()) then
                rootPart.CFrame = CFrame.new(v.Position + Vector3.new(0, 5, 0))
                break
            end
        end
    end)
end

-- MISC TAB
local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("Extra Features")

-- Auto reconnect
MiscSection:NewToggle("Auto Rejoin", "Auto reconnect kalo disconnect", function(state)
    Config.AutoRejoin = state
    if state then
        spawn(function()
            while Config.AutoRejoin do
                wait(5)
                if not game:IsLoaded() then
                    game:GetService("TeleportService"):Teleport(game.PlaceId, player)
                end
            end
        end)
    end
end)

-- Anti AFK
MiscSection:NewToggle("Anti AFK", "Anti kick karena afk", function(state)
    Config.AntiAFK = state
    if state then
        spawn(function()
            while Config.AntiAFK do
                wait(600)
                humanoid:MoveTo(rootPart.Position + Vector3.new(1, 0, 0))
                wait(0.1)
                humanoid:MoveTo(rootPart.Position - Vector3.new(1, 0, 0))
            end
        end)
    end
end)

-- Clear inventory
MiscSection:NewButton("Clear Inventory", "Bersihin inventory", function()
    for _, item in pairs(player.Backpack:GetChildren()) do
        item:Destroy()
    end
    Library:Notify("Inventory Cleared!", 2)
end)

-- FPS Boost
MiscSection:NewToggle("FPS Boost", "Tingkatin FPS", function(state)
    if state then
        settings().Rendering.QualityLevel = 1
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    else
        settings().Rendering.QualityLevel = 10
        game:GetService("RunService"):Set3dRenderingEnabled(true)
    end
end)

-- CREDITS TAB
local CreditsTab = Window:NewTab("Credits")
local CreditsSection = CreditsTab:NewSection("About")

CreditsSection:NewLabel("FISH IT SCRIPT")
CreditsSection:NewLabel("Created by: JUNZXSEC")
CreditsSection:NewLabel("Version: 3.0")
CreditsSection:NewLabel("Executor: Delta")
CreditsSection:NewLabel("Join: @junzsukanasgor")
CreditsSection:NewLabel("Team: GHOSTNET-X")

-- NOTIFICATION ON LOAD
Library:Notify("FISH IT SCRIPT Loaded! | JUNZXSEC", 3)

-- WELCOME MESSAGE
print([[
╔══════════════════════════════════════╗
║     FISH IT SCRIPT - JUNZXSEC        ║
║         Delta Executor Ready          ║
╚══════════════════════════════════════╝
]])

-- AUTO EXECUTE ON LOAD
spawn(function()
    wait(2)
    print("[✓] Script loaded successfully!")
    print("[✓] Features ready to use!")
    print("[✓] Happy Fishing!")
end)