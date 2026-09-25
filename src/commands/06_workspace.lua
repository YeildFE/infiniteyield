addcmd('unlockws',{'unlockworkspace'},function(args, speaker)
	for i, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Locked = false
		end
	end
end)

addcmd('lockws',{'lockworkspace'},function(args, speaker) 
	for i, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Locked = true
		end
	end
end)

addcmd('delete',{'remove'},function(args, speaker)
	for i, v in ipairs(workspace:GetDescendants()) do
		if v.Name:lower() == getstring(1, args):lower() then
			v:Destroy()
		end
	end
	notify('Item(s) Deleted','Deleted ' ..getstring(1, args))
end)

addcmd('deleteclass',{'removeclass','deleteclassname','removeclassname','dc'},function(args, speaker)
	for i, v in ipairs(workspace:GetDescendants()) do
		if v.ClassName:lower() == getstring(1, args):lower() then
			v:Destroy()
		end
	end
	notify('Item(s) Deleted','Deleted items with ClassName ' ..getstring(1, args))
end)

addcmd('chardelete',{'charremove','cd'},function(args, speaker)
	for i, v in ipairs(speaker.Character:GetDescendants()) do
		if v.Name:lower() == getstring(1, args):lower() then
			v:Destroy()
		end
	end
	notify('Item(s) Deleted','Deleted ' ..getstring(1, args))
end)

addcmd('chardeleteclass',{'charremoveclass','chardeleteclassname','charremoveclassname','cdc'},function(args, speaker)
	for i, v in ipairs(speaker.Character:GetDescendants()) do
		if v.ClassName:lower() == getstring(1, args):lower() then
			v:Destroy()
		end
	end
	notify('Item(s) Deleted','Deleted items with ClassName ' ..getstring(1, args))
end)

addcmd('deletevelocity',{'dv','removevelocity','removeforces'},function(args, speaker)
	for i, v in ipairs(speaker.Character:GetDescendants()) do
		if v:IsA("BodyVelocity") or v:IsA("BodyGyro") or v:IsA("RocketPropulsion") or v:IsA("BodyThrust") or v:IsA("BodyAngularVelocity") or v:IsA("AngularVelocity") or v:IsA("BodyForce") or v:IsA("VectorForce") or v:IsA("LineForce") then
			v:Destroy()
		end
	end
end)

addcmd('deleteinvisparts',{'deleteinvisibleparts','dip'},function(args, speaker)
	for i, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and v.Transparency == 1 and v.CanCollide then
			v:Destroy()
		end
	end
end)

local shownParts = {}
addcmd('invisibleparts',{'invisparts'},function(args, speaker)
	for i, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and v.Transparency == 1 then
			if not table.find(shownParts,v) then
				table.insert(shownParts,v)
			end
			v.Transparency = 0
		end
	end
end)

addcmd('uninvisibleparts',{'uninvisparts'},function(args, speaker)
	for i,v in pairs(shownParts) do
		v.Transparency = 1
	end
	shownParts = {}
end)

addcmd("btools", {}, function(args, speaker)
	for i = 1, 4 do
		local Tool = Instance.new("HopperBin")
		Tool.BinType = i
		-- IY_NAME: was randomString()
		Tool.Name = "IYBtool"
		Tool.Parent = speaker:FindFirstChildWhichIsA("Backpack")
	end
end)

addcmd("f3x", {"fex"}, function(args, speaker)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/corecommit/backup/refs/heads/main/f3x.lua"))()
end)

addcmd("partpath", {"partname"}, function(args, speaker)
	selectPart()
end)

addcmd("antiafk", {"antiidle"}, function(args, speaker)
	if getconnections then
		for _, connection in pairs(getconnections(speaker.Idled)) do
			if connection["Disable"] then
				connection["Disable"](connection)
			elseif connection["Disconnect"] then
				connection["Disconnect"](connection)
			end
		end
	else
		speaker.Idled:Connect(function()
			Services.VirtualUser:CaptureController()
			Services.VirtualUser:ClickButton2(Vector2.new())
		end)
	end
	if not (args[1] and tostring(args[1]) == "nonotify") then notify("Anti Idle", "Anti idle is enabled") end
end)

addcmd("datalimit", {}, function(args, speaker)
	local kbps = tonumber(args[1])
	if kbps then
		Services.NetworkClient:SetOutgoingKBPSLimit(kbps)
	end
end)

addcmd("replicationlag", {"backtrack"}, function(args, speaker)
	if tonumber(args[1]) then
		settings():GetService("NetworkSettings").IncomingReplicationLag = args[1]
	end
end)

addcmd("noprompts", {"nopurchaseprompts"}, function(args, speaker)
	COREGUI.PurchasePromptApp.Enabled = false
end)

addcmd("showprompts", {"showpurchaseprompts"}, function(args, speaker)
	COREGUI.PurchasePromptApp.Enabled = true
end)

promptNewRig = function(speaker, rig)
	local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		AvatarEditorService:PromptSaveAvatar(humanoid.HumanoidDescription, Enum.HumanoidRigType[rig])
		local result = AvatarEditorService.PromptSaveAvatarCompleted:Wait()
		if result == Enum.AvatarPromptResult.Success then
			execCmd("reset")
		end
	end
end

addcmd("promptr6", {}, function(args, speaker)
	promptNewRig(speaker, "R6")
end)

addcmd("promptr15", {}, function(args, speaker)
	promptNewRig(speaker, "R15")
end)

addcmd("wallwalk", {"walkonwalls"}, function(args, speaker)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/corecommit/backup/refs/heads/main/wallwalker.lua"))()
end)

