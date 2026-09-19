
local Players = game:GetService("Players")

local radiationZone = workspace:WaitForChild("RadiationZone")

local DAMAGE = 2
local CHECK_INTERVAL = 2

local function isInsideZone(position)
    local localPosition =
        radiationZone.CFrame:PointToObjectSpace(position)

    local halfSize = radiationZone.Size / 2

    return math.abs(localPosition.X) <= halfSize.X
        and math.abs(localPosition.Y) <= halfSize.Y
        and math.abs(localPosition.Z) <= halfSize.Z
end

while true do
    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character

        if character then
            local rootPart =
                character:FindFirstChild("HumanoidRootPart")

            local humanoid =
                character:FindFirstChildOfClass("Humanoid")

            if rootPart and humanoid
                and humanoid.Health > 0
                and isInsideZone(rootPart.Position) then

                humanoid:TakeDamage(DAMAGE)
            end
        end
    end

    task.wait(CHECK_INTERVAL)
end
