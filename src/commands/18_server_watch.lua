addcmd("rolewatch", {}, function(args, speaker)
	local groupId = tonumber(args[1] or 0)
	local roleName = args[2] and tostring(getstring(2, args))
	if groupId and roleName then
		RolewatchData.Group = groupId
		RolewatchData.Role = roleName
		notify("Rolewatch", "Watching Group ID \"" .. tostring(groupId) .. "\" for Role \"" .. roleName .. "\"")
	end
end)

addcmd("rolewatchstop", {}, function(args, speaker)
	RolewatchData.Group = 0
	RolewatchData.Role = ""
	RolewatchData.Leave = false
	notify("Rolewatch", "Disabled")
end)

addcmd("rolewatchleave", {"unrolewatch"}, function(args, speaker)
	RolewatchData.Leave = not RolewatchData.Leave
	notify("Rolewatch", RolewatchData.Leave and "Leave has been Enabled" or "Leave has been Disabled")
end)

staffRoles = {"mod", "admin", "staff", "dev", "founder", "owner", "supervis", "manager", "management", "executive", "president", "chairman", "chairwoman", "chairperson", "director"}

getStaffRole = function(player)
	local playerRole = player:GetRoleInGroup(game.CreatorId)
	local result = {Role = playerRole, Staff = false}
	if player:IsInGroup(1200769) then
		result.Role = "Roblox Employee"
		result.Staff = true
	end
	for _, role in pairs(staffRoles) do
		if string.find(string.lower(playerRole), role) then
			result.Staff = true
		end
	end
	return result
end

addcmd("staffwatch", {}, function(args, speaker)
	if staffwatchjoin then
		staffwatchjoin:Disconnect()
	end
	if game.CreatorType == Enum.CreatorType.Group then
		local found = {}
		staffwatchjoin = Players.PlayerAdded:Connect(function(player)
			local result = getStaffRole(player)
			if result.Staff then
				notify("Staffwatch", formatUsername(player) .. " is a " .. result.Role)
			end
		end)
		for _, player in ipairs(Players:GetPlayers()) do
			local result = getStaffRole(player)
			if result.Staff then
				table.insert(found, formatUsername(player) .. " is a " .. result.Role)
			end
		end
		if #found > 0 then
			notify("Staffwatch", table.concat(found, ",\n"))
		else
			notify("Staffwatch", "Enabled")
		end
	else
		notify("Staffwatch", "Game is not owned by a Group")
	end
end)

addcmd("unstaffwatch", {}, function(args, speaker)
	if staffwatchjoin then
		staffwatchjoin:Disconnect()
	end
	notify("Staffwatch", "Disabled")
end)

local function playerGroups()
    local players = Players:GetPlayers()
    local graph = {}
    local seen = {}
    local groups = {}

    for _, p in ipairs(players) do
        graph[p] = {}
    end

    for i = 1, #players do
        for j = i + 1, #players do
            local p1 = players[i]
            local p2 = players[j]

            local success, result = pcall(function()
                return p1:IsFriendsWithAsync(p2.UserId)
            end)

            if success and result then
                table.insert(graph[p1], p2)
                table.insert(graph[p2], p1)
            end
        end
    end

    local function dfs(player, group)
        seen[player] = true
        table.insert(group, player)

        for _, possible in ipairs(graph[player]) do
            if not seen[possible] then
                dfs(possible, group)
            end
        end
    end

    for _, p in ipairs(players) do
        if not seen[p] then
            local group = {}
            dfs(p, group)
            table.insert(groups, group)
        end
    end

    return groups
end

addcmd("findfriendgroups", {}, function(args, speaker)
    notify("Checking Players", "This might take a while (slow function)")

    local groups = playerGroups()
    local playerList = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList)

    local result = ""
    local index = 1
    local found = 0

    for _, group in ipairs(groups) do
        if #group == 1 then continue end
        local names = {}
        for _, player in ipairs(group) do
            table.insert(names, playerList and player.DisplayName or player.Name)
        end
        result = result .. index .. ". " .. table.concat(names, ", ") .. "\n"
        index = index + 1
        found = found + 1
    end

    createPopup("Friend Groups", found == 0 and "None" or result)
end)

addcmd('removeterrain',{'rterrain','noterrain'},function(args, speaker)
	workspace:FindFirstChildOfClass('Terrain'):Clear()
end)

addcmd('clearnilinstances',{'nonilinstances','cni'},function(args, speaker)
	if getnilinstances then
		for i,v in pairs(getnilinstances()) do
			v:Destroy()
		end
	else
		notify('Incompatible Exploit','Your exploit does not support this command (missing getnilinstances)')
	end
end)

addcmd('destroyheight',{'dh'},function(args, speaker)
	local dh = args[1] or -500
	if isNumber(dh) then
		workspace.FallenPartsDestroyHeight = dh
	end
end)

OrgDestroyHeight = workspace.FallenPartsDestroyHeight
addcmd("antivoid", {}, function(args, speaker)
	execCmd("unantivoid nonotify")
	task.wait()
	antivoidloop = RunService.Stepped:Connect(function()
		local root = getRoot(speaker.Character)
		if root and root.Position.Y <= OrgDestroyHeight + 25 then
			root.Velocity = root.Velocity + Vector3.new(0, 250, 0)
		end
	end)
	if args[1] ~= "nonotify" then notify("antivoid", "Enabled") end
end)

addcmd("unantivoid", {"noantivoid"}, function(args, speaker)
	pcall(function() antivoidloop:Disconnect() end)
	antivoidloop = nil
	if args[1] ~= "nonotify" then notify("antivoid", "Disabled") end
end)

antivoidWasEnabled = false
addcmd("fakeout", {}, function(args, speaker)
	local root = getRoot(speaker.Character)
	local oldpos = root.CFrame
	if antivoidloop then
		execCmd("unantivoid nonotify")
		antivoidWasEnabled = true
	end
	workspace.FallenPartsDestroyHeight = 0/1/0
	root.CFrame = CFrame.new(Vector3.new(0, OrgDestroyHeight - 25, 0))
	task.wait(1)
	root.CFrame = oldpos
	workspace.FallenPartsDestroyHeight = OrgDestroyHeight
	if antivoidWasEnabled then
		execCmd("antivoid nonotify")
		antivoidWasEnabled = false
	end
end)

addcmd("trip", {}, function(args, speaker)
	local humanoid = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
	local root = speaker.Character and getRoot(speaker.Character)
	if humanoid and root then
		humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
		root.Velocity = root.CFrame.LookVector * 30
	end
end)

addcmd("removeads", {"adblock"}, function(args, speaker)
	while task.wait() do
		pcall(function()
			for i, v in ipairs(workspace:GetDescendants()) do
				if v:IsA("PackageLink") then
					if v.Parent:FindFirstChild("ADpart") then
						v.Parent:Destroy()
					end
					if v.Parent:FindFirstChild("AdGuiAdornee") then
						v.Parent.Parent:Destroy()
					end
				end
			end
		end)
	end
end)

addcmd("scare", {"spook"}, function(args, speaker)
	local players = getPlayer(args[1], speaker)
	local oldpos = nil

	for _, v in pairs(players) do
		local root = speaker.Character and getRoot(speaker.Character)
		local target = Players[v]
		local targetRoot = target and target.Character and getRoot(target.Character)

		if root and targetRoot and target ~= speaker then
			oldpos = root.CFrame
			root.CFrame = targetRoot.CFrame + targetRoot.CFrame.lookVector * 2
			root.CFrame = CFrame.new(root.Position, targetRoot.Position)
			task.wait(0.5)
			root.CFrame = oldpos
		end
	end
end)

addcmd("alignmentkeys", {}, function(args, speaker)
	alignmentKeys = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.Comma then workspace.CurrentCamera:PanUnits(-1) end
		if input.KeyCode == Enum.KeyCode.Period then workspace.CurrentCamera:PanUnits(1) end
	end)
	alignmentKeysEmotes = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
end)

addcmd("unalignmentkeys", {"noalignmentkeys"}, function(args, speaker)
	if type(alignmentKeysEmotes) == "boolean" then
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, alignmentKeysEmotes)
	end
	alignmentKeys:Disconnect()
end)

addcmd("ctrllock", {}, function(args, speaker)
	local mouseLockController = speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("MouseLockController")
	local boundKeys = mouseLockController:FindFirstChild("BoundKeys")

	if boundKeys then
		boundKeys.Value = "LeftControl"
	else
		boundKeys = Instance.new("StringValue")
		boundKeys.Name = "BoundKeys"
		boundKeys.Value = "LeftControl"
		boundKeys.Parent = mouseLockController
	end
end)

addcmd("unctrllock", {}, function(args, speaker)
	local mouseLockController = speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("CameraModule"):WaitForChild("MouseLockController")
	local boundKeys = mouseLockController:FindFirstChild("BoundKeys")

	if boundKeys then
		boundKeys.Value = "LeftShift"
	else
		boundKeys = Instance.new("StringValue")
		boundKeys.Name = "BoundKeys"
		boundKeys.Value = "LeftShift"
		boundKeys.Parent = mouseLockController
	end
end)

addcmd("listento", {}, function(args, speaker)
	execCmd("unlistento")
	if not args[1] then return end

	local player = Players:FindFirstChild(getPlayer(args[1], speaker)[1])
	local root = player and player.Character and getRoot(player.Character)

	if root then
		SoundService:SetListener(Enum.ListenerType.ObjectPosition, root)
		listentoChar = player.CharacterAdded:Connect(function()
			repeat task.wait() until Players[player.Name].Character ~= nil and getRoot(Players[player.Name].Character)
			SoundService:SetListener(Enum.ListenerType.ObjectPosition, getRoot(Players[player.Name].Character))
		end)
	end
end)

addcmd("unlistento", {}, function(args, speaker)
	SoundService:SetListener(Enum.ListenerType.Camera)
	listentoChar:Disconnect()
end)

addcmd("jerk", {}, function(args, speaker)
	local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	local backpack = speaker:FindFirstChildWhichIsA("Backpack")
	if not humanoid or not backpack then return end

	local tool = Instance.new("Tool")
	tool.Name = "Jerk Off"
	tool.ToolTip = "in the stripped club. straight up \"jorking it\" . and by \"it\" , haha, well. let's justr say. My peanits."
	tool.RequiresHandle = false
	tool.Parent = backpack

	local jorkin = false
	local track = nil

	local function stopTomfoolery()
		jorkin = false
		if track then
			track:Stop()
			track = nil
		end
	end

	tool.Equipped:Connect(function() jorkin = true end)
	tool.Unequipped:Connect(stopTomfoolery)
	humanoid.Died:Connect(stopTomfoolery)

	while task.wait() do
		if not jorkin then continue end

		local isR15 = r15(speaker)
		if not track then
			local anim = Instance.new("Animation")
			anim.AnimationId = not isR15 and "rbxassetid://72042024" or "rbxassetid://698251653"
			track = humanoid:LoadAnimation(anim)
		end

		track:Play()
		track:AdjustSpeed(isR15 and 0.7 or 0.65)
		track.TimePosition = 0.6
		task.wait(0.1)
		while track and track.TimePosition < (not isR15 and 0.65 or 0.7) do task.wait(0.1) end
		if track then
			track:Stop()
			track = nil
		end
	end
end)

addcmd("guiscale", {}, function(args, speaker)
	if args[1] and isNumber(args[1]) then
		local scale = tonumber(args[1])
		if scale % 1 == 0 then scale = scale / 100 end
		-- me when i divide and it explodes
		if scale == 0.01 then scale = 1 end
		if scale == 0.02 then scale = 2 end

		if scale >= 0.4 and scale <= 2 then
			guiScale = scale
		end
	else
		guiScale = defaultGuiScale
	end

	Scale.Scale = math.max(Holder.AbsoluteSize.X / 1920, guiScale)
	updatesaves()
end)

addcmd("muteallvoices", {"muteallvcs"}, function(args, speaker)
	Services.VoiceChatInternal:SubscribePauseAll(true)
end)

addcmd("unmuteallvoices", {"unmuteallvcs"}, function(args, speaker)
	Services.VoiceChatInternal:SubscribePauseAll(false)
end)

addcmd("mutevc", {}, function(args, speaker)
	for _, plr in getPlayer(args[1], speaker) do
		if Players[plr] == speaker then continue end
		Services.VoiceChatInternal:SubscribePause(Players[plr].UserId, true)
	end
end)

addcmd("unmutevc", {}, function(args, speaker)
	for _, plr in getPlayer(args[1], speaker) do
		if Players[plr] == speaker then continue end
		Services.VoiceChatInternal:SubscribePause(Players[plr].UserId, false)
	end
end)

addcmd("phonebook", {"call"}, function(args, speaker)
	local success, canInvite = pcall(function()
		return SocialService:CanSendCallInviteAsync(speaker)
	end)
	if success and canInvite then
		SocialService:PromptPhoneBook(speaker, "")
	else
		notify("Phonebook", "It seems you're not able to call anyone. Sorry!")
	end
end)

local freezingua = nil
frozenParts = {}
addcmd('freezeunanchored',{'freezeua'},function(args, speaker)
	local badnames = {
		"Head",
		"UpperTorso",
		"LowerTorso",
		"RightUpperArm",
		"LeftUpperArm",
		"RightLowerArm",
		"LeftLowerArm",
		"RightHand",
		"LeftHand",
		"RightUpperLeg",
		"LeftUpperLeg",
		"RightLowerLeg",
		"LeftLowerLeg",
		"RightFoot",
		"LeftFoot",
		"Torso",
		"Right Arm",
		"Left Arm",
		"Right Leg",
		"Left Leg",
		"HumanoidRootPart"
	}
	local function FREEZENOOB(v)
		if v:IsA("BasePart" or "UnionOperation") and v.Anchored == false then
			local BADD = false
			for i = 1,#badnames do
				if v.Name == badnames[i] then
					BADD = true
				end
			end
			if speaker.Character and v:IsDescendantOf(speaker.Character) then
				BADD = true
			end
			if BADD == false then
				for i, c in ipairs(v:GetChildren()) do
					if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
						c:Destroy()
					end
				end
				local bodypos = Instance.new("BodyPosition")
				bodypos.Parent = v
				bodypos.Position = v.Position
				bodypos.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
				local bodygyro = Instance.new("BodyGyro")
				bodygyro.Parent = v
				bodygyro.CFrame = v.CFrame
				bodygyro.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
				if not table.find(frozenParts,v) then
					table.insert(frozenParts,v)
				end
			end
		end
	end
	for i, v in ipairs(workspace:GetDescendants()) do
		FREEZENOOB(v)
	end
	freezingua = workspace.DescendantAdded:Connect(FREEZENOOB)
end)

addcmd('thawunanchored',{'thawua','unfreezeunanchored','unfreezeua'},function(args, speaker)
	if freezingua then
		freezingua:Disconnect()
	end
	for i,v in pairs(frozenParts) do
		for i, c in ipairs(v:GetChildren()) do
			if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
				c:Destroy()
			end
		end
	end
	frozenParts = {}
end)

addcmd('tpunanchored',{'tpua'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for i,v in pairs(players) do
		local Forces = {}
		for _, part in ipairs(workspace:GetDescendants()) do
			if Players[v].Character:FindFirstChild('Head') and part:IsA("BasePart" or "UnionOperation" or "Model") and part.Anchored == false and not part:IsDescendantOf(speaker.Character) and part.Name == "Torso" == false and part.Name == "Head" == false and part.Name == "Right Arm" == false and part.Name == "Left Arm" == false and part.Name == "Right Leg" == false and part.Name == "Left Leg" == false and part.Name == "HumanoidRootPart" == false then
				for i, c in ipairs(part:GetChildren()) do
					if c:IsA("BodyPosition") or c:IsA("BodyGyro") then
						c:Destroy()
					end
				end
				local ForceInstance = Instance.new("BodyPosition")
				ForceInstance.Parent = part
				ForceInstance.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				table.insert(Forces, ForceInstance)
				if not table.find(frozenParts,part) then
					table.insert(frozenParts,part)
				end
			end
		end
		for i,c in pairs(Forces) do
			c.Position = Players[v].Character.Head.Position
		end
	end
end)

keycodeMap = {
	["0"] = 0x30,
	["1"] = 0x31,
	["2"] = 0x32,
	["3"] = 0x33,
	["4"] = 0x34,
	["5"] = 0x35,
	["6"] = 0x36,
	["7"] = 0x37,
	["8"] = 0x38,
	["9"] = 0x39,
	["a"] = 0x41,
	["b"] = 0x42,
	["c"] = 0x43,
	["d"] = 0x44,
	["e"] = 0x45,
	["f"] = 0x46,
	["g"] = 0x47,
	["h"] = 0x48,
	["i"] = 0x49,
	["j"] = 0x4A,
	["k"] = 0x4B,
	["l"] = 0x4C,
	["m"] = 0x4D,
	["n"] = 0x4E,
	["o"] = 0x4F,
	["p"] = 0x50,
	["q"] = 0x51,
	["r"] = 0x52,
	["s"] = 0x53,
	["t"] = 0x54,
	["u"] = 0x55,
	["v"] = 0x56,
	["w"] = 0x57,
	["x"] = 0x58,
	["y"] = 0x59,
	["z"] = 0x5A,
	["enter"] = 0x0D,
	["shift"] = 0x10,
	["ctrl"] = 0x11,
	["alt"] = 0x12,
	["pause"] = 0x13,
	["capslock"] = 0x14,
	["spacebar"] = 0x20,
	["space"] = 0x20,
	["pageup"] = 0x21,
	["pagedown"] = 0x22,
	["end"] = 0x23,
	["home"] = 0x24,
	["left"] = 0x25,
	["up"] = 0x26,
	["right"] = 0x27,
	["down"] = 0x28,
	["insert"] = 0x2D,
	["delete"] = 0x2E,
	["f1"] = 0x70,
	["f2"] = 0x71,
	["f3"] = 0x72,
	["f4"] = 0x73,
	["f5"] = 0x74,
	["f6"] = 0x75,
	["f7"] = 0x76,
	["f8"] = 0x77,
	["f9"] = 0x78,
	["f10"] = 0x79,
	["f11"] = 0x7A,
	["f12"] = 0x7B,
}
autoKeyPressing = false
cancelAutoKeyPress = nil

addcmd('autokeypress',{'keypress'},function(args, speaker)
	if keypress and keyrelease and args[1] then
		local code = keycodeMap[args[1]:lower()]
		if not code then notify('Auto Key Press',"Invalid key") return end
		execCmd('unautokeypress')
		task.wait()
		local clickDelay = 0.1
		local releaseDelay = 0.1
		if args[2] and isNumber(args[2]) then clickDelay = args[2] end
		if args[3] and isNumber(args[3]) then releaseDelay = args[3] end
		autoKeyPressing = true
		cancelAutoKeyPress = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
			if not gameProcessedEvent then
				if (input.KeyCode == Enum.KeyCode.Backspace and UserInputService:IsKeyDown(Enum.KeyCode.Equals)) or (input.KeyCode == Enum.KeyCode.Equals and UserInputService:IsKeyDown(Enum.KeyCode.Backspace)) then
					autoKeyPressing = false
					cancelAutoKeyPress:Disconnect()
				end
			end
		end)
		notify('Auto Key Press',"Press [backspace] and [=] at the same time to stop")
		repeat task.wait(clickDelay)
			keypress(code)
			task.wait(releaseDelay)
			keyrelease(code)
		until autoKeyPressing == false
		if cancelAutoKeyPress then cancelAutoKeyPress:Disconnect() keyrelease(code) end
	else
		notify('Auto Key Press',"Your exploit doesn't have the ability to use auto key press")
	end
end)

addcmd('unautokeypress',{'noautokeypress','unkeypress','nokeypress'},function(args, speaker)
	autoKeyPressing = false
	if cancelAutoKeyPress then cancelAutoKeyPress:Disconnect() end
end)

