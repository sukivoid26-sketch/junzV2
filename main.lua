--[[
██████╗ ██╗   ██╗████████╗████████╗ ██████╗ ███╗   ██╗
██╔══██╗██║   ██║╚══██╔══╝╚══██╔══╝██╔═══██╗████╗  ██║
██████╔╝██║   ██║   ██║      ██║   ██║   ██║██╔██╗ ██║
██╔══██╗██║   ██║   ██║      ██║   ██║   ██║██║╚██╗██║
██████╔╝╚██████╔╝   ██║      ██║   ╚██████╔╝██║ ╚████║
╚═════╝  ╚═════╝    ╚═╝      ╚═╝    ╚═════╝ ╚═╝  ╚═══╝
]]

-- PAKE FLUFFLIB (RINGAN & PASTI WORK)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "JUNZXSEC KUDET TOOL",
    SubTitle = "by JUNZXSEC",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Darker"
})

local Tabs = {
    Main = Window:AddTab({ Title = "KUDET", Icon = "rbxassetid://4483345998" }),
    Second = Window:AddTab({ Title = "CREDITS", Icon = "rbxassetid://4483345998" })
}

-- VARIABLES
local player = game.Players.LocalPlayer
local players = game:GetService("Players")
local Options = Fluent.Options

-- MAIN TAB
local Section = Tabs.Main:AddSection("Player Kicker")

-- LIST PLAYER BUAT DROPDOWN
local playerNames = {}
for _, v in pairs(players:GetPlayers()) do
    if v ~= player then
        table.insert(playerNames, v.Name)
    end
end

-- DROPDOWN PLAYER
local Dropdown = Tabs.Main:AddDropdown("PlayerDropdown", {
    Title = "Pilih Target",
    Values = playerNames,
    Multi = false,
    Default = 1,
})

local selectedTarget = nil
Dropdown:OnChanged(function(Value)
    selectedTarget = players:FindFirstChild(Value)
    print("Target:", Value)
end)

-- BUTTON KICK (PASTI BISA DIPENCET)
Tabs.Main:AddButton({
    Title = "KICK PLAYER",
    Description = "Kick player yang dipilih",
    Callback = function()
        if selectedTarget then
            pcall(function()
                selectedTarget:Kick("KUDET SCRIPT - JUNZXSEC")
                Fluent:Notify({
                    Title = "BERHASIL",
                    Content = "Player " .. selectedTarget.Name .. " telah dikick!",
                    Duration = 3
                })
            end)
        else
            Fluent:Notify({
                Title = "GAGAL",
                Content = "Pilih player dulu kontol!",
                Duration = 3
            })
        end
    end
})

-- BUTTON KICK ALL
Tabs.Main:AddButton({
    Title = "KICK ALL PLAYERS",
    Description = "Kick semua player di server",
    Callback = function()
        local count = 0
        for _, v in pairs(players:GetPlayers()) do
            if v ~= player then
                pcall(function()
                    v:Kick("ALL KICKED BY JUNZXSEC")
                    count = count + 1
                end)
            end
        end
        Fluent:Notify({
            Title = "BERHASIL",
            Content = count .. " player telah dikick!",
            Duration = 3
        })
    end
})

-- BUTTON CRASH PLAYER
Tabs.Main:AddButton({
    Title = "CRASH PLAYER",
    Description = "Crash player yang dipilih",
    Callback = function()
        if selectedTarget then
            for i = 1, 500 do
                local p = Instance.new("Part")
                p.Parent = workspace
                p.Size = Vector3.new(100, 100, 100)
                if selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart") then
                    p.Position = selectedTarget.Character.HumanoidRootPart.Position
                end
                p.Anchored = true
            end
            Fluent:Notify({
                Title = "CRASH",
                Content = "Mencrash " .. selectedTarget.Name,
                Duration = 3
            })
        end
    end
})

-- BUTTON REPORT PLAYER
Tabs.Main:AddButton({
    Title = "REPORT PLAYER",
    Description = "Report player ke Roblox",
    Callback = function()
        if selectedTarget then
            for i = 1, 10 do
                pcall(function()
                    game:GetService("ReplicatedStorage"):FindFirstChild("ReportAbuse"):FireServer(selectedTarget, "Hacking/Exploiting")
                end)
            end
            Fluent:Notify({
                Title = "REPORT",
                Content = selectedTarget.Name .. " telah dilaporkan!",
                Duration = 3
            })
        end
    end
})

-- TOGGLE AUTO KICK
Tabs.Main:AddToggle("AutoKickToggle", {
    Title = "Auto Kick New Players",
    Default = false,
    Callback = function(Value)
        _G.autoKick = Value
        if Value then
            players.PlayerAdded:Connect(function(newPlayer)
                if _G.autoKick and newPlayer ~= player then
                    wait(1)
                    pcall(function()
                        newPlayer:Kick("AUTO KICKED")
                    end)
                end
            end)
            Fluent:Notify({
                Title = "AUTO KICK",
                Content = "Auto kick diaktifkan!",
                Duration = 3
            })
        end
    end
})

-- CREDITS TAB
local Credits = Tabs.Second:AddSection("INFO")
Credits:AddParagraph({
    Title = "JUNZXSEC KUDET TOOL",
    Content = "Version: 2.0\nCreator: JUNZXSEC\nTelegram: @junzsukanasgor\nTeam: GHOSTNET-X\n\n⚠️ GUNAKAN DENGAN BIJAK ⚠️"
})

-- SAVE MANAGER
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("JunzKudet")
SaveManager:SetFolder("JunzKudet/Scripts")
InterfaceManager:BuildInterfaceSection(Tabs.Second)
SaveManager:BuildConfigSection(Tabs.Second)

-- INIT
Window:SelectTab(1)
Fluent:Notify({
    Title = "JUNZXSEC KUDET",
    Content = "Script Loaded!",
    Duration = 3
})

print([[
╔══════════════════════════════════════╗
║     JUNZXSEC KUDET TOOL V2           ║
║         BUTTON 100% WORK             ║
╚══════════════════════════════════════╝
]])