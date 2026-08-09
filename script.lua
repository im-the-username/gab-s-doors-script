-- Gabrieltod112's Doors :3  (FULL FIXED + Screech Delete + FOV + Third Person + Delete Halt + Anti Eyes)
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

plr.CharacterAdded:Connect(function(newChar)
    char = newChar
end)

-- ==========================================
-- CONSOLE ASCII ART
-- ==========================================
print([[
%%%%%%%%%%%%%%##=+%%%%%@@@@@@@@@@@@%%#%@@@@%%%%#%*==%%#%%%%@@@@@@@@%#%%#%@@@@@@@@@%%%%###%%%%%%%%%%%
%*%%%%%%%%%%####%%%%###%#%@@@@@@@@@@@%@@@@%%%%%%+-.:*%%%%%%@@@##%#%@@@@%@@%%@@@@@@%%%%%%###*+=*%%%%%
%%%%%*%%%%###%%%%%%%%@##%@@@@@@@@%#@@@@@@@%%%%%+:...=%%%%%**@@@@@%%@%@@@@@@@@@@@@%%%%%%#+=:...*%%%%%
%%%%%%%%%#+*##%#+%%%%%@%%@@%%@@@@@%##@@@@@%#%#+:....:+%%%%#%@@@@@@@@@@@@@@@@@@@@%%%#*=-.......*%%%%%
%%%%%%%##*++%%%%%%%%%%%%@%+:.+%@@@@@@@@@@@@%#=.......:*%%%%@@@@@@@@@@@@@@@@@@@@%*+-:..........+#%%%%
%%%%%%##%%%%%%%%%#*#%%%#=.-*:-%##@@%*#%@@%%#=.........-*%%@@@@@@@@@@@@@@@@@@%*=-..............=##%%%
%%%%##%*+.-#%%%%%%%%%*:.+#*#=:#@@@@@@@@@@%*=...........=%%@@%%@@@@@@@@@@@%#+-.........:..==...-*%%%%
%%%####=.++.=#%%%%%%#.-#%%%%*.*@@@%#%%*%%#=............:+%%@@@@@@@@@@@%#+-..........::.:+==....=####
%%##%%*.*%%#:.*%%%%%%#-.*%%%#:=*#%%%%%%%#+:..............*%%%%%%@@@%#+-...........::::+=--=....:+%##
%#####.-%%#%%*:.*#+%%*%*.:#%%-:%%%%%%%%#=:...............:+#%%%%%%*=...............:=+----=:...:=#%#
%%%%%+.#%%%%%%%*.:*%%%*##=.*%+.*%%%%%%%+:.......::.........-*%%%*=................-+------=:...:-*%%
%%%%%:-%%%%%%#*%%*..*%%%%%*.=*:=%%%%%%+:....::-=++=-:....:::-=**-...............:+=-------=:...::*%%
%%%%#.+@%##%%%%%%%%*:.++#%#*::=:#%%%%*-:::=+=:................:=...............-+---------=-...::+@@
%%%@*.*@@@%%%%%%%%%%%*:.+###+-..*%%%*-:=+==-:................................:+=----------==...::+@@
%%@@*.*%@@@@%%%%%%%%%%#*::*%%%+.=%%#=::::::=:................................=-------------+...::+@@
@@@@#.+###########%%%##%%*::#%%:-%#=:::::=:.................................-=-------------+...::*@@
@@@#%+----------::...::-==+=.-#%%%+::..-=:....................................:=+=---------=...::*@@
@@@@@@@@@@@%#%%@%%%%%####*+-:.=%%#-:::=--=:.......................................:-=-----==...:-*@@
@@@@@@@@@@@@@@@%%%%%%%%%%%%%%%%%%+:::++=+::........................................=------==...:=#@@
@@@@@@@@@%%@%%%%%%%%%%%@@%%%%%%%%+::--:=-.........................................==------=-...:+%@@
%@@@@@@@#+*#%%%%%%%%%%@@%%@@@%%%#=.::::=............................................-+=---=:.::-*@@@
@%*%@@@@@@%+=:=+*%%%%%@@@@@@@@@@#-....=:..............................................:=-=-..::+%@@@
@@@@@%%@@@@@%+-..:=+%%@@@@@@@%%@#:...:+:.............................................-=-=:..::=#%@@@
%%%@@%%@@@@@@%+:....:+#@@@**%%=:--...-+...=-+==:..............:==-+++++-..............-=:..::+#%%@@@
%%%%%%%%%%%%%%#=......-+%@%=:+*=.....-=.=:.:++++=............=:..-++++++-..................:+%%%%%%%
%%%%%%%%%%%%%%#=........=*%#::-+=....-=::..=+++++................-++++++=................:=+*++++*%%
%%%%%%%%%%%%%%#=.........:+*-:::=+:=::+:...++++++:...............-+++++++...............:::=-:=*%%%%
%%%%%%%%%%%%%%*-...........-=::::-++===-...++++++:...............-++++++=...........-:::-===-=#%%%%%
%%%%%%%%%%%%%%+:.............::::::+:.:=...++++++:...............=++++++=............:::.::++#%%%%%%
%%%%%%%%%%%%%+-:...............::::-+::=...-++++=................:++++++:................:-*%%%%%%%%
%%%%%%%%%%%%#=:...............-++=+=-::=:....:-:...................::..................::=*%%%%%%%%%
%%%@@@@@@@@%=::...::...........:=......=-.............................................:=+%@%%%@@@%%%
@@@@@@@@@@%+-:=-.....--....=+===++:....=-....:-===-.....................................:---=%@@@%%%
@@@@@@@@@@*--=::+-:..-++:+--+==+=.=-:::+.......=:.......................................:::=#@%%%%%%
@@@@@@@@@#=:-::=:......=+:+-.....=:=+=-=..............................................:::-+%@%%%%%%%
@@@@@@@@%=::=::+:..::::-+==::....:==+=::=:..........................................:::-+#%%%%%%%%%%
@@@@@@@%+:::-=:+------::++---::::-=+###***=:::..................................:::::=+*##**#%%%%%%%
@@@@@@%*+=:-=+-:+-:::::-++::-----==*########*=-:::::..:===-===:.........::::::::::-+*##########%%%%@
@@@@@@*=..=...==-=:..:--=:=:::::==+++++*#######*+=-:::::::::::::::::-:..:=-::--=+*############%%%%@@
@@@@@%+:.==....-+::==-.....====-:+=...-++##########***++++++++++****+--:::=+##################%@@@@@
@@@@%+:..==-:::-+=.............:+=:....=+*###############%%%############******################%@@@@@
@@@@*+:..-=:::::==....:-====-:..+------==+#######*####%%########################################%@@@
@@@#=:+:..=-:::=-..:==.......:+:-=::::-==*#***#####%###********#################%%%%#:+%%%%####+-#%@
%%%+::-=:..-++:..::+:..........=-:++++--+%##****######*********##############%######+=:*#####%-+:*#%
%%*-::.:+::......-+:..::::::::::==....-+##%##****#########################%%###*****==*:--+++:*#:*#%
%#=:::...=-:....:+--::::--------:=:..=*####%###*****###################%%####*******=+**##########%%
#+-:::....:-:...-=------------:::--.=#######%%###*****##############%%#######****+*==+*-*****==*%%%%
#+::::.....:-:..:+-::::::::::...:=-+%####**###%%################%%##############**====****++*###%%%@
#=::::......--:..=-:::::-=:-=====-+#%####*****###%%%######%%%#############%%#####***+:---=====*#%%%@
#-::::.......--:::==--==:-=:-=:::+##%#####*******#########################%#-+-+##*#+=*#########%%%%
%=:::::.......-=:.::::.....:+-:.-*##%#########**************+++****#######%++##==###+=#*#*##*###%%%%
%+-:::::.......:-...........=::.:+##%##########**+-:..:::::........:-=+*####+=**=*##=+###**####%%%%%
%%+:::::::.....--.........:=-....:=+########*+===..:+=:...:-===............::-+#*-*#-*#########%%%%%
%%%+-:::::::::-=:..................:++######+-:+..:+:...:==:................:::+#===+#########%%%%%%
%%%%*=:::::::::=:.................::+*######*-:=:::+...:=-....................:-*############%%%%%%%
]])

local Window = Rayfield:CreateWindow({
    Name = "Gabrieltod112's Doors",
    LoadingTitle = "LOADINGGgg Miguel's",
    LoadingSubtitle = "You aren't soupused to read this.",
    ToggleUIKeybind = "K",
    ConfigurationSaving = { Enabled = false, FileName = "gab's_Doors" }
})

local ESPTab = Window:CreateTab("ESP", nil)
local MiscTab = Window:CreateTab("Misc", nil)
local ConfigTab = Window:CreateTab("Config", nil)
local InfoTab = Window:CreateTab("Info", nil)

local flags = {
    doorESP = false, espkeys = false, espitems = false, espbooks = false,
    esprush = false, esplocker = false, espchest = false, espgold = false,
    esphumans = false, hintrush = false, getcode = false, draweraura = false,
    espfigure = false, fullbright = false, instantdoor = false,
    espsnare = false, espfuse = false, espgenerator = false, espanchor = false,
    espgrumble = false, espqueen = false, speedEnabled = false,
    deleteScreech = false,
    deleteHalt = false,
    antiEyes = false,
}

local goldespvalue = 0
local currentSpeed = 16
local doorScanInterval = 3
local heavyScanInterval = 2.8
local currentFOV = 70

local esptable = {
    doors = {}, keys = {}, items = {}, books = {}, entity = {},
    lockers = {}, chests = {}, gold = {}, people = {}, figure = {},
    snares = {}, fuses = {}, generators = {}, anchors = {}, grumbles = {}, queens = {},
}

local entitynames = {
    "RushMoving", "AmbushMoving", "ScreechMoving",
    "HideMoving", "TimothyMoving", "DupeMoving",
    "FloorMoving", "FigureMoving", "SeekMoving",
    "HaltMoving", "Eyes", "A-60", "A60", "A-120", "A120",
}

local function hasESP(obj)
    if not obj then return true end
    return obj:GetAttribute("_KuromiESP") == true
        or obj:FindFirstChild("_KuromiESP_H") ~= nil
end

local function markESP(obj)
    if obj then
        pcall(function() obj:SetAttribute("_KuromiESP", true) end)
    end
end

local function clearMark(obj)
    if obj then
        pcall(function() obj:SetAttribute("_KuromiESP", nil) end)
    end
end

local function esp(target, color, labelPart, labelText)
    local highlights, billboards, marked = {}, {}, {}

    local function highlightInst(inst)
        if not inst or not inst.Parent or hasESP(inst) then return end
        local h = Instance.new("Highlight")
        h.Name = "_KuromiESP_H"
        h.Adornee = inst
        h.FillColor = color
        h.OutlineColor = color
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.Parent = inst
        markESP(inst)
        table.insert(highlights, h)
        table.insert(marked, inst)
    end

    if typeof(target) == "table" then
        for _, part in pairs(target) do
            highlightInst(part)
        end
    else
        highlightInst(target)
        if target then table.insert(marked, target) end
    end

    if labelPart and labelPart.Parent and not labelPart:FindFirstChild("_KuromiESP_BB") then
        local bb = Instance.new("BillboardGui")
        bb.Name = "_KuromiESP_BB"
        bb.Adornee = labelPart
        bb.Size = UDim2.fromScale(5, 2)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.fromScale(1, 1)
        lbl.BackgroundTransparency = 1
        lbl.TextScaled = true
        lbl.Text = labelText or ""
        lbl.TextColor3 = color
        lbl.Font = Enum.Font.GothamBold
        lbl.Parent = bb
        bb.Parent = labelPart
        table.insert(billboards, bb)
    end

    local handle = {}
    function handle.delete()
        for _, h in pairs(highlights) do
            if h and h.Parent then h:Destroy() end
        end
        for _, bb in pairs(billboards) do
            if bb and bb.Parent then bb:Destroy() end
        end
        for _, obj in pairs(marked) do
            clearMark(obj)
        end
    end
    return handle
end

-------------------------------------------------
-- DOOR ESP (reliable)
-------------------------------------------------
local doorESPHandles = {}

local function clearDoorESP()
    for door, handle in pairs(doorESPHandles) do
        if handle and handle.delete then
            pcall(handle.delete)
        end
        if door and door.Parent then
            clearMark(door)
            local h = door:FindFirstChild("_KuromiESP_H")
            if h then h:Destroy() end
            local bb = door:FindFirstChild("_KuromiESP_BB")
            if bb then bb:Destroy() end
        end
    end
    table.clear(doorESPHandles)
end

task.spawn(function()
    while true do
        if flags.doorESP then
            local rooms = Workspace:FindFirstChild("CurrentRooms")
            if rooms then
                for _, room in pairs(rooms:GetChildren()) do
                    local door = room:FindFirstChild("Door") or room:FindFirstChild("RoomExit")
                    if door and not hasESP(door) and not doorESPHandles[door] then
                        markESP(door)

                        local h = Instance.new("Highlight")
                        h.Name = "_KuromiESP_H"
                        h.Adornee = door
                        h.FillColor = Color3.fromRGB(0, 255, 0)
                        h.OutlineColor = Color3.fromRGB(0, 255, 0)
                        h.FillTransparency = 0.5
                        h.OutlineTransparency = 0
                        h.Parent = door

                        local roomNum = tonumber(room.Name)
                        local bb = nil
                        if roomNum then
                            local adornee = door.PrimaryPart or door:FindFirstChildWhichIsA("BasePart")
                            if adornee then
                                bb = Instance.new("BillboardGui")
                                bb.Name = "_KuromiESP_BB"
                                bb.Adornee = adornee
                                bb.Size = UDim2.fromScale(4, 2)
                                bb.StudsOffset = Vector3.new(0, 3, 0)
                                bb.AlwaysOnTop = true
                                local lbl = Instance.new("TextLabel")
                                lbl.Size = UDim2.fromScale(1, 1)
                                lbl.BackgroundTransparency = 1
                                lbl.TextScaled = true
                                lbl.Text = tostring(roomNum + 1)
                                lbl.TextColor3 = Color3.fromRGB(0, 255, 0)
                                lbl.Font = Enum.Font.GothamBold
                                lbl.Parent = bb
                                bb.Parent = door
                            end
                        end

                        local handle = {
                            delete = function()
                                if h and h.Parent then h:Destroy() end
                                if bb and bb.Parent then bb:Destroy() end
                                clearMark(door)
                            end
                        }
                        doorESPHandles[door] = handle
                    end
                end
            end
        else
            clearDoorESP()
        end
        task.wait(doorScanInterval)
    end
end)

ESPTab:CreateToggle({
    Name = "ESP Doors",
    CurrentValue = false,
    Flag = "esp_door",
    Callback = function(v)
        flags.doorESP = v
        if not v then clearDoorESP() end
    end
})

-------------------------------------------------
-- SHARED HEAVY SCANNER
-------------------------------------------------
task.spawn(function()
    while true do
        local anyHeavy = flags.espkeys or flags.espsnare or flags.espfuse or flags.espgenerator
            or flags.espanchor or flags.espgrumble or flags.espqueen or flags.espfigure

        if anyHeavy then
            local rooms = Workspace:FindFirstChild("CurrentRooms")

            if flags.espfigure then
                local function tryFigure(v)
                    if not v or not v:IsA("Model") or hasESP(v) then return end
                    local n = v.Name
                    if n == "Figure" or n == "FigureRig" or n == "FigureRagdoll"
                        or n == "FigureMoving" or n:find("Figure") then

                        local part = v:FindFirstChild("Hitbox")
                            or v.PrimaryPart
                            or v:FindFirstChild("Torso")
                            or v:FindFirstChild("Root")
                            or v:FindFirstChildWhichIsA("BasePart")

                        if part then
                            local h = esp(v, Color3.fromRGB(255, 25, 25), part, "Figure")
                            table.insert(esptable.figure, h)
                        end
                    end
                end

                if rooms then
                    for _, room in pairs(rooms:GetChildren()) do
                        if room.Name == "50" or room.Name == "100" then
                            local setup = room:FindFirstChild("FigureSetup")
                            if setup then
                                local rig = setup:FindFirstChild("FigureRig")
                                    or setup:FindFirstChild("FigureRagdoll")
                                    or setup:FindFirstChild("Figure")
                                if rig then tryFigure(rig) end
                            end
                        end
                    end
                end

                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") then
                        tryFigure(v)
                    end
                end
            end

            if rooms then
                for _, room in pairs(rooms:GetChildren()) do
                    for _, v in pairs(room:GetDescendants()) do
                        if not v:IsA("Model") or hasESP(v) then continue end

                        if flags.espkeys then
                            if v.Name == "KeyObtain" then
                                local hitbox = v:FindFirstChild("Hitbox")
                                if hitbox then
                                    local parts = {}
                                    for _, p in pairs(hitbox:GetChildren()) do
                                        if p:IsA("BasePart") and p.Name ~= "PromptHitbox" then
                                            table.insert(parts, p)
                                        end
                                    end
                                    if #parts > 0 then
                                        local h = esp(parts, Color3.fromRGB(90, 255, 40), hitbox, "Key")
                                        markESP(v)
                                        table.insert(esptable.keys, h)
                                    end
                                end
                            elseif v.Name == "LeverForGate" then
                                local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    local h = esp(v, Color3.fromRGB(90, 255, 40), part, "Lever")
                                    table.insert(esptable.keys, h)
                                end
                            end
                        end

                        if flags.espsnare and v.Name == "Snare" then
                            local part = v:FindFirstChild("Hitbox") or v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                            if part then
                                local h = esp(v, Color3.fromRGB(255, 0, 0), part, "Snare")
                                table.insert(esptable.snares, h)
                            end
                        end

                        if flags.espfuse and (v.Name == "Fuse" or v.Name == "FuseObtain" or v.Name:find("Fuse")) then
                            local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart") or v:FindFirstChild("Hitbox")
                            if part then
                                local h = esp(v, Color3.fromRGB(255, 170, 0), part, "Fuse")
                                table.insert(esptable.fuses, h)
                            end
                        end

                        if flags.espgenerator and (v.Name == "Generator" or v.Name:find("Generator") or v.Name == "LiveGenerator") then
                            local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart") or v:FindFirstChild("Hitbox")
                            if part then
                                local h = esp(v, Color3.fromRGB(0, 200, 255), part, "Generator")
                                table.insert(esptable.generators, h)
                            end
                        end

                        if flags.espanchor and (v.Name == "Anchor" or v.Name:find("Anchor")) then
                            local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                            if part then
                                local h = esp(v, Color3.fromRGB(255, 100, 255), part, "Anchor")
                                table.insert(esptable.anchors, h)
                            end
                        end
                    end
                end
            end

            if flags.espgrumble or flags.espqueen then
                local function tryGrumble(v)
                    if not v:IsA("Model") or hasESP(v) then return end
                    local n = v.Name:lower()

                    if flags.espgrumble and (n == "grumbo" or n == "grumble" or n:find("grumbo") or n:find("grumble"))
                        and not n:find("queen") then
                        local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local h = esp(v, Color3.fromRGB(255, 80, 80), part, "Grumble")
                            table.insert(esptable.grumbles, h)
                        end
                    end

                    if flags.espqueen and (n:find("queen") and (n:find("grumbo") or n:find("grumble"))) then
                        local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local h = esp(v, Color3.fromRGB(255, 0, 150), part, "Queen Grumble")
                            table.insert(esptable.queens, h)
                        end
                    end
                end

                if rooms then
                    for _, room in pairs(rooms:GetChildren()) do
                        for _, v in pairs(room:GetDescendants()) do
                            tryGrumble(v)
                        end
                    end
                end

                for _, v in pairs(Workspace:GetChildren()) do
                    tryGrumble(v)
                end
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") then
                        tryGrumble(v)
                    end
                end
            end
        end
        task.wait(heavyScanInterval)
    end
end)

local function makeHeavyToggle(name, flagName, tableName)
    ESPTab:CreateToggle({
        Name = name,
        CurrentValue = false,
        Flag = "esp_" .. flagName,
        Callback = function(Value)
            flags[flagName] = Value
            if not Value then
                for _, h in pairs(esptable[tableName]) do
                    if h and h.delete then h.delete() end
                end
                table.clear(esptable[tableName])
            end
        end
    })
end

makeHeavyToggle("ESP Keys/Levers", "espkeys", "keys")
makeHeavyToggle("ESP Snares", "espsnare", "snares")
makeHeavyToggle("ESP Fuses", "espfuse", "fuses")
makeHeavyToggle("ESP Generators", "espgenerator", "generators")
makeHeavyToggle("ESP Anchors", "espanchor", "anchors")
makeHeavyToggle("ESP Grumbles", "espgrumble", "grumbles")
makeHeavyToggle("ESP Queen Grumble", "espqueen", "queens")
makeHeavyToggle("ESP Figure (Figure)", "espfigure", "figure")

-------------------------------------------------
-- EVENT-BASED ESPs
-------------------------------------------------
ESPTab:CreateToggle({
    Name = "ESP Items",
    CurrentValue = false,
    Flag = "esp_items",
    Callback = function(Value)
        flags.espitems = Value
        if not Value then
            for _, v in pairs(esptable.items) do if v and v.delete then v.delete() end end
            table.clear(esptable.items)
            return
        end
        local function check(v)
            if v:IsA("Model") and (v:GetAttribute("Pickup") or v:GetAttribute("PropType")) and not hasESP(v) then
                local part = v:FindFirstChild("Handle") or v:FindFirstChild("Prop") or v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                if part then
                    local h = esp(v, Color3.fromRGB(160, 190, 255), part, v.Name)
                    table.insert(esptable.items, h)
                end
            end
        end
        local function setup(room)
            local assets = room:FindFirstChild("Assets")
            if not assets then return end
            local conn = assets.DescendantAdded:Connect(function(v) if flags.espitems then check(v) end end)
            for _, v in pairs(assets:GetDescendants()) do check(v) end
            task.spawn(function()
                repeat task.wait() until not flags.espitems
                conn:Disconnect()
            end)
        end
        local rooms = Workspace:FindFirstChild("CurrentRooms")
        if rooms then
            local addconn = rooms.ChildAdded:Connect(function(r) if flags.espitems then setup(r) end end)
            for _, r in pairs(rooms:GetChildren()) do setup(r) end
            task.spawn(function()
                repeat task.wait() until not flags.espitems
                addconn:Disconnect()
            end)
        end
    end
})

ESPTab:CreateToggle({
    Name = "ESP Breakers/Books",
    CurrentValue = false,
    Flag = "esp_books",
    Callback = function(Value)
        flags.espbooks = Value
        if not Value then
            for _, v in pairs(esptable.books) do if v and v.delete then v.delete() end end
            table.clear(esptable.books)
            return
        end
        local function check(v)
            if v:IsA("Model") and (v.Name == "LiveHintBook" or v.Name == "LiveBreakerPolePickup") and not hasESP(v) then
                local label = (v.Name == "LiveHintBook") and "Book" or "Breaker"
                local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                local h = esp(v, Color3.fromRGB(160, 190, 255), part, label)
                table.insert(esptable.books, h)
            end
        end
        local function setup(room)
            if room.Name ~= "50" and room.Name ~= "100" then return end
            local conn = room.DescendantAdded:Connect(function(v) if flags.espbooks then check(v) end end)
            for _, v in pairs(room:GetDescendants()) do check(v) end
            task.spawn(function()
                repeat task.wait() until not flags.espbooks
                conn:Disconnect()
            end)
        end
        local rooms = Workspace:FindFirstChild("CurrentRooms")
        if rooms then
            local addconn = rooms.ChildAdded:Connect(function(r) if flags.espbooks then setup(r) end end)
            for _, r in pairs(rooms:GetChildren()) do setup(r) end
            task.spawn(function()
                repeat task.wait() until not flags.espbooks
                addconn:Disconnect()
            end)
        end
    end
})

ESPTab:CreateToggle({
    Name = "ESP Entities (Rush, Ambush..)",
    CurrentValue = false,
    Flag = "esp_entities",
    Callback = function(Value)
        flags.esprush = Value
        if not Value then
            for _, v in pairs(esptable.entity) do if v and v.delete then v.delete() end end
            table.clear(esptable.entity)
            return
        end

        local function tryESP(v)
            if flags.esprush and table.find(entitynames, v.Name) and not hasESP(v) then
                task.wait(0.1)
                if not v.Parent then return end
                local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                local h = esp(v, Color3.fromRGB(255, 25, 25), part, v.Name:gsub("Moving", ""))
                table.insert(esptable.entity, h)
            end
        end

        for _, v in pairs(Workspace:GetChildren()) do
            tryESP(v)
        end

        local addconn = Workspace.ChildAdded:Connect(function(v)
            if flags.esprush then tryESP(v) end
        end)

        task.spawn(function()
            repeat task.wait() until not flags.esprush
            addconn:Disconnect()
        end)
    end
})

ESPTab:CreateToggle({
    Name = "ESP Closets/Lockers",
    CurrentValue = false,
    Flag = "esp_lockers",
    Callback = function(Value)
        flags.esplocker = Value
        if not Value then
            for _, v in pairs(esptable.lockers) do if v and v.delete then v.delete() end end
            table.clear(esptable.lockers)
            return
        end

        local function check(v)
            if not v:IsA("Model") or hasESP(v) then return end

            local n = v.Name
            local label = nil

            if n == "Wardrobe" then
                label = "Closet"
            elseif n == "Rooms_Locker" or n == "Rooms_Locker_Fridge" then
                label = "Locker"
            elseif n == "Locker" or n == "IronLocker" or n == "MinesLocker" then
                label = "Locker"
            elseif n == "ToolShed" or n == "Toolshed" or n == "Cupboard" then
                label = "Toolshed"
            elseif n == "Dumpster" then
                label = "Dumpster"
            elseif n == "CircularVent" then
                label = "Vent"
            elseif v:FindFirstChild("HiddenPlayer") then
                label = "Hide Spot"
            end

            if label then
                local part = v.PrimaryPart or v:FindFirstChild("Main") or v:FindFirstChildWhichIsA("BasePart")
                if part then
                    local h = esp(v, Color3.fromRGB(145, 100, 25), part, label)
                    table.insert(esptable.lockers, h)
                end
            end
        end

        local function setup(room)
            local conn = room.DescendantAdded:Connect(function(v)
                if flags.esplocker then check(v) end
            end)
            task.spawn(function()
                for _, v in pairs(room:GetDescendants()) do
                    if not flags.esplocker then break end
                    check(v)
                    if _ % 80 == 0 then task.wait() end
                end
            end)
            task.spawn(function()
                repeat task.wait() until not flags.esplocker
                conn:Disconnect()
            end)
        end

        local rooms = Workspace:FindFirstChild("CurrentRooms")
        if rooms then
            local addconn = rooms.ChildAdded:Connect(function(r)
                if flags.esplocker then setup(r) end
            end)
            for _, r in pairs(rooms:GetChildren()) do
                setup(r)
            end
            task.spawn(function()
                repeat task.wait() until not flags.esplocker
                addconn:Disconnect()
            end)
        end
    end
})

ESPTab:CreateToggle({
    Name = "ESP Chests",
    CurrentValue = false,
    Flag = "esp_chests",
    Callback = function(Value)
        flags.espchest = Value
        if not Value then
            for _, v in pairs(esptable.chests) do if v and v.delete then v.delete() end end
            table.clear(esptable.chests)
            return
        end
        local function check(v)
            if not v:IsA("Model") or hasESP(v) then return end
            if v.Name == "ChestBox" then
                local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                local h = esp(v, Color3.fromRGB(205, 120, 255), part, "Chest")
                table.insert(esptable.chests, h)
            elseif v.Name == "ChestBoxLocked" then
                local part = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                local h = esp(v, Color3.fromRGB(255, 120, 205), part, "Locked Chest")
                table.insert(esptable.chests, h)
            end
        end
        local function setup(room)
            local conn = room.DescendantAdded:Connect(function(v) if flags.espchest then check(v) end end)
            for _, v in pairs(room:GetDescendants()) do check(v) end
            task.spawn(function()
                repeat task.wait() until not flags.espchest
                conn:Disconnect()
            end)
        end
        local rooms = Workspace:FindFirstChild("CurrentRooms")
        if rooms then
            local addconn = rooms.ChildAdded:Connect(function(r) if flags.espchest then setup(r) end end)
            for _, r in pairs(rooms:GetChildren()) do setup(r) end
            task.spawn(function()
                repeat task.wait() until not flags.espchest
                addconn:Disconnect()
            end)
        end
    end
})

ESPTab:CreateToggle({
    Name = "ESP Goldpiles",
    CurrentValue = false,
    Flag = "esp_gold",
    Callback = function(Value)
        flags.espgold = Value
        if not Value then
            for _, v in pairs(esptable.gold) do if v and v.delete then v.delete() end end
            table.clear(esptable.gold)
            return
        end
        local function check(v)
            if not v:IsA("Model") or hasESP(v) then return end
            local goldvalue = v:GetAttribute("GoldValue")
            if goldvalue and goldvalue >= goldespvalue then
                local hitbox = v:FindFirstChild("Hitbox")
                if hitbox then
                    local parts = {}
                    for _, p in pairs(hitbox:GetChildren()) do
                        if p:IsA("BasePart") then table.insert(parts, p) end
                    end
                    if #parts > 0 then
                        local h = esp(parts, Color3.fromRGB(255, 255, 0), hitbox, "GoldPile [" .. goldvalue .. "]")
                        markESP(v)
                        table.insert(esptable.gold, h)
                    end
                end
            end
        end
        local function setup(room)
            local assets = room:FindFirstChild("Assets")
            if not assets then return end
            local conn = assets.DescendantAdded:Connect(function(v) if flags.espgold then check(v) end end)
            for _, v in pairs(assets:GetDescendants()) do check(v) end
            task.spawn(function()
                repeat task.wait() until not flags.espgold
                conn:Disconnect()
            end)
        end
        local rooms = Workspace:FindFirstChild("CurrentRooms")
        if rooms then
            local addconn = rooms.ChildAdded:Connect(function(r) if flags.espgold then setup(r) end end)
            for _, r in pairs(rooms:GetChildren()) do setup(r) end
            task.spawn(function()
                repeat task.wait() until not flags.espgold
                addconn:Disconnect()
            end)
        end
    end
})

ESPTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = false,
    Flag = "esp_players",
    Callback = function(Value)
        flags.esphumans = Value
        if not Value then
            for _, v in pairs(esptable.people) do if v and v.delete then v.delete() end end
            table.clear(esptable.people)
            return
        end
        local function personesp(v)
            local function apply(vc)
                if not vc or hasESP(vc) then return end
                local torso = vc:FindFirstChild("UpperTorso") or vc:FindFirstChild("HumanoidRootPart") or vc:FindFirstChildWhichIsA("BasePart")
                if torso then
                    local h = esp(vc, Color3.fromRGB(255, 255, 255), torso, v.DisplayName)
                    table.insert(esptable.people, h)
                end
            end
            v.CharacterAdded:Connect(apply)
            if v.Character then apply(v.Character) end
        end
        local addconn = Players.PlayerAdded:Connect(function(v) if v ~= plr then personesp(v) end end)
        for _, v in pairs(Players:GetPlayers()) do if v ~= plr then personesp(v) end end
        task.spawn(function()
            repeat task.wait() until not flags.esphumans
            addconn:Disconnect()
        end)
    end
})

-------------------------------------------------
-- MISC
-------------------------------------------------
-------------------------------------------------
-- SPEED (CFrame method - WalkSpeed stays 16)
-------------------------------------------------
MiscTab:CreateToggle({
    Name = "Enable Custom Speed",
    CurrentValue = false,
    Flag = "misc_speed_toggle",
    Callback = function(Value)
        flags.speedEnabled = Value
        if not Value and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 16
            end
        end
    end
})

MiscTab:CreateSlider({
    Name = "Movement Speed",
    Range = {1, 4.5},
    Increment = 0.5,
    Suffix = " Speed",
    CurrentValue = 16,
    Flag = "misc_speed",
    Callback = function(value)
        currentSpeed = value
    end
})

task.spawn(function()
    while true do
        local dt = task.wait() -- every frame

        if flags.speedEnabled and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local root = plr.Character:FindFirstChild("HumanoidRootPart")

            if hum and root then
                -- Keep WalkSpeed normal so the server doesn't freak out
                if hum.WalkSpeed ~= 16 then
                    hum.WalkSpeed = 16
                end

                -- Move with CFrame instead
                if hum.MoveDirection.Magnitude > 0.05 then
                    local move = hum.MoveDirection * currentSpeed * dt
                    root.CFrame = root.CFrame + Vector3.new(move.X, 0, move.Z)
                end
            end
        end
    end
end)

local oldLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

MiscTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "misc_fullbright",
    Callback = function(Value)
        flags.fullbright = Value
        if Value then
            task.spawn(function()
                while flags.fullbright do
                    Lighting.Brightness = 2
                    Lighting.ClockTime = 14
                    Lighting.FogEnd = 100000
                    Lighting.GlobalShadows = false
                    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
                    task.wait(0.6)
                end
            end)
        else
            Lighting.Brightness = oldLighting.Brightness
            Lighting.ClockTime = oldLighting.ClockTime
            Lighting.FogEnd = oldLighting.FogEnd
            Lighting.GlobalShadows = oldLighting.GlobalShadows
            Lighting.Ambient = oldLighting.Ambient
            Lighting.OutdoorAmbient = oldLighting.OutdoorAmbient
        end
    end
})

local instantDoorConn = nil
MiscTab:CreateToggle({
    Name = "Instant Interact (Doors + Generators)",
    CurrentValue = false,
    Flag = "misc_instantdoor",
    Callback = function(Value)
        flags.instantdoor = Value
        if instantDoorConn then
            instantDoorConn:Disconnect()
            instantDoorConn = nil
        end
        if Value then
            local rooms = Workspace:FindFirstChild("CurrentRooms")
            if rooms then
                for _, desc in pairs(rooms:GetDescendants()) do
                    if desc:IsA("ProximityPrompt") then
                        desc.HoldDuration = 0
                    end
                end
                instantDoorConn = rooms.DescendantAdded:Connect(function(desc)
                    if flags.instantdoor and desc:IsA("ProximityPrompt") then
                        desc.HoldDuration = 0
                    end
                end)
            end
        end
    end
})

-- ========== DELETE SCREECH (CLIENT) ==========
local screechConns = {}

MiscTab:CreateToggle({
    Name = "Delete Screech (Client)",
    CurrentValue = false,
    Flag = "misc_deletescreech",
    Callback = function(Value)
        flags.deleteScreech = Value

        for _, c in pairs(screechConns) do
            if c then c:Disconnect() end
        end
        table.clear(screechConns)

        if not Value then return end

        local function nuke(obj)
            if obj and (obj.Name == "Screech" or obj.Name == "ScreechMoving") then
                pcall(function() obj:Destroy() end)
            end
        end

        local cam = Workspace.CurrentCamera
        if cam then
            for _, child in pairs(cam:GetChildren()) do
                nuke(child)
            end
            table.insert(screechConns, cam.ChildAdded:Connect(nuke))
        end

        for _, child in pairs(Workspace:GetChildren()) do
            nuke(child)
        end
        table.insert(screechConns, Workspace.ChildAdded:Connect(nuke))
    end
})

-- ========== DELETE HALT (CLIENT) ==========
local haltConns = {}

MiscTab:CreateToggle({
    Name = "Delete Halt (Client)",
    CurrentValue = false,
    Flag = "misc_deletehalt",
    Callback = function(Value)
        flags.deleteHalt = Value

        for _, c in pairs(haltConns) do
            if c then c:Disconnect() end
        end
        table.clear(haltConns)

        if not Value then return end

        local function nuke(obj)
            if obj and (obj.Name == "Halt" or obj.Name == "HaltMoving" or obj.Name:find("Halt")) then
                pcall(function() obj:Destroy() end)
            end
        end

        for _, child in pairs(Workspace:GetChildren()) do
            nuke(child)
        end
        table.insert(haltConns, Workspace.ChildAdded:Connect(nuke))

        local rooms = Workspace:FindFirstChild("CurrentRooms")
        if rooms then
            for _, desc in pairs(rooms:GetDescendants()) do
                nuke(desc)
            end
            table.insert(haltConns, rooms.DescendantAdded:Connect(nuke))
        end
    end
})

-- ========== ANTI EYES (IMPROVED - Eyes stays visible) ==========
local eyesConns = {}
local eyesLoop = nil

MiscTab:CreateToggle({
    Name = "Anti Eyes Damage",
    CurrentValue = false,
    Flag = "misc_antieyes",
    Callback = function(Value)
        flags.antiEyes = Value

        for _, c in pairs(eyesConns) do
            if c then c:Disconnect() end
        end
        table.clear(eyesConns)

        if eyesLoop then
            task.cancel(eyesLoop)
            eyesLoop = nil
        end

        if not Value then return end

        -- Soft continuous protection (does not destroy Eyes model)
        eyesLoop = task.spawn(function()
            while flags.antiEyes do
                local character = plr.Character
                if character then
                    local hum = character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health < hum.MaxHealth * 0.95 then
                        -- Gentle heal so it doesn't fight the server too hard
                        hum.Health = math.min(hum.MaxHealth, hum.Health + 4)
                    end
                end
                task.wait(0.12)
            end
        end)

        table.insert(eyesConns, plr.CharacterAdded:Connect(function()
            task.wait(1)
            if flags.antiEyes then
                local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Health = hum.MaxHealth
                end
            end
        end))
    end
})

MiscTab:CreateToggle({
    Name = "Auto Loot",
    CurrentValue = false,
    Flag = "misc_autoloot",
    Callback = function(Value)
        flags.draweraura = Value
        if not Value then return end
        local function tryLoot(prompt, pos)
            if prompt:GetAttribute("Interactions") then return end
            task.spawn(function()
                while flags.draweraura and prompt and prompt.Parent do
                    if plr:DistanceFromCharacter(pos()) <= 12 then
                        fireproximityprompt(prompt)
                    end
                    task.wait(0.15)
                end
            end)
        end
        local function check(v)
            if not v:IsA("Model") then return end
            if v.Name == "DrawerContainer" then
                local knob = v:FindFirstChild("Knobs")
                if knob then
                    local prompt = knob:FindFirstChild("ActivateEventPrompt")
                    if prompt then tryLoot(prompt, function() return knob.Position end) end
                end
            elseif v.Name == "GoldPile" then
                local prompt = v:FindFirstChild("LootPrompt")
                if prompt and v.PrimaryPart then tryLoot(prompt, function() return v.PrimaryPart.Position end) end
            elseif v.Name:sub(1, 8) == "ChestBox" then
                local prompt = v:FindFirstChild("ActivateEventPrompt")
                if prompt and v.PrimaryPart then tryLoot(prompt, function() return v.PrimaryPart.Position end) end
            elseif v.Name == "RolltopContainer" then
                local prompt = v:FindFirstChild("ActivateEventPrompt")
                if prompt and v.PrimaryPart then tryLoot(prompt, function() return v.PrimaryPart.Position end) end
            end
        end
        local function setup(room)
            local conn = room.DescendantAdded:Connect(function(v) if flags.draweraura then check(v) end end)
            for _, v in pairs(room:GetDescendants()) do check(v) end
            task.spawn(function()
                repeat task.wait() until not flags.draweraura
                conn:Disconnect()
            end)
        end
        local rooms = Workspace:FindFirstChild("CurrentRooms")
        if rooms then
            local addconn = rooms.ChildAdded:Connect(function(r) if flags.draweraura then setup(r) end end)
            for _, r in pairs(rooms:GetChildren()) do setup(r) end
            task.spawn(function()
                repeat task.wait() until not flags.draweraura
                addconn:Disconnect()
            end)
        end
    end
})

MiscTab:CreateToggle({
    Name = "Notify Entities",
    CurrentValue = false,
    Flag = "misc_notify",
    Callback = function(Value)
        flags.hintrush = Value
        if not Value then return end

        local notified = {}
        local function notify(name, msg)
            if notified[name] then return end
            notified[name] = true
            Rayfield:Notify({
                Title = "⚠ Entity Incoming",
                Content = msg,
                Duration = 6,
                Image = 4483362458,
            })
            task.delay(8, function() notified[name] = nil end)
        end

        local function checkEntity(v)
            if not v or not v.Parent then return end
            local n = v.Name
            if n == "RushMoving" then notify("Rush", "Rush is coming! Go hide in a closet!")
            elseif n == "AmbushMoving" then notify("Ambush", "Ambush is coming! Hide now (it can rebound)!")
            elseif n == "ScreechMoving" or n == "Screech" then notify("Screech", "Screech is near! Look at it!")
            elseif n == "Eyes" or n == "EyesMoving" then notify("Eyes", "Eyes spawned! Look away!")
            elseif n == "HaltMoving" or n == "Halt" then notify("Halt", "Halt is coming! Walk carefully!")
            elseif n == "SeekMoving" or n == "Seek" then notify("Seek", "Seek chase starting! Run!")
            elseif n == "FigureMoving" or n == "Figure" or n == "FigureRagdoll" or n == "FigureRig" then notify("Figure", "Figure is nearby! Be quiet!")
            elseif n == "Timothy" or n == "TimothyMoving" then notify("Timothy", "Timothy appeared!")
            elseif n == "Dupe" or n == "DupeMoving" then notify("Dupe", "Dupe is in a door!")
            elseif n == "A-60" or n == "A60" then notify("A-60", "A-60 is coming! Hide!")
            elseif n == "A-120" or n == "A120" then notify("A-120", "A-120 is coming! Hide!")
            elseif n == "Grumble" or n == "GrumbleMoving" or n == "Grumbo" then notify("Grumble", "Grumble is nearby!")
            elseif n:find("Queen") and (n:find("Grumble") or n:find("Grumbo")) then notify("Queen", "Queen Grumble is here!")
            end
        end

        local wconn = Workspace.ChildAdded:Connect(function(v)
            if flags.hintrush then
                task.wait(0.08)
                checkEntity(v)
            end
        end)

        local function scanRoom(room)
            if room.Name == "50" or room.Name == "100" then
                local setup = room:FindFirstChild("FigureSetup")
                if setup then
                    local fig = setup:FindFirstChild("FigureRagdoll") or setup:FindFirstChild("FigureRig")
                    if fig then checkEntity(fig) end
                end
            end
            local dconn = room.DescendantAdded:Connect(function(d)
                if flags.hintrush then checkEntity(d) end
            end)
            task.spawn(function()
                repeat task.wait() until not flags.hintrush
                dconn:Disconnect()
            end)
        end

        local rooms = Workspace:FindFirstChild("CurrentRooms")
        if rooms then
            for _, r in pairs(rooms:GetChildren()) do scanRoom(r) end
            local rconn = rooms.ChildAdded:Connect(function(r)
                if flags.hintrush then
                    task.wait(0.2)
                    scanRoom(r)
                end
            end)
            task.spawn(function()
                repeat task.wait() until not flags.hintrush
                rconn:Disconnect()
                wconn:Disconnect()
            end)
        end
    end
})

MiscTab:CreateToggle({
    Name = "Auto Library Code",
    CurrentValue = false,
    Flag = "misc_libcode",
    Callback = function(Value)
        flags.getcode = Value
        if not Value then return end
        local function deciphercode()
            local paper = char:FindFirstChild("LibraryHintPaper")
            local hints = plr.PlayerGui:FindFirstChild("PermUI") and plr.PlayerGui.PermUI:FindFirstChild("Hints")
            local code = {"_","_","_","_","_"}
            if paper and hints then
                for _, v in pairs(paper:FindFirstChild("UI") and paper.UI:GetChildren() or {}) do
                    if v:IsA("ImageLabel") and v.Name ~= "Image" then
                        for _, img in pairs(hints:GetChildren()) do
                            if img:IsA("ImageLabel") and img.Visible and v.ImageRectOffset == img.ImageRectOffset then
                                local num = img:FindFirstChild("TextLabel")
                                if num then code[tonumber(v.Name)] = num.Text end
                            end
                        end
                    end
                end
            end
            return table.concat(code)
        end
        local conn = char.ChildAdded:Connect(function(v)
            if v:IsA("Tool") and v.Name == "LibraryHintPaper" then
                task.wait(0.1)
                local code = deciphercode()
                if code:find("_") then
                    Rayfield:Notify({Title = "Library Code", Content = "Get all hints first!", Duration = 5})
                else
                    Rayfield:Notify({Title = "Library Code", Content = "The code is: " .. code, Duration = 10})
                end
            end
        end)
        task.spawn(function()
            repeat task.wait() until not flags.getcode
            conn:Disconnect()
        end)
    end
})

-------------------------------------------------
-- CONFIG + INFO
-------------------------------------------------
ConfigTab:CreateSection("Scan Intervals")
ConfigTab:CreateSlider({
    Name = "Door Scan Interval",
    Range = {1, 15},
    Increment = 1,
    Suffix = "s",
    CurrentValue = 3,
    Flag = "cfg_doorscan",
    Callback = function(v) doorScanInterval = v end
})
ConfigTab:CreateSlider({
    Name = "Heavy ESP Scan Interval",
    Range = {1.5, 6},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 2.8,
    Flag = "cfg_heavyscan",
    Callback = function(v) heavyScanInterval = v end
})
ConfigTab:CreateSlider({
    Name = "Min Gold Value (Goldpile ESP)",
    Range = {0, 500},
    Increment = 10,
    Suffix = " gold",
    CurrentValue = 0,
    Flag = "cfg_goldmin",
    Callback = function(v) goldespvalue = v end
})

ConfigTab:CreateSection("Camera")
ConfigTab:CreateSlider({
    Name = "Field of View",
    Range = {30, 120},
    Increment = 1,
    Suffix = " FOV",
    CurrentValue = 70,
    Flag = "cfg_fov",
    Callback = function(v)
        currentFOV = v
    end
})

RunService.RenderStepped:Connect(function()
    local cam = Workspace.CurrentCamera
    if cam then
        cam.FieldOfView = currentFOV
    end
end)

InfoTab:CreateParagraph({
    Title = "Gabrieltod112",
    Content = "Hi.. I hope you're enjoying this Script I made."
})
InfoTab:CreateDivider()
InfoTab:CreateParagraph({
    Title = "Last Updated",
    Content = "Fixed Door ESP + Delete Screech + Delete Halt + Anti Eyes (Eyes stays visible) + FOV + Third Person"
})
InfoTab:CreateParagraph({
    Title = "Performance Tips",
    Content = "Turn off ESPs you don't need during Seek. Use the Heavy ESP Scan Interval slider if you still lag."
})

-------------------------------------------------
-- IMPROVED THIRD PERSON + KEYBINDS
-------------------------------------------------
local thirdPersonEnabled = false
local thirdPersonConn = nil
local visibilityConn = nil

local cameraYaw = 0
local cameraPitch = 0
local cameraSensitivity = 0.35
local maxPitch = 80
local cameraDistance = 10
local cameraHeight = 2.5

local function setCharacterVisibility(character, visible)
    if not character then return end

    for _, obj in pairs(character:GetDescendants()) do
        if obj:IsA("BasePart") then
            if obj.Name == "Head" or (obj.Parent and (obj.Parent:IsA("Accessory") or obj.Parent:IsA("Hat"))) then
                if visible then
                    obj.LocalTransparencyModifier = 0
                else
                    obj.LocalTransparencyModifier = 1
                end
            end
        elseif obj:IsA("Decal") and obj.Parent and obj.Parent.Name == "Head" then
            if visible then
                obj.LocalTransparencyModifier = 0
            else
                obj.LocalTransparencyModifier = 1
            end
        end
    end
end

local function startVisibilityLoop(character)
    if visibilityConn then
        visibilityConn:Disconnect()
        visibilityConn = nil
    end

    if not character then return end

    visibilityConn = RunService.RenderStepped:Connect(function()
        if thirdPersonEnabled and character and character.Parent then
            setCharacterVisibility(character, true)
        end
    end)
end

local function stopVisibilityLoop()
    if visibilityConn then
        visibilityConn:Disconnect()
        visibilityConn = nil
    end
end

local function setThirdPerson(state)
    thirdPersonEnabled = state

    if thirdPersonConn then
        thirdPersonConn:Disconnect()
        thirdPersonConn = nil
    end
    stopVisibilityLoop()

    local cam = Workspace.CurrentCamera
    if not cam then return end

    local character = plr.Character

    if state then
        cam.CameraType = Enum.CameraType.Scriptable
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        UserInputService.MouseIconEnabled = false

        if character then
            setCharacterVisibility(character, true)
            startVisibilityLoop(character)
        end

        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                local look = root.CFrame.LookVector
                cameraYaw = math.deg(math.atan2(-look.X, -look.Z))
                cameraPitch = 0
            end
        end

        thirdPersonConn = RunService.RenderStepped:Connect(function()
            local char = plr.Character
            if not char then return end

            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            local delta = UserInputService:GetMouseDelta()
            cameraYaw = cameraYaw - delta.X * cameraSensitivity
            cameraPitch = math.clamp(cameraPitch - delta.Y * cameraSensitivity, -maxPitch, maxPitch)

            local rotation = CFrame.fromEulerAnglesYXZ(
                math.rad(cameraPitch),
                math.rad(cameraYaw),
                0
            )

            local targetPos = root.Position + Vector3.new(0, cameraHeight, 0)
            local camPos = targetPos + (rotation:VectorToWorldSpace(Vector3.new(0, 0, cameraDistance)))

            cam.CFrame = CFrame.lookAt(camPos, targetPos)
            cam.Focus = CFrame.new(targetPos)
        end)

        Rayfield:Notify({
            Title = "Third Person",
            Content = "Enabled (Mouse Look + Full Character)",
            Duration = 2
        })
    else
        cam.CameraType = Enum.CameraType.Custom

        if character then
            local hum = character:FindFirstChildOfClass("Humanoid")
            if hum then
                cam.CameraSubject = hum
            end
            setCharacterVisibility(character, false)
        end

        plr.CameraMode = Enum.CameraMode.LockFirstPerson
        plr.CameraMaxZoomDistance = 0.5
        plr.CameraMinZoomDistance = 0.5

        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true

        Rayfield:Notify({
            Title = "Third Person",
            Content = "Disabled",
            Duration = 2
        })
    end
end

plr.CharacterAdded:Connect(function(newChar)
    task.wait(1.2)
    if thirdPersonEnabled then
        setThirdPerson(true)
    else
        setCharacterVisibility(newChar, false)
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.V then
        setThirdPerson(not thirdPersonEnabled)
    end
end)

-- Keybinds menu
local keybindGui = Instance.new("ScreenGui")
keybindGui.Name = "KeybindsMenu"
keybindGui.ResetOnSpawn = false
keybindGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
keybindGui.Parent = plr:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 210, 0, 100)
frame.Position = UDim2.new(0, 12, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Parent = keybindGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 80, 100)
stroke.Thickness = 1.2
stroke.Transparency = 0.4
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundTransparency = 1
title.Text = "Keybinds"
title.TextColor3 = Color3.fromRGB(220, 220, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, -16, 0, 55)
keyLabel.Position = UDim2.new(0, 8, 0, 32)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "V  →  Toggle Third Person\n(Mouse Look + Full Body)"
keyLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextSize = 13
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.TextYAlignment = Enum.TextYAlignment.Top
keyLabel.Parent = frame
