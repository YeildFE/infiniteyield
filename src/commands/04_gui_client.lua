addcmd('enable',{},function(args, speaker)
	local input = args[1] and args[1]:lower()
	if input then
		if input == "reset" then
			StarterGui:SetCore("ResetButtonCallback", true)
		else
			local coreGuiType = coreGuiTypeNames[input]
			if coreGuiType then
				StarterGui:SetCoreGuiEnabled(coreGuiType, true)
			end
		end
	end
end)

addcmd('disable',{},function(args, speaker)
	local input = args[1] and args[1]:lower()
	if input then
		if input == "reset" then
			StarterGui:SetCore("ResetButtonCallback", false)
		else
			local coreGuiType = coreGuiTypeNames[input]
			if coreGuiType then
				StarterGui:SetCoreGuiEnabled(coreGuiType, false)
			end
		end
	end
end)


local invisGUIS = {}
addcmd('showguis',{},function(args, speaker)
	for i, v in ipairs(PlayerGui:GetDescendants()) do
		if (v:IsA("Frame") or v:IsA("ImageLabel") or v:IsA("ScrollingFrame")) and not v.Visible then
			v.Visible = true
			if not FindInTable(invisGUIS,v) then
				table.insert(invisGUIS,v)
			end
		end
	end
end)

addcmd('unshowguis',{},function(args, speaker)
	for i,v in pairs(invisGUIS) do
		v.Visible = false
	end
	invisGUIS = {}
end)

local hiddenGUIS = {}
addcmd('hideguis',{},function(args, speaker)
	for i, v in ipairs(PlayerGui:GetDescendants()) do
		if (v:IsA("Frame") or v:IsA("ImageLabel") or v:IsA("ScrollingFrame")) and v.Visible then
			v.Visible = false
			if not FindInTable(hiddenGUIS,v) then
				table.insert(hiddenGUIS,v)
			end
		end
	end
end)

addcmd('unhideguis',{},function(args, speaker)
	for i,v in pairs(hiddenGUIS) do
		v.Visible = true
	end
	hiddenGUIS = {}
end)

function deleteGuisAtPos()
	pcall(function()
		local guisAtPosition = PlayerGui:GetGuiObjectsAtPosition(IYMouse.X, IYMouse.Y)
		for _, gui in pairs(guisAtPosition) do
			if gui.Visible == true then
				gui:Destroy()
			end
		end
	end)
end

local deleteGuiInput
addcmd('guidelete',{},function(args, speaker)
	deleteGuiInput = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if not gameProcessedEvent then
			if input.KeyCode == Enum.KeyCode.Backspace then
				deleteGuisAtPos()
			end
		end
	end)
	notify('GUI Delete Enabled','Hover over a GUI and press backspace to delete it')
end)

addcmd('unguidelete',{'noguidelete'},function(args, speaker)
	if deleteGuiInput then deleteGuiInput:Disconnect() end
	notify('GUI Delete Disabled','GUI backspace delete has been disabled')
end)

local wasStayOpen = StayOpen
addcmd('hideiy',{'hide'},function(args, speaker)
	isHidden = true
	wasStayOpen = StayOpen
	if StayOpen == true then
		StayOpen = false
		On.BackgroundTransparency = 1
	end
	minimizeNum = 0
	minimizeHolder()
	if not (args[1] and tostring(args[1]) == 'nonotify') then notify('IY Hidden','You can press the prefix key to access the command bar') end
end)

addcmd('showiy',{'unhideiy','unhide'},function(args, speaker)
	isHidden = false
	minimizeNum = -20
	if wasStayOpen then
		maximizeHolder()
		StayOpen = true
		On.BackgroundTransparency = 0
	else
		minimizeHolder()
	end
end)

addcmd('rec', {'record'}, function(args, speaker)
	return COREGUI:ToggleRecording()
end)

addcmd('screenshot', {'scrnshot'}, function(args, speaker)
	return COREGUI:TakeScreenshot()
end)

addcmd('togglefs', {'togglefullscreen'}, function(args, speaker)
	return GuiService:ToggleFullscreen()
end)

addcmd('inspect', {'examine'}, function(args, speaker)
	for _, v in ipairs(getPlayer(args[1], speaker)) do
		GuiService:CloseInspectMenu()
		GuiService:InspectPlayerFromUserId(Players[v].UserId)
	end
end)

addcmd("savegame", {"saveplace"}, function(args, speaker)
	if saveinstance then
		notify("Loading", "Downloading game. This will take a while")
		saveinstance()
		notify("Game Saved", "Saved place to the workspace folder within your exploit folder.")
	else
		notify("Incompatible Exploit", "Your exploit does not support this command (missing saveinstance)")
	end
end)

addcmd("clearerror", {"clearerrors"}, function(args, speaker)
    GuiService:ClearError()
end)

addcmd("antigameplaypaused", {}, function(args, speaker)
    pcall(function() networkPaused:Disconnect() end)
    networkPaused = COREGUI.RobloxGui.ChildAdded:Connect(function(obj)
        if obj.Name == "CoreScripts/NetworkPause" then
            obj:Destroy()
        end
    end)
    COREGUI.RobloxGui["CoreScripts/NetworkPause"]:Destroy()
end)

addcmd("unantigameplaypaused", {}, function(args, speaker)
    networkPaused:Disconnect()
end)

addcmd('clientantikick',{'antikick'},function(args, speaker)
	if not hookmetamethod then 
		return notify('Incompatible Exploit','Your exploit does not support this command (missing hookmetamethod)')
	end
	local LocalPlayer = Players.LocalPlayer
	local oldhmmi
	local oldhmmnc
	local oldKickFunction
	if hookfunction then
		oldKickFunction = hookfunction(LocalPlayer.Kick, function() end)
	end
	oldhmmi = hookmetamethod(game, "__index", function(self, method)
		if self == LocalPlayer and method:lower() == "kick" then
			return error("Expected ':' not '.' calling member function Kick", 2)
		end
		return oldhmmi(self, method)
	end)
	oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
		if self == LocalPlayer and getnamecallmethod():lower() == "kick" then
			return
		end
		return oldhmmnc(self, ...)
	end)

	notify('Client Antikick','Client anti kick is now active (only effective on localscript kick)')
end)

allow_rj = true
addcmd('clientantiteleport',{'antiteleport'},function(args, speaker)
	if not hookmetamethod then 
		return notify('Incompatible Exploit','Your exploit does not support this command (missing hookmetamethod)')
	end
	local TeleportService = TeleportService
	local oldhmmi
	local oldhmmnc
	oldhmmi = hookmetamethod(game, "__index", function(self, method)
		if self == TeleportService then
			if method:lower() == "teleport" then
				return error("Expected ':' not '.' calling member function Kick", 2)
			elseif method == "TeleportToPlaceInstance" then
				return error("Expected ':' not '.' calling member function TeleportToPlaceInstance", 2)
			end
		end
		return oldhmmi(self, method)
	end)
	oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
		if self == TeleportService and getnamecallmethod():lower() == "teleport" or getnamecallmethod() == "TeleportToPlaceInstance" then
			return
		end
		return oldhmmnc(self, ...)
	end)

	notify('Client AntiTP','Client anti teleport is now active (only effective on localscript teleport)')
end)

addcmd('allowrejoin',{'allowrj'},function(args, speaker)
	if args[1] and args[1] == 'false' then
		allow_rj = false
		notify('Client AntiTP','Allow rejoin set to false')
	else
		allow_rj = true
		notify('Client AntiTP','Allow rejoin set to true')
	end
end)

addcmd("cancelteleport", {"canceltp"}, function(args, speaker)
	TeleportService:TeleportCancel()
end)

addcmd("volume",{ "vol"}, function(args, speaker)
	UserSettings():GetService("UserGameSettings").MasterVolume = args[1]/10
end)

addcmd("antilag", {"boostfps", "lowgraphics"}, function(args, speaker)
	local Terrain = workspace:FindFirstChildWhichIsA("Terrain")
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 1
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 9e9
	Lighting.FogStart = 9e9
	settings().Rendering.QualityLevel = 1
	for _, v in ipairs(game:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CastShadow = false
			v.Material = "Plastic"
			v.Reflectance = 0
			v.BackSurface = "SmoothNoOutlines"
			v.BottomSurface = "SmoothNoOutlines"
			v.FrontSurface = "SmoothNoOutlines"
			v.LeftSurface = "SmoothNoOutlines"
			v.RightSurface = "SmoothNoOutlines"
			v.TopSurface = "SmoothNoOutlines"
		elseif v:IsA("Decal") then
			v.Transparency = 1
			v.Texture = ""
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Lifetime = NumberRange.new(0)
		end
	end
	for _, v in ipairs(Lighting:GetDescendants()) do
		if v:IsA("PostEffect") then
			v.Enabled = false
		end
	end
	workspace.DescendantAdded:Connect(function(child)
		task.spawn(function()
			if child:IsA("ForceField") or child:IsA("Sparkles") or child:IsA("Smoke") or child:IsA("Fire") or child:IsA("Beam") then
				RunService.Heartbeat:Wait()
				child:Destroy()
			elseif child:IsA("BasePart") then
				child.CastShadow = false
			end
		end)
	end)
end)

addcmd("setfpscap", {"fpscap", "maxfps"}, function(args, speaker)
	if fpscaploop then
		task.cancel(fpscaploop)
		fpscaploop = nil
	end

	local fpsCap = 60
	local num = tonumber(args[1]) or 1e6
	if num == "none" then
		return
	elseif num > 0 then
		fpsCap = num
	else
		return notify("Invalid argument", "Please provide a number above 0 or 'none'.")
	end

	if setfpscap and type(setfpscap) == "function" then
		setfpscap(fpsCap)
	else
		fpscaploop = task.spawn(function()
			local timer = os.clock()
			while true do
				if os.clock() >= timer + 1 / fpsCap then
					timer = os.clock()
					task.wait()
				end
			end
		end)
	end
end)

addcmd('notify',{},function(args, speaker)
	-- no text = undo 'nonotify' (turn notifications back on)
	if #args == 0 then
		if not notificationsMuted then
			notify('Notifications','Notifications are already on')
			return
		end
		notificationsMuted = false
		notify('Notifications','Notifications are back on')
		return
	end
	notify(getstring(1, args))
end)

addcmd('nonotify',{'mutealerts'},function(args, speaker)
	if notificationsMuted then
		notify('Notifications','Notifications are already off')
		return
	end
	notify('Notifications','Notifications are off (use "notify" with no text to turn them back on)')
	notificationsMuted = true
end)

addcmd('lastcommand',{'lastcmd'},function(args, speaker)
	if cmdHistory[1]:sub(1,11) ~= 'lastcommand' and cmdHistory[1]:sub(1,7) ~= 'lastcmd' then
		execCmd(cmdHistory[1])
	end
end)

-- 'x', 'Enum.KeyCode.X', 'leftclick' -> the KEY format the keybind table uses
local function bindKeyFromArg(keyArg)
	local key = tostring(keyArg or ''):lower()
	if key == '' then return nil, '' end
	if key == 'leftclick' or key == 'mousebutton1' then return 'LeftClick' end
	if key == 'rightclick' or key == 'mousebutton2' then return 'RightClick' end
	if key:sub(1, 13) == 'enum.keycode.' then key = key:sub(14) end
	local upper = key:upper()
	local ok, keyCode = pcall(function() return Enum.KeyCode[upper] end)
	if ok and keyCode then return 'Enum.KeyCode.' .. keyCode.Name end
	return nil, upper
end

local function bindKeyDisplay(key)
	key = tostring(key)
	if key == 'LeftClick' or key == 'RightClick' then return key end
	if key:sub(1, 13) == 'Enum.KeyCode.' then return key:sub(14) end
	return key
end

addcmd('bind',{},function(args, speaker)
	if not args[1] or getstring(2, args) == '' then
		notify('Keybinds','Usage: bind [key] [command]  (e.g. bind X esp, or bind X "esp | noesp" for a toggle)')
		return
	end
	if string.find(getstring(2, args), "\\\\") then
		notify('Keybind Error','Only use one backslash to keybind multiple commands into one keybind or command')
		return
	end
	local key, unknown = bindKeyFromArg(args[1])
	if not key then
		notify('Keybind Error','Unknown key: '..tostring(unknown))
		return
	end
	local cmdStr = getstring(2, args)
	-- 'bind X esp | noesp' makes a toggle pair, same as the toggle button in the editor
	local toggleCmd = nil
	local bar = string.find(cmdStr, ' | ', 1, true)
	if bar then
		toggleCmd = string.sub(cmdStr, bar + 3)
		cmdStr = string.sub(cmdStr, 1, bar - 1)
		if toggleCmd == '' then toggleCmd = nil end
	end
	addbind(cmdStr, key, false, toggleCmd)
	refreshbinds()
	updatesaves()
	notify('Keybinds Updated','Binded '..bindKeyDisplay(key)..' to '..cmdStr..(toggleCmd and ' / '..toggleCmd or ''))
end)

addcmd('unbind',{},function(args, speaker)
	if not args[1] then
		notify('Keybinds','Usage: unbind [key] [command]  (leave the command off to clear every bind on that key)')
		return
	end
	local key, unknown = bindKeyFromArg(args[1])
	if not key then
		notify('Keybind Error','Unknown key: '..tostring(unknown))
		return
	end
	local display = bindKeyDisplay(key)
	local cmdStr = getstring(2, args)
	local removed = 0
	for i = #binds, 1, -1 do
		if binds[i].KEY == key and (cmdStr == '' or binds[i].COMMAND == cmdStr) then
			toggleOn[binds[i]] = nil
			table.remove(binds, i)
			removed = removed + 1
		end
	end
	refreshbinds()
	updatesaves()
	if removed == 0 then
		notify('Keybinds','No bind matches '..display..(cmdStr ~= '' and ' > '..cmdStr or ''))
	elseif cmdStr ~= '' then
		notify('Keybinds Updated','Unbinded '..display..' from '..cmdStr)
	else
		notify('Keybinds Updated','Removed '..removed..' bind(s) from '..display)
	end
end)

addcmd('binds',{'listbinds','keybinds'},function(args, speaker)
	if type(binds) ~= 'table' or #binds == 0 then
		notify('Keybinds','No keybinds set')
		return
	end
	local parts = {}
	for i = 1, #binds do
		if #parts >= 8 then break end
		parts[#parts + 1] = bindKeyDisplay(binds[i].KEY)..' > '..tostring(binds[i].COMMAND)..(binds[i].ISKEYUP and ' (keyup)' or '')
	end
	local extra = #binds - #parts
	notify('Keybinds', #binds..' bind(s): '..table.concat(parts, ', ')..(extra > 0 and '  +'..extra..' more' or ''))
end)

addcmd('setprefix',{'prefix'},function(args, speaker)
	local newPrefix = tostring(args[1] or '')
	if newPrefix == '' then
		notify('Prefix','Usage: setprefix [text]  (current prefix: '..tostring(prefix)..')')
		return
	end
	PrefixBox.Text = newPrefix
	notify('Prefix','Command bar prefix set to "'..newPrefix..'"')
end)

