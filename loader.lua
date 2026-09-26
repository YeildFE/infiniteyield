--========================================================================--
--  Infinite Yield FE v7.0 - modular loader
--
--  This is the ONLY file you execute. It loads every module listed below,
--  joins them in order and runs them as a single chunk, so all top-level
--  locals keep exactly the same visibility as in the original monolith.
--
--  Module sources (first hit wins):
--    1. local disk : infiniteyield/modules/<path>   (via readfile)
--    2. GitHub raw : BASE_REMOTE .. <path>          (via game:HttpGet)
--
--  Use installer.lua to download the modules to local disk once.
--========================================================================--

local BASE_LOCAL  = "infiniteyield/modules/"
local BASE_REMOTE = "https://raw.githubusercontent.com/YeildFE/infiniteyield/master/src/"

if IY_LOADED and not _G.IY_DEBUG then
        return
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

local function fetch(name)
        -- 1) local disk
        if type(readfile) == "function" then
                local ok, res = pcall(readfile, BASE_LOCAL .. name)
                if ok and type(res) == "string" and #res > 0 then
                        return res, "local"
                end
        end
        -- 2) github raw
        local ok, res = pcall(function()
                return game:HttpGet(BASE_REMOTE .. name, true)
        end)
        if ok and type(res) == "string" and #res > 0 then
                return res, "remote"
        end
        return nil, nil
end

-- Modules are fetched CONCURRENTLY: the sequential loop paid for 28 separate
-- network round trips back to back, which is what made loading slow. Each
-- fetch now runs on its own thread so the requests overlap - total load time
-- is roughly one round trip instead of 28. Order is preserved by storing into
-- chunks[i], so table.concat below still produces the original module order.
local chunks = {}
local failures = {}
local pending = #MODULES

local function loadOne(i, name)
        local ok, src, from = pcall(fetch, name)
        if ok and src then
                if _G.IY_DEBUG then
                        print(("[IY loader] %02d/%d %s (%s)"):format(i, #MODULES, name, from))
                end
                chunks[i] = src
        else
                failures[i] = name
        end
        pending = pending - 1
end

if type(task) == "table" and type(task.spawn) == "function" then
        local startTime = tick()
        for i, name in ipairs(MODULES) do
                task.spawn(loadOne, i, name)
        end
        while pending > 0 do task.wait() end
        if _G.IY_DEBUG then
                print(("[IY loader] fetched %d modules in %.2fs"):format(#MODULES, tick() - startTime))
        end
else
        -- no task library: fall back to the old one-by-one behaviour
        for i, name in ipairs(MODULES) do
                loadOne(i, name)
        end
end

-- anything still missing after the join is reported as failed
for i, name in ipairs(MODULES) do
        if chunks[i] == nil then failures[i] = name end
end

if next(failures) then
        local firstIdx, firstName = math.huge, nil
        for i, name in pairs(failures) do
                if i < firstIdx then firstIdx, firstName = i, name end
        end
        error("[IY loader] failed to load module '" .. firstName
                .. "' (not found in '" .. BASE_LOCAL .. "' and fetch failed)"
                .. "\nRun installer.lua once to download all modules locally.", 0)
end

local joined = table.concat(chunks, "\n")
local fn, err = loadstring(joined, "InfiniteYield")
if not fn then
        error("[IY loader] compile failed: " .. tostring(err), 0)
end
fn()
