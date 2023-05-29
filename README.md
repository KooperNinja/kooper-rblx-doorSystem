# kooper-rblx-doorsystem


## Getting Started
To init the Door System, require the module.

```lua
local doorSystem = require(ReplicatedStorage.Shared.DoorSystem) --Path to the module
```
Then load the doors with:
```lua
doorSystem:loadDoors()
```
And the buttons with:
```lua
doorSystem:loadButtons()()
```

## Add Your Own Doors
To **Add** your own door you start by creating the a folder with your `DoorName` inside the `DoorSystem.Doors` folder in your `Workspace`.

Inside this folder put your DoorParts in a linear order.
**BUILD YOUR DOOR CLOSED!**

Your folder should look like this:

```
DoorSystem
├── DoorButtons
├── Doors
│   ├── YourDoor
│   │   ├── 1
│   │   ├── 2
```

Now you need to reference them inside the module.
Inside the `DoorSystem` file you need to add a new door to the `DoorSystem.Doors` table.
```lua
{
        name = "YourDoor", --Same name as the folder
        tweenInfo = {
            time = 3, -- in seconds | Door will open in that time
            easingStyle = Enum.EasingStyle.Quint,
            easingDirection = Enum.EasingDirection.Out,
            repeatCount = 0,
            delayTime = 0
        },
        goalSettings = {
            {
                pos = Vector3.new(0,0,-10) -- relative displacement to the 1st Door Part
            },
            {
                pos = Vector3.new(0,0,10)  -- relative displacement to the 2nd Door Part
            }
        },
        parts = {}, --will be filled by loadDoors()
        tweens = { --will be filled by loadDoors()
            open = {},
            close = {}
        },
        status = DoorEnums.Status.Closed, --standard, don't change
    }
```
Now you've set up your own door.

## Find a Door
To find a door use the `doorSystem:findDoorByName()` function.

```lua
local door = doorSystem:findDoorByName("YourDoor")
```

## Open a Door
After your found your door you can use the `door:trigger()` function to trigger it:
If closed                   -> it opens,
If open                     -> it closes,
If either opening/closing   -> it does notihing

```lua
local door = doorSystem:findDoorByName("YourDoor")
door:trigger()
```

You can do this manually too by using either
```lua
door:open()
```
or
```lua
door:close()
```

## Working with Buttons
The button feature let's you trigger one or multiple Doors with a Part acting as a Button.

First create a Part inside the `DoorSystem.DoorButtons` folder.
Add a `ClickDetector` to the Part.
Then create a folder inside of the Part called `DoorNames`
Inside of this folder, add ``String Values`` with the Value set to your DoorName.
```
DoorSystem
├── DoorButtons
│   ├── Button
│   │   ├── DoorNames
│   │   │   ├── 1 -> Value: YourDoor
│   │   │   ├── 2 -> Value: OtherDoor
│   │   ├── ClickDetector
├── Doors
```
Now load the Buttons with
```lua
doorSystem:loadButtons()
```