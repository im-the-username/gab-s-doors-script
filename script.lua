--[[
    MsFent Doors - Starlight UI Remake
    Original features fully preserved, UI rebuilt with Starlight Interface Suite.
]]

local Starlight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/starlight"))()
local NebulaIcons = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))()

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local StatsService = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

getgenv().InterfaceName = "MsFentDoors"

local Window = Starlight:CreateWindow({
	Name = "MsFent",
	Subtitle = "msFent Doors By gab currently unstable ;-;",
	Icon = NebulaIcons:GetIcon("door_front", "Material"),

	LoadingSettings = {
		Title = "MsFent Doors",
		Subtitle = "by gab",
	},

	FileSettings = {
		ConfigFolder = "MsFentDoors"
	},
})

-- ====================== STATE ======================
local Toggles = {}
local Options = {}

-- ====================== TABS ======================
local MainSection = Window:CreateTabSection("Main")
local MainTab = MainSection:CreateTab({
	Name = "Main",
	Icon = NebulaIcons:GetIcon("home", "Material"),
	Columns = 2,
}, "MainTab")

local ESPTab = MainSection:CreateTab({
	Name = "ESP",
	Icon = NebulaIcons:GetIcon("visibility", "Material"),
	Columns = 2,
}, "ESPTab")

local SettingsSection = Window:CreateTabSection("Settings")
local UISettingsTab = SettingsSection:CreateTab({
	Name = "UI Settings",
	Icon = NebulaIcons:GetIcon("settings", "Material"),
	Columns = 1,
}, "UISettingsTab")

-- ====================== PLAYER ======================
local PlayerBox = MainTab:CreateGroupbox({
	Name = "Player",
	Icon = NebulaIcons:GetIcon("person", "Material"),
	Column = 1,
}, "PlayerBox")

local GoldLabel = PlayerBox:CreateLabel({
	Name = "Current Gold: Loading...",
}, "GoldLabel")

Options.GoldSlider = 50
PlayerBox:CreateSlider({
	Name = "Gold Amount",
	Range = {1, 1000},
	Increment = 1,
	CurrentValue = 50,
	Callback = function(Value)
		Options.GoldSlider = Value
	end,
}, "GoldSlider")

PlayerBox:CreateButton({
	Name = "Add Gold",
	Callback = function()
		local goldObj = LocalPlayer:FindFirstChild("Gold")
		if goldObj then
			goldObj.Value = goldObj.Value + (Options.GoldSlider or 50)
		end
	end,
}, "AddGold")

Toggles.ToggleJump = false
PlayerBox:CreateToggle({
	Name = "Toggle Jump",
	CurrentValue = false,
	Callback = function(Value)
		Toggles.ToggleJump = Value
		local char = workspace:FindFirstChild(LocalPlayer.Name)
		if char then char:SetAttribute("CanJump", Value) end
	end,
}, "ToggleJump")

Toggles.ToggleSlide = false
PlayerBox:CreateToggle({
	Name = "Toggle Slide",
	CurrentValue = false,
	Callback = function(Value)
		Toggles.ToggleSlide = Value
		local char = workspace:FindFirstChild(LocalPlayer.Name)
		if char then char:SetAttribute("CanSlide", Value) end
	end,
}, "ToggleSlide")

Toggles.InfiniteItems = false
PlayerBox:CreateToggle({
	Name = "Infinite Items",
	CurrentValue = false,
	Callback = function(Value)
		Toggles.InfiniteItems = Value
	end,
}, "InfiniteItems")

PlayerBox:CreateLabel({
	Name = "mspaint-style on locks (may not work)",
}, "InfItemsNote")

-- Position Offset state
local positionOffsetEnabled = false
local positionOffsetConn = nil
local OFFSET_KEY = Enum.KeyCode.G
local HALF_BODY_SINK = 4.2
local saved = {
	HipHeight = nil,
	CameraOffset = nil,
	CollisionSize = nil,
	Parts = {},
}

local function getCharParts()
	local char = LocalPlayer.Character
	if not char then return nil end
	local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Collision")
	local hum = char:FindFirstChildOfClass("Humanoid")
	local collision = char:FindFirstChild("Collision")
	return char, root, hum, collision
end

local function clearSaved()
	saved.HipHeight = nil
	saved.CameraOffset = nil
	saved.CollisionSize = nil
	table.clear(saved.Parts)
end

local function applyPositionOffset(enable)
	local char, root, hum, collision = getCharParts()
	if not char or not root or not hum then return end
	if enable then
		if saved.HipHeight == nil then
			saved.HipHeight = hum.HipHeight
		end
		if saved.CameraOffset == nil then
			saved.CameraOffset = hum.CameraOffset
		end
		hum.HipHeight = (saved.HipHeight or 2) - HALF_BODY_SINK
		hum.CameraOffset = Vector3.new(0, HALF_BODY_SINK, 0)
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				if saved.Parts[part] == nil then
					saved.Parts[part] = {
						CanTouch = part.CanTouch,
						CanQuery = part.CanQuery,
					}
				end
				part.CanTouch = false
			end
		end
		if collision then
			if saved.CollisionSize == nil then
				saved.CollisionSize = collision.Size
			end
			local s = saved.CollisionSize
			collision.Size = Vector3.new(s.X * 0.85, math.max(0.6, s.Y * 0.35), s.Z * 0.85)
			collision.CanTouch = false
		end
		if positionOffsetConn then
			positionOffsetConn:Disconnect()
			positionOffsetConn = nil
		end
		positionOffsetConn = RunService.Heartbeat:Connect(function()
			if not positionOffsetEnabled then return end
			local c, r, h, col = getCharParts()
			if not c or not r or not h then return end
			h.HipHeight = (saved.HipHeight or 2) - HALF_BODY_SINK
			h.CameraOffset = Vector3.new(0, HALF_BODY_SINK, 0)
			for _, part in pairs(c:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanTouch = false
				end
			end
			if col and saved.CollisionSize then
				local s = saved.CollisionSize
				col.Size = Vector3.new(s.X * 0.85, math.max(0.6, s.Y * 0.35), s.Z * 0.85)
				col.CanTouch = false
			end
		end)
		pcall(function()
			Starlight:Notify({ Title = "Position Offset", Content = "ON — hands in ground", Duration = 2 })
		end)
	else
		if positionOffsetConn then
			positionOffsetConn:Disconnect()
			positionOffsetConn = nil
		end
		local c, r, h, col = getCharParts()
		if h then
			if saved.HipHeight ~= nil then
				h.HipHeight = saved.HipHeight
			end
			if saved.CameraOffset ~= nil then
				h.CameraOffset = saved.CameraOffset
			else
				h.CameraOffset = Vector3.new(0, 0, 0)
			end
		end
		if col and saved.CollisionSize then
			col.Size = saved.CollisionSize
		end
		for part, props in pairs(saved.Parts) do
			if part and part.Parent then
				pcall(function()
					part.CanTouch = props.CanTouch
					part.CanQuery = props.CanQuery
				end)
			end
		end
		clearSaved()
		pcall(function()
			Starlight:Notify({ Title = "Position Offset", Content = "OFF", Duration = 2 })
		end)
	end
end

local function togglePositionOffset()
	positionOffsetEnabled = not positionOffsetEnabled
	applyPositionOffset(positionOffsetEnabled)
end

Toggles.PositionOffset = false
PlayerBox:CreateToggle({
	Name = "Position Offset (hands in ground)",
	CurrentValue = false,
	Callback = function(Value)
		Toggles.PositionOffset = Value
		positionOffsetEnabled = Value
		applyPositionOffset(Value)
	end,
}, "PositionOffset")

PlayerBox:CreateLabel({
	Name = "Keybind: G — move while sunk",
}, "PosOffsetNote")

-- Gold updater
task.spawn(function()
	while task.wait(1) do
		local goldObj = LocalPlayer:FindFirstChild("Gold")
		local goldText = goldObj and tostring(goldObj.Value) or "N/A"
		pcall(function()
			GoldLabel:Set({ Name = "Current Gold: " .. goldText })
		end)
	end
end)

-- ====================== VISUALS + FOV ======================
local Visuals = MainTab:CreateGroupbox({
	Name = "Visuals",
	Icon = NebulaIcons:GetIcon("visibility", "Material"),
	Column = 1,
}, "VisualsBox")

Options.BrightnessSlider = 2
Options.FOVSlider = 70

Toggles.Fullbright = false
Visuals:CreateToggle({
	Name = "Fullbright",
	CurrentValue = false,
	Callback = function(Value)
		Toggles.Fullbright = Value
		Lighting.ClockTime = Value and 12 or 14
		Lighting.GlobalShadows = not Value
		Lighting.Brightness = Value and (Options.BrightnessSlider or 2) or 1
	end,
}, "Fullbright")

Visuals:CreateSlider({
	Name = "Fullbright Intensity",
	Range = {1, 10},
	Increment = 0.5,
	CurrentValue = 2,
	Callback = function(Value)
		Options.BrightnessSlider = Value
		if Toggles.Fullbright then
			Lighting.Brightness = Value
		end
	end,
}, "BrightnessSlider")

Visuals:CreateSlider({
	Name = "Field of View",
	Range = {30, 120},
	Increment = 1,
	CurrentValue = 70,
	Callback = function(Value)
		Options.FOVSlider = Value
		if Camera then Camera.FieldOfView = Value end
	end,
}, "FOVSlider")

RunService.RenderStepped:Connect(function()
	if Camera and Options.FOVSlider then
		Camera.FieldOfView = Options.FOVSlider
	end
end)

-- ====================== INTERACT ======================
local InteractBox = MainTab:CreateGroupbox({
	Name = "Interact",
	Icon = NebulaIcons:GetIcon("touch_app", "Material"),
	Column = 2,
}, "InteractBox")

local instantConn = nil
local function applyInstantToPrompt(prompt)
	if prompt and prompt:IsA("ProximityPrompt") then
		pcall(function() prompt.HoldDuration = 0 end)
	end
end

Toggles.InstantInteract = false
InteractBox:CreateToggle({
	Name = "Instant Interact",
	CurrentValue = false,
	Callback = function(Value)
		Toggles.InstantInteract = Value
		if instantConn then instantConn:Disconnect() instantConn = nil end
		if not Value then return end
		for _, desc in pairs(workspace:GetDescendants()) do
			if desc:IsA("ProximityPrompt") then applyInstantToPrompt(desc) end
		end
		instantConn = workspace.DescendantAdded:Connect(function(desc)
			if Toggles.InstantInteract and desc:IsA("ProximityPrompt") then
				applyInstantToPrompt(desc)
			end
		end)
	end,
}, "InstantInteract")

local AUTO_RANGE = 12
local AUTO_INTERVAL = 0.18
local JeffShopKeywords = {
	"jeff", "jeffshop", "jeff_shop", "tipjar", "tip_jar", "tip jar",
	"elgoblino", "el goblino", "bob", "shopshelf", "shopitem"
}
local PaperPlaneKeywords = {
	"paperplane", "paper_plane", "paper plane", "paperairplane",
	"paper airplane", "paperairplanes", "plane"
}
local HidingKeywords = {
	"locker", "wardrobe", "closet", "bed", "toolshed", "shed",
	"hiding", "hide", "vent", "cabinet", "cupboard",
	"rooms_locker", "circularvent", "backdoor_wardrobe", "locker_large"
}

local function nameContainsAny(str, list)
	if not str then return false end
	local lower = string.lower(str)
	for _, kw in ipairs(list) do
		if lower:find(kw, 1, true) then return true end
	end
	return false
end

local function walkAncestors(prompt, keywords, maxDepth)
	maxDepth = maxDepth or 12
	if nameContainsAny(prompt.ObjectText, keywords) then return true end
	if nameContainsAny(prompt.ActionText, keywords) then return true end
	if nameContainsAny(prompt.Name, keywords) then return true end
	local current = prompt.Parent
	local depth = 0
	while current and depth < maxDepth do
		if nameContainsAny(current.Name, keywords) then return true end
		current = current.Parent
		depth = depth + 1
	end
	return false
end

local function shouldSkipPrompt(prompt)
	if not prompt or not prompt:IsA("ProximityPrompt") then return true end
	if not prompt.Enabled then return true end
	if walkAncestors(prompt, JeffShopKeywords) then return true end
	if walkAncestors(prompt, PaperPlaneKeywords) then return true end
	if walkAncestors(prompt, HidingKeywords) then return true end
	return false
end

local function getPromptWorldPosition(prompt)
	local parent = prompt.Parent
	if not parent then return nil end
	if parent:IsA("BasePart") then return parent.Position end
	if parent:IsA("Attachment") then return parent.WorldPosition end
	if parent:IsA("Model") then
		local pp = parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
		return pp and pp.Position
	end
	local part = parent:FindFirstChildWhichIsA("BasePart")
	return part and part.Position
end

local autoInteractRunning = false
local function startAutoInteract()
	if autoInteractRunning then return end
	autoInteractRunning = true
	task.spawn(function()
		while autoInteractRunning and Toggles.AutoInteract do
			local char = LocalPlayer.Character
			local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Collision"))
			if root then
				local rootPos = root.Position
				for _, desc in pairs(workspace:GetDescendants()) do
					if not autoInteractRunning then break end
					if desc:IsA("ProximityPrompt") and not shouldSkipPrompt(desc) then
						local pos = getPromptWorldPosition(desc)
						if pos then
							local dist = (rootPos - pos).Magnitude
							local maxDist = (desc.MaxActivationDistance > 0 and desc.MaxActivationDistance) or AUTO_RANGE
							if dist <= math.min(AUTO_RANGE, maxDist + 1.5) then
								pcall(function() fireproximityprompt(desc) end)
							end
						end
					end
				end
			end
			task.wait(AUTO_INTERVAL)
		end
		autoInteractRunning = false
	end)
end

local function stopAutoInteract()
	autoInteractRunning = false
end

Toggles.AutoInteract = false
InteractBox:CreateToggle({
	Name = "Auto Interact",
	CurrentValue = false,
	Callback = function(Value)
		Toggles.AutoInteract = Value
		if Value then startAutoInteract() else stopAutoInteract() end
	end,
}, "AutoInteract")

InteractBox:CreateLabel({
	Name = "Skips Jeff / Paper Planes / Lockers",
}, "AutoInteractNote")

-- ====================== ANTI-ENTITIES ======================
local AntiBox = MainTab:CreateGroupbox({
	Name = "Anti-Entities",
	Icon = NebulaIcons:GetIcon("shield", "Material"),
	Column = 2,
}, "AntiBox")

local function getRemotesFolder()
	return ReplicatedStorage:FindFirstChild("Remotes")
		or ReplicatedStorage:FindFirstChild("EntityRemotes")
		or ReplicatedStorage
end

local function ToggleRemote(name, state)
	local Remotes = getRemotesFolder()
	local remote = Remotes:FindFirstChild(name) or _G[name .. "_Storage"]
	if state then
		if remote then
			_G[name .. "_Storage"] = remote
			remote.Parent = nil
		end
	else
		local storage = _G[name .. "_Storage"]
		if storage then storage.Parent = Remotes end
	end
end

Toggles.AntiA90 = false
AntiBox:CreateToggle({
	Name = "Anti A-90",
	CurrentValue = false,
	Callback = function(v)
		Toggles.AntiA90 = v
		ToggleRemote("A90", v)
	end,
}, "AntiA90")

Toggles.AntiDread = false
AntiBox:CreateToggle({
	Name = "Anti Dread",
	CurrentValue = false,
	Callback = function(v)
		Toggles.AntiDread = v
		ToggleRemote("Dread", v)
	end,
}, "AntiDread")

local screechConns = {}
local function nukeScreech(obj)
	if obj and (obj.Name == "Screech" or obj.Name == "ScreechMoving") then
		pcall(function() obj:Destroy() end)
	end
end

local function stopDeleteScreech()
	for _, c in pairs(screechConns) do
		if c then c:Disconnect() end
	end
	table.clear(screechConns)
end

local function startDeleteScreech()
	stopDeleteScreech()
	local cam = workspace.CurrentCamera
	if cam then
		for _, child in pairs(cam:GetChildren()) do
			nukeScreech(child)
		end
		table.insert(screechConns, cam.ChildAdded:Connect(nukeScreech))
	end
	for _, child in pairs(workspace:GetChildren()) do
		nukeScreech(child)
	end
	table.insert(screechConns, workspace.ChildAdded:Connect(nukeScreech))
	table.insert(screechConns, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		local newCam = workspace.CurrentCamera
		if newCam then
			table.insert(screechConns, newCam.ChildAdded:Connect(nukeScreech))
			for _, child in pairs(newCam:GetChildren()) do
				nukeScreech(child)
			end
		end
	end))
end

Toggles.DeleteScreech = false
AntiBox:CreateToggle({
	Name = "Delete Screech (Client)",
	CurrentValue = false,
	Callback = function(Value)
		Toggles.DeleteScreech = Value
		if Value then startDeleteScreech() else stopDeleteScreech() end
	end,
}, "DeleteScreech")

Toggles.AntiGiggle = false
AntiBox:CreateToggle({
	Name = "Anti Giggle",
	CurrentValue = false,
	Callback = function(v)
		Toggles.AntiGiggle = v
		ToggleRemote("Giggle", v)
	end,
}, "AntiGiggle")

Toggles.AntiHaste = false
AntiBox:CreateToggle({
	Name = "Anti Haste",
	CurrentValue = false,
	Callback = function(v)
		Toggles.AntiHaste = v
		ToggleRemote("Haste", v)
	end,
}, "AntiHaste")

Toggles.AntiCamShake = false
AntiBox:CreateToggle({
	Name = "Anti CamShake",
	CurrentValue = false,
	Callback = function(v)
		Toggles.AntiCamShake = v
		for _, name in pairs({"CamShake", "CamShakeClient", "CamShakeRelative", "CamShakeRelativeClient"}) do
			ToggleRemote(name, v)
		end
	end,
}, "AntiCamShake")

-- ====================== ESP TAB ======================
local ESPBox = ESPTab:CreateGroupbox({
	Name = "ESP Toggles",
	Icon = NebulaIcons:GetIcon("visibility", "Material"),
	Column = 1,
}, "ESPBox")

-- Default colors
Options.FillColor = Color3.fromRGB(0, 255, 100)
Options.ObjColor = Color3.fromRGB(0, 0, 255)
Options.EntityColor = Color3.fromRGB(255, 0, 0)
Options.GoldColor = Color3.fromRGB(255, 225, 0)
Options.ItemColor = Color3.fromRGB(0, 255, 255)
Options.HideCol = Color3.fromRGB(100, 100, 100)
Options.ShedCol = Color3.fromRGB(139, 69, 19)
Options.PCol = Color3.fromRGB(0, 255, 0)

Toggles.DoorESP = false
ESPBox:CreateToggle({
	Name = "Door ESP (Next only)",
	CurrentValue = false,
	Callback = function(v) Toggles.DoorESP = v end,
}, "DoorESP")

Toggles.ObjESP = false
ESPBox:CreateToggle({
	Name = "Objective ESP",
	CurrentValue = false,
	Callback = function(v) Toggles.ObjESP = v end,
}, "ObjESP")

Toggles.EntityESP = false
ESPBox:CreateToggle({
	Name = "Entity Highlight",
	CurrentValue = false,
	Callback = function(v) Toggles.EntityESP = v end,
}, "EntityESP")

Toggles.GoldPileESP = false
ESPBox:CreateToggle({
	Name = "Gold Highlight",
	CurrentValue = false,
	Callback = function(v) Toggles.GoldPileESP = v end,
}, "GoldPileESP")

Toggles.ItemESP = false
ESPBox:CreateToggle({
	Name = "Item Highlight",
	CurrentValue = false,
	Callback = function(v) Toggles.ItemESP = v end,
}, "ItemESP")

Toggles.HidingESP = false
ESPBox:CreateToggle({
	Name = "Hiding ESP",
	CurrentValue = false,
	Callback = function(v) Toggles.HidingESP = v end,
}, "HidingESP")

Toggles.ShedESP = false
ESPBox:CreateToggle({
	Name = "ToolShed ESP",
	CurrentValue = false,
	Callback = function(v) Toggles.ShedESP = v end,
}, "ShedESP")

Toggles.PlayerESP = false
ESPBox:CreateToggle({
	Name = "Player ESP",
	CurrentValue = false,
	Callback = function(v) Toggles.PlayerESP = v end,
}, "PlayerESP")

-- ESP Settings
local ESPSettingsBox = ESPTab:CreateGroupbox({
	Name = "ESP Settings",
	Icon = NebulaIcons:GetIcon("tune", "Material"),
	Column = 2,
}, "ESPSettingsBox")

Toggles.RainbowESP = true
ESPSettingsBox:CreateToggle({
	Name = "Rainbow ESP",
	CurrentValue = true,
	Callback = function(v) Toggles.RainbowESP = v end,
}, "RainbowESP")

Toggles.EnableText = true
ESPSettingsBox:CreateToggle({
	Name = "Enable Text",
	CurrentValue = true,
	Callback = function(v) Toggles.EnableText = v end,
}, "EnableText")

Options.TextSize = 18
ESPSettingsBox:CreateSlider({
	Name = "Text Size",
	Range = {10, 40},
	Increment = 1,
	CurrentValue = 18,
	Callback = function(v) Options.TextSize = v end,
}, "TextSize")

Options.KeyTextSize = 36
ESPSettingsBox:CreateSlider({
	Name = "Key ESP Text Size",
	Range = {18, 60},
	Increment = 1,
	CurrentValue = 36,
	Callback = function(v) Options.KeyTextSize = v end,
}, "KeyTextSize")

Options.TextHeight = 2.5
ESPSettingsBox:CreateSlider({
	Name = "Text Offset Y",
	Range = {-5, 15},
	Increment = 0.5,
	CurrentValue = 2.5,
	Callback = function(v) Options.TextHeight = v end,
}, "TextHeight")

Options.MaxDistance = 1000
ESPSettingsBox:CreateSlider({
	Name = "Max ESP Distance",
	Range = {50, 5000},
	Increment = 50,
	CurrentValue = 1000,
	Callback = function(v) Options.MaxDistance = v end,
}, "MaxDistance")

-- Entity Notify
local NotifyBox = ESPTab:CreateGroupbox({
	Name = "Entity Notify",
	Icon = NebulaIcons:GetIcon("notifications", "Material"),
	Column = 2,
}, "NotifyBox")

Toggles.EntityNotify = false
NotifyBox:CreateToggle({
	Name = "Entity Spawn Notify",
	CurrentValue = false,
	Callback = function(v) Toggles.EntityNotify = v end,
}, "EntityNotify")

NotifyBox:CreateLabel({
	Name = "Known entities only + ding sound",
}, "NotifyNote")

-- ====================== DATA ======================
local activeESPs = {}
local EntityNames = {
	"Rush", "Ambush", "Seek", "Eyes", "Screech", "Halt", "A-60", "A-120",
	"GiggleCeiling", "MonumentEntity", "SallyMoving", "JeffTheKiller",
	"GloombatSwarm", "FigureRig", "RushMoving", "AmbushMoving", "SeekMoving",
	"HaltMoving", "FigureMoving", "ScreechMoving", "EyesMoving", "DupeMoving",
	"A60", "A120", "Figure", "FigureRagdoll"
}

local KnownEntityMessages = {
	RushMoving = "Rush is coming! Hide!",
	Rush = "Rush is coming! Hide!",
	AmbushMoving = "Ambush is coming! Hide (it rebounds)!",
	Ambush = "Ambush is coming! Hide!",
	SeekMoving = "Seek chase starting! Run!",
	Seek = "Seek is here! Run!",
	ScreechMoving = "Screech nearby! Look at it!",
	Screech = "Screech nearby! Look at it!",
	HaltMoving = "Halt is active! Walk carefully!",
	Halt = "Halt is active! Walk carefully!",
	Eyes = "Eyes spawned! Look away!",
	EyesMoving = "Eyes spawned! Look away!",
	FigureRig = "Figure is nearby! Stay quiet!",
	FigureMoving = "Figure is nearby! Stay quiet!",
	Figure = "Figure is nearby! Stay quiet!",
	FigureRagdoll = "Figure is nearby! Stay quiet!",
	["A-60"] = "A-60 is coming! Hide!",
	A60 = "A-60 is coming! Hide!",
	["A-120"] = "A-120 is coming! Hide!",
	A120 = "A-120 is coming! Hide!",
	DupeMoving = "Dupe may be in a door!",
	Dupe = "Dupe may be in a door!",
	GiggleCeiling = "Giggle is above! Be careful!",
	JeffTheKiller = "Jeff The Killer spawned!",
	GloombatSwarm = "Gloombats incoming!",
	MonumentEntity = "Monument entity nearby!",
	SallyMoving = "Sally is moving!",
}

local ObjList = {
	"LibraryHintPaper", "LiveHintBook", "KeyObtain", "LeverForGate",
	"LiveBreakerPolePickup", "ElectricalKeyObtain"
}

local ItemList = {
	"AK-47","AlarmClock","Aloe","AN-94","Anchors","A-90sStopSign","BackdoorKey","BackdoorLock",
	"Bandage","BandagePack","Battery","BatteryPack","BigBomb","BlueKeycard","BluePrince","Bomb",
	"Bread","BreakerPole","Bulklight","Buddy","Cactus","Candle","CarmelApple","Cheese","ChocolateBar",
	"Citamines","ColtAnaconda","Cookie","Crossbow","Crucifix","DBShotgun","DesertEagle","ElectricalKey",
	"ElectricalRoomFuse","EnergyDrink","ExecutionRoomKey","Flashlight","FreezeGun","Flamethrower","G36C",
	"Generator","GeneratorFuse","GiftLauncher","GlitchFragment","GweenSoda","GuidanceCandy","Headlamp",
	"HealingPad","HolyHandGrenade","HasteLever","Hookshot","HotelKey","HotelLock","IceTripmine",
	"InvincibilityStar","JackoBomb","Keycard","Knockbomb","Landmine","Lantern","LaserPointer",
	"Level5Keycard","LibearyBook","LibearyLock","LibearyPaper","Light_Bulb","Lockpick","Lolipop",
	"MG42","M14","M16A2","M1911","M249","M5K","M4A1","MoonlightCandle","MoonlightFloat","MoonlightSmoothie",
	"Monkey","Nanner","NannerPeel","NestGenerator","NVCS-3000","OrangeKeycard","P90","Paintingoval",
	"Paintingrectanglelyingshortsides","Paintingrectanglelyinglongsides","PaintingSquare","PlantofVirdis",
	"Potion","R870","RedEnergyDrink","Rock","Roto_Door","RubberChicken","SacredHerb","SaltShaker",
	"Shakelight","Shears","SkeletonKey","Smoothie","SmallShieldPotion","SpeedBoostPad","SprayPaint",
	"StarlightBottle","StarlightJug","StarlightVial","Straplight","StrawberryCandy","StrongHerb",
	"StrongerHerb","StrongestHerb","SuperHerb","SweetHerb","ThrowableHatStand","ThrowableNormalCardboardBox",
	"ThrowableOfficeChair","ThrowablePottedPlant","ThrowableRegalChair","ThrowableRegalOttoman",
	"ThrowableStool","ThrowableTrashCan","ThrowableWideCardboardBox","ThrowableWoodenChair",
	"ThrowableWoodenCrate","TipJar","Vitamins"
}

local HSList = {"Locker_Large", "Toolshed", "Wardrobe", "Bed", "Backdoor_Wardrobe", "Rooms_Locker", "CircularVent"}
local DING_SOUND_ID = "rbxassetid://1527814017"

local function playDing()
	local sound = Instance.new("Sound")
	sound.SoundId = DING_SOUND_ID
	sound.Volume = 1.5
	sound.Parent = SoundService
	sound:Play()
	sound.Ended:Connect(function() if sound then sound:Destroy() end end)
	task.delay(3, function() if sound and sound.Parent then sound:Destroy() end end)
end

local notifiedEntities = {}
local function notifyEntity(name, message)
	if notifiedEntities[name] then return end
	notifiedEntities[name] = true
	playDing()
	pcall(function()
		Starlight:Notify({ Title = "Entity", Content = message, Duration = 5 })
	end)
	task.delay(8, function() notifiedEntities[name] = nil end)
end

local function checkEntityNotify(obj)
	if not Toggles.EntityNotify then return end
	if not obj or not obj.Parent then return end
	local msg = KnownEntityMessages[obj.Name]
	if msg then notifyEntity(obj.Name, msg) end
end

local function Cleanup(obj, data)
	pcall(function()
		if data.Highlight then data.Highlight:Destroy() end
		if data.Box then data.Box:Destroy() end
		if data.Bill then data.Bill:Destroy() end
	end)
	activeESPs[obj] = nil
end

local function CreateESP(obj, name, type)
	if activeESPs[obj] then return end
	if not obj or not obj.Parent then return end
	local objN = obj.Name
	if objN == "LiveHintBook" or objN == "FigureRig" or objN == "LiveBreakerPolePickup" or objN == "ElectricalKeyObtain" then
		local displayName = (objN == "LiveHintBook" and "Book")
			or (objN == "FigureRig" and "Figure")
			or (objN == "LiveBreakerPolePickup" and "Breaker")
			or (objN == "ElectricalKeyObtain" and "Electrical Key")
		activeESPs[obj] = { Name = displayName, Type = type }
		return
	end
	local lowerN = objN:lower()
	if lowerN:find("bookcase") or lowerN:find("modular_bookshelf") then return end
	activeESPs[obj] = { Name = name, Type = type }
end

local function isBadDoor(door, room, currentRoomNum)
	if not door then return true end
	local roomNum = room and tonumber(room.Name)
	if roomNum and currentRoomNum and roomNum < currentRoomNum then return true end
	local n = string.lower(door.Name)
	if n:find("dupe") then return true end
	if door:GetAttribute("Dupe") == true then return true end
	if door:GetAttribute("IsDupe") == true then return true end
	local current = door
	for _ = 1, 8 do
		if not current then break end
		local cn = string.lower(current.Name)
		if cn:find("dupe") or cn:find("fakedoor") or cn:find("fake_door") then
			return true
		end
		current = current.Parent
	end
	return false
end

local function getCurrentRoomNumber()
	local attr = LocalPlayer:GetAttribute("CurrentRoom")
	if typeof(attr) == "number" then return attr end
	local char = LocalPlayer.Character
	local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Collision"))
	if not root then return 0 end
	local rooms = workspace:FindFirstChild("CurrentRooms")
	if not rooms then return 0 end
	local best, bestDist = 0, math.huge
	for _, room in pairs(rooms:GetChildren()) do
		local num = tonumber(room.Name)
		if num then
			local part = room:FindFirstChildWhichIsA("BasePart")
			if part then
				local d = (root.Position - part.Position).Magnitude
				if d < bestDist then
					bestDist = d
					best = num
				end
			end
		end
	end
	return best
end

-- ====================== INFINITE ITEMS ======================
local function getNearestModulePrompt(toolId)
	local char = LocalPlayer.Character
	local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Collision"))
	if not root then return nil end
	local best, bestDist = nil, 15
	for _, desc in pairs(workspace:GetDescendants()) do
		if desc:IsA("ProximityPrompt") and desc.Name == "ModulePrompt" then
			local parent = desc.Parent
			if parent and parent:GetAttribute("Tool_ID") == toolId then
				local pos
				if parent:IsA("BasePart") then
					pos = parent.Position
				elseif parent:IsA("Model") then
					pos = parent:GetPivot().Position
				else
					local p = parent:FindFirstChildWhichIsA("BasePart")
					pos = p and p.Position
				end
				if pos then
					local d = (root.Position - pos).Magnitude
					if d < bestDist then
						bestDist = d
						best = desc
					end
				end
			end
		end
	end
	return best
end

local function isLockPrompt(prompt)
	if not prompt or not prompt:IsA("ProximityPrompt") then return false end
	local isDoorLock = prompt.Name == "UnlockPrompt"
		and prompt.Parent and prompt.Parent.Name == "Lock"
		and prompt.Parent.Parent and not prompt.Parent.Parent:GetAttribute("Opened")
	local isSkeletonDoor = prompt.Name == "SkullPrompt"
		and prompt.Parent and prompt.Parent.Name == "SkullLock"
		and not (prompt.Parent:FindFirstChild("Door") and prompt.Parent.Door.Transparency == 1)
	local isChestBox = prompt.Name == "ActivateEventPrompt"
		and prompt.Parent and prompt.Parent.Name == "ChestBoxLocked"
		and prompt.Parent:GetAttribute("Locked")
	local isRoomsDoorLock = false
	pcall(function()
		isRoomsDoorLock = prompt.Parent and prompt.Parent.Parent and prompt.Parent.Parent.Parent
			and prompt.Parent.Parent.Parent.Name == "RoomsDoor_Entrance" and prompt.Enabled
	end)
	return isDoorLock or isSkeletonDoor or isChestBox or isRoomsDoorLock
end

local function mspaintInfItemsOnPrompt(prompt)
	if not Toggles.InfiniteItems then return end
	if not isLockPrompt(prompt) then return end
	local char = LocalPlayer.Character
	if not char then return end
	local equippedTool = char:FindFirstChildOfClass("Tool")
	if not equippedTool then return end
	if not equippedTool:GetAttribute("UniversalKey") then return end
	local toolId = equippedTool:GetAttribute("ID")
	local remotes = getRemotesFolder()
	local dropRemote = remotes and remotes:FindFirstChild("DropItem")
	local isChest = prompt.Name == "ActivateEventPrompt"
		and prompt.Parent and prompt.Parent.Name == "ChestBoxLocked"
	task.wait(isChest and 0.15 or 0)
	if dropRemote then
		pcall(function() dropRemote:FireServer(equippedTool) end)
	else
		pcall(function() equippedTool.Parent = workspace end)
	end
	task.spawn(function()
		pcall(function()
			if equippedTool and equippedTool.Parent then
				equippedTool.Destroying:Wait()
			end
		end)
		task.wait(0.15)
		local pickup = getNearestModulePrompt(toolId)
		if pickup then
			pcall(function() fireproximityprompt(pickup) end)
		end
	end)
end

ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
	if player == LocalPlayer then mspaintInfItemsOnPrompt(prompt) end
end)
ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt, player)
	if player == LocalPlayer then mspaintInfItemsOnPrompt(prompt) end
end)

-- ====================== SCANNER ======================
task.spawn(function()
	while true do
		local rooms = workspace:FindFirstChild("CurrentRooms")
		local currentRoomNum = getCurrentRoomNumber()
		if rooms then
			for _, room in pairs(rooms:GetChildren()) do
				local roomNum = tonumber(room.Name)
				if Toggles.DoorESP and roomNum == currentRoomNum then
					local door = room:FindFirstChild("Door") or room:FindFirstChild("RoomExit")
					if door and not isBadDoor(door, room, currentRoomNum) then
						CreateESP(door, "Door " .. (roomNum + 1), "Door")
					end
				end
				for _, child in pairs(room:GetDescendants()) do
					local n = child.Name
					if Toggles.EntityESP and table.find(EntityNames, n) then
						CreateESP(child, n == "FigureRig" and "Figure" or n, "Entity")
					elseif Toggles.ObjESP and table.find(ObjList, n) then
						local d = (n == "KeyObtain" and "Key")
							or (n == "LeverForGate" and "Lever")
							or (n == "LiveHintBook" and "Book")
							or (n == "LiveBreakerPolePickup" and "Breaker")
							or (n == "ElectricalKeyObtain" and "Electrical Key")
							or n
						CreateESP(child, d, "Objective")
					elseif Toggles.GoldPileESP and n == "GoldPile" then
						CreateESP(child, "Gold", "Gold")
					elseif Toggles.ItemESP and table.find(ItemList, n) then
						CreateESP(child, n, "Item")
					elseif Toggles.HidingESP and table.find(HSList, n) then
						CreateESP(child, n, "Hiding")
					elseif Toggles.ShedESP and n == "Toolshed_Small" then
						CreateESP(child, "Tool Shed", "Shed")
					end
					checkEntityNotify(child)
				end
				task.wait(0.01)
			end
		end
		for obj, data in pairs(activeESPs) do
			if data.Type == "Door" then
				local stillValid = false
				if rooms and Toggles.DoorESP then
					local room = rooms:FindFirstChild(tostring(currentRoomNum))
					if room then
						local door = room:FindFirstChild("Door") or room:FindFirstChild("RoomExit")
						if door == obj and not isBadDoor(door, room, currentRoomNum) then
							stillValid = true
						end
					end
				end
				if not stillValid then Cleanup(obj, data) end
			end
		end
		for _, ent in pairs(workspace:GetChildren()) do
			if table.find(EntityNames, ent.Name) then
				CreateESP(ent, ent.Name == "FigureRig" and "Figure" or ent.Name, "Entity")
			end
			checkEntityNotify(ent)
		end
		if Toggles.PlayerESP then
			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and plr.Character then
					local char = plr.Character
					local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Collision")
					if root then
						CreateESP(char, plr.DisplayName or plr.Name, "Player")
					end
				end
			end
		end
		task.wait(1.2)
	end
end)

workspace.ChildAdded:Connect(function(child)
	task.wait(0.05)
	checkEntityNotify(child)
end)

local roomsFolder = workspace:FindFirstChild("CurrentRooms")
if roomsFolder then
	roomsFolder.DescendantAdded:Connect(function(desc)
		task.wait(0.05)
		checkEntityNotify(desc)
	end)
else
	workspace.ChildAdded:Connect(function(child)
		if child.Name == "CurrentRooms" then
			child.DescendantAdded:Connect(function(desc)
				task.wait(0.05)
				checkEntityNotify(desc)
			end)
		end
	end)
end

-- ====================== UPDATE ESP ======================
local function UpdateESP()
	local rainbow = Color3.fromHSV((tick() % 5) / 5, 1, 1)
	local char = LocalPlayer.Character
	local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Collision"))
	if not root then return end
	for obj, data in pairs(activeESPs) do
		local isEnabled = (data.Type == "Door" and Toggles.DoorESP)
			or (data.Type == "Objective" and Toggles.ObjESP)
			or (data.Type == "Entity" and Toggles.EntityESP)
			or (data.Type == "Gold" and Toggles.GoldPileESP)
			or (data.Type == "Item" and Toggles.ItemESP)
			or (data.Type == "Player" and Toggles.PlayerESP)
			or (data.Type == "Hiding" and Toggles.HidingESP)
			or (data.Type == "Shed" and Toggles.ShedESP)
		if not obj or not obj.Parent or not isEnabled then
			Cleanup(obj, data)
			continue
		end
		local targetPos, adornPart
		if obj:IsA("Model") then
			targetPos = obj:GetPivot().Position
			adornPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
		elseif obj:IsA("BasePart") then
			targetPos = obj.Position
			adornPart = obj
		else
			adornPart = obj:FindFirstChildWhichIsA("BasePart")
			targetPos = adornPart and adornPart.Position
		end
		if not targetPos then continue end
		local dist = (root.Position - targetPos).Magnitude
		if dist > (Options.MaxDistance or 1000) then
			if data.Highlight then data.Highlight.Enabled = false end
			if data.Box then data.Box.Visible = false end
			if data.Bill then data.Bill.Enabled = false end
			continue
		end
		local _, onScreen = Camera:WorldToViewportPoint(targetPos)
		local isKey = (data.Name == "Key" or data.Name == "Electrical Key" or data.Name == "Skeleton Key")
		local shouldShow = isKey or onScreen
		local color = Options.FillColor
		if data.Type == "Entity" then color = Options.EntityColor
		elseif data.Type == "Player" then color = Options.PCol
		elseif data.Type == "Gold" then color = Options.GoldColor
		elseif data.Type == "Item" then color = Options.ItemColor
		elseif data.Type == "Objective" then color = Options.ObjColor
		elseif data.Type == "Hiding" then color = Options.HideCol
		elseif data.Type == "Shed" then color = Options.ShedCol
		end
		if Toggles.RainbowESP then color = rainbow end
		if shouldShow then
			if data.Type == "Door" then
				if not data.Highlight then
					data.Highlight = Instance.new("Highlight")
					data.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					data.Highlight.Parent = obj
				end
				data.Highlight.Enabled = true
				data.Highlight.FillColor = color
				data.Highlight.OutlineColor = color
				data.Highlight.FillTransparency = 0.55
				data.Highlight.OutlineTransparency = 0
				if adornPart and adornPart:IsA("BasePart") then
					if not data.Box then
						data.Box = Instance.new("BoxHandleAdornment")
						data.Box.Name = "DoorBox"
						data.Box.AlwaysOnTop = true
						data.Box.ZIndex = 5
						data.Box.Transparency = 0.65
						data.Box.Parent = adornPart
					end
					data.Box.Adornee = adornPart
					data.Box.Size = adornPart.Size
					data.Box.CFrame = CFrame.new()
					data.Box.Color3 = color
					data.Box.Visible = true
				end
			else
				if not data.Highlight then
					data.Highlight = Instance.new("Highlight")
					data.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					data.Highlight.Parent = obj
				end
				data.Highlight.Enabled = true
				data.Highlight.FillColor = color
				data.Highlight.OutlineColor = color
				data.Highlight.FillTransparency = 0.5
				data.Highlight.OutlineTransparency = 0
			end
			if not data.Bill then
				data.Bill = Instance.new("BillboardGui")
				data.Bill.AlwaysOnTop = true
				data.Bill.Size = UDim2.new(0, 200, 0, 50)
				data.Bill.Parent = obj
				local txt = Instance.new("TextLabel")
				txt.BackgroundTransparency = 1
				txt.Size = UDim2.new(1, 0, 1, 0)
				txt.Font = Enum.Font.GothamBold
				txt.Name = "L"
				txt.TextStrokeTransparency = 0.35
				txt.Parent = data.Bill
			end
			data.Bill.Enabled = Toggles.EnableText
			data.Bill.StudsOffset = Vector3.new(0, Options.TextHeight or 2.5, 0)
			local lbl = data.Bill:FindFirstChild("L")
			if lbl then
				lbl.TextColor3 = color
				if isKey and Options.KeyTextSize then
					lbl.TextSize = Options.KeyTextSize
					data.Bill.Size = UDim2.new(0, 260, 0, 70)
				else
					lbl.TextSize = Options.TextSize or 18
					data.Bill.Size = UDim2.new(0, 160, 0, 40)
				end
				lbl.Text = data.Name .. " [" .. math.floor(dist) .. "]"
			end
		else
			if data.Highlight then data.Highlight.Enabled = false end
			if data.Box then data.Box.Visible = false end
			if data.Bill then data.Bill.Enabled = false end
		end
	end
end

local connection = RunService.RenderStepped:Connect(UpdateESP)

-- ====================== THIRD PERSON ======================
local thirdPersonEnabled = false
local thirdPersonConn = nil
local visibilityConn = nil
local cameraYaw, cameraPitch = 0, 0
local cameraSensitivity, maxPitch = 0.32, 80
local cameraDistance, cameraHeight = 9, 2.2

local function setCharacterVisibility(character, visible)
	if not character then return end
	for _, obj in pairs(character:GetDescendants()) do
		if obj:IsA("BasePart") then
			if obj.Name == "Head" or (obj.Parent and (obj.Parent:IsA("Accessory") or obj.Parent:IsA("Hat"))) then
				obj.LocalTransparencyModifier = visible and 0 or 1
			end
		elseif obj:IsA("Decal") and obj.Parent and obj.Parent.Name == "Head" then
			obj.LocalTransparencyModifier = visible and 0 or 1
		end
	end
end

local function startVisibilityLoop(character)
	if visibilityConn then visibilityConn:Disconnect() visibilityConn = nil end
	if not character then return end
	visibilityConn = RunService.RenderStepped:Connect(function()
		if thirdPersonEnabled and character and character.Parent then
			setCharacterVisibility(character, true)
		end
	end)
end

local function stopVisibilityLoop()
	if visibilityConn then visibilityConn:Disconnect() visibilityConn = nil end
end

local function setThirdPerson(state)
	thirdPersonEnabled = state
	if thirdPersonConn then thirdPersonConn:Disconnect() thirdPersonConn = nil end
	stopVisibilityLoop()
	local cam = workspace.CurrentCamera
	if not cam then return end
	local character = LocalPlayer.Character
	if state then
		cam.CameraType = Enum.CameraType.Scriptable
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.MouseIconEnabled = false
		if character then
			setCharacterVisibility(character, true)
			startVisibilityLoop(character)
			local root = character:FindFirstChild("HumanoidRootPart")
			if root then
				local look = root.CFrame.LookVector
				cameraYaw = math.deg(math.atan2(-look.X, -look.Z))
				cameraPitch = 0
			end
		end
		thirdPersonConn = RunService.RenderStepped:Connect(function()
			local char = LocalPlayer.Character
			if not char then return end
			local root = char:FindFirstChild("HumanoidRootPart")
			if not root then return end
			local delta = UserInputService:GetMouseDelta()
			cameraYaw = cameraYaw - delta.X * cameraSensitivity
			cameraPitch = math.clamp(cameraPitch - delta.Y * cameraSensitivity, -maxPitch, maxPitch)
			local rotation = CFrame.fromEulerAnglesYXZ(math.rad(cameraPitch), math.rad(cameraYaw), 0)
			local targetPos = root.Position + Vector3.new(0, cameraHeight, 0)
			local camPos = targetPos + rotation:VectorToWorldSpace(Vector3.new(0, 0, cameraDistance))
			cam.CFrame = CFrame.lookAt(camPos, targetPos)
			cam.Focus = CFrame.new(targetPos)
		end)
		pcall(function()
			Starlight:Notify({ Title = "Third Person", Content = "Enabled (V)", Duration = 2 })
		end)
	else
		cam.CameraType = Enum.CameraType.Custom
		if character then
			local hum = character:FindFirstChildOfClass("Humanoid")
			if hum then cam.CameraSubject = hum end
			setCharacterVisibility(character, false)
		end
		LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
		LocalPlayer.CameraMaxZoomDistance = 0.5
		LocalPlayer.CameraMinZoomDistance = 0.5
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		UserInputService.MouseIconEnabled = true
		pcall(function()
			Starlight:Notify({ Title = "Third Person", Content = "Disabled", Duration = 2 })
		end)
	end
end

-- ====================== KEYBINDS ======================
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.V then
		setThirdPerson(not thirdPersonEnabled)
	elseif input.KeyCode == OFFSET_KEY then
		togglePositionOffset()
	end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
	task.wait(1)
	clearSaved()
	if thirdPersonEnabled then
		setThirdPerson(true)
	else
		setCharacterVisibility(newChar, false)
	end
	if positionOffsetEnabled then
		applyPositionOffset(true)
	end
end)

-- Keybind HUD
local keybindGui = Instance.new("ScreenGui")
keybindGui.Name = "MsFentKeybinds"
keybindGui.ResetOnSpawn = false
keybindGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
keybindGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 230, 0, 95)
frame.Position = UDim2.new(0, 12, 0.5, -47)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = keybindGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(140, 60, 200)
stroke.Thickness = 1.2
stroke.Transparency = 0.25
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 24)
title.BackgroundTransparency = 1
title.Text = "Keybinds"
title.TextColor3 = Color3.fromRGB(210, 210, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, -14, 0, 65)
keyLabel.Position = UDim2.new(0, 7, 0, 26)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "V  →  Toggle Third Person\nG  →  Position Offset (ground)"
keyLabel.TextColor3 = Color3.fromRGB(190, 190, 205)
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextSize = 13
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.TextYAlignment = Enum.TextYAlignment.Top
keyLabel.Parent = frame

-- ====================== UI SETTINGS ======================
local MenuGroup = UISettingsTab:CreateGroupbox({
	Name = "Menu",
	Icon = NebulaIcons:GetIcon("settings", "Material"),
}, "MenuGroup")

MenuGroup:CreateButton({
	Name = "Unload",
	Callback = function()
		connection:Disconnect()
		if instantConn then instantConn:Disconnect() end
		stopAutoInteract()
		stopDeleteScreech()
		positionOffsetEnabled = false
		applyPositionOffset(false)
		if positionOffsetConn then positionOffsetConn:Disconnect() end
		if thirdPersonConn then thirdPersonConn:Disconnect() end
		stopVisibilityLoop()
		if thirdPersonEnabled then setThirdPerson(false) end
		for obj, data in pairs(activeESPs) do Cleanup(obj, data) end
		if keybindGui then keybindGui:Destroy() end
		pcall(function() Starlight:Destroy() end)
	end,
}, "Unload")

MenuGroup:CreateLabel({
	Name = "V = Third Person | G = Position Offset",
}, "KeybindInfo")

print("MsFent Doors (Starlight) loaded!")
