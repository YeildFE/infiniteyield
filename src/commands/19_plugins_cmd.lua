addcmd('addplugin',{'plugin'},function(args, speaker)
	addPlugin(getstring(1, args))
end)

addcmd('removeplugin',{'deleteplugin'},function(args, speaker)
	deletePlugin(getstring(1, args))
end)

addcmd('reloadplugin',{},function(args, speaker)
	local pluginName = getstring(1, args)
	deletePlugin(pluginName)
	task.wait(1)
	addPlugin(pluginName)
end)

addcmd("addallplugins", {"loadallplugins"}, function(args, speaker)
	if not listfiles or not isfolder then
		notify("Incompatible Exploit", "Your exploit does not support this command (missing listfiles/isfolder)")
		return
	end

	for _, filePath in ipairs(listfiles("")) do
		local fileName = filePath:match("([^/\\]+%.iy)$")

		if fileName and
			fileName:lower() ~= "iy_fe.iy" and
			not isfolder(fileName) and
			not table.find(PluginsTable, fileName)
		then
			addPlugin(fileName)
		end
	end
end)

addcmd('removecmd',{'deletecmd'},function(args, speaker)
	removecmd(args[1])
end)

