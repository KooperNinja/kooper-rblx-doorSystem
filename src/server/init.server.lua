local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


Players.PlayerAdded:Connect(function (player)
    print(player.Name, "joined!")
end)


local doorSystem = require(ReplicatedStorage.Shared.DoorSystem)

doorSystem:loadDoors()
doorSystem:loadButtons()

local door = doorSystem:findDoorByName("TestDoor")

for k,part in pairs(door.parts) do
    part.Touched:Connect(function(otherPart)
        if not otherPart.parent:FindFirstChild("Humanoid") then return end
        door:trigger()
    end)
end

