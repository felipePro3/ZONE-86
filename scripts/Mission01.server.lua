
local Players = game:GetService("Players")

local cityObjective = workspace:WaitForChild("CidadeObjetivo")
local baseDelivery = workspace:WaitForChild("BaseEntrega")

local REWARD = 100

local missionProgress = {}

Players.PlayerAdded:Connect(function(player)
    missionProgress[player] = {
        visitedCity = false,
        completed = false
    }

    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local credits = Instance.new("IntValue")
    credits.Name = "Creditos"
    credits.Value = 0
    credits.Parent = leaderstats
end)

Players.PlayerRemoving:Connect(function(player)
    missionProgress[player] = nil
end)

local function getPlayerFromTouch(hit)
    local character = hit:FindFirstAncestorOfClass("Model")

    if not character then
        return nil
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return nil
    end

    return Players:GetPlayerFromCharacter(character)
end

cityObjective.Touched:Connect(function(hit)
    local player = getPlayerFromTouch(hit)

    if not player then
        return
    end

    local progress = missionProgress[player]

    if progress and not progress.completed then
        progress.visitedCity = true
    end
end)

baseDelivery.Touched:Connect(function(hit)
    local player = getPlayerFromTouch(hit)

    if not player then
        return
    end

    local progress = missionProgress[player]

    if not progress
        or not progress.visitedCity
        or progress.completed then
        return
    end

    progress.completed = true

    local leaderstats = player:FindFirstChild("leaderstats")
    local credits = leaderstats
        and leaderstats:FindFirstChild("Creditos")

    if credits then
        credits.Value += REWARD
    end
end)
