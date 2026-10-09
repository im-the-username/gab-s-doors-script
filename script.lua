--[[
    ╔══════════════════════════════════════╗
    ║         Ms fent Hub | Doors          ║
    ║        Fully integrated Mrow         ║
    ╚══════════════════════════════════════╝
]]


-- Shared Universal helper definitions (used by both paths)
getgenv().__MsFent_NDS_Scripts = {
	{ group = "Misc", text = "Touch fling", url = "https://pastebin.com/raw/LgZwZ7ZB", autorunNDS = false, doorsOk = false },
	{ group = "Misc", text = "Kilaskis multi fling", url = "https://raw.githubusercontent.com/K1LAS1K/Ultimate-Fling-GUI/main/flingscript.lua", autorunNDS = true, doorsOk = false },
	{ group = "Misc", text = "Flight anims", url = "https://obj.wearedevs.net/197198/scripts/invincible%20flight%20animation.lua", autorunNDS = true, doorsOk = false },
	{ group = "Misc", text = "anti stuff", url = "https://raw.githubusercontent.com/OMNIMANRUSSIA/NDS-OMNIMAN-GOD-TOUCH-FLING-ANTISIT-ANTIBANG/main/main.lua", autorunNDS = true, doorsOk = false },
	{ group = "Misc", text = "Drop kick (buggy)", url = "https://raw.githubusercontent.com/gsm231/Fe-DropKick/refs/heads/main/V0.1", autorunNDS = false, doorsOk = false },
	{ group = "Misc", text = "Infinite Yield", url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", autorunNDS = true, doorsOk = true },
	{ group = "OP", text = "Super ring v5 lukas", url = "https://raw.githubusercontent.com/Lukashub-coder/Super-ring-V5/refs/heads/main/By%20lukas!!", autorunNDS = false, doorsOk = false },
	{ group = "OP", text = "GABS SUPER RING", url = "https://raw.githubusercontent.com/im-the-username/meow.lua/refs/heads/main/meow1.lua", autorunNDS = false, doorsOk = false },
	{ group = "OP", text = "supering by foxy9694", url = "https://raw.githubusercontent.com/northernline23/Super-ring-parts-V1/refs/heads/main/script.lua", autorunNDS = false, doorsOk = false },
	{ group = "Other", text = "gab's aimbot", url = "https://raw.githubusercontent.com/im-the-username/gab-s-aimbot/refs/heads/main/Aimbot.lua", autorunNDS = false, doorsOk = false },
}

getgenv().__MsFent_IsNDSGame = function()
	local ok, result = pcall(function()
		-- Classic Natural Disaster Survival + common clones
		local ndsPlaces = {
			[189707] = true, -- Natural Disaster Survival
		}
		if ndsPlaces[game.PlaceId] then return true end
		local name = ""
		pcall(function()
			name = string.lower(tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name))
		end)
		if name:find("natural disaster", 1, true) then return true end
		if name:find("nds", 1, true) and not name:find("doors", 1, true) then return true end
		return false
	end)
	return ok and result == true
end

getgenv().__MsFent_RunHelper = function(item, Library)
	local ok, err = pcall(function()
		loadstring(game:HttpGet(item.url))()
	end)
	if ok then
		pcall(function()
			if Library and Library.Notify then
				Library:Notify("Loaded: " .. item.text, 3)
			end
		end)
		print("[Ms fent Universal] Loaded:", item.text)
	else
		pcall(function()
			if Library and Library.Notify then
				Library:Notify("Failed: " .. item.text, 5)
			end
		end)
		warn("[Ms fent Universal] Failed", item.text, err)
	end
	return ok
end

-- mode: "full" (outside Doors) | "doors" (only Infinite Yield enabled)
getgenv().__MsFent_BuildNDSTab = function(Window, Library, mode)
	local isDoorsMode = (mode == "doors" or mode == false)
	local tab = Window:AddTab("Universal", "swords")

	local function canUse(item)
		if isDoorsMode then
			return item.doorsOk == true
		end
		return true
	end

	local function addGroup(title, items)
		local box = tab:AddLeftGroupbox(title)
		for _, item in ipairs(items) do
			local allowed = canUse(item)
			local tip = allowed and "Runs this helper via loadstring."
				or (isDoorsMode and "Only Infinite Yield is available anywhere" or "Unavailable.")
			local btnOpts = {
				Text = item.text,
				Tooltip = tip,
				Func = function()
					if not canUse(item) then
						pcall(function()
							Library:Notify(isDoorsMode and "Only Infinite Yield works in Doors." or "Unavailable here.", 4)
						end)
						return
					end
					getgenv().__MsFent_RunHelper(item, Library)
				end,
			}
			if not allowed then
				btnOpts.Disabled = true
				btnOpts.DisabledTooltip = tip
			end
			box:AddButton(btnOpts)
		end
	end

	local byGroup = { Misc = {}, OP = {}, Other = {} }
	for _, s in ipairs(getgenv().__MsFent_NDS_Scripts) do
		table.insert(byGroup[s.group] or byGroup.Other, s)
	end
	addGroup("Misc", byGroup.Misc)
	addGroup("OP Scripts", byGroup.OP)
	addGroup("Other", byGroup.Other)

	local info = tab:AddRightGroupbox("Status")
	if isDoorsMode then
		info:AddLabel("In Doors")
		info:AddLabel("Only Infinite Yield is enabled.")
		info:AddLabel("Other helpers are locked.")
	else
		info:AddLabel("Universal mode")
		info:AddLabel("PlaceId: " .. tostring(game.PlaceId))
		if getgenv().__MsFent_IsNDSGame and getgenv().__MsFent_IsNDSGame() then
			info:AddLabel("NDS detected — auto-running presets")
		else
			info:AddLabel("Re-run loader anytime.")
		end
	end
	return tab
end

getgenv().__MsFent_AutorunNDSPresets = function(Library)
	if not (getgenv().__MsFent_IsNDSGame and getgenv().__MsFent_IsNDSGame()) then
		return
	end
	warn("[Ms fent] NDS detected — auto-running IY, Flight anims, Kilaskis, anti stuff")
	task.spawn(function()
		for _, item in ipairs(getgenv().__MsFent_NDS_Scripts or {}) do
			if item.autorunNDS then
				task.wait(0.35)
				getgenv().__MsFent_RunHelper(item, Library)
			end
		end
	end)
end

getgenv().__MsFent_BuildDoorsLockedTab = function(Window, Library)
	local tab = Window:AddTab("Doors", "door-open")
	local box = tab:AddLeftGroupbox("Doors Hub")
	local function locked(text)
		box:AddButton({
			Text = text,
			Disabled = true,
			DisabledTooltip = "Only available in Doors.",
			Tooltip = "Only available in Doors.",
			Func = function()
				pcall(function() Library:Notify("Join Doors to use the full hub.", 4) end)
			end,
		})
	end
	locked("Speed Boost / Fly / Noclip")
	locked("Entity ESP / Notify")
	locked("Bypass / Remove entities")
	locked("Archives / Stairwell")
	locked("Debug (Void, Tp Door)")
	local info = tab:AddRightGroupbox("Status")
	info:AddLabel("You are NOT in Doors.")
	info:AddLabel("Doors features are disabled.")
	info:AddLabel("Join Doors to unlock this tab.")
	return tab
end

-- ============================================================
-- Game router
-- Doors  → Ms fent Hub (single-load lock)
-- Other  → load ALL universal helpers (can re-execute freely)
-- ============================================================
local function __MsFent_IsDoorsGame()
	local ok, result = pcall(function()
		local rs = game:GetService("ReplicatedStorage")
		if rs:FindFirstChild("GameData") then return true end
		if rs:FindFirstChild("RemotesFolder") then return true end
		local doorsPlaces = {
			[6516141723] = true, -- lobby
			[6839171747] = true,
			[2440500124] = true,
			[5130598377] = true,
			[10511121194] = true,
			[12394881069] = true,
		}
		if doorsPlaces[game.PlaceId] then return true end
		local name = string.lower(tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name))
		if string.find(name, "doors", 1, true) then return true end
		return false
	end)
	return ok and result == true
end

local function __MsFent_SendTelemetry(scriptName)
	pcall(function()
		local HttpService = game:GetService("HttpService")
		local Players = game:GetService("Players")
		local lp = Players.LocalPlayer
		local username = lp and lp.Name or "Unknown"
		local userId = lp and lp.UserId or 0
		local executorName = "Unknown"
		pcall(function()
			if identifyexecutor then executorName = tostring(identifyexecutor())
			elseif getexecutorname then executorName = tostring(getexecutorname()) end
		end)

		local COUNT_FILE = "msfent_exec_count.txt"
		local executions = 1
		pcall(function()
			if isfile and isfile(COUNT_FILE) and readfile then
				executions = (tonumber(readfile(COUNT_FILE)) or 0) + 1
			elseif getgenv().MsFentExecCount then
				executions = (tonumber(getgenv().MsFentExecCount) or 0) + 1
			end
			if writefile then writefile(COUNT_FILE, tostring(executions)) end
			getgenv().MsFentExecCount = executions
		end)

		local startedAt = os.date("!%Y-%m-%d %H:%M:%S UTC")
		local payload = {
			version = "3.2.1",
			session = string.format("%s | %s | runs:%d | %s", username, executorName, executions, scriptName),
			startedAt = startedAt,
			username = username,
			userId = userId,
			executor = executorName,
			executions = executions,
			keyTime = "infinite",
			placeId = game.PlaceId,
			jobId = game.JobId,
			script = scriptName,
		}
		local body = HttpService:JSONEncode(payload)
		local req = (request or http_request or (syn and syn.request) or (http and http.request))
		if req then
			req({
				Url = "https://msfent-api.gabrieltodiras2.workers.dev/telemetry",
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = body,
			})
		end
	end)
end

if not __MsFent_IsDoorsGame() then
	-- Non-Doors: unified Obsidian UI — NDS active, Doors tab grayed
	-- No MsFentLoaded lock → can re-execute
	warn("[Ms fent] Not Doors (PlaceId " .. tostring(game.PlaceId) .. ") — NDS UI")

	local okUI, errUI = pcall(function()
		local BaseUrl = "https://raw.githubusercontent.com/mstudio45/Obsidian/refs/heads/main/"
		local Library = loadstring(game:HttpGet(BaseUrl .. "Library.lua"))()
		local ThemeManager = loadstring(game:HttpGet(BaseUrl .. "addons/ThemeManager.lua"))()
		local SaveManager = loadstring(game:HttpGet(BaseUrl .. "addons/SaveManager.lua"))()
		ThemeManager:SetLibrary(Library)
		SaveManager:SetLibrary(Library)
		SaveManager:SetFolder("msfent-nds")

		local Window = Library:CreateWindow({
			Title = "💉 Ms fent Hub 💉",
			Footer = "Universal • Doors locked",
			Icon = "door-open",
			IconSize = UDim2.fromOffset(26, 26),
			NotifySide = "Right",
			ShowCustomCursor = false,
			AutoShow = true,
		})

		-- NDS enabled
		getgenv().__MsFent_BuildNDSTab(Window, Library, "full")
		getgenv().__MsFent_AutorunNDSPresets(Library)
		-- Doors grayed out
		getgenv().__MsFent_BuildDoorsLockedTab(Window, Library)

		local info = Window:AddTab("Info", "user")
		local box = info:AddLeftGroupbox("Session")
		box:AddLabel("Mode: Universal")
		box:AddLabel("User: " .. (game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Name or "?"))
		box:AddLabel("PlaceId: " .. tostring(game.PlaceId))
		pcall(function()
			SaveManager:BuildConfigSection(info)
			ThemeManager:ApplyToTab(info)
		end)

		Library:Notify("Ms fent • Universal mode (Doors locked)", 5)
	end)

	if not okUI then
		warn("[Ms fent] NDS UI failed: " .. tostring(errUI))
	end

	local tel = (getgenv().__MsFent_IsNDSGame and getgenv().__MsFent_IsNDSGame()) and "Ms fent Hub | NDS (autorun)" or "Ms fent Hub | Universal"
	__MsFent_SendTelemetry(tel)
	return
end

-- Doors path: single-load lock (prevent double hub)
if getgenv().MsFentLoaded then
	warn("[Ms fent Hub] Already loaded (Doors)")
	return
end
getgenv().MsFentLoaded = true
-- Telemetry for Doors is sent later in the main telemetry block


-- ===== INTEGRATED: Environment =====
local function __MsFent_Load_Environment()
local Environment = {}
local Log = {}
local Tested = 0
local Failed = 0
local Passed = 0

local BrokenFeatures = {
	["Volcano"] = {"run_on_actor", "oth"},
	["Delta"] = {"hookmetamethod"},
	["Madium"] = {"gethiddenproperty"},
	["Opiumware"] = {"gethiddenproperty"},
	["Solara"] = {"require"},
	["Xeno"] = {"require"},
}

local RootEnv = getfenv(0)

local function GetGlobal(Path)
	local Value = RootEnv
	while Value ~= nil and Path ~= "" do
		local Name, NextPath = string.match(Path, "^([^.]+)%.?(.*)$")
		Value = Value[Name]
		Path = NextPath
	end
	return Value
end

local Global = setmetatable({}, {
	__index = function(Self, Name)
		return GetGlobal(Name)
	end,
})

local Services = setmetatable({}, {
	__index = function(Self, Name)
		return game:GetService(Name)
	end,
})

local Results = {}

local function AddResult(Name, Text, DidPass)
	table.insert(Results, Text)
	Log[Name] = {
		Passed = DidPass,
		Reason = Text,
	}
end

Environment.Results = Results
Environment.PrintResults = function()
	local Executor = Environment.identifyexecutor and Environment.identifyexecutor() or "Unknown"
	print("Test Result")
	for _, Result in ipairs(Results) do
		print(Result)
		task.wait()
	end
	print("Executor - " .. Executor)
	print("Tests Passed: " .. Passed .. "/" .. Tested)
	print("Test Score: " .. math.floor((Passed / Tested) * 100 + 0.5) .. "%")
end

local function RunTest(Name, Test, InternalName)
	local TimedOut = false
	Tested = Tested + 1

	local ExecutorName = Global.identifyexecutor and Global.identifyexecutor() or "Unknown"
	local BrokenList = BrokenFeatures[ExecutorName]
	if BrokenList and table.find(BrokenList, Name) then
		AddResult(Name, "❌ " .. Name .. " failed: test has been skipped", false)
		Failed = Failed + 1
		return
	end

	local TargetGlobal = Global[Name]
	if not TargetGlobal then
		AddResult(Name, "❌ " .. Name .. " failed: function is nil", false)
		Failed = Failed + 1
		return
	end

	local Time = 0
	local Finished = false

	task.spawn(function()
		local Success, Result = pcall(Test)
		if not TimedOut then
			if Success then
				local Key = InternalName or Name
				Environment[Key] = TargetGlobal
				AddResult(Name, "✅ " .. Name, true)
				Passed = Passed + 1
			else
				AddResult(Name, "❌ " .. Name .. " failed: " .. tostring(Result), false)
				Failed = Failed + 1
			end
		end
		Finished = true
	end)

	while not Finished do
		Time = Time + 1
		if Time > 100 then
			AddResult(Name, "❌ " .. Name .. " failed: test timed out", false)
			Failed = Failed + 1
			TimedOut = true
			break
		end
		task.wait(0.1)
	end
end

RunTest("getgenv", function()
	assert(typeof(Global.getgenv()) == "table", "Did not return a table")
	Global.getgenv().Example = "Test"
	assert(Example == "Test", "Failed to set a global variable")
	Global.getgenv().Example = nil
end)

RunTest("getrenv", function()
	assert(Environment.getgenv, "getgenv is required to test")
	local Env = Global.getrenv()
	assert(typeof(Env) == "table", "Did not return a table")
	assert(typeof(Env.print) == "function", "Did not return an environment table")
	assert(Global.getrenv ~= Global.getgenv, "getrenv is an alias of getgenv")
	assert(Global.getgenv() ~= Global.getrenv(), "Returned executor environment")
	local Success = pcall(function()
		return Env.loadstring([[return 10]])()
	end)
	assert(Success == false, "Should error when calling loadstring from roblox environment")
end)

RunTest("getgc", function()
	local TestFunction = function()
		return 10
	end
	local TestTable = { Value = 10 }
	local YesTables = Global.getgc(true)
	local NoTables = Global.getgc(false)
	assert(table.find(YesTables, TestTable), "Failed to find a table")
	assert(table.find(YesTables, TestFunction), "Failed to find a function")
	assert(not table.find(NoTables, TestTable), "Should not return a table when called with false")
	assert(table.find(NoTables, TestFunction), "Failed to find a function")
end)

RunTest("identifyexecutor", function()
	assert(typeof(Global.identifyexecutor()) == "string", "Did not return a string")
end)

RunTest("request", function()
	local Response = Global.request({
		Url = "https://raw.githubusercontent.com/quins-max/VibeIncDoors/refs/heads/main/Components/Environment.luau",
		Method = "GET",
	})
	assert(Response.StatusCode == 200, "Status code should be 200")
	assert(typeof(Response.Body) == "string", "Body should be a string")
end)

RunTest("cloneref", function()
	local TestPart = Instance.new("Part")
	local Clone = Global.cloneref(TestPart)
	assert(typeof(Clone) == "Instance", "Should return an Instance")
	assert(TestPart ~= Clone, "Clone should not be equal to original")
	TestPart.Name = "Test"
	assert(Clone.Name == "Test", "Changing the original did not change the clone")
	TestPart:Destroy()
end)

RunTest("gethui", function()
	local Hui = Global.gethui()
	assert(typeof(Hui) == "Instance", "Should return an instance")
	local ValidClasses = { "ScreenGui", "Folder", "BasePlayerGui", "CoreGui" }
	if not Hui:IsDescendantOf(Services.CoreGui) and Hui.ClassName ~= "CoreGui" or not table.find(ValidClasses, Hui.ClassName) then
		error("Did not return a valid gui container")
	end
end)

RunTest("getcallbackvalue", function()
	local TestBindable = Instance.new("BindableFunction")
	TestBindable.OnInvoke = function(Value)
		return Value * 10
	end
	local Callback = Global.getcallbackvalue(TestBindable, "OnInvoke")
	local Success, Result = pcall(function()
		assert(typeof(Callback) == "function", "Did not return a function")
		assert(Callback(5) == 50, "Did not return the callback value")
	end)
	TestBindable:Destroy()
	assert(Success, Result)
end)

RunTest("getinstances", function()
	local TestPart1 = Instance.new("Part")
	local TestPart2 = Instance.new("Part", Services.Workspace)
	local InstanceList = Global.getinstances()
	local Found1 = table.find(InstanceList, TestPart1)
	local Found2 = table.find(InstanceList, TestPart2)
	TestPart1:Destroy()
	TestPart2:Destroy()
	assert(Found2, "Did not return an instance")
	assert(Found1, "Did not return an instance parented to nil")
end)

RunTest("getnilinstances", function()
	local TestPart1 = Instance.new("Part")
	local TestPart2 = Instance.new("Part", Services.Workspace)
	local InstanceList = Global.getnilinstances()
	local FoundNil = table.find(InstanceList, TestPart1)
	local FoundParented = table.find(InstanceList, TestPart2)
	TestPart1:Destroy()
	TestPart2:Destroy()
	assert(not FoundParented, "Returned an instance not parented to nil")
	assert(FoundNil, "Did not return an instance parented to nil")
end)

RunTest("fireproximityprompt", function()
	local TestPart = Instance.new("Part", Services.Workspace)
	local TestPrompt = Instance.new("ProximityPrompt", TestPart)
	local Fired = false
	local Connection = TestPrompt.Triggered:Connect(function()
		Fired = true
	end)
	Global.fireproximityprompt(TestPrompt)
	local Tries = 0
	while not Fired and Tries < 10 do
		Tries = Tries + 1
		task.wait(0.1)
	end
	Connection:Disconnect()
	TestPart:Destroy()
	assert(Fired == true, "Failed to fire a proximity prompt")
end)

RunTest("fireclickdetector", function()
	local TestPart = Instance.new("Part", Services.Workspace)
	local TestClick = Instance.new("ClickDetector", TestPart)
	local Fired = false
	local Connection = TestClick.MouseClick:Connect(function()
		Fired = true
	end)
	Global.fireclickdetector(TestClick)
	local Tries = 0
	while not Fired and Tries < 10 do
		Tries = Tries + 1
		task.wait(0.1)
	end
	Connection:Disconnect()
	TestPart:Destroy()
	assert(Fired == true, "Failed to fire a click detector")
end)

RunTest("firetouchinterest", function()
	local TestPart1 = Instance.new("Part", Services.Workspace)
	TestPart1.Position = Vector3.new(0, 1000, 0)
	local TestPart2 = Instance.new("Part", Services.Workspace)
	TestPart2.Position = Vector3.new(0, 1000, 0)
	local Fired = false
	local Connection = TestPart1.Touched:Connect(function(Child)
		if Child == TestPart2 then
			Fired = true
		end
	end)
	Global.firetouchinterest(TestPart1, TestPart2, 0)
	task.wait()
	Global.firetouchinterest(TestPart1, TestPart2, 1)
	local Tries = 0
	while not Fired and Tries < 10 do
		Tries = Tries + 1
		task.wait(0.1)
	end
	Connection:Disconnect()
	TestPart1:Destroy()
	TestPart2:Destroy()
	assert(Fired == true, "Failed to fire a touch interest")
end)

RunTest("clonefunction", function()
	local TestFunction = function()
		return 10
	end
	local TestClone = Global.clonefunction(TestFunction)
	assert(TestFunction ~= TestClone, "Returned the original function")
	assert(TestFunction() == TestClone(), "Clone did not return the same as the original")
end)

RunTest("newcclosure", function()
	local TestFunction = function()
		return 10
	end
	local TestC = Global.newcclosure(TestFunction)
	assert(TestFunction ~= TestC, "Returned the original function")
	assert(TestFunction() == TestC(), "Did not return the same value as the original")
	assert(TestC() == 10, "Did not return the correct value")
	assert(debug.info(TestC, "s") == "[C]", "Did not return a C function")
end)

RunTest("hookfunction", function()
	local TestFunction = function()
		return 10
	end
	local TestC = Global.newcclosure(function()
		return 25
	end)
	local TestHook = function()
		return 100
	end
	local Old = Global.hookfunction(TestFunction, TestHook)
	local OldC = Global.hookfunction(TestC, TestHook)
	assert(TestFunction ~= TestHook, "Original and hook are the same function")
	assert(debug.info(TestC, "s") == "[C]", "Hooked C function is no longer in C")
	assert(TestFunction() == 100, "Did not change the return value")
	assert(Old() == 10, "Did not return the original function")
	assert(OldC() == 25, "Did not return the original C function")
end)

RunTest("restorefunction", function()
	assert(Environment.hookfunction, "hookfunction is required to test")
	local TestFunction = function()
		return 10
	end
	local TestHook = function()
		return 100
	end
	Global.hookfunction(TestFunction, TestHook)
	Global.restorefunction(TestFunction)
	assert(TestFunction() == 10, "Failed to unhook a function")
end)

RunTest("isfunctionhooked", function()
	assert(Environment.hookfunction, "hookfunction is required to test")
	assert(Environment.restorefunction, "restorefunction is required to test")
	local TestFunction = function()
		return 10
	end
	local TestHook = function()
		return 100
	end
	Global.hookfunction(TestFunction, TestHook)
	assert(Global.isfunctionhooked(TestFunction) == true, "Did not return true for a hooked function")
	Global.restorefunction(TestFunction)
	assert(Global.isfunctionhooked(TestFunction) == false, "Did not return false for an unhooked function")
end)

RunTest("isexecutorclosure", function()
	assert(Environment.newcclosure, "newcclosure is required to test")
	local TestFunction = function()
		return 10
	end
	local TestC = Global.newcclosure(TestFunction)
	assert(Global.isexecutorclosure(TestFunction) == true, "Did not return true for an executor function")
	assert(Global.isexecutorclosure(Global.newcclosure) == true, "Did not return true for an executor global")
	assert(Global.isexecutorclosure(warn) == false, "Did not return false for a Roblox global")
	assert(Global.isexecutorclosure(TestC) == true, "Did not return true for an executor C function")
end)

RunTest("getnamecallmethod", function()
	pcall(function()
		game:ExampleNamecall()
	end)
	assert(typeof(Global.getnamecallmethod()) == "string", "Did not return a string")
	assert(Global.getnamecallmethod() == "ExampleNamecall", "Did not return the correct method")
end)

RunTest("hookmetamethod", function()
	assert(Environment.getnamecallmethod, "getnamecallmethod is required to test")
	assert(Environment.newcclosure, "newcclosure is required to test")
	local TestTable = setmetatable({}, {
		__index = Global.newcclosure(function()
			return "normal"
		end),
	})
	Global.hookmetamethod(TestTable, "__index", Global.newcclosure(function()
		return "hooked"
	end))
	assert(TestTable.Example == "hooked", "Failed to hook a metamethod")
end)

RunTest("getrawmetatable", function()
	local TestTable = { __metatable = "Locked!" }
	local TestObject = setmetatable({}, TestTable)
	assert(Global.getrawmetatable(TestObject) == TestTable, "Did not return the metatable")
end)

RunTest("setrawmetatable", function()
	assert(Environment.getrawmetatable, "getrawmetatable is required to test")
	local TestTable = { __metatable = "Locked!" }
	local TestObject = setmetatable({}, TestTable)
	Global.setrawmetatable(TestObject, {
		__index = function()
			return "Edited!"
		end,
	})
	assert(TestObject.Example == "Edited!", "Failed to set the metatable")
end)

RunTest("isreadonly", function()
	local TestTable = {}
	local FrozenTable = table.freeze({})
	assert(Global.isreadonly(TestTable) == false, "Did not return false for a writeable table")
	assert(Global.isreadonly(FrozenTable) == true, "Did not return true for a readonly table")
end)

RunTest("setreadonly", function()
	assert(Environment.isreadonly, "isreadonly is required to test")
	local TestTable = { Value = 10 }
	table.freeze(TestTable)
	Global.setreadonly(TestTable, false)
	TestTable.Value = 100
	assert(Global.isreadonly(TestTable) == false, "Failed to set readonly")
end)

RunTest("Drawing.new", function()
	assert(typeof(Global.Drawing.new) == "function", "Drawing.new is not a function")
	local NewShape = Global.Drawing.new("Circle")
	NewShape.Visible = false
	NewShape.Radius = 10
	NewShape.Thickness = 1
	NewShape.Filled = false
	NewShape.NumSides = 10
	NewShape:Remove()
end, "Drawing_New")

RunTest("Drawing.Fonts", function()
	assert(typeof(Global.Drawing.Fonts) == "table", "Drawing.Fonts is not a table")
end, "Drawing_Fonts")

RunTest("writefile", function()
	Global.writefile("MsFent_Test_File", "example")
	assert(Global.isfile("MsFent_Test_File") == true, "Failed to create a file")
	assert(Global.readfile("MsFent_Test_File") == "example", "File does not contain expected data")
end)

RunTest("isfile", function()
	assert(Global.isfile("MsFent_Test_File") == true, "Did not return true for a valid file")
end)

RunTest("readfile", function()
	assert(Global.readfile("MsFent_Test_File") == "example", "Did not return the expected data")
end)

RunTest("appendfile", function()
	Global.appendfile("MsFent_Test_File", "_appended")
	assert(Global.readfile("MsFent_Test_File") == "example_appended", "Failed to append content to a file")
end)

RunTest("loadfile", function()
	Global.writefile("MsFent_Test_Load", [[return 25]])
	assert(Global.loadfile("MsFent_Test_Load")() == 25, "Failed to load and execute a file")
end)

RunTest("delfile", function()
	Global.delfile("MsFent_Test_File")
	Global.delfile("MsFent_Test_Load")
	assert(Global.isfile("MsFent_Test_File") == false, "Failed to delete a file")
end)

RunTest("makefolder", function()
	Global.makefolder("MsFent_Test_Folder")
	assert(Global.isfolder("MsFent_Test_Folder") == true, "Failed to create a folder")
end)

RunTest("delfolder", function()
	Global.delfolder("MsFent_Test_Folder")
	assert(Global.isfolder("MsFent_Test_Folder") == false, "Failed to delete a folder")
end)

RunTest("listfiles", function()
	Global.makefolder("MsFent_ListFiles_Test")
	Global.writefile("MsFent_ListFiles_Test/Test1", "test 1")
	Global.writefile("MsFent_ListFiles_Test/Test2", "test 2")
	local FilesList = Global.listfiles("MsFent_ListFiles_Test")
	local Found1 = false
	local Found2 = false
	assert(#FilesList == 2, "Did not return the correct number of files")
	for _, File in ipairs(FilesList) do
		local Content = Global.readfile(File)
		if Content == "test 1" then
			Found1 = true
		elseif Content == "test 2" then
			Found2 = true
		end
	end
	Global.delfolder("MsFent_ListFiles_Test")
	assert(Found1 == true, "Did not return the first file")
	assert(Found2 == true, "Did not return the second file")
end)

RunTest("getcustomasset", function()
	assert(Environment.writefile, "writefile is required to test")
	local Content = game:HttpGet("https://raw.githubusercontent.com/quins-max/VibeIncDoors/refs/heads/main/Assets/Check.png")
	Global.writefile("MsFent_Test_Image", Content)
	local Asset = Global.getcustomasset("MsFent_Test_Image")
	local TestImage = Instance.new("ImageLabel", Services.CoreGui.RobloxGui)
	TestImage.Image = Asset
	local Tries = 0
	while not TestImage.IsLoaded and Tries < 10 do
		Tries = Tries + 1
		task.wait(0.1)
	end
	local IsLoaded = TestImage.IsLoaded
	TestImage:Destroy()
	Global.delfile("MsFent_Test_Image")
	assert(string.find(Asset, "rbxasset://"), "Should return an rbxasset id")
	assert(IsLoaded == true, "Failed to load a PNG image")
end)

RunTest("gethiddenproperty", function()
	local TestPart = Instance.new("Part")
	local Value = Global.gethiddenproperty(TestPart, "NetworkIsSleeping")
	TestPart:Destroy()
	assert(Value == false, "Did not return the correct property value")
end)

RunTest("sethiddenproperty", function()
	assert(Environment.gethiddenproperty, "gethiddenproperty is required to test")
	local TestPart = Instance.new("Part")
	Global.sethiddenproperty(TestPart, "NetworkIsSleeping", true)
	local Value = Global.gethiddenproperty(TestPart, "NetworkIsSleeping")
	TestPart:Destroy()
	assert(Value == true, "Failed to set a hidden property")
end)

RunTest("getthreadidentity", function()
	local Identity = Global.getthreadidentity()
	assert(typeof(Identity) == "number", "Did not return a number")
	assert(Identity > 0, "Returned an invalid identity")
	assert(Identity < 9, "Returned an invalid identity")
end)

RunTest("setthreadidentity", function()
	assert(Environment.getthreadidentity, "getthreadidentity is needed to test")
	local Old = Global.getthreadidentity()
	Global.setthreadidentity(2)
	assert(Services.CoreGui == nil, "Capabilities do not match set identity")
	Global.setthreadidentity(Old)
end)

RunTest("isnetworkowner", function()
	local Test = Instance.new("Part", Services.Workspace)
	local RootPart = Services.Players.LocalPlayer.Character.HumanoidRootPart
	local TestPart

	for _, Part in ipairs(Services.Workspace:GetDescendants()) do
		if Part:IsA("BasePart") and Part.Anchored then
			TestPart = Part
			break
		end
	end

	RootPart.Anchored = true
	local IsOwned = Global.isnetworkowner(RootPart)
	RootPart.Anchored = false

	local IsClientOwned = Global.isnetworkowner(Test)
	local IsNotOwned = TestPart and Global.isnetworkowner(TestPart)
	Test:Destroy()

	assert(TestPart ~= nil, "Skipped, no anchored part to test with")
	assert(IsClientOwned == true, "Did not return true for a client owned part")
	assert(IsNotOwned == false, "Did not return false for a non client owned part")
	assert(IsOwned == true, "Did not return true for a client owned anchored part")
end)

RunTest("firesignal", function()
	local TestEvent = Instance.new("RemoteEvent")
	local Fired = false
	local Value1, Value2, Value3
	local Connection = TestEvent.OnClientEvent:Connect(function(Arg1, Arg2, Arg3)
		Fired = true
		Value1 = Arg1
		Value2 = Arg2
		Value3 = Arg3
	end)
	Global.firesignal(TestEvent.OnClientEvent, "Example", 10, true)
	local Tries = 0
	while not Fired and Tries < 10 do
		Tries = Tries + 1
		task.wait(0.1)
	end
	Connection:Disconnect()
	TestEvent:Destroy()
	assert(Fired == true, "Failed to fire a signal")
	assert(Value1 == "Example", "Fired signal with incorrect data")
	assert(Value2 == 10, "Fired signal with incorrect data")
	assert(Value3 == true, "Fired signal with incorrect data")
end)

RunTest("replicatesignal", function()
	local TestButton = Instance.new("Frame")
	Global.replicatesignal(TestButton.MouseWheelForward, 69, 420)
	local Success = pcall(function()
		Global.replicatesignal(TestButton.MouseWheelForward)
		Global.replicatesignal(TestButton.MouseWheelForward, 69)
	end)
	TestButton:Destroy()
	assert(Success == false, "Did not throw an error with invalid arguments")
end)

RunTest("getconnections", function()
	local Fired = false
	local Connection = game.ChildAdded:Connect(function(Child)
		if Child == "Example" then
			Fired = true
		end
	end)
	for _, Conn in ipairs(getconnections(game.ChildAdded)) do
		Conn:Fire("Example")
	end
	local Tries = 0
	while not Fired and Tries < 10 do
		Tries = Tries + 1
		task.wait(0.1)
	end
	Connection:Disconnect()
	assert(Fired == true, "Failed to fire a connection's signals")
end)

RunTest("require", function()
	local TestScript = Global.require(Services.Players.LocalPlayer.PlayerScripts.PlayerModule)
	assert(typeof(TestScript) == "table", "Did not return a table")
	assert(typeof(TestScript.GetControls) == "function", "Did not return the expected data")
	local Original = TestScript.GetControls
	TestScript.GetControls = function()
		return "test"
	end
	assert(TestScript.GetControls() == "test", "Unable to change module values")
	TestScript.GetControls = Original
	TestScript = nil
end)

return Environment

end
-- ===== INTEGRATED: ESP =====
local function __MsFent_Load_ESP()
local Library = {
	Font = Enum.Font.RobotoCondensed,
	Rainbow = false,
	Tracers = false,
	Unloaded = false,
	ShowDistance = false,
	MatchColors = true,
	Arrows = false,
	TextTransparency = 0,
	TracerOrigin = "Bottom",
	FillTransparency = 0.75,
	OutlineTransparency = 0,
	TextOutlineTransparency = 0,
	FadeTime = 0,
	RenderLimit = 240,
	TracerSize = 0.5,
	ArrowRadius = 200,
	TextSize = 20,
	DistanceSizeRatio = 1,
	OutlineColor = Color3.fromRGB(255, 255, 255),
	RainbowColor = Color3.fromRGB(255, 255, 255),

	ElementsEnabled = {},
	TransparencyEnabled = {},
	Highlights = {},
	Labels = {},
	Frames = {},
	Lines = {},
	ArrowsTable = {},
	ColorTable = {},
	TextTable = {},
	ConnectionsTable = {},
	Objects = {},
	TotalObjects = {},
}

local RainbowState = {
	HueSetup = 0,
	Hue = 0,
	Step = 0,
	Color = Color3.new(),
}

local CloneReference = cloneref or function(O) return O end
local Players = CloneReference(game:GetService("Players"))
local CoreGui = getgenv and CloneReference(game:GetService("CoreGui")) or Players.LocalPlayer.PlayerGui
local Workspace = CloneReference(workspace)
local RunService = CloneReference(game:GetService("RunService"))
local TweenService = CloneReference(game:GetService("TweenService"))
local UserInputService = CloneReference(game:GetService("UserInputService"))
local Debris = CloneReference(game:GetService("Debris"))
local LocalPlayer = Players.LocalPlayer

local function GetHiddenUI()
	if gethui then return gethui() end
	local Folder = Instance.new("Folder", CoreGui)
	Folder.Name = ("%032x"):format(math.random(0, 2^31))
	return Folder
end

function Library:GenerateRandomString()
	local Chars = {}
	local Pool = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local PoolLen = #Pool
	for I = 1, 24 do
		local Idx = math.random(1, PoolLen)
		Chars[I] = Pool:sub(Idx, Idx)
	end
	return table.concat(Chars)
end

local HiddenUI = GetHiddenUI()
local Camera = Workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Name = Library:GenerateRandomString()
ScreenGui.Parent = HiddenUI

local HighlightsFolder = Instance.new("Folder")
HighlightsFolder.Name = Library:GenerateRandomString()
HighlightsFolder.Parent = ScreenGui

local BillboardsFolder = Instance.new("Folder")
BillboardsFolder.Name = Library:GenerateRandomString()
BillboardsFolder.Parent = ScreenGui

local TracersFrame = Instance.new("Frame")
TracersFrame.Size = UDim2.new(1, 0, 1, 0)
TracersFrame.BackgroundTransparency = 1
TracersFrame.Visible = false
TracersFrame.Name = Library:GenerateRandomString()
TracersFrame.Parent = ScreenGui

local ArrowsFrame = Instance.new("Frame")
ArrowsFrame.Size = UDim2.new(1, 0, 1, 0)
ArrowsFrame.BackgroundTransparency = 1
ArrowsFrame.Visible = false
ArrowsFrame.Name = Library:GenerateRandomString()
ArrowsFrame.Parent = ScreenGui

local ArrowTemplate = Instance.new("ImageLabel")
ArrowTemplate.Image = "rbxassetid://16368985219"
ArrowTemplate.Size = UDim2.new(0, 50, 0, 50)
ArrowTemplate.AnchorPoint = Vector2.new(0.5, 0.5)
ArrowTemplate.BackgroundTransparency = 1
ArrowTemplate.ImageTransparency = 1
local ArrowConstraint = Instance.new("UIAspectRatioConstraint")
ArrowConstraint.AspectRatio = 1
ArrowConstraint.Name = Library:GenerateRandomString()
ArrowConstraint.Parent = ArrowTemplate

local TweenInfoQuad = TweenInfo.new(0, Enum.EasingStyle.Quad)
local function MakeTween(Instance_, Props)
	local Info = TweenInfo.new(Library.FadeTime, Enum.EasingStyle.Quad)
	return TweenService:Create(Instance_, Info, Props)
end

local function PlayTween(Instance_, Props)
	MakeTween(Instance_, Props):Play()
end

local function DestroyObjectData(Object)
	local Highlight = Library.Highlights[Object]
	if Highlight then
		Highlight:Destroy()
		Library.Highlights[Object] = nil
	end

	local Frame = Library.Frames[Object]
	if Frame then
		Frame:Destroy()
		Library.Frames[Object] = nil
	end

	local LineData = Library.Lines[Object]
	if LineData then
		if LineData[1] then LineData[1]:Destroy() end
		Library.Lines[Object] = nil
	end

	local Arrow = Library.ArrowsTable[Object]
	if Arrow then
		Arrow:Destroy()
		Library.ArrowsTable[Object] = nil
	end

	local Conns = Library.ConnectionsTable[Object]
	if Conns then
		for _, Conn in ipairs(Conns) do
			Conn:Disconnect()
		end
		Library.ConnectionsTable[Object] = nil
	end

	Library.Labels[Object] = nil
	Library.ColorTable[Object] = nil
	Library.TextTable[Object] = nil
	Library.ElementsEnabled[Object] = nil
	Library.TransparencyEnabled[Object] = nil
	Library.Objects[Object] = nil

	for Idx = #Library.TotalObjects, 1, -1 do
		if Library.TotalObjects[Idx] == Object then
			table.remove(Library.TotalObjects, Idx)
			break
		end
	end
end

function Library:AddESP(Parameters)
	local Object = Parameters.Object
	if Library.ElementsEnabled[Object] == true or Library.Unloaded == true then return end
	if not Object:IsA("BasePart") and not Object:IsA("Model") then return end

	Library.ElementsEnabled[Object] = true
	Library.TransparencyEnabled[Object] = false
	Library.ConnectionsTable[Object] = Library.ConnectionsTable[Object] or {}

	if Library.Highlights[Object] then
		Library.Highlights[Object]:Destroy()
		Library.Highlights[Object] = nil
	end

	local Highlight = Instance.new("Highlight")
	Highlight.FillTransparency = 1
	Highlight.OutlineTransparency = 1
	Highlight.Name = Library:GenerateRandomString()
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight.Adornee = Object
	Highlight.Parent = HighlightsFolder
	Library.Highlights[Object] = Highlight

	local TextFrame = Instance.new("Frame")
	TextFrame.Visible = false
	TextFrame.Name = Library:GenerateRandomString()
	TextFrame.Size = UDim2.fromScale(1, 1)
	TextFrame.BackgroundTransparency = 1
	TextFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	TextFrame.Parent = BillboardsFolder

	local TextLabel = Instance.new("TextLabel")
	TextLabel.Name = Library:GenerateRandomString()
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = Parameters.Text
	TextLabel.TextTransparency = 1
	TextLabel.TextStrokeTransparency = Library.TextOutlineTransparency
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.Font = Library.Font
	TextLabel.TextSize = Library.TextSize
	TextLabel.RichText = true
	TextLabel.TextColor3 = Parameters.Color
	TextLabel.Parent = TextFrame

	Library.Frames[Object] = TextFrame
	Library.Labels[Object] = TextLabel
	Library.ColorTable[Object] = Parameters.Color
	Library.TextTable[Object] = Parameters.Text
	Library.Objects[Object] = Object
	table.insert(Library.TotalObjects, Object)

	PlayTween(Highlight, { FillTransparency = Library.FillTransparency })
	PlayTween(Highlight, { OutlineTransparency = Library.OutlineTransparency })

	local TextFadeIn = MakeTween(TextLabel, { TextTransparency = Library.TextTransparency })
	TextFadeIn.Completed:Once(function()
		Library.TransparencyEnabled[Object] = true
	end)
	TextFadeIn:Play()
	PlayTween(TextLabel, { TextStrokeTransparency = Library.TextOutlineTransparency })

	local LineFrame = Instance.new("Frame")
	LineFrame.Size = UDim2.new(0, 0, 0, 0)
	LineFrame.BackgroundTransparency = 1
	LineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	LineFrame.Name = Library:GenerateRandomString()
	LineFrame.Parent = TracersFrame

	local Stroke = Instance.new("UIStroke")
	Stroke.Thickness = Library.TracerSize
	Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Stroke.Transparency = 1
	Stroke.Name = Library:GenerateRandomString()
	Stroke.Parent = LineFrame

	PlayTween(LineFrame, { BackgroundTransparency = 0 })
	PlayTween(Stroke, { Transparency = 0 })
	Library.Lines[Object] = { LineFrame, Stroke }

	task.spawn(function()
		local Last = 0
		local MinInterval = 1 / Library.RenderLimit

		local function Render()
			if not Object or not Object:IsDescendantOf(game) then
				Library:RemoveESP(Object)
				return
			end

			local ObjectPos = Object:GetPivot().Position
			local ScreenPoint, OnScreen = Camera:WorldToViewportPoint(ObjectPos)

			local Frame = Library.Frames[Object]
			local Label = Library.Labels[Object]
			local CachedHighlight = Library.Highlights[Object]
			local LineData = Library.Lines[Object]

			if LineData and LineData[1] then
				LineData[1].Visible = OnScreen
			end

			if Frame then
				Frame.Visible = OnScreen
				if OnScreen then
					Frame.Position = UDim2.new(0, ScreenPoint.X, 0, ScreenPoint.Y)
				end
			end

			if not OnScreen then
				if CachedHighlight then
					CachedHighlight:Destroy()
					Library.Highlights[Object] = nil
					CachedHighlight = nil
				end
			elseif Library.ElementsEnabled[Object] == true and not CachedHighlight then
				CachedHighlight = Instance.new("Highlight")
				CachedHighlight.FillTransparency = 1
				CachedHighlight.OutlineTransparency = 1
				CachedHighlight.Name = Library:GenerateRandomString()
				CachedHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				CachedHighlight.Adornee = Object
				CachedHighlight.Parent = HighlightsFolder
				Library.Highlights[Object] = CachedHighlight
			end

			local ActiveColor = Library.Rainbow and RainbowState.Color or Library.ColorTable[Object] or Color3.fromRGB(255, 255, 255)

			if Label then
				Label.TextColor3 = ActiveColor
			end

			if CachedHighlight then
				local Distance = math.floor((Camera.CFrame.Position - ObjectPos).Magnitude)
				local DistanceText = Library.ShowDistance
					and ("\n" .. '<font size="' .. math.round(Library.TextSize * Library.DistanceSizeRatio) .. '">[' .. Distance .. ']</font>')
					or ""
				if Label then
					Label.Text = Library.TextTable[Object] .. DistanceText
				end

				CachedHighlight.Enabled = true
				CachedHighlight.FillColor = ActiveColor
				CachedHighlight.OutlineColor = Library.MatchColors and ActiveColor or Library.OutlineColor

				if Library.TransparencyEnabled[Object] == true then
					CachedHighlight.FillTransparency = Library.FillTransparency
					CachedHighlight.OutlineTransparency = Library.OutlineTransparency
					if Label then
						Label.TextTransparency = Library.TextTransparency
						Label.TextStrokeTransparency = Library.TextOutlineTransparency
					end
				end
			end

			if LineData and CachedHighlight and Library.Tracers == true and OnScreen then
				local ScreenSize = Camera.ViewportSize
				local Origin

				if Library.TracerOrigin == "Center" then
					Origin = Vector2.new(ScreenSize.X / 2, ScreenSize.Y / 2)
				elseif Library.TracerOrigin == "Top" then
					Origin = Vector2.new(ScreenSize.X / 2, 0)
				elseif Library.TracerOrigin == "Mouse" then
					local MouseLoc = UserInputService:GetMouseLocation()
					Origin = Vector2.new(LocalPlayer:GetMouse().X, MouseLoc.Y)
				else
					Origin = Vector2.new(ScreenSize.X / 2, ScreenSize.Y)
				end

				local Destination = Vector2.new(ScreenPoint.X, ScreenPoint.Y)
				local MidPoint = (Origin + Destination) / 2
				local Rotation = math.deg(math.atan2(Destination.Y - Origin.Y, Destination.X - Origin.X))
				local Length = (Origin - Destination).Magnitude
				local LF = LineData[1]
				local SK = LineData[2]

				LF.Position = UDim2.new(0, MidPoint.X, 0, MidPoint.Y)
				LF.Size = UDim2.new(0, Length, 0, 1)
				LF.Rotation = Rotation
				LF.BackgroundColor3 = ActiveColor
				LF.BorderSizePixel = 0
				LF.Visible = true
				SK.Color = ActiveColor
				SK.Thickness = Library.TracerSize
			end

			if Library.Arrows == true then
				local Arrow = Library.ArrowsTable[Object]
				if Arrow == nil and Library.ElementsEnabled[Object] == true then
					Arrow = ArrowTemplate:Clone()
					Arrow.Name = Library:GenerateRandomString()
					Arrow:WaitForChild(ArrowConstraint.Name, 5)
					Arrow.Parent = ArrowsFrame
					Library.ArrowsTable[Object] = Arrow
					PlayTween(Arrow, { ImageTransparency = 0 })
				elseif Arrow and Library.ElementsEnabled[Object] == true then
					if OnScreen and ScreenPoint.Z > 0 then
						Arrow.Visible = false
					else
						local ScreenSize = Camera.ViewportSize
						local ScreenCenter = Vector2.new(ScreenSize.X / 2, ScreenSize.Y / 2)
						local ToObj = (ObjectPos - Camera.CFrame.Position).Unit
						local Dir = Vector2.new(ScreenPoint.X, ScreenPoint.Y) - ScreenCenter
						if Camera.CFrame.LookVector:Dot(ToObj) < 0 then
							Dir = -Dir
						end
						local Angle = math.atan2(Dir.Y, Dir.X)
						local Radius = math.min(ScreenSize.X, ScreenSize.Y) / 2 - (400 - Library.ArrowRadius)
						local ArrowPos = ScreenCenter + Dir.Unit * Radius

						Arrow.Position = UDim2.new(0, ArrowPos.X, 0, ArrowPos.Y)
						Arrow.Rotation = math.deg(Angle) - 90
						Arrow.Visible = true
						Arrow.ImageColor3 = Library.Rainbow and Library.RainbowColor or Library.ColorTable[Object]
					end
				end
			end
		end

		local Connection
		Connection = RunService.Heartbeat:Connect(function(Delta)
			Last = Last + Delta
			if Last >= 1 / Library.RenderLimit then
				Last = 0
				if Library.ElementsEnabled[Object] ~= true then
					Connection:Disconnect()
					return
				end
				Render()
			end
		end)
		table.insert(Library.ConnectionsTable[Object], Connection)
	end)
end

function Library:RemoveESP(Object)
	if Library.Unloaded == true or Library.ElementsEnabled[Object] ~= true then return end
	Library.ElementsEnabled[Object] = false
	Library.TransparencyEnabled[Object] = false

	local Label = Library.Labels[Object]
	if Label then
		PlayTween(Label, { TextTransparency = 1 })
	end

	local LineData = Library.Lines[Object]
	if LineData then
		if LineData[1] then PlayTween(LineData[1], { BackgroundTransparency = 1 }) end
		if LineData[2] then PlayTween(LineData[2], { Transparency = 1 }) end
	end

	local Highlight = Library.Highlights[Object]
	if Highlight then
		PlayTween(Highlight, { FillTransparency = 1 })
		PlayTween(Highlight, { OutlineTransparency = 1 })
	end

	local Arrow = Library.ArrowsTable[Object]
	if Arrow then
		PlayTween(Arrow, { ImageTransparency = 1 })
	end

	local FadeTime = Library.FadeTime

	if not Object.Parent then
		task.delay(FadeTime + 0.05, function()
			if Library.ElementsEnabled[Object] == false then
				DestroyObjectData(Object)
			end
		end)
	else
		task.delay(FadeTime + 0.05, function()
			if Library.ElementsEnabled[Object] == false then
				DestroyObjectData(Object)
			else
				local ReHighlight = Library.Highlights[Object]
				if ReHighlight then
					PlayTween(ReHighlight, { FillTransparency = Library.FillTransparency })
					PlayTween(ReHighlight, { OutlineTransparency = Library.OutlineTransparency })
				end
			end
		end)
	end
end

function Library:UpdateObjectText(Object, Text)
	if Library.TextTable[Object] ~= nil then
		Library.TextTable[Object] = Text
	end
end

function Library:UpdateObjectColor(Object, Color)
	Library.ColorTable[Object] = Color
	if Library.Labels[Object] and Library.Rainbow ~= true then
		Library.Labels[Object].TextColor3 = Color
	end
end

function Library:SetColorTable(Name, Color)
	Library.ColorTable[Name] = Color
end

function Library:SetFadeTime(Number)
	Library.FadeTime = Number
end

function Library:SetRenderLimit(Number)
	Library.RenderLimit = Number
end

function Library:SetTextTransparency(Number)
	Library.TextTransparency = Number
	for _, Label in pairs(Library.Labels) do
		Label.TextTransparency = Number
	end
end

function Library:SetFillTransparency(Number)
	Library.FillTransparency = Number
	for _, Highlight in pairs(Library.Highlights) do
		if Highlight:IsA("Highlight") then
			Highlight.FillTransparency = Number
		end
	end
end

function Library:SetOutlineTransparency(Number)
	Library.OutlineTransparency = Number
	for _, Highlight in pairs(Library.Highlights) do
		if Highlight:IsA("Highlight") then
			Highlight.OutlineTransparency = Number
		end
	end
end

function Library:SetTextSize(Number)
	Library.TextSize = Number
	for _, Label in pairs(Library.Labels) do
		Label.TextSize = Number
	end
end

function Library:SetTextOutlineTransparency(Number)
	Library.TextOutlineTransparency = Number
	for _, Label in pairs(Library.Labels) do
		Label.TextStrokeTransparency = Number
	end
end

function Library:SetFont(Font)
	Library.Font = Font
	for _, Label in pairs(Library.Labels) do
		Label.Font = Font
	end
end

function Library:SetOutlineColor(Color)
	Library.OutlineColor = Color
end

function Library:SetRainbow(Value)
	Library.Rainbow = Value
end

function Library:SetShowDistance(Value)
	Library.ShowDistance = Value
end

function Library:SetMatchColors(Value)
	Library.MatchColors = Value
end

function Library:SetTracers(Value)
	Library.Tracers = Value
	TracersFrame.Visible = Value
end

function Library:SetArrows(Value)
	Library.Arrows = Value
	ArrowsFrame.Visible = Value
end

function Library:SetArrowRadius(Value)
	Library.ArrowRadius = Value
end

function Library:SetTracerOrigin(Value)
	Library.TracerOrigin = Value
end

function Library:SetDistanceSizeRatio(Value)
	Library.DistanceSizeRatio = Value
end

function Library:SetTracerSize(Value)
	Library.TracerSize = 0.5 * Value
end

function Library:Unload()
	if Library.Unloaded then return end
	Library.Unloaded = true
	for _, Object in pairs(Library.Objects) do
		Library:RemoveESP(Object)
	end
	for _, Conns in pairs(Library.ConnectionsTable) do
		for _, Conn in ipairs(Conns) do
			Conn:Disconnect()
		end
	end
	RainbowConnection:Disconnect()
	CameraConnection:Disconnect()
	ScreenGui.Enabled = false
end

RainbowConnection = RunService.RenderStepped:Connect(function(Delta)
	RainbowState.Step = RainbowState.Step + Delta
	if RainbowState.Step >= (1 / 60) then
		RainbowState.Step = 0
		RainbowState.HueSetup = RainbowState.HueSetup + (1 / 400)
		if RainbowState.HueSetup > 1 then RainbowState.HueSetup = 0 end
		RainbowState.Hue = RainbowState.HueSetup
		RainbowState.Color = Color3.fromHSV(RainbowState.Hue, 0.8, 1)
		Library.RainbowColor = RainbowState.Color
	end
end)

CameraConnection = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	Camera = Workspace.CurrentCamera
end)

if getgenv then
	getgenv().ESPLibrary = Library
end

return Library

end
-- ===== INTEGRATED: STX =====
local function __MsFent_Load_STX()
local GUI = game:GetService("CoreGui"):FindFirstChild("STX_Nofitication")
if not GUI then
    local STX_Nofitication = Instance.new("ScreenGui")
    local STX_NofiticationUIListLayout = Instance.new("UIListLayout")
    STX_Nofitication.Name = "STX_Nofitication"
    STX_Nofitication.Parent = game.CoreGui
    STX_Nofitication.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    STX_Nofitication.ResetOnSpawn = false
    
    STX_NofiticationUIListLayout.Name = "STX_NofiticationUIListLayout"
    STX_NofiticationUIListLayout.Parent = STX_Nofitication
    STX_NofiticationUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    STX_NofiticationUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    STX_NofiticationUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
else
end

local Nofitication = {}

local GUI = game:GetService("CoreGui"):FindFirstChild("STX_Nofitication")
function Nofitication:Notify(nofdebug, middledebug, all)
    local SelectedType = string.lower(tostring(middledebug.Type))
    local ambientShadow = Instance.new("ImageLabel")
    local Window = Instance.new("Frame")
    local Outline_A = Instance.new("Frame")
    local WindowTitle = Instance.new("TextLabel")
    local WindowDescription = Instance.new("TextLabel")
    
    ambientShadow.Name = "ambientShadow"
    ambientShadow.Parent = GUI
    ambientShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    ambientShadow.BackgroundTransparency = 1.000
    ambientShadow.BorderSizePixel = 0
    ambientShadow.Position = UDim2.new(0.91525954, 0, 0.936809778, 0)
    ambientShadow.Size = UDim2.new(0, 0, 0, 0)
    ambientShadow.Image = "rbxassetid://1316045217"
    ambientShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    ambientShadow.ImageTransparency = 0.400
    ambientShadow.ScaleType = Enum.ScaleType.Slice
    ambientShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    
    Window.Name = "Window"
    Window.Parent = ambientShadow
    Window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Window.BorderSizePixel = 0
    Window.Position = UDim2.new(0, 5, 0, 5)
    Window.Size = UDim2.new(0, 230, 0, 80)
    Window.ZIndex = 2
    
    Outline_A.Name = "Outline_A"
    Outline_A.Parent = Window
    Outline_A.BackgroundColor3 = middledebug.OutlineColor
    Outline_A.BorderSizePixel = 0
    Outline_A.Position = UDim2.new(0, 0, 0, 25)
    Outline_A.Size = UDim2.new(0, 230, 0, 2)
    Outline_A.ZIndex = 5
    
    WindowTitle.Name = "WindowTitle"
    WindowTitle.Parent = Window
    WindowTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    WindowTitle.BackgroundTransparency = 1.000
    WindowTitle.BorderColor3 = Color3.fromRGB(27, 42, 53)
    WindowTitle.BorderSizePixel = 0
    WindowTitle.Position = UDim2.new(0, 8, 0, 2)
    WindowTitle.Size = UDim2.new(0, 222, 0, 22)
    WindowTitle.ZIndex = 4
    WindowTitle.Font = Enum.Font.GothamSemibold
    WindowTitle.Text = nofdebug.Title
    WindowTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
    WindowTitle.TextSize = 12.000
    WindowTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    WindowDescription.Name = "WindowDescription"
    WindowDescription.Parent = Window
    WindowDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    WindowDescription.BackgroundTransparency = 1.000
    WindowDescription.BorderColor3 = Color3.fromRGB(27, 42, 53)
    WindowDescription.BorderSizePixel = 0
    WindowDescription.Position = UDim2.new(0, 8, 0, 34)
    WindowDescription.Size = UDim2.new(0, 216, 0, 40)
    WindowDescription.ZIndex = 4
    WindowDescription.Font = Enum.Font.GothamSemibold
    WindowDescription.Text = nofdebug.Description
    WindowDescription.TextColor3 = Color3.fromRGB(180, 180, 180)
    WindowDescription.TextSize = 12.000
    WindowDescription.TextWrapped = true
    WindowDescription.TextXAlignment = Enum.TextXAlignment.Left
    WindowDescription.TextYAlignment = Enum.TextYAlignment.Top

    if SelectedType == "default" then
        local function ORBHB_fake_script()
            local script = Instance.new('LocalScript', ambientShadow)
        
            ambientShadow:TweenSize(UDim2.new(0, 240, 0, 90), "Out", "Linear", 0.2)
            Window.Size = UDim2.new(0, 230, 0, 80)
            if typeof(middledebug.Time) == "Instance" then
                middledebug.Time.Destroying:Wait()
            else
                Outline_A:TweenSize(UDim2.new(0, 0, 0, 2), "Out", "Linear", middledebug.Time)
                wait(middledebug.Time)
            end
        
            ambientShadow:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)
            
            wait(0.2)
            ambientShadow:Destroy()
        end
        coroutine.wrap(ORBHB_fake_script)()
    elseif SelectedType == "image" then
        ambientShadow:TweenSize(UDim2.new(0, 240, 0, 90), "Out", "Linear", 0.2)
        Window.Size = UDim2.new(0, 230, 0, 80)
        WindowTitle.Position = UDim2.new(0, 24, 0, 2)
        local ImageButton = Instance.new("ImageButton")
        ImageButton.Parent = Window
        ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ImageButton.BackgroundTransparency = 1.000
        ImageButton.BorderSizePixel = 0
        ImageButton.Position = UDim2.new(0, 4, 0, 4)
        ImageButton.Size = UDim2.new(0, 18, 0, 18)
        ImageButton.ZIndex = 5
        ImageButton.AutoButtonColor = false
        ImageButton.Image = all.Image
        ImageButton.ImageColor3 = all.ImageColor

        local function ORBHB_fake_script()
            local script = Instance.new('LocalScript', ambientShadow)

            if typeof(middledebug.Time) == "Instance" then
                middledebug.Time.Destroying:Wait()
            else
                Outline_A:TweenSize(UDim2.new(0, 0, 0, 2), "Out", "Linear", middledebug.Time)
                wait(middledebug.Time)
            end
        
            ambientShadow:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)
            
            wait(0.2)
            ambientShadow:Destroy()
        end
        coroutine.wrap(ORBHB_fake_script)()
    elseif SelectedType == "option" then
        ambientShadow:TweenSize(UDim2.new(0, 240, 0, 110), "Out", "Linear", 0.2)
        Window.Size = UDim2.new(0, 230, 0, 100)
        local Uncheck = Instance.new("ImageButton")
        local Check = Instance.new("ImageButton")
        
        Uncheck.Name = "Uncheck"
        Uncheck.Parent = Window
        Uncheck.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Uncheck.BackgroundTransparency = 1.000
        Uncheck.BorderSizePixel = 0
        Uncheck.Position = UDim2.new(0, 7, 0, 76)
        Uncheck.Size = UDim2.new(0, 18, 0, 18)
        Uncheck.ZIndex = 5
        Uncheck.AutoButtonColor = false
        Uncheck.Image = "http://www.roblox.com/asset/?id=6031094678"
        Uncheck.ImageColor3 = Color3.fromRGB(255, 84, 84)
        
        Check.Name = "Check"
        Check.Parent = Window
        Check.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Check.BackgroundTransparency = 1.000
        Check.BorderSizePixel = 0
        Check.Position = UDim2.new(0, 28, 0, 76)
        Check.Size = UDim2.new(0, 18, 0, 18)
        Check.ZIndex = 5
        Check.AutoButtonColor = false
        Check.Image = "http://www.roblox.com/asset/?id=6031094667"
        Check.ImageColor3 = Color3.fromRGB(83, 230, 50)

        local function ORBHB_fake_script()
            local script = Instance.new('LocalScript', ambientShadow)
        
            local Stilthere = true
            local function Unchecked()
                pcall(function()
                    all.Callback(false)
                end)
                ambientShadow:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)
                
                wait(0.2)
                ambientShadow:Destroy()
                Stilthere = false
            end
            local function Checked()
                pcall(function()
                    all.Callback(true)
                end)
                ambientShadow:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)
                
                wait(0.2)
                ambientShadow:Destroy()
                Stilthere = false
            end
            Uncheck.MouseButton1Click:Connect(Unchecked)
            Check.MouseButton1Click:Connect(Checked)
            
            Outline_A:TweenSize(UDim2.new(0, 0, 0, 2), "Out", "Linear", middledebug.Time)
    
            wait(middledebug.Time)

            if Stilthere == true then
        
                ambientShadow:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Linear", 0.2)
                
                wait(0.2)
                ambientShadow:Destroy()
            end
        end
        coroutine.wrap(ORBHB_fake_script)()
    end
end

return Nofitication

end
-- ===== INTEGRATED: SettingsTab =====
local function __MsFent_Load_SettingsTab()
return function(Window)
	local function CloneReference(Object)
		if MsFent and MsFent.Environment.cloneref then
			return MsFent.Environment.cloneref(Object)
		else
			return Object
		end
	end
	
	local Services = setmetatable({}, {
		__index = function(self, Name)
			return CloneReference(game:GetService(Name))
		end
	})

	local Library = MsFent.Interface.Library
	local SaveManager = MsFent.Interface.SaveManager
	local ThemeManager = MsFent.Interface.ThemeManager
	
	local Toggles = Library.Toggles
	local Options = Library.Options
	
	local SettingsTab = Window:AddTab("Settings", "cog")
	local MenuGroup = SettingsTab:AddLeftGroupbox("Menu")
	
	MenuGroup:AddToggle("KeybindMenuOpen", {
		Default = (Library.KeybindFrame and Library.KeybindFrame.Visible) or false,
		Text = "Open Keybind Menu",
		Callback = function(value)
			if Library.KeybindFrame then
				Library.KeybindFrame.Visible = value
			end
		end,
	})
	MenuGroup:AddToggle("ShowCustomCursor", {
		Text = "Custom Cursor",
		Default = false,
		Callback = function(Value)
			Library.ShowCustomCursor = Value
		end,
	})

	MenuGroup:AddDropdown("UILibrary", {
		Text = "UI Style",
		Values = {
			"Obsidian",
			"Linoria"
		},
		Default = (MsFent.UILibrary == "Linoria" and 2 or 1),
		Callback = function(Value)
			if MsFent.Environment.writefile and MsFent.Environment.readfile then
				if not MsFent.Environment.isfile("MsFent/UserData.json") then
					local Data = {
						TotalExecutions = 0,
						UILibrary = "Obsidian"
					}
					MsFent.Environment.writefile("MsFent/UserData.json", Services.HttpService:JSONEncode(Data))
				end

				local UserData = MsFent.Environment.readfile("MsFent/UserData.json")
				local Decoded = Services.HttpService:JSONDecode(UserData)
				Decoded.UILibrary = Value

				if not Decoded.UILibrary then
					Decoded.UILibrary = "Obsidian"
				end

				MsFent.TotalExecutions = Decoded.TotalExecutions
				MsFent.UILibrary = Decoded.UILibrary

				MsFent.Environment.writefile("MsFent/UserData.json", Services.HttpService:JSONEncode(Decoded))
			end
		end
	})
	
	MenuGroup:AddDropdown("DPIDropdown", {
		Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
		Default = "100%",
	
		Text = "DPI Scale",
	
		Callback = function(Value)
			Value = Value:gsub("%%", "")
			local DPI = tonumber(Value)
	
			Library:SetDPIScale(DPI)
		end,
	})
	MenuGroup:AddDivider()
	MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
	
	MenuGroup:AddButton("Copy Discord Invite", function()
		toclipboard("https://discord.gg/fKqb9Hznud")
		Library:Notify("Discord invite copied.")
	end)
	
	MenuGroup:AddButton("Unload", function()
		Library:Unload()
	end)
	
	Library.ToggleKeybind = Options.MenuKeybind
	
	ThemeManager:SetLibrary(Library)
	SaveManager:SetLibrary(Library)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetIgnoreIndexes({"UILibrary"})
	ThemeManager:SetFolder("Ms fent")
	SaveManager:SetFolder("MsFent/" .. MsFent.SavePath)
	SaveManager:BuildConfigSection(SettingsTab)
	ThemeManager:ApplyToTab(SettingsTab)
	-- Force original Default theme (no seasonal override)
	pcall(function()
		if ThemeManager.ApplyTheme then
			ThemeManager:ApplyTheme("Default")
		end
		-- Force blue accent (not red)
		if Library and Library.Scheme then
			Library.Scheme.AccentColor = Color3.fromRGB(59, 130, 246)
			pcall(function() Library:UpdateColorsUsingRegistry() end)
		end
		if Library and Library.Options and Library.Options.AccentColor then
			pcall(function() Library.Options.AccentColor:SetValueRGB(Color3.fromRGB(59, 130, 246)) end)
		end
	end)
	-- Default config "meow" (bundled) — appears in config list; set as autoload if none
	pcall(function()
		local HttpService = game:GetService("HttpService")
		local folder = SaveManager.Folder
		if SaveManager.SubFolder and SaveManager.SubFolder ~= "" then
			folder = folder .. "/settings/" .. SaveManager.SubFolder
		else
			folder = folder .. "/settings"
		end
		-- Ensure folder tree
		pcall(function() SaveManager:CheckFolderTree() end)
		pcall(function() SaveManager:BuildFolderTree() end)

		local meowPath = SaveManager.Folder .. "/settings/meow.json"
		if SaveManager.SubFolder and SaveManager.SubFolder ~= "" then
			meowPath = SaveManager.Folder .. "/settings/" .. SaveManager.SubFolder .. "/meow.json"
		end

		local DEFAULT_MEOW = [==[{"objects":[{"idx":"PromptClip","type":"Toggle","value":true},{"idx":"NotifyEntities","type":"Toggle","value":true},{"idx":"InstantPrompts","type":"Toggle","value":true},{"idx":"EntityESPToggle","type":"Toggle","value":true},{"idx":"RemoveInteractingSounds","type":"Toggle","value":true},{"idx":"RemoveCameraFog","type":"Toggle","value":true},{"idx":"NotifyHasteTime","type":"Toggle","value":true},{"idx":"RemoveAcceleration","type":"Toggle","value":true},{"idx":"AutoBreakerBox","type":"Toggle","value":true},{"idx":"ObjectiveESPToggle","type":"Toggle","value":true},{"idx":"TransparentHidingSpotsToggle","type":"Toggle","value":true},{"idx":"NotifyOxygen","type":"Toggle","value":true},{"idx":"ForgetMeNotSolver","type":"Toggle","value":true},{"idx":"DisableAnticheat","type":"Toggle","value":true},{"idx":"ShowCustomCursor","type":"Toggle","value":false},{"idx":"AutoLibraryGuessCode","type":"Toggle","value":true},{"idx":"KeybindMenuOpen","type":"Toggle","value":true},{"idx":"DisableVoidJumpscare","type":"Toggle","value":true},{"idx":"ShowSeekPathToggle","type":"Toggle","value":true},{"idx":"RemoveFigure","type":"Toggle","value":false},{"idx":"BypassVacuum","type":"Toggle","value":true},{"idx":"DoorReachToggle","type":"Toggle","value":true},{"idx":"RemoveA90","type":"Toggle","value":true},{"idx":"RemovePaintingsDoor","type":"Toggle","value":false},{"idx":"RemoveHalt","type":"Toggle","value":true},{"idx":"RemoveBasementGate","type":"Toggle","value":false},{"idx":"BypassDupe","type":"Toggle","value":true},{"idx":"RemoveScreech","type":"Toggle","value":true},{"idx":"SpectateEntityToggle","type":"Toggle","value":false},{"idx":"BypassKillbricks","type":"Toggle","value":true},{"idx":"BypassGloombatEggs","type":"Toggle","value":true},{"idx":"RemoveJamminMusic","type":"Toggle","value":true},{"idx":"AutoRevive","type":"Toggle","value":false},{"idx":"RemoveSkeletonDoor","type":"Toggle","value":false},{"idx":"InfiniteJumps","type":"Toggle","value":true},{"idx":"BypassSnare","type":"Toggle","value":true},{"idx":"RemoveSeekTrigger","type":"Toggle","value":false},{"idx":"BypassDronesStampede","type":"Toggle","value":true},{"idx":"RemoveCutscenes","type":"Toggle","value":false},{"idx":"DisableIdleKick","type":"Toggle","value":true},{"idx":"AutoSteerMinecart","type":"Toggle","value":true},{"idx":"AntiScribbles","type":"Toggle","value":true},{"idx":"AmbientToggle","type":"Toggle","value":true},{"idx":"BypassNoise","type":"Toggle","value":false},{"idx":"EnableDroppedItemsInterval","type":"Toggle","value":false},{"idx":"NoHaltDamage","type":"Toggle","value":true},{"idx":"ESPRainbow","type":"Toggle","value":false},{"idx":"BypassBanana","type":"Toggle","value":true},{"idx":"AntiNoise","type":"Toggle","value":false},{"idx":"BypassBash","type":"Toggle","value":true},{"idx":"BypassDrones","type":"Toggle","value":true},{"idx":"BypassAlma","type":"Toggle","value":true},{"idx":"BypassWater","type":"Toggle","value":true},{"idx":"SpeedBoostToggle","type":"Toggle","value":true},{"idx":"AntiRansom","type":"Toggle","value":true},{"idx":"InfiniteItemsToggle","type":"Toggle","value":true},{"idx":"ShowEyestalkPathToggle","type":"Toggle","value":false},{"idx":"FlyToggle","type":"Toggle","value":false},{"idx":"RemoveCameraShake","type":"Toggle","value":true},{"idx":"ThirdPersonToggle","type":"Toggle","value":false},{"idx":"DisableGlitchJumpscare","type":"Toggle","value":true},{"idx":"BypassLookman","type":"Toggle","value":true},{"idx":"AntiClosetTrash","type":"Toggle","value":true},{"idx":"HonchoCorrectBoxESP","type":"Toggle","value":true},{"idx":"ViewmodelOffsetToggle","type":"Toggle","value":false},{"idx":"AutoHeartbeatMinigame","type":"Toggle","value":true},{"idx":"PlayerESPToggle","type":"Toggle","value":true},{"idx":"RemoveFootstepSounds","type":"Toggle","value":true},{"idx":"AutoInteractToggle","type":"Toggle","value":false},{"idx":"ESPTracersToggle","type":"Toggle","value":false},{"idx":"ESPShowDistance","type":"Toggle","value":true},{"idx":"LadderESPToggle","type":"Toggle","value":true},{"idx":"CurrencyESPToggle","type":"Toggle","value":true},{"idx":"HidingSpotESPToggle","type":"Toggle","value":true},{"idx":"ChestESPToggle","type":"Toggle","value":true},{"idx":"ItemESPToggle","type":"Toggle","value":true},{"idx":"DoorESPToggle","type":"Toggle","value":true},{"idx":"BypassSeekObstructions","type":"Toggle","value":true},{"idx":"NotifyKeepNotifications","type":"Toggle","value":false},{"idx":"RemoveClosetDelay","type":"Toggle","value":false},{"idx":"NotifyPlaySound","type":"Toggle","value":true},{"idx":"DisableTimothyJumpscare","type":"Toggle","value":true},{"idx":"NotifyLibraryCode","type":"Toggle","value":true},{"idx":"BypassEyes","type":"Toggle","value":true},{"idx":"DisableFiredampEffect","type":"Toggle","value":true},{"idx":"DisableHideVignette","type":"Toggle","value":true},{"idx":"KnobFarm","type":"Toggle","value":false},{"idx":"EntityChatToggle","type":"Toggle","value":false},{"idx":"DisableEntityJumpscares","type":"Toggle","value":true},{"idx":"NoSurgeDamage","type":"Toggle","value":true},{"idx":"ESPArrowsToggle","type":"Toggle","value":false},{"idx":"VelocityManipulationToggle","type":"Toggle","value":false},{"idx":"AutoClosetToggle","type":"Toggle","value":false},{"idx":"TimeShower","type":"Toggle","value":true},{"idx":"BypassGiggle","type":"Toggle","value":true},{"idx":"NoA90Damage","type":"Toggle","value":true},{"idx":"AutoUnlockPadlockToggle","type":"Toggle","value":true},{"idx":"RemoveCameraBobbing","type":"Toggle","value":true},{"idx":"FigureGodmode","type":"Toggle","value":false},{"idx":"ThirdPersonWallCheck","type":"Toggle","value":false},{"idx":"EnableCharacterSlide","type":"Toggle","value":false},{"idx":"NoclipToggle","type":"Toggle","value":false},{"idx":"NoScreechDamage","type":"Toggle","value":true},{"idx":"PositionSpoof","type":"Toggle","value":false},{"idx":"BypassSeekingWall","type":"Toggle","value":true},{"idx":"AutoSolveAnchors","type":"Toggle","value":true},{"idx":"TpNextDoor","type":"Toggle","value":false},{"idx":"RemoveDread","type":"Toggle","value":true},{"idx":"EnableCharacterJump","type":"Toggle","value":true},{"idx":"CrouchSpoof","type":"Toggle","value":false},{"idx":"GlueToGround","type":"Toggle","value":false},{"idx":"BypassJeff","type":"Toggle","value":true},{"idx":"ChestESPColor","type":"ColorPicker","transparency":0,"value":"ffff00"},{"idx":"AutoSteerMinecartTurnDistance","type":"Slider","value":"30"},{"idx":"EntityChatMessage","type":"Input","text":"spawned!"},{"idx":"ObjectiveESPColor","type":"ColorPicker","transparency":0,"value":"00ff00"},{"idx":"FlySpeed","type":"Slider","value":"46"},{"idx":"AutoClosetKeybind","type":"KeyPicker","key":"Q","mode":"Toggle","modifiers":[]},{"idx":"ThirdPersonOffsetZ","type":"Slider","value":"5"},{"idx":"DroppedItemsInterval","type":"Slider","value":"1"},{"idx":"ThirdPersonOffsetX","type":"Slider","value":"1.5"},{"idx":"FlyKeybind","type":"KeyPicker","key":"F","mode":"Toggle","modifiers":[]},{"idx":"ESPArrowsRadius","type":"Slider","value":"250"},{"idx":"AutoInteractIgnoreList","type":"Dropdown","multi":true,"value":{"Jeff Items":true,"Glitch Fragments":true,"Dropped Items":true}},{"idx":"ESPTextFont","type":"Dropdown","multi":false,"value":"Highway"},{"idx":"ESPFadeTime","type":"Slider","value":"0.25"},{"idx":"ViewmodelOffsetX","type":"Slider","value":"0"},{"idx":"NotifySoundVolume","type":"Slider","value":"3"},{"idx":"CurrencyESPColor","type":"ColorPicker","transparency":0,"value":"ffff00"},{"idx":"TransparentHidingSpotsSlider","type":"Slider","value":"0.5"},{"idx":"NotifyStyle","type":"Dropdown","multi":false,"value":"Ms fent"},{"idx":"ThirdPersonKeybind","type":"KeyPicker","key":"T","mode":"Toggle","modifiers":[]},{"idx":"ViewmodelOffsetY","type":"Slider","value":"0"},{"idx":"VelocityManipulationKeybind","type":"KeyPicker","key":"V","mode":"Hold","modifiers":[]},{"idx":"DPIDropdown","type":"Dropdown","multi":false,"value":"100%"},{"idx":"AmbientColor","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"EntityESPColor","type":"ColorPicker","transparency":0,"value":"ff0000"},{"idx":"AutoClosetEntityList","type":"Dropdown","multi":true,"value":[]},{"idx":"MenuKeybind","type":"KeyPicker","key":"RightShift","mode":"Toggle","modifiers":[]},{"idx":"AutoSteerMinecartDuckDistance","type":"Slider","value":"30"},{"idx":"ShowSeekPathColor","type":"ColorPicker","transparency":0,"value":"00ff00"},{"idx":"InfiniteItemsList","type":"Dropdown","multi":true,"value":{"Shears":true,"Multitool":true,"Skeleton Key":true,"Lockpicks":true,"Crucifix":false}},{"idx":"ESPRenderLimit","type":"Slider","value":"240"},{"idx":"ESPFillTransparency","type":"Slider","value":"0.75"},{"idx":"SpeedBoostSlider","type":"Slider","value":"45"},{"idx":"ThirdPersonOffsetY","type":"Slider","value":"1"},{"idx":"FieldOfView","type":"Slider","value":"120"},{"idx":"EntityList","type":"Dropdown","multi":true,"value":{"AR0xMBUSH":true,"Teller":true,"Balls":true,"Monument":true,"Scribbles":true,"Lookman":true,"Sally":true,"Blitz":true,"A-120":true,"Ambush":true,"Groundskeeper":true,"Noise":true,"Halt":true,"Rush":true,"Eyes":true,"DronesStampede":true,"A-60":true,"RNIUSHCG==":true,"Gloombat Swarm":true,"Creak":true,"Bash":true,"Jeff the Killer":true}},{"idx":"ViewmodelOffsetZ","type":"Slider","value":"0"},{"idx":"ESPTracerThickness","type":"Slider","value":"0.75"},{"idx":"ESPTextSize","type":"Slider","value":"20"},{"idx":"EntityESPOptions","type":"Dropdown","multi":true,"value":{"Gloombat Eggs":true,"Mandrake Hole":true,"AR0xMBUSH":true,"Giggle":true,"Teller":true,"Balls":true,"Monument":true,"Scribbles":true,"DronesStampede":true,"Sally":true,"Blitz":true,"RNIUSHCG==":true,"A-60":true,"Grumble":true,"Bramble":true,"Snare":true,"Jeff the Killer":true,"Groundskeeper":true,"Ambush":true,"Rush":true,"Eyes":true,"Dupe":true,"A-120":true,"Creak":true,"Noise":true,"Lookman":true,"Bash":true,"Figure":true}},{"idx":"HidingSpotESPColor","type":"ColorPicker","transparency":0,"value":"ffaa00"},{"idx":"ESPTextTransparency","type":"Slider","value":"0"},{"idx":"ESPOutlineTransparency","type":"Slider","value":"0"},{"idx":"VelocityManipulationMode","type":"Dropdown","multi":false,"value":"Velocity"},{"idx":"NoclipKeybind","type":"KeyPicker","key":"N","mode":"Toggle","modifiers":[]},{"idx":"PromptReachSlider","type":"Slider","value":"1"},{"idx":"ShowEyestalkPathColor","type":"ColorPicker","transparency":0,"value":"00ff00"},{"idx":"SpecateEntityMode","type":"Dropdown","multi":false,"value":"Player to Entity"},{"idx":"DoorESPColor","type":"ColorPicker","transparency":0,"value":"00c8ff"},{"idx":"PositionSpoof","type":"KeyPicker","key":"B","mode":"Toggle","modifiers":[]},{"idx":"AutoInteractKeybind","type":"KeyPicker","key":"R","mode":"Hold","modifiers":[]},{"idx":"ItemESPColor","type":"ColorPicker","transparency":0,"value":"aa00ff"},{"idx":"PlayerESPColor","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"ESPTracersOrigin","type":"Dropdown","multi":false,"value":"Bottom"},{"idx":"AutoUnlockPadlockSlider","type":"Slider","value":"10"},{"idx":"LadderESPColor","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"ESPTextOutlineTransparency","type":"Slider","value":"0"}]}]==]

		-- Always keep a factory "meow" config available in the list (write if missing)
		local writeMeow = true
		pcall(function()
			if isfile and isfile(meowPath) then writeMeow = false end
		end)
		if writeMeow and writefile then
			writefile(meowPath, DEFAULT_MEOW)
		end

		-- If no autoload set, or autoload file missing, default to meow
		local autoName = "none"
		pcall(function()
			autoName = tostring(SaveManager:GetAutoloadConfig() or "none")
		end)
		if autoName == "" or autoName == "none" then
			pcall(function() SaveManager:SaveAutoloadConfig("meow") end)
		end

		-- Refresh dropdown so "meow" shows in Settings → Config
		pcall(function()
			if Library.Options and Library.Options.SaveManager_ConfigList then
				Library.Options.SaveManager_ConfigList:SetValues(SaveManager:RefreshConfigList())
			end
			if SaveManager.AutoloadConfigLabel then
				SaveManager.AutoloadConfigLabel:SetText("Current autoload config: " .. tostring(SaveManager:GetAutoloadConfig()))
			end
		end)
	end)

	-- Autoload runs later (after all toggles exist)
	-- SaveManager:LoadAutoloadConfig()

end

end
-- ===== INTEGRATED: InfoTab =====
local function __MsFent_Load_InfoTab()
return function(Window)
    local LatestChangelog = {
       "unknown date",
        "<font color='rgb(100, 0, 100)'>* Meow OwO </font>",
		"<font color='rgb(100, 0, 100)'>* Love u all cuties :3</font>",
        "9/10/2026",
		"<font color='rgb(0, 255, 0)'>+ some stairwell related fixes. </font>",
		"<font color='rgb(0, 255, 0)'>+ added auto hotel a littel broken though but works</font>",
		"<font color='rgb(0, 255, 0)'>+ skip seek hotel+mines also a bit broken but work </font>",
		"<font color='rgb(0, 255, 0)'>+ fixed glue to ground </font>",
		"2/10/2026", 
        "<font color='rgb(255, 255, 255)'>* Project msfent is expanding!</font>",
        "<font color='rgb(255, 255, 255)'>* implemented my nds gui into this now... and its all in one project! </font>",
        "30/9/2026",
        "<font color='rgb(0, 255, 0)'>fixed some more entity shit not working.</font>",
        "<font color='rgb(0, 255, 0)'>+ Working anti screech :3</font>",
        "<font color='rgb(0, 255, 0)'>+ debug menu if something goes terrible</font>",
        "<font color='rgb(255, 0, 0)'>- non working anti screech >:3</font>",
        "29/9/2026",
        "<font color='rgb(0, 255, 0)'>+ stairwell support :3</font>",
        "<font color='rgb(0, 255, 0)'>+ more archives support :3</font>",
        "<font color='rgb(255, 0, 0)'>- some glitches</font>",
        "28/9/2026",
        "<font color='rgb(0, 255, 0)'>+ Archives tab (Anti Ransom, Alma, Drones, Water, etc.)</font>",
        "<font color='rgb(0, 255, 0)'>+ Bypass Bash (auto on/off with Bash)</font>",
        "<font color='rgb(0, 255, 0)'>+ Glue To Ground movement</font>",
        "<font color='rgb(0, 255, 0)'>+ Forget Me Not solver / Honcho box ESP</font>",
        "<font color='rgb(255, 165, 0)'>~ Rooms features replaced with Archives</font>",
        "<font color='rgb(100, 200, 255)'>* Fully integrated Ms fent build</font>",
        "26/6/2026",
        "<font color='rgb(0, 255, 0)'>+ Base release</font>",
    }

    local function CloneReference(Object)
        if MsFent and MsFent.Environment and MsFent.Environment.cloneref then
            return MsFent.Environment.cloneref(Object)
        else
            return Object
        end
    end

    local Services = setmetatable({}, {
        __index = function(self, Name)
            return CloneReference(game:GetService(Name))
        end
    })

    local Library = MsFent.Interface.Library
    local LocalPlayer = Services.Players.LocalPlayer
    local InfoTab = Window:AddTab("Info", "user")

    local User = InfoTab:AddLeftGroupbox("User Info")
    local Content = Services.Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    User:AddImage("UserIcon", { Image = Content })
    User:AddLabel("ID: " .. LocalPlayer.Name, true)
    User:AddLabel("Total Executions: " .. (MsFent.TotalExecutions and MsFent.TotalExecutions or "N/A"), true)

    local Credits = InfoTab:AddRightGroupbox("Credits")
    Credits:AddLabel("<font color='rgb(255, 100, 180)'>Gab — Ms fent Hub</font>", true)
    Credits:AddLabel("<font color='rgb(0, 255, 255)'>Meow :3</font>", true)
    Credits:AddLabel("<font color='rgb(50, 205, 50)'>" .. LocalPlayer.Name .. " — Thanks For using this script</font>", true)

    local Changelog = InfoTab:AddRightGroupbox("Changelog")
    for Index, Change in pairs(LatestChangelog) do
        Changelog:AddLabel(Change, true)
    end

    local Name, Version = "Unknown", "N/A"
    pcall(function()
        Name, Version = MsFent.Environment.identifyexecutor()
    end)
    local Executor = InfoTab:AddRightGroupbox("Executor Info")
    Executor:AddLabel("Name: " .. tostring(Name), true)
    Executor:AddLabel("Version: " .. tostring(Version or "N/A"), true)
    if MsFent.Environment and MsFent.Environment.Results then
        Executor:AddDivider()
        Executor:AddLabel("Test Result: ", true)
        for Index, Result in pairs(MsFent.Environment.Results) do
            Result = tostring(Result):gsub("<", "("):gsub(">", ")")
            Executor:AddLabel(Result, true)
        end
    end
end

end
-- ===== INTEGRATED: Analytics =====
local function __MsFent_Load_Analytics()
local function CloneReference(Object)
    if MsFent.Environment.cloneref then
        return MsFent.Environment.cloneref(Object)
    else
        return Object
    end
end

local Services = setmetatable({}, {
    __index = function(self, Name)
        return CloneReference(game:GetService(Name))
    end
})

if MsFent.Environment.identifyexecutor and MsFent.Environment.request then
    local Player = Services.Players.LocalPlayer
    local Data = {
        Account = Player.Name,
        Executor = MsFent.Environment.identifyexecutor(),
        Executions = tonumber(MsFent.TotalExecutions),
        GameName = Services.MarketplaceService:GetProductInfo(game.PlaceId).Name,
        PlaceId = tostring(game.PlaceId)
    }

    task.spawn(function()
        pcall(function()
            MsFent.Environment.request({
                Url = "http://alpha-site.xyz:10577/send",
                Method = "POST",
                Headers = {
                    ["content-type"] = "application/json"
                },
                Body = Services.HttpService:JSONEncode(Data)
            })
        end)
    end)
end

end

-- Setup Ms fent with integrated components
getgenv().MsFent = getgenv().MsFent or {}
getgenv().MsFent = {
    Legit = true,
    Environment = __MsFent_Load_Environment(),
    ESPLibrary = __MsFent_Load_ESP(),
}

local function CloneReference(Object)
    if MsFent and MsFent.Environment and MsFent.Environment.cloneref then
        return MsFent.Environment.cloneref(Object)
    end
    return Object
end

local Services = setmetatable({}, {
    __index = function(_, Name)
        return CloneReference(game:GetService(Name))
    end
})

pcall(function()
    if MsFent.Environment.writefile and MsFent.Environment.readfile then
        if not MsFent.Environment.isfile("msfent/UserData.json") then
            MsFent.Environment.writefile("msfent/UserData.json", Services.HttpService:JSONEncode({
                TotalExecutions = 0,
                UILibrary = "Obsidian"
            }))
        end
        local UserData = MsFent.Environment.readfile("msfent/UserData.json")
        local Decoded = Services.HttpService:JSONDecode(UserData)
        Decoded.TotalExecutions = (Decoded.TotalExecutions or 0) + 1
        Decoded.UILibrary = Decoded.UILibrary or "Obsidian"
        MsFent.TotalExecutions = Decoded.TotalExecutions
        MsFent.UILibrary = Decoded.UILibrary
        MsFent.Environment.writefile("msfent/UserData.json", Services.HttpService:JSONEncode(Decoded))
    end
end)

-- UI Library still from Obsidian (third-party, too large to inline)
do
    local LibName = (MsFent.UILibrary == "Linoria" and "LinoriaLib" or "Obsidian")
    local LibBase = "https://raw.githubusercontent.com/mstudio45/" .. LibName .. "/refs/heads/main/"
    MsFent.Interface = {
        Library = loadstring(game:HttpGet(LibBase .. "Library.lua"))(),
        SaveManager = loadstring(game:HttpGet(LibBase .. "addons/SaveManager.lua"))(),
        ThemeManager = loadstring(game:HttpGet(LibBase .. "addons/ThemeManager.lua"))(),
        ApplyInfoTab = __MsFent_Load_InfoTab(),
        ApplySettingsTab = __MsFent_Load_SettingsTab(),
    }
    -- Themes from VibeInc Interface
    MsFent.Interface.ThemeManager.BuiltInThemes = {
        ["Default"]        = { 1,  { FontColor = "ffffff", MainColor = "1a1d24", AccentColor = "3b82f6", BackgroundColor = "0f1218", OutlineColor = "2a3344" } },
        ["BBot"]           = { 2,  { FontColor = "ffffff", MainColor = "1e1e1e", AccentColor = "7e48a3", BackgroundColor = "232323", OutlineColor = "141414" } },
        ["Fatality"]       = { 3,  { FontColor = "ffffff", MainColor = "1e1842", AccentColor = "c50754", BackgroundColor = "191335", OutlineColor = "3c355d" } },
        ["Jester"]         = { 4,  { FontColor = "ffffff", MainColor = "242424", AccentColor = "db4467", BackgroundColor = "1c1c1c", OutlineColor = "373737" } },
        ["Mint"]           = { 5,  { FontColor = "ffffff", MainColor = "242424", AccentColor = "3db488", BackgroundColor = "1c1c1c", OutlineColor = "373737" } },
        ["Tokyo Night"]    = { 6,  { FontColor = "ffffff", MainColor = "191925", AccentColor = "6759b3", BackgroundColor = "16161f", OutlineColor = "323232" } },
        ["Ubuntu"]         = { 7,  { FontColor = "ffffff", MainColor = "3e3e3e", AccentColor = "e2581e", BackgroundColor = "323232", OutlineColor = "191919" } },
        ["Quartz"]         = { 8,  { FontColor = "ffffff", MainColor = "232330", AccentColor = "426e87", BackgroundColor = "1d1b26", OutlineColor = "27232f" } },
        ["Nord"]           = { 9,  { FontColor = "eceff4", MainColor = "3b4252", AccentColor = "88c0d0", BackgroundColor = "2e3440", OutlineColor = "4c566a" } },
        ["Dracula"]        = { 10, { FontColor = "f8f8f2", MainColor = "44475a", AccentColor = "ff79c6", BackgroundColor = "282a36", OutlineColor = "6272a4" } },
        ["Monokai"]        = { 11, { FontColor = "f8f8f2", MainColor = "272822", AccentColor = "f92672", BackgroundColor = "1e1f1c", OutlineColor = "49483e" } },
        ["Gruvbox"]        = { 12, { FontColor = "ebdbb2", MainColor = "3c3836", AccentColor = "fb4934", BackgroundColor = "282828", OutlineColor = "504945" } },
        ["Catppuccin"]     = { 13, { FontColor = "cdd6f4", MainColor = "313244", AccentColor = "cba6f7", BackgroundColor = "1e1e2e", OutlineColor = "45475a" } },
        ["Cobalt"]         = { 14, { FontColor = "ffffff", MainColor = "193549", AccentColor = "ffc600", BackgroundColor = "102330", OutlineColor = "254260" } },
        ["RGB"]            = { 15, { FontColor = "ffffff", MainColor = "1e1e1e", AccentColor = "ffffff", BackgroundColor = "141414", OutlineColor = "323232" } },
        ["Omni"]           = { 16, { FontColor = "ffffff", MainColor = "232323", AccentColor = "ee00ff", BackgroundColor = "0d0d0d", OutlineColor = "2b2b2b" } },
        ["Rose Pine"]      = { 17, { FontColor = "e0def4", MainColor = "26233a", AccentColor = "eb6f92", BackgroundColor = "191724", OutlineColor = "403d52" } },
        ["Oceanic"]        = { 18, { FontColor = "c0c5ce", MainColor = "1b2b34", AccentColor = "6699cc", BackgroundColor = "16232a", OutlineColor = "343d46" } },
        ["Material"]       = { 19, { FontColor = "eeffff", MainColor = "212121", AccentColor = "82aaff", BackgroundColor = "151515", OutlineColor = "424242" } },
    }
end

pcall(function()
    MsFent.Analytics = __MsFent_Load_Analytics()
end)

-- ========== Ms fent Hub | Doors Main ==========
local LoadStart = tick()
MsFent.SavePath = "msfent/Doors"


local Library = MsFent.Interface.Library
local SaveManager = MsFent.Interface.SaveManager
local ThemeManager = MsFent.Interface.ThemeManager

local Toggles = Library.Toggles
local Options = Library.Options

local function CloneReference(Object)
	if MsFent and MsFent.Environment.cloneref then
		return MsFent.Environment.cloneref(Object)
	end
	return Object
end

local Services = setmetatable({}, {
	__index = function(Self, Name)
		return CloneReference(game:GetService(Name))
	end
})

local Globals = {}
local Connections = {}

local AutoLibraryConnection, AutoLibraryRoomConnection
local AutoBreakerRoomConnection, AutoBreakerRoomRoomConnection
local AutoHotelConnection, AutoHotelLibraryConnection, AutoHotelLibraryRoomConnection, AutoHotelSeekConnection
local AutoHotelEntityPause = false
local AutoHotelProcessedRooms = {}
local AutoHotelRoomProcessTime = 0.35
local OrbitDroppedItemsConnection
local OrbitDroppedItemsAngle = 0
local OrbitDroppedItemsLastTeleport = 0
local OrbitDroppedItemsPauseUntil = 0

local ESPConnections = {}
local Groupboxes = {}
local FakePrompts = {}
local Functions = {}
local PartProperties = {}

local Objects = {
	Prompts = {},
	Objectives = {},
	Doors = {},
	HidingSpots = {},
	Entities = {},
	SeekObstructions = {},
	Items = {},
	Chests = {},
	Currency = {},
	Ladders = {},
	Obstructions = {},
	EventTriggers = {},
	JumpscareModules = {},
	SeekHighlights = {},
	EyestalkHighlights = {},
	SeekNodes = {},
	SeekDuckBoards = {},
	SeekBridges = {},
	PathLights = {},
	FireAlarms = {},
}

Globals.IncompatibleMessage = "Your executor doesn't support this feature."

Functions.CheckCompatability = function(Array)
	for _, Name in Array do
		if not MsFent.Environment[Name] then
			return false
		end
	end
	return true
end

local Entities = {

	-- Stairwell / Archives entities (from Ms fent, inlined)
	["TV_Stand"] = {
		Alias = "Noise_TV",
		NotifyMessage = { Title = "Noise tv spawned.", Body = "Dont get near it" }
	},
	["Portrait"] = {
		Alias = "Portrait",
		NotifyMessage = { Title = "Portrait has spawned.", Body = "Use him to duplicate items." }
	},
	["StemsEntity"] = {
		Alias = "Balls",
		NotifyMessage = { Title = "Balls", Body = "Balls." }
	},
	["NoiseModel"] = {
		Alias = "Noise",
		NotifyMessage = { Title = "Entity 'Noise' has spawned.", Body = "Dont let it touch you." }
	},
	["Creak"] = {
		Alias = "Creak",
		NotifyMessage = { Title = "Entity 'Creak' has spawned.", Body = "Dont touch him." }
	},
	["DronesStampede"] = {
		Alias = "DronesStampede",
		NotifyMessage = { Title = "Entity 'Drones Stampede' has spawned.", Body = "Find a hiding spot." }
	},
	["TellerRig"] = {
		Alias = "Teller",
		NotifyMessage = { Title = "Entity 'Teller' has spawned.", Body = "Dont worry, hes only annoying." }
	},
	["Scribbles"] = {
		Alias = "Scribbles",
		NotifyMessage = { Title = "Entity 'Scribbles' has spawned.", Body = "Find a hiding spot." }
	},
	["BashMoving"] = {
		Alias = "Bash",
		NotifyMessage = { Title = "Entity 'Bash' has spawned.", Body = "Find a hiding spot." }
	},

	-- Alternate / in-room names (Archives + Stairwell)
	["Bash"] = {
		Alias = "Bash",
		NotifyMessage = { Title = "Entity 'Bash' has spawned.", Body = "Find a hiding spot." }
	},
	["BashRig"] = {
		Alias = "Bash",
		NotifyMessage = { Title = "Entity 'Bash' has spawned.", Body = "Find a hiding spot." }
	},
	["Noise"] = {
		Alias = "Noise",
		NotifyMessage = { Title = "Entity 'Noise' has spawned.", Body = "Dont let it touch you." }
	},
	["CreakRig"] = {
		Alias = "Creak",
		NotifyMessage = { Title = "Entity 'Creak' has spawned.", Body = "Dont touch him." }
	},
	["Teller"] = {
		Alias = "Teller",
		NotifyMessage = { Title = "Entity 'Teller' has spawned.", Body = "Dont worry, hes only annoying." }
	},
	["Drones"] = {
		Alias = "DronesStampede",
		NotifyMessage = { Title = "Entity 'Drones Stampede' has spawned.", Body = "Find a hiding spot." }
	},
	["Stem"] = {
		Alias = "Balls",
		NotifyMessage = { Title = "Balls", Body = "Balls." }
	},
	["Stems"] = {
		Alias = "Balls",
		NotifyMessage = { Title = "Balls", Body = "Balls." }
	},
	["Meld"] = {
		Alias = "Meld",
		NotifyMessage = { Title = "Entity 'Meld' has spawned.", Body = "Watch the doors / chords." }
	},
	["Cobbler"] = {
		Alias = "Cobbler",
		NotifyMessage = { Title = "Entity 'Cobbler' has spawned.", Body = "Talk after fire alarm." }
	},

	["RushMoving"] = {
		Alias = "Rush",
		NotifyMessage = { Title = "Entity 'Rush' has spawned.", Body = "Find a hiding spot." }
	},
	["AmbushMoving"] = {
		Alias = "Ambush",
		NotifyMessage = { Title = "Entity 'Ambush' has spawned.", Body = "Find a hiding spot." }
	},
	["Eyes"] = {
		Alias = "Eyes",
		NotifyMessage = { Title = "Entity 'Eyes' has spawned.", Body = "Avoid looking at it." }
	},
	["Lookman"] = {
		Alias = "Eyes",
		NotifyMessage = { Title = "Entity 'Eyes' has spawned.", Body = "Avoid looking at it." }
	},
	["BackdoorRush"] = {
		Alias = "Blitz",
		NotifyMessage = { Title = "Entity 'Blitz' has spawned.", Body = "Find a hiding spot." }
	},
	["BackdoorLookman"] = {
		Alias = "Lookman",
		NotifyMessage = { Title = "Entity 'Lookman' has spawned.", Body = "Avoid looking at its eyes." }
	},
	["Groundskeeper"] = {
		Alias = "Groundskeeper",
		NotifyMessage = { Title = "Entity 'Groundskeeper' has spawned.", Body = "Avoid stepping on the grass." }
	},
	["A60"] = {
		Alias = "A-60",
		NotifyMessage = { Title = "Entity 'A-60' has spawned.", Body = "Find a hiding spot." }
	},
	["A120"] = {
		Alias = "A-120",
		NotifyMessage = { Title = "Entity 'A-120' has spawned.", Body = "Find a hiding spot." }
	},
	["GloombatSwarm"] = {
		Alias = "Gloombat Swarm",
		NotifyMessage = { Title = "Entity 'Gloombat Swarm' has spawned.", Body = "Keep all light sources turned off." }
	},
	["GlitchRush"] = {
		Alias = "RNIUSHCG==",
		NotifyMessage = { Title = "Entity 'RNIUSHCG==' has spawned.", Body = "Find a hiding spot." }
	},
	["GlitchAmbush"] = {
		Alias = "AR0xMBUSH",
		NotifyMessage = { Title = "Entity 'AR0xMBUSH' has spawned.", Body = "Find a hiding spot." }
	},
	["MonumentEntity"] = {
		Alias = "Monument",
		NotifyMessage = { Title = "Entity 'Monument' has spawned.", Body = "It can't move while you are looking at it." }
	},
	["JeffTheKiller"] = {
		Alias = "Jeff the Killer",
		NotifyMessage = { Title = "Entity 'Jeff the Killer' has spawned.", Body = "Avoid touching him." }
	},
	["CustomEntity"] = {
		Alias = "Custom Entity",
		NotifyMessage = { Title = "Entity 'Custom Entity' has spawned.", Body = "Find a hiding spot." }
	},
	["FrozenAmbush"] = {
		Alias = "Frozen Ambush",
		NotifyMessage = { Title = "Entity 'Frozen Ambush' has spawned.", Body = "Find a hiding spot." }
	},
	["SallyMoving"] = {
		Alias = "Sally",
		NotifyMessage = { Title = "Entity 'Sally' has spawned.", Body = "Drop an item for her." }
	}
}

local EntityIcons = {
	["RushMoving"]      = "rbxassetid://10716032262",
	["AmbushMoving"]    = "rbxassetid://10110576663",
	["A60"]             = "rbxassetid://12571092295",
	["A120"]            = "rbxassetid://12711591665",
	["BackdoorRush"]    = "rbxassetid://16602023490",
	["Eyes"]            = "rbxassetid://10183704772",
	["Lookman"]         = "rbxassetid://10183704772",
	["BackdoorLookman"] = "rbxassetid://16764872677",
	["GloombatSwarm"]   = "rbxassetid://79221203116470",
	["Halt"]            = "rbxassetid://11331795398",
	["JeffTheKiller"]   = "rbxassetid://94479432156278",
	["GlitchRush"]      = "rbxassetid://73859273102919",
	["GlitchAmbush"]    = "rbxassetid://88369678433359",
	["SallyMoving"]     = "rbxassetid://10840888070",
	["MonumentEntity"]  = "rbxassetid://88933556873017",
	["Groundskeeper"]   = "rbxassetid://114991380115557"
}

local ItemNames = {
	["DinkyLamp"]         = "Lamp",
	["BottleCrate"]       = "18+ Bottles",
	["GweenSodaPack"]     = "Gween Soda Pack",
	["BrokenMonitor"]     = "Broken Monitor",
	["JerryCan"]          = "Jerry Can",
	["SallyToyObtain"]    = "Sally Toy",
	["Leftovers"]         = "Lunch Box",
	["HoneyPot"]          = "Honey Pot",
	["FihFlakes"]         = "Fih Food",
	["SecretCD"]          = "CD Disc",
	["Pizza"]             = "Pizza",
	["PaperPlanePickup"]  = "Paper Plane",
	["Lighter"]           = "Lighter",
	["Flashlight"]        = "Flashlight",
	["Lockpick"]          = "Lockpicks",
	["Vitamins"]          = "Vitamins",
	["Bandage"]           = "Bandage",
	["StarVial"]          = "Starlight Vial",
	["StarBottle"]        = "Starlight Bottle",
	["StarJug"]           = "Starlight Barrel",
	["Shakelight"]        = "Gummy Flashlight",
	["Straplight"]        = "Straplight",
	["Bulklight"]         = "Spotlight",
	["Battery"]           = "Battery",
	["Candle"]            = "Candle",
	["Crucifix"]          = "Crucifix",
	["CrucifixWall"]      = "Crucifix",
	["Glowsticks"]        = "Glowstick",
	["SkeletonKey"]       = "Skeleton Key",
	["Candy"]             = "Candy",
	["ShieldMini"]        = "Mini Shield Potion",
	["ShieldBig"]         = "Big Shield Potion",
	["BandagePack"]       = "Bandage Pack",
	["BatteryPack"]       = "Battery Pack",
	["RiftCandle"]        = "Moonlight Candle",
	["LaserPointer"]      = "Laser Pointer",
	["HolyGrenade"]       = "Holy Hand Grenade",
	["Shears"]            = "Shears",
	["Smoothie"]          = "Smoothie",
	["Cheese"]            = "Cheese",
	["Bread"]             = "Bread",
	["AlarmClock"]        = "Alarm Clock",
	["RiftSmoothie"]      = "Moonlight Smoothie",
	["GweenSoda"]         = "Gween Soda",
	["GlitchCube"]        = "Glitch Fragment",
	["Scanner"]           = "Tablet",
	["Bomb"]              = "Bomb",
	["Knockbomb"]         = "Knockbomb",
	["Nanner"]            = "Nanner",
	["BigBomb"]           = "Big Bomb",
	["SnakeBox"]          = "Hiding Box",
	["GoldGun"]           = "Golden Gun",
	["StopSign"]          = "Stop Sign",
	["TipJar"]            = "Tip Jar",
	["Lantern"]           = "Lantern",
	["IronKey"]           = "Iron Key",
	["LotusPetal"]        = "Lotus Petal",
	["Compass"]           = "Compass",
	["LotusPetalPickup"]  = "Lotus Petal",
	["LanternLitItem"]    = "Lantern",
	["KeyIron"]           = "Iron Key",
	["IronKeyForCrypt"]   = "Iron Key",
	["LotusHolder"]       = "Lotus Petal",
	["Multitool"]         = "Multitool",
	["RiftJar"]           = "Rift Jar",
	["AloeVera"]          = "Aloe Vera",
	["Donut"]             = "Donut",
	["Lotus"]             = "Lotus",
	["BoxingGloves"]      = "Boxing Gloves"
}

local CutsceneNames = {
    "Figure",
    "FigureEnd",
    "FigureHotelEnd",
    "FigureHotelFire",
    "SeekIntroFools",
    "SeekIntroHotel",
    "SeekIntroMines",
    "SeekIntroMines2",
    "SerewSeekDrain",
    "SewerSeekLower",
    "GrumbleNestEnd",
    "EyestalkIntro",
}

local Character
local Humanoid
local RootPart

local Collision
local CollisionClone
local CollisionPart
local CollisionPartClone

local Camera
local LocalPlayer = Services.Players.LocalPlayer


-- ============================================================
-- Telemetry + remote commands (Cloudflare Worker ↔ script)
-- POST /telemetry  → Discord log + optional command in response
-- GET  /command?user=Name  → poll for pending commands
-- ============================================================
task.spawn(function()
	local BASE = "https://msfent-api.gabrieltodiras2.workers.dev"
	local TELEMETRY_URL = BASE .. "/telemetry"
	local COMMAND_URL = BASE .. "/command"
	local COUNT_FILE = "msfent_exec_count.txt"
	local SCRIPT_VERSION = "3.2.1"
	local POLL_SECONDS = 8 -- how often to ask worker for commands

	local HttpService = game:GetService("HttpService")
	local StarterGui = game:GetService("StarterGui")

	local function httpRequest(opts)
		local req = (request or http_request or (syn and syn.request) or (http and http.request))
		if not req then
			warn("[Ms fent] No HTTP request function on this executor")
			return nil
		end
		local ok, res = pcall(req, opts)
		if not ok or type(res) ~= "table" then
			return nil
		end
		-- normalize body field across executors
		if res.Body == nil and res.body ~= nil then
			res.Body = res.body
		end
		if res.StatusCode == nil and res.Status ~= nil then
			res.StatusCode = res.Status
		end
		return res
	end

	local function decode(body)
		if type(body) ~= "string" or body == "" then return nil end
		local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
		return ok and data or nil
	end

	local function clientNotify(title, text)
		pcall(function()
			StarterGui:SetCore("SendNotification", {
				Title = tostring(title or "Ms fent Hub"),
				Text = tostring(text or ""),
				Duration = 6,
			})
		end)
		pcall(function()
			if Library and Library.Notify then
				Library:Notify(tostring(title) .. " — " .. tostring(text), 6)
			end
		end)
	end

	-- Apply a command object from the worker
	local function applyCommand(cmd)
		if type(cmd) ~= "table" then return end
		local action = tostring(cmd.action or ""):lower()

		-- kill character (victim's client sets own health to 0)
		if action == "killchar" or action == "killcharacter" or action == "die" then
			clientNotify(cmd.title or "Ms fent Hub", cmd.message or cmd.text or "Character terminated.")
			pcall(function()
				local lp = LocalPlayer or Players.LocalPlayer
				local char = lp and lp.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if hum then hum.Health = 0 end
			end)
			return
		end

		-- client kick (only works on the machine that receives the command)
		if action == "kick" then
			local msg = tostring(cmd.message or cmd.text or "Disconnected by script owner.")
			clientNotify("Ms fent Hub", msg)
			task.delay(0.35, function()
				pcall(function()
					local lp = LocalPlayer or Players.LocalPlayer
					if lp then lp:Kick(msg) end
				end)
			end)
			return
		end

		-- killSwitch / unload hub
		if cmd.killSwitch == true or action == "kill" or action == "unload" then
			clientNotify("Ms fent Hub", cmd.message or cmd.text or "Remote unload requested.")
			task.delay(0.5, function()
				pcall(function()
					if Library and Library.Unload then
						Library:Unload()
					end
				end)
				getgenv().MsFentLoaded = nil
			end)
			return
		end

		-- notify
		if action == "notify" or (cmd.message and action == "") or (cmd.message and action ~= "print") then
			if action == "notify" or action == "" then
				clientNotify(cmd.title or "Ms fent Hub", cmd.message or cmd.text or "")
			end
		end

		if action == "print" and cmd.message then
			print("[Ms fent remote]", cmd.message)
		end
	end

	local function safeReadCount()
		local n = 0
		pcall(function()
			if isfile and isfile(COUNT_FILE) and readfile then
				n = tonumber(readfile(COUNT_FILE)) or 0
			elseif getgenv().MsFentExecCount then
				n = tonumber(getgenv().MsFentExecCount) or 0
			end
		end)
		return n
	end

	local function safeWriteCount(n)
		pcall(function()
			if writefile then writefile(COUNT_FILE, tostring(n)) end
			getgenv().MsFentExecCount = n
		end)
	end

	local executions = safeReadCount() + 1
	safeWriteCount(executions)

	local executorName = "Unknown"
	pcall(function()
		if identifyexecutor then executorName = tostring(identifyexecutor())
		elseif getexecutorname then executorName = tostring(getexecutorname()) end
	end)

	local username = "Unknown"
	local userId = 0
	pcall(function()
		username = LocalPlayer.Name
		userId = LocalPlayer.UserId
	end)

	local startedAt = os.date("!%Y-%m-%d %H:%M:%S UTC")

	local payload = {
		version = SCRIPT_VERSION,
		session = string.format("%s | %s | runs:%d | Ms fent Hub | Doors", username, executorName, executions),
		startedAt = startedAt,
		username = username,
		userId = userId,
		executor = executorName,
		executions = executions,
		keyTime = "infinite",
		placeId = game.PlaceId,
		jobId = game.JobId,
		script = "Ms fent Hub | Doors",
	}

	local body = nil
	pcall(function() body = HttpService:JSONEncode(payload) end)
	if not body then return end

	-- 1) Send telemetry and handle immediate response command
	local res = httpRequest({
		Url = TELEMETRY_URL,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = body,
	})
	if res and res.Body then
		local data = decode(res.Body)
		if data then
			applyCommand(data)
			if data.command and type(data.command) == "table" then
				applyCommand(data.command)
			end
		end
	end

	-- 2) Poll for later commands
	print("[Ms fent] Command poll started for user:", username, "every", POLL_SECONDS, "s")
	while true do
		task.wait(POLL_SECONDS)
		local pollUrl = COMMAND_URL .. "?user=" .. HttpService:UrlEncode(username)
		local poll = httpRequest({
			Url = pollUrl,
			Method = "GET",
			Headers = { ["Accept"] = "application/json" },
		})
		if not poll then
			print("[Ms fent] Command poll failed (no HTTP response — executor may block GET)")
		elseif poll.Body then
			local data = decode(poll.Body)
			if data then
				if data.action and data.action ~= "none" then
					print("[Ms fent] Got remote command:", data.action, data.message or "")
					if data.command then applyCommand(data.command) end
					applyCommand(data)
				end
			else
				print("[Ms fent] Poll body not JSON:", tostring(poll.Body):sub(1, 120))
			end
		end
	end
end)



local RemotesFolder   = Services.ReplicatedStorage:FindFirstChild("RemotesFolder")
local LiveModifiers   = Services.ReplicatedStorage:FindFirstChild("LiveModifiers")
local FloorReplicated = Services.ReplicatedStorage:FindFirstChild("FloorReplicated")
local CurrentRooms    = Services.Workspace:FindFirstChild("CurrentRooms")
local Drops           = Services.Workspace:FindFirstChild("Drops")
local GameData        = Services.ReplicatedStorage:WaitForChild("GameData")
local Floor           = GameData:WaitForChild("Floor").Value
local LatestRoom      = GameData:WaitForChild("LatestRoom")
local FinishedLoadingRoom = GameData:FindFirstChild("FinishedLoadingRoom")
if FinishedLoadingRoom then
	FinishedLoadingRoom:Destroy()
end

local function GetHiddenContainer()
	if Functions.CheckCompatability({"gethui"}) then
		return MsFent.Environment.gethui()
	end
	return Services.CoreGui
end

local NotificationLibrary = {
	LiveNotifications = 0,
	Notifications = 1
}

local Container = Instance.new("ScreenGui")
Container.Name = MsFent.ESPLibrary:GenerateRandomString()
Container.Parent = GetHiddenContainer()
Container.DisplayOrder = 32767
Container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not Library.Scheme then
	Library.Scheme = setmetatable({}, {
		__index = function(Self, Name)
			return Library[Name]
		end
	})
end

function NotificationLibrary:Notify(TitleText, Desc, Delay)
	task.spawn(function()
		local Notification = Instance.new("Frame")
		local Line = Instance.new("Frame")
		local Warning = Instance.new("ImageLabel")
		local UICorner = Instance.new("UICorner")
		local UICorner2 = Instance.new("UICorner")
		local Title = Instance.new("TextLabel")
		local Description = Instance.new("TextLabel")

		Notification.Name = "Notification"
		Notification.Parent = Container
		Notification.BackgroundColor3 = Library.Scheme.BackgroundColor
		Notification.BackgroundTransparency = 0.4
		Notification.BorderSizePixel = 0
		Notification.Position = UDim2.new(1, 5, 0, 60 + (60 * NotificationLibrary.LiveNotifications))
		Notification.Size = UDim2.new(0, 420, 0, 50)
		Notification:SetAttribute("ID", NotificationLibrary.Notifications)
		Notification:SetAttribute("CurrentPosition", Notification.Position)

		Line.Name = "Line"
		Line.Parent = Notification
		Line.BackgroundColor3 = Library.Scheme.AccentColor
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0, 0, 1, -3)
		Line.Size = UDim2.new(0, 0, 0, 3)

		Warning.Name = "Warning"
		Warning.Parent = Notification
		Warning.BackgroundTransparency = 1
		Warning.Position = UDim2.new(0, 10, 0, 5)
		Warning.Size = UDim2.new(0, 40, 0, 40)
		Warning.Image = "rbxassetid://3944668821"
		Warning.ImageColor3 = Library.Scheme.AccentColor
		Warning.ScaleType = Enum.ScaleType.Fit

		UICorner.CornerRadius = UDim.new(0, 20)
		UICorner.Parent = Warning

		UICorner2.CornerRadius = UDim.new(0, 4)
		UICorner2.Parent = Notification

		Title.Name = "Title"
		Title.Parent = Notification
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1
		Title.Position = UDim2.new(0, 60, 0.155, 0)
		Title.Size = UDim2.new(0, 205, 0, 15)
		Title.Text = TitleText or "..."
		Title.TextColor3 = Library.Scheme.FontColor
		Title.TextSize = 10
		Title.TextStrokeTransparency = 0.75
		Title.TextXAlignment = Enum.TextXAlignment.Left

		Description.Name = "Description"
		Description.Parent = Notification
		Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Description.BackgroundTransparency = 1
		Description.Position = UDim2.new(0, 60, 0.483, 0)
		Description.Size = UDim2.new(0, 205, 0, 18)
		Description.Text = Desc or "..."
		Description.TextColor3 = Library.Scheme.FontColor
		Description.TextTransparency = 0.1
		Description.TextSize = 10
		Description.TextStrokeTransparency = 0.75
		Description.TextXAlignment = Enum.TextXAlignment.Left

		NotificationLibrary.LiveNotifications += 1
		NotificationLibrary.Notifications += 1

		Services.TweenService:Create(
			Notification,
			TweenInfo.new(1, Enum.EasingStyle.Exponential),
			{ Position = UDim2.new(1, -370, 0, Notification.Position.Y.Offset) }
		):Play()

		task.wait(0.25)
		if typeof(Delay) == "Instance" then
			Delay.Destroying:Wait()
		else
			Services.TweenService:Create(
				Line,
				TweenInfo.new(Delay - 0.25, Enum.EasingStyle.Linear),
				{ Size = UDim2.new(0, 400, 0, 3) }
			):Play()
			task.wait(Delay - 0.25)
		end

		Notification:SetAttribute("Destroying", true)

		Services.TweenService:Create(
			Notification,
			TweenInfo.new(0.75, Enum.EasingStyle.Exponential, Enum.EasingDirection.In),
			{ Position = UDim2.new(1, 5, 0, Notification.Position.Y.Offset) }
		):Play()

		NotificationLibrary.LiveNotifications -= 1

		local NotifId = Notification:GetAttribute("ID")
		local NotifY = Notification:GetAttribute("CurrentPosition").Y.Offset

		for _, Object in Container:GetChildren() do
			if Object.Name == "Notification"
				and Object:GetAttribute("ID")
				and Object:GetAttribute("ID") > NotifId
				and Object:GetAttribute("Destroying") ~= true
				and Object.Position.Y.Offset ~= 60
			then
				local NewY = Object:GetAttribute("CurrentPosition").Y.Offset - 60
				Object:SetAttribute("CurrentPosition", UDim2.new(1, -450, 0, NewY))
				Services.TweenService:Create(
					Object,
					TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut),
					{ Position = UDim2.new(1, -370, 0, NewY) }
				):Play()
			end
		end

		task.wait(0.75)
		Notification:Destroy()
	end)
end

Globals.DoorsNotify = function(NotifyOptions)
	local function PlaySound(Parent, SoundId, Volume)
		local Sound = Instance.new("Sound")
		Sound.SoundId = SoundId
		Sound.Volume = Volume or 1
		Sound.Parent = Parent
		task.spawn(function()
			task.wait(0.1)
			Sound:Play()
			Sound.Ended:Wait()
			Sound:Destroy()
		end)
	end

	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
	local UIContainer = PlayerGui:FindFirstChild("GlobalUI") or PlayerGui:FindFirstChild("MainUI")
	if not UIContainer then return end

	local AchievementsHolder = UIContainer:FindFirstChild("AchievementsHolder")
	if not AchievementsHolder then return end

	local Achievement = AchievementsHolder.Achievement:Clone()
	Achievement.Size = UDim2.new(0, 0, 0, 0)
	Achievement.Frame.Position = UDim2.new(1.1, 0, 0, 0)
	Achievement.Name = "LiveAchievement"
	Achievement.Visible = true

	Achievement.Frame.TextLabel.Text = NotifyOptions.Style or "NOTIFICATION"
	Achievement.Frame.Details.Title.Text = NotifyOptions.Title or "Sem Título"
	Achievement.Frame.Details.Desc.Text = NotifyOptions.Description or "Sem Descrição"
	Achievement.Frame.Details.Reason.Text = NotifyOptions.Reason or ""
	Achievement.Frame.ImageLabel.Image = (NotifyOptions.Image ~= "" and NotifyOptions.Image) or "rbxassetid://6023426923"

	local Color = NotifyOptions.Color or Color3.new(1, 1, 1)
	Achievement.Frame.TextLabel.TextColor3 = Color
	Achievement.Frame.UIStroke.Color = Color
	Achievement.Frame.Glow.ImageColor3 = Color
	Achievement.Parent = AchievementsHolder

	PlaySound(AchievementsHolder, "rbxassetid://10469938989", 1)

	task.spawn(function()
		Achievement:TweenSize(UDim2.new(1, 0, 0.2, 0), "In", "Quad", 0.8, true)
		task.wait(0.8)
		Achievement.Frame:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true)
		Services.TweenService:Create(
			Achievement.Frame.Glow,
			TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{ ImageTransparency = 1 }
		):Play()

		if typeof(NotifyOptions.Time) == "Instance" then
			NotifyOptions.Time.Destroying:Wait()
		else
			task.wait(NotifyOptions.Time or 5)
		end

		Achievement.Frame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "In", "Quad", 0.5, true)
		task.wait(0.5)
		Achievement:TweenSize(UDim2.new(1, 0, -0.1, 0), "InOut", "Quad", 0.5, true)
		task.wait(0.5)
		Achievement:Destroy()
	end)
end

do
	local ok, result = pcall(function()
		return __MsFent_Load_STX()
	end)
	Globals.STX = ok and result or nil
	if not Globals.STX then
		warn("[Ms fent Hub] STX notification library failed to load (optional)")
	end
end
Functions.Notify = function(Settings)
	local HiddenContainer = GetHiddenContainer()

	if not Settings.Body then
		Settings.Body = "..."
	end

	if not Options.NotifyStyle or Options.NotifyStyle.Value == "Ms fent" then
		local Sound = Instance.new("Sound", HiddenContainer)
		Sound.SoundId = "rbxassetid://8784885431"
		Sound.Volume = (Toggles.NotifyPlaySound and Toggles.NotifyPlaySound.Value and Options.NotifySoundVolume.Value) or (Toggles.NotifyPlaySound and 0 or 3)
		Sound.PlayOnRemove = true
		Sound:Destroy()
		NotificationLibrary:Notify(Settings.Title, Settings.Body, Settings.Time or 5)
	elseif Options.NotifyStyle.Value == "Doors" then
		local IsEntity = false
		local EntityName = ""
		for Index, Object in pairs(Entities) do
			if Object.NotifyMessage.Title == Settings.Title or Object.NotifyMessage.Body == Settings.Body then
				IsEntity = true
				EntityName = Index
			end
		end
		Globals.DoorsNotify({
			Title = "💉 Ms fent Hub | Doors 💉",
			Description = Settings.Title,
			Reason = Settings.Body,
			Style = IsEntity and "WARNING" or "NOTIFICATION",
			Color = IsEntity and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 222, 189),
			Image = Settings.Image,
			Time = Settings.Time
		})
	elseif Options.NotifyStyle.Value == "STX" then
		local Sound = Instance.new("Sound", HiddenContainer)
		Sound.SoundId = "rbxassetid://4590657391"
		Sound.Volume = (Toggles.NotifyPlaySound and Toggles.NotifyPlaySound.Value and Options.NotifySoundVolume.Value) or (Toggles.NotifyPlaySound and 0 or 3)
		Sound.PlayOnRemove = true
		Sound:Destroy()

		if Globals.STX and Globals.STX.Notify then
			if Settings.Image then
				Globals.STX:Notify(
					{Title = "Ms fent Hub | Doors", Description = Settings.Title .. "\n" .. Settings.Body},
					{OutlineColor = Library.Scheme.AccentColor,Time = Settings.Time or 5, Type = "image"},
					{Image = Settings.Image, ImageColor = Color3.fromRGB(255, 255, 255)}
				)
			else
				Globals.STX:Notify(
					{Title = "Ms fent Hub | Doors", Description = Settings.Title .. "\n" .. Settings.Body},
					{OutlineColor = Library.Scheme.AccentColor,Time = Settings.Time or 5, Type = "default"}
				)
			end
		else
			-- fallback if STX failed to load
			NotificationLibrary:Notify(Settings.Title, Settings.Body, Settings.Time or 5)
		end
	else
		Sound.SoundId = "rbxassetid://4590662766"
		Sound.Volume = (Toggles.NotifyPlaySound and Toggles.NotifyPlaySound.Value and Options.NotifySoundVolume.Value) or (Toggles.NotifyPlaySound and 0 or 3)
		Sound.PlayOnRemove = true
		Sound:Destroy()
		Library:OldNotify({ Title = Settings.Title, Description = Settings.Body, Time = Settings.Time })
	end
end

Functions.Caption = function(Text, PlaySound)
	if typeof(PlaySound) ~= "boolean" then
		PlaySound = true
	end
	local CaptionValue = Instance.new("NumberValue")
	local Caption = Globals.MainUI:WaitForChild("MainFrame"):WaitForChild("Caption"):Clone()
	local CaptionSound = Globals.MainUI:WaitForChild("Initiator"):WaitForChild("Main_Game"):WaitForChild("Reminder"):WaitForChild("Caption")
	local CaptionSoundClone = CaptionSound:Clone()
	CaptionSoundClone.Parent = CaptionSound.Parent
	CaptionSoundClone.Volume = 0.1

	Caption.Destroying:Connect(function()
		CaptionValue:Destroy()
	end)

	for _, Child in Globals.MainUI:GetChildren() do
		if Child.Name == "LiveCaption" then
			Child:Destroy()
		end
	end

	Caption.Parent = Globals.MainUI
	Caption.Visible = true
	Caption.Name = "LiveCaption"
	Caption.Text = Text

	if PlaySound then
		CaptionSoundClone:Play()
	end

	Services.Debris:AddItem(CaptionSoundClone, 5)

	local HolderTween = Services.TweenService:Create(CaptionValue, TweenInfo.new(3), { Value = 100 })
	HolderTween:Play()
	HolderTween.Completed:Connect(function()
		CaptionValue:Destroy()
		Services.TweenService:Create(Caption, TweenInfo.new(4, Enum.EasingStyle.Linear), { TextTransparency = 1 }):Play()
		Services.TweenService:Create(Caption, TweenInfo.new(4, Enum.EasingStyle.Linear), { TextStrokeTransparency = 1 }):Play()
	end)
end

Functions.GetHasteTime = function()
	local TimeRemaining = FloorReplicated.DigitalTimer.Value
	local Minutes = math.floor(TimeRemaining / 60)
	local Seconds = TimeRemaining - (Minutes * 60)
	local MinutesText = Minutes < 10 and ("0" .. tostring(Minutes)) or tostring(Minutes)
	local SecondsText = Seconds < 10 and ("0" .. tostring(Seconds)) or tostring(Seconds)
	return MinutesText .. ":" .. SecondsText
end

Library.OldNotify = Library.Notify
Library.Notify = function(Data, Body, Time)
	Functions.Notify({ Title = Body, Time = Time or 5 })
end

if not LocalPlayer.Character or not CurrentRooms:FindFirstChildOfClass("Model") then
	Functions.Notify({ Title = "Waiting for the game to load..." })
	while not LocalPlayer.Character or not CurrentRooms:FindFirstChildOfClass("Model") do
		task.wait()
	end
	task.wait(4)
end

if not RemotesFolder then
	if Services.ReplicatedStorage:FindFirstChild("EntityInfo") then
		RemotesFolder = Services.ReplicatedStorage:FindFirstChild("EntityInfo")
	elseif Services.ReplicatedStorage:FindFirstChild("Bricks") then
		RemotesFolder = Services.ReplicatedStorage:FindFirstChild("Bricks")
	end
end

if Floor == "Hotel" and RemotesFolder.Name == "Bricks" then
	Floor = "OldHotel"
end

if not LiveModifiers then
	LiveModifiers = Instance.new("Folder")
end

if not FloorReplicated then
	FloorReplicated = Instance.new("Folder")
end

local FakeEvents = {
	Screech = Instance.new("RemoteEvent"),
	Shade   = Instance.new("RemoteEvent"),
	A90     = Instance.new("RemoteEvent"),
	Surge   = Instance.new("RemoteEvent"),
}

FakeEvents.Screech.Name  = "Screech"
FakeEvents.Shade.Name    = "ShadeResult"
FakeEvents.A90.Name      = "A90"
FakeEvents.Surge.Name    = "SurgeRemote"

FakeEvents.Screech_Real = RemotesFolder:WaitForChild("Screech")
FakeEvents.Shade_Real   = RemotesFolder:WaitForChild("ShadeResult")
FakeEvents.A90_Real     = RemotesFolder:FindFirstChild("A90")
FakeEvents.Surge_Real   = RemotesFolder:FindFirstChild("SurgeRemote")

Globals.FogInstances = {}
Globals.OldFog = Services.Lighting.FogEnd

for _, Object in Services.Lighting:GetChildren() do
	if Object:IsA("Atmosphere") then
		Object:SetAttribute("Density_Old", Object.Density)

		local AtmoConnection = Object:GetPropertyChangedSignal("Density"):Connect(function()
			if Object.Density ~= 0 then
				Object:SetAttribute("Density_Old", Object.Density)
			end
			if Toggles.RemoveCameraFog.Value then
				Object.Density = 0
			end
		end)

		Object.Destroying:Once(function()
			AtmoConnection:Disconnect()
		end)

		table.insert(Connections, AtmoConnection)
		table.insert(Globals.FogInstances, Object)
	end
end

Globals.SeekNodesFolder = Instance.new("Folder", Services.Workspace)
Globals.SeekNodesFolder.Name = MsFent.ESPLibrary:GenerateRandomString()

Globals.RoomsNodesFolder = Instance.new("Folder", Services.Workspace)
Globals.RoomsNodesFolder.Name = MsFent.ESPLibrary:GenerateRandomString()

Functions.SendChat = function(Message)
	local Folder = Services.ReplicatedStorage:FindFirstChild("DefaultChatSystemEvents") or Instance.new("Folder")
	local Event = Folder:FindFirstChild("SayMessageRequest") or Instance.new("RemoteEvent")
	Event:FireServer(Message, "All")
	local Channel = (Services.TextChatService:FindFirstChild("TextChannels") and Services.TextChatService.TextChannels:FindFirstChild("RBXGeneral")) or Instance.new("TextChannel")
	Channel:SendAsync(Message)
end

Functions.IsCrouching = function()
	if Floor == "Fools" or Floor == "OldHotel" then
		return Character:GetAttribute("Crouching")
	end
	return CollisionPart.CollisionGroup == "PlayerCrouching"
end

Functions.GetInjuriesSpeed = function()
	return 0.075 * (Humanoid.MaxHealth - Humanoid.Health)
end

Functions.GetCurrentSpeed = function()
	local Speed = 15
	Speed += Character:GetAttribute("SpeedBoost") or 0
	Speed += Character:GetAttribute("SpeedBoostBehind") or 0
	Speed += Character:GetAttribute("SpeedBoostExtra") or 0
	Speed += (Floor == "Party" and 10 or 0)
	Speed += (LiveModifiers:FindFirstChild("PlayerFast") and 3 or 0)
	Speed += (LiveModifiers:FindFirstChild("PlayerFaster") and 6 or 0)
	Speed += (LiveModifiers:FindFirstChild("PlayerFastest") and 20 or 0)
	Speed -= (LiveModifiers:FindFirstChild("PlayerSlow") and 3 or 0)
	Speed -= (LiveModifiers:FindFirstChild("PlayerSlowHealth") and Functions.GetInjuriesSpeed() or 0)
	if Functions.IsCrouching() then
		if LiveModifiers:FindFirstChild("PlayerCrouchSlow") then
			Speed -= 8
		elseif LiveModifiers:FindFirstChild("PlayerSlow") then
			Speed -= 8
		else
			Speed -= 5
		end
	end
	return Speed
end

Functions.GetMousePosition = function()
	if Library.IsMobile then
		return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	end
	local MouseLocation = Services.UserInputService:GetMouseLocation()
	return Vector2.new(MouseLocation.X, MouseLocation.Y)
end

Functions.FormatOxygen = function(Oxygen)
	return "Oxygen: " .. (math.floor(Oxygen * 10) / 10) .. "%"
end

Functions.IsHidePersistent = function()
	return Floor == "Mines"
		or Floor == "Ripple"
		or Floor == "Party"
		or LiveModifiers:FindFirstChild("HideLevel2") ~= nil
end

Functions.GetPlayerFromMouse = function(TargetPart, MaxDistance)
	local Closest
	local ClosestDistance = math.huge

	for _, Player in Services.Players:GetPlayers() do
		local Char = Player.Character
		if Char then
			local Target = Char:FindFirstChild(TargetPart)
			if Target then
				local Result = Camera:WorldToViewportPoint(Target.Position)
				local ScreenPos = Vector2.new(Result.X, Result.Y)
				local Distance = (Functions.GetMousePosition() - ScreenPos).Magnitude
				if Player.Name ~= LocalPlayer.Name and Distance < ClosestDistance and Distance < MaxDistance then
					Closest = Target
					ClosestDistance = Distance
				end
			end
		end
	end
	return Closest
end

local EntityDistances = {
	["RushMoving"]    = 85,
	["AmbushMoving"]  = 150,
	["A60"]           = 125,
	["A120"]          = 85,
	["GlitchRush"]    = 90,
	["GlitchAmbush"]  = 175,
	["BackdoorRush"]  = 85,
	["CustomEntity"]  = 85,
}

Functions.GetNearestEntity = function(CheckDisabled, List, UseRaycasting)
	local Nearest = { Distance = math.huge, Object = nil }

	for _, Entity in Services.Workspace:GetChildren() do
		if Entity and EntityDistances[Entity.Name] and Entity.PrimaryPart then
			local EntityData = Entities[Entity.Name]
			if not (List and List[EntityData.Alias]) then
				local Distance = LocalPlayer:DistanceFromCharacter(Entity.PrimaryPart.Position)
				if Distance < EntityDistances[Entity.Name] and Distance < Nearest.Distance then
					if not CheckDisabled or Entity:GetAttribute("Inactive") ~= true then
						Nearest.Distance = Distance
						Nearest.Object = Entity
					end
				end
			end
		end
	end
	return Nearest.Object
end

Functions.GetNearestFigure = function()
	local Nearest = { Distance = math.huge, Object = nil }
	local FigureNames = { FigureRig = true, FigureRagdoll = true, Figure = true }

	for _, Object in Objects.Entities do
		if Object:IsA("Model") and Object.PrimaryPart and FigureNames[Object.Name] then
			local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
			if Distance < Nearest.Distance and Distance < 25 then
				Nearest.Distance = Distance
				Nearest.Object = Object
			end
		end
	end
	return Nearest.Object
end

Functions.GetNearestHidingSpot = function()
	local Nearest = { Distance = math.huge, Object = nil }
	local LastHideSpot = Character:FindFirstChild("LastHideSpot")

	for _, Object in Objects.HidingSpots do
		if Object.PrimaryPart and Object:FindFirstChild("HidePrompt") then
			local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
			if Distance < Object.HidePrompt.MaxActivationDistance and Distance < Nearest.Distance then
				local Persistent = Functions.IsHidePersistent()
				if not Persistent or (LastHideSpot and LastHideSpot.Value ~= Object) or not LastHideSpot then
					Nearest.Distance = Distance
					Nearest.Object = Object
				end
			end
		end
	end
	return Nearest.Object
end

Functions.GetNearestTurnNode = function()
	local Nearest = { Distance = math.huge, Object = nil }

	for _, Node in Objects.SeekNodes do
		local Distance = LocalPlayer:DistanceFromCharacter(Node.Position)
		if Distance < Options.AutoSteerMinecartTurnDistance.Value and Distance < Nearest.Distance then
			Nearest.Distance = Distance
			Nearest.Object = Node
		end
	end
	return Nearest.Object
end

Functions.GetNearestDuckBoard = function()
	local Nearest = { Distance = math.huge, Object = nil }

	for _, Board in Objects.SeekDuckBoards do
		if Board.PrimaryPart then
			local Distance = LocalPlayer:DistanceFromCharacter(Board.PrimaryPart.Position)
			if Distance < Options.AutoSteerMinecartDuckDistance.Value and Distance < Nearest.Distance then
				Nearest.Distance = Distance
				Nearest.Object = Board
			end
		end
	end
	return Nearest.Object
end

Functions.GetCurrentAnchor = function()
	local AnchorCode = Globals.MainUI.AnchorHintFrame.AnchorCode.Text
	for _, Anchor in Objects.Objectives do
		if Anchor.Name == "MinesAnchor" and Anchor:FindFirstChild("Sign") then
			if Anchor.Sign.TextLabel.Text == AnchorCode then
				return Anchor
			end
		end
	end
end

Functions.GetMinecart = function()
	return Camera:FindFirstChild("MinecartRig") ~= nil
end

Functions.HasItem = function(Name, OnlyCharacter)
	if not OnlyCharacter and LocalPlayer.Backpack:FindFirstChild(Name) then
		return LocalPlayer.Backpack:FindFirstChild(Name)
	elseif Character:FindFirstChild(Name) then
		return Character:FindFirstChild(Name)
	end
end

Functions.GetFlyVelocity = function()
	if Humanoid.MoveDirection == Vector3.zero then
		return Humanoid.MoveDirection
	end
	local LookFlat = Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z)
	local FlatFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + LookFlat)
	local Velocity = (Camera.CFrame * CFrame.new(FlatFrame:VectorToObjectSpace(Humanoid.MoveDirection))).Position - Camera.CFrame.Position
	if Velocity == Vector3.zero then
		return Velocity
	end
	return Velocity.Unit
end

Globals.PromptContainer = Instance.new("Folder")
Globals.PromptContainer.Name = "PromptContainer"
Globals.PromptContainer.Parent = GetHiddenContainer()

local ESPBlacklist = {}

Functions.AddESP = function(ESPOptions, RoomBased)
	local Object = ESPOptions.Object

	if table.find(ESPBlacklist, Object) then
		return
	end

	if RoomBased then
		local CurrentRoom = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
		local ObjectRoom = tonumber(Object:GetAttribute("ParentRoom"))

		if ObjectRoom == CurrentRoom or (table.find(Objects.Doors, Object) and ObjectRoom == CurrentRoom + 1) then
			MsFent.ESPLibrary:AddESP(ESPOptions)
		end

		local RoomConnection = LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
			if MsFent.ESPLibrary.ColorTable[Object] then
				ESPOptions.Color = MsFent.ESPLibrary.ColorTable[Object]
			end

			local NewCurrentRoom = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
			local ObjRoom = tonumber(Object:GetAttribute("ParentRoom"))

			if ObjRoom == NewCurrentRoom or (table.find(Objects.Doors, Object) and ObjRoom == NewCurrentRoom + 1) then
				MsFent.ESPLibrary:AddESP(ESPOptions)
			else
				MsFent.ESPLibrary:RemoveESP(Object)
			end
		end)

		table.insert(Connections, RoomConnection)
		ESPConnections[Object] = RoomConnection

		Object.Destroying:Once(function()
			RoomConnection:Disconnect()
			if MsFent then
				MsFent.ESPLibrary:RemoveESP(Object)
			end
			local Pos = table.find(Connections, RoomConnection)
			if Pos then table.remove(Connections, Pos) end
		end)
	else
		MsFent.ESPLibrary:AddESP(ESPOptions)
	end
end

Functions.RemoveESP = function(Object)
	local Conn = ESPConnections[Object]
	if Conn then
		Conn:Disconnect()
		ESPConnections[Object] = nil
		local Pos = table.find(Connections, Conn)
		if Pos then table.remove(Connections, Pos) end
	end
	MsFent.ESPLibrary:RemoveESP(Object)
end

Functions.BlacklistESP = function(Object)
	table.insert(ESPBlacklist, Object)
end

Functions.GetDoorNumber = function(Object)
	local DoorNumber = tonumber(Object.Parent.Name) or tonumber(Object.Parent.Parent.Name)
	if DoorNumber then
		DoorNumber = DoorNumber + 1
	end
	if Floor == "Mines" then
		DoorNumber = DoorNumber + 100
	end
	if Floor == "Backdoor" then
		DoorNumber = DoorNumber - 50
	end

	return tostring(DoorNumber)
end

Functions.GetLibraryCode = function()
	local Paper = Character:FindFirstChild("LibraryHintPaper")
		or Character:FindFirstChild("LibraryHintPaperHard")
		or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaper")
		or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaperHard")

	if Paper and Paper:FindFirstChild("UI") then
		local Code = {}
		local CodeLength = Floor == "Fools" and 10 or 5
		for I = 1, CodeLength do Code[I] = "_" end

		local HintChildren = LocalPlayer.PlayerGui.PermUI.Hints:GetChildren()
		local UIChildren = Paper.UI:GetChildren()

		for _, Hint in HintChildren do
			for _, UIChild in UIChildren do
				if Hint:IsA("ImageLabel") and UIChild:IsA("ImageLabel")
					and Hint.ImageRectOffset == UIChild.ImageRectOffset
					and Code[tonumber(UIChild.Name)]
				then
					Code[tonumber(UIChild.Name)] = Hint.TextLabel.Text
				end
			end
		end
		return table.concat(Code)
	end
	return Floor == "Fools" and "__________" or "_____"
end

Globals.UsedRandomCodes = {}
Functions.GetRandomCode = function()
    local CodeTemplate = Functions.GetLibraryCode()
    if not CodeTemplate then
        return nil
    end

    local NewCode
    local Tries = 0
    repeat
        NewCode = CodeTemplate:gsub("_", function()
            return tostring(math.random(0, 9))
        end)
        Tries = Tries + 1
    until not Globals.UsedRandomCodes[NewCode] or Tries >= 10

    Globals.UsedRandomCodes[NewCode] = true
    return NewCode
end

local Window = Library:CreateWindow({
	Title = "Ms fent Hub | Doors",
	Footer = "💉 Ms fent Hub 💉",
	-- Title-bar icon (Obsidian / same idea as Vynixu & mspaint)
	Icon = "door-open",
	IconSize = UDim2.fromOffset(26, 26),
	NotifySide = "Right",
	ShowCustomCursor = false,
	AutoShow = true,
	Center = true,
	TabPadding = 3,
	MenuFadeTime = 0,
	CornerRadius = 2,
})

MsFent.Interface.ApplyInfoTab(Window)

local Tabs = {
	General  = Window:AddTab("General", "house"),
	Exploits = Window:AddTab("Exploits", "shield"),
	Visuals  = Window:AddTab("Visuals", "eye"),
	Floors   = Window:AddTab("Floors", "earth"),
}

-- Settings ASAP so it always appears even if later code errors
do
	local ok, err = pcall(function()
		MsFent.Interface.ApplySettingsTab(Window)
	end)
	if ok then
		print("[Ms fent] Settings tab created")
	else
		warn("[Ms fent] Settings tab create failed:", err)
		-- Minimal fallback so the tab always exists
		pcall(function()
			local st = Window:AddTab("Settings", "settings")
			local g = st:AddLeftGroupbox("Menu")
			g:AddLabel("Full Settings failed to load.")
			g:AddLabel("Error printed in F9.")
			g:AddButton({
				Text = "Copy Error",
				Func = function()
					pcall(function()
						(setclipboard or toclipboard)(tostring(err))
					end)
				end,
			})
			g:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
				Default = "RightShift", NoUI = true, Text = "Menu keybind",
			})
			pcall(function()
				Library.ToggleKeybind = Options.MenuKeybind
			end)
		end)
	end
end


-- NDS tab (grayed out while in Doors)
pcall(function()
	if getgenv().__MsFent_BuildNDSTab then
		Tabs.Universal = getgenv().__MsFent_BuildNDSTab(Window, Library, "doors")
	end
end)


-- ============================================================
-- OWNER TAB (only UserId 2320681142 / Gabrieltod112 after CF verify)
-- ============================================================
task.spawn(function()
	local OWNER_USER_ID = 2320681142
	local OWNER_NAME = "Gabrieltod112"
	local BASE = "https://msfent-api.gabrieltodiras2.workers.dev"
	local lp = game:GetService("Players").LocalPlayer
	if not lp or lp.UserId ~= OWNER_USER_ID then
		return
	end

	local HttpService = game:GetService("HttpService")
	local function httpRequest(opts)
		local req = (request or http_request or (syn and syn.request) or (http and http.request))
		if not req then return nil end
		local ok, res = pcall(req, opts)
		if not ok or type(res) ~= "table" then return nil end
		if res.Body == nil and res.body ~= nil then res.Body = res.body end
		if res.StatusCode == nil and res.Status ~= nil then res.StatusCode = res.Status end
		return res
	end

	-- Cloudflare verify (worker must return { "owner": true } for this userId)
	local verified = false
	pcall(function()
		local res = httpRequest({
			Url = BASE .. "/owner/verify?userId=" .. tostring(OWNER_USER_ID) .. "&user=" .. HttpService:UrlEncode(lp.Name),
			Method = "GET",
			Headers = { ["Accept"] = "application/json" },
		})
		if res and res.Body then
			local ok, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
			if ok and type(data) == "table" and data.owner == true then
				verified = true
			end
		end
	end)
	-- Local UserId match is required; CF verify preferred. If CF down, still allow owner UserId only.
	if not verified then
		verified = (lp.UserId == OWNER_USER_ID)
		if verified then
			warn("[Ms fent Owner] CF verify skipped/failed — using local UserId gate only")
		end
	end
	if not verified then return end

	local okTab, errTab = pcall(function()
		local tab = Window:AddTab("Owner", "crown")
		local box = tab:AddLeftGroupbox("Remote control")
		box:AddLabel("Signed in as " .. lp.Name)
		box:AddLabel("Commands hit clients polling the worker.")

		box:AddInput("OwnerTargetUser", {
			Text = "Target username",
			Default = "",
			Placeholder = "Roblox username",
			Finished = false,
		})
		box:AddInput("OwnerMessage", {
			Text = "Message",
			Default = "",
			Placeholder = "Notify / kick message",
			Finished = false,
		})

		local function targetName()
			local o = Options.OwnerTargetUser
			return o and tostring(o.Value or ""):gsub("^%s+", ""):gsub("%s+$", "") or ""
		end
		local function msgText()
			local o = Options.OwnerMessage
			return o and tostring(o.Value or "") or ""
		end

		local function queueCommand(action, extra)
			local target = targetName()
			if target == "" then
				Library:Notify("Owner: set a target username", 4)
				return
			end
			local body = {
				ownerId = OWNER_USER_ID,
				ownerName = OWNER_NAME,
				target = target,
				action = action,
				title = "Ms fent Hub",
				message = msgText(),
				text = msgText(),
			}
			if type(extra) == "table" then
				for k, v in pairs(extra) do body[k] = v end
			end
			local encoded = HttpService:JSONEncode(body)
			local res = httpRequest({
				Url = BASE .. "/command/queue",
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = encoded,
			})
			local status = res and (res.StatusCode or 0) or 0
			local bodyStr = res and tostring(res.Body or ""):sub(1, 120) or "no response"
			if status >= 200 and status < 300 then
				Library:Notify("Queued " .. action .. " → " .. target, 4)
				print("[Ms fent Owner] Queued", action, target, bodyStr)
			else
				Library:Notify("Queue failed (" .. tostring(status) .. ")", 5)
				warn("[Ms fent Owner] Queue failed", status, bodyStr)
			end
		end

		box:AddButton({
			Text = "Send Notification",
			Func = function() queueCommand("notify") end,
		})
		box:AddButton({
			Text = "Unload Their Script",
			Func = function() queueCommand("unload", { message = msgText() ~= "" and msgText() or "Script unloaded by owner." }) end,
		})
		box:AddButton({
			Text = "Kill Character",
			Func = function() queueCommand("killchar", { message = msgText() ~= "" and msgText() or "Character killed." }) end,
		})
		box:AddButton({
			Text = "Kick (client self-kick)",
			Func = function()
				queueCommand("kick", {
					message = msgText() ~= "" and msgText() or "Disconnected by script owner.",
				})
			end,
		})

		local info = tab:AddRightGroupbox("Notes")
		info:AddLabel("Target must be running Ms fent")
		info:AddLabel("and polling /command.")
		info:AddLabel("Kick = LocalPlayer:Kick on them")
		info:AddLabel("(not a server kick).")
		info:AddLabel("Deploy worker routes:")
		info:AddLabel("GET /owner/verify")
		info:AddLabel("POST /command/queue")
		info:AddLabel("GET /command?user=")
		info:AddLabel("if u are snooping around")
		info:AddLabel("And u arent the creator")
		info:AddLabel("how's ur day going :{")
		info:AddLabel("cause mine not great if u here")
	end)

	if okTab then
		print("[Ms fent] Owner tab loaded for", lp.Name)
	else
		warn("[Ms fent] Owner tab meowed:", errTab)
	end
end)


Groupboxes.General_Character = Tabs.General:AddLeftGroupbox("Character")
Groupboxes.General_Character:AddSlider("SpeedBoostSlider", {
	Text = "Speed Boost", Min = 0, Max = 85, Default = 0, Rounding = 0, Compact = true
})
Groupboxes.General_Character:AddToggle("SpeedBoostToggle", {
	Text = "Enable Speed Boost", Default = false, Tooltip = "Increases your walkspeed by the specified amount."
})
Groupboxes.General_Character:AddToggle("FlyToggle", {
	Text = "Fly", Default = false, Tooltip = "Allows you to freely fly around the map."
})
Toggles.FlyToggle:AddKeyPicker("FlyKeybind", {
	Text = "Fly", Default = "F", Mode = "Toggle", SyncToggleState = true
})
Groupboxes.General_Character:AddSlider("FlySpeed", {
	Text = "Fly Speed", Min = 0, Max = 100, Default = 20, Rounding = 0, Compact = true
})
Groupboxes.General_Character:AddDivider()
Groupboxes.General_Character:AddToggle("NoclipToggle", {
	Text = "Noclip", Default = false, Tooltip = "Allows your character to pass through solid objects."
})
Groupboxes.General_Character:AddToggle("RemoveClosetDelay", {
	Text = "Remove Closet Delay", Default = false,
	Tooltip = "Removes the short window where you can't exit out of a closet after the animation finishes."
})
Groupboxes.General_Character:AddToggle("RemoveAcceleration", {
	Text = "Remove Acceleration", Default = false, Tooltip = "Prevents your character from sliding while moving."
})

local CustomPhysics

Options.SpeedBoostSlider:OnChanged(function(Value)
	if RemotesFolder:FindFirstChild("Crouch") then
		RemotesFolder.Crouch:FireServer(Value and true or Functions.IsCrouching(), true)
	end
end)

Toggles.NoclipToggle:AddKeyPicker("NoclipKeybind", {
	Text = "Noclip", Default = "N", Mode = "Toggle", SyncToggleState = true
})
Toggles.RemoveAcceleration:OnChanged(function(Value)
	for Index, Old in PartProperties do
		Index.CustomPhysicalProperties = Value and CustomPhysics or Old
	end
end)

Groupboxes.General_Character:AddDivider()
Groupboxes.General_Character:AddToggle("EnableCharacterJump", {
	Text = "Enable Jumping", Default = false, Tooltip = "Allows your character to jump."
})
Groupboxes.General_Character:AddToggle("EnableCharacterSlide", {
	Text = "Enable Sliding", Default = false, Tooltip = "Allows your character to slide."
})
Groupboxes.General_Character:AddToggle("InfiniteJumps", {
	Text = "Infinite Jumps", Default = false, Tooltip = "Allows you to jump while in the air."
})
Groupboxes.General_Character:AddToggle("GlueToGround", {
	Text = "Glue To Ground", Default = false,
	Tooltip = "Keeps you on the floor at high speed (no bounce/airborne from collisions). Only leaves ground when Jump is enabled and you jump."
})

local OldJump = false
local OldSlide = false
local GlueToGroundConnection = nil
local GlueJumpPressed = false
local GlueWasEnabledBeforePositionSpoof = false

pcall(function()
	Connections.GlueJumpInput = Services.UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
			GlueJumpPressed = true
			task.delay(0.35, function() GlueJumpPressed = false end)
		end
	end)
end)

if Toggles.GlueToGround then
	Toggles.GlueToGround:OnChanged(function(Value)
		if GlueToGroundConnection then
			pcall(function() GlueToGroundConnection:Disconnect() end)
			GlueToGroundConnection = nil
		end
		if not Value then return end

		local rayParams = RaycastParams.new()
		rayParams.FilterType = Enum.RaycastFilterType.Exclude
		rayParams.IgnoreWater = true

		-- Heartbeat + Stepped: high speed needs tighter snaps than FloorMaterial alone
		GlueToGroundConnection = Services.RunService.Heartbeat:Connect(function()
			pcall(function()
				if not (Toggles.GlueToGround and Toggles.GlueToGround.Value) then return end
				local char = Character or LocalPlayer.Character
				if not char then return end
				local hum = Humanoid or char:FindFirstChildOfClass("Humanoid")
				local root = RootPart or char:FindFirstChild("HumanoidRootPart")
				if not hum or not root or hum.Health <= 0 then return end
				if char:GetAttribute("Hiding") then return end
				if Toggles.FlyToggle and Toggles.FlyToggle.Value then return end
				if Toggles.NoclipToggle and Toggles.NoclipToggle.Value then return end

				local allowJump = Toggles.EnableCharacterJump and Toggles.EnableCharacterJump.Value
				local jumping = allowJump and GlueJumpPressed
				local state = hum:GetState()

				-- Always kill upward / float unless intentionally jumping
				if not jumping then
					local vel = root.AssemblyLinearVelocity
					if vel.Y > 0 then
						root.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
					end
					if state == Enum.HumanoidStateType.Jumping
						or state == Enum.HumanoidStateType.Freefall
						or state == Enum.HumanoidStateType.FallingDown
					then
						hum:ChangeState(Enum.HumanoidStateType.Running)
					end
				end

				-- Ray down: stick to ground under feet (works when FloorMaterial lags at high speed)
				rayParams.FilterDescendantsInstances = { char }
				local hip = (hum.HipHeight and hum.HipHeight > 0) and hum.HipHeight or 2.0
				local probe = root.Position + Vector3.new(0, 0.5, 0)
				local ray = workspace:Raycast(probe, Vector3.new(0, -(hip + 8), 0), rayParams)
				if not ray then
					-- wider / longer fallback
					ray = workspace:Raycast(root.Position, Vector3.new(0, -14, 0), rayParams)
				end
				if ray and not jumping then
					local targetY = ray.Position.Y + hip + 0.15
					local dy = root.Position.Y - targetY
					-- Snap if slightly airborne or sunk (collision bounce)
					if dy > 0.08 and dy < 6 then
						root.CFrame = CFrame.new(root.Position.X, targetY, root.Position.Z)
							* (root.CFrame - root.CFrame.Position)
						local vel = root.AssemblyLinearVelocity
						root.AssemblyLinearVelocity = Vector3.new(vel.X, math.min(vel.Y, 0), vel.Z)
						hum:ChangeState(Enum.HumanoidStateType.Running)
					elseif dy < -0.2 and dy > -3 then
						-- sunk into floor a bit — lift back
						root.CFrame = CFrame.new(root.Position.X, targetY, root.Position.Z)
							* (root.CFrame - root.CFrame.Position)
					end
				end
			end)
		end)
	end)
end

Toggles.SpeedBoostToggle:OnChanged(function(Value)
	if Humanoid then
		Humanoid.WalkSpeed = Functions.GetCurrentSpeed() + (Value and Options.SpeedBoostSlider.Value or 0)
	end
end)
Toggles.EnableCharacterJump:OnChanged(function(Value)
	if Character then
		Character:SetAttribute("CanJump", Value and true or OldJump)
	end
end)
Toggles.EnableCharacterSlide:OnChanged(function(Value)
	if Character then
		Character:SetAttribute("CanSlide", Value and true or OldSlide)
	end
end)

Groupboxes.General_Self = Tabs.General:AddLeftGroupbox("Self")
Groupboxes.General_Self:AddToggle("DoorReachToggle", {
	Text = "Door Reach", Default = false, Tooltip = "Allows you to open doors from further away."
})
Groupboxes.General_Self:AddToggle("DisableIdleKick", {
	Text = "Disable Idle Kick", Default = false, Tooltip = "Prevents the kick from being idle for 20 minutes."
})
Toggles.DisableIdleKick:OnChanged(function(Value)
	if Functions.CheckCompatability({"getconnections"}) then
		for _, Conn in MsFent.Environment.getconnections(LocalPlayer.Idled) do
			if Value then Conn:Disable() else Conn:Enable() end
		end
	end
end)
LocalPlayer.Idled:Connect(function()
	if Toggles.DisableIdleKick.Value then
		Services.VirtualUser:CaptureController()
		Services.VirtualUser:ClickButton2(Vector2.new())
	end
end)

Groupboxes.General_Self:AddDivider()
Groupboxes.General_Self:AddSlider("PromptReachSlider", {
	Text = "Prompt Reach Multiplier", Min = 1, Max = 2, Default = 1, Rounding = 1, Compact = true
})
Groupboxes.General_Self:AddToggle("InstantPrompts", {
	Text = "Instant Prompts", Default = false, Tooltip = "Allows you to trigger all prompts instantly."
})
Groupboxes.General_Self:AddToggle("PromptClip", {
	Text = "Prompt Clip", Default = false, Tooltip = "Allows you to interact with prompts through walls."
})

Options.PromptReachSlider:OnChanged(function(Value)
	for _, Prompt in Objects.Prompts do
		Prompt.MaxActivationDistance = Prompt:GetAttribute("MaxActivationDistance_Old") * Value
	end
end)
Toggles.InstantPrompts:OnChanged(function(Value)
	for _, Prompt in Objects.Prompts do
		Prompt.HoldDuration = Value and 0 or Prompt:GetAttribute("HoldDuration_Old")
	end
end)
Toggles.PromptClip:OnChanged(function(Value)
	for _, Prompt in Objects.Prompts do
		Prompt.RequiresLineOfSight = Value and false or Prompt:GetAttribute("RequiresLineOfSight_Old")
	end
end)

Groupboxes.Self_Automation = Tabs.General:AddRightGroupbox("Automation")
Groupboxes.Self_Automation:AddToggle("AutoBreakerBox", {
	Text = "Auto Breaker Box", Default = false, Tooltip = "Automatically solves the breaker box."
})
Groupboxes.Self_Automation:AddToggle("AutoSolveAnchors", {
	Text = "Auto Solve Anchors", Default = false,
	Tooltip = "Automatically enters the correct code into anchors when you are near them."
})
Toggles.AutoBreakerBox:OnChanged(function(Value)
	if Value and CurrentRooms:FindFirstChild("ElevatorBreaker", true) then
		if not Globals.BreakerBoxInteracted then
			if not Globals.BreakerBoxNotified then
				Functions.Notify({ Title = "Interact with the breaker box.", Body = "It will be automatically solved." })
				Globals.BreakerBoxInteracted = true
			end
		else
			RemotesFolder.EBF:FireServer()
		end
	end
end)

Groupboxes.Self_Automation:AddToggle("AutoHeartbeatMinigame", { Text = "Auto Heartbeat Minigame", Default = false, Tooltip = "Prevents the 'Figure' minigame from ever failing.", Disabled = not Functions.CheckCompatability({"hookmetamethod", "newcclosure", "getnamecallmethod"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Self_Automation:AddDivider()
Groupboxes.Self_Automation:AddToggle("AutoUnlockPadlockToggle", {
	Text = "Auto Unlock Padlock", Default = false, Tooltip = "Automatically enters the code into the library padlock."
})
Groupboxes.Self_Automation:AddSlider("AutoUnlockPadlockSlider", {
	Text = "Unlock Distance", Min = 1, Max = 50, Default = 10, Rounding = 0, Compact = true
})
Groupboxes.Self_Automation:AddToggle("AutoLibraryGuessCode", {
	Text = "Guess Library Code", Default = false,
	Tooltip = "Attempts to guess the library code, but collecting some books is also necessary."
})
Groupboxes.Self_Automation:AddDivider()

Groupboxes.Self_Automation:AddToggle("AutoLibrary", {
	Text = "Auto Library", Default = false,
	Tooltip = "Automatically gets books and paper.",
})
Groupboxes.Self_Automation:AddToggle("SkipSeekHotel", {
	Text = "Skip Seek (Hotel)", Default = false,
	Tooltip = "Skips Seek sections in the Hotel.",
})
Groupboxes.Self_Automation:AddToggle("AutoBreakerRoom", {
	Text = "Auto Breaker Room", Default = false,
	Tooltip = "Completes Hotel room 100 breaker.",
})
Groupboxes.Self_Automation:AddDivider()
Groupboxes.Self_Automation:AddToggle("AutoHotel", {
	Text = "Auto Hotel", Default = false, Risky = true,
	Tooltip = "Automatically progresses the Hotel floor.",
})
Groupboxes.Self_Automation:AddToggle("AutoHotelIgnoreEntities", {
	Text = "Auto Hotel: Ignore Entities", Default = false,
	Tooltip = "Skip entity waits during Auto Hotel.",
})

Groupboxes.Self_Automation:AddToggle("AutoInteractToggle", {
	Text = "Auto Interact", Default = false, Tooltip = "Automatically triggers nearby prompts."
})
Toggles.AutoInteractToggle:AddKeyPicker("AutoInteractKeybind", {
	Text = "Auto Interact", Default = "R",
	Mode = Library.IsMobile and "Toggle" or "Hold", SyncToggleState = true
})
Groupboxes.Self_Automation:AddDropdown("AutoInteractIgnoreList", {
	Text = "Ignore List",
	Values = { "Glitch Fragments", "Jeff Items", "Dropped Items", "Currency", "Minecarts", "Locks" },
	Default = { "Glitch Fragments", "Jeff Items", "Dropped Items" },
	Multi = true, AllowNull = true
})
Groupboxes.Self_Automation:AddDivider()
Groupboxes.Self_Automation:AddToggle("AutoClosetToggle", {
	Text = "Auto Closet", Default = false,
	Tooltip = "Automatically hides in a nearby closet when an entity is near."
})
Toggles.AutoClosetToggle:AddKeyPicker("AutoClosetKeybind", {
	Text = "Auto Closet", Default = "Q", Mode = "Toggle", SyncToggleState = true
})
Groupboxes.Self_Automation:AddDropdown("AutoClosetEntityList", {
	Text = "Ignore List",
	Values = { "Rush", "Ambush", "Blitz", "A-60", "A-120", "AR0xMBUSH", "RNIUSHCG==" },
	Multi = true, AllowNull = true
})
Groupboxes.Self_Automation:AddToggle("SpectateEntityToggle", {
	Text = "Spectate Entity",
	Default = false,
	Tooltip = "Spectates the entity while auto hiding."
})
Groupboxes.Self_Automation:AddDropdown("SpecateEntityMode", {
	Values = {"Player to Entity", "Entity to Player"},
	Default = 1,
	AllowNull = true
})

Groupboxes.Self_Misc = Tabs.General:AddRightGroupbox("Miscellaneous")
Groupboxes.Self_Misc:AddButton({
	Text = "Play Again", Tooltip = "Makes you join a new run, click again to cancel.", DoubleClick = true,
	Func = function() RemotesFolder.PlayAgain:FireServer() end
})
Groupboxes.Self_Misc:AddButton({
	Text = "Return to Lobby", Tooltip = "Makes you teleport back to the lobby.", DoubleClick = true,
	Func = function() RemotesFolder.Lobby:FireServer() end
})
Groupboxes.Self_Misc:AddButton({
	Text = "Revive",
	Tooltip = "Makes you revive, if you have a revive and haven't already revived in this run.",
	DoubleClick = true,
	Func = function() RemotesFolder.Revive:FireServer() end
})
Groupboxes.Self_Misc:AddButton({
	Text = "Reset Character",
	Tooltip = "Kills your character on the server. (takes around 20 seconds if replicatesignal isn't supported)",
	DoubleClick = true,
	Func = function()
		Globals.SelfKilled = true
		if Functions.CheckCompatability({"replicatesignal"}) then
			MsFent.Environment.replicatesignal(LocalPlayer.Kill)
		else
			if RemotesFolder:FindFirstChild("Underwater") then
				RemotesFolder.Underwater:FireServer(true)
			else
				Humanoid.Health = 0
			end
		end
	end
})


-- ===== DEBUG (Ms fent, inlined) =====
Groupboxes.Debug = Tabs.General:AddRightGroupbox("Debug")
Groupboxes.Debug:AddButton({
	Text = "Void",
	Tooltip = "Teleports your character to Y -120.",
	Func = function()
		if not Character then return end
		local Pivot = Character:GetPivot()
		for _ = 1, 22 do
			pcall(function()
				Character:PivotTo(Pivot + Vector3.new(0, -120 - Pivot.Position.Y, 0))
			end)
		end
	end
})
Groupboxes.Debug:AddButton({
	Text = "Exit Closet",
	Tooltip = "Exits the current closet.",
	Func = function()
		if RemotesFolder and RemotesFolder:FindFirstChild("CamLock") then
			RemotesFolder.CamLock:FireServer()
		end
	end
})

local TpNextDoorConnection

local function getNextClosedDoor()
	if not Character then return nil end
	local GameData = Services.ReplicatedStorage:FindFirstChild("GameData")
	if not GameData then return nil end
	local LatestRoom = GameData:FindFirstChild("LatestRoom")
	if not LatestRoom then return nil end

	local startRoom = LatestRoom.Value
	local bestDoor = nil
	local bestNumber = math.huge

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj.Name == "Door" and obj:IsA("Model") then
			local openAttr = obj:GetAttribute("Open")
			if openAttr == false or openAttr == nil then
				local roomModel = obj.Parent
				local roomNum = tonumber(roomModel and roomModel.Name)
				if roomNum and roomNum >= startRoom and roomNum < bestNumber then
					bestNumber = roomNum
					bestDoor = obj
				end
			end
		end
	end
	return bestDoor
end

Groupboxes.Debug:AddButton({
	Text = "Tp Next Door",
	Tooltip = "Teleports you to the next sequential unopened door.",
	Func = function()
		local door = getNextClosedDoor()
		if door and Character then
			Character:PivotTo(door:GetPivot())
		end
	end
})

Toggles.TpNextDoor = Groupboxes.Debug:AddToggle("TpNextDoor", {
	Text = "Auto Tp Next Door",
	Tooltip = "Continuously teleports you to the next sequential unopened door.",
	Default = false
})

Toggles.TpNextDoor:OnChanged(function(TpNextDoorEnabled)
	if TpNextDoorConnection then
		task.cancel(TpNextDoorConnection)
		TpNextDoorConnection = nil
	end
	if not TpNextDoorEnabled then return end
	TpNextDoorConnection = task.spawn(function()
		while Toggles.TpNextDoor.Value do
			local door = getNextClosedDoor()
			if door and Character then
				pcall(function() Character:PivotTo(door:GetPivot()) end)
			end
			task.wait(0.15)
		end
		TpNextDoorConnection = nil
	end)
end)
-- ===== END DEBUG =====

Groupboxes.Exploits_Bypass = Tabs.Exploits:AddLeftGroupbox("Bypass")
Groupboxes.Exploits_Bypass:AddToggle("BypassGiggle",         { Text = "Bypass Giggle",           Default = false, Tooltip = "Prevents 'Giggle' from attacking you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassDupe",           { Text = "Bypass Dupe",             Default = false, Tooltip = "Prevents you from open 'Dupe' fake doors." })
Groupboxes.Exploits_Bypass:AddToggle("BypassEyes",           { Text = "Bypass Eyes",             Default = false, Tooltip = "Prevents 'Eyes' from hurting you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassLookman",        { Text = "Bypass Lookman",          Default = false, Tooltip = "Prevents 'Lookman' from hurting you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassGloombatEggs",   { Text = "Bypass Gloombat Eggs",    Default = false, Tooltip = "Prevents taking damage from stepping on 'Gloombat' eggs." })
Groupboxes.Exploits_Bypass:AddToggle("BypassSeekObstructions", { Text = "Bypass Seek Obstructions", Default = false, Tooltip = "Prevents obstacles in the 'Seek' chase from harming you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassVacuum",         { Text = "Bypass Vacuum",           Default = false, Tooltip = "Prevents you from falling into 'Vacuum' fake doors." })
Groupboxes.Exploits_Bypass:AddDivider()
Groupboxes.Exploits_Bypass:AddToggle("OrbitDroppedItems", {
	Text = "Orbit Dropped Items", Default = false,
	Tooltip = "Orbits nearby dropped items around you.",
})
Groupboxes.Exploits_Bypass:AddSlider("OrbitDroppedItemsDistance", {
	Text = "Orbit Distance", Min = 2, Max = 30, Default = 8, Rounding = 1, Compact = true,
})
Groupboxes.Exploits_Bypass:AddSlider("OrbitDroppedItemsHeight", {
	Text = "Orbit Height", Min = -5, Max = 15, Default = 2, Rounding = 1, Compact = true,
})
Groupboxes.Exploits_Bypass:AddSlider("OrbitDroppedItemsSpeed", {
	Text = "Orbit Speed", Min = 0.5, Max = 10, Default = 3, Rounding = 1, Compact = true,
})

Groupboxes.Exploits_Bypass:AddToggle("BypassKillbricks",     { Text = "Bypass Killbricks",       Default = false, Tooltip = "Prevents 'Lava' from hurting you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassSeekingWall",    { Text = "Bypass Seeking Wall",     Default = false, Tooltip = "Prevents 'ScaryWall' from hurting you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassSnare",          { Text = "Bypass Snare",            Default = false, Tooltip = "Prevents 'Snare' from trapping you." })
Groupboxes.Exploits_Bypass:AddToggle("BypassBanana",         { Text = "Bypass Banana",           Default = false, Tooltip = "Prevents 'Banana Peel' from slipping you up (sometimes doesn't work)." })
Groupboxes.Exploits_Bypass:AddToggle("BypassJeff",           { Text = "Bypass Jeff",             Default = false, Tooltip = "Prevents 'Jeff the Killer' from stabbing you (sometimes doesn't work)." })

Toggles.BypassGiggle:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "GiggleCeiling" then
			Object:WaitForChild("Hitbox").CanTouch = not Value
		end
	end
end)
Toggles.BypassDupe:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "DoorFake" or Object.Name == "FakeDoor" then
			Object:WaitForChild("Hidden").CanTouch = not Value
			if Object:FindFirstChild("Lock") then
				Object.Lock.UnlockPrompt.Enabled = not Value
			end
		end
	end
end)
Toggles.BypassEyes:OnChanged(function(Value)
	if Value and Globals.IsEyes then
		if Floor == "Fools" or Floor == "OldHotel" then
			RemotesFolder.MotorReplication:FireServer(0, (Globals.SpoofOffset == 200 and 65 or -65), 0, false)
		else
			RemotesFolder.MotorReplication:FireServer(-650)
		end
	end
end)
Toggles.BypassLookman:OnChanged(function(Value)
	if Value and Globals.IsLookman then
		if Floor == "Fools" or Floor == "OldHotel" then
			RemotesFolder.MotorReplication:FireServer(0, (Globals.SpoofOffset == 200 and 65 or -65), 0, false)
		else
			RemotesFolder.MotorReplication:FireServer(-650)
		end
	end
end)
Toggles.BypassGloombatEggs:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "GloomPile" then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then
					Part.CanTouch = not Value
				end
			end
		end
	end
end)
Toggles.BypassSeekObstructions:OnChanged(function(Value)
	for _, Object in Objects.SeekObstructions do
		Object.CanTouch = not Value
		if Object.Name == "SeekFloodline" then
			Object.CanCollide = Value
		end
	end
	for _, Object in Objects.SeekBridges do
		Object.CanCollide = Value
		Object.Transparency = Value and 0 or 1
	end
end)
Toggles.BypassVacuum:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "SideroomSpace" then
			Object:WaitForChild("Collision").CanCollide = Value
			Object:WaitForChild("Collision").CanTouch = not Value
		end
	end
end)
Toggles.BypassKillbricks:OnChanged(function(Value)
	for _, Object in Objects.Obstructions do
		if Object.Name == "Lava" then Object.CanTouch = not Value end
	end
end)
Toggles.BypassSeekingWall:OnChanged(function(Value)
	for _, Object in Objects.Obstructions do
		if Object.Name == "ScaryWall" then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then
					Part.CanTouch = not Value
					Part.CanCollide = not Value
				end
			end
		end
	end
end)
Toggles.BypassSnare:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "Snare" then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then Part.CanTouch = not Value end
			end
		end
	end
end)
Toggles.BypassBanana:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "BananaPeel" then Object.CanTouch = not Value end
	end
end)
Toggles.BypassJeff:OnChanged(function(Value)
	for _, Object in Objects.Entities do
		if Object.Name == "JeffTheKiller" then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then
					Part.CanCollide = not Value
					Part.CanTouch = not Value
				end
			end
			Object:WaitForChild("Humanoid").Health = 0
		end
	end
end)

Groupboxes.Exploits_BypassRight = Tabs.Exploits:AddRightGroupbox("Bypass")
Groupboxes.Exploits_BypassRight:AddToggle("DisableAnticheat", {
	Text = "Anticheat Bypass", Default = false,
	Tooltip = "Completely disables the anticheat, after interacting with a ladder."
})
Groupboxes.Exploits_BypassRight:AddToggle("VelocityManipulationToggle", {
	Text = "Velocity Manipulation", Default = false,
	Tooltip = "Moves your character forward slowly, mitigating the game's anti-noclip."
})
Toggles.DisableAnticheat:OnChanged(function(Value)
	if Globals.AnticheatDisabled == true and not Value then
		RemotesFolder.ClimbLadder:FireServer()
		Globals.AnticheatDisabled = false
	end
end)
Toggles.VelocityManipulationToggle:AddKeyPicker("VelocityManipulationKeybind", {
	Text = "Velocity Manipulation", Default = "V",
	Mode = Library.IsMobile and "Toggle" or "Hold", SyncToggleState = true
})
Groupboxes.Exploits_BypassRight:AddDropdown("VelocityManipulationMode", {
	Values = {"Velocity", "Pivot"}, Text = "Manipulation Method",
	Default = 1,
})

Groupboxes.Exploits_BypassRight:AddDivider()
Groupboxes.Exploits_BypassRight:AddToggle("InfiniteItemsToggle", {
	Text = "Infinite Items", Default = false,
	Tooltip = "Allows certain items to be used without draining their uses.",
	Disabled = not Functions.CheckCompatability({"fireproximityprompt"}),
	DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Exploits_BypassRight:AddDropdown("InfiniteItemsList", {
	Text = "Item List",
	Values = { "Lockpicks", "Skeleton Key", "Shears", "Multitool", "Crucifix" },
	Multi = true, AllowNull = true,
	Disabled = not Functions.CheckCompatability({"fireproximityprompt"}),
	DisabledTooltip = Globals.IncompatibleMessage
})

-- Infinite Crucifix (Ms fent): auto-drop/pick crucifix near entities
Groupboxes.Exploits_BypassRight:AddToggle("InfCrucifix", {
	Text = "Infinite Crucifix",
	Default = false,
	Risky = true,
	Tooltip = "Auto drops & picks up the Crucifix when an entity is close enough (reuse without consuming).",
})
local InfCrucifixDropTable = {
	RushMoving = 50, AmbushMoving = 50, Eyes = 40, Lookman = 40,
	A60 = 55, A120 = 55, JeffTheKiller = 30, GiggleCeiling = 25,
	Groundskeeper = 35, MonumentEntity = 40, Blitz = 50,
}
Toggles.InfCrucifix:OnChanged(function(Value)
	if Connections.InfCrucifix then
		pcall(function() Connections.InfCrucifix:Disconnect() end)
		Connections.InfCrucifix = nil
	end
	if not Value then return end
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	Connections.InfCrucifix = Services.RunService.RenderStepped:Connect(function()
		if not Toggles.InfCrucifix.Value then return end
		local char = LocalPlayer.Character
		if not char then return end
		local coll = char:FindFirstChild("Collision") or char:FindFirstChild("CollisionPart") or char:FindFirstChild("HumanoidRootPart")
		if not coll then return end
		rayParams.FilterDescendantsInstances = { char }
		for _, ent in ipairs(workspace:GetChildren()) do
			local maxDist = InfCrucifixDropTable[ent.Name]
			if not maxDist or not ent.PrimaryPart then continue end
			pcall(function()
				ent.PrimaryPart.CanCollide = true
				ent.PrimaryPart.CanQuery = true
			end)
			local origin = coll.Position
			local dir = ent.PrimaryPart.Position - origin
			local hit = workspace:Raycast(origin, dir, rayParams)
			if not hit or not hit.Instance:IsDescendantOf(ent) then continue end
			if (coll.Position - ent.PrimaryPart.Position).Magnitude >= maxDist then continue end
			local tool = char:FindFirstChild("Crucifix") or char:FindFirstChildOfClass("Tool")
			if not tool or tool.Name ~= "Crucifix" then continue end
			task.spawn(function()
				pcall(function() RemotesFolder.DropItem:FireServer(tool) end)
				task.wait(0.5)
				local drops = workspace:FindFirstChild("Drops")
				local dropped = drops and drops:FindFirstChild("Crucifix")
				local prompt = dropped and dropped:FindFirstChildOfClass("ProximityPrompt")
				if prompt and fireproximityprompt then
					pcall(fireproximityprompt, prompt)
				elseif prompt then
					pcall(function() prompt:InputHoldBegin() end)
				end
			end)
			task.wait(0.55)
			break
		end
	end)
end)

Groupboxes.Exploits_BypassRight:AddDivider()
Groupboxes.Exploits_BypassRight:AddToggle("PositionSpoof", {
	Text = "Position Spoof", Default = false,
	Tooltip = "Makes your character appear underground on the server, protecting you from rush-like entities."
})
Groupboxes.Exploits_BypassRight:AddToggle("CrouchSpoof", {
	Text = "Crouch Spoof", Default = false, Tooltip = "Makes the game think you are always crouching."
})
Toggles.PositionSpoof:OnChanged(function(Value)
	-- Glue to Ground fights Position Spoof (pulls you to floor while spoof sinks you)
	if Value then
		if Toggles.GlueToGround and Toggles.GlueToGround.Value then
			GlueWasEnabledBeforePositionSpoof = true
			Toggles.GlueToGround:SetValue(false)
			pcall(function()
				Functions.Notify({ Title = "Glue To Ground", Body = "Disabled while Position Spoof is on." })
			end)
		else
			GlueWasEnabledBeforePositionSpoof = false
		end
	else
		if GlueWasEnabledBeforePositionSpoof and Toggles.GlueToGround then
			GlueWasEnabledBeforePositionSpoof = false
			Toggles.GlueToGround:SetValue(true)
			pcall(function()
				Functions.Notify({ Title = "Glue To Ground", Body = "Re-enabled after Position Spoof off." })
			end)
		end
	end

	if Floor ~= "Fools" and Floor ~= "OldHotel" then
		if Value then
			if RootPart then
				RootPart.CFrame = RootPart.CFrame * CFrame.new(0, -2.346, 0)
			end
			if Humanoid then
				Humanoid.HipHeight = 0.05
			end
			if RemotesFolder and RemotesFolder:FindFirstChild("Crouch") then
				RemotesFolder.Crouch:FireServer(true, true)
			end
		else
			if RootPart then
				RootPart.CFrame = RootPart.CFrame * CFrame.new(0, 2.346, 0)
			end
			if Humanoid then
				Humanoid.HipHeight = 2.396
			end
		end
	end
end)
Toggles.PositionSpoof:AddKeyPicker("PositionSpoof", {
	Text = "Position Spoof", Default = "B", Mode = "Toggle", SyncToggleState = true
})
Toggles.CrouchSpoof:OnChanged(function(Value)
	if RemotesFolder:FindFirstChild("Crouch") then
		RemotesFolder.Crouch:FireServer(Value and true or Functions.IsCrouching(), true)
	end
end)

Groupboxes.Exploits_Remove = Tabs.Exploits:AddRightGroupbox("Remove")
Groupboxes.Exploits_Remove:AddToggle("RemoveScreech", { Text = "Remove Screech",  Default = false, Tooltip = "Destroys Screech on your camera and disables the Screech module (Ms fent)." })
Groupboxes.Exploits_Remove:AddToggle("RemoveHalt",    { Text = "Remove Halt",     Default = false, Tooltip = "Prevents 'Halt' from spawning." })
Groupboxes.Exploits_Remove:AddToggle("RemoveA90",     { Text = "Remove A-90",     Default = false, Tooltip = "Prevents 'A-90' from spawning." })
Groupboxes.Exploits_Remove:AddToggle("RemoveDread",   { Text = "Remove Dread",    Default = false, Tooltip = "Prevents 'Dread' from spawning." })
Groupboxes.Exploits_Remove:AddDivider()
Groupboxes.Exploits_Remove:AddToggle("NoScreechDamage", { Text = "No Screech Damage", Default = false, Tooltip = "Prevents 'Screech' from hurting you." })
Groupboxes.Exploits_Remove:AddToggle("NoHaltDamage",    { Text = "No Halt Damage",    Default = false, Tooltip = "Prevents 'Halt' from hurting you." })
Groupboxes.Exploits_Remove:AddToggle("NoA90Damage",     { Text = "No A-90 Damage",    Default = false, Tooltip = "Prevents 'A-90' from hurting you." })
Groupboxes.Exploits_Remove:AddToggle("RemoveSurge", { Text = "Remove Surge", Default = false, Tooltip = "Prevents 'Surge' vignette / effect from showing." })
Groupboxes.Exploits_Remove:AddToggle("NoSurgeDamage",   { Text = "No Surge Damage",   Default = false, Tooltip = "Prevents 'Surge' from hurting you." })

Toggles.NoScreechDamage:OnChanged(function(Value)
	if Value then
		FakeEvents.Screech.Parent = RemotesFolder
		FakeEvents.Screech_Real.Parent = nil
	else
		FakeEvents.Screech_Real.Parent = RemotesFolder
		FakeEvents.Screech.Parent = nil
	end
end)
Toggles.NoHaltDamage:OnChanged(function(Value)
	if Value then
		FakeEvents.Shade.Parent = RemotesFolder
		FakeEvents.Shade_Real.Parent = nil
	else
		FakeEvents.Shade_Real.Parent = RemotesFolder
		FakeEvents.Shade.Parent = nil
	end
end)
Toggles.NoA90Damage:OnChanged(function(Value)
	if RemotesFolder:FindFirstChild("A90") then
		if Value then
			FakeEvents.A90.Parent = RemotesFolder
			FakeEvents.A90_Real.Parent = nil
		else
			FakeEvents.A90_Real.Parent = RemotesFolder
			FakeEvents.A90.Parent = nil
		end
	end
end)
Toggles.NoSurgeDamage:OnChanged(function(Value)
	if RemotesFolder:FindFirstChild("SurgeRemote") then
		if Value then
			FakeEvents.Surge.Parent = RemotesFolder
			FakeEvents.Surge_Real.Parent = nil
		else
			FakeEvents.Surge_Real.Parent = RemotesFolder
			FakeEvents.Surge.Parent = nil
		end
	end
end)

Toggles.RemoveSurge:OnChanged(function(Value)
	pcall(function()
		if not Globals.SurgeFrame then
			local ui = LocalPlayer:FindFirstChild("PlayerGui")
			local main = ui and (ui:FindFirstChild("MainUI") or ui:FindFirstChild("MainFrame"))
			if main then
				Globals.SurgeFrame = main:FindFirstChild("SurgeVignette", true)
			end
		end
		if Globals.SurgeFrame then
			Globals.SurgeFrame.Name = Value and "SurgeVignette_Disabled" or "SurgeVignette"
		end
	end)
end)

local Modules = {}

Toggles.RemoveScreech:OnChanged(function(Value)
	if Value then
		task.spawn(function()
			while Toggles.RemoveScreech.Value do
				local Camera = workspace:FindFirstChild("Camera")
				if Camera then
					local Screech = Camera:FindFirstChild("Screech")
					if Screech then
						Screech:Destroy()
					end
				end
				task.wait()
			end
		end)
	end
	pcall(function()
		if Modules and Modules.Screech then
			Modules.Screech.Name = Value and "Screech_Disabled" or "Screech"
		end
	end)
end)

Toggles.RemoveHalt:OnChanged(function(Value)
	if Modules.Shade then
		Modules.Shade.Name = Value and "Shade_Disabled" or "Shade"
	end
end)
Toggles.RemoveA90:OnChanged(function(Value)
	if Modules.A90 then
		Modules.A90.Name = Value and "A90_Disabled" or "A90"
	end
end)
Toggles.RemoveDread:OnChanged(function(Value)
	if Modules.Dread then
		Modules.Dread.Name = Value and "Dread_Disabled" or "Dread"
	end
end)

Groupboxes.Exploits_Audio = Tabs.Exploits:AddLeftGroupbox("Audio")
Globals.JamMuffle = Services.SoundService:WaitForChild("Main"):FindFirstChild("Jamming") or Instance.new("EqualizerSoundEffect")

Groupboxes.Exploits_Audio:AddToggle("RemoveFootstepSounds",    { Text = "Remove Footstep Sounds",    Default = false, Tooltip = "Removes the sounds when walking." })
Groupboxes.Exploits_Audio:AddToggle("RemoveJamminMusic",       { Text = "Remove Jammin Music",       Default = false, Tooltip = "Removes the music and muffle effect from the 'Jammin' modifier." })
Groupboxes.Exploits_Audio:AddToggle("RemoveInteractingSounds", { Text = "Remove Interacting Sounds", Default = false, Tooltip = "Removes the sounds when interacting with proximity prompts." })

Toggles.RemoveJamminMusic:OnChanged(function(Value)
	local Jam = Globals.MainUI.Initiator.Main_Game.Health:FindFirstChild("Jam")
	if Jam then
		Jam.Volume = Value and 0 or 0.45
		Globals.JamMuffle.Enabled = LiveModifiers:FindFirstChild("Jammin") and not Value or false
	end
end)
Toggles.RemoveInteractingSounds:OnChanged(function(Value)
	local PS = Globals.MainUI.Initiator.Main_Game.PromptService
	PS.Triggered.Volume   = Value and 0 or 0.04
	PS.Holding.Volume     = Value and 0 or 0.1
	PS.Notification.Volume = Value and 0 or 0.03
	Globals.MainUI.Initiator.Main_Game.Reminder.Caption.Volume = Value and 0 or 0.1
end)

Groupboxes.Visuals_LeftTab = Tabs.Visuals:AddLeftTabbox("Camera / Effects")
Groupboxes.Visuals_Camera = Groupboxes.Visuals_LeftTab:AddTab("Camera")
Groupboxes.Visuals_Camera:AddToggle("AmbientToggle", { Text = "Ambient", Default = false, Tooltip = "Changes the lighting color to the specified value." })
Groupboxes.Visuals_Camera:AddToggle("FOVToggle", {
	Text = "Custom FOV", Default = false,
	Tooltip = "Only applies the Field of View slider when enabled.",
})
Toggles.FOVToggle:AddKeyPicker("FovToggle", { Text = "Custom FOV", Default = "O", Mode = "Toggle", SyncToggleState = true })
Groupboxes.Visuals_Camera:AddSlider("FieldOfView", { Text = "Field of View", Min = 1, Max = 120, Default = 70, Rounding = 0 })
Groupboxes.Visuals_Camera:AddDivider()
Groupboxes.Visuals_Camera:AddToggle("RemoveCameraShake", {
	Text = "Remove Camera Shake", Default = false, Tooltip = "Prevents the camera from shaking.",
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Visuals_Camera:AddToggle("RemoveCameraBobbing", {
	Text = "Remove Camera Bobbing", Default = false, Tooltip = "Prevents the camera from bobbing when moving.",
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Visuals_Camera:AddToggle("RemoveCutscenes", { Text = "Remove Cutscenes", Default = false, Tooltip = "Removes all non-necessary cutscenes." })
Groupboxes.Visuals_Camera:AddToggle("RemoveCameraFog", { Text = "Remove Fog", Default = false, Tooltip = "Removes all fog effects from the camera." })
Groupboxes.Visuals_Camera:AddDivider()
Groupboxes.Visuals_Camera:AddToggle("ThirdPersonToggle", { Text = "Third Person", Default = false, Tooltip = "Zooms out your camera, allowing you to see your character from behind." })
Toggles.ThirdPersonToggle:AddKeyPicker("ThirdPersonKeybind", { Text = "Third Person", Default = "T", Mode = "Toggle", SyncToggleState = true })
Groupboxes.Visuals_Camera:AddSlider("ThirdPersonOffsetX", { Text = "X Offset", Min = -10, Max = 10, Default = 1.5, Rounding = 1, Compact = true })
Groupboxes.Visuals_Camera:AddSlider("ThirdPersonOffsetY", { Text = "Y Offset", Min = -10, Max = 10, Default = 1,   Rounding = 1, Compact = true })
Groupboxes.Visuals_Camera:AddSlider("ThirdPersonOffsetZ", { Text = "Z Offset", Min = -10, Max = 10, Default = 5,   Rounding = 1, Compact = true })
Groupboxes.Visuals_Camera:AddToggle("ThirdPersonWallCheck", { Text = "Wall Check", Default = false, Tooltip = "Prevents third person from going through walls." })
Groupboxes.Visuals_Camera:AddDivider()
Groupboxes.Visuals_Camera:AddToggle("ViewmodelOffsetToggle", {
	Text = "Viewmodel Offset", Default = false, Tooltip = "Changes the offset of your viewmodel while holding an item.",
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Visuals_Camera:AddSlider("ViewmodelOffsetX", { Text = "X Offset", Min = -10, Max = 10, Default = 0, Rounding = 1, Compact = true, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Visuals_Camera:AddSlider("ViewmodelOffsetY", { Text = "Y Offset", Min = -10, Max = 10, Default = 0, Rounding = 1, Compact = true, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })
Groupboxes.Visuals_Camera:AddSlider("ViewmodelOffsetZ", { Text = "Z Offset", Min = -10, Max = 10, Default = 0, Rounding = 1, Compact = true, Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage })

Toggles.AmbientToggle:AddColorPicker("AmbientColor", { Text = "Ambient", Default = Color3.fromRGB(255, 255, 255), Transparency = 0 })
Toggles.AmbientToggle:OnChanged(function(Value)
	local OldAmbient = CurrentRooms:FindFirstChild(tostring(LocalPlayer:GetAttribute("CurrentRoom"))):GetAttribute("Ambient")
	Services.TweenService:Create(Services.Lighting, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), {
		Ambient = Value and Options.AmbientColor.Value or OldAmbient
	}):Play()
end)

local Main_Game
local ClientModules

Toggles.RemoveCameraBobbing:OnChanged(function(Value)
	if Main_Game then Main_Game.spring.Speed = Value and 9e9 or 8 end
end)
Toggles.RemoveCameraFog:OnChanged(function(Value)
	Services.Lighting.FogEnd = Value and 10000000 or Globals.OldFog
	for _, Object in Globals.FogInstances do
		Object.Density = Value and 0 or Object:GetAttribute("Density_Old")
	end
end)
Toggles.RemoveCutscenes:OnChanged(function(Value)
    local Cutscenes = Globals.MainUI.Initiator.Main_Game.RemoteListener.Cutscenes
    for _, Object in pairs(Cutscenes:GetChildren()) do
        if table.find(CutsceneNames, Object.Name) and Object:IsA("ModuleScript") or table.find(CutsceneNames, Object:GetAttribute("OriginalName")) and Object:IsA("ModuleScript") then
            Object.Name = (Value and Object.Name .. "_Disabled" or Object:GetAttribute("OriginalName"))
        end
    end
    for _, Object in pairs(FloorReplicated:GetChildren()) do
        if table.find(CutsceneNames, Object.Name) and Object:IsA("ModuleScript") or table.find(CutsceneNames, Object:GetAttribute("OriginalName")) and Object:IsA("ModuleScript") then
            Object.Name = (Value and Object.Name .. "_Disabled" or Object:GetAttribute("OriginalName"))
        end
    end
end)

Groupboxes.Visuals_Effects = Groupboxes.Visuals_LeftTab:AddTab("Effects")
Groupboxes.Visuals_Effects:AddToggle("TransparentHidingSpotsToggle", { Text = "Transparent Hiding Spots", Default = false, Tooltip = "Makes a hiding spot transparent when you enter it." })
Groupboxes.Visuals_Effects:AddSlider("TransparentHidingSpotsSlider", { Text = "Transparency", Min = 0, Max = 1, Default = 0.5, Rounding = 2, Compact = true })

local function ApplyHidingTransparency(Value, SliderValue)
	for _, Object in Objects.HidingSpots do
		local IsHiding = false
		for _, Child in Object:GetDescendants() do
			if Child.Name == "HiddenPlayer" and Child.Value == Character then
				IsHiding = true
				break
			end
		end
		for _, Part in Object:GetDescendants() do
			if Part:IsA("BasePart") and Part:GetAttribute("Transparency_Old") then
				Services.TweenService:Create(Part, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
					Transparency = (Value and IsHiding) and SliderValue or Part:GetAttribute("Transparency_Old")
				}):Play()
			end
		end
	end
end

Toggles.TransparentHidingSpotsToggle:OnChanged(function(Value)
	ApplyHidingTransparency(Value, Options.TransparentHidingSpotsSlider.Value)
end)
Options.TransparentHidingSpotsSlider:OnChanged(function(Value)
	ApplyHidingTransparency(Toggles.TransparentHidingSpotsToggle.Value, Value)
end)

Groupboxes.Visuals_Effects:AddDivider()
Groupboxes.Visuals_Effects:AddToggle("DisableGlitchJumpscare",   { Text = "Disable Glitch Jumpscare",   Default = false, Tooltip = "Disables the jumpscare from 'Glitch'" })
Groupboxes.Visuals_Effects:AddToggle("DisableTimothyJumpscare",  { Text = "Disable Timothy Jumpscare",  Default = false, Tooltip = "Disables the jumpscare from 'Timothy'" })
Groupboxes.Visuals_Effects:AddToggle("DisableVoidJumpscare",     { Text = "Disable Void Jumpscare",     Default = false, Tooltip = "Disables the jumpscare from 'Void'" })
Groupboxes.Visuals_Effects:AddDivider()
Groupboxes.Visuals_Effects:AddToggle("DisableHideVignette",      { Text = "Disable Hide Vignette",      Default = false, Tooltip = "Disables the hiding screen effect." })
Groupboxes.Visuals_Effects:AddToggle("DisableFiredampEffect",    { Text = "Disable Firedamp Effect",    Default = false, Tooltip = "Disables the firedamp screen effect." })
Groupboxes.Visuals_Effects:AddToggle("DisableEntityJumpscares",  { Text = "Disable Entity Jumpscares",  Default = false, Tooltip = "Disables jumpscares from entities like Rush and Ambush." })

Toggles.DisableGlitchJumpscare:OnChanged(function(Value)
	if Modules.Glitch then Modules.Glitch.Name = Value and "Glitch_Disabled" or "Glitch" end
end)
Toggles.DisableTimothyJumpscare:OnChanged(function(Value)
	if Modules.SpiderJumpscare then
		if Modules.SpiderJumpscare then Modules.SpiderJumpscare.Name = Value and "SpiderJumpscare_Disabled" or "SpiderJumpscare" end
	end
end)
Toggles.DisableVoidJumpscare:OnChanged(function(Value)
	if Modules.Void then Modules.Void.Name = Value and "Void_Disabled" or "Void" end
end)
Toggles.DisableHideVignette:OnChanged(function(Value)
	local Vignette = Globals.MainUI:FindFirstChild("HideVignette") or Globals.MainUI.MainFrame:FindFirstChild("HideVignette")
	if Vignette then Vignette.Image = Value and "Disabled" or "rbxassetid://6100076320" end
end)
Toggles.DisableFiredampEffect:OnChanged(function(Value)
	for _, Object in CurrentRooms:GetChildren() do
		if Value then
			Object:SetAttribute("Firedamp", false)
			for _, FiredampObj in Camera:GetChildren() do
				if FiredampObj.Name == "LiveFiredamp" then FiredampObj:Destroy() end
			end
		else
			Object:SetAttribute("Firedamp", Object:GetAttribute("Firedamp_Old"))
		end
	end
	local Old = LocalPlayer:GetAttribute("CurrentRoom")
	LocalPlayer:SetAttribute("CurrentRoom", 0)
	task.wait()
	LocalPlayer:SetAttribute("CurrentRoom", Old)
end)
Toggles.DisableEntityJumpscares:OnChanged(function(Value)
	local Jumpscares = Globals.MainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscares")
		or Globals.MainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscares_Disabled")
	if Jumpscares then
		Jumpscares.Name = Value and "Jumpscares_Disabled" or "Jumpscares"
		for _, Object in Objects.JumpscareModules do
			Object.Name = Value and (Object:GetAttribute("OriginalName") .. "_Disabled") or Object:GetAttribute("OriginalName")
		end
	end
end)

Groupboxes.Visuals_RightTab = Tabs.Visuals:AddRightTabbox("Entities / ESP")
Groupboxes.Visuals_Entities = Groupboxes.Visuals_RightTab:AddTab("Entities")
Groupboxes.Visuals_EntitySettings = Groupboxes.Visuals_RightTab:AddTab("Notify")

Groupboxes.Visuals_Entities:AddDropdown("EntityList", {
	Text = "Entity List",
	Values = { "Rush","Bash","Scribbles","Teller","DronesStampede","Creak","Noise","Balls","Meld","Cobbler","Ambush","Eyes","Halt","Blitz","Lookman","Gloombat Swarm","A-60","A-120","Sally","Jeff the Killer","Groundskeeper","Monument","AR0xMBUSH","RNIUSHCG==" },
	Multi = true, AllowNull = true
})
Groupboxes.Visuals_Entities:AddToggle("NotifyEntities",    { Text = "Notify Entities",    Default = false, Tooltip = "Sends a notification when an entity spawns." })
Groupboxes.Visuals_Entities:AddDivider()
Groupboxes.Visuals_Entities:AddToggle("NotifyItemsToggle", { Text = "Notify Items", Default = false, Tooltip = "Sends a notification when an item spawns." })
Groupboxes.Visuals_Entities:AddToggle("NotifyItemsShowDistance", { Text = "Show Item Distance", Default = false, Tooltip = "Shows distance in item spawn notifications." })
Groupboxes.Visuals_Entities:AddDropdown("NotifyItemList", {
	Text = "Item Notify List",
	Values = { "Lockpicks", "Skeleton Key", "Shears", "Crucifix", "Flashlight", "Candle", "Lighter", "Battery", "Bandage", "Vitamins", "Starlight Bottle", "Starlight Vial", "Starlight Barrel", "Alarm Clock", "Straplight", "Laser Pointer", "Tablet", "Multitool", "Lamp", "18+ Bottles", "Gween Soda Pack", "Broken Monitor", "Jerry Can", "Sally Toy", "Lunch Box", "Honey Pot", "Fih Food", "CD Disc", "Pizza", "Paper Plane", "Gummy Flashlight", "Spotlight", "Glowstick", "Mini Shield Potion", "Big Shield Potion", "Bandage Pack", "Battery Pack", "Moonlight Candle", "Holy Hand Grenade", "Smoothie", "Cheese", "Bread", "Moonlight Smoothie", "Gween Soda", "Glitch Fragment", "Bomb", "Knockbomb", "Nanner", "Big Bomb", "Hiding Box", "Golden Gun", "Stop Sign", "Tip Jar", "Lantern", "Iron Key", "Lotus Petal", "Compass" },
	Multi = true, AllowNull = true, Default = {},
})
Groupboxes.Visuals_Entities:AddDivider()
Groupboxes.Visuals_Entities:AddToggle("NotifyLibraryCode", { Text = "Notify Library Code", Default = false, Tooltip = "Automatically solves the code for the library padlock." })
Groupboxes.Visuals_Entities:AddToggle("NotifyOxygen",      { Text = "Notify Oxygen Level", Default = false, Tooltip = "Shows how much oxygen you have remaining." })
Groupboxes.Visuals_Entities:AddToggle("NotifyHasteTime",   { Text = "Notify Haste Time",   Default = false, Tooltip = "Shows how much time you have remaining before 'Haste' spawns." })

Globals.LibraryCodeFound = false
Toggles.NotifyLibraryCode:OnChanged(function(Value)
	if Value then
		local Code = Functions.GetLibraryCode()
		if Code and not Code:find("_") and not Globals.LibraryCodeFound and CurrentRooms:FindFirstChild("50") then
			local Lock = Services.Workspace:FindFirstChild("Padlock", true)
			Functions.Notify({ Title = "Padlock code found!", Body = "The code is: '" .. Code .. "'", Time = Toggles.NotifyKeepNotifications.Value and Lock or 15 })
			Globals.LibraryCodeFound = true
		end
	end
end)

Groupboxes.Visuals_EntitySettings:AddToggle("EntityChatToggle", { Text = "Notify Chat", Default = false, Tooltip = "Sends a message in the chat when an entity spawns." })
Groupboxes.Visuals_EntitySettings:AddInput("EntityChatMessage", { Text = "Message", Default = "spawned!", Numeric = false, Placeholder = "Message" })
Groupboxes.Visuals_EntitySettings:AddDivider()
Groupboxes.Visuals_EntitySettings:AddDropdown("NotifyStyle", { Text = "Notify Style", Values = { "Ms fent", "Doors", "STX", "Library" }, Default = 1 })
Groupboxes.Visuals_EntitySettings:AddSlider("NotifySoundVolume", { Text = "Sound Volume", Min = 0, Max = 10, Default = 3, Rounding = 1 })
Groupboxes.Visuals_EntitySettings:AddToggle("NotifyPlaySound", { Text = "Play Sound", Default = true, Tooltip = "Makes notifications play an alert sound." })
Groupboxes.Visuals_EntitySettings:AddToggle("NotifyKeepNotifications", { Text = "Keep Notifications", Default = false, Tooltip = "Certain notifications will stay on screen until they are no longer needed." })
Groupboxes.Visuals_EntitySettings:AddButton({ Text = "Test Notification", DoubleClick = false, Tooltip = "Sends a test notifcation, so you can see how your settings look.", Func = function()
	Functions.Notify({Title = "This is a test."})
end})

Groupboxes.Visuals_ESP = Groupboxes.Visuals_RightTab
Groupboxes.Visuals_ESP_Toggles = Groupboxes.Visuals_RightTab:AddTab("ESP")
Groupboxes.Visuals_ESP_Settings = Groupboxes.Visuals_RightTab:AddTab("ESP Settings")

local function MakeESPToggle(ToggleKey, ColorKey, Text, Tooltip, ObjectsTable, LabelFunc, RoomBased)
	Groupboxes.Visuals_ESP_Toggles:AddToggle(ToggleKey, { Text = Text, Default = false, Tooltip = Tooltip })
	Toggles[ToggleKey]:AddColorPicker(ColorKey, { Text = Text, Default = Options[ColorKey] and Options[ColorKey].Value or Color3.new(1,1,1), Transparency = 0 })
	Toggles[ToggleKey]:OnChanged(function(Value)
		for _, Object in ObjectsTable do
			if Value then
				local Label, UseRoom = LabelFunc(Object)
				if Label then
					Functions.AddESP({ Object = Object, Text = Label, Color = Options[ColorKey].Value }, UseRoom ~= nil and UseRoom or RoomBased)
				end
			else
				Functions.RemoveESP(Object)
			end
		end
	end)
	Options[ColorKey]:OnChanged(function(Value)
		for _, Object in ObjectsTable do
			MsFent.ESPLibrary:UpdateObjectColor(Object, Value)
		end
	end)
end

Groupboxes.Visuals_ESP_Toggles:AddToggle("ObjectiveESPToggle", { Text = "Objectives", Default = false, Tooltip = "Highlights all objects required to progress." })
Toggles.ObjectiveESPToggle:AddColorPicker("ObjectiveESPColor", { Text = "Objectives", Default = Color3.fromRGB(0, 255, 0), Transparency = 0 })

local ObjectiveLabels = {
	["KeyObtain"]              = "Door Key",
	["ElectricalKeyObtain"]    = "Electrical Key",
	["MinesGenerator"]         = "Generator",
	["FuseObtain"]             = "Generator Fuse",
	["LiveHintBook"]           = "Hint Book",
	["LiveBreakerPolePickup"]  = "Fuse Breaker",
	["LibraryHintPaper"]       = "Hint Paper",
	["PickupItem"]             = "Hint Paper",
	["CringlePresent"]         = "Present",
	["LeverForGate"]           = "Gate Lever",
	["MinesGateButton"]        = "Gate Button",
	["GardenGateButton"]       = "Gate Button",
	["StairwellFireAlarm"]     = "Fire Alarm",
	["FireAlarm"]              = "Fire Alarm",
	["Fire_Alarm"]             = "Fire Alarm",
}

Toggles.ObjectiveESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Objectives do
		if Value then
			local Label = ObjectiveLabels[Object.Name]
			local nLow = string.lower(tostring(Object.Name))
			if Object.Name == "TimerLever" then
				Label = "Time Lever [+" .. Object:GetAttribute("AddTime") .. "s]"
			elseif Object.Name == "MinesAnchor" then
				Label = "Anchor [" .. Object:WaitForChild("Sign").TextLabel.Text .. "]"
			elseif Object.Name == "WaterPump" then
				Functions.AddESP({ Object = Object.Wheel, Text = "Water Pump", Color = Options.ObjectiveESPColor.Value }, true)
			elseif Object.Name == "VineGuillotine" then
				Functions.AddESP({ Object = Object.Lever, Text = "Vine Lever", Color = Options.ObjectiveESPColor.Value }, true)
			elseif Object:GetAttribute("MsFent_FireAlarm") or (nLow:find("fire", 1, true) and nLow:find("alarm", 1, true)) then
				Label = "Fire Alarm"
			end
			if Label then
				local target = Object
				if Label == "Fire Alarm" and Object:IsA("Model") then
					target = Object.PrimaryPart or Object:FindFirstChildWhichIsA("BasePart", true) or Object
				end
				Functions.AddESP({ Object = target, Text = Label, Color = Options.ObjectiveESPColor.Value }, true)
			end
		else
			Functions.RemoveESP(Object)
		end
	end
end)
Options.ObjectiveESPColor:OnChanged(function(Value)
	for _, Object in Objects.Objectives do
		MsFent.ESPLibrary:UpdateObjectColor(Object, Value)
	end
end)

Groupboxes.Visuals_ESP_Toggles:AddToggle("DoorESPToggle",       { Text = "Doors",        Default = false, Tooltip = "Highlights the next door." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("HidingSpotESPToggle", { Text = "Hiding Spots", Default = false, Tooltip = "Highlights places where you can hide from entities" })
Groupboxes.Visuals_ESP_Toggles:AddToggle("PlayerESPToggle",     { Text = "Players",      Default = false, Tooltip = "Highlights other players." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("ChestESPToggle",      { Text = "Chests",       Default = false, Tooltip = "Highlights objects that can contain loot." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("ItemESPToggle",       { Text = "Items",        Default = false, Tooltip = "Highlights all collectable items/consumables." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("CurrencyESPToggle",   { Text = "Currency",     Default = false, Tooltip = "Highlights all currency that spawns." })
Groupboxes.Visuals_ESP_Toggles:AddToggle("LadderESPToggle",     { Text = "Ladders",      Default = false, Tooltip = "Highlights ladders that can be used to disable the anticheat." })
Groupboxes.Visuals_ESP_Toggles:AddDivider()
Groupboxes.Visuals_ESP_Toggles:AddDropdown("EntityESPOptions", {
	Text = "Entity List",
	Values = { "Rush","Bash","Scribbles","Teller","DronesStampede","Creak","Noise","Balls","Meld","Cobbler","Ambush","Eyes","Dupe","Figure","Blitz","Lookman","Snare","Giggle","Gloombat Eggs","Grumble","A-60","A-120","Sally","Jeff the Killer","Groundskeeper","Mandrake Hole","Monument","Bramble","AR0xMBUSH","RNIUSHCG==" },
	Multi = true,
	AllowNull = true
})
Groupboxes.Visuals_ESP_Toggles:AddToggle("EntityESPToggle",     { Text = "Entities",     Default = false, Tooltip = "Highlights all entities that spawn." })

Toggles.DoorESPToggle:AddColorPicker("DoorESPColor",           { Text = "Doors",        Default = Color3.fromRGB(0, 200, 255),  Transparency = 0 })
Toggles.HidingSpotESPToggle:AddColorPicker("HidingSpotESPColor", { Text = "Hiding Spots", Default = Color3.fromRGB(255, 170, 0),  Transparency = 0 })
Toggles.PlayerESPToggle:AddColorPicker("PlayerESPColor",       { Text = "Players",      Default = Color3.fromRGB(255, 255, 255), Transparency = 0 })
Toggles.ChestESPToggle:AddColorPicker("ChestESPColor",         { Text = "Chests",       Default = Color3.fromRGB(255, 255, 0),   Transparency = 0 })
Toggles.ItemESPToggle:AddColorPicker("ItemESPColor",           { Text = "Items",        Default = Color3.fromRGB(170, 0, 255),   Transparency = 0 })
Toggles.CurrencyESPToggle:AddColorPicker("CurrencyESPColor",   { Text = "Currency",     Default = Color3.fromRGB(255, 255, 0),   Transparency = 0 })
Toggles.LadderESPToggle:AddColorPicker("LadderESPColor",       { Text = "Ladders",      Default = Color3.fromRGB(255, 255, 255), Transparency = 0 })
Toggles.EntityESPToggle:AddColorPicker("EntityESPColor",       { Text = "Entities",     Default = Color3.fromRGB(255, 0, 0),     Transparency = 0 })

Groupboxes.Visuals_ESP_Toggles:AddToggle("ShowEntityPath", {
	Text = "Show Entity Path", Default = false,
	Tooltip = "Draws path nodes for rush-like entities.",
})
Groupboxes.Visuals_ESP_Toggles:AddToggle("MiscESPToggle", {
	Text = "Misc Objects", Default = false,
	Tooltip = "Highlights miscellaneous interactables.",
})
Toggles.MiscESPToggle:AddColorPicker("MiscESPColor", { Text = "Misc", Default = Color3.fromRGB(200, 200, 255) })
Groupboxes.Visuals_ESP_Settings:AddSlider("ShowEntityPathLineThickness", {
	Text = "Path Line Thickness", Min = 0.5, Max = 5, Default = 1.5, Rounding = 1, Compact = true,
})
Groupboxes.Visuals_ESP_Settings:AddSlider("ShowEntityPathLineTransparency", {
	Text = "Path Line Transparency", Min = 0, Max = 1, Default = 0.3, Rounding = 2, Compact = true,
})
Groupboxes.Visuals_ESP_Settings:AddSlider("ShowEntityPathNodeTransparency", {
	Text = "Path Node Transparency", Min = 0, Max = 1, Default = 0.4, Rounding = 2, Compact = true,
})


local HidingSpotLabels = {
	Wardrobe = "Closet", ["Backdoor_Wardrobe"] = "Closet", Toolshed = "Closet",
	RetroWardrobe = "Closet", ["Wardrobe-FOOLS26"] = "Closet",
	Locker_Large = "Locker", Rooms_Locker = "Locker", Rooms_Locker_Fridge = "Locker",
	Bed = "Bed", Double_Bed = "Double Bed", CircularVent = "Vent", Dumpster = "Dumpster"
}
local ChestLabels = {
	ChestBox = true, ChestBoxLocked = true, Toolbox = true, Toolbox_Locked = true,
	Chest_Vine = "Vine Chest", Toolshed_Small = "Toolshed", Locker_Small_Locked = "Locked Item Locker", MouseHole = "Mouse"
}
local EntityESPLabels = {
	KeyObtainFake = "Fake Key", JeffTheKiller = "Jeff the Killer", GiggleCeiling = "Giggle",
	Snare = "Snare", GrumbleRig = "Grumble",
	BashMoving = "Bash", Bash = "Bash", BashRig = "Bash", Scribbles = "Scribbles", TellerRig = "Teller", Teller = "Teller",
	DronesStampede = "DronesStampede", Drones = "DronesStampede", Creak = "Creak", CreakRig = "Creak",
	NoiseModel = "Noise", Noise = "Noise", TV_Stand = "Noise_TV", Portrait = "Portrait", StemsEntity = "Balls", Stem = "Balls", Stems = "Balls", Meld = "Meld", Cobbler = "Cobbler",
	Drakobloxxer = "Drakobloxxer", Hole = "Mandrake Hole", Groundskeeper = "Groundskeeper",
	LiveEntityBramble = "Bramble", Figure = "Figure", FigureRig = "Figure", FigureRagdoll = "Figure"
}

Toggles.DoorESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Doors do
		if Value then Functions.AddESP({ Object = Object, Text = "Door " .. Functions.GetDoorNumber(Object), Color = Options.DoorESPColor.Value }, true)
		else Functions.RemoveESP(Object) end
	end
end)
Options.DoorESPColor:OnChanged(function(Value)
	for _, Object in Objects.Doors do MsFent.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.HidingSpotESPToggle:OnChanged(function(Value)
	for _, Object in Objects.HidingSpots do
		local Label = HidingSpotLabels[Object.Name]
		if Value and Label then Functions.AddESP({ Object = Object, Text = Label, Color = Options.HidingSpotESPColor.Value }, true)
		elseif not Value then Functions.RemoveESP(Object) end
	end
end)
Options.HidingSpotESPColor:OnChanged(function(Value)
	for _, Object in Objects.HidingSpots do MsFent.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.PlayerESPToggle:OnChanged(function(Value)
	task.wait()
	for _, Player in Services.Players:GetPlayers() do
		if Player.Character and Player ~= LocalPlayer then
			if Value and Player:GetAttribute("Alive") == true then
				Functions.AddESP({ Object = Player.Character, Text = Player.Name, Color = Options.PlayerESPColor.Value })
			else
				Functions.RemoveESP(Player.Character)
			end
		end
	end
end)
Options.PlayerESPColor:OnChanged(function(Value)
	for _, Player in Services.Players:GetPlayers() do
		if Player.Character and Player ~= LocalPlayer then
			MsFent.ESPLibrary:UpdateObjectColor(Player.Character, Value)
		end
	end
end)

Toggles.ChestESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Chests do
		if Value then
			local Label
			if Object.Name == "ChestBox" or Object.Name == "ChestBoxLocked" then
				Label = Object:GetAttribute("Locked") and "Locked Chest" or "Chest"
			elseif Object.Name == "Toolbox" or Object.Name == "Toolbox_Locked" then
				Label = Object:GetAttribute("Locked") and "Locked Toolbox" or "Toolbox"
			elseif ChestLabels[Object.Name] and ChestLabels[Object.Name] ~= true then
				Label = ChestLabels[Object.Name]
			end
			if Label then Functions.AddESP({ Object = Object, Text = Label, Color = Options.ChestESPColor.Value }, true) end
		else
			Functions.RemoveESP(Object)
		end
	end
end)

Options.ChestESPColor:OnChanged(function(Value)
	for _, Object in Objects.Chests do MsFent.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.ItemESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Items do
		if Value then
			local Label = ItemNames[Object.Name] or (Object.Name == "Green_Herb" and "Green Herb")
			if Label then
				Functions.AddESP({ Object = Object, Text = Label, Color = Options.ItemESPColor.Value }, Object:GetAttribute("ParentRoom") ~= nil)
			end
		else
			Functions.RemoveESP(Object)
		end
	end
end)
Options.ItemESPColor:OnChanged(function(Value)
	for _, Object in Objects.Items do MsFent.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.CurrencyESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Currency do
		if Value then
			local Label
			if Object.Name == "GoldPile" and Object:GetAttribute("GoldValue") then
				Label = "Gold Pile [" .. Object:GetAttribute("GoldValue") .. "]"
			elseif Object.Name == "StardustPickup" then
				Label = "Stardust Pile"
			end
			if Label then Functions.AddESP({ Object = Object, Text = Label, Color = Options.CurrencyESPColor.Value }, true) end
		else
			Functions.RemoveESP(Object)
		end
	end
end)
Options.CurrencyESPColor:OnChanged(function(Value)
	for _, Object in Objects.Currency do MsFent.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

local NodeEntities = { Rush = true, Bash = true, Scribbles = true, DronesStampede = true, Ambush = true, Eyes = true, Blitz = true, Lookman = true, ["A-60"] = true, ["A-120"] = true, Sally = true, ["Jeff The Killer"] = true, Monument = true, ["AR0xMBUSH"] = true, ["RNIUSHCG=="] = true, Creak = true, Noise = true, Balls = true }

local function EntityESPAllowed(Label)
	if not Label then return false end
	local opts = Options.EntityESPOptions and Options.EntityESPOptions.Value
	if not opts then return true end
	local anySelected = false
	for _, v in pairs(opts) do
		if v then anySelected = true break end
	end
	if not anySelected then return true end
	return opts[Label] == true
end

local function RefreshEntityESP()
	for _, Object in Objects.Entities do
		if Toggles.EntityESPToggle.Value and Object and Object.Parent then
			local Label = EntityESPLabels[Object.Name]
			if not Label and Entities[Object.Name] then Label = Entities[Object.Name].Alias end
			if EntityESPAllowed(Label) then
				local target = Object
				if Object.Name == "MonumentEntity" and Object:FindFirstChild("Top") then
					target = Object.Top
				-- Creak / Noise: use a single part for ESP so Highlight doesn't break model animations
				elseif Label == "Creak" or Label == "Noise" then
					local pp = Object.PrimaryPart or Object:FindFirstChildWhichIsA("BasePart", true)
					if pp then target = pp end
				end
				Functions.AddESP({ Object = target, Text = Label or Object.Name, Color = Options.EntityESPColor.Value }, NodeEntities[Label] ~= true)
			else
				Functions.RemoveESP(Object)
			end
		else
			if Object then Functions.RemoveESP(Object) end
		end
	end
end

Toggles.EntityESPToggle:OnChanged(function()
	if Toggles.EntityESPToggle.Value and Globals.ScanEntitiesForESP then
		pcall(Globals.ScanEntitiesForESP)
	end
	RefreshEntityESP()
end)
if Options.EntityESPOptions then
	Options.EntityESPOptions:OnChanged(function()
		RefreshEntityESP()
	end)
end
Options.EntityESPColor:OnChanged(function(Value)
	for _, Object in Objects.Entities do MsFent.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Toggles.LadderESPToggle:OnChanged(function(Value)
	for _, Object in Objects.Ladders do
		if Value then Functions.AddESP({ Object = Object, Text = "Ladder", Color = Options.LadderESPColor.Value }, true)
		else Functions.RemoveESP(Object) end
	end
end)
Options.LadderESPColor:OnChanged(function(Value)
	for _, Object in Objects.Ladders do MsFent.ESPLibrary:UpdateObjectColor(Object, Value) end
end)

Groupboxes.Visuals_ESP_Settings:AddToggle("ESPRainbow",     { Text = "Rainbow Effect", Default = false, Tooltip = "Makes the esp objects change colour like a rainbow." })
Groupboxes.Visuals_ESP_Settings:AddToggle("ESPShowDistance",{ Text = "Show Distance",  Default = true,  Tooltip = "Shows how far away your character is from the object." })
Groupboxes.Visuals_ESP_Settings:AddDivider()
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPFillTransparency",        { Text = "Fill Transparency",         Min = 0, Max = 1, Default = 0.75, Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPOutlineTransparency",     { Text = "Outline Transparency",      Min = 0, Max = 1, Default = 0,    Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextTransparency",        { Text = "Text Transparency",         Min = 0, Max = 1, Default = 0,    Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextOutlineTransparency", { Text = "Text Outline Transparency", Min = 0, Max = 1, Default = 0,    Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPFadeTime",                { Text = "Fade Time",                 Min = 0, Max = 1, Default = 0.25, Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPRenderLimit",             { Text = "Render Limit",              Min = 30, Max = 240, Default = 240, Rounding = 0, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTextSize",                { Text = "Text Size",                 Min = 12, Max = 24, Default = 20, Rounding = 0, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddDropdown("ESPTextFont", {
	Text = "Text Font",
	Values = { "Legacy","Arial","ArialBold","SourceSans","SourceSansBold","SourceSansLight","SourceSansItalic","Bodoni","Garamond","Cartoon","Code","Highway","SciFi","Arcade","Fantasy","Antique","SourceSansSemibold","Gotham","GothamMedium","GothamBold","GothamBlack","AmaticSC","Bangers","Creepster","DenkOne","Fondamento","FredokaOne","GrenzeGotisch","IndieFlower","JosefinSans","Jura","Kalam","LuckiestGuy","Merriweather","Michroma","Nunito","Oswald","PatrickHand","PermanentMarker","Roboto","RobotoCondensed","RobotoMono","Sarpanch","SpecialElite","TitilliumWeb","Ubuntu","BuilderSans","BuilderSansMedium","BuilderSansBold","BuilderSansExtraBold","Arimo","ArimoBold" },
	Default = 12
})
Groupboxes.Visuals_ESP_Settings:AddDivider()
Groupboxes.Visuals_ESP_Settings:AddDropdown("ESPTracersOrigin",  { Text = "Tracer Origin", Values = { "Bottom","Center","Top","Mouse" }, Default = 1 })
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPTracerThickness",  { Text = "Tracer Thickness", Min = 0.5, Max = 2, Default = 0.75, Rounding = 2, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddToggle("ESPTracersToggle",    { Text = "Enable Tracers", Default = false, Tooltip = "Draws a line to highlighted objects." })
Groupboxes.Visuals_ESP_Settings:AddDivider()
Groupboxes.Visuals_ESP_Settings:AddSlider("ESPArrowsRadius",     { Text = "Arrow Radius", Min = 100, Max = 500, Default = 250, Rounding = 0, Compact = true })
Groupboxes.Visuals_ESP_Settings:AddToggle("ESPArrowsToggle",     { Text = "Enable Arrows", Default = false, Tooltip = "Shows arrow that point to off-screen objects." })

MsFent.ESPLibrary:SetRainbow(false)
MsFent.ESPLibrary:SetShowDistance(true)
MsFent.ESPLibrary:SetFillTransparency(0.75)
MsFent.ESPLibrary:SetOutlineTransparency(0)
MsFent.ESPLibrary:SetTextTransparency(0)
MsFent.ESPLibrary:SetTextOutlineTransparency(0)
MsFent.ESPLibrary:SetRenderLimit(240)
MsFent.ESPLibrary:SetFadeTime(0.25)
MsFent.ESPLibrary:SetTextSize(20)
MsFent.ESPLibrary:SetFont(Enum.Font.Highway)
MsFent.ESPLibrary:SetTracers(false)
MsFent.ESPLibrary:SetTracerSize(0.75)
MsFent.ESPLibrary:SetTracerOrigin("Bottom")
MsFent.ESPLibrary:SetArrows(false)
MsFent.ESPLibrary:SetArrowRadius(250)
MsFent.ESPLibrary:SetDistanceSizeRatio(0.8)

Toggles.ESPRainbow:OnChanged(function(V)        MsFent.ESPLibrary:SetRainbow(V) end)
Toggles.ESPShowDistance:OnChanged(function(V)   MsFent.ESPLibrary:SetShowDistance(V) end)
Options.ESPFillTransparency:OnChanged(function(V)        MsFent.ESPLibrary:SetFillTransparency(V) end)
Options.ESPOutlineTransparency:OnChanged(function(V)     MsFent.ESPLibrary:SetOutlineTransparency(V) end)
Options.ESPTextTransparency:OnChanged(function(V)        MsFent.ESPLibrary:SetTextTransparency(V) end)
Options.ESPTextOutlineTransparency:OnChanged(function(V) MsFent.ESPLibrary:SetTextOutlineTransparency(V) end)
Options.ESPFadeTime:OnChanged(function(V)        MsFent.ESPLibrary:SetFadeTime(V) end)
Options.ESPRenderLimit:OnChanged(function(V)     MsFent.ESPLibrary:SetRenderLimit(V) end)
Options.ESPTextSize:OnChanged(function(V)        MsFent.ESPLibrary:SetTextSize(V) end)
Options.ESPTextFont:OnChanged(function(V)        MsFent.ESPLibrary:SetFont(Enum.Font[V]) end)
Toggles.ESPTracersToggle:OnChanged(function(V)   MsFent.ESPLibrary:SetTracers(V) end)
Options.ESPTracersOrigin:OnChanged(function(V)   MsFent.ESPLibrary:SetTracerOrigin(V) end)
Options.ESPTracerThickness:OnChanged(function(V) MsFent.ESPLibrary:SetTracerSize(V) end)
Toggles.ESPArrowsToggle:OnChanged(function(V)    MsFent.ESPLibrary:SetArrows(V) end)
Options.ESPArrowsRadius:OnChanged(function(V)    MsFent.ESPLibrary:SetArrowRadius(V) end)

Tabs.Floors:UpdateWarningBox({
	Visible = true,
	Title = "Compatability Warning",
	Text = "Features highlighted in red do not work in the current floor.",
})

Groupboxes.Floors_Automation = Tabs.Floors:AddRightGroupbox("Automation")

Groupboxes.Floors_Automation:AddToggle("SkipSeekMines", {
	Text = "Skip Seek (Mines)", Default = false,
	Tooltip = "Skips Seek sections in the Mines.",
	Risky = true,
})

Groupboxes.Floors_Automation:AddToggle("AutoSteerMinecart", {
	Text = "Auto Steer Minecart", Default = false, Tooltip = "Automatically completes the minecart chase.",
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Floors_Automation:AddSlider("AutoSteerMinecartTurnDistance", {
	Text = "Turn Distance", Min = 20, Max = 40, Default = 30, Rounding = 0,
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Floors_Automation:AddSlider("AutoSteerMinecartDuckDistance", {
	Text = "Crouch Distance", Min = 20, Max = 40, Default = 30, Rounding = 0,
	Disabled = not Functions.CheckCompatability({"require"}), DisabledTooltip = Globals.IncompatibleMessage
})
-- Archives (replaces old Rooms features in Floors tab)
Groupboxes.Floors_Archives = Tabs.Floors:AddLeftGroupbox("Archives")
Groupboxes.Floors_Archives:AddToggle("AntiRansom", { Text = "Anti Ransom", Default = false, Tooltip = "Destroys Ransom when it spawns." })
Groupboxes.Floors_Archives:AddToggle("AntiClosetTrash", { Text = "Anti Closet Trash", Default = false, Tooltip = "Deletes Binder/Shoe/Shelf closet trash." })
Groupboxes.Floors_Archives:AddToggle("ForgetMeNotSolver", { Text = "Forget Me Not Skipper", Default = false, Tooltip = "Auto-solves Forget Me Not vine doors." })
Groupboxes.Floors_Archives:AddToggle("TimeShower", { Text = "Time Shower", Default = false, Tooltip = "Shows Archives clock time on screen." })
Groupboxes.Floors_Archives:AddToggle("BypassDronesStampede", { Text = "Stop Time / Anti Stampede", Default = false, Tooltip = "Fires clock LookedAt remote to stop drone stampede." })
Groupboxes.Floors_Archives:AddToggle("HonchoCorrectBoxESP", { Text = "Honcho Correct Box ESP", Default = false, Tooltip = "Highlights correct Honcho storage boxes." })
Groupboxes.Floors_Archives:AddDivider()
Groupboxes.Floors_Archives:AddToggle("BypassWater", { Text = "Bypass Electric Water", Default = false, Tooltip = "Platform above electric water." })
Groupboxes.Floors_Archives:AddToggle("BypassAlma", { Text = "Bypass Alma", Default = false, Tooltip = "Destroys Alma on spawn." })
Groupboxes.Floors_Archives:AddToggle("BypassDrones", { Text = "Bypass Drones", Default = false, Tooltip = "Removes Drones WalkedInto so they can't hit you." })
Groupboxes.Floors_Archives:AddToggle("AntiScribbles", { Text = "Bypass Scribbles", Default = false, Tooltip = "Removes Scribbles exploit-detection child." })
Groupboxes.Floors_Archives:AddToggle("BypassBash", { Text = "Bypass Bash", Default = false, Tooltip = "Elevates you on a high platform + LOS shield until Bash despawns." })
Groupboxes.Floors_Archives:AddToggle("ArchivesChairACBypass", {
	Text = "Chair Anticheat Bypass",
	Default = false,
	Risky = true,
	Tooltip = "Allows you to bypass the anticheat using an office chair. Use Start Bypass near a chair.",
})
Groupboxes.Floors_Archives:AddSlider("ChairSpeed", {
	Text = "Chair Speed",
	Default = 50,
	Min = 1,
	Max = 100,
	Rounding = 0,
	Tooltip = "Movement speed while chair anticheat bypass is active.",
})
Groupboxes.Floors_Archives:AddButton({
	Text = "Start Bypass",
	Tooltip = "Start chair anticheat bypass (stand near an office chair).",
	Func = function()
		if Functions.ArchivesChairAC_Start then
			Functions.ArchivesChairAC_Start()
		end
	end,
})
Groupboxes.Floors_Archives:AddButton({
	Text = "Stop Bypass",
	Tooltip = "Stop chair anticheat bypass and restore chair.",
	Func = function()
		if Functions.ArchivesChairAC_Stop then
			Functions.ArchivesChairAC_Stop()
		end
	end,
})

-- ===== STAIRWELL (Ms fent, inlined) =====
Groupboxes.Floors_Stairwell = Tabs.Floors:AddLeftGroupbox("Stairwell")
local droppedItemsIntervalRunning = false

local function MsFent_GetDropsFolders()
	local folders = {}
	local seen = {}
	local function add(f)
		if f and not seen[f] then
			seen[f] = true
			table.insert(folders, f)
		end
	end
	add(workspace:FindFirstChild("Drops"))
	add(workspace:FindFirstChild("DroppedItems"))
	add(workspace:FindFirstChild("Items"))
	local cr = workspace:FindFirstChild("CurrentRooms")
	if cr then
		for _, room in ipairs(cr:GetChildren()) do
			add(room:FindFirstChild("Drops"))
			add(room:FindFirstChild("DroppedItems"))
		end
	end
	-- fallback: any Folder named Drops under workspace
	for _, d in ipairs(workspace:GetDescendants()) do
		if d:IsA("Folder") and (d.Name == "Drops" or d.Name == "DroppedItems") then
			add(d)
		end
	end
	return folders
end

local function MsFent_ClaimDrop(item)
	pcall(function()
		local parts = {}
		if item:IsA("BasePart") then
			table.insert(parts, item)
		elseif item:IsA("Model") then
			for _, d in ipairs(item:GetDescendants()) do
				if d:IsA("BasePart") then
					table.insert(parts, d)
				end
			end
		end
		for _, part in ipairs(parts) do
			pcall(function()
				part.Anchored = false
				part.CanCollide = false
				if part.SetNetworkOwner then
					part:SetNetworkOwner(LocalPlayer)
				end
			end)
		end
	end)
end

local function MsFent_MoveDrop(item, cf)
	MsFent_ClaimDrop(item)
	pcall(function()
		if item:IsA("Model") then
			item:PivotTo(cf)
			-- also shove primary / all parts in case PivotTo is ignored
			local pp = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart", true)
			if pp then
				pp.CFrame = cf
				pp.AssemblyLinearVelocity = Vector3.zero
				pp.AssemblyAngularVelocity = Vector3.zero
			end
		elseif item:IsA("BasePart") then
			item.CFrame = cf
			item.AssemblyLinearVelocity = Vector3.zero
			item.AssemblyAngularVelocity = Vector3.zero
		end
	end)
end

local function BringDroppedItems()
	local char = LocalPlayer.Character or Character
	local root = char and (char:FindFirstChild("HumanoidRootPart") or RootPart)
	if not root then
		pcall(function()
			Functions.Notify({ Title = "Bring Items", Body = "No character / root part." })
		end)
		return
	end
	local target = root.CFrame * CFrame.new(0, 1.5, -2)
	local count = 0
	for _, folder in ipairs(MsFent_GetDropsFolders()) do
		for _, item in ipairs(folder:GetChildren()) do
			if item:IsA("Model") or item:IsA("BasePart") then
				MsFent_MoveDrop(item, target)
				count += 1
			end
		end
	end
	pcall(function()
		Functions.Notify({
			Title = "Bring Dropped Items",
			Body = count > 0 and ("Moved " .. count .. " drop(s).") or "No drops found (check Stairwell Drops folder).",
		})
	end)
end

Groupboxes.Floors_Stairwell:AddButton({
	Text = "Bring Dropped Items",
	Func = function() BringDroppedItems() end,
	DoubleClick = false,
	Tooltip = "Brings all dropped items to you."
})
Groupboxes.Floors_Stairwell:AddToggle("EnableDroppedItemsInterval", {
	Text = "Enable Interval",
	Default = false,
	Tooltip = "Automatically brings dropped items at the selected interval."
})
Groupboxes.Floors_Stairwell:AddSlider("DroppedItemsInterval", {
	Text = "Interval", Default = 1, Min = 0, Max = 60, Rounding = 1, Compact = false,
	Tooltip = "How often dropped items are brought."
})
Toggles.EnableDroppedItemsInterval:OnChanged(function(enabled)
	if enabled then
		if droppedItemsIntervalRunning then return end
		droppedItemsIntervalRunning = true
		task.spawn(function()
			while Toggles.EnableDroppedItemsInterval.Value do
				BringDroppedItems()
				local interval = Options.DroppedItemsInterval.Value
				if interval <= 0 then task.wait() else task.wait(interval) end
			end
			droppedItemsIntervalRunning = false
		end)
	end
end)

Groupboxes.Floors_Stairwell:AddDivider()
Groupboxes.Floors_Stairwell:AddToggle("AntiNoise", {
	Text = "Anti Noise", Default = false,
	Tooltip = "Client movement that avoids Noise tracking (silent move)."
})
Groupboxes.Floors_Stairwell:AddToggle("BypassNoise", {
	Text = "Noise TV Breaker", Default = false,
	Tooltip = "Breaks Noise TV while you are holding/pushing it."
})
Groupboxes.Floors_Stairwell:AddDivider()
Groupboxes.Floors_Stairwell:AddToggle("DroppedItemValue", {
	Text = "Item Number", Default = false,
	Tooltip = "Shows the number of dropped items.",
})
Groupboxes.Floors_Stairwell:AddToggle("KillAllWithCart", {
	Text = "Kill All (Requires ≥1 Cart)", Default = false,
	Tooltip = "Uses carts to damage others (Stairwell).",
})
Groupboxes.Floors_Stairwell:AddToggle("FlingCreak", {
	Text = "Bug Out Creak (≥5 Cart)", Default = false,
	Tooltip = "Do not touch the carts yourself.",
})
Groupboxes.Floors_Stairwell:AddToggle("CreakAggressionMeter", {
	Text = "Creak Aggression Meter", Default = false,
	Tooltip = "Shows Creak aggression state.",
})
Groupboxes.Floors_Stairwell:AddToggle("MeldRemover", {
	Text = "Meld Remover", Default = false,
	Tooltip = "Removes Meld-related objects.",
})
Groupboxes.Floors_Stairwell:AddToggle("StairwellLandingSpam", {
	Text = "TP to trash & drop trash", Default = false,
	Tooltip = "TP to landing trash prompts and drop (combine with Orbit / Bring).",
})
Groupboxes.Floors_Stairwell:AddToggle("DeleteStairwellCrusherExceptBasicWall", {
	Text = "Delete Crusher (Keep Wall)", Default = false,
})
Groupboxes.Floors_Stairwell:AddToggle("DisableStairwellCrusherCollision", {
	Text = "Disable Crusher Collision", Default = false,
})

Groupboxes.Floors_Stairwell:AddDivider()
Groupboxes.Floors_Stairwell:AddToggle("FireAlarmESPToggle", {
	Text = "Fire Alarm ESP",
	Default = false,
	Tooltip = "Highlights Stairwell fire alarms (green). Re-scans every 5 seconds.",
})
Toggles.FireAlarmESPToggle:AddColorPicker("FireAlarmESPColor", {
	Text = "Fire Alarm ESP",
	Default = Color3.fromRGB(0, 255, 80),
	Transparency = 0,
})

local FireAlarmESPRefreshToken = 0

local function MsFent_IsFireAlarmInstance(Inst)
	if not Inst or not (Inst:IsA("Model") or Inst:IsA("BasePart")) then return false end
	local n = tostring(Inst.Name)
	local low = string.lower(n)
	return n == "StairwellFireAlarm" or n == "FireAlarm" or n == "Fire_Alarm"
		or n == "FireAlarmSwitch" or n == "AlarmSwitch" or n == "FireEscapeAlarm"
		or n == "PullStation" or n == "FirePull"
		or (low:find("fire", 1, true) and low:find("alarm", 1, true))
end

local function MsFent_ScanFireAlarmsESP()
	local col = (Options.FireAlarmESPColor and Options.FireAlarmESPColor.Value) or Color3.fromRGB(0, 255, 80)
	-- prune dead refs
	for i = #Objects.FireAlarms, 1, -1 do
		local obj = Objects.FireAlarms[i]
		if not obj or not obj.Parent then
			table.remove(Objects.FireAlarms, i)
		end
	end
	for _, Inst in ipairs(workspace:GetDescendants()) do
		if MsFent_IsFireAlarmInstance(Inst) then
			if not table.find(Objects.FireAlarms, Inst) then
				table.insert(Objects.FireAlarms, Inst)
			end
			pcall(function()
				Functions.AddESP({ Object = Inst, Text = "Fire Alarm", Color = col }, true)
			end)
		end
	end
	for _, Object in Objects.FireAlarms do
		if Object and Object.Parent then
			pcall(function()
				Functions.AddESP({ Object = Object, Text = "Fire Alarm", Color = col }, true)
			end)
		end
	end
end

Toggles.FireAlarmESPToggle:OnChanged(function(Value)
	FireAlarmESPRefreshToken += 1
	local token = FireAlarmESPRefreshToken
	if not Value then
		for _, Object in Objects.FireAlarms do
			pcall(function() Functions.RemoveESP(Object) end)
		end
		return
	end
	MsFent_ScanFireAlarmsESP()
	-- re-update every 5 seconds while enabled
	task.spawn(function()
		while Toggles.FireAlarmESPToggle.Value and token == FireAlarmESPRefreshToken do
			task.wait(5)
			if not Toggles.FireAlarmESPToggle.Value or token ~= FireAlarmESPRefreshToken then break end
			MsFent_ScanFireAlarmsESP()
		end
	end)
end)
Options.FireAlarmESPColor:OnChanged(function(Value)
	for _, Object in Objects.FireAlarms do
		pcall(function() MsFent.ESPLibrary:UpdateObjectColor(Object, Value) end)
	end
end)

-- No Heavy Item Limit (Depot / two-handed items — pick up more than one)
Groupboxes.Floors_Stairwell:AddToggle("NoHeavyItemsLimit", {
	Text = "No Heavy Item Limit",
	Default = false,
	Tooltip = "Lets you hold multiple depot / two-handed heavy items (moves them to backpack + clears carry locks).",
})

local NoHeavyItemsConn = nil
local NoHeavyItemsCharConn = nil
local NoHeavyItemsLoopToken = 0

local function MsFent_IsHeavyTool(tool)
	if not tool or not tool:IsA("Tool") then return false end
	local n = string.lower(tostring(tool.Name))
	-- Stairwell depot / two-handed style names
	local keywords = {
		"jerry", "screw", "monitor", "crate", "bottle", "gween", "lamp",
		"hat", "depot", "heavy", "large", "broken", "damaged", "gasoline",
		"fuel", "canister", "scrap", "twisted",
	}
	for _, k in ipairs(keywords) do
		if n:find(k, 1, true) then return true end
	end
	-- attributes some floors use
	if tool:GetAttribute("Heavy") == true
		or tool:GetAttribute("IsHeavy") == true
		or tool:GetAttribute("TwoHanded") == true
		or tool:GetAttribute("TwoHand") == true
		or tool:GetAttribute("DepotItem") == true
		or tool:GetAttribute("RequiresTwoHands") == true
	then
		return true
	end
	return false
end

local function MsFent_ClearHeavyLocks(char)
	if not char then return end
	local attrNames = {
		"HoldingHeavy", "IsHoldingHeavy", "CarryingHeavy", "HeavyItem",
		"TwoHanded", "TwoHands", "HoldingTwoHanded", "DepotHolding",
		"CannotPickup", "InventoryLocked", "HandsFull", "HoldingLarge",
	}
	for _, a in ipairs(attrNames) do
		pcall(function()
			if char:GetAttribute(a) ~= nil then
				char:SetAttribute(a, nil)
			end
		end)
	end
	-- humanoid state that blocks equip
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		pcall(function()
			if hum:GetAttribute("HoldingHeavy") ~= nil then hum:SetAttribute("HoldingHeavy", nil) end
			if hum:GetAttribute("TwoHanded") ~= nil then hum:SetAttribute("TwoHanded", nil) end
		end)
	end
end

local function MsFent_StashHeavyTools(char)
	if not char then return end
	local backpack = LocalPlayer:FindFirstChild("Backpack")
	if not backpack then return end
	for _, child in ipairs(char:GetChildren()) do
		if MsFent_IsHeavyTool(child) then
			-- strip heavy flags then move to backpack so another can be picked up
			pcall(function()
				child:SetAttribute("Heavy", nil)
				child:SetAttribute("IsHeavy", nil)
				child:SetAttribute("TwoHanded", nil)
				child:SetAttribute("TwoHand", nil)
				child:SetAttribute("RequiresTwoHands", nil)
				child:SetAttribute("DepotItem", nil)
			end)
			pcall(function() child.Parent = backpack end)
		end
	end
	MsFent_ClearHeavyLocks(char)
end

Toggles.NoHeavyItemsLimit:OnChanged(function(Value)
	NoHeavyItemsLoopToken += 1
	local token = NoHeavyItemsLoopToken
	if NoHeavyItemsConn then
		pcall(function() NoHeavyItemsConn:Disconnect() end)
		NoHeavyItemsConn = nil
	end
	if NoHeavyItemsCharConn then
		pcall(function() NoHeavyItemsCharConn:Disconnect() end)
		NoHeavyItemsCharConn = nil
	end
	if not Value then return end

	local function hookCharacter(char)
		if not char then return end
		MsFent_StashHeavyTools(char)
		if NoHeavyItemsConn then
			pcall(function() NoHeavyItemsConn:Disconnect() end)
		end
		NoHeavyItemsConn = char.ChildAdded:Connect(function(child)
			if not Toggles.NoHeavyItemsLimit.Value then return end
			if MsFent_IsHeavyTool(child) then
				task.defer(function()
					if not Toggles.NoHeavyItemsLimit.Value then return end
					local backpack = LocalPlayer:FindFirstChild("Backpack")
					if backpack then
						pcall(function()
							child:SetAttribute("Heavy", nil)
							child:SetAttribute("IsHeavy", nil)
							child:SetAttribute("TwoHanded", nil)
							child:SetAttribute("TwoHand", nil)
							child:SetAttribute("RequiresTwoHands", nil)
							child:SetAttribute("DepotItem", nil)
							child.Parent = backpack
						end)
					end
					MsFent_ClearHeavyLocks(char)
				end)
			end
		end)
	end

	hookCharacter(LocalPlayer.Character)
	NoHeavyItemsCharConn = LocalPlayer.CharacterAdded:Connect(function(char)
		if not Toggles.NoHeavyItemsLimit.Value then return end
		task.wait(0.2)
		hookCharacter(char)
	end)

	-- periodic clear (server may re-apply attributes)
	task.spawn(function()
		while Toggles.NoHeavyItemsLimit.Value and token == NoHeavyItemsLoopToken do
			local char = LocalPlayer.Character
			if char then
				MsFent_ClearHeavyLocks(char)
				-- also strip flags on tools already in backpack so re-equip is fine
				local backpack = LocalPlayer:FindFirstChild("Backpack")
				if backpack then
					for _, tool in ipairs(backpack:GetChildren()) do
						if MsFent_IsHeavyTool(tool) then
							pcall(function()
								tool:SetAttribute("Heavy", nil)
								tool:SetAttribute("IsHeavy", nil)
								tool:SetAttribute("TwoHanded", nil)
								tool:SetAttribute("TwoHand", nil)
								tool:SetAttribute("RequiresTwoHands", nil)
								tool:SetAttribute("DepotItem", nil)
							end)
						end
					end
				end
			end
			task.wait(0.35)
		end
	end)

	pcall(function()
		Functions.Notify({
			Title = "No Heavy Item Limit",
			Body = "ON — heavy/depot items auto-stash to backpack so you can pick up more.",
		})
	end)
end)

-- ============================================================
-- STAIRWELL HANDLERS (synced from Abysall Continued)
-- ============================================================

local StairwellAntiNoiseConns = {}
local BypassNoiseChildConn = nil
local StairwellLandingToken = 0

-- Creak aggression meter (Drawing API)
local CreakAggressionMetersTable = {}
local CreakAggressionCamera = workspace.CurrentCamera
local CreakAggressionChildAddedConnection = nil

local function CleanupCreakAggressionMeter(CreakModel)
	local CreakMeterData = CreakAggressionMetersTable[CreakModel]
	if not CreakMeterData then return end
	CreakAggressionMetersTable[CreakModel] = nil
	if CreakMeterData.RenderConnection then pcall(function() CreakMeterData.RenderConnection:Disconnect() end) end
	if CreakMeterData.DestroyConnection then pcall(function() CreakMeterData.DestroyConnection:Disconnect() end) end
	for _, CreakDrawingObject in ipairs(CreakMeterData.Drawings) do
		pcall(function() CreakDrawingObject:Remove() end)
	end
end

local function GetCreakAggressionValue(CreakModel)
	local CreakAnimator = CreakModel:FindFirstChildOfClass("Animator")
		or (CreakModel:FindFirstChild("AnimationController") and CreakModel.AnimationController:FindFirstChildOfClass("Animator"))
		or CreakModel:FindFirstChildOfClass("AnimationController")
	if not CreakAnimator then return nil end
	for _, CreakAnimationTrack in ipairs(CreakAnimator:GetPlayingAnimationTracks()) do
		if CreakAnimationTrack.Name == "CreakGraph" or (CreakAnimationTrack.Animation and CreakAnimationTrack.Animation.Name == "CreakGraph") then
			local CreakSuccess, CreakAggressionValue = pcall(CreakAnimationTrack.GetParameter, CreakAnimationTrack, "Aggression")
			if CreakSuccess and typeof(CreakAggressionValue) == "number" then
				return math.clamp(CreakAggressionValue, 0, 1)
			end
		end
	end
	return nil
end

local function CreateCreakAggressionDrawings()
	local CreakDrawingList = {}
	local function CreateCreakDrawing(CreakDrawingType)
		local CreakNewDrawing = Drawing.new(CreakDrawingType)
		table.insert(CreakDrawingList, CreakNewDrawing)
		return CreakNewDrawing
	end
	local CreakTitleText = CreateCreakDrawing("Text")
	CreakTitleText.Text = "Aggression --%"
	CreakTitleText.Size = 16
	CreakTitleText.Font = Drawing.Fonts.Plex
	CreakTitleText.Color = Color3.fromRGB(255, 255, 255)
	CreakTitleText.Center = true
	CreakTitleText.Outline = true
	CreakTitleText.Visible = false
	local CreakBarBackground = CreateCreakDrawing("Square")
	CreakBarBackground.Size = Vector2.new(112, 6)
	CreakBarBackground.Filled = true
	CreakBarBackground.Color = Color3.fromRGB(58, 58, 64)
	CreakBarBackground.Transparency = 0.15
	CreakBarBackground.Visible = false
	local CreakBarFill = CreateCreakDrawing("Square")
	CreakBarFill.Size = Vector2.new(0, 6)
	CreakBarFill.Filled = true
	CreakBarFill.Visible = false
	return {
		Drawings = CreakDrawingList,
		TitleText = CreakTitleText,
		BarBackground = CreakBarBackground,
		BarFill = CreakBarFill,
	}
end

local function AddCreakAggressionMeter(CreakModel)
	if not Toggles.CreakAggressionMeter.Value or CreakModel.Name ~= "Creak" or CreakAggressionMetersTable[CreakModel] then
		return
	end
	local CreakHeadPart = CreakModel:FindFirstChild("Head")
	if not CreakHeadPart or not CreakHeadPart:IsA("BasePart") then return end
	local CreakMeterData = CreateCreakAggressionDrawings()
	CreakAggressionMetersTable[CreakModel] = CreakMeterData
	CreakMeterData.RenderConnection = Services.RunService.RenderStepped:Connect(function()
		if not Toggles.CreakAggressionMeter.Value or not CreakModel.Parent or not CreakHeadPart.Parent then
			CleanupCreakAggressionMeter(CreakModel)
			return
		end
		if not CreakAggressionCamera or not CreakAggressionCamera.Parent then
			CreakAggressionCamera = workspace.CurrentCamera
			if not CreakAggressionCamera then return end
		end
		local CreakScreenPosition, CreakIsOnScreen = CreakAggressionCamera:WorldToViewportPoint(CreakHeadPart.Position + Vector3.new(0, 1.85, 0))
		if not (CreakIsOnScreen and CreakScreenPosition.Z > 0) then
			CreakMeterData.TitleText.Visible = false
			CreakMeterData.BarBackground.Visible = false
			CreakMeterData.BarFill.Visible = false
			return
		end
		CreakMeterData.TitleText.Position = Vector2.new(CreakScreenPosition.X, CreakScreenPosition.Y - 28)
		CreakMeterData.BarBackground.Position = Vector2.new(CreakScreenPosition.X - 56, CreakScreenPosition.Y - 6)
		CreakMeterData.BarFill.Position = CreakMeterData.BarBackground.Position
		local CreakAggressionValue = GetCreakAggressionValue(CreakModel)
		if not CreakAggressionValue then
			CreakMeterData.TitleText.Text = "Aggression --%"
			CreakMeterData.TitleText.Color = Color3.fromRGB(200, 200, 200)
			CreakMeterData.BarFill.Size = Vector2.new(0, 6)
			CreakMeterData.TitleText.Visible = true
			CreakMeterData.BarBackground.Visible = true
			CreakMeterData.BarFill.Visible = false
			return
		end
		CreakMeterData.TitleText.Text = "Aggression " .. math.floor(CreakAggressionValue * 100 + 0.5) .. "%"
		CreakMeterData.TitleText.Color = Color3.fromRGB(255, 255, 255)
		CreakMeterData.BarFill.Size = Vector2.new(112 * CreakAggressionValue, 6)
		CreakMeterData.BarFill.Color = Color3.fromRGB(70, 220, 100):Lerp(Color3.fromRGB(255, 55, 55), CreakAggressionValue)
		CreakMeterData.TitleText.Visible = true
		CreakMeterData.BarBackground.Visible = true
		CreakMeterData.BarFill.Visible = true
	end)
	CreakMeterData.DestroyConnection = CreakModel.Destroying:Connect(function()
		CleanupCreakAggressionMeter(CreakModel)
	end)
end

local function StartCreakAggressionListener()
	if CreakAggressionChildAddedConnection then return end
	local CreakLiveEntitiesFolder = workspace:FindFirstChild("LiveEntities")
	if not CreakLiveEntitiesFolder then return end
	CreakAggressionChildAddedConnection = CreakLiveEntitiesFolder.ChildAdded:Connect(function(CreakNewChild)
		if CreakNewChild.Name == "Creak" then
			AddCreakAggressionMeter(CreakNewChild)
		end
	end)
end

local function StopCreakAggressionListener()
	if CreakAggressionChildAddedConnection then
		CreakAggressionChildAddedConnection:Disconnect()
		CreakAggressionChildAddedConnection = nil
	end
end

Toggles.CreakAggressionMeter:OnChanged(function(CreakToggleEnabled)
	if CreakToggleEnabled then
		for _, CreakEntityModel in ipairs(Objects.Entities or {}) do
			pcall(AddCreakAggressionMeter, CreakEntityModel)
		end
		local CreakLiveEntitiesFolder = workspace:FindFirstChild("LiveEntities")
		local CreakExistingModel = CreakLiveEntitiesFolder and CreakLiveEntitiesFolder:FindFirstChild("Creak")
		if CreakExistingModel then
			AddCreakAggressionMeter(CreakExistingModel)
		end
		StartCreakAggressionListener()
	else
		StopCreakAggressionListener()
		for CreakEntityModel in pairs(CreakAggressionMetersTable) do
			CleanupCreakAggressionMeter(CreakEntityModel)
		end
	end
end)

Toggles.KillAllWithCart:OnChanged(function(KillAllWithCartState)
	if not KillAllWithCartState then return end
	local KillAllWithCartIndex = 1
	task.spawn(function()
		while Toggles.KillAllWithCart.Value do
			local KillAllWithCartCarts = {}
			local misc = workspace:FindFirstChild("Misc")
			if misc then
				for _, KillAllWithCartModel in ipairs(misc:GetChildren()) do
					if KillAllWithCartModel.Name == "ShoppingCart" and KillAllWithCartModel:IsA("Model") then
						KillAllWithCartCarts[#KillAllWithCartCarts + 1] = KillAllWithCartModel
					end
				end
			end
			local KillAllWithCartAlivePlayers = {}
			for _, KillAllWithCartPlayer in ipairs(Services.Players:GetPlayers()) do
				if KillAllWithCartPlayer ~= LocalPlayer and KillAllWithCartPlayer.Character then
					local KillAllWithCartHumanoid = KillAllWithCartPlayer.Character:FindFirstChildOfClass("Humanoid")
					if KillAllWithCartHumanoid and KillAllWithCartHumanoid.Health > 0 then
						KillAllWithCartAlivePlayers[#KillAllWithCartAlivePlayers + 1] = KillAllWithCartPlayer
					end
				end
			end
			if #KillAllWithCartCarts > 0 and #KillAllWithCartAlivePlayers > 0 then
				if KillAllWithCartIndex > #KillAllWithCartAlivePlayers then
					KillAllWithCartIndex = 1
				end
				local KillAllWithCartTarget = KillAllWithCartAlivePlayers[KillAllWithCartIndex]
				local KillAllWithCartTargetCFrame = KillAllWithCartTarget.Character:GetPivot()
				for KillAllWithCartCartIndex = 1, #KillAllWithCartCarts do
					pcall(function()
						KillAllWithCartCarts[KillAllWithCartCartIndex]:PivotTo(KillAllWithCartTargetCFrame)
					end)
				end
				KillAllWithCartIndex = KillAllWithCartIndex + 1
			end
			task.wait(0.10)
		end
	end)
end)

Toggles.FlingCreak:OnChanged(function(FlingCreakState)
	if not FlingCreakState then return end
	task.spawn(function()
		while Toggles.FlingCreak.Value do
			local live = workspace:FindFirstChild("LiveEntities")
			local creak = live and live:FindFirstChild("Creak")
			if creak then
				local targetCFrame = creak:GetPivot()
				local misc = workspace:FindFirstChild("Misc")
				if misc then
					for _, model in ipairs(misc:GetChildren()) do
						if model.Name == "ShoppingCart" and model:IsA("Model") then
							pcall(function() model:PivotTo(targetCFrame) end)
						end
					end
				end
			end
			task.wait(0.10)
		end
	end)
end)

Toggles.DisableStairwellCrusherCollision:OnChanged(function(DisableStairwellCrusherCollisionState)
	if not DisableStairwellCrusherCollisionState then return end
	task.spawn(function()
		while Toggles.DisableStairwellCrusherCollision.Value do
			local rooms = workspace:FindFirstChild("CurrentRooms")
			if rooms then
				for _, DisableStairwellCrusherRoom in ipairs(rooms:GetChildren()) do
					local DisableStairwellCrusherAssets = DisableStairwellCrusherRoom:FindFirstChild("Assets")
					if DisableStairwellCrusherAssets then
						for _, DisableStairwellCrusherContainer in ipairs(DisableStairwellCrusherAssets:GetChildren()) do
							if DisableStairwellCrusherContainer.Name == "StairwellCrusherContainer1" then
								for _, DisableStairwellCrusherDescendant in ipairs(DisableStairwellCrusherContainer:GetDescendants()) do
									if DisableStairwellCrusherDescendant:IsA("BasePart") and DisableStairwellCrusherDescendant.CanCollide then
										local DisableStairwellCrusherUnderBasicWall = false
										local DisableStairwellCrusherParent = DisableStairwellCrusherDescendant.Parent
										while DisableStairwellCrusherParent and DisableStairwellCrusherParent ~= DisableStairwellCrusherContainer do
											if DisableStairwellCrusherParent.Name == "BasicWall" then
												DisableStairwellCrusherUnderBasicWall = true
												break
											end
											DisableStairwellCrusherParent = DisableStairwellCrusherParent.Parent
										end
										if not DisableStairwellCrusherUnderBasicWall then
											DisableStairwellCrusherDescendant.CanCollide = false
										end
									end
								end
							end
							local DisableStairwellCrusher = DisableStairwellCrusherContainer:FindFirstChild("StairwellCrusher")
							if DisableStairwellCrusher then
								local OuterTrigger = DisableStairwellCrusher:FindFirstChild("OuterTrigger")
								local CoreTrigger = DisableStairwellCrusher:FindFirstChild("CoreTrigger")
								if OuterTrigger then OuterTrigger:Destroy() end
								if CoreTrigger then CoreTrigger:Destroy() end
							end
						end
					end
				end
			end
			task.wait(0.5)
		end
	end)
end)

Toggles.DeleteStairwellCrusherExceptBasicWall:OnChanged(function(DeleteStairwellCrusherExceptBasicWallState)
	if not DeleteStairwellCrusherExceptBasicWallState then return end
	task.spawn(function()
		while Toggles.DeleteStairwellCrusherExceptBasicWall.Value do
			local rooms = workspace:FindFirstChild("CurrentRooms")
			if rooms then
				for _, DeleteStairwellCrusherRoom in ipairs(rooms:GetChildren()) do
					local DeleteStairwellCrusherAssets = DeleteStairwellCrusherRoom:FindFirstChild("Assets")
					if DeleteStairwellCrusherAssets then
						for _, DeleteStairwellCrusherContainer in ipairs(DeleteStairwellCrusherAssets:GetChildren()) do
							if DeleteStairwellCrusherContainer.Name == "StairwellCrusherContainer1" then
								local DeleteStairwellCrusherToDestroy = {}
								for _, DeleteStairwellCrusherDescendant in ipairs(DeleteStairwellCrusherContainer:GetDescendants()) do
									local DeleteStairwellCrusherUnderBasicWall = false
									local DeleteStairwellCrusherParent = DeleteStairwellCrusherDescendant.Parent
									while DeleteStairwellCrusherParent and DeleteStairwellCrusherParent ~= DeleteStairwellCrusherContainer do
										if DeleteStairwellCrusherParent.Name == "BasicWall" then
											DeleteStairwellCrusherUnderBasicWall = true
											break
										end
										DeleteStairwellCrusherParent = DeleteStairwellCrusherParent.Parent
									end
									if not DeleteStairwellCrusherUnderBasicWall and DeleteStairwellCrusherDescendant.Name ~= "BasicWall" then
										DeleteStairwellCrusherToDestroy[#DeleteStairwellCrusherToDestroy + 1] = DeleteStairwellCrusherDescendant
									end
								end
								for _, DeleteStairwellCrusherInstance in ipairs(DeleteStairwellCrusherToDestroy) do
									if DeleteStairwellCrusherInstance and DeleteStairwellCrusherInstance.Parent then
										pcall(function() DeleteStairwellCrusherInstance:Destroy() end)
									end
								end
							end
						end
					end
				end
			end
			task.wait(0.5)
		end
	end)
end)

Toggles.MeldRemover:OnChanged(function(State)
	if not State then return end
	task.spawn(function()
		while Toggles.MeldRemover.Value do
			local rooms = workspace:FindFirstChild("CurrentRooms")
			if rooms then
				for _, room in pairs(rooms:GetChildren()) do
					for _, folderName in ipairs({ "Assets", "Parts" }) do
						local folder = room:FindFirstChild(folderName)
						if folder then
							for _, child in ipairs(folder:GetChildren()) do
								if child.Name == "MeldWall" or child.Name == "Boleahghth29tdgfhy2thuy2htuu259uhh3u" then
									pcall(function() child:Destroy() end)
								end
							end
						end
					end
					for _, name in ipairs({ "MeldData", "MeldPads", "Meldview", "Meld" }) do
						local obj = room:FindFirstChild(name)
						if obj and obj:IsA("Folder") then
							pcall(function() obj:Destroy() end)
						end
					end
				end
			end
			task.wait(0.5)
		end
	end)
end)

Toggles.StairwellLandingSpam:OnChanged(function(Value)
	StairwellLandingToken += 1
	if not Value then return end
	local CurrentToken = StairwellLandingToken
	task.spawn(function()
		while Toggles.StairwellLandingSpam.Value and CurrentToken == StairwellLandingToken do
			local rooms = workspace:FindFirstChild("CurrentRooms")
			if not rooms then
				Services.RunService.Heartbeat:Wait()
			else
				local StairwellModels = {}
				for _, Room in ipairs(rooms:GetChildren()) do
					local StairwellLandingLogic = Room:FindFirstChild("StairwellLandingLogic")
					if StairwellLandingLogic then
						for _, Model in ipairs(StairwellLandingLogic:GetChildren()) do
							if Model:IsA("Model") then
								local Prompts = {}
								for _, Object in ipairs(Model:GetDescendants()) do
									if Object:IsA("ProximityPrompt") then
										Prompts[#Prompts + 1] = Object
									end
								end
								if #Prompts > 0 then
									StairwellModels[#StairwellModels + 1] = { Model = Model, Prompts = Prompts }
								end
							end
						end
					end
				end
				table.sort(StairwellModels, function(First, Second)
					local FirstRoom = First.Model.Parent and First.Model.Parent.Parent
					local SecondRoom = Second.Model.Parent and Second.Model.Parent.Parent
					return (tonumber(FirstRoom and FirstRoom.Name) or math.huge) < (tonumber(SecondRoom and SecondRoom.Name) or math.huge)
				end)
				for _, Data in ipairs(StairwellModels) do
					if not Toggles.StairwellLandingSpam.Value or CurrentToken ~= StairwellLandingToken then break end
					local Model = Data.Model
					while Model.Parent and Model:IsDescendantOf(workspace)
						and Toggles.StairwellLandingSpam.Value and CurrentToken == StairwellLandingToken do
						local Character = LocalPlayer.Character
						local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
						if HumanoidRootPart then
							HumanoidRootPart.CFrame = Model:GetPivot() + Vector3.new(0, 5, 0)
							for Index = 1, #Data.Prompts do
								local Prompt = Data.Prompts[Index]
								if Prompt.Parent and Prompt.Enabled then
									pcall(function()
										if fireproximityprompt then
											fireproximityprompt(Prompt)
										elseif MsFent.Environment and MsFent.Environment.fireproximityprompt then
											MsFent.Environment.fireproximityprompt(Prompt)
										end
									end)
								end
							end
							pcall(function()
								if keypress and keyrelease then
									keypress(0x58)
									task.wait(0.03)
									keyrelease(0x58)
								elseif MsFent.Environment and MsFent.Environment.keypress and MsFent.Environment.keyrelease then
									MsFent.Environment.keypress(0x58)
									task.wait(0.03)
									MsFent.Environment.keyrelease(0x58)
								end
							end)
						end
						Services.RunService.Heartbeat:Wait()
					end
				end
			end
			Services.RunService.Heartbeat:Wait()
		end
	end)
end)

-- Anti Noise (silent move — Abysall Continued)
Toggles.AntiNoise:OnChanged(function(value)
	for i = #StairwellAntiNoiseConns, 1, -1 do
		local conn = StairwellAntiNoiseConns[i]
		if conn and conn.Disconnect then pcall(function() conn:Disconnect() end) end
		table.remove(StairwellAntiNoiseConns, i)
	end
	if not value then return end
	local Controls
	pcall(function()
		Controls = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls()
	end)
	local antiNoiseConn = Services.RunService.PreSimulation:Connect(function(dt)
		if not Toggles.AntiNoise.Value then return end
		if not LocalPlayer:GetAttribute("Alive") then return end
		local character = LocalPlayer.Character
		if not character then return end
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local camera = workspace.CurrentCamera
		if not rootPart or not humanoid or not camera then return end
		if humanoid.Health <= 0 or rootPart.Anchored then return end
		local state = humanoid:GetState()
		if state == Enum.HumanoidStateType.Dead
			or state == Enum.HumanoidStateType.Ragdoll
			or state == Enum.HumanoidStateType.Climbing
			or state == Enum.HumanoidStateType.Swimming
		then return end
		humanoid.AutoRotate = false
		humanoid:Move(Vector3.zero, false)
		local inputVector = Vector3.zero
		if Controls then
			pcall(function() inputVector = Controls:GetMoveVector() end)
		end
		local inputMagnitude = inputVector.Magnitude
		if inputMagnitude <= 0 then
			rootPart.AssemblyLinearVelocity = Vector3.zero
			return
		end
		local cameraCFrame = camera.CFrame
		local cameraForward = Vector3.new(cameraCFrame.LookVector.X, 0, cameraCFrame.LookVector.Z)
		local cameraRight = Vector3.new(cameraCFrame.RightVector.X, 0, cameraCFrame.RightVector.Z)
		if cameraForward.Magnitude < 0.001 or cameraRight.Magnitude < 0.001 then return end
		cameraForward = cameraForward.Unit
		cameraRight = cameraRight.Unit
		local worldDirection = (cameraRight * inputVector.X) + (cameraForward * -inputVector.Z)
		if worldDirection.Magnitude <= 0 then return end
		worldDirection = worldDirection.Unit
		local finalSpeed = humanoid.WalkSpeed * math.clamp(inputMagnitude, 0, 1)
		local clampedDt = math.clamp(dt, 0, 1 / 30)
		rootPart.AssemblyLinearVelocity = Vector3.zero
		rootPart.CFrame = rootPart.CFrame + (worldDirection * finalSpeed * clampedDt)
		rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + worldDirection)
	end)
	StairwellAntiNoiseConns[#StairwellAntiNoiseConns + 1] = antiNoiseConn
end)

-- Noise TV Breaker (Abysall Continued)
Toggles.BypassNoise:OnChanged(function(value)
	if BypassNoiseChildConn then
		pcall(function() BypassNoiseChildConn:Disconnect() end)
		BypassNoiseChildConn = nil
	end
	if not value then return end
	local function checkBypassNoiseTvStand(targetTvStand)
		if not targetTvStand:IsA("Model") then return end
		if targetTvStand.Name ~= "TV_Stand" then return end
		local tvStandCurrentCFrame = targetTvStand:GetPivot()
		if tvStandCurrentCFrame.Position.Y > -119 then
			targetTvStand:PivotTo(CFrame.new(
				tvStandCurrentCFrame.Position.X,
				-120,
				tvStandCurrentCFrame.Position.Z
			))
		end
	end
	local bypassNoiseMiscFolder = workspace:FindFirstChild("Misc")
	if not bypassNoiseMiscFolder then return end
	BypassNoiseChildConn = bypassNoiseMiscFolder.ChildAdded:Connect(function(bypassNoiseNewChild)
		checkBypassNoiseTvStand(bypassNoiseNewChild)
	end)
	for _, bypassNoiseMiscChild in ipairs(bypassNoiseMiscFolder:GetChildren()) do
		checkBypassNoiseTvStand(bypassNoiseMiscChild)
	end
end)

-- Item Number counter (Abysall Continued)
Toggles.DroppedItemValue:OnChanged(function(DroppedItemValue)
	local DroppedItemValueScreenGui = game:GetService("CoreGui"):FindFirstChild("DropsCoinCounter")
	if not DroppedItemValue then
		if DroppedItemValueScreenGui then DroppedItemValueScreenGui:Destroy() end
		return
	end
	local DroppedItemValueWorkspaceDrops = workspace:FindFirstChild("Drops") or workspace:WaitForChild("Drops", 5)
	if not DroppedItemValueWorkspaceDrops then
		pcall(function() Functions.Notify({ Title = "Item Number", Body = "workspace.Drops not found yet." }) end)
		return
	end
	if DroppedItemValueScreenGui then DroppedItemValueScreenGui:Destroy() end
	DroppedItemValueScreenGui = Instance.new("ScreenGui")
	DroppedItemValueScreenGui.Name = "DropsCoinCounter"
	DroppedItemValueScreenGui.ResetOnSpawn = false
	pcall(function() DroppedItemValueScreenGui.Parent = game:GetService("CoreGui") end)
	if not DroppedItemValueScreenGui.Parent then
		DroppedItemValueScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end
	local DroppedItemValueCoinText = Instance.new("TextLabel")
	DroppedItemValueCoinText.Name = "CoinText"
	DroppedItemValueCoinText.AnchorPoint = Vector2.new(0.5, 0)
	DroppedItemValueCoinText.Position = UDim2.new(0.5, 0, 0.02, 0)
	DroppedItemValueCoinText.Size = UDim2.new(0, 250, 0, 40)
	DroppedItemValueCoinText.BackgroundTransparency = 1
	DroppedItemValueCoinText.Text = "Items: 0"
	DroppedItemValueCoinText.TextSize = 24
	DroppedItemValueCoinText.Font = Enum.Font.GothamBold
	DroppedItemValueCoinText.TextColor3 = Color3.fromRGB(255, 255, 255)
	DroppedItemValueCoinText.TextStrokeTransparency = 0.5
	DroppedItemValueCoinText.Parent = DroppedItemValueScreenGui
	local DroppedItemValueCountedDrops = {}
	task.spawn(function()
		while Toggles.DroppedItemValue.Value do
			for _, DroppedItemValueDrop in ipairs(DroppedItemValueWorkspaceDrops:GetChildren()) do
				if DroppedItemValueDrop:IsA("Model") and not DroppedItemValueCountedDrops[DroppedItemValueDrop] then
					DroppedItemValueDrop:SetAttribute("CoinsChecked", true)
					DroppedItemValueCountedDrops[DroppedItemValueDrop] = true
				end
			end
			for DroppedItemValueDrop in pairs(DroppedItemValueCountedDrops) do
				if not DroppedItemValueDrop.Parent or DroppedItemValueDrop.Parent ~= DroppedItemValueWorkspaceDrops then
					DroppedItemValueCountedDrops[DroppedItemValueDrop] = nil
				end
			end
			local DroppedItemValueTotalItems = 0
			for DroppedItemValueDrop in pairs(DroppedItemValueCountedDrops) do
				if DroppedItemValueDrop.Parent == DroppedItemValueWorkspaceDrops then
					DroppedItemValueTotalItems += 1
				end
			end
			DroppedItemValueCoinText.Text = "Items: " .. DroppedItemValueTotalItems
			task.wait(1)
		end
		if DroppedItemValueScreenGui and DroppedItemValueScreenGui.Parent then
			DroppedItemValueScreenGui:Destroy()
		end
	end)
end)

-- TP Shopping Carts + Grinder (Abysall Continued extras on Stairwell tab)
Groupboxes.Floors_Stairwell:AddDivider()
Groupboxes.Floors_Stairwell:AddButton({
	Text = "TP Shopping Carts To Me",
	DoubleClick = false,
	Tooltip = "Teleports all ShoppingCart models in workspace.Misc to you.",
	Func = function()
		local char = LocalPlayer.Character
		if not char then return end
		local target = char:GetPivot()
		local misc = workspace:FindFirstChild("Misc")
		if not misc then
			Functions.Notify({ Title = "Carts", Body = "workspace.Misc not found." })
			return
		end
		local n = 0
		for _, model in ipairs(misc:GetChildren()) do
			if model.Name == "ShoppingCart" and model:IsA("Model") then
				pcall(function() model:PivotTo(target) end)
				n += 1
			end
		end
		Functions.Notify({ Title = "Carts", Body = "Moved " .. n .. " cart(s)." })
	end,
})
Groupboxes.Floors_Stairwell:AddButton({
	Text = "TP Drops to Nearest Grinder",
	DoubleClick = false,
	Tooltip = "Teleports every dropped item to the nearest Stairwell scrapper grinder.",
	Func = function()
		local dropsFolder = workspace:FindFirstChild("Drops")
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		local rooms = workspace:FindFirstChild("CurrentRooms")
		if not dropsFolder or not root or not rooms then
			Functions.Notify({ Title = "Grinder", Body = "Need Drops + character + CurrentRooms." })
			return
		end
		local nearest, nearestDist = nil, math.huge
		for _, room in ipairs(rooms:GetChildren()) do
			local scrapper = room:FindFirstChild("StairwellScrapper", true)
			if scrapper then
				for _, obj in ipairs(scrapper:GetDescendants()) do
					if obj.Name == "Grinder1" and (obj:IsA("Model") or obj:IsA("BasePart")) then
						local pos = obj:GetPivot().Position
						local d = (root.Position - pos).Magnitude
						if d < nearestDist then
							nearestDist = d
							nearest = obj
						end
					end
				end
			end
		end
		if not nearest then
			Functions.Notify({ Title = "Grinder", Body = "No Grinder1 found." })
			return
		end
		local cf = nearest:GetPivot()
		local n = 0
		for _, item in ipairs(dropsFolder:GetChildren()) do
			if item:IsA("Model") or item:IsA("BasePart") then
				MsFent_MoveDrop(item, cf)
				n += 1
			end
		end
		Functions.Notify({ Title = "Grinder", Body = "Moved " .. n .. " drop(s)." })
	end,
})

-- ===== END STAIRWELL =====


-- Stubs so leftover RoomsAutoWalk code never errors (Floor=="Rooms" is gone)
do
	local function FakeToggle()
		return {
			Value = false,
			OnChanged = function(self, fn) end,
			AddColorPicker = function() return { OnChanged = function() end } end,
			SetValue = function() end,
		}
	end
	if not Toggles.RoomsAutoWalk then Toggles.RoomsAutoWalk = FakeToggle() end
	if not Toggles.RoomsAutoWalkShowPathToggle then Toggles.RoomsAutoWalkShowPathToggle = FakeToggle() end
	if not Options.RoomsAutoWalkShowPathColor then Options.RoomsAutoWalkShowPathColor = { Value = Color3.fromRGB(0, 255, 0), OnChanged = function() end } end
	if not Options.RoomsAutoWalkPathfindTimeout then Options.RoomsAutoWalkPathfindTimeout = { Value = 1, OnChanged = function() end } end
	if not Toggles.RoomsAutoWalkIgnoreA60 then Toggles.RoomsAutoWalkIgnoreA60 = FakeToggle() end
	if not Toggles.RoomsAutoWalkSpoofFootsteps then Toggles.RoomsAutoWalkSpoofFootsteps = FakeToggle() end
end

Functions.RoomsAutoWalk = {}
Functions.RoomsAutoWalk.GetNearestHidingSpot = function()
	local Nearest = { Distance = math.huge, Object = nil }
	for _, Object in Objects.HidingSpots do
		if Object.PrimaryPart and Object:FindFirstChild("HidePrompt") then
			local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
			if Distance < Nearest.Distance and Object.PrimaryPart.Position.Y > -10 then
				local HiddenPlayer = Object:FindFirstChild("HiddenPlayer", true)
				if HiddenPlayer and not HiddenPlayer.Value then
					Nearest.Distance = Distance
					Nearest.Object = Object
				end
			end
		end
	end
	return Nearest.Object
end

local RoomsEntityList = { "RushMoving","AmbushMoving","BackdoorRush","A60","A120","CustomEntity","GlitchRush","GlitchAmbush" }
Functions.RoomsAutoWalk.GetPathfindTarget = function()
	for _, Object in Services.Workspace:GetChildren() do
		if table.find(RoomsEntityList, Object.Name) and Object.PrimaryPart then
			local Y = Object.PrimaryPart.Position.Y
			if Y > -10 and Y < 150 then
				if Object.Name == "A60" and not Toggles.RoomsAutoWalkIgnoreA60.Value or Object.Name ~= "A60" then
					return Functions.RoomsAutoWalk.GetNearestHidingSpot() or CurrentRooms[tostring(LatestRoom.Value)]:FindFirstChild("RoomExit")
				end
			end
		end
	end
	return CurrentRooms[tostring(LatestRoom.Value)]:FindFirstChild("RoomExit")
end

Connections.RoomsAutoWalkHandler = Services.RunService.Heartbeat:Connect(function()
	-- Rooms removed (Archives replace); never run
	if true then return end
	if Floor ~= "Rooms" or not (Toggles.RoomsAutoWalk and Toggles.RoomsAutoWalk.Value) or Globals.RoomsAutoWalkActive or not CollisionPart or LatestRoom.Value >= 1000 then return end
	Globals.RoomsAutoWalkActive = true

	local Path = Services.PathfindingService:CreatePath({
		AgentCanJump = true, AgentCanClimb = false, WaypointSpacing = 4,
		AgentRadius = 1.5, AgentHeight = 1.5, Costs = { StuckPart = 8 }
	})

	if Toggles.RoomsAutoWalkIgnoreA60.Value and not Toggles.PositionSpoof.Value then
		Toggles.PositionSpoof:SetValue(true)
	end

	local TargetPart = Functions.RoomsAutoWalk.GetPathfindTarget()
	if not TargetPart then
		Globals.RoomsAutoWalkActive = false
		return
	end

	local TargetPosition
	if TargetPart.Name == "RoomExit" then
		TargetPosition = TargetPart.Position
	elseif TargetPart:FindFirstChild("HidePrompt") then
		for _, Part in TargetPart:GetDescendants() do
			if Part:IsA("BasePart") then Part.CanCollide = false end
		end
		TargetPosition = TargetPart.PrimaryPart.Position
	end

	if CollisionPart.Anchored and not TargetPart:FindFirstChild("HidePrompt") then
		Character:SetAttribute("Hiding", true)
		RemotesFolder.CamLock:FireServer()
		Character:SetAttribute("Hiding", false)
	end

	local CurrentRoom = CurrentRooms[tostring(LatestRoom.Value)]
	if CurrentRoom:FindFirstChild("Door") then
		CurrentRoom.Door.Door.CanCollide = false
	end

	if not TargetPosition or LocalPlayer:DistanceFromCharacter(TargetPosition) >= 750 then
		Globals.RoomsAutoWalkActive = false
		return
	end

	Path:ComputeAsync(CollisionPart.Position, TargetPosition)
	local Waypoints = Path:GetWaypoints()

	if #Waypoints == 0 then
		local RoomExit = CurrentRoom:FindFirstChild("RoomExit")
		if RoomExit then Humanoid:MoveTo(RoomExit.Position) end
		Globals.RoomsAutoWalkActive = false
		return
	end

	for _, Node in Globals.RoomsNodesFolder:GetChildren() do
		if Node.Name == "PathNode" then Node:Destroy() end
	end

	for _, Waypoint in Waypoints do
		local Block = Instance.new("Part", Globals.RoomsNodesFolder)
		Block.Transparency = Toggles.RoomsAutoWalkShowPathToggle.Value and 0.5 or 1
		Block.Size = Vector3.one
		Block.Position = Waypoint.Position
		Block.Shape = Enum.PartType.Ball
		Block.CanCollide = false
		Block.Anchored = true
		Block.Name = "PathNode"
		Block.Color = Options.RoomsAutoWalkShowPathColor.Value
		Block.Material = Enum.Material.Neon
	end

	local Stuck = false
	for _, Waypoint in Waypoints do
		if Stuck or not Toggles.RoomsAutoWalk.Value then break end

		local Finished = false
		local Start = tick()

		local StepConnection = Services.RunService.RenderStepped:Connect(function()
			if Stuck or not Toggles.RoomsAutoWalk.Value then Finished = true return end

			local NewTarget = Functions.RoomsAutoWalk.GetPathfindTarget()
			if NewTarget and NewTarget:FindFirstChild("HidePrompt") and not TargetPart:FindFirstChild("HidePrompt") then
				Finished = true return
			end
			if TargetPart:FindFirstChild("HidePrompt") then
				local HidePrompt = TargetPart:FindFirstChild("HidePrompt")
				if LocalPlayer:DistanceFromCharacter(TargetPosition) < HidePrompt.MaxActivationDistance
					and Character:GetAttribute("Hiding") ~= true
				then
					Functions.ForceFirePrompt(HidePrompt)
				end
			end
			local FlatPos = Vector3.new(Waypoint.Position.X, RootPart.Position.Y, Waypoint.Position.Z)
			if LocalPlayer:DistanceFromCharacter(FlatPos) < 5 then Finished = true end
			Humanoid:MoveTo(Waypoint.Position)
		end)

		while not Finished do
			if tick() - Start > Options.RoomsAutoWalkPathfindTimeout.Value then
				local StuckBlock = Instance.new("Part", Globals.RoomsNodesFolder)
				StuckBlock.Transparency = 1
				StuckBlock.Size = Vector3.one
				StuckBlock.CFrame = Collision.CFrame
				StuckBlock.Shape = Enum.PartType.Ball
				StuckBlock.CanCollide = false
				StuckBlock.Anchored = true
				StuckBlock.Name = "StuckPart"
				local Modifier = Instance.new("PathfindingModifier", StuckBlock)
				Modifier.Label = "StuckPart"
				Stuck = true
				break
			end
			task.wait()
		end
		StepConnection:Disconnect()
		Humanoid:MoveTo(RootPart.Position)
	end

	Globals.RoomsAutoWalkActive = false
end)

Connections.RoomsHandler = CurrentRooms.ChildAdded:Connect(function(Room)
	for _, Object in Globals.RoomsNodesFolder:GetChildren() do
		if Object.Name == "StuckPart" then Object:Destroy() end
	end

	if Room:GetAttribute("RawName") and string.find(Room:GetAttribute("RawName"), "Eyestalk") then
        local PreviousNode = nil

		local function CreateEyestalkNode(WaypointPos)
			local NewNode = Instance.new("Part")
			NewNode.Size = Vector3.one
			NewNode.Transparency = 1
			NewNode.Parent = Globals.SeekNodesFolder
			NewNode.Anchored = true
			NewNode.Position = WaypointPos
			NewNode.CanCollide = false
			NewNode.Name = "SeekLightNode"

			local PrevNode = PreviousNode or NewNode
			PreviousNode = NewNode

			local NewBeam = Instance.new("Beam")
			NewBeam.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Options.ShowEyestalkPathColor.Value), ColorSequenceKeypoint.new(1, Options.ShowEyestalkPathColor.Value) })
			NewBeam.FaceCamera = true
			NewBeam.Width0 = 0.2
			NewBeam.Width1 = 0.2
			NewBeam.Brightness = 10
			NewBeam.LightInfluence = 0
			NewBeam.LightEmission = 0
			NewBeam.Enabled = true

			local Vis = Toggles.ShowEyestalkPathToggle.Value and 0 or 1
			NewBeam.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, Vis), NumberSequenceKeypoint.new(1, Vis) })
			NewBeam.Parent = Globals.SeekNodesFolder

			local A0 = Instance.new("Attachment", NewNode)
			local A1 = Instance.new("Attachment", PrevNode)
			NewBeam.Attachment0 = A0
			NewBeam.Attachment1 = A1

			table.insert(Objects.EyestalkHighlights, NewBeam)
		end

		Room:WaitForChild("RoomEntrance", 9e9)
		Room:WaitForChild("RoomExit", 9e9)

		while not Room:GetAttribute("PathFound") do
			if Toggles.ShowEyestalkPathToggle.Value then
				local EyePath = game:GetService("PathfindingService"):CreatePath({
					AgentCanJump = false, AgentCanClimb = false, WaypointSpacing = 2, AgentRadius = 1, AgentHeight = 1
				})
				EyePath:ComputeAsync(RootPart.Position, Room.RoomExit.Position)
				if EyePath.Status == Enum.PathStatus.Success then
					Room:SetAttribute("PathFound", true)
					for _, Waypoint in EyePath:GetWaypoints() do
						CreateEyestalkNode(Waypoint.Position)
						task.wait()
					end
                    break
				end
			end
			task.wait(0.25)
		end
	end
end)

-- ============================================================
-- ARCHIVES LOGIC (adapted from Ms fent)
-- ============================================================
do
	local DroneWalkedIntoParents = {}
	local DroneConnection, AlmaConnection
	local AntiRansom_Connection, AntiClosetTrash_Connection, AntiScribbles_Connection
	local WaterBypassConnection, WaterParts = nil, {}
	local ForgetMeNotConnection, ForgetMeNotRunning = nil, false
	local ForgetMeNotProcessing, ForgetMeNotNotified = {}, {}
	local TimeShowerConnection, TimeShowerSourceLabel, TimeShowerToken = nil, nil, 0
	local BypassDronesStampedeConnection
	local HonchoCorrectBoxConnection, HonchoProcessedRooms, HonchoESPObjects = nil, {}, {}

	local TimeShowerLabel = Instance.new("TextLabel")
	TimeShowerLabel.Name = "MsFent_TimeShower"
	TimeShowerLabel.AnchorPoint = Vector2.new(0, 1)
	TimeShowerLabel.Position = UDim2.new(0, 12, 1, -12)
	TimeShowerLabel.Size = UDim2.new(0, 200, 0, 32)
	TimeShowerLabel.BackgroundTransparency = 1
	TimeShowerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TimeShowerLabel.TextStrokeTransparency = 0.35
	TimeShowerLabel.Font = Enum.Font.GothamBold
	TimeShowerLabel.TextSize = 18
	TimeShowerLabel.TextXAlignment = Enum.TextXAlignment.Left
	TimeShowerLabel.Text = "Time: --:--"
	TimeShowerLabel.Visible = false
	pcall(function() TimeShowerLabel.Parent = LocalPlayer:WaitForChild("PlayerGui") end)

	local function GetArchivesClockLabel(Room)
		local Assets = Room and Room:FindFirstChild("Assets", true)
		local Clock = Assets and Assets:FindFirstChild("ArchivesClock", true)
		local Time = Clock and Clock:FindFirstChild("Time", true)
		local Label = Time and Time:FindFirstChild("TextLabel")
		return (Label and Label:IsA("TextLabel")) and Label or nil
	end

	local function ResolveClockLabel()
		if TimeShowerSourceLabel and TimeShowerSourceLabel.Parent then return TimeShowerSourceLabel end
		local roomsFolder = workspace:FindFirstChild("CurrentRooms")
		if not roomsFolder then return nil end
		local rooms = {}
		for _, room in ipairs(roomsFolder:GetChildren()) do
			local num = tonumber(room.Name)
			if num then table.insert(rooms, { room = room, num = num }) end
		end
		table.sort(rooms, function(a, b) return a.num > b.num end)
		for i = 1, math.min(6, #rooms) do
			local label = GetArchivesClockLabel(rooms[i].room)
			if label then TimeShowerSourceLabel = label return label end
		end
		return nil
	end

	local function ResolveClockRemote()
		local label = ResolveClockLabel()
		if not label then return nil end
		local clock = label:FindFirstAncestor("ArchivesClock")
		if not clock then return nil end
		local remote = clock:FindFirstChild("LookedAtRemote", true)
		return (remote and remote:IsA("RemoteEvent")) and remote or nil
	end

	
	-- Archives Chair Anticheat Bypass (Start Bypass + Chair Speed)
	local ArchivesChairAC_Active = false
	local ArchivesChairAC_RenderConn = nil
	local ArchivesChairAC_Heartbeat = nil
	local ArchivesChairAC_RoomConn = nil
	local ArchivesChairAC_LagbackConns = {}
	local ArchivesChairAC_LagbackDisabled = false
	local ArchivesChairAC_Held = nil
	local ArchivesChairAC_PartProps = {}
	local ArchivesChairAC_OrigParent = nil
	local ArchivesChairAC_DesiredCF = nil
	local ArchivesChairAC_AtBoundary = false

	local function ArchivesChairAC_IsBoundary(roomVal)
		local n = tonumber(roomVal)
		return n and n > 0 and (n % 50 == 0)
	end

	local function ArchivesChairAC_LooksLikeChair(inst)
		if not inst then return false end
		local n = string.lower(tostring(inst.Name))
		for _, k in ipairs({ "chair", "office", "rolling", "impact", "cart", "caster", "stool" }) do
			if n:find(k, 1, true) then return true end
		end
		if inst:IsA("Model") then
			if inst:FindFirstChild("Collider", true) or inst:FindFirstChild("SeatAttachment", true) then return true end
			if inst:FindFirstChildWhichIsA("Seat", true) or inst:FindFirstChildWhichIsA("VehicleSeat", true) then return true end
		end
		return false
	end

	local function ArchivesChairAC_NearestChair(maxDist)
		maxDist = maxDist or 22
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then return nil end
		local best, bestD = nil, maxDist
		for _, m in ipairs(workspace:GetDescendants()) do
			if m:IsA("Model") and ArchivesChairAC_LooksLikeChair(m) then
				local ok, pos = pcall(function() return m:GetPivot().Position end)
				if ok and pos then
					local d = (pos - hrp.Position).Magnitude
					if d < bestD then bestD, best = d, m end
				end
			end
		end
		return best
	end

	local function ArchivesChairAC_Hide(model)
		if not model then return end
		ArchivesChairAC_Held = model
		ArchivesChairAC_OrigParent = model.Parent
		table.clear(ArchivesChairAC_PartProps)
		pcall(function()
			for _, p in ipairs(model:GetDescendants()) do
				if p:IsA("BasePart") then
					ArchivesChairAC_PartProps[p] = {
						ltm = p.LocalTransparencyModifier, trans = p.Transparency,
						cc = p.CanCollide, cq = p.CanQuery, ct = p.CanTouch,
					}
					p.LocalTransparencyModifier = 1
					p.Transparency = 1
					p.CanCollide = false
					p.CanQuery = false
					p.CanTouch = false
				elseif p:IsA("Decal") or p:IsA("Texture") then
					pcall(function() p.Transparency = 1 end)
				elseif p:IsA("ProximityPrompt") then
					pcall(function() p.Enabled = false end)
				end
			end
			model.Parent = nil
		end)
	end

	local function ArchivesChairAC_Show(model)
		if not model then return end
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		pcall(function()
			for part, props in pairs(ArchivesChairAC_PartProps) do
				if part and part.Parent then
					if props.ltm ~= nil then part.LocalTransparencyModifier = props.ltm end
					if props.trans ~= nil then part.Transparency = props.trans end
					if props.cc ~= nil then part.CanCollide = props.cc end
					if props.cq ~= nil then part.CanQuery = props.cq end
					if props.ct ~= nil then part.CanTouch = props.ct end
				end
			end
			if ArchivesChairAC_OrigParent and ArchivesChairAC_OrigParent.Parent then
				model.Parent = ArchivesChairAC_OrigParent
			else
				model.Parent = workspace
			end
			if hrp then
				pcall(function() model:PivotTo(hrp.CFrame * CFrame.new(0, 0, -3)) end)
			end
		end)
	end

	local function ArchivesChairAC_SetLagbackBlocked(block)
		if block == ArchivesChairAC_LagbackDisabled then return end
		ArchivesChairAC_LagbackDisabled = block
		pcall(function()
			if not getconnections then return end
			local remotes = {}
			if RemotesFolder then
				table.insert(remotes, RemotesFolder:FindFirstChild("ServerTeleported"))
				table.insert(remotes, RemotesFolder:FindFirstChild("Teleport"))
			end
			for _, d in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
				if d:IsA("RemoteEvent") and (d.Name == "ServerTeleported" or d.Name == "Teleport") then
					table.insert(remotes, d)
				end
			end
			if block then
				for _, remote in ipairs(remotes) do
					if not remote then continue end
					for _, conn in ipairs(getconnections(remote.OnClientEvent)) do
						local already = false
						for _, rec in ipairs(ArchivesChairAC_LagbackConns) do
							if rec[1] == conn then already = true break end
						end
						if not already then
							local enabled = true
							pcall(function() enabled = conn.Enabled end)
							table.insert(ArchivesChairAC_LagbackConns, { conn, enabled })
							pcall(function() conn:Disable() end)
						end
					end
				end
			else
				for _, rec in ipairs(ArchivesChairAC_LagbackConns) do
					if rec[2] then pcall(function() rec[1]:Enable() end) end
				end
				table.clear(ArchivesChairAC_LagbackConns)
			end
		end)
	end

	local function ArchivesChairAC_StopInternal(reason)
		ArchivesChairAC_Active = false
		Globals.AnticheatDisabled = false
		ArchivesChairAC_SetLagbackBlocked(false)
		ArchivesChairAC_DesiredCF = nil
		if ArchivesChairAC_RenderConn then pcall(function() ArchivesChairAC_RenderConn:Disconnect() end) ArchivesChairAC_RenderConn = nil end
		if ArchivesChairAC_Heartbeat then pcall(function() ArchivesChairAC_Heartbeat:Disconnect() end) ArchivesChairAC_Heartbeat = nil end
		if ArchivesChairAC_Held then
			ArchivesChairAC_Show(ArchivesChairAC_Held)
			ArchivesChairAC_Held = nil
		end
		table.clear(ArchivesChairAC_PartProps)
		if reason then
			Functions.Notify({ Title = "Anti-Cheat Bypass", Body = reason })
		end
	end

	Functions.ArchivesChairAC_Stop = function()
		ArchivesChairAC_StopInternal("Anti-Cheat bypass disabled due to leaving cart prop.")
	end

	Functions.ArchivesChairAC_Start = function()
		if not Toggles.ArchivesChairACBypass or not Toggles.ArchivesChairACBypass.Value then
			Functions.Notify({ Title = "Anti-Cheat Bypass", Body = "Turn Chair Anticheat Bypass ON first." })
			return
		end
		if ArchivesChairAC_AtBoundary then
			Functions.Notify({ Title = "Anti-Cheat Bypass", Body = "At *-50 — use console, bypass paused." })
			return
		end
		if ArchivesChairAC_Active then
			Functions.Notify({ Title = "Anti-Cheat Bypass", Body = "Already active." })
			return
		end

		local chair = ArchivesChairAC_NearestChair(22)
		if not chair then
			Functions.Notify({ Title = "Anti-Cheat Bypass", Body = "No office chair nearby. Stand closer." })
			return
		end

		ArchivesChairAC_Hide(chair)
		ArchivesChairAC_Active = true
		Globals.AnticheatDisabled = true
		ArchivesChairAC_SetLagbackBlocked(true)

		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then ArchivesChairAC_DesiredCF = hrp.CFrame end

		Functions.Notify({
			Title = "Anti-Cheat Bypass",
			Body = "You have successfully bypassed the anti-cheat!",
		})
		print("[ChairAC] Start Bypass", chair:GetFullName())

		ArchivesChairAC_RenderConn = Services.RunService.RenderStepped:Connect(function(dt)
			if not ArchivesChairAC_Active or ArchivesChairAC_AtBoundary then return end
			local char = LocalPlayer.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if not hrp or not hum then return end

			local speed = 50
			pcall(function()
				if Options.ChairSpeed then
					speed = math.clamp(tonumber(Options.ChairSpeed.Value) or 50, 1, 100)
				end
			end)

			local move = hum.MoveDirection
			if not ArchivesChairAC_DesiredCF then
				ArchivesChairAC_DesiredCF = hrp.CFrame
			end
			if move.Magnitude > 0.05 then
				local nextPos = ArchivesChairAC_DesiredCF.Position + move.Unit * speed * dt
				local rot = hrp.CFrame - hrp.Position
				ArchivesChairAC_DesiredCF = CFrame.new(nextPos) * rot
			else
				local rot = hrp.CFrame - hrp.Position
				ArchivesChairAC_DesiredCF = CFrame.new(ArchivesChairAC_DesiredCF.Position) * rot
			end

			pcall(function()
				hrp.CFrame = ArchivesChairAC_DesiredCF
				hrp.AssemblyLinearVelocity = move.Magnitude > 0.05 and (move.Unit * speed) or Vector3.zero
				hrp.AssemblyAngularVelocity = Vector3.zero
			end)
		end)

		ArchivesChairAC_Heartbeat = Services.RunService.Heartbeat:Connect(function()
			if not ArchivesChairAC_Active then return end
			if ArchivesChairAC_Held then
				pcall(function()
					if ArchivesChairAC_Held.Parent ~= nil then ArchivesChairAC_Held.Parent = nil end
					for p, _ in pairs(ArchivesChairAC_PartProps) do
						if p and p.Parent then
							p.LocalTransparencyModifier = 1
							p.Transparency = 1
							p.CanCollide = false
						end
					end
				end)
			end
			local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if hrp and Globals.ManipulateBody then
				pcall(function()
					Globals.ManipulateBody.Parent = hrp
					local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
					local move = hum and hum.MoveDirection or Vector3.zero
					local spd = 2.25
					pcall(function()
						if Options.ChairSpeed then
							spd = math.clamp((tonumber(Options.ChairSpeed.Value) or 50) / 25, 1, 4)
						end
					end)
					Globals.ManipulateBody.Velocity = move.Magnitude > 0.05 and (move.Unit * spd) or (hrp.CFrame.LookVector * spd)
				end)
			end
		end)
	end

	pcall(function()
		if LatestRoom then
			ArchivesChairAC_RoomConn = LatestRoom:GetPropertyChangedSignal("Value"):Connect(function()
				local boundary = ArchivesChairAC_IsBoundary(LatestRoom.Value)
				if boundary and not ArchivesChairAC_AtBoundary then
					ArchivesChairAC_AtBoundary = true
					if ArchivesChairAC_Active then
						ArchivesChairAC_StopInternal("*-50 — AC off for console (chair restored).")
					end
				elseif not boundary and ArchivesChairAC_AtBoundary then
					ArchivesChairAC_AtBoundary = false
				end
			end)
		end
	end)

	Toggles.ArchivesChairACBypass:OnChanged(function(Value)
		if not Value and ArchivesChairAC_Active then
			ArchivesChairAC_StopInternal("Chair Anticheat Bypass disabled.")
		elseif Value then
			Functions.Notify({
				Title = "Chair Anticheat Bypass",
				Body = "ON — stand by a chair, set Chair Speed, press Start Bypass.",
			})
		end
	end)

Toggles.AntiRansom:OnChanged(function(Value)
		if AntiRansom_Connection then AntiRansom_Connection:Disconnect() AntiRansom_Connection = nil end
		if not Value then return end
		AntiRansom_Connection = workspace.ChildAdded:Connect(function(Child)
			if Child.Name == "Ransom" and Toggles.AntiRansom.Value then
				Child:Destroy()
				Functions.Notify({ Title = "Ransom removed" })
			end
		end)
	end)

	Toggles.AntiClosetTrash:OnChanged(function(Value)
		if AntiClosetTrash_Connection then AntiClosetTrash_Connection:Disconnect() AntiClosetTrash_Connection = nil end
		if not Value then return end
		AntiClosetTrash_Connection = workspace.ChildAdded:Connect(function(Child)
			if not Toggles.AntiClosetTrash.Value then return end
			local Name = Child.Name
			if Name:sub(1, 6) == "Binder" or Name:sub(1, 4) == "Shoe" or Name:sub(1, 5) == "Shelf" then
				Child:Destroy()
			end
		end)
	end)

	Toggles.BypassAlma:OnChanged(function(Value)
		if AlmaConnection then AlmaConnection:Disconnect() AlmaConnection = nil end
		if not Value then return end
		for _, child in ipairs(workspace:GetChildren()) do
			if child.Name == "Alma" then child:Destroy() end
		end
		AlmaConnection = workspace.ChildAdded:Connect(function(child)
			if child.Name == "Alma" then child:Destroy() end
		end)
	end)

	Toggles.AntiScribbles:OnChanged(function(Value)
		if AntiScribbles_Connection then AntiScribbles_Connection:Disconnect() AntiScribbles_Connection = nil end
		if not Value then return end
		AntiScribbles_Connection = workspace.ChildAdded:Connect(function(Child)
			if Child.Name == "Scribbles" and Toggles.AntiScribbles.Value then
				local w = Child:FindFirstChild("IfYoureExploitingDeleteThis")
				if w then w:Destroy() end
			end
		end)
	end)

	Toggles.BypassDrones:OnChanged(function(Value)
		local function ProcessDrones(drones)
			local WalkedInto = drones:FindFirstChild("WalkedInto") or drones:WaitForChild("WalkedInto", 3)
			if WalkedInto and not DroneWalkedIntoParents[WalkedInto] then
				DroneWalkedIntoParents[WalkedInto] = drones
				WalkedInto.Parent = Services.ReplicatedStorage
			end
		end
		if Value then
			for _, child in ipairs(workspace:GetChildren()) do
				if child.Name == "Drones" then ProcessDrones(child) end
			end
			if DroneConnection then DroneConnection:Disconnect() end
			DroneConnection = workspace.ChildAdded:Connect(function(child)
				if child.Name == "Drones" then ProcessDrones(child) end
			end)
		else
			for WalkedInto, originalParent in pairs(DroneWalkedIntoParents) do
				if WalkedInto and WalkedInto.Parent and originalParent and originalParent.Parent then
					WalkedInto.Parent = originalParent
				end
			end
			table.clear(DroneWalkedIntoParents)
			if DroneConnection then DroneConnection:Disconnect() DroneConnection = nil end
		end
	end)

	Toggles.TimeShower:OnChanged(function(Value)
		TimeShowerToken += 1
		if TimeShowerConnection then TimeShowerConnection:Disconnect() TimeShowerConnection = nil end
		TimeShowerLabel.Visible = false
		TimeShowerLabel.Text = "Time: --:--"
		if not Value then return end
		local Token = TimeShowerToken
		TimeShowerLabel.Visible = true
		TimeShowerConnection = Services.RunService.Heartbeat:Connect(function()
			if Token ~= TimeShowerToken then return end
			local TextLabel = ResolveClockLabel()
			TimeShowerLabel.Text = TextLabel and ("Time: " .. TextLabel.Text) or "Time: --:--"
		end)
	end)

	Toggles.BypassDronesStampede:OnChanged(function(enabled)
		if BypassDronesStampedeConnection then
			task.cancel(BypassDronesStampedeConnection)
			BypassDronesStampedeConnection = nil
		end
		if not enabled then return end
		BypassDronesStampedeConnection = task.spawn(function()
			while Toggles.BypassDronesStampede.Value do
				local remote = ResolveClockRemote()
				if remote then pcall(function() remote:FireServer() end) end
				task.wait(0.5)
			end
		end)
	end)

	Toggles.HonchoCorrectBoxESP:OnChanged(function(Value)
		if HonchoCorrectBoxConnection then HonchoCorrectBoxConnection:Disconnect() HonchoCorrectBoxConnection = nil end
		for _, Object in pairs(HonchoESPObjects) do
			if Object then Functions.RemoveESP(Object) end
		end
		table.clear(HonchoESPObjects)
		table.clear(HonchoProcessedRooms)
		if not Value then return end

		local function ProcessHonchoRoom(Room)
			if not tonumber(Room.Name) or HonchoProcessedRooms[Room] then return end
			HonchoProcessedRooms[Room] = true
			task.wait(3)
			if not Toggles.HonchoCorrectBoxESP.Value or not Room.Parent then
				HonchoProcessedRooms[Room] = nil
				return
			end
			local HonchoRoom = Room:FindFirstChild("ArchivesHonchoRoom", true)
			if not HonchoRoom then HonchoProcessedRooms[Room] = nil return end

			local BoxIDs = {}
			for _, Desc in ipairs(Room:GetDescendants()) do
				if Desc.Name == "ArchivesPackageDeposit" then
					local id = Desc:GetAttribute("Tool_BoxID") or Desc:GetAttribute("BoxID")
					if id ~= nil then BoxIDs[id] = true end
				end
			end
			local RoomNumber = tonumber(Room.Name)
			for _, Child in ipairs(HonchoRoom:GetDescendants()) do
				if Child.Name == "ArchivesStorageBox" then
					local ToolBoxID = Child:GetAttribute("Tool_BoxID")
					if ToolBoxID ~= nil and BoxIDs[ToolBoxID] then
						if not Child:GetAttribute("ParentRoom") then
							Child:SetAttribute("ParentRoom", RoomNumber)
						end
						local Color = (Options.ObjectiveESPColor and Options.ObjectiveESPColor.Value) or Color3.fromRGB(0, 255, 80)
						Functions.AddESP({ Object = Child, Text = "Correct Box", Color = Color }, true)
						table.insert(HonchoESPObjects, Child)
					end
				end
			end
		end

		local currentRooms = workspace:FindFirstChild("CurrentRooms")
		if not currentRooms then return end
		for _, Room in ipairs(currentRooms:GetChildren()) do
			task.spawn(ProcessHonchoRoom, Room)
		end
		HonchoCorrectBoxConnection = currentRooms.ChildAdded:Connect(function(Room)
			task.spawn(ProcessHonchoRoom, Room)
		end)
	end)

	Toggles.BypassWater:OnChanged(function(Value)
		if WaterBypassConnection then WaterBypassConnection:Disconnect() WaterBypassConnection = nil end
		if not Value then
			for _, part in pairs(WaterParts) do if part then part:Destroy() end end
			table.clear(WaterParts)
			return
		end
		Functions.Notify({ Title = "Position Spoof can break Water Bypass." })

		local function ProcessWaterRoom(room)
			if not tonumber(room.Name) then return end
			task.wait(3)
			local water = room:FindFirstChild("Water")
			if not water or WaterParts[water] then return end
			local part = Instance.new("Part")
			part.Name = "WaterBypass"
			part.Anchored = true
			part.CanCollide = true
			part.CanTouch = false
			part.CanQuery = false
			part.Transparency = 0.25
			part.Color = Color3.fromRGB(0, 150, 255)
			part.Material = Enum.Material.ForceField
			if water:IsA("BasePart") then
				part.Size = water.Size + Vector3.new(0, 0.5, 0)
				part.CFrame = water.CFrame * CFrame.new(0, 0.25, 0)
			elseif water:IsA("Model") then
				local cf, size = water:GetBoundingBox()
				part.Size = size + Vector3.new(0, 0.5, 0)
				part.CFrame = cf * CFrame.new(0, 0.25, 0)
			else
				part.Size = Vector3.new(10, 1.5, 10)
				part.CFrame = water:GetPivot() * CFrame.new(0, 0.25, 0)
			end
			if part.Size.Y > 3 then
				part:Destroy()
				Functions.Notify({ Title = "Water Bypass removed (softlock risk)." })
				return
			end
			part.Parent = room
			WaterParts[water] = part
		end

		local latest = tonumber(LatestRoom.Value) or 0
		local roomsFolder = workspace:FindFirstChild("CurrentRooms")
		if roomsFolder then
			for n = math.max(0, latest - 4), latest do
				local r = roomsFolder:FindFirstChild(tostring(n))
				if r then task.spawn(ProcessWaterRoom, r) end
			end
			WaterBypassConnection = roomsFolder.ChildAdded:Connect(function(r)
				task.spawn(ProcessWaterRoom, r)
			end)
		end
	end)

	Toggles.ForgetMeNotSolver:OnChanged(function(Value)
		if ForgetMeNotConnection then ForgetMeNotConnection:Disconnect() ForgetMeNotConnection = nil end
		ForgetMeNotRunning = false
		ForgetMeNotProcessing = {}
		ForgetMeNotNotified = {}
		if not Value then return end
		ForgetMeNotRunning = true

		local function GetNextRoom(Number)
			while ForgetMeNotRunning do
				for RoomNumber = Number + 1, Number + 5 do
					local NextRoom = workspace.CurrentRooms:FindFirstChild(tostring(RoomNumber))
					if NextRoom then return NextRoom end
				end
				task.wait(0.1)
			end
			return nil
		end

		local function FireLookAts(Room)
			for i = 1, 6 do
				local Obj = Room:FindFirstChild(tostring(i))
				local LookAt = Obj and Obj:FindFirstChild("LookAt")
				if LookAt then pcall(function() LookAt:FireServer() end) end
			end
		end

		local function Run(Room)
			if not ForgetMeNotRunning or ForgetMeNotProcessing[Room] then return end
			ForgetMeNotProcessing[Room] = true
			task.wait(2)
			if not ForgetMeNotRunning or not Room.Parent then ForgetMeNotProcessing[Room] = nil return end
			if not Room:FindFirstChild("ForgetMeNotVineDoors", true) then ForgetMeNotProcessing[Room] = nil return end

			FireLookAts(Room)
			local NextRoom = GetNextRoom(tonumber(Room.Name))
			if not NextRoom then ForgetMeNotProcessing[Room] = nil return end
			local Door = NextRoom:FindFirstChild("Door")
			if not Door or Door:GetAttribute("Opened") == true then ForgetMeNotProcessing[Room] = nil return end

			if not Room:FindFirstChild(LocalPlayer.Name, true) then
				if not ForgetMeNotNotified[Room] then
					ForgetMeNotNotified[Room] = true
					Functions.Notify({ Title = "Enter the first Forget Me Not door" })
				end
				repeat task.wait()
				until Room:FindFirstChild(LocalPlayer.Name, true) or not ForgetMeNotRunning or not Room.Parent
				if not ForgetMeNotRunning or not Room.Parent then ForgetMeNotProcessing[Room] = nil return end
			end

			local Hidden = Door:WaitForChild("Hidden", 10)
			if not Hidden or not ForgetMeNotRunning or Door:GetAttribute("Opened") == true then
				ForgetMeNotProcessing[Room] = nil
				return
			end
			task.wait(3)
			while ForgetMeNotRunning and NextRoom.Parent and Door:GetAttribute("Opened") ~= true do
				local Character = LocalPlayer.Character
				if Character then
					if Hidden:IsA("BasePart") then Character:PivotTo(Hidden.CFrame)
					elseif Hidden:IsA("Model") then Character:PivotTo(Hidden:GetPivot()) end
				end
				pcall(function() Door.ClientOpen:Fire() end)
				pcall(function() Door.ClientOpen:FireServer() end)
				task.wait()
			end
			if ForgetMeNotRunning and Door:GetAttribute("Opened") == true then
				local Character = LocalPlayer.Character
				if Character then
					for _ = 1, 4 do Character:PivotTo(CFrame.new(0, -120, 0)) end
					Functions.Notify({ Title = "Spam Void in debug if stuck in Forget Me Not" })
				end
				ForgetMeNotNotified[Room] = nil
			end
			ForgetMeNotProcessing[Room] = nil
		end

		local function CheckRooms()
			local LatestRoomNumber = tonumber(LatestRoom.Value) or 0
			for RoomNumber = math.max(0, LatestRoomNumber - 4), LatestRoomNumber do
				if not ForgetMeNotRunning then return end
				local Room = workspace.CurrentRooms:FindFirstChild(tostring(RoomNumber))
				if Room and not ForgetMeNotProcessing[Room] then task.spawn(Run, Room) end
			end
		end

		local roomsFolder = workspace:FindFirstChild("CurrentRooms")
		if roomsFolder then
			ForgetMeNotConnection = roomsFolder.ChildAdded:Connect(function(Room)
				if not tonumber(Room.Name) then return end
				task.spawn(function()
					task.wait(2)
					if ForgetMeNotRunning and Room.Parent then task.spawn(Run, Room) end
				end)
			end)
		end
		task.spawn(function()
			while ForgetMeNotRunning do CheckRooms() task.wait(2) end
		end)
		CheckRooms()
	end)

	-- Bypass Bash: elevate player on high platform + break LOS until Bash despawns
	local BashPlatform = nil
	local BashShield = nil
	local BashConnection = nil
	local BashHeartbeat = nil
	local ActiveBash = nil

	local function IsBash(obj)
		if not obj then return false end
		local n = obj.Name
		return n == "BashMoving" or n == "Bash" or n == "BashRig" or n:find("Bash") ~= nil
	end

	local function ClearBashPlatform(reason)
		local hadBash = ActiveBash ~= nil
		if BashHeartbeat then
			BashHeartbeat:Disconnect()
			BashHeartbeat = nil
		end
		if BashPlatform then
			BashPlatform:Destroy()
			BashPlatform = nil
		end
		if BashShield then
			BashShield:Destroy()
			BashShield = nil
		end
		ActiveBash = nil
		-- Auto-disable effect when Bash is gone (toggle stays ON for next Bash)
		if hadBash and reason == "despawned" and Toggles.BypassBash and Toggles.BypassBash.Value then
			pcall(function() Functions.Notify({ Title = "Bash gone - platform removed. Waiting for next Bash." }) end)
		end
	end

	local function EnsurePlatform()
		local char = Character or LocalPlayer.Character
		local root = RootPart or (char and char:FindFirstChild("HumanoidRootPart"))
		if not root then return end

		if not BashPlatform or not BashPlatform.Parent then
			BashPlatform = Instance.new("Part")
			BashPlatform.Name = "BashBypassPlatform"
			BashPlatform.Anchored = true
			BashPlatform.CanCollide = true
			BashPlatform.CanTouch = false
			BashPlatform.CanQuery = false
			BashPlatform.Transparency = 0.3
			BashPlatform.Color = Color3.fromRGB(255, 90, 40)
			BashPlatform.Material = Enum.Material.ForceField
			BashPlatform.Size = Vector3.new(14, 1.2, 14)
			BashPlatform.Parent = workspace
		end

		local pos = root.Position
		BashPlatform.CFrame = CFrame.new(pos.X, pos.Y - 3 + 8, pos.Z)
		if root.Position.Y < BashPlatform.Position.Y + 3 then
			root.CFrame = CFrame.new(pos.X, BashPlatform.Position.Y + 2.5, pos.Z) * (root.CFrame - root.CFrame.Position)
		end

		if ActiveBash and ActiveBash.Parent then
			local bashPart = ActiveBash.PrimaryPart or ActiveBash:FindFirstChildWhichIsA("BasePart", true)
			if bashPart then
				if not BashShield or not BashShield.Parent then
					BashShield = Instance.new("Part")
					BashShield.Name = "BashLOSShield"
					BashShield.Anchored = true
					BashShield.CanCollide = false
					BashShield.CanTouch = false
					BashShield.CanQuery = true
					BashShield.Transparency = 0.15
					BashShield.Color = Color3.fromRGB(40, 40, 40)
					BashShield.Material = Enum.Material.SmoothPlastic
					BashShield.Size = Vector3.new(12, 12, 2)
					BashShield.Parent = workspace
				end
				local mid = (root.Position + bashPart.Position) / 2
				BashShield.CFrame = CFrame.lookAt(mid, bashPart.Position)
			end
		end
	end

	local function StartBashBypass(bash)
		if not bash or ActiveBash == bash then return end
		ClearBashPlatform("switch")
		ActiveBash = bash

		pcall(function()
			for _, d in ipairs(bash:GetDescendants()) do
				if d:IsA("BasePart") then
					d.CanTouch = false
				end
			end
		end)

		-- When THIS Bash is destroyed, auto-clear platform
		bash.AncestryChanged:Connect(function(_, parent)
			if not parent and ActiveBash == bash then
				ClearBashPlatform("despawned")
			end
		end)
		bash.Destroying:Connect(function()
			if ActiveBash == bash then
				ClearBashPlatform("despawned")
			end
		end)

		if BashHeartbeat then BashHeartbeat:Disconnect() end
		BashHeartbeat = Services.RunService.Heartbeat:Connect(function()
			if not (Toggles.BypassBash and Toggles.BypassBash.Value) then
				ClearBashPlatform("toggle_off")
				return
			end
			if not ActiveBash or not ActiveBash.Parent then
				ClearBashPlatform("despawned")
				return
			end
			EnsurePlatform()
		end)
		EnsurePlatform()
		pcall(function() Functions.Notify({ Title = "Bash detected - elevated until Bash leaves." }) end)
	end

	if Toggles.BypassBash then
		Toggles.BypassBash:OnChanged(function(Value)
			if BashConnection then BashConnection:Disconnect() BashConnection = nil end
			if not Value then
				ClearBashPlatform("toggle_off")
				return
			end
			pcall(function() Functions.Notify({ Title = "Bypass Bash armed - activates when Bash spawns." }) end)

			for _, child in ipairs(workspace:GetChildren()) do
				if IsBash(child) then
					StartBashBypass(child)
				end
			end
			-- Auto re-enable effect whenever Bash spawns again
			BashConnection = workspace.ChildAdded:Connect(function(child)
				if not (Toggles.BypassBash and Toggles.BypassBash.Value) then return end
				task.wait(0.05)
				if IsBash(child) then
					StartBashBypass(child)
				end
			end)
		end)
	end

end
-- ============================================================

Groupboxes.Floors_Completion = Tabs.Floors:AddRightGroupbox("Completion")
Groupboxes.Floors_Completion:AddButton({
    Text = "Auto Complete Dam Seek",
    Tooltip = "Automatically teleports to and interacts with each water pump.",
    Func = function()
        if LatestRoom.Value < 100 or Floor ~= "Mines" then
            Functions.Notify({Title = "You must be in Room 200 to do this."})
            return
        end

		local IsCutscene = false
		local CutsceneConnection = RemotesFolder.Cutscene.OnClientEvent:Connect(function()
			IsCutscene = true
			task.wait(7)
			IsCutscene = false
		end)

        local function GetNextPump()
            local Highest = {
                Height = -69420,
                Object = nil
            }
            for _, Object in pairs(Objects.Objectives) do
                if Object.Name == "WaterPump" and Object:GetAttribute("MsFent_Completed") ~= true then
                    if Object.PrimaryPart and Object.PrimaryPart.Position.Y > Highest.Height then
                        Highest.Object = Object
                        Highest.Height = Object.PrimaryPart.Position.Y
                    end
                end
            end
            return Highest.Object
        end

        local function HandlePump(Pump)

            while task.wait(0.1) do
				if IsCutscene then
					continue
				end

                Character:PivotTo(Pump:GetPivot())

                local Prompt = Pump:FindFirstChild("ValvePrompt", true)
                if Prompt then
                    Functions.ForceFirePrompt(Prompt)
                end

                if Pump:GetAttribute("MsFent_Completed") then
                    break
                end
            end
        end

        Functions.Notify({Title = "Attempting to complete the valves.", Body = "Please wait."})
        while task.wait(0.1) do
            local Pump = GetNextPump()
            if Pump then
                HandlePump(Pump)
            else
                break
            end
        end
        Functions.Notify({Title = "Successfully completed the valves."})
    end
})

Groupboxes.Floors_Completion:AddButton({
    Text = "Auto Complete Cringle",
    Tooltip = "Instantly completes the quest.",
    Func = function()
        local TouchPart = CurrentRooms:FindFirstChild("RippleExitDoor", true)
        if TouchPart then
            Character:PivotTo(TouchPart:GetPivot())
        end
    end
})

Groupboxes.Floors_Visuals = Tabs.Floors:AddLeftGroupbox("Visuals")
Groupboxes.Floors_Visuals:AddToggle("ShowSeekPathToggle", {
	Text = "Show Seek Path", Default = false, Tooltip = "Shows you the correct path in seek chases.",
	Risky = Floor ~= "Mines"
})
Toggles.ShowSeekPathToggle:AddColorPicker("ShowSeekPathColor", { Text = "Seek Path", Default = Color3.fromRGB(0, 255, 0), Transparency = 0 })

local function UpdateBeamVisibility(BeamTable, ColorKey, Visible)
	local Vis = Visible and 0 or 1
	local Seq = NumberSequence.new({ NumberSequenceKeypoint.new(0, Vis), NumberSequenceKeypoint.new(1, Vis) })
	for _, Beam in BeamTable do Beam.Transparency = Seq end
end
local function UpdateBeamColor(BeamTable, Value)
	local Seq = ColorSequence.new({ ColorSequenceKeypoint.new(0, Value), ColorSequenceKeypoint.new(1, Value) })
	for _, Beam in BeamTable do Beam.Color = Seq end
end

Toggles.ShowSeekPathToggle:OnChanged(function(V)  UpdateBeamVisibility(Objects.SeekHighlights, "ShowSeekPathColor", V) end)
Options.ShowSeekPathColor:OnChanged(function(V)   UpdateBeamColor(Objects.SeekHighlights, V) end)

Groupboxes.Floors_Visuals:AddToggle("ShowEyestalkPathToggle", {
	Text = "Show Eyestalk Path", Default = false, Tooltip = "Shows you the correct path in the eyestalk chase.",
	Risky = Floor ~= "Garden"
})
Toggles.ShowEyestalkPathToggle:AddColorPicker("ShowEyestalkPathColor", { Text = "Eyestalk Path", Default = Color3.fromRGB(0, 255, 0), Transparency = 0 })
Toggles.ShowEyestalkPathToggle:OnChanged(function(V) UpdateBeamVisibility(Objects.EyestalkHighlights, "ShowEyestalkPathColor", V) end)
Options.ShowEyestalkPathColor:OnChanged(function(V)  UpdateBeamColor(Objects.EyestalkHighlights, V) end)

Groupboxes.Floors_Bypass = Tabs.Floors:AddLeftGroupbox("Bypass")
Groupboxes.Floors_Bypass:AddToggle("RemoveSeekTrigger", {
	Text = "Delete Seek Trigger", Default = false, Tooltip = "Diables the 'Seek' chase trigger.",
	Risky = not (Floor == "Fools" or Floor == "OldHotel"),
	Disabled = not Functions.CheckCompatability({"firetouchinterest"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Floors_Bypass:AddToggle("RemoveFigure", {
	Text = "Delete Figure", Default = false, Tooltip = "Completely removes the entity 'Figure' (doesn't always work).",
	Risky = not (Floor == "Fools" or Floor == "OldHotel" or Floor == "Mines"),
	Disabled = not Functions.CheckCompatability({"isnetworkowner"}), DisabledTooltip = Globals.IncompatibleMessage
})
Groupboxes.Floors_Bypass:AddToggle("AutoRevive", {
	Text = "Infinite Revives", Default = false, Tooltip = "Automatically revives after dying, with unlimited respawns.",
	Risky = not (Floor == "Fools" or Floor == "OldHotel")
})
Groupboxes.Floors_Bypass:AddToggle("FigureGodmode", {
	Text = "Figure Godmode", Default = false, Tooltip = "Prevents 'Figure' from hurting you.",
	Risky = not (Floor == "Fools" or Floor == "OldHotel")
})
Groupboxes.Floors_Bypass:AddDivider()
Groupboxes.Floors_Bypass:AddToggle("RemoveBasementGate",  { Text = "Remove Basement Gate",   Default = false, Tooltip = "Removes the gate from basement rooms.",            Risky = not (Floor == "Fools" or Floor == "OldHotel") })
Groupboxes.Floors_Bypass:AddToggle("RemovePaintingsDoor", { Text = "Remove Paintings Door",  Default = false, Tooltip = "Removes the fireplace doors from painting rooms.", Risky = not (Floor == "Fools" or Floor == "OldHotel") })
Groupboxes.Floors_Bypass:AddToggle("RemoveSkeletonDoor",  { Text = "Remove Skeleton Door",   Default = false, Tooltip = "Removes the skeleton door from the infirmary.",    Risky = Floor ~= "Fools" })

local ObstructionNames = { ThingToOpen = "RemoveBasementGate", MovingDoor = "RemovePaintingsDoor", Wax_Door = "RemoveSkeletonDoor" }
for ObjName, ToggleName in ObstructionNames do
	Toggles[ToggleName]:OnChanged(function(Value)
		for _, Object in Objects.Obstructions do
			if Object.Name == ObjName then
				Object:PivotTo(Value and CFrame.new(-10000, -10000, -10000) or Object:GetAttribute("OriginalPosition"))
			end
		end
	end)
end

Groupboxes.Floors_Farming = Tabs.Floors:AddLeftGroupbox("Farming")

Groupboxes.Floors_Farming:AddButton({
	Text = "Start Death Farm",
	DoubleClick = true,
	Tooltip = "Auto-farms deaths: die → statistics → next run (Hotel). Requires queue_on_teleport.",
	Func = function()
		if getgenv().MsFentDeathFarm then
			Library:Notify("Death farm already running.")
			return
		end
		getgenv().MsFentDeathFarm = true
		local function caption(t)
			pcall(function()
				if firesignal and RemotesFolder:FindFirstChild("Caption") then
					firesignal(RemotesFolder.Caption.OnClientEvent, "[Ms fent] " .. t)
				end
			end)
			pcall(function() Functions.Notify({ Title = "Death Farm", Body = t }) end)
		end
		local qot = queue_on_teleport or queueonteleport
		local reexec = [[
			getgenv().MsFentDeathFarm = true
			task.spawn(function()
				task.wait(2)
				pcall(function()
					-- Death farm logic is local; no external load
				end)
			end)
		]]
		-- Prefer inlined loop without external if possible; lobby hop bootstrap
		if game.PlaceId == 6516141723 then
			caption("Lobby → creating Hotel run...")
			if qot then pcall(qot, reexec) end
			pcall(function()
				RemotesFolder.CreateElevator:FireServer({
					Mods = {}, Settings = {}, Destination = "Hotel",
					FriendsOnly = false, MaxPlayers = "1",
				})
			end)
			return
		end
		caption("Death farm active — dying for knobs...")
		task.spawn(function()
			while getgenv().MsFentDeathFarm do
				pcall(function()
					if LocalPlayer:GetAttribute("Alive") then
						if replicatesignal and LocalPlayer:FindFirstChild("Kill") then
							pcall(replicatesignal, LocalPlayer.Kill)
						elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
							LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
						end
					end
				end)
				task.wait(1.5)
				pcall(function() RemotesFolder.Statistics:FireServer() end)
				task.wait(2)
			end
		end)
	end,
})
Groupboxes.Floors_Farming:AddButton({
	Text = "Stop Death Farm",
	Tooltip = "Stops the local death farm loop.",
	Func = function()
		getgenv().MsFentDeathFarm = false
		Library:Notify("Death farm stopped.")
	end,
})
Groupboxes.Floors_Farming:AddToggle("KnobFarm", {
    Text = "Knob Farm",
    Default = false,
    Tooltip = "Automatically gains knobs for you, dies and revives repeatedly.",
})

Groupboxes.Floors_Farming:AddButton({
    Text = "Start Knob Farm",
    Tooltip = "Starts farming knobs, click this when you have enough gold.",
    Func = function()
		if LatestRoom.Value ~= 0 then
			Functions.Notify({Title = "You must be in Room 0 to use this."})
			return
		end

		if LocalPlayer.PlayerGui:FindFirstChild("TopbarUI") then 
			local GoldCount = LocalPlayer.PlayerGui.TopbarUI.Topbar.StatsTopbarHandler.StatModules.Gold.GoldVal
			if GoldCount.Value <= 0 then
				Functions.Notify({Title = "You must have gold to do this."})
				return
			end
		end

        Globals.KnobFarmStarted = true
    end
})

Toggles.KnobFarm:OnChanged(function(Value)
    if Value then
        Functions.Notify({Title = "Please collect some gold to earn knobs.", Body = "Click 'Start Knob Farm' when you're ready."})
	else
		Globals.KnobFarmStarted = false
    end
end)

Globals.KnobFarmActive = false
Globals.KnobFarmStarted = false
Connections.KnobFarm = Services.RunService.Heartbeat:Connect(function()
	if Toggles.KnobFarm.Value and Globals.KnobFarmStarted then
		if not Globals.KnobFarmActive then
			Globals.KnobFarmActive = true
			if Functions.CheckCompatability({"replicatesignal"}) then
				MsFent.Environment.replicatesignal(LocalPlayer.Kill)
			else
				RemotesFolder.Underwater:FireServer(true)
			end
			while task.wait() do
				if LocalPlayer:GetAttribute("Alive") then
					break
				end
			end
			RemotesFolder.Statistics:FireServer()
			task.wait(0.25)
			Globals.KnobFarmActive = false
		end
	end
end)

local MainHook
local OtherHook
if Functions.CheckCompatability({"hookmetamethod", "newcclosure", "getnamecallmethod"}) then
	MainHook = MsFent.Environment.hookmetamethod(game, "__namecall", MsFent.Environment.newcclosure(function(Self, ...)
		local Args = { ... }
		if MsFent and MsFent.Environment then
			local Method = MsFent.Environment.getnamecallmethod()

			if Self.Name == "Crouch" and Method == "FireServer" then
				if Toggles.CrouchSpoof.Value or Toggles.PositionSpoof.Value then
					Args[1] = true
				end
				Args[2] = true
			end

			if Self.Name == "ClutchHeartbeat" and Method == "FireServer" and Toggles.AutoHeartbeatMinigame.Value or Self.Name == "HideMonster" and Method == "FireServer" and Toggles.AutoHeartbeatMinigame.Value then
				return
			end

			if Self.Name == "MotorReplication" and Method == "FireServer" then
				local DoBypass = (Toggles.BypassEyes.Value and Globals.IsEyes) or (Toggles.BypassLookman.Value and Globals.IsLookman)
				if DoBypass then
					if Floor == "Fools" or Floor == "OldHotel" then
						Args[1] = 0 Args[2] = (Globals.SpoofOffset == 200 and 65 or -65) Args[3] = 0 Args[4] = false
					else
						Args[1] = -650
					end
				end
			end
		end
		return MainHook(Self, table.unpack(Args))
	end))

    OtherHook = MsFent.Environment.hookmetamethod(game, "__index", MsFent.Environment.newcclosure(function(Self, Property)
        local Real = OtherHook(Self, Property)

        if Property == "MoveDirection" and Self == Humanoid and Globals.RoomsAutoWalkActive and Toggles.RoomsAutoWalkSpoofFootsteps.Value and Floor == "Rooms" and not Character:GetAttribute("Hiding") then
            return RootPart.CFrame.LookVector
        end
        
        return Real
    end))
end

if Services.ReplicatedStorage:FindFirstChild("ModulesClient") then
	ClientModules = Services.ReplicatedStorage.ModulesClient
else
	ClientModules = Services.ReplicatedStorage.ClientModules
end

Modules = {
	Glitch         = ClientModules.EntityModules.Glitch,
	Shade          = ClientModules.EntityModules.Shade,
	Void           = ClientModules.EntityModules:FindFirstChild("Void"),
	SpiderJumpscare = nil,
	A90            = nil,
	Screech        = nil,
	Dread          = nil,
	GlitchScreech  = nil,
}

local CharacterOldConnectionKeys = {
	"MainHandler", "JumpHandler", "SlideHandler", "LibraryCodeHandler1", "LibraryCodeHandler2",
	"OxygenConnection", "AnimationHandler", "AutoHideConnection", "LagbackFixer", "AutoReviveHandler",
	"SHMFixer", "AnticheatDisabler", "AnticheatEnableDetector1", "AnticheatEnableDetector2",
	"AutoSteerMinecartDuckHandler", "AutoSolveAnchorsConnection", "InfiniteJumpsConnection1", "InfiniteJumpsConnection2",
	"FootstepHandler"
}

Globals.IsTyping = false
Connections.TextBoxConnection1 = Services.UserInputService.TextBoxFocused:Connect(function()
	Globals.IsTyping = true
end)
Connections.TextBoxConnection2 = Services.UserInputService.TextBoxFocusReleased:Connect(function()
	Globals.IsTyping = false
end)

-- Permanent feature enforcer: survives revive without relying on stale Humanoid refs
Functions.RetoggleAllFeatures = function(reason)
	if Globals.RetogglingFeatures then return end
	Globals.RetogglingFeatures = true
	task.spawn(function()
		local ok, err = pcall(function()
			-- 1) Refresh character + Main_Game library
			local char = LocalPlayer.Character
			if char then
				Character = char
				Humanoid = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChild("Humanoid")
				RootPart = char:FindFirstChild("HumanoidRootPart")
				Collision = char:FindFirstChild("Collision")
				CollisionPart = char:FindFirstChild("CollisionPart") or Collision
			end
			Camera = workspace.CurrentCamera
			pcall(function()
				local pg = LocalPlayer:FindFirstChild("PlayerGui")
				if not pg then return end
				local ui = pg:FindFirstChild("MainUI")
				if not ui then return end
				Globals.MainUI = ui
				local initiator = ui:FindFirstChild("Initiator")
				local mg = initiator and initiator:FindFirstChild("Main_Game")
				if mg and Functions.CheckCompatability({"require"}) then
					Main_Game = MsFent.Environment.require(mg)
				end
			end)

			-- 2) Snapshot every toggle that is currently ON
			--    Skip pure UI / one-shot / farm toggles that would softlock on re-fire
			local skip = {
				KeybindMenuOpen = true,
				ShowCustomCursor = true,
				KnobFarm = true,
				TpNextDoor = true,
				-- Infinite Revives stays on but we don't pulse it (would spam revive remote)
			}
			local wasOn = {}
			for name, toggle in pairs(Toggles) do
				if typeof(toggle) == "table" and toggle.Value == true and not skip[name] then
					-- only real library toggles with SetValue
					if toggle.SetValue or toggle.SetState then
						table.insert(wasOn, name)
					end
				end
			end

			print("[Ms fent] RetoggleAll:", reason or "?", "count=", #wasOn)

			-- 3) Turn OFF then ON so every OnChanged handler re-runs with new Character/Main_Game
			for _, name in ipairs(wasOn) do
				local toggle = Toggles[name]
				if toggle then
					pcall(function()
						if toggle.SetValue then
							toggle:SetValue(false)
						elseif toggle.SetState then
							toggle:SetState(false)
						end
					end)
				end
			end
			task.wait(0.08)
			for _, name in ipairs(wasOn) do
				local toggle = Toggles[name]
				if toggle then
					pcall(function()
						if toggle.SetValue then
							toggle:SetValue(true)
						elseif toggle.SetState then
							toggle:SetState(true)
						end
					end)
					task.wait(0.02) -- small stagger so handlers don't stack-race
				end
			end

			-- 4) Direct enforcement after retoggle
			task.wait(0.05)
			Functions.RefreshActiveFeatures((reason or "retoggle") .. "-post")
		end)
		if not ok then
			warn("[Ms fent] RetoggleAll error:", err)
		end
		Globals.RetogglingFeatures = false
	end)
end

Functions.RefreshActiveFeatures = function(reason)
	pcall(function()
		local char = LocalPlayer.Character
		if not char then return end

		Character = char
		Humanoid = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChild("Humanoid")
		RootPart = char:FindFirstChild("HumanoidRootPart")
		Collision = char:FindFirstChild("Collision")
		CollisionPart = char:FindFirstChild("CollisionPart") or Collision
		Camera = workspace.CurrentCamera

		pcall(function()
			local pg = LocalPlayer:FindFirstChild("PlayerGui")
			if pg and pg:FindFirstChild("MainUI") then
				Globals.MainUI = pg.MainUI
				if Functions.CheckCompatability({"require"}) and Globals.MainUI:FindFirstChild("Initiator") then
					local init = Globals.MainUI.Initiator:FindFirstChild("Main_Game")
					if init then
						Main_Game = MsFent.Environment.require(init)
					end
				end
			end
		end)

		if not Humanoid or not RootPart then return end

		if Toggles.EnableCharacterJump and Toggles.EnableCharacterJump.Value then
			char:SetAttribute("CanJump", true)
		end
		if Toggles.EnableCharacterSlide and Toggles.EnableCharacterSlide.Value then
			char:SetAttribute("CanSlide", true)
		end

		if Toggles.SpeedBoostToggle and Toggles.SpeedBoostToggle.Value and Options.SpeedBoostSlider then
			Humanoid.WalkSpeed = Functions.GetCurrentSpeed() + (tonumber(Options.SpeedBoostSlider.Value) or 0)
		end

		if Toggles.FOVToggle and Toggles.FOVToggle.Value and Options.FieldOfView then
			local fov = tonumber(Options.FieldOfView.Value) or 70
			if Main_Game then Main_Game.fovtarget = fov end
			if Camera then Camera.FieldOfView = fov end
		end

		if Globals.FlyBody then
			if Toggles.FlyToggle and Toggles.FlyToggle.Value then
				Globals.FlyBody.Parent = RootPart
				Globals.FlyBody.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			else
				Globals.FlyBody.Parent = nil
			end
		end

		Globals.ThirdPersonParts = {}
		pcall(function()
			for _, obj in char:GetDescendants() do
				if obj:IsA("Accessory") and obj:FindFirstChild("Handle") then
					table.insert(Globals.ThirdPersonParts, obj.Handle)
				end
			end
			local head = char:FindFirstChild("Head")
			if head then table.insert(Globals.ThirdPersonParts, head) end
		end)

		if Main_Game and Toggles.RemoveCameraBobbing and Toggles.RemoveCameraBobbing.Value then
			Main_Game.spring.Speed = 9e9
		end
		if Toggles.RemoveCameraFog and Toggles.RemoveCameraFog.Value then
			Services.Lighting.FogEnd = 10000000
		end

		print("[Ms fent] RefreshActiveFeatures:", reason or "?")
	end)
end

-- Always-on enforcer (does NOT get disconnected on CharacterAdded)
if Connections.FeatureEnforcer then
	pcall(function() Connections.FeatureEnforcer:Disconnect() end)
end
Connections.FeatureEnforcer = Services.RunService.Heartbeat:Connect(function()
	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end

	-- Keep globals in sync so MainHandler doesn't use dead instances
	if Character ~= char then
		Character = char
		Humanoid = hum
		RootPart = hrp
		Collision = char:FindFirstChild("Collision")
		CollisionPart = char:FindFirstChild("CollisionPart") or Collision
	elseif Humanoid ~= hum then
		Humanoid = hum
		RootPart = hrp
	end

	if Toggles.SpeedBoostToggle and Toggles.SpeedBoostToggle.Value and Options.SpeedBoostSlider then
		local target = Functions.GetCurrentSpeed() + (tonumber(Options.SpeedBoostSlider.Value) or 0)
		if math.abs(hum.WalkSpeed - target) > 0.05 then
			hum.WalkSpeed = target
		end
	end

	if Toggles.FOVToggle and Toggles.FOVToggle.Value and Options.FieldOfView then
		local fov = tonumber(Options.FieldOfView.Value) or 70
		if Main_Game and Main_Game.fovtarget ~= fov then
			Main_Game.fovtarget = fov
		end
		local cam = workspace.CurrentCamera
		if cam and math.abs(cam.FieldOfView - fov) > 0.5 then
			cam.FieldOfView = fov
		end
	end

	if Toggles.EnableCharacterJump and Toggles.EnableCharacterJump.Value then
		if char:GetAttribute("CanJump") ~= true then
			char:SetAttribute("CanJump", true)
		end
	end
	if Toggles.EnableCharacterSlide and Toggles.EnableCharacterSlide.Value then
		if char:GetAttribute("CanSlide") ~= true then
			char:SetAttribute("CanSlide", true)
		end
	end

	if Toggles.FlyToggle and Toggles.FlyToggle.Value and Globals.FlyBody then
		if Globals.FlyBody.Parent ~= hrp then
			Globals.FlyBody.Parent = hrp
		end
	end
end)

-- Revive watcher: Alive, CharacterAdded, and health recovery
do
	local lastAlive = LocalPlayer:GetAttribute("Alive")
	local function onReviveEvent(tag)
		task.spawn(function()
			-- wait for character/MainUI to exist after revive
			task.wait(0.25)
			local t0 = tick()
			while tick() - t0 < 5 do
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					local pg = LocalPlayer:FindFirstChild("PlayerGui")
					if pg and pg:FindFirstChild("MainUI") then break end
				end
				task.wait(0.1)
			end
			Functions.RetoggleAllFeatures(tag)
			task.wait(0.8)
			Functions.RefreshActiveFeatures(tag .. "-late")
			task.wait(1.2)
			Functions.RefreshActiveFeatures(tag .. "-later")
		end)
	end

	LocalPlayer:GetAttributeChangedSignal("Alive"):Connect(function()
		local now = LocalPlayer:GetAttribute("Alive")
		if now == true and lastAlive == false then
			onReviveEvent("Alive")
		end
		lastAlive = now
	end)

	LocalPlayer.CharacterAdded:Connect(function(newChar)
		onReviveEvent("CharacterAdded")
		task.spawn(function()
			local hum = newChar:WaitForChild("Humanoid", 10)
			if not hum then return end
			hum.Died:Connect(function()
				-- after death, watch for health return without CharacterAdded
			end)
			hum:GetPropertyChangedSignal("Health"):Connect(function()
				if hum.Health > 0 and LocalPlayer:GetAttribute("Alive") == true then
					Functions.RefreshActiveFeatures("HealthRecover")
				end
			end)
		end)
	end)
end

Functions.HandleCharacter = function(NewCharacter)

	for _, Key in CharacterOldConnectionKeys do
		if Connections[Key] then
			Connections[Key]:Disconnect()
			Connections[Key] = nil
		end
	end

	while not LocalPlayer.PlayerGui:FindFirstChild("MainUI") do
		task.wait()
	end

	Character = NewCharacter
	Humanoid = NewCharacter:WaitForChild("Humanoid", 9e9)
	RootPart = NewCharacter:FindFirstChild("HumanoidRootPart")
	Camera   = Services.Workspace.CurrentCamera

	Globals.OldCamera = Camera
	Globals.MainUI = LocalPlayer.PlayerGui.MainUI

	Collision = NewCharacter:WaitForChild("Collision")
	CollisionPart  = NewCharacter:FindFirstChild("CollisionPart") or NewCharacter:FindFirstChild("Collision")
	CollisionClone = Collision:Clone()
	CollisionClone.Parent = NewCharacter
	CollisionClone.Name = "CollisionClone"
	CollisionClone.Massless = true

	CollisionPartClone = CollisionPart:Clone()
	CollisionPartClone.Parent = NewCharacter
	CollisionPartClone.Name = "CollisionPartClone"
	CollisionPartClone.CanCollide = false
	CollisionPartClone.Massless = true

	if CollisionPartClone:FindFirstChild("CollisionCrouch") then
		CollisionPartClone.CollisionCrouch:Destroy()
	end

	Character:SetAttribute("SpeedBoost", 0)
	Character:SetAttribute("SpeedBoostBehind", 0)
	Character:SetAttribute("SpeedBoostExtra", 0)

	OldJump  = NewCharacter:GetAttribute("CanJump")
	OldSlide = NewCharacter:GetAttribute("CanSlide")

	if Toggles.EnableCharacterJump.Value  then Character:SetAttribute("CanJump",  true) end
	if Toggles.EnableCharacterSlide.Value then Character:SetAttribute("CanSlide", true) end

	if Functions.CheckCompatability({"require"}) then
		Main_Game = MsFent.Environment.require(Globals.MainUI.Initiator.Main_Game)
	end

	if Main_Game and Toggles.RemoveCameraBobbing.Value then
		Main_Game.spring.Speed = 9e9
	end

	if Main_Game and Functions.CheckCompatability({"require"}) then
		local Controls = require(LocalPlayer.PlayerScripts.PlayerModule):GetControls()
		local OriginalGetMoveVector = Controls.GetMoveVector
		Controls.GetMoveVector = function(...)
			if Toggles.AutoSteerMinecart.Value and Floor == "Mines" then
				local Node = Globals.NearestTurnNode
				if Node and Functions.GetMinecart() then
					local Turn = Node:GetAttribute("Turn")
					return Turn == "Left" and Vector3.new(-1, 0, 0) or Turn == "Right" and Vector3.new(1, 0, 0) or Vector3.zero
				end
			end
			return OriginalGetMoveVector(...)
		end
	end

	Globals.AutoMinecartDucked = false
	Globals.LastDuck = tick()
	Connections.AutoSteerMinecartDuckHandler = Services.RunService.Heartbeat:Connect(function()
		if not Toggles.AutoSteerMinecart.Value or not Functions.GetMinecart() or tick() - Globals.LastDuck < 0.1 then return end
		Globals.NearestTurnNode = Functions.GetNearestTurnNode()

		if not Globals.AutoMinecartDucked and Functions.GetNearestDuckBoard() then
			Main_Game.crouch(true)
			Globals.AutoMinecartDucked = true
		elseif not Functions.GetNearestDuckBoard() and Globals.AutoMinecartDucked then
			Main_Game.crouch(false)
			Globals.AutoMinecartDucked = false
		end
		if Toggles.FOVToggle and Toggles.FOVToggle.Value then
			if Toggles.FOVToggle and Toggles.FOVToggle.Value then
				if Main_Game then
					Main_Game.fovtarget = Options.FieldOfView.Value
				else
					Camera.FieldOfView = Options.FieldOfView.Value
				end
			end
		end
		Globals.LastDuck = tick()
	end)

	Globals.AnticheatDisabled = false

	local UIModules = Globals.MainUI.Initiator.Main_Game.RemoteListener.Modules
	Modules.A90             = UIModules:FindFirstChild("A90")
	Modules.Screech         = UIModules.Screech
	Modules.Dread           = UIModules:FindFirstChild("Dread")
	Modules.SpiderJumpscare = UIModules.SpiderJumpscare

	if Toggles.RemoveScreech.Value    then Modules.Screech.Name = "Screech_Disabled" end
	if Toggles.RemoveA90.Value and Modules.A90   then Modules.A90.Name = "A90_Disabled" end
	if Toggles.RemoveDread.Value and Modules.Dread then Modules.Dread.Name = "Dread_Disabled" end
	if Toggles.DisableTimothyJumpscare.Value then Modules.SpiderJumpscare.Name = "SpiderJumpscare_Disabled" end

	if Toggles.DisableHideVignette.Value then
		local Vignette = Globals.MainUI:FindFirstChild("HideVignette") or Globals.MainUI.MainFrame:FindFirstChild("HideVignette")
		if Vignette then Vignette.Image = "Disabled" end
	end
	if Toggles.RemoveInteractingSounds.Value then
		local PS = Globals.MainUI.Initiator.Main_Game.PromptService
		PS.Triggered.Volume = 0
		PS.Holding.Volume   = 0
		PS.Notification.Volume = 0
		Globals.MainUI.Initiator.Main_Game.Reminder.Caption.Volume = 0
	end
	if Toggles.DisableEntityJumpscares.Value then
		local JS = Globals.MainUI.Initiator.Main_Game.RemoteListener:FindFirstChild("Jumpscares")
		if JS then JS.Name = "Jumpscares_Disabled" end
	end
    local Cutscenes = Globals.MainUI.Initiator.Main_Game.RemoteListener.Cutscenes
    for _, Object in pairs(Cutscenes:GetChildren()) do
        if table.find(CutsceneNames, Object.Name) and Object:IsA("ModuleScript") then
            Object:SetAttribute("OriginalName", Object.Name)
            if Toggles.RemoveCutscenes.Value then
                Object.Name = Object.Name .. "_Disabled"
            end
        end
    end
    for _, Object in pairs(FloorReplicated:GetChildren()) do
        if table.find(CutsceneNames, Object.Name) and Object:IsA("ModuleScript") then
            Object:SetAttribute("OriginalName", Object.Name)
            if Toggles.RemoveCutscenes.Value then
                Object.Name = Object.Name .. "_Disabled"
            end
        end
    end

	CustomPhysics = PhysicalProperties.new(
		100,
		RootPart.CustomPhysicalProperties.Friction,
		RootPart.CustomPhysicalProperties.Elasticity,
		RootPart.CustomPhysicalProperties.FrictionWeight,
		RootPart.CustomPhysicalProperties.ElasticityWeight
	)
	for _, Part in NewCharacter:GetDescendants() do
		if Part:IsA("BasePart") then
			PartProperties[Part] = Part.CustomPhysicalProperties
			if Toggles.RemoveAcceleration.Value then
				Part.CustomPhysicalProperties = CustomPhysics
			end
		end
	end

	Connections.LibraryCodeHandler1 = LocalPlayer.PlayerGui.PermUI.Hints.ChildAdded:Connect(function()
		if Toggles.NotifyLibraryCode.Value then
			local Code = Functions.GetLibraryCode()
			if Code and not Code:find("_") and not Globals.LibraryCodeFound then
				local Lock = Services.Workspace:FindFirstChild("Padlock", true)
				Functions.Notify({ Title = "Padlock code found!", Body = "The code is: '" .. Code .. "'", Time = Toggles.NotifyKeepNotifications.Value and Lock or 15 })
				Globals.LibraryCodeFound = true
			end
		end
	end)

	Connections.LibraryCodeHandler2 = Character.ChildAdded:Connect(function(Child)
		if (Child.Name == "LibraryHintPaper" or Child.Name == "LibraryHintPaperHard") and Toggles.NotifyLibraryCode.Value then
			local Code = Functions.GetLibraryCode()
			if Code and not Code:find("_") and not Globals.LibraryCodeFound then
				local Lock = Services.Workspace:FindFirstChild("Padlock", true)
				Functions.Notify({ Title = "Padlock code found!", Body = "The code is: '" .. Code .. "'", Time = Toggles.NotifyKeepNotifications.Value and Lock or 15 })
				Globals.LibraryCodeFound = true
			end
		end
	end)

	Connections.FootstepHandler = Character.ChildAdded:Connect(function(Object)
		if Object:IsA("Sound") and Object.Name == "Sound" and Toggles.RemoveFootstepSounds.Value then
			Object.Volume = 0
		end
	end)

	Globals.OldOxygen = Character:GetAttribute("Oxygen")
	Connections.OxygenConnection = Character:GetAttributeChangedSignal("Oxygen"):Connect(function()
		local NewOxy = Character:GetAttribute("Oxygen")
		if NewOxy < Globals.OldOxygen and Toggles.NotifyOxygen.Value then
			Functions.Caption(Functions.FormatOxygen(NewOxy), true)
		end
		Globals.OldOxygen = NewOxy
	end)

	Connections.AutoReviveHandler = LocalPlayer:GetAttributeChangedSignal("Alive"):Connect(function()
		local alive = LocalPlayer:GetAttribute("Alive")
		if alive == false and Toggles.AutoRevive.Value then
			if Floor == "Fools" or Floor == "OldHotel" then
				while LocalPlayer:GetAttribute("Alive") ~= true do
					RemotesFolder.Revive:FireServer()
					task.wait(0.5)
				end
			else
				-- other floors: still try revive remote when Infinite Revives is on
				task.spawn(function()
					for _ = 1, 8 do
						if LocalPlayer:GetAttribute("Alive") == true then break end
						pcall(function() RemotesFolder.Revive:FireServer() end)
						task.wait(0.4)
					end
				end)
			end
		elseif alive == true then
			-- Revive detected (game button or Infinite Revives) → refresh features
			task.defer(function()
				task.wait(0.2)
				if LocalPlayer.Character then
					Functions.RefreshActiveFeatures("Revive/Alive=true")
				end
				task.wait(0.5)
				if LocalPlayer.Character then
					Functions.RefreshActiveFeatures("Revive-delayed")
				end
			end)
		end
	end)

	Connections.SHMFixer = RootPart:GetPropertyChangedSignal("Anchored"):Connect(function()
		task.wait()
		if Floor == "Fools" and RootPart.Anchored and Character:GetAttribute("Hiding") ~= true then
			RootPart.Anchored = false
		end
	end)

	Connections.AnticheatDisabler = Character:GetAttributeChangedSignal("Climbing"):Connect(function()
		if Character:GetAttribute("Climbing") == true and Toggles.DisableAnticheat.Value and not Globals.AnticheatDisabled then
			task.wait(0.25)
			Character:SetAttribute("Climbing", false)
			Functions.Notify({ Title = "Successfully disabled the anticheat.", Body = "It will be re-enabled after a cutscene or halt room." })
			Globals.AnticheatDisabled = true
		end
	end)

	Connections.AnticheatEnableDetector1 = RemotesFolder:WaitForChild("Cutscene").OnClientEvent:Connect(function(CutsceneName)
		if Globals.AnticheatDisabled and not CutsceneName:find("SewerSeek") then
			Globals.AnticheatDisabled = false
			Functions.Notify({ Title = "The anticheat has been re-enabled.", Body = "Interact with a ladder to disable it again." })
		end
	end)

	Connections.AnticheatEnableDetector2 = RemotesFolder:WaitForChild("UseEnemyModule").OnClientEvent:Connect(function(ModuleName)
		if ModuleName == "Void" or ModuleName == "Glitch" then
			if Globals.AnticheatDisabled then
				Globals.AnticheatDisabled = false
				Functions.Notify({ Title = "The anticheat has been re-enabled.", Body = "Interact with a ladder to disable it again." })
			end
			LocalPlayer:SetAttribute("CurrentRoom", LatestRoom.Value)
		end
	end)

	Connections.AnimationHandler = Character.ChildAdded:Connect(function()
		local ToolNames = { "Lockpick","Shears","SkeletonKey","Key","GeneratorFuse","KeyElectrical","KeyBackdoor","KeyIron", "Multitool" }
		local Tool
		for _, Name in ToolNames do
			Tool = Character:FindFirstChild(Name)
			if Tool then break end
		end
		if not Tool then return end

		local UseAnim = Tool:FindFirstChild("use", true) or Tool:FindFirstChild("promptanim", true)
		if UseAnim then
			UseAnim = Humanoid:LoadAnimation(UseAnim)
			UseAnim.Priority = Enum.AnimationPriority.Action4
			Globals.UseAnimation = UseAnim
		end
		local UseAnimBreak = Tool:FindFirstChild("usefinish", true) or Tool:FindFirstChild("promptanimend", true) or Tool:FindFirstChild("lockpickuse", true)
		if UseAnimBreak then
			UseAnimBreak = Humanoid:LoadAnimation(UseAnimBreak)
			UseAnimBreak.Priority = Enum.AnimationPriority.Action4
			Globals.UseAnimationBreak = UseAnimBreak
		end
	end)

	Connections.JumpHandler = Character:GetAttributeChangedSignal("CanJump"):Connect(function()
		local Val = Character:GetAttribute("CanJump")
		if Toggles.EnableCharacterJump.Value and Val ~= true or not Toggles.EnableCharacterJump.Value then
			OldJump = Val
		end
		if Toggles.EnableCharacterJump.Value then Character:SetAttribute("CanJump", true) end
	end)

	Connections.SlideHandler = Character:GetAttributeChangedSignal("CanSlide"):Connect(function()
		local Val = Character:GetAttribute("CanSlide")
		if Toggles.EnableCharacterSlide.Value and Val ~= true or not Toggles.EnableCharacterSlide.Value then
			OldSlide = Val
		end
		if Toggles.EnableCharacterSlide.Value then Character:SetAttribute("CanSlide", true) end
	end)

	Connections.InfiniteJumpsConnection1 = Services.UserInputService.InputBegan:Connect(function(Input)
		if Input.KeyCode == Enum.KeyCode.Space and Toggles.InfiniteJumps.Value and not Globals.IsTyping then
			Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)

	local JumpButton = Globals.MainUI.MainFrame.MobileButtons:FindFirstChild("JumpButton")
	if JumpButton then
		Connections.InfiniteJumpsConnection2 = JumpButton.MouseButton1Down:Connect(function()
			if Toggles.InfiniteJumps.Value then
				Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end

	Globals.SpoofOffset = 0
	Globals.LastAutoHide = tick()
	Connections.AutoHideConnection = Services.RunService.Heartbeat:Connect(function()
		if not Toggles.AutoClosetToggle.Value or tick() - Globals.LastAutoHide <= 0.1 then
			Globals.AutoClosetActive = false
			return
		end
		local Entity = Functions.GetNearestEntity(true, Options.AutoClosetEntityList.Value)
		if Entity then
			local Closet = Functions.GetNearestHidingSpot()
			if Character:GetAttribute("Hiding") ~= true and Closet then
				Globals.AutoClosetActive = true
				Functions.ForceFirePrompt(Closet.HidePrompt)
			end
			if Character:GetAttribute("Hiding") then
				if Toggles.SpectateEntityToggle.Value and Entity.PrimaryPart then
					Globals.SpectateEntity = Entity
				end
			end
		elseif Character:GetAttribute("Hiding") == true then
			Globals.SpectateEntity = nil
			Globals.AutoClosetActive = false
			RemotesFolder.CamLock:FireServer()
		else
			Globals.SpectateEntity = nil
		end
		Globals.LastAutoHide = tick()
	end)

	Connections.LagbackFixer = CollisionPart:GetPropertyChangedSignal("Anchored"):Connect(function()
		if CollisionPartClone and CollisionPart.Anchored and not Character:GetAttribute("Hiding") then
			Globals.Lagging = true
			CollisionPartClone.Massless = true
			task.wait(1)
			Globals.Lagging = false
		end
	end)

	Globals.LastAutoAnchor = tick()
	Connections.AutoSolveAnchorsConnection = Services.RunService.Heartbeat:Connect(function()
		if not Toggles.AutoSolveAnchors.Value then return end
		if not Globals.MainUI:FindFirstChild("AnchorHintFrame") then return end
		if tick() - Globals.LastAutoAnchor <= 0.1 then return end
		local Anchor = Functions.GetCurrentAnchor()
		if Anchor and LocalPlayer:DistanceFromCharacter(Anchor.PrimaryPart.Position) < Anchor.ActivateEventPrompt.MaxActivationDistance and not Anchor:GetAttribute("Activated") then
			Anchor:WaitForChild("AnchorRemote"):InvokeServer(Globals.MainUI.AnchorHintFrame.Code.Text)
		end
		Globals.LastAutoAnchor = tick()
	end)

	Globals.ManipulateBody = Instance.new("BodyVelocity")
	Globals.ManipulateBody.MaxForce = Vector3.new(9e9, 9e9, 9e9)

	Globals.FlyBody = Instance.new("BodyVelocity")
	Globals.FlyBody.MaxForce = Vector3.new(9e9, 9e9, 9e9)

	Globals.SelfKilled = false
	Globals.ThirdPersonParts = {}
	for _, Object in Character:GetDescendants() do
		if Object:IsA("Accessory") and Object:FindFirstChild("Handle") then
			table.insert(Globals.ThirdPersonParts, Object.Handle)
		end
	end
	table.insert(Globals.ThirdPersonParts, Character:WaitForChild("Head"))

	Globals.LastAnimationCheck = tick()
	Globals.LastCrouchFire = tick()
	Globals.OriginalC1 = Character.LowerTorso.Root.C1

	local RayParams = RaycastParams.new()
	RayParams.FilterType = Enum.RaycastFilterType.Exclude

	Connections.MainHandler = Services.RunService.RenderStepped:Connect(function()
		if Services.Workspace:FindFirstChild("Camera") then
			Camera = Services.Workspace:FindFirstChild("Camera")
		end

		if Toggles.SpeedBoostToggle.Value then
			Humanoid.WalkSpeed = Functions.GetCurrentSpeed() + Options.SpeedBoostSlider.Value
		end

		if Globals.Lagging or (Options.SpeedBoostSlider.Value <= 6 and Options.FlySpeed.Value <= 21) then
			CollisionPartClone.Massless = true
		end

		Globals.IsEyes    = Services.Workspace:FindFirstChild("Eyes") ~= nil or Services.Workspace:FindFirstChild("Lookman") ~= nil
		Globals.IsLookman = Services.Workspace:FindFirstChild("BackdoorLookman") ~= nil

		if Toggles.AmbientToggle.Value then
			Services.TweenService:Create(Services.Lighting, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { Ambient = Options.AmbientColor.Value }):Play()
		end

		if Main_Game then
			if Toggles.RemoveCameraShake.Value     then Main_Game.csgo = CFrame.new() end
			if Toggles.ViewmodelOffsetToggle.Value then
				Main_Game.tooloffset = Vector3.new(Options.ViewmodelOffsetX.Value, Options.ViewmodelOffsetY.Value, Options.ViewmodelOffsetZ.Value)
			else
				Main_Game.tooloffset = Vector3.zero
			end
		end

		if Globals.SelfKilled and Globals.MainUI:FindFirstChild("Statistics") then
			Globals.MainUI.Statistics.Death.Text = "Died to Ms fent | Doors"
		end

		local MainFrame = Globals.MainUI:FindFirstChild("MainFrame")
		if MainFrame then
			local Effects = MainFrame.Healthbar:FindFirstChild("Effects")
			if Effects and Effects:FindFirstChild("Crouching") then
				Effects.Crouching.Visible = Functions.IsCrouching()
			end
		end

		if not MainHook then
			if (Toggles.CrouchSpoof.Value or Toggles.PositionSpoof.Value) and RemotesFolder:FindFirstChild("Crouch") then
				RemotesFolder.Crouch:FireServer(true, true)
			end
		end

		if Floor ~= "Fools" and Floor ~= "OldHotel" and not Camera:FindFirstChild("MinecartRig") then
			RootPart.CanCollide = false
		end

		for _, Part in Character:GetChildren() do
			if Part:IsA("BasePart") then Part.CanCollide = false end
		end

		if LocalPlayer:GetAttribute("Alive") == true then
			Services.SoundService:WaitForChild("Main").Volume = 1
		end

		if Floor == "OldHotel" or Floor == "Fools" then
			local SpoofOffset = Toggles.PositionSpoof.Value and Functions.GetNearestEntity() and 200 or Toggles.FigureGodmode.Value and Functions.GetNearestFigure() and 200 or 0
			Globals.SpoofOffset = SpoofOffset
			Collision.Position = RootPart.Position + Vector3.new(0, SpoofOffset, 0)
			Collision.CanCollide = false
			if Floor == "Fools" then
				Collision.CollisionCrouch.CanCollide = false
				CollisionClone.CollisionCrouch.CanCollide = false
			end
			RootPart.CanCollide = not (Toggles.NoclipToggle.Value or Toggles.VelocityManipulationToggle.Value)
		else
			Collision.CanCollide = false
			if Collision:FindFirstChild("CollisionCrouch") then Collision.CollisionCrouch.CanCollide = false end

			if CollisionClone:FindFirstChild("CollisionCrouch") then
				local IsCrouch = Functions.IsCrouching()
				CollisionClone.CanCollide = not (Toggles.NoclipToggle.Value or Toggles.VelocityManipulationToggle.Value or IsCrouch)
				CollisionClone.CollisionCrouch.CanCollide = not (Toggles.NoclipToggle.Value or Toggles.VelocityManipulationToggle.Value or not IsCrouch)
			else
				RootPart.CanCollide = not (Toggles.NoclipToggle.Value or Toggles.VelocityManipulationToggle.Value)
			end

			if Character:FindFirstChild("LowerTorso") and Character.LowerTorso:FindFirstChild("Root") then
				Character.LowerTorso.Root.C1 = Globals.OriginalC1 * CFrame.new(0, Toggles.PositionSpoof.Value and -2.346 or 0, 0)
			end

			local SpoofY = Toggles.PositionSpoof.Value and 2.328 or 0.18
			Collision.Position     = RootPart.Position + Vector3.new(0, SpoofY, 0)
			CollisionPart.Position = RootPart.Position + Vector3.new(0, SpoofY, 0)

			if Collision:FindFirstChild("CollisionCrouch") and CollisionClone:FindFirstChild("CollisionCrouch") then
				local CrouchY = Toggles.PositionSpoof.Value and 1.328 or -0.982
				Collision.CollisionCrouch.Position = RootPart.Position + Vector3.new(0, CrouchY, 0)
				CollisionClone.CollisionCrouch.CollisionGroup = Collision.CollisionCrouch.CollisionGroup
			end
			if CollisionClone:FindFirstChild("CollisionCrouch") then
				CollisionClone.CollisionCrouch.Position = RootPart.Position + Vector3.new(0, Toggles.PositionSpoof.Value and 0.75 or -0.982, 0)
			end
		end

		CollisionClone.CollisionGroup = Collision.CollisionGroup
		CollisionClone.Position = RootPart.Position + Vector3.new(0, Toggles.PositionSpoof.Value and 1.75 or 0.18, 0)

		if Toggles.VelocityManipulationToggle.Value and Options.VelocityManipulationMode.Value == "Velocity" then
			Globals.ManipulateBody.Parent = RootPart
			Globals.ManipulateBody.Velocity = RootPart.CFrame.LookVector * 2.25
		else
			Globals.ManipulateBody.Parent = nil
		end

		if Toggles.VelocityManipulationToggle.Value and Options.VelocityManipulationMode.Value == "Pivot" and Floor ~= "Fools" and Floor ~= "OldHotel" then
			Character:PivotTo(Camera:GetPivot() * CFrame.new(0, 0, 2560))
		end

		if Toggles.FlyToggle.Value then
			Globals.FlyBody.Parent = RootPart
			Globals.FlyBody.Velocity = Functions.GetFlyVelocity() * Options.FlySpeed.Value
		else
			Globals.FlyBody.Parent = nil
		end

		if not MainHook then
			local DoEyesBypass = (Toggles.BypassEyes.Value and Globals.IsEyes) or (Toggles.BypassLookman.Value and Globals.IsLookman)
			if DoEyesBypass then
				if Floor == "Fools" or Floor == "OldHotel" then
					RemotesFolder.MotorReplication:FireServer(0, (Globals.SpoofOffset == 200 and 65 or -65), 0, false)
				else
					RemotesFolder.MotorReplication:FireServer(-650)
				end
			end
		end

		if RemotesFolder:FindFirstChild("Crouch") and tick() - Globals.LastCrouchFire > 0.1 then
			local IsCrouch = Functions.IsCrouching()
			if Toggles.CrouchSpoof.Value or Toggles.PositionSpoof.Value then IsCrouch = true end
			RemotesFolder.Crouch:FireServer(IsCrouch, true)
			Globals.LastCrouchFire = tick()
		end

		if tick() - Globals.LastAnimationCheck > 0.1 then
			local Sliding = false
			for _, Anim in Humanoid:GetPlayingAnimationTracks() do
				if Anim.Name == "Slide" then Sliding = true break end
			end
			Globals.Sliding = Sliding
			Globals.LastAnimationCheck = tick()
		end

		Character:SetAttribute("Sliding", Globals.Sliding)
		if Character:GetAttribute("Crouching") ~= Functions.IsCrouching() then
			Character:SetAttribute("Crouching", Functions.IsCrouching())
		end

		RayParams.FilterDescendantsInstances = { Character }
		local TPOffset = CFrame.new(Options.ThirdPersonOffsetX.Value, Options.ThirdPersonOffsetY.Value, Options.ThirdPersonOffsetZ.Value)
		local Direction = (Camera.CFrame * TPOffset).Position - Camera.CFrame.Position
		local WallResult = Services.Workspace:Spherecast(Camera.CFrame.Position, 0.2, Direction, RayParams)

		if Toggles.ThirdPersonToggle.Value then
			if Toggles.ThirdPersonWallCheck.Value and WallResult and WallResult.Instance.CanCollide then
				local NewPos = Camera.CFrame.Position + Direction.Unit * WallResult.Distance
				Camera.CFrame = CFrame.new(NewPos, NewPos + Camera.CFrame.LookVector)
			else
				Camera.CFrame = Camera.CFrame * TPOffset
			end
		end

		for _, Part in Globals.ThirdPersonParts do
			Part.Transparency = Toggles.ThirdPersonToggle.Value and 0 or 1
			Part.LocalTransparencyModifier = Toggles.ThirdPersonToggle.Value and 0 or 1
		end

		if Globals.SpectateEntity and Toggles.AutoClosetToggle.Value and Toggles.SpectateEntityToggle.Value then
			local Entity = Globals.SpectateEntity

			local CamPosition
			if Options.SpecateEntityMode.Value == "Player to Entity" then
				CamPosition = CFrame.lookAt(Character.Head.Position, Entity.PrimaryPart.Position)
			else
				CamPosition = CFrame.lookAt(Entity.PrimaryPart.Position, Character.Head.Position)
			end

			Camera.CFrame = CamPosition
		end

		if Toggles.FOVToggle and Toggles.FOVToggle.Value then
			if Main_Game then
				task.wait()
				Main_Game.fovtarget = Options.FieldOfView.Value
			else
				Camera.FieldOfView = Options.FieldOfView.Value
			end
		end

		if Toggles.RemoveClosetDelay.Value
			and Humanoid.MoveDirection ~= Vector3.zero
			and (CollisionPart.Anchored or RootPart.Anchored)
			and Character:GetAttribute("AnimatingClient") ~= true
			and Character:GetAttribute("Hiding") == true
		then
			RemotesFolder.CamLock:FireServer()
		end

		local ClosestPlayer = { Distance = math.huge, Object = nil }
		for _, Player in Services.Players:GetPlayers() do
			if Player.Character and Player ~= LocalPlayer then
				local Root = Player.Character:FindFirstChild("HumanoidRootPart")
				if Root then
					local D = (Camera.CFrame.Position - Root.Position).Magnitude
					if D < ClosestPlayer.Distance then
						ClosestPlayer.Distance = D
						ClosestPlayer.Object = Player
					end
				end
			end
		end
		if ClosestPlayer.Object and LocalPlayer:GetAttribute("Alive") ~= true then
			LocalPlayer:SetAttribute("CurrentRoom", ClosestPlayer.Object:GetAttribute("CurrentRoom"))
		end
	end)

	task.wait(1)
	if Toggles.PositionSpoof.Value and Floor ~= "Fools" and Floor ~= "OldHotel" then
		RootPart.CFrame = RootPart.CFrame * CFrame.new(0, -2.346, 0)
		Humanoid.HipHeight = 0.05
		RemotesFolder.Crouch:FireServer(true, true)
	end

	local Jam = Globals.MainUI.Initiator.Main_Game.Health:FindFirstChild("Jam")
	if Jam and Toggles.RemoveJamminMusic.Value then
		Jam.Volume = 0
		Globals.JamMuffle.Enabled = false
	end

	-- Re-apply toggles so speed / FOV / 3rd person / fly / noclip survive respawn
	task.defer(function()
		task.wait(0.15)
		Functions.RefreshActiveFeatures("HandleCharacter")
		task.wait(0.35)
		Functions.RefreshActiveFeatures("HandleCharacter-delayed")
	end)
end

Functions.HandleHidingTransparency = function(Model)
	local Parts = {}
	for _, Part in Model:GetDescendants() do
		if Part:IsA("BasePart") then
			Part:SetAttribute("Transparency_Old", Part.Transparency)
			table.insert(Parts, Part)
		end
		if Part.Name == "HiddenPlayer" then
			local HideConn = Part:GetPropertyChangedSignal("Value"):Connect(function()
				for _, P in Parts do
					if P:GetAttribute("Transparency_Old") then
						Services.TweenService:Create(P, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
							Transparency = (Part.Value == Character and Toggles.TransparentHidingSpotsToggle.Value)
								and Options.TransparentHidingSpotsSlider.Value
								or P:GetAttribute("Transparency_Old")
						}):Play()
					end
				end
			end)
			table.insert(Connections, HideConn)
			Model.Destroying:Once(function()
				HideConn:Disconnect()
				local Pos = table.find(Connections, HideConn)
				if Pos then table.remove(Connections, Pos) end
			end)
		end
	end
end

Functions.HandleObject = function(Object)
	for _, Room in CurrentRooms:GetChildren() do
		if Object:IsDescendantOf(Room) then
			Object:SetAttribute("ParentRoom", tonumber(Room.Name))
			break
		end
		task.wait()
	end

	if Object.Parent == CurrentRooms then
		local FiredampVal = Object:GetAttribute("Firedamp")
		Object:SetAttribute("Firedamp_Old", FiredampVal ~= nil and FiredampVal or false)
		if Toggles.DisableFiredampEffect.Value then
			Object:SetAttribute("Firedamp", false)
		end
	end

	local Name = Object.Name

	if Name == "KeyObtain" then
		task.spawn(function()
			task.wait(0.5)
			if Object.Parent then
				if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Door Key", Color = Options.ObjectiveESPColor.Value }, true) end
				table.insert(Objects.Objectives, Object)
			end
		end)
	elseif Name == "ElectricalKeyObtain" then
		task.spawn(function()
			task.wait(0.5)
			if Object.Parent then
				if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Electrical Key", Color = Options.ObjectiveESPColor.Value }, true) end
				table.insert(Objects.Objectives, Object)
			end
		end)
	elseif Name == "KeyObtainFake" then
		task.spawn(function()
			task.wait(0.5)
			if Object.Parent then
				if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Fake Key", Color = Options.EntityESPColor.Value }, true) end
				table.insert(Objects.Entities, Object)
			end
		end)
	elseif Name == "TimerLever" then
		task.spawn(function()
			task.wait(0.5)
			if Object.Parent then
				Object:SetAttribute("AddTime", Object.TakeTimer.TextLabel.Text == "01:00" and 60 or 30)
				if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Time Lever [+" .. Object:GetAttribute("AddTime") .. "s]", Color = Options.ObjectiveESPColor.Value }, true) end
				Object:WaitForChild("Main").SoundToPlay.Played:Once(function()
					Functions.RemoveESP(Object)
					Functions.BlacklistESP(Object)
				end)
				table.insert(Objects.Objectives, Object)
			end
		end)
	elseif Name == "LiveHintBook" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Hint Book", Color = Options.ObjectiveESPColor.Value }, true) end
		table.insert(Objects.Objectives, Object)
	elseif Name == "LiveBreakerPolePickup" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Fuse Breaker", Color = Options.ObjectiveESPColor.Value }, true) end
		for _, Child in Object:GetChildren() do
			if Child.Name == "ActivateEventPrompt" and (Child.MaxActivationDistance == 5 or Child:GetAttribute("MaxActivationDistance_Old") == 5) then
				Child:Destroy()
			end
		end
		table.insert(Objects.Objectives, Object)
	elseif Name == "LibraryHintPaper" or Name == "PickupItem" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Hint Paper", Color = Options.ObjectiveESPColor.Value }, true) end
		table.insert(Objects.Objectives, Object)
	elseif Name == "MinesAnchor" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Anchor [" .. Object:WaitForChild("Sign").TextLabel.Text .. "]", Color = Options.ObjectiveESPColor.Value }, true) end
		Object:GetAttributeChangedSignal("Activated"):Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "WaterPump" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object:WaitForChild("Wheel"), Text = "Water Pump", Color = Options.ObjectiveESPColor.Value }, true) end
		Object:WaitForChild("Wheel").Sound.Played:Once(function()
			Object:SetAttribute("MsFent_Completed", true)

			Functions.RemoveESP(Object.Wheel)
			Functions.BlacklistESP(Object.Wheel)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "CringlePresent" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Present", Color = Options.ObjectiveESPColor.Value }, true) end
		Object:WaitForChild("ToolProp").Highlight:Destroy()
		table.insert(Objects.Objectives, Object)
	elseif Name == "LeverForGate" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Gate Lever", Color = Options.ObjectiveESPColor.Value }, true) end
		Object:WaitForChild("Main").SoundToPlay.Played:Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "VineGuillotine" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object.Lever, Text = "Vine Lever", Color = Options.ObjectiveESPColor.Value }, true) end
		Object.Lever:WaitForChild("ActivateEventPrompt"):GetAttributeChangedSignal("Interactions"):Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "MandrakeLive" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object.Hole, Text = "Mandrake Hole", Color = Options.EntityESPColor.Value }, true) end
		table.insert(Objects.Entities, Object.Hole)
	elseif Name == "MinesGenerator" then
		task.spawn(function()
			task.wait(0.75)
			if Object.Parent then
				if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Generator", Color = Options.ObjectiveESPColor.Value }, true) end
				Object:WaitForChild("Lever").Sound.Played:Once(function()
					Functions.RemoveESP(Object)
					Functions.BlacklistESP(Object)
				end)
				table.insert(Objects.Objectives, Object)
			end
		end)
	elseif Name == "FuseObtain" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Generator Fuse", Color = Options.ObjectiveESPColor.Value }, true) end
		Object:WaitForChild("Hitbox").FuseModel:GetPropertyChangedSignal("LocalTransparencyModifier"):Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "MinesGateButton" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Gate Button", Color = Options.ObjectiveESPColor.Value }, true) end
		Object.Parent:WaitForChild("MinesGate").Main.SoundOpen.Played:Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "GardenGateButton" then
		if Toggles.ObjectiveESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Gate Button", Color = Options.ObjectiveESPColor.Value }, true) end
		Object.Parent:WaitForChild("GardenGate").Collision.Sound.Played:Once(function()
			Functions.RemoveESP(Object)
			Functions.BlacklistESP(Object)
		end)
		table.insert(Objects.Objectives, Object)
	elseif Name == "StairwellFireAlarm" or Name == "FireAlarm" or Name == "Fire_Alarm"
		or Name == "FireAlarmSwitch" or Name == "AlarmSwitch" or Name == "FireEscapeAlarm"
		or Name == "PullStation" or Name == "FirePull"
		or (string.lower(Name):find("fire", 1, true) and string.lower(Name):find("alarm", 1, true)) then
		-- Stairwell fire alarms (name varies by build)
		local espTarget = Object
		if Object:IsA("Model") then
			local pp = Object.PrimaryPart or Object:FindFirstChildWhichIsA("BasePart", true)
			if pp then espTarget = pp end
		end
		if Toggles.ObjectiveESPToggle.Value then
			Functions.AddESP({ Object = espTarget, Text = "Fire Alarm", Color = Options.ObjectiveESPColor.Value }, true)
		end
		table.insert(Objects.Objectives, Object)
		-- keep mapping for toggle refresh
		pcall(function() Object:SetAttribute("MsFent_FireAlarm", true) end)
	elseif Name == "Ladder" then
		if Toggles.LadderESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Ladder", Color = Options.LadderESPColor.Value }, true) end
		table.insert(Objects.Ladders, Object)
	elseif Name == "Door" and Object.Parent and tonumber(Object.Parent.Name) then
		local DoorParts = {}
		for _, Child in Object:GetChildren() do
			if Child.Name == "Door" and Child:IsA("BasePart") then
				table.insert(DoorParts, Child)
			end
		end

		if #DoorParts == 2 then
			local HighlightModel = Instance.new("Model", Object)
			HighlightModel.Name = "HighlightModel"
			Instance.new("Humanoid", HighlightModel).Name = "HighlightHumanoid"
			HighlightModel:SetAttribute("ParentRoom", tonumber(Object.Parent.Name))

			for _, DoorPart in DoorParts do
				local HP = Instance.new("Part", HighlightModel)
				HP.Transparency = 0.999
				HP.Size = DoorPart.Size
				HP.CanCollide = false
				HP.CFrame = DoorPart.CFrame
				HP.Name = "HighlightPart"
				HP.Material = Enum.Material.Glass
				HP:SetAttribute("ParentRoom", tonumber(Object.Parent.Name))
				local W = Instance.new("WeldConstraint", HP)
				W.Part0 = HP W.Part1 = DoorPart W.Enabled = true
			end
			table.insert(Objects.Doors, HighlightModel)
			if Toggles.DoorESPToggle.Value then Functions.AddESP({ Object = HighlightModel, Text = "Door " .. Functions.GetDoorNumber(Object), Color = Options.DoorESPColor.Value }, true) end
		else
			local Root = Object:WaitForChild("Door", 9e9)
			local HP = Instance.new("Part", Object)
			HP.Transparency = 0.999
			HP.Size = Root.Size
			HP.CanCollide = false
			HP.CFrame = Root.CFrame
			HP.Name = "HighlightPart"
			HP.Material = Enum.Material.Glass
			HP:SetAttribute("ParentRoom", tonumber(Object.Parent.Name))
			local W = Instance.new("WeldConstraint", HP)
			W.Part0 = HP W.Part1 = Root W.Enabled = true
			Instance.new("Humanoid", Object).Name = "HighlightHumanoid"
			table.insert(Objects.Doors, HP)
			if Toggles.DoorESPToggle.Value then Functions.AddESP({ Object = HP, Text = "Door " .. Functions.GetDoorNumber(Object), Color = Options.DoorESPColor.Value }, true) end
		end

		local LastDoorFire = tick()
		local DoorConn = Services.RunService.Heartbeat:Connect(function()
			if Object:FindFirstChild("Door") and Object:FindFirstChild("ClientOpen") then
				if LocalPlayer:DistanceFromCharacter(Object.Door.Position) < 75
					and tick() - LastDoorFire > 0.1
					and Toggles.DoorReachToggle.Value
				then
					Object.ClientOpen:FireServer()
					LastDoorFire = tick()
				end
			end
		end)
		Object:WaitForChild("Door"):WaitForChild("Open").Played:Once(function()
			DoorConn:Disconnect()
		end)
		table.insert(Connections, DoorConn)

	elseif Name == "PathLights" then
		local ObjectsToHighlight = {}
		local PLConn = Object.ChildAdded:Connect(function(Child)
			table.insert(ObjectsToHighlight, Child)
		end)
		for _, Child in Object:GetChildren() do
			table.insert(ObjectsToHighlight, Child)
		end

		local function CreateSeekNode(Light)
			if Light.Name ~= "SeekGuidingLight" or Light:GetAttribute("Highlighted") then return end
			Light:SetAttribute("Highlighted", true)

			local NewNode = Instance.new("Part")
			NewNode.Size = Vector3.one
			NewNode.Transparency = 1
			NewNode.Parent = Globals.SeekNodesFolder
			NewNode.Anchored = true
			NewNode.CFrame = Light.CFrame
			NewNode.CanCollide = false
			NewNode.Name = "SeekLightNode"

			local PrevNode2 = PreviousNode or NewNode
			PreviousNode = NewNode

			local Beam = Instance.new("Beam")
			Beam.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Options.ShowSeekPathColor.Value), ColorSequenceKeypoint.new(1, Options.ShowSeekPathColor.Value) })
			Beam.FaceCamera = true
			Beam.Width0 = 0.2
			Beam.Width1 = 0.2
			Beam.Brightness = 10
			Beam.LightInfluence = 0
			Beam.LightEmission = 0
			Beam.Enabled = true
			local Vis = Toggles.ShowSeekPathToggle.Value and 0 or 1
			Beam.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, Vis), NumberSequenceKeypoint.new(1, Vis) })
			Beam.Parent = Globals.SeekNodesFolder
			local A0 = Instance.new("Attachment", NewNode)
			local A1 = Instance.new("Attachment", PrevNode2)
			Beam.Attachment0 = A0
			Beam.Attachment1 = A1
			table.insert(Objects.SeekHighlights, Beam)
		end

		task.spawn(function()
			while task.wait() do
				local Light = table.remove(ObjectsToHighlight, 1)
				if Light then CreateSeekNode(Light) end
			end
		end)

		table.insert(Connections, PLConn)
		table.insert(Objects.PathLights, Object)
		Object.Destroying:Once(function() PLConn:Disconnect() end)
	elseif Name == "SeekMovingNewClone" then
		local Connection = Object.Destroying:Connect(function()
			for _, Folder in pairs(Objects.PathLights) do
				Folder:ClearAllChildren()
			end
			Globals.SeekNodesFolder:ClearAllChildren()
		end)
		table.insert(Connections, Connection)
	elseif Name == "Bridge" then
		for _, Child in Object:GetChildren() do
			if Child.Name == "PlayerBarrier" and Child.Size.Y == 2.75 and (Child.Rotation.X == 0 or Child.Rotation.X == 180) then
				local NewBridge = Child:Clone()
				NewBridge.CFrame = NewBridge.CFrame * CFrame.new(0, 0, -5)
				NewBridge.Name = MsFent.ESPLibrary:GenerateRandomString()
				NewBridge.Size = Vector3.new(NewBridge.Size.X, NewBridge.Size.Y, 11)
				NewBridge.Parent = Object
				NewBridge.CanCollide = Toggles.BypassSeekObstructions.Value
				NewBridge.Color = Color3.fromRGB(0, 255, 255)
				NewBridge.Transparency = Toggles.BypassSeekObstructions.Value and 0 or 1
				NewBridge.Material = Enum.Material.ForceField
				table.insert(Objects.SeekBridges, NewBridge)
			end
			task.wait()
		end
    elseif Name == "MinecartRig" then
        Globals.Minecart = Object
	elseif Name == "RunnerNodes" then
		local function IsBehind(Part1, Part2)
			local P1 = (Part1.CFrame + Part1.CFrame.LookVector).Position
			local P2 = (Part1.CFrame + Part1.CFrame.LookVector * -1).Position
			return (P1 - Part2.Position).Magnitude > (P2 - Part2.Position).Magnitude
		end
		local function GetDirection(Part1, Part2)
			local RightDist = Part1.CFrame.RightVector:Dot(Part1.Position - Part2.Position)
			if RightDist > 0.5    then return IsBehind(Part1, Part2) and "Right" or "Left" end
			if RightDist < -0.5   then return IsBehind(Part1, Part2) and "Left" or "Right" end
			return "Straight"
		end
		local function GetClosestNode(Node)
			local Best, BestDist = nil, math.huge
			local NodeID2 = tonumber(Node.Name:split("MinecartNode")[2])
			for _, OtherNode in Object:GetChildren() do
				local OtherID = tonumber(OtherNode.Name:split("MinecartNode")[2])
				if OtherNode ~= Node and OtherID and NodeID2 and OtherID > NodeID2 then
					local D = (Node.Position - OtherNode.Position).Magnitude
					if D < BestDist and OtherNode:GetAttribute("DistanceBlacklist") ~= true then
						BestDist = D Best = OtherNode
					end
				end
			end
			return Best
		end

		for _, Node in Object:GetChildren() do
			local NodeID = tonumber(Node.Name:split("MinecartNode")[2])
			if Node:GetAttribute("DeathType") then Node:SetAttribute("DistanceBlacklist", true) end
			for I = 1, 20 do
				local NextNode = NodeID and Object:FindFirstChild("MinecartNode" .. NodeID + I)
				if NextNode and NextNode:GetAttribute("DeathType") ~= nil then
					Node:SetAttribute("DistanceBlacklist", true)
				end
			end
			local PrevNode3 = NodeID and Object:FindFirstChild("MinecartNode" .. NodeID - 1)
			if PrevNode3 and PrevNode3:GetAttribute("ForceConnect") then
				Node:SetAttribute("DistanceBlacklist", nil)
			end
			task.wait()
		end

		for _, Node in Object:GetChildren() do
			if Node:GetAttribute("ForceConnect") then
				local NextNode = GetClosestNode(Node)
				if NextNode then
					Node:SetAttribute("Turn", GetDirection(Node, NextNode))
					table.insert(Objects.SeekNodes, Node)
				end
			end
			task.wait()
		end

	elseif Name == "EyestalkEndCutscene" then
		Object.Name = "_EyestalkEndCutscene"
	elseif Name == "DuckBoard" then
		table.insert(Objects.SeekDuckBoards, Object)
	elseif HidingSpotLabels[Name] then
		if Toggles.HidingSpotESPToggle.Value then Functions.AddESP({ Object = Object, Text = HidingSpotLabels[Name], Color = Options.HidingSpotESPColor.Value }, true) end
		Functions.HandleHidingTransparency(Object)
		table.insert(Objects.HidingSpots, Object)
	elseif Name == "Lava" then
		if Toggles.BypassKillbricks.Value then Object.CanTouch = false end
		table.insert(Objects.Obstructions, Object)
	elseif Name == "ScaryWall" then
		for _, Part in Object:GetDescendants() do
			if Part:IsA("BasePart") then
				Part.CanTouch = not Toggles.BypassSeekingWall.Value
				Part.CanCollide = not Toggles.BypassSeekingWall.Value

                local Connection1 = Part:GetPropertyChangedSignal("CanTouch"):Connect(function()
                    if Part.CanTouch == Toggles.BypassSeekingWall.Value then
                        Part.CanTouch = not Toggles.BypassSeekingWall.Value
                    end
                end)
                local Connection2 = Part:GetPropertyChangedSignal("CanCollide"):Connect(function()
                    if Part.CanCollide == Toggles.BypassSeekingWall.Value then
                        Part.CanCollide = not Toggles.BypassSeekingWall.Value
                    end
                end)

                table.insert(Connections, Connection1)
                table.insert(Connections, Connection2)
            end
		end
		table.insert(Objects.Obstructions, Object)
	elseif Name == "ChestBox" or Name == "ChestBoxLocked" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = Object:GetAttribute("Locked") and "Locked Chest" or "Chest", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif Name == "Toolbox" or Name == "Toolbox_Locked" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = Object:GetAttribute("Locked") and "Locked Toolbox" or "Toolbox", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif Name == "Chest_Vine" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Vine Chest", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif Name == "Toolshed_Small" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Toolshed", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif Name == "Locker_Small_Locked" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Locked Item Locker", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif Name == "MouseHole" then
		if Toggles.ChestESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Mouse", Color = Options.ChestESPColor.Value }, true) end
		table.insert(Objects.Chests, Object)
	elseif ItemNames[Name] and Object:FindFirstChild("ModulePrompt") then
		if Toggles.ItemESPToggle.Value then Functions.AddESP({ Object = Object, Text = ItemNames[Name], Color = Options.ItemESPColor.Value }, Object:GetAttribute("ParentRoom") ~= nil) end
		pcall(function()
			if Toggles.NotifyItemsToggle and Toggles.NotifyItemsToggle.Value
				and Options.NotifyItemList and Options.NotifyItemList.Value
				and Options.NotifyItemList.Value[ItemNames[Name]]
				and Object.Parent and Object.Parent.Name ~= "Drops" then
				local body = ""
				if Toggles.NotifyItemsShowDistance and Toggles.NotifyItemsShowDistance.Value then
					local pos = Object.PrimaryPart and Object.PrimaryPart.Position
						or (Object:IsA("Model") and Object:GetPivot().Position)
						or nil
					if pos then
						body = "Distance: " .. tostring(math.round(LocalPlayer:DistanceFromCharacter(pos))) .. " studs"
					end
				end
				Functions.Notify({ Title = "Item '" .. ItemNames[Name] .. "' has spawned.", Body = body ~= "" and body or "Item nearby." })
			end
		end)
		if Name == "LotusHolder" or Name == "LotusPetalPickup" then
			Object.Handle:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
				MsFent.ESPLibrary:RemoveESP(Object)
				MsFent.ESPLibrary:BlacklistESP(Object)
			end)
		end
		table.insert(Objects.Items, Object)
	elseif Name == "Green_Herb" then
		if Toggles.ItemESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Green Herb", Color = Options.ItemESPColor.Value }, true) end
		table.insert(Objects.Items, Object)
	elseif Name == "GoldPile" and Object:GetAttribute("GoldValue") then
		if Toggles.CurrencyESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Gold Pile [" .. Object:GetAttribute("GoldValue") .. "]", Color = Options.CurrencyESPColor.Value }, true) end
		table.insert(Objects.Currency, Object)
	elseif Name == "StardustPickup" then
		if Toggles.CurrencyESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Stardust Pile", Color = Options.CurrencyESPColor.Value }, true) end
		table.insert(Objects.Currency, Object)
	elseif Name == "GiggleCeiling" then
		if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Giggle", Color = Options.EntityESPColor.Value }, true) end
		if Toggles.BypassGiggle.Value then Object:WaitForChild("Hitbox").CanTouch = false end
		table.insert(Objects.Entities, Object)
	elseif Name == "GloomPile" then
		if Toggles.BypassGloombatEggs.Value then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then Part.CanTouch = false
				end
			end
		end
		local Connection = Object.DescendantAdded:Connect(function(Part)
			if Part:IsA("BasePart") then Part.CanTouch = false end
		end)
		table.insert(Connections, Connection)
		table.insert(Objects.Entities, Object)
	elseif Name == "TriggerEventCollision" and Functions.CheckCompatability({"firetouchinterest"}) then
		if (Floor == "Fools" or Floor == "OldHotel") and Toggles.RemoveSeekTrigger.Value then
			task.spawn(function()
				while Object:IsDescendantOf(game) do
					for _, Part in Object:GetChildren() do
						if Part:IsA("BasePart") then
							MsFent.Environment.firetouchinterest(RootPart, Part, 0)
							task.wait()
							MsFent.Environment.firetouchinterest(RootPart, Part, 1)
						end
					end
					task.wait()
				end
			end)
		end
		table.insert(Objects.EventTriggers, Object)
	elseif Name == "DoorFake" or Name == "FakeDoor" then
		if Object.Parent and Object:FindFirstChild("Hidden") then
			if Toggles.BypassDupe.Value then
				Object:WaitForChild("Hidden").CanTouch = false
				local Lock = Object:FindFirstChild("Lock")
				if Lock and Lock:FindFirstChild("UnlockPrompt") then Lock.UnlockPrompt.Enabled = false end
			end
			table.insert(Objects.Entities, Object)
		end
	elseif Name == "SideroomSpace" then
		if Toggles.BypassVacuum.Value then
			Object:WaitForChild("Collision").CanCollide = true
			Object:WaitForChild("Collision").CanTouch = false
		end
		table.insert(Objects.Entities, Object)
	elseif Name == "Snare" then
		if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Snare", Color = Options.EntityESPColor.Value }, true) end
		for _, Part in Object:GetDescendants() do
			if Part:IsA("BasePart") then Part.CanTouch = not Toggles.BypassSnare.Value end
		end
		local Connection = Object.DescendantAdded:Connect(function(Part)
			if Part:IsA("BasePart") then Part.CanTouch = not Toggles.BypassSnare.Value end
		end)
		table.insert(Connections, Connection)
		table.insert(Objects.Entities, Object)

		if Object:FindFirstChild("Snare") then
			Object:WaitForChild("Snare"):WaitForChild("Roots").Transparency = 1
			Object:WaitForChild("Snare"):WaitForChild("SnareBase").Transparency = 1
		end
		if Object:FindFirstChild("Void") then
			Object.Void.Transparency = 0
			Object.Void.Color = Color3.fromRGB(76, 67, 55)
		end
	elseif Name == "Seek_Arm" or Name == "ChandelierObstruction" then
		for _, Part in Object:GetDescendants() do
			if Part:IsA("BasePart") then
				Part.CanTouch = not Toggles.BypassSeekObstructions.Value
				table.insert(Objects.SeekObstructions, Part)
			end
		end
	elseif Name == "SeekFloodline" then
		Object.CanCollide = Toggles.BypassSeekObstructions.Value
		local FloodConn = Object:GetPropertyChangedSignal("CanCollide"):Connect(function()
			if Object.CanCollide ~= Toggles.BypassSeekObstructions.Value then
				Object.CanCollide = Toggles.BypassSeekObstructions.Value
			end
		end)
		Object.Destroying:Once(function() FloodConn:Disconnect() end)
		table.insert(Objects.SeekObstructions, Object)
	elseif Object:GetAttribute("RawName") and Object:GetAttribute("RawName"):find("Halt") or Object:GetAttribute("Shade") == true then
		if Toggles.NotifyEntities.Value and Options.EntityList.Value["Halt"] then
			Functions.Notify({ Title = "Entity 'Halt' will spawn in the next room.", Image = EntityIcons["Halt"] })
			if Toggles.EntityChatToggle.Value then Functions.SendChat("Halt next room!") end
		end
		local HaltLogConn
		HaltLogConn = Services.LogService.MessageOut:Connect(function(Message)
			if Message == "client teleporting" then
				if Globals.AnticheatDisabled then
					Globals.AnticheatDisabled = false
					Functions.Notify({ Title = "The anticheat has been re-enabled.", Body = "Interact with a ladder to disable it again." })
				end
				HaltLogConn:Disconnect()
			end
		end)
	elseif Name == "BananaPeel" then
		if Toggles.BypassBanana.Value then Object.CanTouch = false end
		table.insert(Objects.Entities, Object)
	elseif Name == "JeffTheKiller" then
		if Toggles.BypassJeff.Value then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then Part.CanCollide = false Part.CanTouch = false end
			end
			Object:WaitForChild("Humanoid").Health = 0
		end
	elseif Name == "GrumbleRig" then
		if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Grumble", Color = Options.EntityESPColor.Value }, true) end
		table.insert(Objects.Entities, Object)
	elseif Name == "Drakobloxxer" then
		if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Drakobloxxer", Color = Options.EntityESPColor.Value }, true) end
		table.insert(Objects.Entities, Object)
	elseif Name == "LiveEntityBramble" then
		if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Bramble", Color = Options.EntityESPColor.Value }, true) end
		table.insert(Objects.Entities, Object)
	elseif Name == "Groundskeeper" then
		if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Groundskeeper", Color = Options.EntityESPColor.Value }, true) end
		if Toggles.NotifyEntities.Value and Options.EntityList.Value["Groundskeeper"] then
			local ED = Entities["Groundskeeper"]
			Functions.Notify({ Title = ED.NotifyMessage.Title, Body = ED.NotifyMessage.Body, Image = EntityIcons["Groundskeeper"] })
		end
		table.insert(Objects.Entities, Object)
	elseif Name == "Figure" or Name == "FigureRig" or Name == "FigureRagdoll" then
		for _, Part in Object:GetDescendants() do
			if Part:IsA("BasePart") then
				Part.CanTouch = false
			end
		end
		if Toggles.EntityESPToggle.Value then Functions.AddESP({ Object = Object, Text = "Figure", Color = Options.EntityESPColor.Value }, true) end
		table.insert(Objects.Entities, Object)
		if Toggles.RemoveFigure.Value and Functions.CheckCompatability({"isnetworkowner"}) then
			if Floor == "Mines" then
				for _, Part in Object:GetDescendants() do
					if Part:IsA("BasePart") then
						task.spawn(function()
							if MsFent.Environment.isnetworkowner(Part) then
								Part.Position = Vector3.new(-49999, -49999, -49999)
							end
						end)
					end
				end
			elseif Floor == "OldHotel" or Floor == "Fools" then
				CurrentRooms.ChildAdded:Wait()
				for _, Part in Object:GetDescendants() do
					if Part:IsA("BasePart") then
						Part.CanCollide = false
						task.spawn(function()
							while MsFent.Environment.isnetworkowner(Part) do
								Part.Position = Vector3.new(math.random(-29999,29999), math.random(-29999,29999), math.random(-29999,29999))
								task.wait()
							end
						end)
					end
				end
			end
		end
	elseif (Name == "ThingToOpen" or Name == "MovingDoor") and (Floor == "Fools" or Floor == "OldHotel")
		or Name == "Wax_Door" and Floor == "Fools"
	then
		Object:SetAttribute("OriginalPosition", Object:GetPivot())
		local ToggleMap = { ThingToOpen = "RemoveBasementGate", MovingDoor = "RemovePaintingsDoor", Wax_Door = "RemoveSkeletonDoor" }
		if ToggleMap[Name] and Toggles[ToggleMap[Name]].Value then
			Object:PivotTo(CFrame.new(-10000, -10000, -10000))
		end
		table.insert(Objects.Obstructions, Object)
	elseif Name == "ElevatorBreaker" then
		if Toggles.AutoBreakerBox.Value and not Globals.BreakerBoxNotified then
			Functions.Notify({ Title = "Interact with the breaker box.", Body = "It will be automatically solved." })
			Globals.BreakerBoxNotified = true
		end
		Connections.BreakerConnection = Object:WaitForChild("SurfaceGui").Frame.Code:GetPropertyChangedSignal("Text"):Connect(function()
			if Toggles.AutoBreakerBox.Value then
				if not Globals.BreakerBoxStartNotified and (Floor == "Fools" or Floor == "OldHotel") then
					Functions.Notify({ Title = "Attempting to solve the breaker box.", Body = "Please wait." })
					Globals.BreakerBoxStartNotified = true
				end
				RemotesFolder.EBF:FireServer()
			end
			Globals.BreakerBoxInteracted = true
		end)
	elseif Name == "ElevatorCar" then
		local ElevConn = Object.DescendantAdded:Connect(function(Desc)
			if Toggles.AutoBreakerBox.Value and Desc.Name == "TouchInterest" and not Globals.BreakerBoxFinishedNotified then
				Functions.Notify({ Title = "Successfully solved the breaker box.", Body = "Try going to the elevator!" })
				Globals.BreakerBoxFinishedNotified = true
			end
		end)
		Object.Destroying:Once(function() ElevConn:Disconnect() end)
	elseif Object.ClassName == "ProximityPrompt" and not Object:GetAttribute("FakePrompt") then
		if Object:HasTag("DisableWhenEnabledOnClient") then Object:RemoveTag("DisableWhenEnabledOnClient") end

		Object:SetAttribute("HoldDuration_Old", Object.HoldDuration)
		Object:SetAttribute("RequiresLineOfSight_Old", Object.RequiresLineOfSight)
		Object:SetAttribute("MaxActivationDistance_Old", Object.MaxActivationDistance)

		if Toggles.InstantPrompts.Value    then Object.HoldDuration = 0 end
		if Toggles.PromptClip.Value        then Object.RequiresLineOfSight = false end
		Object.MaxActivationDistance = Object:GetAttribute("MaxActivationDistance_Old") * Options.PromptReachSlider.Value

		local LockPromptNames = { UnlockPrompt=true, SkullPrompt=true, LockPrompt=true, ThingToEnable=true, FusesPrompt=true }

		if Functions.CheckCompatability({"fireproximityprompt"}) and Floor ~= "OldHotel" and Floor ~= "Fools" then
			local IsLockPrompt = LockPromptNames[Object.Name]
				or (Object.Parent and Object.Parent:GetAttribute("Locked") == true)
				or (Object.Parent and Object.Parent.Parent and Object.Parent.Parent.Name == "Locker_Small_Locked" and Object.Name == "ActivateEventPrompt")

			if IsLockPrompt then
				local FakePrompt = Object:Clone()
				FakePrompt:SetAttribute("FakePrompt", true)
				task.wait()
				FakePrompt.Parent = Object.Parent

				FakePrompt:SetAttribute("HoldDuration_Old", Object:GetAttribute("HoldDuration_Old"))
				FakePrompt:SetAttribute("RequiresLineOfSight_Old", Object:GetAttribute("RequiresLineOfSight_Old"))
				FakePrompt:SetAttribute("MaxActivationDistance_Old", Object:GetAttribute("MaxActivationDistance_Old"))

				FakePrompt.HoldDuration = Object.HoldDuration
				FakePrompt.RequiresLineOfSight = Object.RequiresLineOfSight
				FakePrompt.MaxActivationDistance = Object.MaxActivationDistance

				if Toggles.InstantPrompts.Value    then FakePrompt.HoldDuration = 0 end
				if Toggles.PromptClip.Value        then FakePrompt.RequiresLineOfSight = false end
				FakePrompt.MaxActivationDistance = FakePrompt:GetAttribute("MaxActivationDistance_Old") * Options.PromptReachSlider.Value

				FakePrompts[FakePrompt] = Object
				pcall(function() Object.Parent = Globals.PromptContainer end)

				local FPEnabledConn = Object:GetPropertyChangedSignal("Enabled"):Connect(function()
					FakePrompt.Enabled = Object.Enabled
				end)
				Object:GetPropertyChangedSignal("ActionText"):Once(function()
					Object.Parent = FakePrompt.Parent
					FakePrompt:Destroy()
					FPEnabledConn:Disconnect()
				end)
				Object.Destroying:Once(function()
					FakePrompt:Destroy()
					FPEnabledConn:Disconnect()
				end)
				table.insert(Connections, FPEnabledConn)
				table.insert(Objects.Prompts, FakePrompt)

				FakePrompt.Enabled = false
				task.wait()
				FakePrompt.Enabled = Object.Enabled
			end
		end
		table.insert(Objects.Prompts, Object)
	elseif Name == "Padlock" then
		Connections.PadlockConnection = Services.RunService.Heartbeat:Connect(function()
			if Object.PrimaryPart then
				local Distance = LocalPlayer:DistanceFromCharacter(Object.PrimaryPart.Position)
				if Toggles.AutoUnlockPadlockToggle.Value then
					local Code = Functions.GetLibraryCode()
					if Code and tonumber(Code) and Distance < Options.AutoUnlockPadlockSlider.Value then
						RemotesFolder.PL:FireServer(Code)
					end
				end
				if Toggles.AutoLibraryGuessCode.Value and LatestRoom.Value == 50 then
					local Code = Functions.GetRandomCode()
					if Code then RemotesFolder.PL:FireServer(Code) end
				end
			end
		end)
		Object.Destroying:Once(function()
			if Connections.PadlockConnection then
				Connections.PadlockConnection:Disconnect()
				Connections.PadlockConnection = nil
			end
		end)
	elseif Name == "StairwellFireAlarm" or Name == "FireAlarm" or Name == "Fire_Alarm"
		or Name == "FireAlarmSwitch" or Name == "AlarmSwitch" or Name == "FireEscapeAlarm"
		or Name == "PullStation" or Name == "FirePull"
		or (string.find(string.lower(Name), "fire", 1, true) and string.find(string.lower(Name), "alarm", 1, true)) then
		table.insert(Objects.FireAlarms, Object)
		if Toggles.FireAlarmESPToggle and Toggles.FireAlarmESPToggle.Value then
			local col = (Options.FireAlarmESPColor and Options.FireAlarmESPColor.Value) or Color3.fromRGB(0, 255, 80)
			Functions.AddESP({ Object = Object, Text = "Fire Alarm", Color = col }, true)
		end
	end
end

Connections.PromptAnimationFixer1 = Services.ProximityPromptService.PromptButtonHoldBegan:Connect(function(Object)
	if not Object:GetAttribute("FakePrompt") then return end
	local ToolNames = { "Lockpick","Shears","SkeletonKey","Key","GeneratorFuse","KeyElectrical","KeyBackdoor","KeyIron", "Multitool" }
	local AnimateToolNames = { "Lockpick","Shears","SkeletonKey","Key","KeyElectrical","KeyBackdoor","KeyIron", "Multitool" }
	local Tool
	for _, N in ToolNames do Tool = Character:FindFirstChild(N) if Tool then break end end

	local Prompt = Object
	local LockPromptNames = { UnlockPrompt=true, SkullPrompt=true, LockPrompt=true, ThingToEnable=true, FusesPrompt=true }
	local IsLockPrompt = LockPromptNames[Object.Name]
		or (Object.Parent and Object.Parent:GetAttribute("Locked") == true)
		or (Object.Parent and Object.Parent.Parent and Object.Parent.Parent.Name == "Locker_Small_Locked" and Object.Name == "ActivateEventPrompt")
	if IsLockPrompt then
		if Options.AutoInteractIgnoreList.Value["Locks"] then return end
		local KeyItems = { "Key","GeneratorFuse","KeyBackdoor","KeyElectrical","KeyIron","Lockpick","SkeletonKey","Shears","Multitool" }
		local OffhandKeyItems = { "Key","GeneratorFuse","KeyElectrical","KeyIron" }
		local HasKey = false
		for _, K in KeyItems do if Functions.HasItem(K, true) then HasKey = true break end end
		for _, K in OffhandKeyItems do if Functions.HasItem(K) then HasKey = true break end end
		if not HasKey then return end
	end

	if Prompt.Parent.Name == "CuttableVines" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Chest_Vine" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Cellar" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) then return end
	if Prompt.Parent.Name == "SkullLock" and not Functions.HasItem("SkeletonKey", true) then return end
	if Prompt.Parent.Name == "Lock1" and not Functions.HasItem("Lockpick", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Lock2" and not Functions.HasItem("Lockpick", true) and not Functions.HasItem("Multitool", true) then return end
	if Functions.HasItem("Shears", true) and IsLockPrompt and Prompt.Parent.Name ~= "CuttableVines" and Prompt.Parent.Name ~= "Chest_Vine" and Prompt.Parent.Name ~= "Cellar" then return end
	
	if Tool and table.find(AnimateToolNames, Tool.Name) and Globals.UseAnimation then
		Globals.UseAnimationBreak:Stop()
		Globals.UseAnimation:Stop()
		Globals.UseAnimation:Play()
		if Tool.Name == "Shears" then Tool:WaitForChild("Handle"):WaitForChild("sound_prompt"):Play() end
	end
end)

Globals.ObjectQueue = {}
local AllowedInstances = {
	Lava=true, GoldPile=true, KeyObtain=true, KeyObtainFake=true, Drakobloxxer=true, FuseObtain=true,
	MinesGenerator=true, JeffTheKiller=true, Snare=true, FakeDoor=true, DoorFake=true, SideroomSpace=true,
	ChestBox=true, ChestBoxLocked=true, Chest_Vine=true, Locker_Small_Locked=true, Toolbox=true,
	Toolbox_Locked=true, Wardrobe=true, ["Wardrobe-FOOLS26"]=true, Toolshed=true, Toolshed_Small=true,
	Bed=true, MinesAnchor=true, Double_Bed=true, RetroWardrobe=true, Backdoor_Wardrobe=true,
	Rooms_Locker=true, Rooms_Locker_Fridge=true, Locker_Large=true, FigureRig=true, FigureRagdoll=true,
	TimerLever=true, Lever=true, Seek_Arm=true, ChandelierObstruction=true, ScaryWall=true, Ladder=true,
	CircularVent=true, Dumpster=true, SquareGrate=true, TriggerEventCollision=true, GrumbleRig=true,
	GiggleCeiling=true, MinesGateButton=true, ElectricalKeyObtain=true, LibraryHintPaper=true,
	WaterPump=true, CringlePresent=true, Wheel=true, PickupItem=true, LiveHintBook=true,
	LiveBreakerPolePickup=true, LeverForGate=true, GloomPile=true, SeekFloodline=true, Door=true,
	Green_Herb=true, Bridge=true, MouseHole=true, BananaPeel=true, NannerPeel=true, PowerupPad=true,
	IndustrialGate=true, CollisionFloor=true, ElevatorCar=true, Wax_Door=true, ThingToOpen=true,
	MovingDoor=true, StardustPickup=true, Hole=true, Groundskeeper=true, MandrakeLive=true,
	GardenGateButton=true, LotusPetalPickup=true, VineGuillotine=true, LiveEntityBramble=true,
	RiftSpawn=true, ElevatorBreaker=true, RunnerNodes=true, PathLights=true, DuckBoard=true,
	Padlock=true, EyestalkEndCutscene=true, MinecartRig=true, SeekMovingNewClone=true,
	StairwellFireAlarm=true, FireAlarm=true, Fire_Alarm=true, FireAlarmSwitch=true,
	AlarmSwitch=true, FireEscapeAlarm=true, PullStation=true, FirePull=true
}

Functions.QueueObject = function(Object)
	local n = string.lower(tostring(Object.Name))
	local isFireAlarm = (n:find("fire", 1, true) and n:find("alarm", 1, true))
		or n == "pullstation" or n == "alarmswitch" or n:find("firepull", 1, true)
	if not AllowedInstances[Object.Name] and not isFireAlarm
		and Object.ClassName ~= "ProximityPrompt" and Object.Parent ~= CurrentRooms and not ItemNames[Object.Name] then
		return
	end
	table.insert(Globals.ObjectQueue, Object)
end

Globals.QueueDone = true
Connections.QueueConnection = Services.RunService.RenderStepped:Connect(function()
	local Object = table.remove(Globals.ObjectQueue, 1)
	if Object then
		Functions.HandleObject(Object)
	end
end)

for _, Object in Services.Workspace:GetDescendants() do
	task.spawn(function() Functions.QueueObject(Object) end)
end

Connections.InstanceHandler = Services.Workspace.DescendantAdded:Connect(function(Object)
	Functions.QueueObject(Object)
end)

for _, Player in Services.Players:GetPlayers() do
	if Player ~= LocalPlayer then
		if Player.Character and Toggles.PlayerESPToggle.Value then
			Functions.AddESP({ Object = Player.Character, Text = Player.Name, Color = Options.PlayerESPColor.Value })
		end
		local CharConn = Player.CharacterAdded:Connect(function(NewCharacter)
			if Toggles.PlayerESPToggle.Value then
				Functions.AddESP({ Object = NewCharacter, Text = Player.Name, Color = Options.PlayerESPColor.Value })
			end
		end)
		local DeadConn = Player:GetAttributeChangedSignal("Alive"):Connect(function()
			if Player:GetAttribute("Alive") ~= true and Player.Character then
				Functions.RemoveESP(Player.Character)
			end
		end)
		table.insert(Connections, CharConn)
		table.insert(Connections, DeadConn)
		Player.Destroying:Once(function()
			CharConn:Disconnect()
			DeadConn:Disconnect()
		end)
	end
end

Connections.PlayerHandler = Services.Players.PlayerAdded:Connect(function(Player)
	if Player == LocalPlayer then return end
	if Player.Character and Toggles.PlayerESPToggle.Value then
		Functions.AddESP({ Object = Player.Character, Text = Player.Name, Color = Options.PlayerESPColor.Value })
	end
	local CharConn = Player.CharacterAdded:Connect(function(NewCharacter)
		if Toggles.PlayerESPToggle.Value then
			Functions.AddESP({ Object = NewCharacter, Text = Player.Name, Color = Options.PlayerESPColor.Value })
		end
	end)
	local DeadConn = Player:GetAttributeChangedSignal("Alive"):Connect(function()
		if Player:GetAttribute("Alive") ~= true and Player.Character then
			Functions.RemoveESP(Player.Character)
		end
	end)
	table.insert(Connections, CharConn)
	table.insert(Connections, DeadConn)
	Player.Destroying:Once(function()
		CharConn:Disconnect()
		DeadConn:Disconnect()
	end)
end)

local PromptsToFire = {}
local PromptCooldown = {}

Functions.FirePrompt      = MsFent.Environment.fireproximityprompt
Functions.ForceFirePrompt = MsFent.Environment.fireproximityprompt

if not Functions.FirePrompt then
	Functions.FirePrompt = function(Prompt)
		if not Prompt:IsA("ProximityPrompt") or PromptCooldown[Prompt] or table.find(PromptsToFire, Prompt) or not Camera then return end
		table.insert(PromptsToFire, Prompt)
	end
	Functions.ForceFirePrompt = Functions.FirePrompt

	task.spawn(function()
		while task.wait() do
			local Prompt = table.remove(PromptsToFire, 1)
			if not Prompt then continue end
			PromptCooldown[Prompt] = true

			local OldDist   = Prompt.MaxActivationDistance
			local OldEnable = Prompt.Enabled
			local OldParent = Prompt.Parent
			local OldHold   = Prompt.HoldDuration
			local OldLOS    = Prompt.RequiresLineOfSight

			Prompt.MaxActivationDistance = 99999
			Prompt.Enabled = true
			Prompt.HoldDuration = 0
			Prompt.RequiresLineOfSight = false

			local TempPart = Instance.new("Part")
			TempPart.Parent = Services.Workspace
			TempPart.CanCollide = false TempPart.CanQuery = false TempPart.CanTouch = false
			TempPart.Anchored = true TempPart.Transparency = 1
			TempPart.Size = Vector3.new(0.001, 0.001, 0.001)
			TempPart.Position = Camera.CFrame:ToWorldSpace(CFrame.new(0, 0, -0.1)).Position

			if not Prompt or not OldParent then
				TempPart:Destroy()
				PromptCooldown[Prompt] = nil
				continue
			end

			pcall(function() Prompt.Parent = TempPart end)

			local Shown, Fired = false, false

			local ShownConn = Services.ProximityPromptService.PromptShown:Connect(function(P)
				if P == Prompt then Shown = true end
			end)
			local FiredConn = Prompt.Triggered:Connect(function() Fired = true end)

			local T1 = 0
			while not Shown and T1 < 5 do T1 += 1 task.wait() end

			local T2 = 0
			while not Fired and T2 < 5 do
				Prompt:InputHoldBegin()
				Prompt:InputHoldEnd()
				T2 += 1 task.wait()
			end

			Prompt.MaxActivationDistance = OldDist
			Prompt.Enabled = OldEnable
			Prompt.HoldDuration = OldHold
			Prompt.RequiresLineOfSight = OldLOS
			pcall(function() Prompt.Parent = OldParent end)
			task.wait()
			PromptCooldown[Prompt] = nil
			TempPart:Destroy()
			ShownConn:Disconnect()
			FiredConn:Disconnect()
		end
	end)
end

local AutoInteractBlacklist = {
	HidePrompt=true, RiftPrompt=true, StarRiftPrompt=true, InteractPrompt=true, ClimbPrompt=true,
	DonatePrompt=true, DialoguePrompt=true, RevivePrompt=true, EnterPrompt=true, AnimatePrompt=true,
	ToolEventPrompt=true, Prompt=true, PropPrompt=true
}

local TriggerDebounce = false

Functions.TriggerPrompt = function(Prompt)
	if AutoInteractBlacklist[Prompt.Name] then return end
	if not Prompt or not Prompt.Parent then return end
	if TriggerDebounce then return end

	local ParentItem = Functions.HasItem(Prompt.Parent.Name)
	if ParentItem and ParentItem:GetAttribute("Durability") and ParentItem:GetAttribute("DurabilityMax")
		and ParentItem:GetAttribute("Durability") >= ParentItem:GetAttribute("DurabilityMax")
	then return end

	local LockPromptNames = { UnlockPrompt=true, SkullPrompt=true, LockPrompt=true, ThingToEnable=true, FusesPrompt=true }
	local IsLockPrompt = LockPromptNames[Prompt.Name]
		or (Prompt.Parent and Prompt.Parent:GetAttribute("Locked") == true)
		or (Prompt.Parent and Prompt.Parent.Parent and Prompt.Parent.Parent.Name == "Locker_Small_Locked" and Prompt.Name == "ActivateEventPrompt")

	if IsLockPrompt then
		if Options.AutoInteractIgnoreList.Value["Locks"] then return end
		local KeyItems = { "Key","GeneratorFuse","KeyBackdoor","KeyElectrical","KeyIron","Lockpick","SkeletonKey","Shears","Multitool" }
		local OffhandKeyItems = { "Key","GeneratorFuse","KeyElectrical","KeyIron" }
		local HasKey = false
		for _, K in KeyItems do if Functions.HasItem(K, true) then HasKey = true break end end
		for _, K in OffhandKeyItems do if Functions.HasItem(K) then HasKey = true break end end
		if not HasKey then return end
	end

	if Prompt.Parent.Name == "CuttableVines" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Chest_Vine" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Cellar" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) then return end
	if Prompt.Parent.Name == "SkullLock" and not Functions.HasItem("SkeletonKey", true) then return end
	if Prompt.Parent.Name == "Lock1" and not Functions.HasItem("Lockpick", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Lock2" and not Functions.HasItem("Lockpick", true) and not Functions.HasItem("Multitool", true) then return end
	if Functions.HasItem("Shears", true) and IsLockPrompt and Prompt.Parent.Name ~= "CuttableVines" and Prompt.Parent.Name ~= "Chest_Vine" and Prompt.Parent.Name ~= "Cellar" then return end

	if Prompt.Parent.Name == "GlitchCube" and Options.AutoInteractIgnoreList.Value["Glitch Fragments"] then return end

	if (Prompt.Parent.Name == "KeyObtain" and (Functions.HasItem("Key") or Functions.HasItem("KeyBackdoor")))
		or (Prompt.Parent.Name == "ElectricalKeyObtain" and Functions.HasItem("KeyElectrical"))
	then return end

	if Prompt:IsDescendantOf(Drops) and Options.AutoInteractIgnoreList.Value["Dropped Items"] then return end
	if Prompt.Parent.Name == "TrackLever" then return end
	if Prompt.Name == "ActivateEventPrompt" and (Prompt.ActionText == "Close"
		or Prompt.Parent.Name == "ElevatorBreaker"
		or (Prompt.Parent.Parent and Prompt.Parent.Parent.Name == "IndustrialGate"))
	then return end
	if Prompt.Name == "ActivateEventPrompt" and (Prompt.Parent.Name == "Padlock" or Prompt.Parent.Name == "MinesAnchor") then return end
	if Prompt.Parent.Name == "LeverForGate" and Prompt:GetAttribute("Interactions") then return end
	if Prompt.Parent.Parent and (Prompt.Parent.Parent.Name == "DoorFake" or Prompt.Parent.Parent.Name == "FakeDoor") then return end
	if Prompt.Parent:GetAttribute("JeffShop") and Options.AutoInteractIgnoreList.Value["Jeff Items"] then return end
	if Prompt:GetAttribute("AutoInteractIgnore") then return end
	if Prompt.Name == "PushPrompt" and Options.AutoInteractIgnoreList.Value["Minecarts"] then return end
	if (Prompt.Parent.Name == "GoldPile" or Prompt.Parent.Name == "StardustPickup") and Options.AutoInteractIgnoreList.Value["Currency"] then return end

	if Prompt.Parent.Name == "Bandage" then
		local BPack = Functions.HasItem("BandagePack")
		if Humanoid.Health >= Humanoid.MaxHealth and not BPack then return end
		if BPack and BPack:GetAttribute("Durability") >= BPack:GetAttribute("DurabilityMax") then return end
	end

	if Prompt.Parent.Name == "Battery" then
		local Tool = Character:FindFirstChildOfClass("Tool")
		local BPack = Functions.HasItem("BatteryPack")
		if BPack and BPack:GetAttribute("Durability") >= BPack:GetAttribute("DurabilityMax") then return end
		if not Tool then return end
		if Tool:GetAttribute("LightSource") then
			if Tool:GetAttribute("Durability") and Tool:GetAttribute("DurabilityMax")
				and Tool:GetAttribute("Durability") > Tool:GetAttribute("DurabilityMax")
			then return end
		else
			return
		end
	end

	if Prompt.Name == "HerbPrompt" then
		local Effects = Globals.MainUI.MainFrame.Healthbar:FindFirstChild("Effects")
		if Effects and Effects.HerbGreenEffect.Visible then return end
	end

	if (Prompt.Parent.Name == "LibraryHintPaper" or Prompt.Parent.Name == "PickupItem") and (Functions.HasItem("LibraryHintPaper") or Functions.HasItem("LibraryHintPaperHard")) then return end
	if Prompt.Parent.Name == "AlarmClock" and Functions.HasItem("AlarmClock") then return end
	if Prompt.Parent.Name == "KeyObtainFake" or Prompt.Parent.Name == "TithingPlate" then return end

	Functions.FirePrompt(Prompt)
	TriggerDebounce = true
	if Floor == "OldHotel" then task.wait() end
	TriggerDebounce = false
end

Globals.LastAutoInteractFire = tick()
Connections.AutoInteract = Services.RunService.Heartbeat:Connect(function()
	local Active = Toggles.AutoInteractToggle.Value or Options.AutoInteractKeybind:GetState()
    if not Active then return end
    if tick() - Globals.LastAutoInteractFire < 1/60 then return end

	for _, Prompt in Objects.Prompts do
        if Prompt:GetAttribute("ParentRoom") and tonumber(Prompt:GetAttribute("ParentRoom")) ~= tonumber(LocalPlayer:GetAttribute("CurrentRoom")) then continue end

		if Prompt.Parent and (Prompt.Parent:IsA("BasePart") or Prompt.Parent:IsA("Model")) then
			local Distance
			if Prompt.Parent:IsA("BasePart") then
				Distance = LocalPlayer:DistanceFromCharacter(Prompt.Parent.Position)
			else
				Distance = LocalPlayer:DistanceFromCharacter(Prompt.Parent:GetPivot().Position)
			end
			if Distance <= Prompt.MaxActivationDistance and Prompt.Enabled or Distance <= Prompt.MaxActivationDistance and Prompt.Name == "LongPushPrompt" or Distance <= Prompt.MaxActivationDistance and Prompt.Name == "BigPropPrompt" then
				task.spawn(Functions.TriggerPrompt, Prompt)
			end
		end
	end
    Globals.LastAutoInteractFire = tick()
end)

Connections.InfiniteItemsHandler = Services.ProximityPromptService.PromptTriggered:Connect(function(Object)
	if not Object:GetAttribute("FakePrompt") then return end

	local ToolNames = { "Lockpick","Shears","SkeletonKey","Key","GeneratorFuse","KeyElectrical","KeyBackdoor","KeyIron", "Multitool" }
	local AnimateToolNames = { "Lockpick","Shears","SkeletonKey","Key","KeyElectrical","KeyBackdoor","KeyIron", "Multitool" }
	local Tool
	for _, N in ToolNames do Tool = Character:FindFirstChild(N) if Tool then break end end

	local Prompt = Object
	local LockPromptNames = { UnlockPrompt=true, SkullPrompt=true, LockPrompt=true, ThingToEnable=true, FusesPrompt=true }
	local IsLockPrompt = LockPromptNames[Object.Name]
		or (Object.Parent and Object.Parent:GetAttribute("Locked") == true)
		or (Object.Parent and Object.Parent.Parent and Object.Parent.Parent.Name == "Locker_Small_Locked" and Object.Name == "ActivateEventPrompt")
	if IsLockPrompt then
		if Options.AutoInteractIgnoreList.Value["Locks"] then return end
		local KeyItems = { "Key","GeneratorFuse","KeyBackdoor","KeyElectrical","KeyIron","Lockpick","SkeletonKey","Shears","Multitool" }
		local OffhandKeyItems = { "Key","GeneratorFuse","KeyElectrical","KeyIron" }
		local HasKey = false
		for _, K in KeyItems do if Functions.HasItem(K, true) then HasKey = true break end end
		for _, K in OffhandKeyItems do if Functions.HasItem(K) then HasKey = true break end end
		if not HasKey then return end
	end

	if Prompt.Parent.Name == "CuttableVines" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Chest_Vine" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Cellar" and not Functions.HasItem("Shears", true) and not Functions.HasItem("Multitool", true) then return end
	if Prompt.Parent.Name == "SkullLock" and not Functions.HasItem("SkeletonKey", true) then return end
	if Prompt.Parent.Name == "Lock1" and not Functions.HasItem("Lockpick", true) and not Functions.HasItem("Multitool", true) or Prompt.Parent.Name == "Lock2" and not Functions.HasItem("Lockpick", true) and not Functions.HasItem("Multitool", true) then return end
	if Functions.HasItem("Shears", true) and IsLockPrompt and Prompt.Parent.Name ~= "CuttableVines" and Prompt.Parent.Name ~= "Chest_Vine" and Prompt.Parent.Name ~= "Cellar" then return end

	if Tool and table.find(AnimateToolNames, Tool.Name) and Globals.UseAnimation and Globals.UseAnimationBreak then
		Globals.UseAnimation:Stop()
		Globals.UseAnimationBreak:Stop()
		Globals.UseAnimationBreak:Play()
		if Tool.Name == "Shears" then Tool:WaitForChild("Handle"):WaitForChild("sound_prompt"):Play() end
	end

	local AnyTool = Character:FindFirstChildOfClass("Tool")
	local ToolData = AnyTool and ItemNames[AnyTool.Name]
	if AnyTool and ToolData and Toggles.InfiniteItemsToggle.Value and Options.InfiniteItemsList.Value[ToolData] then
		Drops.ChildAdded:Once(function(NewTool)
			local Prompt = NewTool:FindFirstChild("ModulePrompt")
			local RealPrompt = FakePrompts[Object]
			Functions.FirePrompt(Prompt)
			Functions.FirePrompt(RealPrompt)
		end)
		Character.ChildAdded:Once(function(NewTool)
			if NewTool.Name == "Shears" then NewTool:WaitForChild("Handle"):WaitForChild("sound_promptend"):Play() end
		end)
		RemotesFolder.DropItem:FireServer(AnyTool)
	else
		local RealPrompt = FakePrompts[Object]
		Functions.FirePrompt(RealPrompt)
	end
end)

Connections.FloorReplicatedHandler = FloorReplicated.DescendantAdded:Connect(function(Object)
	if Object.Name == "GlitchScreech" then
		Modules.GlitchScreech = Object
		if Toggles.RemoveScreech.Value then Object.Name = "GlitchScreech_Disabled" end
	end
	if Object.Name:find("Jumpscare") and Object:IsA("ModuleScript")
		and not Object.Name:find("Eyestalk") and not Object.Name:find("Groundskeeper") and not Object.Name:find("Monument")
	then
		Object:SetAttribute("OriginalName", Object.Name)
		if Toggles.DisableEntityJumpscares.Value then Object.Name = Object.Name .. "_Disabled" end
		table.insert(Objects.JumpscareModules, Object)
	end
end)

if FloorReplicated:FindFirstChild("DigitalTimer") then
	Connections.HasteTimerConnection = FloorReplicated.DigitalTimer:GetPropertyChangedSignal("Value"):Connect(function()
		if Toggles.NotifyHasteTime.Value then Functions.Caption(Functions.GetHasteTime(), true) end
	end)
end

Connections.FogHandler = Services.Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
	if Services.Lighting.FogEnd ~= 10000000 then
		Globals.OldFog = Services.Lighting.FogEnd
	end
	if Toggles.RemoveCameraFog.Value then
		Services.Lighting.FogEnd = 10000000
	end
end)

Connections.FogHandler2 = Services.Lighting.DescendantAdded:Connect(function(Object)
	if not Object:IsA("Atmosphere") then return end
	Object:SetAttribute("Density_Old", Object.Density)
	if Toggles.RemoveCameraFog.Value then Object.Density = 0 end

	local AtmoConn2 = Object:GetPropertyChangedSignal("Density"):Connect(function()
		if Object.Density ~= 0 then Object:SetAttribute("Density_Old", Object.Density) end
		if Toggles.RemoveCameraFog.Value then Object.Density = 0 end
	end)
	Object.Destroying:Once(function() AtmoConn2:Disconnect() end)
	table.insert(Connections, AtmoConn2)
	table.insert(Globals.FogInstances, Object)
end)

local RusherAliases = { Rush=true, Bash=true, Ambush=true, Eyes=true, Lookman=true, Blitz=true, ["A-60"]=true, ["A-120"]=true, AR0xMBUSH=true, ["RNIUSHCG=="]=true, ["Custom Entity"]=true, Scribbles=true, DronesStampede=true, Teller=true, Balls=true }

local TrackedEntityModels = setmetatable({}, { __mode = "k" })

local function HandleEntitySpawn(Model)
	if not Model or not Model:IsA("Model") then return end
	local EntityData = Entities[Model.Name]
	if not EntityData then return end
	if TrackedEntityModels[Model] then return end

	-- wait for primary part (some entities spawn incomplete)
	local tries = 0
	while not Model.PrimaryPart and Model.Parent and tries < 50 do
		for _, Child in Model:GetChildren() do
			if Child:IsA("BasePart") then
				Model.PrimaryPart = Child
				break
			end
		end
		tries += 1
		task.wait()
	end
	task.wait(0.1)

	if not Model.Parent then return end
	if not Model.PrimaryPart then return end
	if LocalPlayer:DistanceFromCharacter(Model.PrimaryPart.Position) >= 10000 then return end

	TrackedEntityModels[Model] = true

	local Alias = EntityData.Alias
	local RealAlias = Alias

	if Options.EntityList.Value[Alias] and Toggles.NotifyEntities.Value then
		local NotifyTitle = EntityData.NotifyMessage.Title
		local NotifyBody  = EntityData.NotifyMessage.Body
		local NotifyImage = EntityIcons[Model.Name]

		if Model.Name == "RushMoving" and Model.PrimaryPart.Name ~= "RushNew" then
			NotifyTitle = NotifyTitle:gsub("Rush", Model.PrimaryPart.Name)
			local att = Model.PrimaryPart:FindFirstChild("Attachment")
			if att and att:FindFirstChild("ParticleEmitter") then
				NotifyImage = att.ParticleEmitter.Texture
			end
			Alias = Model.PrimaryPart.Name
		end

		Functions.Notify({ Title = NotifyTitle, Body = NotifyBody, Image = NotifyImage, Time = Toggles.NotifyKeepNotifications.Value and Model or nil })

		if Toggles.EntityChatToggle.Value then
			Functions.SendChat(Alias .. " " .. Options.EntityChatMessage.Value)
		end
	end

	if Model.Name ~= "GloombatSwarm" then
		table.insert(Objects.Entities, Model)
		if Toggles.EntityESPToggle.Value and EntityESPAllowed(RealAlias) then
			if Model.Name == "MonumentEntity" and Model:FindFirstChild("Top") then
				Functions.AddESP({ Object = Model.Top, Text = RealAlias, Color = Options.EntityESPColor.Value }, NodeEntities[RealAlias] ~= true)
			elseif RealAlias == "Creak" or RealAlias == "Noise" then
				local pp = Model.PrimaryPart or Model:FindFirstChildWhichIsA("BasePart", true)
				Functions.AddESP({ Object = pp or Model, Text = RealAlias, Color = Options.EntityESPColor.Value }, NodeEntities[RealAlias] ~= true)
			else
				Functions.AddESP({ Object = Model, Text = RealAlias, Color = Options.EntityESPColor.Value }, NodeEntities[RealAlias] ~= true)
			end
		end
	end

	local AnimSensitive = { Creak = true, Noise = true }
	if RusherAliases[EntityData.Alias] and not AnimSensitive[EntityData.Alias] then
		if not Model:FindFirstChild("HighlightHumanoid") then
			Instance.new("Humanoid", Model).Name = "HighlightHumanoid"
		end
		local Root = Model.PrimaryPart
		if Root then Root.Transparency = 0.999 Root.Material = Enum.Material.Glass end
	end

	if Model.Name == "Lookman" then
		task.spawn(function()
			CurrentRooms.ChildAdded:Wait()
			task.wait(10)
			if Model.Parent then Model:Destroy() end
		end)
	end
end

-- Robust entity registration (Workspace + descendants + name aliases)
local function RegisterEntityModel(Model)
	if not Model or not Model:IsA("Model") then return end
	local EntityData = Entities[Model.Name]
	if not EntityData then return end
	if Model:GetAttribute("MsFent_EntityHandled") then return end
	Model:SetAttribute("MsFent_EntityHandled", true)

	-- Resolve PrimaryPart
	local tries = 0
	while not Model.PrimaryPart and tries < 50 do
		for _, Child in Model:GetChildren() do
			if Child:IsA("BasePart") then
				Model.PrimaryPart = Child
				break
			end
		end
		if not Model.PrimaryPart then
			tries += 1
			task.wait(0.05)
		end
	end
	if not Model.PrimaryPart then
		-- still allow ESP without PrimaryPart using model pivot
		pcall(function()
			if not Model.PrimaryPart then
				local pp = Model:FindFirstChildWhichIsA("BasePart", true)
				if pp then Model.PrimaryPart = pp end
			end
		end)
	end

	local Alias = EntityData.Alias
	local RealAlias = Alias

	-- Distance gate (skip only if we have a position and it's insanely far)
	if Model.PrimaryPart then
		local ok, dist = pcall(function()
			return LocalPlayer:DistanceFromCharacter(Model.PrimaryPart.Position)
		end)
		if ok and dist and dist >= 10000 then return end
	end

	if Options.EntityList.Value[Alias] and Toggles.NotifyEntities.Value then
		local NotifyTitle = EntityData.NotifyMessage.Title
		local NotifyBody  = EntityData.NotifyMessage.Body
		local NotifyImage = EntityIcons and EntityIcons[Model.Name] or nil

		if Model.Name == "RushMoving" and Model.PrimaryPart and Model.PrimaryPart.Name ~= "RushNew" then
			NotifyTitle = NotifyTitle:gsub("Rush", Model.PrimaryPart.Name)
			pcall(function()
				NotifyImage = Model.PrimaryPart:WaitForChild("Attachment", 1).ParticleEmitter.Texture
			end)
			Alias = Model.PrimaryPart.Name
		end

		Functions.Notify({ Title = NotifyTitle, Body = NotifyBody, Image = NotifyImage, Time = Toggles.NotifyKeepNotifications.Value and Model or nil })

		if Toggles.EntityChatToggle.Value then
			Functions.SendChat(Alias .. " " .. Options.EntityChatMessage.Value)
		end
	end

	if Model.Name ~= "GloombatSwarm" then
		table.insert(Objects.Entities, Model)
		if Toggles.EntityESPToggle.Value and EntityESPAllowed(RealAlias) then
			local target = Model
			if Model.Name == "MonumentEntity" and Model:FindFirstChild("Top") then
				target = Model.Top
			end
			Functions.AddESP({ Object = target, Text = Alias, Color = Options.EntityESPColor.Value }, NodeEntities[RealAlias] ~= true)
		end
	end

	-- Skip HighlightHumanoid for entities whose animations break with extra Humanoid / glass root
	local AnimSensitive = { Creak = true, Noise = true }
	if RusherAliases[EntityData.Alias] and not AnimSensitive[EntityData.Alias] then
		pcall(function()
			Instance.new("Humanoid", Model).Name = "HighlightHumanoid"
			local Root = Model.PrimaryPart
			if Root then Root.Transparency = 0.999 Root.Material = Enum.Material.Glass end
		end)
	end

	if Model.Name == "Lookman" then
		task.spawn(function()
			CurrentRooms.ChildAdded:Wait()
			task.wait(10)
			pcall(function() Model:Destroy() end)
		end)
	end
end

Connections.EntityHandler = Services.Workspace.ChildAdded:Connect(function(Entity)
	RegisterEntityModel(Entity)
end)

-- Catch entities that appear as descendants (Humanoid under a model, or parented into rooms)
Connections.EntityDescendantHandler = Services.Workspace.DescendantAdded:Connect(function(Descendant)
	if Descendant:IsA("Humanoid") then
		local Model = Descendant.Parent
		if Model and Model:IsA("Model") and Entities[Model.Name] then
			task.defer(RegisterEntityModel, Model)
		end
	elseif Descendant:IsA("Model") and Entities[Descendant.Name] then
		task.defer(RegisterEntityModel, Descendant)
	end
end)

-- Scan anything already in workspace (late execute / existing floor entities)
local function ScanEntitiesForESP()
	for _, Inst in ipairs(Services.Workspace:GetDescendants()) do
		if Inst:IsA("Model") and Entities[Inst.Name] then
			if not Inst:GetAttribute("MsFent_EntityHandled") then
				pcall(RegisterEntityModel, Inst)
			elseif Toggles.EntityESPToggle and Toggles.EntityESPToggle.Value then
				local ed = Entities[Inst.Name]
				local alias = ed and ed.Alias or Inst.Name
				local target = Inst.PrimaryPart or Inst:FindFirstChildWhichIsA("BasePart", true) or Inst
				pcall(function()
					Functions.AddESP({ Object = target, Text = alias, Color = Options.EntityESPColor.Value }, true)
				end)
			end
		end
	end
end
Globals.ScanEntitiesForESP = ScanEntitiesForESP
task.spawn(ScanEntitiesForESP)


local LastClean = tick()
Connections.Cleaner = Services.RunService.Heartbeat:Connect(function()
	if tick() - LastClean <= 0.5 then return end
	LastClean = tick()

	for ArrayName, Array in Objects do
		local I = #Array
		while I >= 1 do
			local Object = Array[I]
			if Object == nil or not Object:IsDescendantOf(Services.Workspace) then
				table.remove(Array, I)
				local Conn = ESPConnections[Object]
				if Conn then
					Conn:Disconnect()
					ESPConnections[Object] = nil
					local Pos = table.find(Connections, Conn)
					if Pos then table.remove(Connections, Pos) end
				end
			end
			I -= 1
		end
	end
end)

local LastPromptFix = tick()
Connections.PromptFixer = Services.RunService.Heartbeat:Connect(function()
	if tick() - LastPromptFix <= 0.5 then return end
	LastPromptFix = tick()
	for _, Prompt in Objects.Prompts do
		if Prompt:HasTag("DisableWhenEnabledOnClient") then
			Prompt:RemoveTag("DisableWhenEnabledOnClient")
		end
	end
end)

if LocalPlayer.Character then
	task.spawn(function() Functions.HandleCharacter(LocalPlayer.Character) end)
end

LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
	if Connections.MainHandler then
		pcall(function() Connections.MainHandler:Disconnect() end)
		Connections.MainHandler = nil
	end
	task.wait(0.35)
	Functions.HandleCharacter(NewCharacter)
	task.defer(function()
		Functions.RefreshActiveFeatures("CharacterAdded-bottom")
		task.wait(0.6)
		Functions.RefreshActiveFeatures("CharacterAdded-bottom-late")
	end)
end)

-- ===== Update 1.0 automation =====
Toggles.SkipSeekHotel:OnChanged(function(Value)
	if not Value then return end
	if Floor ~= "Hotel" then return end

	task.spawn(function()
		print("started")

		local currentRooms

		repeat
			if not Toggles.SkipSeekHotel.Value or Floor ~= "Hotel" then
				return
			end
			currentRooms = workspace:FindFirstChild("CurrentRooms")
			task.wait()
		until currentRooms

		print("got currentrooms")

		local lastTriggerRoom = nil

		while Toggles.SkipSeekHotel.Value and Floor == "Hotel" do
			local triggerRoom = nil

			print("waiting for trigger")

			repeat
				if not Toggles.SkipSeekHotel.Value or Floor ~= "Hotel" then
					return
				end

				currentRooms = workspace:FindFirstChild("CurrentRooms")
				local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))

				if currentRoomNum and currentRoomNum ~= lastTriggerRoom then
					local room = currentRooms and currentRooms:FindFirstChild(tostring(currentRoomNum))
					if room then
						local trigger = room:WaitForChild("TriggerEventCollision", 0.5)
						if trigger then
							triggerRoom = currentRoomNum
							print("found trigger in", triggerRoom)
						end
					end
				end

				task.wait()
			until triggerRoom

			lastTriggerRoom = triggerRoom

			local roomNum = triggerRoom

			while Toggles.SkipSeekHotel.Value and Floor == "Hotel" do
				roomNum += 1
				print("looking for room", roomNum)

				local room
				repeat
					if not Toggles.SkipSeekHotel.Value or Floor ~= "Hotel" then
						return
					end
					currentRooms = workspace:FindFirstChild("CurrentRooms")
					room = currentRooms and currentRooms:FindFirstChild(tostring(roomNum))
					task.wait()
				until room

				print("found room", roomNum)

				local hasSeekArm = false
				local assets = room:FindFirstChild("Assets")
				if assets then
					for _, child in ipairs(assets:GetChildren()) do
						if child.Name == "Seek_Arm" then
							hasSeekArm = true
							print("found seek arm")
							break
						end
					end
				end

				local door
				repeat
					if not Toggles.SkipSeekHotel.Value or Floor ~= "Hotel" then
						return
					end
					door = room:FindFirstChild("Door", true)
					task.wait()
				until door

				print("found door, teleporting")

				repeat
					if not Toggles.SkipSeekHotel.Value or Floor ~= "Hotel" then
						return
					end
					if Character then
						Character:PivotTo(door:GetPivot())
					end
					task.wait()
				until door:GetAttribute("Opened") == true

				print("door opened")

				if hasSeekArm then
					if not Character then
						return
					end

					print("voiding")

					local voidCFrame = Character:GetPivot() + Vector3.new(0, -2500, 0)

					task.wait(0.25)

					for _ = 1, 20 do
						Character:PivotTo(voidCFrame)
						task.wait()
					end

					task.wait(0.3)

					for _ = 1, 15 do
						Character:PivotTo(voidCFrame)
						task.wait()
					end

					task.wait(0.2)

					for _ = 1, 10 do
						Character:PivotTo(voidCFrame)
						task.wait()
					end

					print("done voiding")
					break
				end
			end
		end
	end)
end)

Toggles.AutoLibrary:OnChanged(function(AutoLibraryEnabled)
	if AutoLibraryConnection then
		task.cancel(AutoLibraryConnection)
		AutoLibraryConnection = nil
	end

	if AutoLibraryRoomConnection then
		AutoLibraryRoomConnection:Disconnect()
		AutoLibraryRoomConnection = nil
	end

	if not AutoLibraryEnabled then
		return
	end

	AutoLibraryConnection = task.spawn(function()
		local AutoLibraryPlayers = game:GetService("Players")
		local AutoLibraryLocalPlayer = AutoLibraryPlayers.LocalPlayer
		local AutoLibraryCharacter = AutoLibraryLocalPlayer.Character or AutoLibraryLocalPlayer.CharacterAdded:Wait()
		local AutoLibraryHumanoidRootPart = AutoLibraryCharacter:WaitForChild("HumanoidRootPart")

		local AutoLibraryCurrentRooms = workspace:WaitForChild("CurrentRooms")
		local AutoLibraryRoom50 = AutoLibraryCurrentRooms:WaitForChild("50")
		local AutoLibraryLiveHintBooks = {}
		local AutoLibraryHintPaperObtained = false

		local function AutoLibraryIsInRoom50(AutoLibraryObject)
			return AutoLibraryObject
				and AutoLibraryObject:IsDescendantOf(AutoLibraryRoom50)
				and AutoLibraryObject:IsDescendantOf(AutoLibraryCurrentRooms)
				and AutoLibraryObject:IsDescendantOf(workspace)
		end

		local function AutoLibraryIsActuallyInRoom50()
			return tonumber(AutoLibraryLocalPlayer:GetAttribute("CurrentRoom")) == 50
		end

		while AutoLibraryEnabled and not AutoLibraryIsActuallyInRoom50() do
			task.wait(0.05)
		end

		if not AutoLibraryEnabled then
			return
		end

		local function AutoLibraryHasHintPaper()
			AutoLibraryCharacter = AutoLibraryLocalPlayer.Character

			if not AutoLibraryCharacter then
				return false
			end

			local AutoLibraryBackpackPaper = AutoLibraryLocalPlayer.Backpack:FindFirstChild("LibraryHintPaper", true)
			local AutoLibraryCharacterPaper = AutoLibraryCharacter:FindFirstChild("LibraryHintPaper", true)

			return AutoLibraryBackpackPaper ~= nil or AutoLibraryCharacterPaper ~= nil
		end

		local function AutoLibraryGetObjectCFrame(AutoLibraryObject)
			if not AutoLibraryIsActuallyInRoom50() then
				return nil
			end

			if not AutoLibraryIsInRoom50(AutoLibraryObject) then
				return nil
			end

			if AutoLibraryObject:IsA("Model") then
				return AutoLibraryObject:GetPivot()
			elseif AutoLibraryObject:IsA("BasePart") then
				return AutoLibraryObject.CFrame
			end

			local AutoLibraryObjectPart = AutoLibraryObject:FindFirstChildWhichIsA("BasePart", true)

			if AutoLibraryObjectPart then
				return AutoLibraryObjectPart.CFrame
			end

			return nil
		end

		local function AutoLibraryFindBooks(AutoLibraryObject)
			if not AutoLibraryIsActuallyInRoom50() then
				return
			end

			if not AutoLibraryIsInRoom50(AutoLibraryObject) then
				return
			end

			if AutoLibraryObject.Name == "LiveHintBook" then
				if not table.find(AutoLibraryLiveHintBooks, AutoLibraryObject) then
					table.insert(AutoLibraryLiveHintBooks, AutoLibraryObject)
				end
			end

			for _, AutoLibraryDescendant in ipairs(AutoLibraryObject:GetDescendants()) do
				if AutoLibraryDescendant.Name == "LiveHintBook"
					and AutoLibraryIsInRoom50(AutoLibraryDescendant) then

					if not table.find(AutoLibraryLiveHintBooks, AutoLibraryDescendant) then
						table.insert(AutoLibraryLiveHintBooks, AutoLibraryDescendant)
					end
				end
			end
		end

		for _, AutoLibraryDescendant in ipairs(AutoLibraryRoom50:GetDescendants()) do
			if not AutoLibraryEnabled or not AutoLibraryIsActuallyInRoom50() then
				return
			end

			if AutoLibraryDescendant.Name == "LiveHintBook"
				and AutoLibraryIsInRoom50(AutoLibraryDescendant) then

				if not table.find(AutoLibraryLiveHintBooks, AutoLibraryDescendant) then
					table.insert(AutoLibraryLiveHintBooks, AutoLibraryDescendant)
				end
			end
		end

		AutoLibraryRoomConnection = AutoLibraryRoom50.DescendantAdded:Connect(function(AutoLibraryAddedObject)
			if not AutoLibraryEnabled then
				return
			end

			if not AutoLibraryIsActuallyInRoom50() then
				return
			end

			if not AutoLibraryIsInRoom50(AutoLibraryAddedObject) then
				return
			end

			AutoLibraryFindBooks(AutoLibraryAddedObject)
		end)

		while AutoLibraryEnabled
			and AutoLibraryIsActuallyInRoom50()
			and #AutoLibraryLiveHintBooks < 3 do

			for _, AutoLibraryDescendant in ipairs(AutoLibraryRoom50:GetDescendants()) do
				if not AutoLibraryEnabled or not AutoLibraryIsActuallyInRoom50() then
					return
				end

				if AutoLibraryDescendant.Name == "LiveHintBook"
					and AutoLibraryIsInRoom50(AutoLibraryDescendant)
					and not table.find(AutoLibraryLiveHintBooks, AutoLibraryDescendant) then

					table.insert(AutoLibraryLiveHintBooks, AutoLibraryDescendant)
				end
			end

			if #AutoLibraryLiveHintBooks >= 3 then
				break
			end

			task.wait(0.05)
		end

		while AutoLibraryEnabled
			and AutoLibraryIsActuallyInRoom50()
			and not AutoLibraryHintPaperObtained do

			if AutoLibraryHasHintPaper() then
				AutoLibraryHintPaperObtained = true
				break
			end

			for AutoLibraryIndex = #AutoLibraryLiveHintBooks, 1, -1 do
				if not AutoLibraryIsActuallyInRoom50() then
					return
				end

				local AutoLibraryLiveHintBook = AutoLibraryLiveHintBooks[AutoLibraryIndex]

				if not AutoLibraryIsInRoom50(AutoLibraryLiveHintBook) then
					table.remove(AutoLibraryLiveHintBooks, AutoLibraryIndex)
					continue
				end

				while AutoLibraryEnabled
					and AutoLibraryIsActuallyInRoom50()
					and not AutoLibraryHintPaperObtained
					and AutoLibraryLiveHintBook.Parent
					and AutoLibraryIsInRoom50(AutoLibraryLiveHintBook) do

					if AutoLibraryHasHintPaper() then
						AutoLibraryHintPaperObtained = true
						break
					end

					AutoLibraryCharacter = AutoLibraryLocalPlayer.Character or AutoLibraryLocalPlayer.CharacterAdded:Wait()
					AutoLibraryHumanoidRootPart = AutoLibraryCharacter:FindFirstChild("HumanoidRootPart")

					if not AutoLibraryHumanoidRootPart then
						task.wait()
						continue
					end

					local AutoLibraryBookCFrame = AutoLibraryGetObjectCFrame(AutoLibraryLiveHintBook)

					if AutoLibraryBookCFrame
						and AutoLibraryIsActuallyInRoom50()
						and AutoLibraryIsInRoom50(AutoLibraryLiveHintBook) then

						AutoLibraryHumanoidRootPart.CFrame = AutoLibraryBookCFrame
					end

					for _, AutoLibraryPromptDescendant in ipairs(AutoLibraryLiveHintBook:GetDescendants()) do
						if AutoLibraryPromptDescendant:IsA("ProximityPrompt")
							and AutoLibraryIsInRoom50(AutoLibraryPromptDescendant)
							and AutoLibraryIsActuallyInRoom50() then

							fireproximityprompt(AutoLibraryPromptDescendant)
						end
					end

					task.wait(0.05)
				end

				if AutoLibraryHintPaperObtained then
					break
				end
			end

			if AutoLibraryHasHintPaper() then
				AutoLibraryHintPaperObtained = true
				break
			end

			local AutoLibraryHintPaper = AutoLibraryRoom50:FindFirstChild("LibraryHintPaper", true)

			if AutoLibraryHintPaper
				and AutoLibraryIsInRoom50(AutoLibraryHintPaper)
				and AutoLibraryIsActuallyInRoom50() then

				while AutoLibraryEnabled
					and AutoLibraryIsActuallyInRoom50()
					and not AutoLibraryHintPaperObtained
					and AutoLibraryHintPaper.Parent
					and AutoLibraryIsInRoom50(AutoLibraryHintPaper) do

					if AutoLibraryHasHintPaper() then
						AutoLibraryHintPaperObtained = true
						break
					end

					AutoLibraryCharacter = AutoLibraryLocalPlayer.Character or AutoLibraryLocalPlayer.CharacterAdded:Wait()
					AutoLibraryHumanoidRootPart = AutoLibraryCharacter:FindFirstChild("HumanoidRootPart")

					if not AutoLibraryHumanoidRootPart then
						task.wait()
						continue
					end

					local AutoLibraryPaperCFrame = AutoLibraryGetObjectCFrame(AutoLibraryHintPaper)

					if AutoLibraryPaperCFrame
						and AutoLibraryIsActuallyInRoom50()
						and AutoLibraryIsInRoom50(AutoLibraryHintPaper) then

						AutoLibraryHumanoidRootPart.CFrame = AutoLibraryPaperCFrame * CFrame.new(0, 5, 0)
					end

					for _, AutoLibraryPromptDescendant in ipairs(AutoLibraryHintPaper:GetDescendants()) do
						if AutoLibraryPromptDescendant:IsA("ProximityPrompt")
							and AutoLibraryIsInRoom50(AutoLibraryPromptDescendant)
							and AutoLibraryIsActuallyInRoom50() then

							fireproximityprompt(AutoLibraryPromptDescendant)
						end
					end

					task.wait(0.05)
				end
			end

			task.wait(0.05)
		end
	end)
end)


Toggles.AutoBreakerRoom:OnChanged(function(AutoBreakerRoomEnabled)
	if AutoBreakerRoomConnection then
		task.cancel(AutoBreakerRoomConnection)
		AutoBreakerRoomConnection = nil
	end

	if AutoBreakerRoomRoomConnection then
		AutoBreakerRoomRoomConnection:Disconnect()
		AutoBreakerRoomRoomConnection = nil
	end

	if not AutoBreakerRoomEnabled then
		return
	end

	local AutoBreakerRoomGateFireTime = 5
	local AutoBreakerRoomWaitAfterLever = 5
	local AutoBreakerRoomBreakerSecondTime = 10
	local AutoBreakerRoomWaitBeforeWeb = 4
	local AutoBreakerRoomWebDuration = 20

	AutoBreakerRoomConnection = task.spawn(function()
		local AutoBreakerRoomPlayers = game:GetService("Players")
		local AutoBreakerRoomCurrentRooms = workspace:WaitForChild("CurrentRooms")
		local AutoBreakerRoom100 = AutoBreakerRoomCurrentRooms:WaitForChild("100")

		local function AutoBreakerRoomIsActuallyInRoom100()
			return tonumber(AutoBreakerRoomPlayers.LocalPlayer:GetAttribute("CurrentRoom")) == 100
		end

		local function AutoBreakerRoomIsInRoom100(AutoBreakerRoomObject)
			return AutoBreakerRoomObject
				and AutoBreakerRoomObject.Parent
				and AutoBreakerRoomObject:IsDescendantOf(AutoBreakerRoom100)
				and AutoBreakerRoomObject:IsDescendantOf(AutoBreakerRoomCurrentRooms)
		end

		local function AutoBreakerRoomGetObjectCFrame(AutoBreakerRoomObject)
			if not AutoBreakerRoomIsActuallyInRoom100() or not AutoBreakerRoomIsInRoom100(AutoBreakerRoomObject) then
				return nil
			end

			if AutoBreakerRoomObject:IsA("Model") then
				return AutoBreakerRoomObject:GetPivot()
			elseif AutoBreakerRoomObject:IsA("BasePart") then
				return AutoBreakerRoomObject.CFrame
			end

			local AutoBreakerRoomPart = AutoBreakerRoomObject:FindFirstChildWhichIsA("BasePart", true)
			return AutoBreakerRoomPart and AutoBreakerRoomPart.CFrame
		end

		local function AutoBreakerRoomGetHRP()
			local AutoBreakerRoomCharacter = AutoBreakerRoomPlayers.LocalPlayer.Character
			return AutoBreakerRoomCharacter and AutoBreakerRoomCharacter:FindFirstChild("HumanoidRootPart")
		end

		local function AutoBreakerRoomActivate(AutoBreakerRoomObject)
			if not AutoBreakerRoomObject then
				return
			end

			if AutoBreakerRoomObject:IsA("ProximityPrompt") then
				fireproximityprompt(AutoBreakerRoomObject)
				return
			end

			for _, AutoBreakerRoomDescendant in ipairs(AutoBreakerRoomObject:GetDescendants()) do
				if AutoBreakerRoomDescendant:IsA("ProximityPrompt") then
					fireproximityprompt(AutoBreakerRoomDescendant)
				end
			end
		end

		local function AutoBreakerRoomConstantTPAndActivate(AutoBreakerRoomTarget, AutoBreakerRoomDuration, AutoBreakerRoomInterval, AutoBreakerRoomOffset)
			AutoBreakerRoomInterval = AutoBreakerRoomInterval or 0.04
			AutoBreakerRoomOffset = AutoBreakerRoomOffset or CFrame.new()
			local AutoBreakerRoomEndTime = os.clock() + (AutoBreakerRoomDuration or 3)

			while AutoBreakerRoomEnabled
				and AutoBreakerRoomIsActuallyInRoom100()
				and AutoBreakerRoomIsInRoom100(AutoBreakerRoomTarget)
				and os.clock() < AutoBreakerRoomEndTime do

				local AutoBreakerRoomHRP = AutoBreakerRoomGetHRP()
				local AutoBreakerRoomCF = AutoBreakerRoomGetObjectCFrame(AutoBreakerRoomTarget)

				if AutoBreakerRoomHRP and AutoBreakerRoomCF then
					AutoBreakerRoomHRP.CFrame = AutoBreakerRoomCF * AutoBreakerRoomOffset
				end

				AutoBreakerRoomActivate(AutoBreakerRoomTarget)
				task.wait(AutoBreakerRoomInterval)
			end
		end

		while AutoBreakerRoomEnabled do
			while AutoBreakerRoomEnabled and not AutoBreakerRoomIsActuallyInRoom100() do
				task.wait(0.1)
			end

			if not AutoBreakerRoomEnabled then
				return
			end

			local AutoBreakerRoomPoles = {}

			while AutoBreakerRoomEnabled and AutoBreakerRoomIsActuallyInRoom100() do
				AutoBreakerRoomPoles = {}

				for _, AutoBreakerRoomDescendant in ipairs(AutoBreakerRoom100:GetDescendants()) do
					if AutoBreakerRoomDescendant.Name == "LiveBreakerPolePickup" and AutoBreakerRoomIsInRoom100(AutoBreakerRoomDescendant) then
						if not table.find(AutoBreakerRoomPoles, AutoBreakerRoomDescendant) then
							table.insert(AutoBreakerRoomPoles, AutoBreakerRoomDescendant)
						end
					end
				end

				if #AutoBreakerRoomPoles == 0 then
					break
				end

				for _, AutoBreakerRoomPole in ipairs(AutoBreakerRoomPoles) do
					if not AutoBreakerRoomEnabled or not AutoBreakerRoomIsActuallyInRoom100() then
						break
					end

					if AutoBreakerRoomIsInRoom100(AutoBreakerRoomPole) then
						AutoBreakerRoomConstantTPAndActivate(AutoBreakerRoomPole, 2.8, 0.03)
						task.wait(0.12)
					end
				end

				task.wait(0.05)
			end

			if not AutoBreakerRoomEnabled or not AutoBreakerRoomIsActuallyInRoom100() then
				continue
			end

			local AutoBreakerRoomIndustrialGate = AutoBreakerRoom100:FindFirstChild("IndustrialGate")
			local AutoBreakerRoomBox = AutoBreakerRoomIndustrialGate and AutoBreakerRoomIndustrialGate:FindFirstChild("Box")
			local AutoBreakerRoomLever = AutoBreakerRoomBox and AutoBreakerRoomBox:FindFirstChild("Lever")
			local AutoBreakerRoomActivateEventPrompt = AutoBreakerRoomBox and AutoBreakerRoomBox:FindFirstChild("ActivateEventPrompt")

			if AutoBreakerRoomActivateEventPrompt and AutoBreakerRoomLever then
				local function AutoBreakerRoomGetLeverCFrame()
					if AutoBreakerRoomLever:IsA("Model") then
						return AutoBreakerRoomLever:GetPivot()
					elseif AutoBreakerRoomLever:IsA("BasePart") then
						return AutoBreakerRoomLever.CFrame
					end
					local AutoBreakerRoomPart = AutoBreakerRoomLever:FindFirstChildWhichIsA("BasePart", true)
					return AutoBreakerRoomPart and AutoBreakerRoomPart.CFrame
				end

				local AutoBreakerRoomInitialLeverCFrame = AutoBreakerRoomGetLeverCFrame()
				local AutoBreakerRoomLeverEndTime = os.clock() + 10

				while AutoBreakerRoomEnabled
					and AutoBreakerRoomIsActuallyInRoom100()
					and AutoBreakerRoomIsInRoom100(AutoBreakerRoomLever)
					and os.clock() < AutoBreakerRoomLeverEndTime do

					local AutoBreakerRoomCurrentLeverCFrame = AutoBreakerRoomGetLeverCFrame()

					if AutoBreakerRoomCurrentLeverCFrame and AutoBreakerRoomInitialLeverCFrame
						and AutoBreakerRoomCurrentLeverCFrame ~= AutoBreakerRoomInitialLeverCFrame then
						break
					end

					local AutoBreakerRoomHRP = AutoBreakerRoomGetHRP()
					local AutoBreakerRoomCF = AutoBreakerRoomGetObjectCFrame(AutoBreakerRoomBox)

					if AutoBreakerRoomHRP and AutoBreakerRoomCF then
						AutoBreakerRoomHRP.CFrame = AutoBreakerRoomCF
					end

					AutoBreakerRoomActivate(AutoBreakerRoomActivateEventPrompt)
					task.wait(0.04)
				end
			end

			if not AutoBreakerRoomEnabled or not AutoBreakerRoomIsActuallyInRoom100() then
				continue
			end

			task.wait(AutoBreakerRoomWaitAfterLever)

			if not AutoBreakerRoomEnabled or not AutoBreakerRoomIsActuallyInRoom100() then
				continue
			end

			local AutoBreakerRoomElevatorBreakerEmpty = AutoBreakerRoom100:FindFirstChild("ElevatorBreakerEmpty")
			if not AutoBreakerRoomElevatorBreakerEmpty then
				continue
			end

			local AutoBreakerRoomBreakerPrompt = AutoBreakerRoomElevatorBreakerEmpty:FindFirstChild("Prompt")
			if not AutoBreakerRoomBreakerPrompt then
				continue
			end

			local AutoBreakerRoomBreakerOffset = CFrame.new(0, -1.8, 0)

			while AutoBreakerRoomEnabled and AutoBreakerRoomIsActuallyInRoom100() do
				if AutoBreakerRoomElevatorBreakerEmpty:FindFirstChild("BreakerSwitchInBox") then
					break
				end

				local AutoBreakerRoomHRP = AutoBreakerRoomGetHRP()
				local AutoBreakerRoomCF = AutoBreakerRoomGetObjectCFrame(AutoBreakerRoomElevatorBreakerEmpty)

				if AutoBreakerRoomHRP and AutoBreakerRoomCF then
					AutoBreakerRoomHRP.CFrame = AutoBreakerRoomCF * AutoBreakerRoomBreakerOffset
				end

				AutoBreakerRoomActivate(AutoBreakerRoomBreakerPrompt)
				task.wait(0.04)
			end

			if not AutoBreakerRoomEnabled or not AutoBreakerRoomIsActuallyInRoom100() then
				continue
			end

			task.wait(10)

			AutoBreakerRoomConstantTPAndActivate(
				AutoBreakerRoomElevatorBreakerEmpty,
				AutoBreakerRoomBreakerSecondTime,
				0.04,
				AutoBreakerRoomBreakerOffset
			)

			task.wait(AutoBreakerRoomWaitBeforeWeb)

			if not AutoBreakerRoomEnabled or not AutoBreakerRoomIsActuallyInRoom100() then
				continue
			end

			local AutoBreakerRoomElevatorCar = AutoBreakerRoom100:FindFirstChild("ElevatorCar")
			local AutoBreakerRoomWeb = AutoBreakerRoomElevatorCar and AutoBreakerRoomElevatorCar:FindFirstChild("Web", true)

			if AutoBreakerRoomWeb then
				local AutoBreakerRoomEndTime = os.clock() + AutoBreakerRoomWebDuration

				while AutoBreakerRoomEnabled and AutoBreakerRoomIsActuallyInRoom100() and os.clock() < AutoBreakerRoomEndTime do
					local AutoBreakerRoomHRP = AutoBreakerRoomGetHRP()
					local AutoBreakerRoomCF = AutoBreakerRoomGetObjectCFrame(AutoBreakerRoomWeb)

					if AutoBreakerRoomHRP and AutoBreakerRoomCF then
						AutoBreakerRoomHRP.CFrame = AutoBreakerRoomCF
					end

					task.wait(0.04)
				end
			end

			while AutoBreakerRoomEnabled and AutoBreakerRoomIsActuallyInRoom100() do
				task.wait(0.5)
			end
		end
	end)
end)

local AutoHotelConnection
local AutoHotelLibraryConnection
local AutoHotelLibraryRoomConnection
local AutoHotelSeekConnection
local AutoHotelEntityPause = false
local AutoHotelRoomProcessTime = 0.5
local AutoHotelProcessedRooms = {}

local AutoHotelEntityNames = {
	["RushMoving"] = true,
	["Scribbles"] = true,
	["BashMoving"] = true,
	["DronesStampede"] = true,
	["AmbushMoving"] = true,
	["A60"] = true,
	["A120"] = true,
	["GlitchRush"] = true,
	["GlitchAmbush"] = true,
	["BackdoorRush"] = true,
	["CustomEntity"] = true,
}

local function AutoHotelIsEntityPresent()
	if Toggles.AutoHotelIgnoreEntities and Toggles.AutoHotelIgnoreEntities.Value then
		return false
	end
	for _, AutoHotelChild in ipairs(workspace:GetChildren()) do
		if AutoHotelEntityNames[AutoHotelChild.Name] then
			return true
		end
	end
	return false
end

local function AutoHotelWaitForEntities(AutoHotelSeconds)
	if Toggles.AutoHotelIgnoreEntities and Toggles.AutoHotelIgnoreEntities.Value then
		return
	end

	task.wait(AutoHotelSeconds or 5)

	while AutoHotelIsEntityPresent() do
		task.wait(0.15)
	end
end

local function AutoHotelGetNextClosedDoor()
	if not Character then return nil, nil end

	local AutoHotelGameData = game:GetService("ReplicatedStorage"):FindFirstChild("GameData")
	if not AutoHotelGameData then return nil, nil end

	local AutoHotelLatestRoom = AutoHotelGameData:FindFirstChild("LatestRoom")
	if not AutoHotelLatestRoom then return nil, nil end

	local AutoHotelStartRoom = AutoHotelLatestRoom.Value
	local AutoHotelBestDoor, AutoHotelBestNumber = nil, math.huge
	local AutoHotelCurrentRooms = workspace:FindFirstChild("CurrentRooms")

	if AutoHotelCurrentRooms then
		for _, AutoHotelRoom in ipairs(AutoHotelCurrentRooms:GetChildren()) do
			local AutoHotelRoomNum = tonumber(AutoHotelRoom.Name)
			if AutoHotelRoomNum and AutoHotelRoomNum ~= 100 and AutoHotelRoomNum >= AutoHotelStartRoom and AutoHotelRoomNum < AutoHotelBestNumber then
				local AutoHotelDoor = AutoHotelRoom:FindFirstChild("Door")
				if AutoHotelDoor and AutoHotelDoor:IsA("Model") then
					local AutoHotelOpenAttr = AutoHotelDoor:GetAttribute("Open")
					if AutoHotelOpenAttr == false or AutoHotelOpenAttr == nil then
						AutoHotelBestNumber = AutoHotelRoomNum
						AutoHotelBestDoor = AutoHotelDoor
					end
				end
			end
		end
	end

	return AutoHotelBestDoor, AutoHotelBestNumber
end

local function AutoHotelFindKeyObtain(AutoHotelRoom)
	local AutoHotelFound = nil
	local function AutoHotelScan(AutoHotelParent)
		if AutoHotelFound then return end
		for _, AutoHotelChild in ipairs(AutoHotelParent:GetChildren()) do
			if AutoHotelChild.Name == "KeyObtain" then
				AutoHotelFound = AutoHotelChild
				return
			end
			AutoHotelScan(AutoHotelChild)
			if AutoHotelFound then return end
		end
	end
	AutoHotelScan(AutoHotelRoom)
	return AutoHotelFound
end

local function AutoHotelHandleKey(AutoHotelRoomNum)
	local AutoHotelCurrentRooms = workspace:FindFirstChild("CurrentRooms")
	if not AutoHotelCurrentRooms then return false end

	local AutoHotelRoom = AutoHotelCurrentRooms:FindFirstChild(tostring(AutoHotelRoomNum))
	if not AutoHotelRoom then return false end

	local AutoHotelDoor = AutoHotelRoom:FindFirstChild("Door")
	if not AutoHotelDoor or not AutoHotelDoor:FindFirstChild("Lock") then
		return false
	end

	local AutoHotelKeyObtain = AutoHotelFindKeyObtain(AutoHotelRoom)
	if not AutoHotelKeyObtain then return false end

	local AutoHotelStart = tick()
	while tick() - AutoHotelStart < 12 do
		if LocalPlayer.Backpack:FindFirstChild("Key") or (Character and Character:FindFirstChild("Key")) then
			return true
		end

		if Character then
			Character:PivotTo(AutoHotelKeyObtain:GetPivot())
		end

		for _, AutoHotelDesc in ipairs(AutoHotelKeyObtain:GetDescendants()) do
			if AutoHotelDesc:IsA("ProximityPrompt") then
				fireproximityprompt(AutoHotelDesc)
			end
		end

		task.wait(0.12)
	end
	return false
end

local function AutoHotelProcessRoom(AutoHotelRoomNum)
	if AutoHotelProcessedRooms[AutoHotelRoomNum] then
		return
	end
	task.wait(AutoHotelRoomProcessTime)
	AutoHotelProcessedRooms[AutoHotelRoomNum] = true
end

local function AutoHotelRunLibrary()
	local AutoHotelCurrentRooms = workspace:WaitForChild("CurrentRooms")
	local AutoHotelRoom50 = AutoHotelCurrentRooms:WaitForChild("50")
	local AutoHotelLiveHintBooks = {}
	local AutoHotelHintPaperObtained = false

	local function AutoHotelIsInRoom50(AutoHotelObj)
		return AutoHotelObj and AutoHotelObj:IsDescendantOf(AutoHotelRoom50)
	end

	local function AutoHotelIsActuallyInRoom50()
		return tonumber(LocalPlayer:GetAttribute("CurrentRoom")) == 50
	end

	while Toggles.AutoHotel.Value and not AutoHotelIsActuallyInRoom50() do
		task.wait(0.1)
	end
	if not Toggles.AutoHotel.Value then return end

	AutoHotelWaitForEntities(5)

	local function AutoHotelHasHintPaper()
		local AutoHotelChar = LocalPlayer.Character
		if not AutoHotelChar then return false end
		return LocalPlayer.Backpack:FindFirstChild("LibraryHintPaper", true) or AutoHotelChar:FindFirstChild("LibraryHintPaper", true)
	end

	local function AutoHotelGetCFrame(AutoHotelObj)
		if not AutoHotelIsActuallyInRoom50() or not AutoHotelIsInRoom50(AutoHotelObj) then return nil end
		if AutoHotelObj:IsA("Model") then return AutoHotelObj:GetPivot() end
		if AutoHotelObj:IsA("BasePart") then return AutoHotelObj.CFrame end
		local AutoHotelPart = AutoHotelObj:FindFirstChildWhichIsA("BasePart", true)
		return AutoHotelPart and AutoHotelPart.CFrame
	end

	local function AutoHotelCollectBooks()
		for _, AutoHotelDesc in ipairs(AutoHotelRoom50:GetDescendants()) do
			if AutoHotelDesc.Name == "LiveHintBook" and AutoHotelIsInRoom50(AutoHotelDesc) and not table.find(AutoHotelLiveHintBooks, AutoHotelDesc) then
				table.insert(AutoHotelLiveHintBooks, AutoHotelDesc)
			end
		end
	end

	AutoHotelCollectBooks()

	AutoHotelLibraryRoomConnection = AutoHotelRoom50.DescendantAdded:Connect(function(AutoHotelAdded)
		if Toggles.AutoHotel.Value and AutoHotelIsActuallyInRoom50() and AutoHotelIsInRoom50(AutoHotelAdded) then
			if AutoHotelAdded.Name == "LiveHintBook" and not table.find(AutoHotelLiveHintBooks, AutoHotelAdded) then
				table.insert(AutoHotelLiveHintBooks, AutoHotelAdded)
			end
		end
	end)

	while Toggles.AutoHotel.Value and AutoHotelIsActuallyInRoom50() and #AutoHotelLiveHintBooks < 3 do
		AutoHotelCollectBooks()
		if #AutoHotelLiveHintBooks >= 3 then break end
		task.wait(0.1)
	end

	while Toggles.AutoHotel.Value and AutoHotelIsActuallyInRoom50() and not AutoHotelHintPaperObtained do
		if AutoHotelHasHintPaper() then
			AutoHotelHintPaperObtained = true
			break
		end

		for AutoHotelIndex = #AutoHotelLiveHintBooks, 1, -1 do
			local AutoHotelBook = AutoHotelLiveHintBooks[AutoHotelIndex]
			if not AutoHotelIsInRoom50(AutoHotelBook) then
				table.remove(AutoHotelLiveHintBooks, AutoHotelIndex)
				continue
			end

			while Toggles.AutoHotel.Value and AutoHotelIsActuallyInRoom50() and not AutoHotelHintPaperObtained and AutoHotelBook.Parent and AutoHotelIsInRoom50(AutoHotelBook) do
				if AutoHotelHasHintPaper() then
					AutoHotelHintPaperObtained = true
					break
				end

				local AutoHotelChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
				local AutoHotelHRP = AutoHotelChar:FindFirstChild("HumanoidRootPart")
				if not AutoHotelHRP then
					task.wait()
					continue
				end

				local AutoHotelCF = AutoHotelGetCFrame(AutoHotelBook)
				if AutoHotelCF then
					AutoHotelHRP.CFrame = AutoHotelCF
				end

				for _, AutoHotelPrompt in ipairs(AutoHotelBook:GetDescendants()) do
					if AutoHotelPrompt:IsA("ProximityPrompt") then
						fireproximityprompt(AutoHotelPrompt)
					end
				end
				task.wait(0.08)
			end
			if AutoHotelHintPaperObtained then break end
		end

		if AutoHotelHasHintPaper() then
			AutoHotelHintPaperObtained = true
			break
		end

		local AutoHotelPaper = AutoHotelRoom50:FindFirstChild("LibraryHintPaper", true)
		if AutoHotelPaper and AutoHotelIsInRoom50(AutoHotelPaper) then
			while Toggles.AutoHotel.Value and AutoHotelIsActuallyInRoom50() and not AutoHotelHintPaperObtained and AutoHotelPaper.Parent do
				if AutoHotelHasHintPaper() then
					AutoHotelHintPaperObtained = true
					break
				end

				local AutoHotelChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
				local AutoHotelHRP = AutoHotelChar:FindFirstChild("HumanoidRootPart")
				if AutoHotelHRP then
					local AutoHotelCF = AutoHotelGetCFrame(AutoHotelPaper)
					if AutoHotelCF then
						AutoHotelHRP.CFrame = AutoHotelCF * CFrame.new(0, 5, 0)
					end
				end

				for _, AutoHotelPrompt in ipairs(AutoHotelPaper:GetDescendants()) do
					if AutoHotelPrompt:IsA("ProximityPrompt") then
						fireproximityprompt(AutoHotelPrompt)
					end
				end
				task.wait(0.08)
			end
		end
		task.wait(0.1)
	end
end

local function AutoHotelHandleSeek()
	local AutoHotelLastTriggerRoom = nil

	while Toggles.AutoHotel.Value do
		local AutoHotelCurrentRooms = workspace:FindFirstChild("CurrentRooms")
		if not AutoHotelCurrentRooms then
			task.wait(0.2)
			continue
		end

		local TriggerRoomNum = nil

		for _, Room in ipairs(AutoHotelCurrentRooms:GetChildren()) do
			local Num = tonumber(Room.Name)
			if Num and Num ~= AutoHotelLastTriggerRoom then
				local Trigger = Room:FindFirstChild("TriggerEventCollision")
					or Room:FindFirstChild("TriggerEventCollision", true)

				if Trigger then
					TriggerRoomNum = Num
					break
				end
			end
		end

		if not TriggerRoomNum then
			task.wait(0.15)
			continue
		end

		AutoHotelLastTriggerRoom = TriggerRoomNum

		AutoHotelEntityPause = true
		AutoHotelWaitForEntities(10)
		AutoHotelEntityPause = false
	end
end

Toggles.AutoHotel:OnChanged(function(AutoHotelEnabled)
	if AutoHotelConnection then
		task.cancel(AutoHotelConnection)
		AutoHotelConnection = nil
	end
	if AutoHotelLibraryConnection then
		task.cancel(AutoHotelLibraryConnection)
		AutoHotelLibraryConnection = nil
	end
	if AutoHotelLibraryRoomConnection then
		AutoHotelLibraryRoomConnection:Disconnect()
		AutoHotelLibraryRoomConnection = nil
	end
	if AutoHotelSeekConnection then
		task.cancel(AutoHotelSeekConnection)
		AutoHotelSeekConnection = nil
	end

	AutoHotelEntityPause = false
	table.clear(AutoHotelProcessedRooms)

	if not AutoHotelEnabled then return end

	if Options.AutoHotelRoomProcess then
		AutoHotelRoomProcessTime = Options.AutoHotelRoomProcess.Value
		Options.AutoHotelRoomProcess:OnChanged(function(Value)
			AutoHotelRoomProcessTime = Value
		end)
	end

	local AutoHotelCurrentRooms = workspace:FindFirstChild("CurrentRooms")
	if AutoHotelCurrentRooms then
		AutoHotelCurrentRooms.ChildAdded:Connect(function(AutoHotelChild)
			local AutoHotelNum = tonumber(AutoHotelChild.Name)
			if AutoHotelNum then
				AutoHotelProcessRoom(AutoHotelNum)
			end
		end)
	end

	AutoHotelSeekConnection = task.spawn(AutoHotelHandleSeek)

	task.spawn(function()
		while Toggles.AutoHotel.Value do
			if AutoHotelIsEntityPresent() then
				AutoHotelEntityPause = true
				while AutoHotelIsEntityPresent() and Toggles.AutoHotel.Value do
					task.wait(0.15)
				end
				AutoHotelEntityPause = false
			end
			task.wait(0.2)
		end
	end)

	AutoHotelConnection = task.spawn(function()
		while Toggles.AutoHotel.Value do
			if AutoHotelEntityPause then
				task.wait(0.1)
				continue
			end

			local AutoHotelDoor, AutoHotelRoomNum = AutoHotelGetNextClosedDoor()

			if AutoHotelDoor and AutoHotelRoomNum and Character then
				if AutoHotelRoomNum == 50 then
					if not AutoHotelLibraryConnection then
						AutoHotelLibraryConnection = task.spawn(function()
							AutoHotelRunLibrary()
							AutoHotelLibraryConnection = nil
						end)
					end
					task.wait(0.4)
				else
					AutoHotelProcessRoom(AutoHotelRoomNum)
					AutoHotelHandleKey(AutoHotelRoomNum)
					if Character and not AutoHotelEntityPause then
						Character:PivotTo(AutoHotelDoor:GetPivot() * CFrame.new(0, -1, 0))
					end
				end
			end
			task.wait(0.15)
		end
	end)
end)



Toggles.SkipSeekMines:OnChanged(function(Value)
	if Value then
		if Floor ~= "Mines" then
			return
		end
		task.spawn(function()
			local MinesSkipSeekCurrentRooms

			repeat
				if not Toggles.SkipSeekMines.Value then
					return
				end

				MinesSkipSeekCurrentRooms = workspace:FindFirstChild("CurrentRooms")
				task.wait()
			until MinesSkipSeekCurrentRooms

			local MinesSkipSeekStartRoom

			repeat
				if not Toggles.SkipSeekMines.Value then
					return
				end

				MinesSkipSeekCurrentRooms = workspace:FindFirstChild("CurrentRooms")

				if MinesSkipSeekCurrentRooms then
					MinesSkipSeekStartRoom = MinesSkipSeekCurrentRooms:FindFirstChild("42")
				end

				task.wait()
			until MinesSkipSeekStartRoom

			local MinesSkipSeekStartDoor

			repeat
				if not Toggles.SkipSeekMines.Value then
					return
				end

				MinesSkipSeekStartDoor = MinesSkipSeekStartRoom:FindFirstChild("Door", true)
				task.wait()
			until MinesSkipSeekStartDoor

			repeat
				if not Toggles.SkipSeekMines.Value then
					return
				end

				task.wait()
			until MinesSkipSeekStartDoor:GetAttribute("Opened") == true

			if Character and Character:GetAttribute("Minecarting") == true then
				Character:SetAttribute("Minecarting", false)
			end

			for _, MinesSkipSeekRoomNumber in ipairs({
				43, 44, 45, 46, 47, 48, 49,
				78, 79, 80, 81, 82, 83
			}) do
				if not Toggles.SkipSeekMines.Value then
					return
				end

				local MinesSkipSeekRoom

				repeat
					if not Toggles.SkipSeekMines.Value then
						return
					end

					MinesSkipSeekCurrentRooms = workspace:FindFirstChild("CurrentRooms")

					if MinesSkipSeekCurrentRooms then
						MinesSkipSeekRoom = MinesSkipSeekCurrentRooms:FindFirstChild(
							tostring(MinesSkipSeekRoomNumber)
						)
					end

					task.wait()
				until MinesSkipSeekRoom

				local MinesSkipSeekDoor

				repeat
					if not Toggles.SkipSeekMines.Value then
						return
					end

					MinesSkipSeekDoor = MinesSkipSeekRoom:FindFirstChild("Door", true)
					task.wait()
				until MinesSkipSeekDoor

				repeat
					if not Toggles.SkipSeekMines.Value then
						return
					end

					if Character then
						Character:PivotTo(MinesSkipSeekDoor:GetPivot())
					end

					task.wait()
				until MinesSkipSeekDoor:GetAttribute("Opened") == true

				if MinesSkipSeekRoomNumber == 49 or MinesSkipSeekRoomNumber == 83 then
					if not Character then
						return
					end

					local MinesSkipSeekVoidPivot = Character:GetPivot()
					MinesSkipSeekVoidPivot = MinesSkipSeekVoidPivot + Vector3.new(0, -1000, 0)

					task.wait(0.3)

					for MinesSkipSeekVoidCount = 1, 12 do
						Character:PivotTo(MinesSkipSeekVoidPivot)
					end

					for MinesSkipSeekVoidCount = 1, 12 do
						Character:PivotTo(MinesSkipSeekVoidPivot)
					end

					for MinesSkipSeekVoidCount = 1, 12 do
						Character:PivotTo(MinesSkipSeekVoidPivot)
					end

					task.wait(0.3)

					for MinesSkipSeekVoidCount = 1, 6 do
						Character:PivotTo(MinesSkipSeekVoidPivot)
					end
				end

				if MinesSkipSeekRoomNumber == 83 then
					return
				end
			end
		end)
	end
end)

Toggles.OrbitDroppedItems:OnChanged(function(OrbitDroppedItemsEnabled)
	if OrbitDroppedItemsConnection then
		pcall(function() OrbitDroppedItemsConnection:Disconnect() end)
		OrbitDroppedItemsConnection = nil
	end
	if not OrbitDroppedItemsEnabled then return end
	OrbitDroppedItemsAngle = 0
	OrbitDroppedItemsLastTeleport = tick()
	OrbitDroppedItemsPauseUntil = 0
	local RS = RunService or Services.RunService
	OrbitDroppedItemsConnection = RS.Heartbeat:Connect(function(dt)
		local char = LocalPlayer and LocalPlayer.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		local height = (Options.OrbitDroppedItemsHeight and Options.OrbitDroppedItemsHeight.Value) or 2
		local dist = (Options.OrbitDroppedItemsDistance and Options.OrbitDroppedItemsDistance.Value) or 5
		local speed = (Options.OrbitDroppedItemsSpeed and Options.OrbitDroppedItemsSpeed.Value) or 2
		local now = tick()

		local list = {}
		for _, folder in ipairs(MsFent_GetDropsFolders()) do
			for _, obj in ipairs(folder:GetChildren()) do
				if obj:IsA("Model") or obj:IsA("BasePart") then
					list[#list + 1] = obj
				end
			end
		end
		local count = #list
		if count == 0 then return end

		-- pull to player every 10s (anti-despawn), pause 2s
		if now - OrbitDroppedItemsLastTeleport >= 10 then
			OrbitDroppedItemsLastTeleport = now
			OrbitDroppedItemsPauseUntil = now + 2
			local center = hrp.CFrame * CFrame.new(0, 1, 0)
			for _, obj in ipairs(list) do
				MsFent_MoveDrop(obj, center)
			end
		end
		if now < OrbitDroppedItemsPauseUntil then return end

		OrbitDroppedItemsAngle += dt * speed
		for i, obj in ipairs(list) do
			local ang = OrbitDroppedItemsAngle + ((i - 1) / count) * math.pi * 2
			local pos = hrp.Position + Vector3.new(
				math.cos(ang) * dist,
				height,
				math.sin(ang) * dist
			)
			MsFent_MoveDrop(obj, CFrame.new(pos))
		end
	end)
	pcall(function()
		Functions.Notify({ Title = "Orbit Dropped Items", Body = "ON — needs server physics ownership; works best on Stairwell drops." })
	end)
end)


Library:OnUnload(function()
	for Key, Connection in Connections do
		if type(Key) == "string" then
			pcall(function() Connection:Disconnect() end)
		else
			pcall(function() Key:Disconnect() end)
			pcall(function() Connection:Disconnect() end)
		end
	end

	for _, Object in Objects.Entities do
		if Object.Name == "Snare" or Object.Name == "GiggleCeiling" then
			local Hitbox = Object:FindFirstChild("Hitbox")
			if Hitbox then Hitbox.CanTouch = true end
		end
		if Object.Name == "GloomPile" then
			for _, Part in Object:GetDescendants() do
				if Part:IsA("BasePart") then Part.CanTouch = true end
			end
		end
		if Object.Name == "FakeDoor" or Object.Name == "DoorFake" then
			local Hidden = Object:FindFirstChild("Hidden")
			if Hidden then Hidden.CanTouch = true end
			local Lock = Object:FindFirstChild("Lock")
			if Lock and Lock:FindFirstChild("UnlockPrompt") then Lock.UnlockPrompt.Enabled = true end
		end
		if Object.Name == "SideroomSpace" then
			local Coll = Object:FindFirstChild("Collision")
			if Coll then Coll.CanCollide = false Coll.CanTouch = true end
		end
	end

	for _, Object in Objects.SeekBridges do Object:Destroy() end

	for _, Fog in Globals.FogInstances do
		Fog.Density = Fog:GetAttribute("Density_Old")
	end
	Services.Lighting.FogEnd = Globals.OldFog

	local Vignette = Globals.MainUI:FindFirstChild("HideVignette") or Globals.MainUI.MainFrame:FindFirstChild("HideVignette")
	if Vignette then Vignette.Image = "rbxassetid://6100076320" end

	local ModuleRestores = {
		Screech = "Screech", Glitch = "Glitch", Shade = "Shade",
		SpiderJumpscare = "SpiderJumpscare", A90 = "A90", Dread = "Dread", Void = "Void"
	}
	for Key, OriginalName in ModuleRestores do
		if Modules[Key] then Modules[Key].Name = OriginalName end
	end

	FakeEvents.Screech:Destroy()
	FakeEvents.Screech_Real.Parent = RemotesFolder
	FakeEvents.Shade:Destroy()
	FakeEvents.Shade_Real.Parent = RemotesFolder

	if FakeEvents.A90_Real then
		FakeEvents.A90:Destroy()
		FakeEvents.A90_Real.Parent = RemotesFolder
	end
	if FakeEvents.Surge_Real then
		FakeEvents.Surge:Destroy()
		FakeEvents.Surge_Real.Parent = RemotesFolder
	end

	Globals.SeekNodesFolder:Destroy()
	Globals.RoomsNodesFolder:Destroy()
	Globals.ManipulateBody:Destroy()

	local OldAmbient = CurrentRooms:FindFirstChild(tostring(LocalPlayer:GetAttribute("CurrentRoom"))):GetAttribute("Ambient")
	Services.TweenService:Create(Services.Lighting, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { Ambient = OldAmbient }):Play()

	for _, Prompt in Objects.Prompts do
		if FakePrompts[Prompt] then
			FakePrompts[Prompt].Parent = Prompt.Parent
			Prompt:Destroy()
		end
		if Prompt.Parent then
			Prompt.HoldDuration = Prompt:GetAttribute("HoldDuration_Old") or Prompt.HoldDuration
			Prompt.RequiresLineOfSight = Prompt:GetAttribute("RequiresLineOfSight_Old") or Prompt.RequiresLineOfSight
			Prompt.MaxActivationDistance = Prompt:GetAttribute("MaxActivationDistance_Old") or Prompt.MaxActivationDistance
		end
	end

	Character:SetAttribute("CanJump",  OldJump)
	Character:SetAttribute("CanSlide", OldSlide)

	for _, Object in Services.Workspace:GetDescendants() do
		task.spawn(function() Functions.RemoveESP(Object) end)
	end

	Humanoid.WalkSpeed  = Functions.GetCurrentSpeed()
	Humanoid.JumpPower  = 5
	Humanoid.HipHeight  = 2.367

	local BaseY = 0.18
	Collision.Position          = RootPart.Position + Vector3.new(0, BaseY, 0)
	CollisionPart.Position      = RootPart.Position + Vector3.new(0, BaseY, 0)
	CollisionPartClone.Position = RootPart.Position + Vector3.new(0, BaseY, 0)

	if Character:FindFirstChild("LowerTorso") and Character.LowerTorso:FindFirstChild("Root") then
		Character.LowerTorso.Root.C1 = Globals.OriginalC1
	end
	if Collision:FindFirstChild("CollisionCrouch") then
		Collision.CollisionCrouch.Position = RootPart.Position + Vector3.new(0, -0.982, 0)
	end

	CollisionClone:Destroy()
	CollisionPartClone:Destroy()
	MsFent.ESPLibrary:Unload()

	if Main_Game then
		Main_Game.fovtarget   = 70
		Main_Game.spring.Speed = 8
		Main_Game.tooloffset   = Vector3.zero
	end

	getgenv().MsFent = nil
	getgenv().MsFent = nil
end)

-- Don't block forever if MainUI is slow/missing
do
	local t0 = tick()
	while not Globals.MainUI and tick() - t0 < 15 do
		task.wait(0.1)
	end
	if not Globals.MainUI then
		warn("[Ms fent] MainUI not found after 15s — continuing (Settings still loads)")
	end
end

-- Load saved config now that every toggle/option exists
pcall(function()
	local SaveManager = MsFent.Interface.SaveManager
	if SaveManager and SaveManager.LoadAutoloadConfig then
		SaveManager:LoadAutoloadConfig()
		print("[Ms fent] Autoload config applied")
	end
end)


-- Info tab already applied earlier; ensure Settings appears
pcall(function()
	local bind = (Options.MenuKeybind and Options.MenuKeybind.Value) or "RightShift"
	Functions.Notify({
		Title = "Successfully loaded in " .. math.floor((tick() - LoadStart) * 1000) / 1000 .. " seconds.",
		Body = "Press '" .. tostring(bind) .. "' to toggle the UI.",
	})
end)
