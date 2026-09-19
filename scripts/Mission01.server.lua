
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cityObjective = workspace:WaitForChild("CidadeObjetivo")
local baseDelivery = workspace:WaitForChild("BaseEntrega")

local REWARD = 100

local missionEvent = ReplicatedStorage:FindFirstChild("Mission01Event")

if not missionEvent then
    missionEvent = Instance.new("RemoteEvent")
    missionEvent.Name = "Mission01Event"
    missionEvent.Parent = ReplicatedStorage
end

local missionProgress = {}

local function sendProgress(player, state)
    missionEvent:FireClient(player, state, REWARD)
end

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

    if progress
        and not progress.visitedCity
        and not progress.completed then

        progress.visitedCity = true
        sendProgress(player, "return")
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

    sendProgress(player, "completed")
end)

missionEvent.OnServerEvent:Connect(function(player)
    local progress = missionProgress[player]

    if not progress then
        return
    end

    if progress.completed then
        sendProgress(player, "completed")
    elseif progress.visitedCity then
        sendProgress(player, "return")
    else
        sendProgress(player, "explore")
    end
end)
