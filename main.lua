-- Configurações do Script
local autoFarmEnabled = false
local autoStatsEnabled = false
local bossFarmEnabled = false

-- Referências para os botões da GUI
local autoFarmToggle = script.Parent:WaitForChild("AutoFarmButton") -- Botão para ativar/desativar o auto-farm
local autoStatsToggle = script.Parent:WaitForChild("AutoStatsButton") -- Botão para ativar/desativar o auto-stats
local bossFarmToggle = script.Parent:WaitForChild("BossFarmButton") -- Botão para ativar/desativar o boss farm

-- Função para encontrar o inimigo mais próximo
local function findClosestEnemy()
    local closestEnemy = nil
    local shortestDistance = math.huge

    for _, enemy in pairs(game.Workspace:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") then
            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                closestEnemy = enemy
                shortestDistance = distance
            end
        end
    end

    return closestEnemy
end

-- Função para ativar o auto-farm
local function startAutoFarm()
    while autoFarmEnabled do
        local enemy = findClosestEnemy()
        if enemy then
            -- Mover o personagem até o inimigo
            game.Players.LocalPlayer.Character.Humanoid:MoveTo(enemy.HumanoidRootPart.Position)

            -- Usar habilidade no inimigo (supondo que o nome da habilidade seja "Ataque")
            game.Players.LocalPlayer.Character:FindFirstChild("Ataque"):Activate()

            wait(1) -- Espera um segundo antes de procurar outro inimigo
        end
    end
end

-- Função para distribuir os pontos de habilidade
local function distributeStats()
    if game.Players.LocalPlayer.Stats.PontosDeHabilidade > 0 then
        -- Distribui os pontos em Força (exemplo)
        game.Players.LocalPlayer.Stats.Forca.Value = game.Players.LocalPlayer.Stats.Forca.Value + 1
        game.Players.LocalPlayer.Stats.PontosDeHabilidade = game.Players.LocalPlayer.Stats.PontosDeHabilidade - 1
    end
end

-- Função para ativar o auto-stats
local function startAutoStats()
    while autoStatsEnabled do
        distributeStats()
        wait(5) -- Aguarda 5 segundos antes de distribuir mais pontos
    end
end

-- Função para encontrar o boss
local function findBoss()
    local boss = nil
    for _, enemy in pairs(game.Workspace:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Name == "Boss" then
            boss = enemy
            break
        end
    end
    return boss
end

-- Função para ativar o boss farm
local function startBossFarm()
    while bossFarmEnabled do
        local boss = findBoss()
        if boss then
            -- Mover o personagem até o boss
            game.Players.LocalPlayer.Character.Humanoid:MoveTo(boss.HumanoidRootPart.Position)

            -- Usar habilidades potentes para derrotar o boss
            game.Players.LocalPlayer.Character:FindFirstChild("HabilidadePoderosa"):Activate()

            wait(2) -- Espera 2 segundos antes de checar novamente
        end
    end
end

-- Conectar o botão do Auto-Farm à função
autoFarmToggle.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    if autoFarmEnabled then
        startAutoFarm()
    end
end)

-- Conectar o botão do Auto-Stats à função
autoStatsToggle.MouseButton1Click:Connect(function()
    autoStatsEnabled = not autoStatsEnabled
    if autoStatsEnabled then
        startAutoStats()
    end
end)

-- Conectar o botão do Boss Farm à função
bossFarmToggle.MouseButton1Click:Connect(function()
    bossFarmEnabled = not bossFarmEnabled
    if bossFarmEnabled then
        startBossFarm()
    end
end)
