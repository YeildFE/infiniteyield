addcmd('pluginstore',{'ps','store'},function(args, speaker)
	if not writefileExploit() then
		notify('Plugin Store', 'Your exploit does not support plugins (missing writefile)')
		return
	end
	task.spawn(function()
		local PLUGIN_URL = 'https://raw.githubusercontent.com/corecommit/plugin-store/main/plugins.json'
		local plugins
		local success, result = pcall(function()
			return game:HttpGet(PLUGIN_URL, true)
		end)
		if not success then
			notify('Plugin Store','Failed to connect to plugin store')
			return
		end
		local success2, data = pcall(function()
			return HttpService:JSONDecode(result)
		end)
		if not success2 then
			notify('Plugin Store','Failed to parse plugin data')
			return
		end
		plugins = data

		local storeGui = Instance.new("ScreenGui")
		storeGui.Name = "Plugin Store"
		storeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		storeGui.ResetOnSpawn = false
		storeGui.Parent = game:GetService("CoreGui")

		local function showError(title, message)
			local errGui = Instance.new("ScreenGui")
			errGui.Name = "ErrorPopup"
			errGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			errGui.ResetOnSpawn = false
			errGui.Parent = game:GetService("CoreGui")

			local box = Instance.new("Frame")
			box.Size = UDim2.new(0.275, 0, 0.199, 0)
			box.AnchorPoint = Vector2.new(0.5, 0.5)
			box.Position = UDim2.new(0.5, 0, 0.5, 0)
			box.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
			box.BorderSizePixel = 0
			box.ZIndex = 11
			box.Parent = errGui

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0.08, 0)
			corner.Parent = box

			local bar = Instance.new("Frame")
			bar.Size = UDim2.new(1, 0, 0.25, 0)
			bar.Position = UDim2.new(0.5, 0, 0.125, 0)
			bar.AnchorPoint = Vector2.new(0.5, 0.5)
			bar.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
			bar.BorderSizePixel = 0
			bar.ZIndex = 12
			bar.Parent = box

			local barCorner = Instance.new("UICorner")
			barCorner.CornerRadius = UDim.new(0.3, 0)
			barCorner.Parent = bar

			local barFix = Instance.new("Frame")
			barFix.Size = UDim2.new(1, 0, 0.5, 0)
			barFix.AnchorPoint = Vector2.new(0.5, 0.5)
			barFix.Position = UDim2.new(0.5, 0, 0.75, 0)
			barFix.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
			barFix.BorderSizePixel = 0
			barFix.ZIndex = 12
			barFix.Parent = bar

			local titleLbl = Instance.new("TextLabel")
			titleLbl.Text = "⚠ " .. title
			titleLbl.Size = UDim2.new(0.971, 0, 1, 0)
			titleLbl.Position = UDim2.new(0.515, 0, 0.5, 0)
			titleLbl.AnchorPoint = Vector2.new(0.5, 0.5)
			titleLbl.BackgroundTransparency = 1
			titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
			titleLbl.TextScaled = true
			titleLbl.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json")
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.ZIndex = 13
			titleLbl.Parent = bar

			local msgLbl = Instance.new("TextLabel")
			msgLbl.Text = message
			msgLbl.Size = UDim2.new(0.941, 0, 0.438, 0)
			msgLbl.Position = UDim2.new(0.5, 0, 0.519, 0)
			msgLbl.AnchorPoint = Vector2.new(0.5, 0.5)
			msgLbl.BackgroundTransparency = 1
			msgLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
			msgLbl.TextWrapped = true
			msgLbl.TextSize = 30
			msgLbl.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json")
			msgLbl.TextXAlignment = Enum.TextXAlignment.Center
			msgLbl.TextYAlignment = Enum.TextYAlignment.Center
			msgLbl.ZIndex = 12
			msgLbl.Parent = box

			local okBtn = Instance.new("TextButton")
			okBtn.Text = "OK"
			okBtn.Size = UDim2.new(0.294, 0, 0.2, 0)
			okBtn.AnchorPoint = Vector2.new(0.5, 0.5)
			okBtn.Position = UDim2.new(0.5, 0, 0.838, 0)
			okBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
			okBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			okBtn.TextScaled = true
			okBtn.BorderSizePixel = 0
			okBtn.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json")
			okBtn.ZIndex = 12
			okBtn.Parent = box

			local okCorner = Instance.new("UICorner")
			okCorner.CornerRadius = UDim.new(0.3, 0)
			okCorner.Parent = okBtn

			okBtn.MouseButton1Click:Connect(function()
				errGui:Destroy()
			end)
		end

		local function setGuiVisible(gui, state)
			if gui and gui.Parent then
				pcall(function()
					gui.Visible = state
				end)
			end
		end

		local MainFrame = Instance.new("Frame")
		MainFrame.Name = "Main Frame"
		MainFrame.BorderSizePixel = 0
		MainFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
		MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		MainFrame.Size = UDim2.new(0.5, 0, 0.55, 0)
		MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MainFrame.Parent = storeGui

		local MainFrameAspectRatio = Instance.new("UIAspectRatioConstraint")
		MainFrameAspectRatio.AspectRatio = 1.40279
		MainFrameAspectRatio.Parent = MainFrame

		local SearchBar = Instance.new("TextBox")
		SearchBar.Name = "SearchBar"
		SearchBar.CursorPosition = -1
		SearchBar.PlaceholderColor3 = Color3.fromRGB(61, 61, 61)
		SearchBar.PlaceholderText = "Search for plugins..."
		SearchBar.Text = ""
		SearchBar.BorderSizePixel = 0
		SearchBar.TextWrapped = true
		SearchBar.TextSize = 35
		SearchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
		SearchBar.TextScaled = true
		SearchBar.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
		SearchBar.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		SearchBar.AnchorPoint = Vector2.new(0.5, 0.5)
		SearchBar.Size = UDim2.new(1, 0, 0.08, 0)
		SearchBar.Position = UDim2.new(0.5, 0, 0.03957, 0)
		SearchBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SearchBar.Visible = false
		SearchBar.ZIndex = 3
		SearchBar.Parent = MainFrame

		local SearchBarAspectRatio = Instance.new("UIAspectRatioConstraint")
		SearchBarAspectRatio.AspectRatio = 17.5349
		SearchBarAspectRatio.Parent = SearchBar

		local Header = Instance.new("TextLabel")
		Header.Name = "Header"
		Header.Text = "Plugin Store"
		Header.TextWrapped = true
		Header.ZIndex = 2
		Header.BorderSizePixel = 0
		Header.TextSize = 14
		Header.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
		Header.TextScaled = true
		Header.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
		Header.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		Header.TextColor3 = Color3.fromRGB(255, 255, 255)
		Header.AnchorPoint = Vector2.new(0.5, 0.5)
		Header.Size = UDim2.new(1, 0, 0.08, 0)
		Header.Position = UDim2.new(0.5, 0, 0.04, 0)
		Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Header.Parent = MainFrame

		local HeaderAspectRatio = Instance.new("UIAspectRatioConstraint")
		HeaderAspectRatio.AspectRatio = 17.5349
		HeaderAspectRatio.Parent = Header

		local CloseButton = Instance.new("TextButton")
		CloseButton.Text = "X"
		CloseButton.TextWrapped = true
		CloseButton.BorderSizePixel = 0
		CloseButton.TextSize = 14
		CloseButton.AutoButtonColor = false
		CloseButton.TextScaled = true
		CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		CloseButton.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
		CloseButton.BackgroundTransparency = 1
		CloseButton.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
		CloseButton.Size = UDim2.new(0.05793, 0, 1.00796, 0)
		CloseButton.Position = UDim2.new(0.97104, 0, 0.49602, 0)
		CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CloseButton.Parent = Header

		CloseButton.MouseButton1Click:Connect(function()
			storeGui:Destroy()
		end)

		local CloseButtonAspectRatio = Instance.new("UIAspectRatioConstraint")
		CloseButtonAspectRatio.AspectRatio = 1.00776
		CloseButtonAspectRatio.Parent = CloseButton

		local IconButton = Instance.new("ImageButton")
		IconButton.BorderSizePixel = 0
		IconButton.ScaleType = Enum.ScaleType.Fit
		IconButton.BackgroundTransparency = 1
		IconButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		IconButton.AnchorPoint = Vector2.new(0.5, 0.5)
		IconButton.Image = "rbxassetid://129011728174193"
		IconButton.Size = UDim2.new(0.05663, 0, 0.99308, 0)
		IconButton.Position = UDim2.new(0.91359, 0, 0.5, 0)
		IconButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		IconButton.Parent = Header

		IconButton.MouseButton1Click:Connect(function()
			SearchBar.Visible = not SearchBar.Visible
			if SearchBar.Visible then
				SearchBar:CaptureFocus()
			else
				SearchBar.Text = ''
			end
		end)

		SearchBar.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				SearchBar.Visible = false
				SearchBar.Text = ''
			end
		end)

		game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
			if processed then return end
			if input.KeyCode == Enum.KeyCode.Escape and SearchBar.Visible then
				SearchBar.Visible = false
				SearchBar.Text = ''
			end
		end)

		local IconButtonAspectRatio = Instance.new("UIAspectRatioConstraint")
		IconButtonAspectRatio.Parent = IconButton

		local ScrollingFrame = Instance.new("ScrollingFrame")
		ScrollingFrame.Active = true
		ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
		ScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Always
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		ScrollingFrame.Size = UDim2.new(1, 0, 0.88141, 0)
		ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5366, 0)
		ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ScrollingFrame.ScrollBarThickness = 7
		ScrollingFrame.BackgroundTransparency = 1
		ScrollingFrame.Parent = MainFrame

		local ScrollingFrameLayout = Instance.new("UIListLayout")
		ScrollingFrameLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		ScrollingFrameLayout.Padding = UDim.new(0, 5)
		ScrollingFrameLayout.Parent = ScrollingFrame

		local CardTemplate = Instance.new("TextButton")
		CardTemplate.Name = "CardTemplate"
		CardTemplate.Text = ""
		CardTemplate.AutoButtonColor = false
		CardTemplate.BorderSizePixel = 0
		CardTemplate.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
		CardTemplate.AnchorPoint = Vector2.new(0.5, 0.5)
		CardTemplate.AutomaticSize = Enum.AutomaticSize.Y
		CardTemplate.Size = UDim2.new(0.967, 0, 0, 0)
		CardTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)

		local CardCorner = Instance.new("UICorner")
		CardCorner.CornerRadius = UDim.new(0.1, 0)
		CardCorner.Parent = CardTemplate

		local CardLayout = Instance.new("UIListLayout")
		CardLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		CardLayout.SortOrder = Enum.SortOrder.Name
		CardLayout.VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly
		CardLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		CardLayout.Parent = CardTemplate

		local CardPadding = Instance.new("UIPadding")
		CardPadding.PaddingTop = UDim.new(0, 6)
		CardPadding.PaddingBottom = UDim.new(0, 6)
		CardPadding.Parent = CardTemplate

		local CardTitle = Instance.new("TextLabel")
		CardTitle.Name = "1"
		CardTitle.Text = ""
		CardTitle.TextWrapped = true
		CardTitle.BorderSizePixel = 0
		CardTitle.TextSize = 14
		CardTitle.TextScaled = true
		CardTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		CardTitle.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		CardTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		CardTitle.BackgroundTransparency = 1
		CardTitle.Size = UDim2.new(0.967, 0, 0, 22)
		CardTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CardTitle.Parent = CardTemplate

		local CardDesc = Instance.new("TextLabel")
		CardDesc.Name = "2"
		CardDesc.Text = ""
		CardDesc.TextWrapped = true
		CardDesc.BorderSizePixel = 0
		CardDesc.TextScaled = false
		CardDesc.TextSize = 12
		CardDesc.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		CardDesc.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		CardDesc.TextColor3 = Color3.fromRGB(201, 201, 201)
		CardDesc.BackgroundTransparency = 1
		CardDesc.AutomaticSize = Enum.AutomaticSize.Y
		CardDesc.Size = UDim2.new(0.967, 0, 0, 0)
		CardDesc.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CardDesc.Parent = CardTemplate

		local CardAuthor = Instance.new("TextLabel")
		CardAuthor.Name = "3"
		CardAuthor.Text = ""
		CardAuthor.TextWrapped = true
		CardAuthor.BorderSizePixel = 0
		CardAuthor.TextSize = 11
		CardAuthor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		CardAuthor.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		CardAuthor.TextColor3 = Color3.fromRGB(95, 95, 95)
		CardAuthor.BackgroundTransparency = 1
		CardAuthor.Size = UDim2.new(0.967, 0, 0, 16)
		CardAuthor.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CardAuthor.Parent = CardTemplate

		local allCards = {}
		local cardIndex = 0
		local LOAD_BATCH = 25
		local loadingMore = false

		local function buildCard(p)
			local card = CardTemplate:Clone()
			card.Name = p.name
			card.Parent = ScrollingFrame

			local titleLabel  = card:FindFirstChild("1")
			local descLabel   = card:FindFirstChild("2")
			local authorLabel = card:FindFirstChild("3")

			if titleLabel  then titleLabel.Text  = p.name:gsub('%.iy$', '') end
			if descLabel   then descLabel.Text   = p.description or '' end
			if authorLabel then
				local a = p.author or ''
				authorLabel.Text = a ~= '' and 'by ' .. a or ''
			end

			card.MouseButton1Click:Connect(function()
				local name = p.name
				local pluginPath = 'plugins/' .. name
				if isfile(pluginPath) then
					showError('Plugin Store', '"' .. name .. '" is already installed.')
					return
				end

				setGuiVisible(storeGui, false)

				local dlSuccess, dlResult = pcall(function()
					return game:HttpGet(p.url, true)
				end)
				if not dlSuccess then
					showError('Plugin Store', 'Failed to download "' .. name .. '".\n' .. tostring(dlResult))
					setGuiVisible(storeGui, true)
					return
				end

				local writeSuccess, writeErr = pcall(function()
					writefile(pluginPath, dlResult)
				end)
				if not writeSuccess then
					showError('Plugin Store', 'Failed to save "' .. name .. '".\n' .. tostring(writeErr))
					setGuiVisible(storeGui, true)
					return
				end

				notify('Plugin Store', 'Downloaded ' .. name)
				addPlugin(pluginPath)
				setGuiVisible(storeGui, true)
			end)

			return card
		end

		local function loadBatch()
			if loadingMore or cardIndex >= #plugins then return end
			loadingMore = true
			local count = 0
			while cardIndex < #plugins and count < LOAD_BATCH do
				cardIndex = cardIndex + 1
				local card = buildCard(plugins[cardIndex])
				card.Visible = true
				allCards[#allCards + 1] = card
				count = count + 1
			end
			loadingMore = false
		end

		local function clearCards()
			for _, card in ipairs(allCards) do
				card:Destroy()
			end
			allCards = {}
			cardIndex = 0
			loadingMore = false
		end

		loadBatch()

		ScrollingFrame:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
			local viewHeight   = ScrollingFrame.AbsoluteSize.Y
			local canvasHeight = ScrollingFrame.AbsoluteCanvasSize.Y
			if canvasHeight > 0 and ScrollingFrame.CanvasPosition.Y + viewHeight * 2 >= canvasHeight then
				loadBatch()
			end
		end)

		SearchBar:GetPropertyChangedSignal('Text'):Connect(function()
			local q = SearchBar.Text:lower()
			clearCards()
			if q == '' then
				loadBatch()
				return
			end
			for _, p in ipairs(plugins) do
				local name    = p.name:gsub('%.iy$', ''):lower()
				local pdesc   = (p.description or ''):lower()
				local pauthor = (p.author or ''):lower()
				if name:find(q, 1, true) or pdesc:find(q, 1, true) or pauthor:find(q, 1, true) then
					local card = buildCard(p)
					card.Visible = true
					allCards[#allCards + 1] = card
				end
			end
		end)
	end)
end)

addcmd('addalias',{},function(args, speaker)
	if #args < 2 then return end
	local cmd = string.lower(args[1])
	local alias = string.lower(args[2])
	for i,v in pairs(cmds) do
		if v.NAME:lower()==cmd or FindInTable(v.ALIAS,cmd) then
			customAlias[alias] = v
			aliases[#aliases + 1] = {CMD = cmd, ALIAS = alias}
			notify('Aliases Modified',"Added "..alias.." as an alias to "..cmd)
			updatesaves()
			refreshaliases()
			break
		end
	end
end)

addcmd('removealias',{},function(args, speaker)
	if #args < 1 then return end
	local alias = string.lower(args[1])
	if customAlias[alias] then
		local cmd = customAlias[alias].NAME
		customAlias[alias] = nil
		for i = #aliases,1,-1 do
			if aliases[i].ALIAS == tostring(alias) then
				table.remove(aliases, i)
			end
		end
		notify('Aliases Modified',"Removed the alias "..alias.." from "..cmd)
		updatesaves()
		refreshaliases()
	end
end)

addcmd('clraliases',{},function(args, speaker)
	customAlias = {}
	aliases = {}
	notify('Aliases Modified','Removed all aliases')
	updatesaves()
	refreshaliases()
end)

addcmd('discord', {'support', 'help'}, function(args, speaker)
	if everyClipboard then
		toClipboard('https://discord.com/invite/78ZuWSq')
		notify('Discord Invite', 'Copied to clipboard!\ndiscord.gg/78ZuWSq')
	else
		notify('Discord Invite', 'discord.gg/78ZuWSq')
	end
	if httprequest then
		httprequest({
			Url = 'http://127.0.0.1:6463/rpc?v=1',
			Method = 'POST',
			Headers = {
				['Content-Type'] = 'application/json',
				Origin = 'https://discord.com'
			},
			Body = HttpService:JSONEncode({
				cmd = 'INVITE_BROWSER',
				nonce = HttpService:GenerateGUID(false),
				args = {code = '78ZuWSq'}
			})
		})
	end
end)

addcmd('keepiy', {}, function(args, speaker)
	if queueteleport then
		KeepInfYield = true
		notify('KeepIY','Infinite Yield will now run after you teleport')
		updatesaves()
	else
		notify('Incompatible Exploit','Your exploit does not support this command (missing queue_on_teleport)')
	end
end)

addcmd('unkeepiy', {}, function(args, speaker)
	if queueteleport then
		KeepInfYield = false
		notify('KeepIY','Infinite Yield will no longer run after you teleport')
		updatesaves()
	else
		notify('Incompatible Exploit','Your exploit does not support this command (missing queue_on_teleport)')
	end
end)

addcmd('togglekeepiy', {}, function(args, speaker)
	if queueteleport then
		KeepInfYield = not KeepInfYield
		updatesaves()
	else
		notify('Incompatible Exploit','Your exploit does not support this command (missing queue_on_teleport)')
	end
end)

local canOpenServerinfo = true
addcmd('serverinfo',{'info','sinfo'},function(args, speaker)
	if not canOpenServerinfo then return end
	canOpenServerinfo = false
	task.spawn(function()
		local FRAME = Instance.new("Frame")
		local shadow = Instance.new("Frame")
		local PopupText = Instance.new("TextLabel")
		local Exit = Instance.new("TextButton")
		local ExitImage = Instance.new("ImageLabel")
		local background = Instance.new("Frame")
		local TextLabel = Instance.new("TextLabel")
		local TextLabel2 = Instance.new("TextLabel")
		local TextLabel3 = Instance.new("TextLabel")
		local Time = Instance.new("TextLabel")
		local appearance = Instance.new("TextLabel")
		local maxplayers = Instance.new("TextLabel")
		local name = Instance.new("TextLabel")
		local placeid = Instance.new("TextLabel")
		local playerid = Instance.new("TextLabel")
		local players = Instance.new("TextLabel")
		local CopyApp = Instance.new("TextButton")
		local CopyPlrID = Instance.new("TextButton")
		local CopyPlcID = Instance.new("TextButton")
		local CopyPlcName = Instance.new("TextButton")

		-- IY_NAME: was randomString()
		FRAME.Name = "IYServerInfo"
		FRAME.Parent = ScaledHolder
		FRAME.Active = true
		FRAME.BackgroundTransparency = 1
		FRAME.Position = UDim2.new(0.5, -130, 0, -500)
		FRAME.Size = UDim2.new(0, 250, 0, 20)
		FRAME.ZIndex = 10
		dragGUI(FRAME)

		shadow.Name = "shadow"
		shadow.Parent = FRAME
		shadow.BackgroundColor3 = currentShade2
		shadow.BorderSizePixel = 0
		shadow.Size = UDim2.new(0, 250, 0, 20)
		shadow.ZIndex = 10
		table.insert(shade2,shadow)

		PopupText.Name = "PopupText"
		PopupText.Parent = shadow
		PopupText.BackgroundTransparency = 1
		PopupText.Size = UDim2.new(1, 0, 0.95, 0)
		PopupText.ZIndex = 10
		PopupText.Font = Enum.Font.SourceSans
		PopupText.TextSize = 14
		PopupText.Text = "Server"
		PopupText.TextColor3 = currentText1
		PopupText.TextWrapped = true
		table.insert(text1,PopupText)

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

		background.Name = "background"
		background.Parent = FRAME
		background.Active = true
		background.BackgroundColor3 = currentShade1
		background.BorderSizePixel = 0
		background.Position = UDim2.new(0, 0, 1, 0)
		background.Size = UDim2.new(0, 250, 0, 250)
		background.ZIndex = 10
		table.insert(shade1,background)

		TextLabel.Name = "Text Label"
		TextLabel.Parent = background
		TextLabel.BackgroundTransparency = 1
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.new(0, 5, 0, 80)
		TextLabel.Size = UDim2.new(0, 100, 0, 20)
		TextLabel.ZIndex = 10
		TextLabel.Font = Enum.Font.SourceSansLight
		TextLabel.TextSize = 20
		TextLabel.Text = "Run Time:"
		TextLabel.TextColor3 = currentText1
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,TextLabel)

		TextLabel2.Name = "Text Label2"
		TextLabel2.Parent = background
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.BorderSizePixel = 0
		TextLabel2.Position = UDim2.new(0, 5, 0, 130)
		TextLabel2.Size = UDim2.new(0, 100, 0, 20)
		TextLabel2.ZIndex = 10
		TextLabel2.Font = Enum.Font.SourceSansLight
		TextLabel2.TextSize = 20
		TextLabel2.Text = "Statistics:"
		TextLabel2.TextColor3 = currentText1
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,TextLabel2)

		TextLabel3.Name = "Text Label3"
		TextLabel3.Parent = background
		TextLabel3.BackgroundTransparency = 1
		TextLabel3.BorderSizePixel = 0
		TextLabel3.Position = UDim2.new(0, 5, 0, 10)
		TextLabel3.Size = UDim2.new(0, 100, 0, 20)
		TextLabel3.ZIndex = 10
		TextLabel3.Font = Enum.Font.SourceSansLight
		TextLabel3.TextSize = 20
		TextLabel3.Text = "Local Player:"
		TextLabel3.TextColor3 = currentText1
		TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,TextLabel3)

		Time.Name = "Time"
		Time.Parent = background
		Time.BackgroundTransparency = 1
		Time.BorderSizePixel = 0
		Time.Position = UDim2.new(0, 5, 0, 105)
		Time.Size = UDim2.new(0, 100, 0, 20)
		Time.ZIndex = 10
		Time.Font = Enum.Font.SourceSans
		Time.FontSize = Enum.FontSize.Size14
		Time.Text = "LOADING"
		Time.TextColor3 = currentText1
		Time.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,Time)

		appearance.Name = "appearance"
		appearance.Parent = background
		appearance.BackgroundTransparency = 1
		appearance.BorderSizePixel = 0
		appearance.Position = UDim2.new(0, 5, 0, 55)
		appearance.Size = UDim2.new(0, 100, 0, 20)
		appearance.ZIndex = 10
		appearance.Font = Enum.Font.SourceSans
		appearance.FontSize = Enum.FontSize.Size14
		appearance.Text = "Appearance: LOADING"
		appearance.TextColor3 = currentText1
		appearance.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,appearance)

		maxplayers.Name = "maxplayers"
		maxplayers.Parent = background
		maxplayers.BackgroundTransparency = 1
		maxplayers.BorderSizePixel = 0
		maxplayers.Position = UDim2.new(0, 5, 0, 175)
		maxplayers.Size = UDim2.new(0, 100, 0, 20)
		maxplayers.ZIndex = 10
		maxplayers.Font = Enum.Font.SourceSans
		maxplayers.FontSize = Enum.FontSize.Size14
		maxplayers.Text = "LOADING"
		maxplayers.TextColor3 = currentText1
		maxplayers.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,maxplayers)

		name.Name = "name"
		name.Parent = background
		name.BackgroundTransparency = 1
		name.BorderSizePixel = 0
		name.Position = UDim2.new(0, 5, 0, 215)
		name.Size = UDim2.new(0, 240, 0, 30)
		name.ZIndex = 10
		name.Font = Enum.Font.SourceSans
		name.FontSize = Enum.FontSize.Size14
		name.Text = "Place Name: LOADING"
		name.TextColor3 = currentText1
		name.TextWrapped = true
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.TextYAlignment = Enum.TextYAlignment.Top
		table.insert(text1,name)

		placeid.Name = "placeid"
		placeid.Parent = background
		placeid.BackgroundTransparency = 1
		placeid.BorderSizePixel = 0
		placeid.Position = UDim2.new(0, 5, 0, 195)
		placeid.Size = UDim2.new(0, 100, 0, 20)
		placeid.ZIndex = 10
		placeid.Font = Enum.Font.SourceSans
		placeid.FontSize = Enum.FontSize.Size14
		placeid.Text = "Place ID: LOADING"
		placeid.TextColor3 = currentText1
		placeid.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,placeid)

		playerid.Name = "playerid"
		playerid.Parent = background
		playerid.BackgroundTransparency = 1
		playerid.BorderSizePixel = 0
		playerid.Position = UDim2.new(0, 5, 0, 35)
		playerid.Size = UDim2.new(0, 100, 0, 20)
		playerid.ZIndex = 10
		playerid.Font = Enum.Font.SourceSans
		playerid.FontSize = Enum.FontSize.Size14
		playerid.Text = "Player ID: LOADING"
		playerid.TextColor3 = currentText1
		playerid.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,playerid)

		players.Name = "players"
		players.Parent = background
		players.BackgroundTransparency = 1
		players.BorderSizePixel = 0
		players.Position = UDim2.new(0, 5, 0, 155)
		players.Size = UDim2.new(0, 100, 0, 20)
		players.ZIndex = 10
		players.Font = Enum.Font.SourceSans
		players.FontSize = Enum.FontSize.Size14
		players.Text = "LOADING"
		players.TextColor3 = currentText1
		players.TextXAlignment = Enum.TextXAlignment.Left
		table.insert(text1,players)

		CopyApp.Name = "CopyApp"
		CopyApp.Parent = background
		CopyApp.BackgroundColor3 = currentShade2
		CopyApp.BorderSizePixel = 0
		CopyApp.Position = UDim2.new(0, 210, 0, 55)
		CopyApp.Size = UDim2.new(0, 35, 0, 20)
		CopyApp.Font = Enum.Font.SourceSans
		CopyApp.TextSize = 14
		CopyApp.Text = "Copy"
		CopyApp.TextColor3 = currentText1
		CopyApp.ZIndex = 10
		table.insert(shade2,CopyApp)
		table.insert(text1,CopyApp)

		CopyPlrID.Name = "CopyPlrID"
		CopyPlrID.Parent = background
		CopyPlrID.BackgroundColor3 = currentShade2
		CopyPlrID.BorderSizePixel = 0
		CopyPlrID.Position = UDim2.new(0, 210, 0, 35)
		CopyPlrID.Size = UDim2.new(0, 35, 0, 20)
		CopyPlrID.Font = Enum.Font.SourceSans
		CopyPlrID.TextSize = 14
		CopyPlrID.Text = "Copy"
		CopyPlrID.TextColor3 = currentText1
		CopyPlrID.ZIndex = 10
		table.insert(shade2,CopyPlrID)
		table.insert(text1,CopyPlrID)

		CopyPlcID.Name = "CopyPlcID"
		CopyPlcID.Parent = background
		CopyPlcID.BackgroundColor3 = currentShade2
		CopyPlcID.BorderSizePixel = 0
		CopyPlcID.Position = UDim2.new(0, 210, 0, 195)
		CopyPlcID.Size = UDim2.new(0, 35, 0, 20)
		CopyPlcID.Font = Enum.Font.SourceSans
		CopyPlcID.TextSize = 14
		CopyPlcID.Text = "Copy"
		CopyPlcID.TextColor3 = currentText1
		CopyPlcID.ZIndex = 10
		table.insert(shade2,CopyPlcID)
		table.insert(text1,CopyPlcID)

		CopyPlcName.Name = "CopyPlcName"
		CopyPlcName.Parent = background
		CopyPlcName.BackgroundColor3 = currentShade2
		CopyPlcName.BorderSizePixel = 0
		CopyPlcName.Position = UDim2.new(0, 210, 0, 215)
		CopyPlcName.Size = UDim2.new(0, 35, 0, 20)
		CopyPlcName.Font = Enum.Font.SourceSans
		CopyPlcName.TextSize = 14
		CopyPlcName.Text = "Copy"
		CopyPlcName.TextColor3 = currentText1
		CopyPlcName.ZIndex = 10
		table.insert(shade2,CopyPlcName)
		table.insert(text1,CopyPlcName)

		local SINFOGUI = background
		TweenService:Create(FRAME, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, -130, 0, 100)}):Play() 
		task.wait(0.5)
		Exit.MouseButton1Click:Connect(function()
			TweenService:Create(FRAME, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, -130, 0, -500)}):Play() 
			task.wait(0.6)
			FRAME:Destroy()
			canOpenServerinfo = true
		end)
		local Asset = MarketplaceService:GetProductInfo(PlaceId)
		SINFOGUI.name.Text = "Place Name: " .. Asset.Name
		SINFOGUI.playerid.Text = "Player ID: " ..speaker.UserId
		SINFOGUI.maxplayers.Text = Players.MaxPlayers.. " Players Max"
		SINFOGUI.placeid.Text = "Place ID: " ..PlaceId

		CopyApp.MouseButton1Click:Connect(function()
			toClipboard(speaker.CharacterAppearanceId)
		end)
		CopyPlrID.MouseButton1Click:Connect(function()
			toClipboard(speaker.UserId)
		end)
		CopyPlcID.MouseButton1Click:Connect(function()
			toClipboard(PlaceId)
		end)
		CopyPlcName.MouseButton1Click:Connect(function()
			toClipboard(Asset.Name)
		end)

		repeat
			players = Players:GetPlayers()
			SINFOGUI.players.Text = #players.. " Player(s)"
			SINFOGUI.appearance.Text = "Appearance: " ..speaker.CharacterAppearanceId
			local seconds = math.floor(workspace.DistributedGameTime)
			local minutes = math.floor(workspace.DistributedGameTime / 60)
			local hours = math.floor(workspace.DistributedGameTime / 60 / 60)
			local seconds = seconds - (minutes * 60)
			local minutes = minutes - (hours * 60)
			if hours < 1 then if minutes < 1 then
					SINFOGUI.Time.Text = seconds .. " Second(s)" else
					SINFOGUI.Time.Text = minutes .. " Minute(s), " .. seconds .. " Second(s)"
				end
			else
				SINFOGUI.Time.Text = hours .. " Hour(s), " .. minutes .. " Minute(s), " .. seconds .. " Second(s)"
			end
			task.wait(1)
		until SINFOGUI.Parent == nil
	end)
end)

addcmd("serverscan", {}, function(args, speaker)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/corecommit/backup/refs/heads/main/serverscanner.lua"))()
end)

addcmd("jobid", {}, function(args, speaker)
	toClipboard("roblox://placeId=" .. PlaceId .. "&gameInstanceId=" .. JobId)
end)

addcmd('notifyjobid',{},function(args, speaker)
	notify('JobId / PlaceId',JobId..' / '..PlaceId)
end)

addcmd('breakloops',{'break'},function(args, speaker)
	lastBreakTime = tick()
end)

addcmd('gametp',{'gameteleport'},function(args, speaker)
	TeleportService:Teleport(args[1])
end)

addcmd("rejoin", {"rj"}, function(args, speaker)
	if #Players:GetPlayers() <= 1 then
		Players.LocalPlayer:Kick("\nRejoining...")
		task.wait()
		TeleportService:Teleport(PlaceId, Players.LocalPlayer)
	else
		TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
	end
end)

addcmd("autorejoin", {"autorj"}, function(args, speaker)
	GuiService.ErrorMessageChanged:Connect(function()
		execCmd("rejoin")
	end)
	notify("Auto Rejoin", "Auto rejoin enabled")
end)

addcmd("serverhop", {"shop"}, function(args, speaker)
	-- thanks to Amity for fixing
	local servers = {}
	local req = game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
	local body = HttpService:JSONDecode(req)

	if body and body.data then
		for i, v in next, body.data do
			if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
				table.insert(servers, 1, v.id)
			end
		end
	end

	if #servers > 0 then
		TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
	else
		return notify("Serverhop", "Couldn't find a server.")
	end
end)

addcmd("exit", {}, function(args, speaker)
	game:Shutdown()
end)

local Noclipping = nil
