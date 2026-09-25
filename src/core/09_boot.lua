addcmd("debug", {}, function(args, speaker)
    local opt = parseBoolean(args[1], true)
    _G.IY_DEBUG = opt
    notify("debug", tostring(opt), 1)
end)

addcmd('loop', {'repeat'}, function(args, speaker)
    local numArgs = #args
    if numArgs < 2 then
        notify("Loop", "Usage: loop [command] [times] [delay]", 3)
        return
    end

    local times, delay
    local cmdEnd = numArgs

    local last = args[numArgs]
    local secondLast = args[numArgs - 1]

    if last and (last == "inf" or tonumber(last)) then
        if secondLast and (secondLast == "inf" or tonumber(secondLast)) then
            times = secondLast == "inf" and "inf" or tonumber(secondLast)
            delay = last == "inf" and "inf" or tonumber(last)
            cmdEnd = numArgs - 2
        else
            times = last == "inf" and "inf" or tonumber(last)
            delay = 0
            cmdEnd = numArgs - 1
        end
    else
        notify("Loop", "Usage: loop [command] [times] [delay]", 3)
        return
    end

    if not times or (type(times) == "number" and times <= 0) then
        notify("Loop", "Times must be a positive number or 'inf'", 3)
        return
    end

    local cmdParts = {}
    for i = 1, cmdEnd do
        cmdParts[#cmdParts + 1] = args[i]
    end
    local cmdStr = table.concat(cmdParts, " ")
    if cmdStr == "" then
        notify("Loop", "Usage: loop [command] [times] [delay]", 3)
        return
    end

    local loopStr
    if times == "inf" then
        loopStr = delay and tonumber(delay) and delay > 0 and ("inf^%s^%s"):format(delay, cmdStr) or ("inf^%s"):format(cmdStr)
    else
        loopStr = delay and tonumber(delay) and delay > 0 and ("%s^%s^%s"):format(times, delay, cmdStr) or ("%s^%s"):format(times, cmdStr)
    end

    execCmd(loopStr, speaker, true)
    notify("Loop", ("Looping '%s' %s time(s)"):format(cmdStr, times), 1)
end)

addcmd('kill', {}, function(args, speaker)
    notify("Kill", "Infinite Yield has been removed", 2)
    pcall(function()
        local gui = PARENT:FindFirstChild("IYScaledHolder") or ScaledHolder
        if gui then gui:Destroy() end
        if PARENT.Name == "IYMainGui" then PARENT:Destroy() end
    end)
    pcall(function()
        local oldGui = COREGUI:FindFirstChild("IYMainGui")
        if oldGui then oldGui:Destroy() end
    end)
    cmds = {}
    customAlias = {}
    lastCmds = {}
    cmdHistory = {}
    _G.IY_LOADED = nil
    IY_LOADED = nil
    getgenv().IY_LOADED = nil
end)

if IsOnMobile then
	local QuickCapture = Instance.new("TextButton")
	local UICorner = Instance.new("UICorner")
	-- IY_NAME: was randomString()
	QuickCapture.Name = "IYQuickCapture"
	QuickCapture.Parent = PARENT
	QuickCapture.BackgroundColor3 = Color3.fromRGB(46, 46, 47)
	QuickCapture.BackgroundTransparency = 0.14
	QuickCapture.Position = UDim2.new(0.489, 0, 0, 0)
	QuickCapture.Size = UDim2.new(0, 32, 0, 33)
	QuickCapture.Font = Enum.Font.SourceSansBold
	QuickCapture.Text = "IY"
	QuickCapture.TextColor3 = Color3.fromRGB(255, 255, 255)
	QuickCapture.TextSize = 20
	QuickCapture.TextWrapped = true
	QuickCapture.ZIndex = 10
	QuickCapture.Draggable = true
	-- IY_NAME: was randomString()
	UICorner.Name = "IYQuickCaptureCorner"
	UICorner.CornerRadius = UDim.new(0.5, 0)
	UICorner.Parent = QuickCapture
	QuickCapture.MouseButton1Click:Connect(function()
		Cmdbar:CaptureFocus()
		maximizeHolder()
	end)
	table.insert(shade1, QuickCapture)
	table.insert(text1, QuickCapture)
end

pcall(function() Scale.Scale = math.max(Holder.AbsoluteSize.X / 1920, guiScale) end)
Scale.Parent = ScaledHolder
ScaledHolder.Size = UDim2.fromScale(1 / Scale.Scale, 1 / Scale.Scale)
Scale:GetPropertyChangedSignal("Scale"):Connect(function()
	ScaledHolder.Size = UDim2.fromScale(1 / Scale.Scale, 1 / Scale.Scale)
	for _, v in ScaledHolder:GetDescendants() do
		if v:IsA("GuiObject") and v.Visible then
			v.Visible = false
			v.Visible = true
		end
	end
end)

updateColors(currentShade1,shade1)
updateColors(currentShade2,shade2)
updateColors(currentShade3,shade3)
updateColors(currentText1,text1)
updateColors(currentText2,text2)
updateColors(currentScroll,scroll)

if PluginsTable ~= nil or PluginsTable ~= {} then
	FindPlugins(PluginsTable)
end

-- Events
eventEditor.RegisterEvent("OnExecute")
eventEditor.RegisterEvent("OnSpawn",{
	{Type="Player",Name="Player Filter ($1)"}
})
eventEditor.RegisterEvent("OnDied",{
	{Type="Player",Name="Player Filter ($1)"}
})
eventEditor.RegisterEvent("OnDamage",{
	{Type="Player",Name="Player Filter ($1)"},
	{Type="Number",Name="Below Health ($2)"}
})
eventEditor.RegisterEvent("OnKilled",{
	{Type="Player",Name="Victim Player ($1)"},
	{Type="Player",Name="Killer Player ($2)",Default = 1}
})
eventEditor.RegisterEvent("OnJoin",{
	{Type="Player",Name="Player Filter ($1)",Default = 1}
})
eventEditor.RegisterEvent("OnLeave",{
	{Type="Player",Name="Player Filter ($1)",Default = 1}
})
eventEditor.RegisterEvent("OnChatted",{
	{Type="Player",Name="Player Filter ($1)",Default = 1},
	{Type="String",Name="Message Filter ($2)"}
})

function hookCharEvents(plr,instant)
	task.spawn(function()
		local char = plr.Character
		if not char then return end

		local humanoid = char:WaitForChild("Humanoid",10)
		if not humanoid then return end

		local oldHealth = humanoid.Health
		humanoid.HealthChanged:Connect(function(health)
			if oldHealth > health then
				eventEditor.FireEvent("OnDamage",plr.Name,tonumber(health))
			end
			oldHealth = health
		end)

		humanoid.Died:Connect(function()
			eventEditor.FireEvent("OnDied",plr.Name)

			local killedBy = humanoid:FindFirstChild("creator")
			if killedBy and killedBy.Value and killedBy.Value.Parent then
				eventEditor.FireEvent("OnKilled",plr.Name,killedBy.Value.Name)
			end
		end)
	end)
end

Players.PlayerAdded:Connect(function(plr)
	eventEditor.FireEvent("OnJoin",plr.Name)
	if isLegacyChat then plr.Chatted:Connect(function(msg) eventEditor.FireEvent("OnChatted",tostring(plr),msg) end) end
	plr.CharacterAdded:Connect(function() eventEditor.FireEvent("OnSpawn",tostring(plr)) hookCharEvents(plr) end)
	JoinLog(plr)
	if isLegacyChat then ChatLog(plr) end
	if ESPenabled then
		local timeout_esp = 0
		repeat task.wait(1) timeout_esp += 1 until (plr.Character and getRoot(plr.Character)) or timeout_esp > 10
		ESP(plr)
	end
	if CHMSenabled then
		local timeout_chms = 0
		repeat task.wait(1) timeout_chms += 1 until (plr.Character and getRoot(plr.Character)) or timeout_chms > 10
		CHMS(plr)
	end
end)

if not isLegacyChat then
	TextChatService.MessageReceived:Connect(function(message)
		if message.TextSource then
			local player = Players:GetPlayerByUserId(message.TextSource.UserId)
			if not player then return end

			if logsEnabled == true then
				CreateLabel(player.Name, message.Text)
			end
			if player.UserId == Players.LocalPlayer.UserId then
				do_exec(message.Text, Players.LocalPlayer)
			end
			eventEditor.FireEvent("OnChatted", player.Name, message.Text)
			sendChatWebhook(player, message.Text)
		end
	end)
end

for _, plr in ipairs(Players:GetPlayers()) do
	pcall(function()
		plr.CharacterAdded:Connect(function() eventEditor.FireEvent("OnSpawn",tostring(plr)) hookCharEvents(plr) end)
		hookCharEvents(plr)
	end)
end

if spawnCmds and #spawnCmds > 0 then
	for i,v in pairs(spawnCmds) do
		eventEditor.AddCmd("OnSpawn",{v.COMMAND or "",{0},v.DELAY or 0})
	end
	updatesaves()
end

if loadedEventData then eventEditor.LoadData(loadedEventData) end
eventEditor.Refresh()

eventEditor.FireEvent("OnExecute")

if aliases and #aliases > 0 then
	local cmdMap = {}
	for i,v in pairs(cmds) do
		cmdMap[v.NAME:lower()] = v
		for _,alias in pairs(v.ALIAS) do
			cmdMap[alias:lower()] = v
		end
	end
	for i = 1, #aliases do
		local cmd = string.lower(aliases[i].CMD)
		local alias = string.lower(aliases[i].ALIAS)
		if cmdMap[cmd] then
			customAlias[alias] = cmdMap[cmd]
		end
	end
	refreshaliases()
end

IYMouse.Move:Connect(checkTT)

CaptureService.CaptureBegan:Connect(function()
	PARENT.Enabled = false
end)

CaptureService.CaptureEnded:Connect(function()
	task.delay(0.1, function()
		PARENT.Enabled = true
	end)
end)

task.spawn(function()
	local success, latestVersionInfo = pcall(function() 
		local versionJson = game:HttpGet("https://raw.githubusercontent.com/corecommit/infiniteyield/master/version")
		return HttpService:JSONDecode(versionJson)
	end)

	if success and type(latestVersionInfo) == "table" and latestVersionInfo.Version then
		if currentVersion ~= latestVersionInfo.Version then
			notify("Outdated", "Get the new version at https://raw.githubusercontent.com/corecommit/infiniteyield/master")
		end

		if latestVersionInfo.Announcement and latestVersionInfo.Announcement ~= "" then
			local AnnGUI = Instance.new("Frame")
			local background = Instance.new("Frame")
			local TextBox = Instance.new("TextLabel")
			local shadow = Instance.new("Frame")
			local PopupText = Instance.new("TextLabel")
			local Exit = Instance.new("TextButton")
			local ExitImage = Instance.new("ImageLabel")

			-- IY_NAME: was randomString()
			AnnGUI.Name = "IYAnnouncementPopup"
			AnnGUI.Parent = ScaledHolder
			AnnGUI.Active = true
			AnnGUI.BackgroundTransparency = 1
			AnnGUI.Position = UDim2.new(0.5, -180, 0, -500)
			AnnGUI.Size = UDim2.new(0, 360, 0, 20)
			AnnGUI.ZIndex = 10

			background.Name = "background"
			background.Parent = AnnGUI
			background.Active = true
			background.BackgroundColor3 = currentShade1
			background.BorderSizePixel = 0
			background.Position = UDim2.new(0, 0, 0, 20)
			background.Size = UDim2.new(0, 360, 0, 150)
			background.ZIndex = 10

			TextBox.Parent = background
			TextBox.BackgroundTransparency = 1
			TextBox.Position = UDim2.new(0, 5, 0, 5)
			TextBox.Size = UDim2.new(0, 350, 0, 140)
			TextBox.Font = Enum.Font.SourceSans
			TextBox.TextSize = 18
			TextBox.TextWrapped = true
			TextBox.Text = latestVersionInfo.Announcement
			TextBox.TextColor3 = currentText1
			TextBox.TextXAlignment = Enum.TextXAlignment.Left
			TextBox.TextYAlignment = Enum.TextYAlignment.Top
			TextBox.ZIndex = 10

			shadow.Name = "shadow"
			shadow.Parent = AnnGUI
			shadow.BackgroundColor3 = currentShade2
			shadow.BorderSizePixel = 0
			shadow.Size = UDim2.new(0, 360, 0, 20)
			shadow.ZIndex = 10

			PopupText.Name = "PopupText"
			PopupText.Parent = shadow
			PopupText.BackgroundTransparency = 1
			PopupText.Size = UDim2.new(1, 0, 0.95, 0)
			PopupText.ZIndex = 10
			PopupText.Font = Enum.Font.SourceSans
			PopupText.TextSize = 14
			PopupText.Text = "Server Announcement"
			PopupText.TextColor3 = currentText1
			PopupText.TextWrapped = true

			Exit.Name = "Exit"
			Exit.Parent = shadow
			Exit.BackgroundTransparency = 1
			Exit.Position = UDim2.new(1, -20, 0, 0)
			Exit.Size = UDim2.new(0, 20, 0, 20)
			Exit.Text = ""
			Exit.ZIndex = 10

			ExitImage.Parent = Exit
			ExitImage.BackgroundColor3 = Color3.new(1, 1, 1)
			ExitImage.BackgroundTransparency = 1
			ExitImage.Position = UDim2.new(0, 5, 0, 5)
			ExitImage.Size = UDim2.new(0, 10, 0, 10)
			ExitImage.Image = getcustomasset("infiniteyield/assets/close.png")
			ExitImage.ZIndex = 10

			task.wait(1)
			TweenService:Create(AnnGUI, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, -180, 0, 150)}):Play()

			Exit.MouseButton1Click:Connect(function()
				TweenService:Create(AnnGUI, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, -180, 0, -500)}):Play()
				task.wait(0.6)
				AnnGUI:Destroy()
			end)
		end
	end
end)

task.spawn(function()
    task.wait()
    pcall(function()
        TweenService:Create(Credits, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0.9, 0)}):Play()
        TweenService:Create(Logo, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 175, 0, 175), Position = UDim2.new(0, 37, 0, 45)}):Play()
        task.wait(2)
        local OutInfo = TweenInfo.new(1.6809, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
        TweenService:Create(Logo, OutInfo, {ImageTransparency = 1}):Play()
        TweenService:Create(IntroBackground, OutInfo, {BackgroundTransparency = 1}):Play()
        TweenService:Create(Credits, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0.9, 30)}):Play()
        task.wait(0.2)
    end)
    Logo:Destroy()
    Credits:Destroy()
    IntroBackground:Destroy()
    minimizeHolder()
end)
