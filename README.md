soulXploit.lua

local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "SoulXploitLogo"

local Logo = Instance.new("ImageLabel", ScreenGui)
Logo.Size = UDim2.new(0, 300, 0, 100)
Logo.Position = UDim2.new(0.5, -150, 0.1, 0) -- centralizado no topo
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://113422439338527"

--[[ 
    ███╗   ███╗████████╗███████╗██╗  ██╗███████╗███████╗
    ████╗ ████║╚══██╔══╝██╔════╝██║  ██║██╔════╝██╔════╝
    ██╔████╔██║   ██║   █████╗  ███████║█████╗  ███████╗
    ██║╚██╔╝██║   ██║   ██╔══╝  ██╔══██║██╔══╝  ╚════██║
    ██║ ╚═╝ ██║   ██║   ███████╗██║  ██║███████╗███████║
    ╚═╝     ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝

    Script: NOT HUB X | Blox Fruits Script
    Criado por: NOT HUB X
]]--

print("NOT HUB X | Script de Blox Fruits Carregado com Sucesso!")

getgenv().SelectedMode = "Melee" -- Altere para: "Melee", "Sword", "Gun", "Blox Fruit"
getgenv().AutoFarmMas = true

function EquipSelectedTool()
    local backpack = game.Players.LocalPlayer.Backpack
    for _, tool in pairs(backpack:GetChildren()) do
        if tool.ToolTip == getgenv().SelectedMode then
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
            break
        end
    end
end

spawn(function()
    while getgenv().AutoFarmMas do
        pcall(function()
            EquipSelectedTool()
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                    local args = {
                        [1] = "Attack",
                        [2] = true
                    }
                    game:GetService("ReplicatedStorage").Remotes.Combat:FireServer(unpack(args))
                end
            end
        end)
        wait(0.1)
    end
end)

getgenv().Settings = {
    AutoFarm = true,
    UseSword = true, -- False para usar fruta
    AutoBeliFruit = true
}

local Replicated = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local function fireSkill(key)
    game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game)
end

-- Detectar em qual Sea você está
function getCurrentSea()
    local placeId = game.PlaceId
    if placeId == 2753915549 then
        return 1
    elseif placeId == 4442272183 then
        return 2
    elseif placeId == 7449423635 then
        return 3
    else
        return 0
    end
end

-- Lista básica de inimigos por Sea (pode ser expandida com mais levels)
local enemies = {
    [1] = {
        {Name="Bandit", Quest="BanditQuest1", Level=10, Pos=CFrame.new(1036, 16, 1547)},
        {Name="Monkey", Quest="JungleQuest", Level=15, Pos=CFrame.new(-1602, 36, 152)},
    },
    [2] = {
        {Name="Swan Pirate", Quest="Area2Quest", Level=775, Pos=CFrame.new(879, 122, 1235)},
        {Name="Factory Staff", Quest="FactoryStaffQuest", Level=800, Pos=CFrame.new(302, 73, -1200)},
    },
    [3] = {
        {Name="Pirate Millionaire", Quest="PiratePortQuest", Level=1500, Pos=CFrame.new(-373, 47, 5567)},
        {Name="Dragon Crew Warrior", Quest="AmazonQuest", Level=1575, Pos=CFrame.new(6141, 29, -1542)},
    }
}

-- Função para pegar alvo
function getTarget()
    local sea = getCurrentSea()
    local level = player.Data.Level.Value
    for i, mob in pairs(enemies[sea] or {}) do
        if level >= mob.Level then
            return mob
        end
    end
    return nil
end

-- Auto Farm de Level
spawn(function()
    while Settings.AutoFarm do
        pcall(function()
            local target = getTarget()
            if target then
                -- Pega quest
                Replicated.Remotes.CommF_:InvokeServer("StartQuest", target.Quest, 1)
                wait(0.5)
                -- Mata o inimigo
                for _, mob in pairs(workspace.Enemies:GetChildren()) do
                    if mob.Name == target.Name and mob:FindFirstChild("HumanoidRootPart") then
                        repeat
                            player.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                            if Settings.UseSword then
                                fireSkill("Z")
                            else
                                fireSkill("X")
                            end
                            wait(0.3)
                        until mob.Humanoid.Health <= 0 or not mob.Parent
                    end
                end
            end
        end)
        wait(1)
    end
end)

-- Auto girar fruta
spawn(function()
    while Settings.AutoBeliFruit do
        pcall(function()
            Replicated.Remotes.CommF_:InvokeServer("GetFruits")
            Replicated.Remotes.CommF_:InvokeServer("BuyFruit", "Random")
        end)
        wait(600) -- Gira a cada 10 min
    end
end)

getgenv().AutoBoss = true
getgenv().UseSword = true -- False para usar fruta

local Replicated = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local bosses = {
    -- Sea 1
    "Gorilla King",
    "Bobby",
    "Yeti",
    "Mob Leader",
    "Vice Admiral",
    "Warden",
    "Swan",
    -- Sea 2
    "Fajita",
    "Don Swan",
    "Jeremy",
    "Smoke Admiral",
    -- Sea 3
    "Stone",
    "Island Empress",
    "Kilo Admiral",
    "Captain Elephant",
    "Beautiful Pirate"
}

-- Ataca com tecla Z/X/C (editar se quiser)
function useAttack()
    local keys = {"Z", "X", "C"}
    for _, key in pairs(keys) do
        game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game)
        wait(0.1)
    end
end

-- Farm loop
spawn(function()
    while getgenv().AutoBoss do
        pcall(function()
            for _, bossName in pairs(bosses) do
                for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                    if enemy.Name == bossName and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                        repeat
                            player.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                            if getgenv().UseSword then
                                useAttack()
                            end
                            wait(0.5)
                        until enemy.Humanoid.Health <= 0 or not enemy.Parent
                    end
                end
            end
        end)
        wait(2)
    end
end)

-- GUI: Auto Farm de Haki, Obs V2 e Raça V4
-- Desenvolvido para executores móveis e PC

-- Biblioteca de UI leve
loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Library = loadstring(game:HttpGet(("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua")))()
local Window = Library.CreateLib("Blox Fruits Auto Farm - V4", "Ocean")

-- Aba principal
local Tab = Window:NewTab("Auto Farm")
local Section = Tab:NewSection("Farm Geral")

-- Auto Haki
Section:NewToggle("Auto Farm Haki", "Upa o Haki batendo em inimigos", function(state)
    getgenv().AutoHaki = state
    if state then
        spawn(function()
            while getgenv().AutoHaki do
                pcall(function()
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                            wait(0.3)
                        end
                    end
                end)
                wait(1)
            end
        end)
    end
end)

-- Auto Observation V2
Section:NewToggle("Auto Farm Obs V2", "Faz Perfect Dodge até liberar Observation V2", function(state)
    getgenv().AutoObsV2 = state
    local dodges = 0
    if state then
        spawn(function()
            while getgenv().AutoObsV2 do
                pcall(function()
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(3, 3, 3)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk", "Activate")
                            wait(0.3)
                            dodges = dodges + 1
                            if dodges >= 500 then
                                getgenv().AutoObsV2 = false
                                Library:Notify("500 Perfect Dodges concluídos!", "Você pode evoluir para Observation V2")
                            end
                        end
                    end
                end)
                wait(0.5)
            end
        end)
    end
end)

-- Auto Mirage + Lua para Raça V4
Section:NewToggle("Auto Mirage Moon", "Vai pra Mirage Island e observa a lua", function(state)
    getgenv().AutoMirageMoon = state
    if state then
        spawn(function()
            while getgenv().AutoMirageMoon do
                pcall(function()
                    local mirage = workspace:FindFirstChild("Mirage Island")
                    if mirage then
                        local top = mirage:FindFirstChild("Top") or mirage:FindFirstChildOfClass("Part")
                        if top then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = top.CFrame + Vector3.new(0, 5, 0)
                        end
                    end
                end)
                wait(5)
            end
        end)
    end
end)

-- GUI criada com sucesso
Library:Notify("Pronto!", "Auto Farm GUI ativado com sucesso.")

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- Função para atacar o Draco
function attackDraco()
    local draco = nil
    for _, obj in pairs(workspace.Enemies:GetChildren()) do
        if obj:FindFirstChild("Humanoid") and obj.Name:lower():find("draco") then
            draco = obj
            break
        end
    end

    if draco and draco:FindFirstChild("HumanoidRootPart") then
        repeat
            pcall(function()
                char.HumanoidRootPart.CFrame = draco.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game) -- Use "Z", "X", "C", ou "V" conforme sua fruta/estilo
            end)
            wait(0.5)
        until not draco or draco.Humanoid.Health <= 0
    end
end

-- Auto Farm loop
while true do
    pcall(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            attackDraco()
        end
    end)
    wait(2)
end

getgenv().AutoSeaEvent = true
getgenv().UseSword = true -- Mude para false se quiser usar fruta

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local vip = game:GetService("VirtualInputManager")

-- Função para atacar
function attack()
    local keys = {"Z", "X", "C"}
    for _, key in pairs(keys) do
        vip:SendKeyEvent(true, key, false, game)
        wait(0.2)
    end
end

-- Detecta e farma todos os tipos de eventos do mar
spawn(function()
    while getgenv().AutoSeaEvent do
        pcall(function()
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if string.find(enemy.Name, "Sea Beast") or string.find(enemy.Name, "Leviathan") or string.find(enemy.Name, "Ship") then
                    if enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                        repeat
                            player.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 40, 0)
                            if getgenv().UseSword then
                                attack()
                            end
                            wait(0.3)
                        until not enemy or enemy.Humanoid.Health <= 0
                    end
                end
            end
        end)
        wait(2)
    end
end)

getgenv().AutoFarmBones = true
getgenv().UseSword = true -- Mude para false se quiser usar fruta

local player = game.Players.LocalPlayer
local enemies = workspace.Enemies
local vinput = game:GetService("VirtualInputManager")

function attack()
    local keys = {"Z", "X", "C"}
    for _, key in ipairs(keys) do
        vinput:SendKeyEvent(true, key, false, game)
        wait(0.2)
    end
end

spawn(function()
    while getgenv().AutoFarmBones do
        pcall(function()
            for _, mob in pairs(enemies:GetChildren()) do
                local valid = mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid")
                local isBoneMob = table.find({
                    "Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"
                }, mob.Name)

                if valid and isBoneMob and mob.Humanoid.Health > 0 then
                    repeat
                        player.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                        if getgenv().UseSword then attack() end
                        wait(0.3)
                    until mob.Humanoid.Health <= 0 or not mob.Parent
                end
            end
        end)
        wait(1)
    end
end)

getgenv().AutoCakePrince = true
getgenv().UseSword = true -- False = fruta

local player = game.Players.LocalPlayer
local enemies = workspace.Enemies
local vinput = game:GetService("VirtualInputManager")

function attack()
    for _, key in pairs({"Z", "X", "C"}) do
        vinput:SendKeyEvent(true, key, false, game)
        wait(0.2)
    end
end

spawn(function()
    while getgenv().AutoCakePrince do
        pcall(function()
            for _, boss in pairs(enemies:GetChildren()) do
                if boss.Name == "Dough King" and boss:FindFirstChild("HumanoidRootPart") and boss.Humanoid.Health > 0 then
                    repeat
                        player.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
                        if getgenv().UseSword then attack() end
                        wait(0.3)
                    until not boss or boss.Humanoid.Health <= 0
                end
            end
        end)
        wait(1)
    end
end)

Section:NewToggle("Auto Farm Baú", "Abre baús automaticamente para pegar itens", function(state)
    getgenv().AutoFarmChest = state
    spawn(function()
        while getgenv().AutoFarmChest do
            pcall(function()
                for _, chest in pairs(workspace:GetChildren()) do
                    if chest.Name == "Chest" and chest:FindFirstChild("HumanoidRootPart") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = chest.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                        if chest:FindFirstChild("ClickDetector") then
                            fireclickdetector(chest.ClickDetector)
                        end
                        wait(1)
                    end
                end
            end)
            wait(2)
        end
    end)
end)

getgenv().AutoV4 = true

local player = game.Players.LocalPlayer
local vinput = game:GetService("VirtualInputManager")
local enemies = workspace.Enemies

-- Função para atacar
function attack()
    for _, key in ipairs({"Z", "X", "C"}) do
        vinput:SendKeyEvent(true, key, false, game)
        wait(0.2)
    end
end

spawn(function()
    while getgenv().AutoV4 do
        pcall(function()
            -- Verifica se a Trial de Raça V4 terminou
            if game.Workspace:FindFirstChild("V4Trial") then
                local trial = game.Workspace.V4Trial
                if trial:FindFirstChild("Status") and trial.Status.Value == "Completed" then
                    -- Matar todos os NPCs restantes da Trial
                    for _, mob in pairs(enemies:GetChildren()) do
                        if mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            player.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                            attack()
                            wait(0.3)
                        end
                    end
                    -- Se precisar ir para outro lugar ou finalizar, adicione o código aqui
                end
            end
        end)
        wait(2)
    end
end)

getgenv().AutoClick = true

spawn(function()
    while getgenv().AutoClick do
        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            wait(0.1) -- Pode diminuir para mais velocidade (ex: 0.05)
        end)
        wait()
    end
end)

getgenv().AutoFindPrehistoric = true

spawn(function()
    while getgenv().AutoFindPrehistoric do
        pcall(function()
            local islands = workspace:IsDescendantOf(workspace) and workspace:GetChildren()
            for _, island in pairs(islands) do
                if island:IsA("Model") and island.Name:find("Prehistoric") then
                    -- Teleportar para a ilha
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = island:GetModelCFrame() + Vector3.new(0, 10, 0)
                    warn("Prehistoric Island encontrada!")
                    getgenv().AutoFindPrehistoric = false
                    break
                end
            end
        end)
        wait(5)
    end
end)

getgenv().AutoKillGolem = true

spawn(function()
    while getgenv().AutoKillGolem do
        pcall(function()
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy.Name:lower():find("golem") and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
                    hrp.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                    
                    -- Fast Attack
                    local args = {
                        [1] = "Attack",
                        [2] = true
                    }
                    game:GetService("ReplicatedStorage").Remotes.Combat:FireServer(unpack(args))
                end
            end
        end)
        wait(0.1)
    end
end)

local function TeleportToSea(seaNumber)
    local args = {
        [1] = "TravelSea",
        [2] = seaNumber
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

-- Exemplo: Teleportar para Sea 2
TeleportToSea(2)

-- Sea 1 = 1
-- Sea 2 = 2
-- Sea 3 = 3

getgenv().AutoFarmMaestria = true

spawn(function()
    while getgenv().AutoFarmMaestria do
        pcall(function()
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                    -- Teleporta para o mob
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)

                    -- Ataca com espada ou arma equipada
                    local args = {
                        [1] = "Attack",
                        [2] = true
                    }
                    game:GetService("ReplicatedStorage").Remotes.Combat:FireServer(unpack(args))
                end
            end
        end)
        wait(0.1)
    end
end)

