addcmd('setwaypoint',{'swp','setwp','spos','saveposition','savepos'},function(args, speaker)
	local WPName = tostring(getstring(1, args))
	if getRoot(speaker.Character) then
		notify('Modified Waypoints',"Created waypoint: "..getstring(1, args))
		local torso = getRoot(speaker.Character)
		WayPoints[#WayPoints + 1] = {NAME = WPName, COORD = {math.floor(torso.Position.X), math.floor(torso.Position.Y), math.floor(torso.Position.Z)}, GAME = PlaceId}
		if AllWaypoints ~= nil then
			AllWaypoints[#AllWaypoints + 1] = {NAME = WPName, COORD = {math.floor(torso.Position.X), math.floor(torso.Position.Y), math.floor(torso.Position.Z)}, GAME = PlaceId}
		end
	end	
	refreshwaypoints()
	updatesaves()
end)

addcmd('waypointpos',{'wpp','setwaypointposition','setpos','setwaypoint','setwaypointpos'},function(args, speaker)
	local WPName = tostring(getstring(1, args))
	if getRoot(speaker.Character) then
		notify('Modified Waypoints',"Created waypoint: "..getstring(1, args))
		WayPoints[#WayPoints + 1] = {NAME = WPName, COORD = {args[2], args[3], args[4]}, GAME = PlaceId}
		if AllWaypoints ~= nil then
			AllWaypoints[#AllWaypoints + 1] = {NAME = WPName, COORD = {args[2], args[3], args[4]}, GAME = PlaceId}
		end
	end	
	refreshwaypoints()
	updatesaves()
end)

addcmd('waypoints',{'positions'},function(args, speaker)
	if SettingsOpen == false then SettingsOpen = true
		TweenService:Create(Settings, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 0, 0, 45)}):Play()
		CMDsF.Visible = false
	end
	TweenService:Create(KeybindsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 0, 0, 175)}):Play()
	TweenService:Create(AliasesFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 0, 0, 175)}):Play()
	TweenService:Create(PluginsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 0, 0, 175)}):Play()
	TweenService:Create(PositionsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 0, 0, 0)}):Play()
	task.wait(0.5)
	SettingsHolder.Visible = false
	maximizeHolder()
end)

waypointParts = {}
addcmd('showwaypoints',{'showwp','showwps'},function(args, speaker)
	execCmd('hidewaypoints')
	task.wait()
	for i,_ in pairs(WayPoints) do
		local x = WayPoints[i].COORD[1]
		local y = WayPoints[i].COORD[2]
		local z = WayPoints[i].COORD[3]
		local part = Instance.new("Part")
		part.Size = Vector3.new(5,5,5)
		part.CFrame = CFrame.new(x,y,z)
		part.Parent = workspace
		part.Anchored = true
		part.CanCollide = false
		table.insert(waypointParts,part)
		local view = Instance.new("BoxHandleAdornment")
		view.Adornee = part
		view.AlwaysOnTop = true
		view.ZIndex = 10
		view.Size = part.Size
		view.Parent = part
	end
	for i,v in pairs(pWayPoints) do
		local view = Instance.new("BoxHandleAdornment")
		view.Adornee = pWayPoints[i].COORD[1]
		view.AlwaysOnTop = true
		view.ZIndex = 10
		view.Size = pWayPoints[i].COORD[1].Size
		view.Parent = pWayPoints[i].COORD[1]
		table.insert(waypointParts,view)
	end
end)

addcmd('hidewaypoints',{'hidewp','hidewps'},function(args, speaker)
	for i,v in pairs(waypointParts) do
		v:Destroy()
	end
	waypointParts = {}
end)

addcmd('waypoint',{'wp','lpos','loadposition','loadpos'},function(args, speaker)
	local WPName = tostring(getstring(1, args))
	if speaker.Character then
		for i,_ in pairs(WayPoints) do
			if tostring(WayPoints[i].NAME):lower() == tostring(WPName):lower() then
				local x = WayPoints[i].COORD[1]
				local y = WayPoints[i].COORD[2]
				local z = WayPoints[i].COORD[3]
				getRoot(speaker.Character).CFrame = CFrame.new(x,y,z)
			end
		end
		for i,_ in pairs(pWayPoints) do
			if tostring(pWayPoints[i].NAME):lower() == tostring(WPName):lower() then
				getRoot(speaker.Character).CFrame = CFrame.new(pWayPoints[i].COORD[1].Position)
			end
		end
	end
end)

tweenSpeed = 1
addcmd('tweenspeed',{'tspeed'},function(args, speaker)
	local newSpeed = args[1] or 1
	if tonumber(newSpeed) then
		tweenSpeed = tonumber(newSpeed)
	end
end)

addcmd('tweenwaypoint',{'twp'},function(args, speaker)
	local WPName = tostring(getstring(1, args))
	if speaker.Character then
		for i,_ in pairs(WayPoints) do
			local x = WayPoints[i].COORD[1]
			local y = WayPoints[i].COORD[2]
			local z = WayPoints[i].COORD[3]
			if tostring(WayPoints[i].NAME):lower() == tostring(WPName):lower() then
				TweenService:Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(x,y,z)}):Play()
			end
		end
		for i,_ in pairs(pWayPoints) do
			if tostring(pWayPoints[i].NAME):lower() == tostring(WPName):lower() then
				TweenService:Create(getRoot(speaker.Character), TweenInfo.new(tweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pWayPoints[i].COORD[1].Position)}):Play()
			end
		end
	end
end)

addcmd('walktowaypoint',{'wtwp'},function(args, speaker)
	local WPName = tostring(getstring(1, args))
	if speaker.Character then
		for i,_ in pairs(WayPoints) do
			local x = WayPoints[i].COORD[1]
			local y = WayPoints[i].COORD[2]
			local z = WayPoints[i].COORD[3]
			if tostring(WayPoints[i].NAME):lower() == tostring(WPName):lower() then
				if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
					speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
					task.wait(.1)
				end
				speaker.Character:FindFirstChildOfClass('Humanoid').WalkToPoint = Vector3.new(x,y,z)
			end
		end
		for i,_ in pairs(pWayPoints) do
			if tostring(pWayPoints[i].NAME):lower() == tostring(WPName):lower() then
				if speaker.Character:FindFirstChildOfClass('Humanoid') and speaker.Character:FindFirstChildOfClass('Humanoid').SeatPart then
					speaker.Character:FindFirstChildOfClass('Humanoid').Sit = false
					task.wait(.1)
				end
				speaker.Character:FindFirstChildOfClass('Humanoid').WalkToPoint = Vector3.new(pWayPoints[i].COORD[1].Position)
			end
		end
	end
end)

addcmd('deletewaypoint',{'dwp','dpos','deleteposition','deletepos'},function(args, speaker)
	for i,v in pairs(WayPoints) do
		if v.NAME:lower() == tostring(getstring(1, args)):lower() then
			notify('Modified Waypoints',"Deleted waypoint: " .. v.NAME)
			table.remove(WayPoints, i)
		end
	end
	if AllWaypoints ~= nil and #AllWaypoints > 0 then
		for i,v in pairs(AllWaypoints) do
			if v.NAME:lower() == tostring(getstring(1, args)):lower() then
				if not v.GAME or v.GAME == PlaceId then
					table.remove(AllWaypoints, i)
				end
			end
		end
	end
	for i,v in pairs(pWayPoints) do
		if v.NAME:lower() == tostring(getstring(1, args)):lower() then
			notify('Modified Waypoints',"Deleted waypoint: " .. v.NAME)
			table.remove(pWayPoints, i)
		end
	end
	refreshwaypoints()
	updatesaves()
end)

addcmd('exportwaypoints',{'exportwp','copywaypoints'},function(args, speaker)
	local source = (type(AllWaypoints) == 'table' and #AllWaypoints > 0) and AllWaypoints or WayPoints
	local plain = {}
	for i = 1, #source do
		local w = source[i]
		if type(w) == 'table' and w.NAME and type(w.COORD) == 'table'
			and tonumber(w.COORD[1]) and tonumber(w.COORD[2]) and tonumber(w.COORD[3]) then
			plain[#plain + 1] = {NAME = tostring(w.NAME), COORD = {tonumber(w.COORD[1]), tonumber(w.COORD[2]), tonumber(w.COORD[3])}, GAME = w.GAME}
		end
	end
	if #plain == 0 then
		notify('Waypoints','No waypoints to export')
		return
	end
	local ok, json = pcall(function() return HttpService:JSONEncode(plain) end)
	if not ok or type(json) ~= 'string' then
		notify('Waypoints','Could not encode your waypoints')
		return
	end
	toClipboard(json)
	notify('Waypoints', #plain..' waypoint(s) copied to the clipboard as JSON')
end)

addcmd('importwaypoints',{'importwp','loadwaypoints'},function(args, speaker)
	local text = getstring(1, args)
	if text == '' then
		notify('Waypoints','Usage: importwaypoints [json]  (paste the JSON produced by exportwaypoints)')
		return
	end
	local ok, data = pcall(function() return HttpService:JSONDecode(text) end)
	if not ok or type(data) ~= 'table' or #data == 0 then
		notify('Waypoints','That does not look like an exported waypoint list')
		return
	end
	if type(AllWaypoints) ~= 'table' then AllWaypoints = {} end
	local added = 0
	for _, w in ipairs(data) do
		if type(w) == 'table' and w.NAME and type(w.COORD) == 'table'
			and tonumber(w.COORD[1]) and tonumber(w.COORD[2]) and tonumber(w.COORD[3]) then
			local name = tostring(w.NAME)
			local x, y, z = tonumber(w.COORD[1]), tonumber(w.COORD[2]), tonumber(w.COORD[3])
			local dupe = false
			for _, existing in ipairs(AllWaypoints) do
				if type(existing) == 'table' and existing.NAME == name and type(existing.COORD) == 'table'
					and tonumber(existing.COORD[1]) == x and tonumber(existing.COORD[2]) == y and tonumber(existing.COORD[3]) == z then
					dupe = true
					break
				end
			end
			if not dupe then
				AllWaypoints[#AllWaypoints + 1] = {NAME = name, COORD = {x, y, z}, GAME = w.GAME}
				if not w.GAME or w.GAME == PlaceId then
					WayPoints[#WayPoints + 1] = {NAME = name, COORD = {x, y, z}, GAME = w.GAME}
				end
				added = added + 1
			end
		end
	end
	refreshwaypoints()
	updatesaves()
	if added == 0 then
		notify('Waypoints','Nothing new to import (all '..#data..' already saved)')
	else
		notify('Waypoints', added..' waypoint(s) imported')
	end
end)

addcmd('clearwaypoints',{'cwp','clearpositions','cpos','clearpos'},function(args, speaker)
	WayPoints = {}
	pWayPoints = {}
	refreshwaypoints()
	updatesaves()
	AllWaypoints = {}
	notify('Modified Waypoints','Removed all waypoints')
end)

addcmd('cleargamewaypoints',{'cgamewp'},function(args, speaker)
	for i,v in pairs(WayPoints) do
		if v.GAME == PlaceId then
			table.remove(WayPoints, i)
		end
	end
	if AllWaypoints ~= nil and #AllWaypoints > 0 then
		for i,v in pairs(AllWaypoints) do
			if v.GAME == PlaceId then
				table.remove(AllWaypoints, i)
			end
		end
	end
	for i,v in pairs(pWayPoints) do
		if v.GAME == PlaceId then
			table.remove(pWayPoints, i)
		end
	end
	refreshwaypoints()
	updatesaves()
	notify('Modified Waypoints','Deleted game waypoints')
end)


local coreGuiTypeNames = {
	-- predefined aliases
	["inventory"] = Enum.CoreGuiType.Backpack,
	["leaderboard"] = Enum.CoreGuiType.PlayerList,
	["emotes"] = Enum.CoreGuiType.EmotesMenu
}

-- Load the full list of enums
for _, enumItem in ipairs(Enum.CoreGuiType:GetEnumItems()) do
	coreGuiTypeNames[enumItem.Name:lower()] = enumItem
end

