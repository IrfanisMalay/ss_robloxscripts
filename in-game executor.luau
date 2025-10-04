-- One-script solution: all players get a GUI with a button
-- When clicked, the server inserts a Script into Workspace

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Make RemoteEvent (for communication)
local eventName = "InsertScriptEvent"
local insertEvent = ReplicatedStorage:FindFirstChild(eventName)
if not insertEvent then
    insertEvent = Instance.new("RemoteEvent")
    insertEvent.Name = eventName
    insertEvent.Parent = ReplicatedStorage
end

-- Give GUI with LocalScript to each player
local function giveGui(player)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "InsertScriptGui"
    screenGui.ResetOnSpawn = false

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Position = UDim2.new(0.5, -100, 0.5, -25)
    button.Text = "Insert Script"
    button.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    button.Parent = screenGui

    -- LocalScript that fires the RemoteEvent
    local localScript = Instance.new("LocalScript")
    localScript.Source = [[
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local insertEvent = ReplicatedStorage:WaitForChild("]] .. eventName .. [[")

        local button = script.Parent
        button.MouseButton1Click:Connect(function()
            insertEvent:FireServer()
        end)
    ]]
    localScript.Parent = button

    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Server listens for event and inserts script into Workspace
insertEvent.OnServerEvent:Connect(function(player)
    local newScript = Instance.new("Script")
    newScript.Name = "InsertedScript"
    newScript.Source = [[
        print("Hello! This Script was inserted by ]] .. player.Name .. [[.")
    ]]
    newScript.Parent = workspace
end)
