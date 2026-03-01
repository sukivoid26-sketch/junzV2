--[[
    99 NIGHT IN THE FOREST SPAWNER
    Created by: JUNZXSEC
    Untuk: Delta Executor
    Fitur: Spawn Kayu, Besi, Perban, Senjata, Makanan
]]

-- Load library untuk GUI (Delta pake Synapse UI biasanya)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("99 NIGHT FOREST SPAWNER", "DarkTheme")

-- Variables
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Fungsi spawn item
local function SpawnItem(itemName)
    -- Cari item di Workspace atau ReplicatedStorage
    local item = nil
    
    -- Coba cari di berbagai lokasi
    local possibleLocations = {
        game:GetService("ReplicatedStorage"):FindFirstChild("Items"),
        game:GetService("ReplicatedStorage"):FindFirstChild("Resources"),
        game:GetService("Workspace"):FindFirstChild("Items"),
        game:GetService("Workspace"):FindFirstChild("DroppedItems"),
    }
    
    for _, loc in ipairs(possibleLocations) do
        if loc and loc:FindFirstChild(itemName) then
            item = loc:FindFirstChild(itemName)
            break
        elseif loc and loc:FindFirstChild(itemName .. "Item") then
            item = loc:FindFirstChild(itemName .. "Item")
            break
        end
    end
    
    -- Kalo gak ketemu, coba pake method clone dari yang udah ada
    if not item then
        -- Cari item yang mirip di workspace
        for _, obj in ipairs(game:GetService("Workspace"):GetDescendants()) do
            if obj.Name:lower():find(itemName:lower()) and obj:IsA("Part") then
                item = obj
                break
            end
        end
    end
    
    if item then
        -- Clone item
        local newItem = item:Clone()
        newItem.Parent = game:GetService("Workspace")
        newItem.Position = HumanoidRootPart.Position + Vector3.new(0, 3, 5) -- Spawn di depan karakter
        
        -- Kasih efek biar keliatan
        if newItem:IsA("Part") then
            newItem.BrickColor = BrickColor.new("Bright red")
            newItem.Material = "Neon"
            
            -- Kasih sinar
            local billboard = Instance.new("BillboardGui")
            billboard.Parent = newItem
            billboard.Size = UDim2.new(0, 100, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            
            local text = Instance.new("TextLabel")
            text.Parent = billboard
            text.Size = UDim2.new(1, 0, 1, 0)
            text.Text = itemName
            text.TextColor3 = Color3.new(1, 1, 1)
            text.BackgroundTransparency = 1
            text.TextStrokeTransparency = 0
        end
        
        -- Notifikasi
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "✅ SPAWN BERHASIL",
            Text = itemName .. " telah di-spawn!",
            Duration = 3
        })
    else
        -- Kalo gak ketemu, spawn pake part biasa
        local part = Instance.new("Part")
        part.Parent = game:GetService("Workspace")
        part.Position = HumanoidRootPart.Position + Vector3.new(0, 3, 5)
        part.Size = Vector3.new(2, 2, 2)
        part.BrickColor = BrickColor.new("Bright red")
        part.Material = "Neon"
        part.Name = itemName
        
        -- Tambah label
        local billboard = Instance.new("BillboardGui")
        billboard.Parent = part
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        
        local text = Instance.new("TextLabel")
        text.Parent = billboard
        text.Size = UDim2.new(1, 0, 1, 0)
        text.Text = itemName
        text.TextColor3 = Color3.new(1, 1, 1)
        text.BackgroundTransparency = 1
        text.TextStrokeTransparency = 0
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "⚠️ ITEM TIDAK DITEMUKAN",
            Text = "Membuat " .. itemName .. " baru",
            Duration = 3
        })
    end
end

-- Fungsi buat ngumpulin item di sekitar
local function CollectNearbyItems()
    local collected = 0
    for _, obj in ipairs(game:GetService("Workspace"):GetDescendants()) do
        if obj:IsA("Part") and obj.Parent ~= Character and (obj.Position - HumanoidRootPart.Position).Magnitude < 10 then
            obj:Destroy()
            collected = collected + 1
        end
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🧹 COLLECT",
        Text = collected .. " item dikumpulkan",
        Duration = 2
    })
end

-- BUAT TAB SPAWNER
local SpawnerTab = Window:NewTab("Spawner")
local SpawnerSection = SpawnerTab:NewSection("Item Spawner")

-- Tombol Kayu
SpawnerSection:NewButton("🪵 Spawn Kayu", "Spawn kayu untuk crafting", function()
    SpawnItem("Kayu")
end)

-- Tombol Besi
SpawnerSection:NewButton("🔩 Spawn Besi", "Spawn besi untuk senjata", function()
    SpawnItem("Besi")
end)

-- Tombol Perban
SpawnerSection:NewButton("🩹 Spawn Perban", "Spawn perban untuk healing", function()
    SpawnItem("Perban")
end)

-- Tombol Senjata
SpawnerSection:NewButton("🔪 Spawn Senjata", "Spawn senjata untuk bertahan", function()
    SpawnItem("Senjata")
end)

-- Tombol Makanan
SpawnerSection:NewButton("🍗 Spawn Makanan", "Spawn makanan untuk survival", function()
    SpawnItem("Makanan")
end)

-- BUAT TAB UTILITY
local UtilityTab = Window:NewTab("Utility")
local UtilitySection = UtilityTab:NewSection("Tools")

-- Tombol Collect Items
UtilitySection:NewButton("🧹 Collect Nearby Items", "Kumpulin item di sekitar", function()
    CollectNearbyItems()
end)

-- Tombol Speed Hack
UtilitySection:NewToggle("⚡ Speed Hack", "Jalan lebih cepat", function(state)
    if state then
        HumanoidRootPart.Velocity = HumanoidRootPart.Velocity * 2
    end
end)

-- Tombol Noclip
UtilitySection:NewToggle("👻 Noclip", "Tembus tembok", function(state)
    if state then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

-- BUAT TAB INFO
local InfoTab = Window:NewTab("Info")
local InfoSection = InfoTab:NewSection("About")

InfoSection:NewLabel("🔥 99 NIGHT IN THE FOREST SPAWNER")
InfoSection:NewLabel("👤 Created by: JUNZXSEC")
InfoSection:NewLabel("⚡ Delta Executor Version")
InfoSection:NewLabel("📌 Fitur:")
InfoSection:NewLabel("   • Spawn Kayu")
InfoSection:NewLabel("   • Spawn Besi") 
InfoSection:NewLabel("   • Spawn Perban")
InfoSection:NewLabel("   • Spawn Senjata")
InfoSection:NewLabel("   • Spawn Makanan")
InfoSection:NewLabel("   • Collect Items")
InfoSection:NewLabel("   • Speed Hack")
InfoSection:NewLabel("   • Noclip")

-- Notifikasi awal
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🔥 SCRIPT LOADED",
    Text = "99 Night Forest Spawner by JUNZXSEC",
    Duration = 5
})

-- Auto update karakter kalo mati
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)