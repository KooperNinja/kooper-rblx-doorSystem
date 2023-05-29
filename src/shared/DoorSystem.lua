local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local DoorEnums = {}
DoorEnums.Status = {
    Open = "open",
    Closed = "closed",
    Opening = "opening",
    Closing = "closing"
}

local DoorSystem = {}

DoorSystem.Doors = {
    {
        name = "MainDoor",
        tweenInfo = {
            time = 3,
            easingStyle = Enum.EasingStyle.Quint,
            easingDirection = Enum.EasingDirection.Out,
            repeatCount = 0,
            delayTime = 0
        },
        goalSettings = {
            {
                pos = Vector3.new(0,0,-10),
            },
            {
                pos = Vector3.new(0,0,10),
            },
            {
                pos = Vector3.new(0,-10,0),
            },
            {
                pos = Vector3.new(0,10,0),
            },
        },
        parts = {},
        tweens = {
            open = {},
            close = {}
        },
        status = DoorEnums.Status.Closed,
    },
    {
        name = "TestDoor",
        tweenInfo = {
            time = 3,
            easingStyle = Enum.EasingStyle.Quint,
            easingDirection = Enum.EasingDirection.Out,
            repeatCount = 0,
            delayTime = 0
        },
        goalSettings = {
            {
                pos = Vector3.new(0,10,0),
            },
            {
                pos = Vector3.new(0,-10,0),
            },

        },
        parts = {},
        tweens = {
            open = {},
            close = {}
        },
        status = DoorEnums.Status.Closed,
    },
}

DoorSystem.Buttons = {}

DoorSystem.DoorModels = Workspace.DoorSystem.Doors
DoorSystem.Buttons = Workspace.DoorSystem.DoorButtons

function DoorSystem:loadDoors()

    for k, door in pairs(self.Doors) do
        local tweenInfoIn = TweenInfo.new(
            door.tweenInfo.time,
            door.tweenInfo.easingStyle,
            door.tweenInfo.easingDirection,
            door.tweenInfo.repeatCount,
            false,
            door.tweenInfo.delayTime
        )
        local tweenInfoOut = TweenInfo.new(
            door.tweenInfo.time,
            door.tweenInfo.easingStyle,
            door.tweenInfo.easingDirection,
            door.tweenInfo.repeatCount,
            false,
            door.tweenInfo.delayTime
        )

        local doorParts = self.DoorModels:FindFirstChild(door.name)
        if doorParts == nil then
            print("Door not found")
            continue
        end

        for kPart, doorPart in doorParts:GetChildren() do
            table.insert(door.parts, doorPart)
            local base = {}
            local basePos = Vector3.new(
                doorPart.Position.x,
                doorPart.Position.y,
                doorPart.Position.z
            )
            base.Position = basePos

            local goal = {}
            local goalPos = Vector3.new(
                doorPart.Position.x + door.goalSettings[kPart].pos.x,
                doorPart.Position.y + door.goalSettings[kPart].pos.y,
                doorPart.Position.z + door.goalSettings[kPart].pos.z
            )
            goal.Position = goalPos

            local tweenOpen = TweenService:Create(doorPart, tweenInfoIn, goal)
            table.insert(door.tweens.open, tweenOpen)
            local tweenClose = TweenService:Create(doorPart, tweenInfoOut, base)
            table.insert(door.tweens.close, tweenClose)
        end

        function door:open()
            if door.status ~= DoorEnums.Status.Closed then return end
            door.status = DoorEnums.Status.Opening
            for ko = 1, #door.parts, 1 do
                door.tweens.open[ko]:Play()
            end
            task.delay(self.tweenInfo.time, function()
                door.status = DoorEnums.Status.Open
            end)
        end

        function door:close()
            if door.status ~= DoorEnums.Status.Open then return end
            door.status = DoorEnums.Status.Closing
            for ko = 1, #door.parts, 1 do
                door.tweens.close[ko]:Play()
            end
            task.delay(self.tweenInfo.time, function()
                door.status = DoorEnums.Status.Closed
            end)
        end

        function door:trigger()
            if door.status == DoorEnums.Status.Open then
                self:close()
            else
                self:open()
            end

        end

    end

    print("Door System Loaded")

end

function DoorSystem:findDoorByName(searchName)
    for k, door in pairs(DoorSystem.Doors) do
        if door.name == searchName then
            return door
        end
    end
    print("Door no found, returning nil")
    return nil
end

function DoorSystem:loadButtons()
    for k,button in self.Buttons:GetChildren() do
        local clickDetec = button:FindFirstChildOfClass("ClickDetector")
        if not clickDetec then return end
        print(1)
        clickDetec.MouseClick:Connect(function()
            for k,name in button.DoorNames:GetChildren() do
                local doorName = name.Value --String Value inside the DoorNames Folder
                local door = self:findDoorByName(doorName)
                if not door then continue end
                door:trigger()
            end
        end)
    end
end



return DoorSystem