addcmd('tools',{'gears'},function(args, speaker)
	local function copy(instance)
		for i, c in ipairs(instance:GetChildren())do
			if c:IsA('Tool') or c:IsA('HopperBin') then
				c:Clone().Parent = speaker:FindFirstChildOfClass("Backpack")
			end
			copy(c)
		end
	end
	copy(Lighting)
	local function copy(instance)
		for i, c in ipairs(instance:GetChildren())do
			if c:IsA('Tool') or c:IsA('HopperBin') then
				c:Clone().Parent = speaker:FindFirstChildOfClass("Backpack")
			end
			copy(c)
		end
	end
	copy(ReplicatedStorage)
	notify('Tools','Copied tools from ReplicatedStorage and Lighting')
end)

addcmd('notools',{'rtools','clrtools','removetools','deletetools','dtools'},function(args, speaker)
	for i,v in ipairs(speaker:FindFirstChildOfClass("Backpack"):GetDescendants()) do
		if v:IsA('Tool') or v:IsA('HopperBin') then
			v:Destroy()
		end
	end
	for i, v in ipairs(speaker.Character:GetDescendants()) do
		if v:IsA('Tool') or v:IsA('HopperBin') then
			v:Destroy()
		end
	end
end)

addcmd('deleteselectedtool',{'dst'},function(args, speaker)
	for i, v in ipairs(speaker.Character:GetDescendants()) do
		if v:IsA('Tool') or v:IsA('HopperBin') then
			v:Destroy()
		end
	end
end)

addcmd("console", {}, function(args, speaker)
	StarterGui:SetCore("DevConsoleVisible", true)
end)

addcmd('oldconsole',{},function(args, speaker)
	-- Thanks wally!!
	notify("Loading",'Hold on a sec')
	local _, str = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/corecommit/backup/refs/heads/main/console.lua", true)
	end)

	local s, e = loadstring(str)
	if typeof(s) ~= "function" then
		return
	end

	local success, message = pcall(s)
	if (not success) then
		if printconsole then
			printconsole(message)
		elseif printoutput then
			printoutput(message)
		end
	end
	task.wait(1)
	notify('Console','Press F9 to open the console')
end)

addcmd("explorer", {"dex"}, function(args, speaker)
	notify("Loading Dex Explorer", "Hold on a sec")
	loadstring(game:HttpGet("https://github.com/AZYsGithub/DexPlusPlus/releases/latest/download/out.lua"))()
end)

addcmd('olddex', {'odex'}, function(args, speaker)
	notify('Loading old explorer', 'Hold on a sec')
	loadstring(game:HttpGet("https://raw.githubusercontent.com/corecommit/backup/refs/heads/main/dex.lua"))()
end)

addcmd('remotespy',{'rspy'},function(args, speaker)
	notify("Loading remote spy",'Hold on a sec')
	loadstring(game:HttpGet("https://raw.githubusercontent.com/corecommit/backup/refs/heads/main/SimpleSpyV3/main.lua"))()
end)

addcmd('cobalt',{'cspy'},function(args, speaker)
	notify("Loading Cobalt",'Hold on a sec')
	loadstring(game:HttpGet("https://github.com/notpoiu/cobalt/releases/latest/download/Cobalt.luau"))()
end)

addcmd('audiologger',{'alogger'},function(args, speaker)
	notify("Loading",'Hold on a sec')
	loadstring(game:HttpGet(('https://raw.githubusercontent.com/corecommit/backup/refs/heads/main/audiologger.lua'),true))()
end)

local loopgoto = nil

addcmd('vex',{'vexe'},function(args, speaker)
	notify('Loading Vex Explorer', 'Hold on a sec')
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Vezise/2026/main/Vez/VexExplorer/VEXExplorer.lua"))()
end)

