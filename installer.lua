--========================================================================--
--  Infinite Yield FE - module installer
--
--  Downloads every module to local disk (infiniteyield/modules/) so the
--  loader can run fully offline afterwards. Requires writefile support.
--========================================================================--

local BASE_LOCAL  = "infiniteyield/modules/"
local BASE_REMOTE = "https://raw.githubusercontent.com/YeildFE/infiniteyield/master/src/"
local BASE_ROOT   = "https://raw.githubusercontent.com/YeildFE/infiniteyield/master/"

if not (writefile and isfolder and makefolder) then
        error("[IY installer] your exploit does not support writefile - "
                .. "the loader will fetch modules from GitHub instead.", 0)
end

local MODULES = {
	"core/01_environment.lua",
	"core/02_gui_construction.lua",
	"core/03_ui_framework.lua",
	"core/04_notifications_ui.lua",
	"core/05_command_bar.lua",
	"core/06_exec_engine.lua",
	"core/07_features.lua",
	"core/08_plugins.lua",
	"commands/01_client_server.lua",
	"commands/02_flying.lua",
	"commands/03_waypoints.lua",
	"commands/04_gui_client.lua",
	"commands/05_esp_camera.lua",
	"commands/06_workspace.lua",
	"commands/07_player_info.lua",
	"commands/08_teleport.lua",
	"commands/09_character.lua",
	"commands/10_animation.lua",
	"commands/11_tp_movement.lua",
	"commands/12_tools_windows.lua",
	"commands/13_chat_fun.lua",
	"commands/14_parts_interaction.lua",
	"commands/15_lighting_avatar.lua",
	"commands/16_logs_fling.lua",
	"commands/17_visuals_misc.lua",
	"commands/18_server_watch.lua",
	"commands/19_plugins_cmd.lua",
	"core/09_boot.lua",
}

makefolder("infiniteyield")
makefolder("infiniteyield/modules")
makefolder("infiniteyield/modules/core")
makefolder("infiniteyield/modules/commands")

for i, name in ipairs(MODULES) do
        local src = game:HttpGet(BASE_REMOTE .. name, true)
        assert(type(src) == "string" and #src > 0, "download failed: " .. name)
        writefile(BASE_LOCAL .. name, src)
        print(("[IY installer] %02d/%d %s (%d bytes)"):format(i, #MODULES, name, #src))
end

print("[IY installer] all modules installed to " .. BASE_LOCAL)

-- install + run the loader itself
local loaderSrc = game:HttpGet(BASE_ROOT .. "loader.lua", true)
writefile("infiniteyield/loader.lua", loaderSrc)
print("[IY installer] loader installed, executing ...")
loadstring(readfile("infiniteyield/loader.lua"))()
