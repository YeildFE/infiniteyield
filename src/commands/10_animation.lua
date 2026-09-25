addcmd("team", {}, function(args, speaker)
	local teamName = getstring(1, args)
	local team = nil
	local root = speaker.Character and getRoot(speaker.Character)
	for _, v in ipairs(Teams:GetChildren()) do
		if v.Name:lower():match(teamName:lower()) then
			team = v
			break
		end
	end
	if not team then
		return notify("Invalid Team", teamName .. " is not a valid team")
	end
	if root and firetouchinterest then
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("SpawnLocation") and v.BrickColor == team.TeamColor and v.AllowTeamChangeOnTouch == true then
				firetouchinterest(v, root, 0)
				firetouchinterest(v, root, 1)
				break
			end
		end
	else
		speaker.Team = team
	end
end)

addcmd('nobgui',{'unbgui','nobillboardgui','unbillboardgui','noname','rohg'},function(args, speaker)
	for i, v in ipairs(speaker.Character:GetDescendants())do
		if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
			v:Destroy()
		end
	end
end)

addcmd('loopnobgui',{'loopunbgui','loopnobillboardgui','loopunbillboardgui','loopnoname','looprohg'},function(args, speaker)
	for i, v in ipairs(speaker.Character:GetDescendants())do
		if v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
			v:Destroy()
		end
	end
	local function charPartAdded(part)
		if part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
			task.wait()
			part:Destroy()
		end
	end
	charPartTrigger = speaker.Character.DescendantAdded:Connect(charPartAdded)
end)

addcmd('unloopnobgui',{'unloopunbgui','unloopnobillboardgui','unloopunbillboardgui','unloopnoname','unlooprohg'},function(args, speaker)
	if charPartTrigger then
		charPartTrigger:Disconnect()
	end
end)

addcmd('spasm',{},function(args, speaker)
	if not r15(speaker) then
		local pchar=speaker.Character
		local AnimationId = "33796059"
		SpasmAnim = Instance.new("Animation")
		SpasmAnim.AnimationId = "rbxassetid://"..AnimationId
		Spasm = pchar:FindFirstChildOfClass('Humanoid'):LoadAnimation(SpasmAnim)
		Spasm:Play()
		Spasm:AdjustSpeed(99)
	else
		notify('R6 Required','This command requires the r6 rig type')
	end
end)

addcmd('unspasm',{'nospasm'},function(args, speaker)
	Spasm:Stop()
	SpasmAnim:Destroy()
end)

addcmd('headthrow',{},function(args, speaker)
	if not r15(speaker) then
		local AnimationId = "35154961"
		local Anim = Instance.new("Animation")
		Anim.AnimationId = "rbxassetid://"..AnimationId
		local k = speaker.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(Anim)
		k:Play(0)
		k:AdjustSpeed(1)
	else
		notify('R6 Required','This command requires the r6 rig type')
	end
end)

local function anim2track(asset_id)
	local objs = game:GetObjects(asset_id)
	for i = 1, #objs do
		if objs[i]:IsA("Animation") then
			return objs[i].AnimationId
		end
	end
	return asset_id
end

addcmd("animation", {"anim"}, function(args, speaker)
	local animid = tostring(args[1])
	if not animid:find("rbxassetid://") then
		animid = "rbxassetid://" .. animid
	end
	animid = anim2track(animid)
	local animation = Instance.new("Animation")
	animation.AnimationId = animid
	local anim = speaker.Character:FindFirstChildWhichIsA("Humanoid"):LoadAnimation(animation)
	anim.Priority = Enum.AnimationPriority.Movement
	anim:Play()
	if args[2] then anim:AdjustSpeed(tostring(args[2])) end
end)

addcmd("emote", {"em"}, function(args, speaker)
	local anim = humanoid:PlayEmoteAndGetAnimTrackById(args[1])
	if args[2] then anim:AdjustSpeed(tostring(args[2])) end
end)


addcmd('noanim',{},function(args, speaker)
	speaker.Character.Animate.Disabled = true
end)

addcmd('reanim',{},function(args, speaker)
	speaker.Character.Animate.Disabled = false
end)

addcmd('animspeed',{},function(args, speaker)
	local Char = speaker.Character
	local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

	for i,v in next, Hum:GetPlayingAnimationTracks() do
		v:AdjustSpeed(tonumber(args[1] or 1))
	end
end)

addcmd('copyanimation',{'copyanim','copyemote'},function(args, speaker)
	local players = getPlayer(args[1], speaker)
	for _,v in ipairs(players)do
		local char = Players[v].Character
		for _, v1 in ipairs(speaker.Character:FindFirstChildOfClass('Humanoid'):GetPlayingAnimationTracks()) do
			v1:Stop()
		end
		for _, v1 in ipairs(Players[v].Character:FindFirstChildOfClass('Humanoid'):GetPlayingAnimationTracks()) do
			if not string.find(v1.Animation.AnimationId, "507768375") then
				local ANIM = speaker.Character:FindFirstChildOfClass('Humanoid'):LoadAnimation(v1.Animation)
				ANIM:Play(.1, 1, v1.Speed)
				ANIM.TimePosition = v1.TimePosition
				task.spawn(function()
					v1.Stopped:Wait()
					ANIM:Stop()
					ANIM:Destroy()
				end)
			end
		end
	end
end)

addcmd("copyanimationid", {"copyanimid", "copyemoteid"}, function(args, speaker)
	local copyAnimId = function(player)
		local found = "Animations Copied"

		for _, v in pairs(player.Character:FindFirstChildWhichIsA("Humanoid"):GetPlayingAnimationTracks()) do
			local animationId = v.Animation.AnimationId
			local assetId = animationId:find("rbxassetid://") and animationId:match("%d+")

			if not string.find(animationId, "507768375") and not string.find(animationId, "180435571") then
				if assetId then
					local success, result = pcall(function()
						return MarketplaceService:GetProductInfo(tonumber(assetId)).Name
					end)
					local name = success and result or "Failed to get name"
					found = found .. "\n\nName: " .. name .. "\nAnimation Id: " .. animationId
				else
					found = found .. "\n\nAnimation Id: " .. animationId
				end
			end
		end

		if found ~= "Animations Copied" then
			toClipboard(found)
		else
			notify("Animations", "No animations to copy")
		end
	end

	if args[1] then
		copyAnimId(Players[getPlayer(args[1], speaker)[1]])
	else
		copyAnimId(speaker)
	end
end)

addcmd('stopanimations',{'stopanims','stopanim'},function(args, speaker)
	local Char = speaker.Character
	local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

	for i,v in next, Hum:GetPlayingAnimationTracks() do
		v:Stop()
	end
end)

addcmd('refreshanimations', {'refreshanimation', 'refreshanims', 'refreshanim'}, function(args, speaker)
	local Char = speaker.Character or speaker.CharacterAdded:Wait()
	local Human = Char and Char:WaitForChild('Humanoid', 15)
	local Animate = Char and Char:WaitForChild('Animate', 15)
	if not Human or not Animate then
		return notify('Refresh Animations', 'Failed to get Animate/Humanoid')
	end
	Animate.Disabled = true
	for _, v in ipairs(Human:GetPlayingAnimationTracks()) do
		v:Stop()
	end
	Animate.Disabled = false
end)

addcmd('allowcustomanim', {'allowcustomanimations'}, function(args, speaker)
	StarterPlayer.AllowCustomAnimations = true
	execCmd('refreshanimations')
end)

addcmd('unallowcustomanim', {'unallowcustomanimations'}, function(args, speaker)
	StarterPlayer.AllowCustomAnimations = false
	execCmd('refreshanimations')
end)

addcmd('loopanimation', {'loopanim'},function(args, speaker)
	local Char = speaker.Character
	local Human = Char and Char.FindFirstChildWhichIsA(Char, "Humanoid")
	for _, v in ipairs(Human.GetPlayingAnimationTracks(Human)) do
		v.Looped = true
	end
end)

