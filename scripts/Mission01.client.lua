
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local missionEvent = ReplicatedStorage:WaitForChild("Mission01Event")

local gui = Instance.new("ScreenGui")
gui.Name = "ZONE86MissionGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "MissionPanel"
panel.Size = UDim2.new(0, 310, 0, 165)
panel.Position = UDim2.new(0, 16, 0, 70)
panel.BackgroundColor3 = Color3.fromRGB(21, 27, 34)
panel.BorderSizePixel = 0
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(246, 196, 83)
stroke.Parent = panel

local function makeLabel(name, text, y, height, size)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = UDim2.new(1, -24, 0, height)
    label.Position = UDim2.new(0, 12, 0, y)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = size
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = panel

    return label
end

local header = makeLabel(
    "Header",
    "ZONE-86  |  MISSÃO 01",
    10, 20, 14
)

local title = makeLabel(
    "Title",
    "Reconhecimento da cidade",
    34, 28, 17
)

local status = makeLabel(
    "Status",
    "ÁREA DE EXPLORAÇÃO",
    67, 20, 13
)

local objective = makeLabel(
    "Objective",
    "Vá até o ponto marcado na cidade abandonada.",
    90, 42, 13
)

local footer = makeLabel(
    "Footer",
    "Progresso: 0/2  |  +100 créditos",
    140, 18, 12
)

local function updateMission(state, reward)
    reward = reward or 100

    if state == "explore" then
        panel.BackgroundColor3 = Color3.fromRGB(21, 27, 34)
        stroke.Color = Color3.fromRGB(246, 196, 83)

        status.Text = "ÁREA DE EXPLORAÇÃO"
        status.TextColor3 = Color3.fromRGB(246, 196, 83)

        objective.Text =
            "Vá até o ponto marcado na cidade abandonada."

        footer.Text =
            "Progresso: 0/2  |  +" .. reward .. " créditos"

    elseif state == "return" then
        panel.BackgroundColor3 = Color3.fromRGB(28, 21, 24)
        stroke.Color = Color3.fromRGB(255, 102, 102)

        status.Text = "ALERTA DE CONTENÇÃO"
        status.TextColor3 = Color3.fromRGB(255, 102, 102)

        objective.Text =
            "Reconhecimento concluído. Retorne à base segura."

        footer.Text =
            "Progresso: 1/2  |  +" .. reward .. " créditos"

    elseif state == "completed" then
        panel.BackgroundColor3 = Color3.fromRGB(20, 34, 29)
        stroke.Color = Color3.fromRGB(95, 220, 145)

        status.Text = "MISSÃO CONCLUÍDA"
        status.TextColor3 = Color3.fromRGB(95, 220, 145)

        objective.Text =
            "Você retornou à base e recebeu sua recompensa."

        footer.Text =
            "Progresso: 2/2  |  +" .. reward .. " créditos"
    end
end

missionEvent.OnClientEvent:Connect(updateMission)
missionEvent:FireServer()
