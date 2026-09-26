# Infinite Yield FE v7.0 — Modular Edition

The single-file **Infinite Yield** admin script (originally one 13,844-line Lua file,
~507 KB) split into **28 focused modules** that behave like the original. The split
itself changed nothing; every change made since is additive and listed below.

> **Split fidelity:** at split time, concatenated in load order the modules reproduced
> the original source *byte-for-byte* (SHA-256 `4dfe873e…`) — the split only cuts at
> top-level statement boundaries, nothing was added, removed, reformatted or reordered.
> Everything below is an additive change made after the split:
>
> 1. **GUI command list synced with the registered commands** — 12 commands that were
>    registered but never listed were added to the `CMDs` table, and the dead
>    `animsunanchored / freezeua` entry was corrected to `freezeunanchored / freezeua`
>    (+13 / −1 lines). The list now shows every registered command, and later v7.0.0
>    rows brought it to 0 missing / 0 dead against the registrations.
> 2. **Command search index** — the suggestion list matches registered names, aliases
>    and tooltip descriptions, not just the text printed on the row, so typing `nofly`,
>    `sinfo`, `setwp`… finds the command those aliases belong to; the prefix typed in
>    the command bar (`;esp`) is accepted too, and the scroll area is refreshed after
>    layout (+111 / −1 lines).
> 3. **v7.0.0 commands** — twelve new commands (`search`, `bind`, `unbind`, `binds`,
>    `setprefix`, `nonotify`, `exportwaypoints`, `importwaypoints`, `stats`,
>    `listaliases`, `aimlock`, `unaimlock`), new aliases (`bring`, `hide`, `unhide`,
>    `gotomodeldelay`) and the notification mute flag in
>    `core/04_notifications_ui.lua`; `notify` with no text now undoes `nonotify`.
>
> Current tree: **14,286 lines** across the same 28 modules, **442 commands**
> (`core/05_command_bar.lua` is now 837 lines; 11 of the 28 modules carry these
> documented changes, the other 17 remain byte-identical to their original slices).

---

## Why this is safe

The original script defines almost everything as **globals**, and its top-level
`local` variables are declared immediately before the code that uses them. The
split preserves the original file order everywhere, so:

- every `local` is still declared **before** every block that references it
  (verified programmatically against all **206** declaration→usage edges),
- no module starts or ends in the middle of a Lua block (verified by a
  Lua-tokenizer depth check on all 28 files),
- the loader joins the modules **in order into one chunk**, which reproduces
  Lua's original chunk-level scoping semantics perfectly.

Commands were **not** reordered: each command file is a contiguous slice of the
original command block, cut where the source itself changes feature clusters.
Within each file, commands keep their original relative order.

---

## File map (load order)

| Module | Lines | Contains | Commands |
|---|---:|---|---|
| `core/01_environment.lua` | 151 | IY guard, executor shims (missing/cloneref/writefile…), Services, asset bootstrap | — |
| `core/02_gui_construction.lua` | 1,821 | main GUI tree: Holder, Cmdbar, Settings, Keybinds/Aliases/Plugins windows, intro logo | — |
| `core/03_ui_framework.lua` | 1,221 | create() widget factory, core utilities (getRoot, toClipboard…), eventEditor, reference viewer, saves | — |
| `core/04_notifications_ui.lua` | 1,052 | notify() (+ the `nonotify` mute guard), chat/join log labels, theme color picker, settings & window button wiring, part picker | — |
| `core/05_command_bar.lua` | 837 | cmds table, command list UI, IndexContents/autoComplete, CMDs display entries, search index | — |
| `core/06_exec_engine.lua` | 779 | execCmd/addcmd/findCmd/getPlayer/argument parsing, do_exec, command-bar input wiring | — |
| `core/07_features.lua` | 591 | ESP/CHMS/Locate, keybind editor, waypoint & alias refresh, input handlers, click-TP | — |
| `core/08_plugins.lua` | 202 | plugin load/save system, plugin editor wiring, OnTeleport guard | — |
| `commands/01_client_server.lua` | 961 | plugin store, aliases (`addalias`/`listaliases`), discord/keepiy, server info & hop, rejoin/exit | 19 commands (`pluginstore`, `addalias`, `removealias`, `clraliases` …) |
| `commands/02_flying.lua` | 486 | noclip, fly/vfly/cframefly, float, swim | 20 commands (`noclip`, `clip`, `togglenoclip`, `fly` …) |
| `commands/03_waypoints.lua` | 292 | waypoint creation/management & JSON export/import, tween & walk-to-waypoint | 14 commands (`setwaypoint`, `waypointpos`, `waypoints`, `showwaypoints` …) |
| `commands/04_gui_client.lua` | 449 | coregui toggles, gui hide/delete, screenshots, antikick/antiteleport, volume/fps, keybinds/prefix/notify mute | 32 commands (`enable`, `disable`, `showguis`, `unshowguis` …) |
| `commands/05_esp_camera.lua` | 642 | esp/chams/locate, spectate, freecam, camera/fov/zoom controls | 33 commands (`esp`, `espteam`, `noesp`, `esptransparency` …) |
| `commands/06_workspace.lua` | 167 | delete/btools, invis parts, antiafk, prompts, wallwalk | 21 commands (`unlockws`, `lockws`, `delete`, `deleteclass` …) |
| `commands/07_player_info.lua` | 172 | account/place info, copy id, render toggles, perf stats | 19 commands (`age`, `chatage`, `joindate`, `chatjoindate` …) |
| `commands/08_teleport.lua` | 361 | goto/vehicle tp, bring/loopbring, walkto/pathfind, orbit, freeze/anchor | 20 commands (`goto`, `tweengoto`, `vehiclegoto`, `pulsetp` …) |
| `commands/09_character.lua` | 570 | reset/respawn/refresh, god, invisibility, jpower/gravity/sit/jump family | 41 commands (`loopoof`, `unloopoof`, `muteboombox`, `unmuteboombox` …) |
| `commands/10_animation.lua` | 232 | billboard-gui removal, spasm, animation/emote engine | 19 commands (`team`, `nobgui`, `loopnobgui`, `unloopnobgui` …) |
| `commands/11_tp_movement.lua` | 235 | tppos/offset, click/mouse teleport, walktopos, speed & jumppower loops | 19 commands (`tpposition`, `tweentpposition`, `offset`, `tweenoffset` …) |
| `commands/12_tools_windows.lua` | 97 | tool inventory, console/explorer/remotespy/audiologger windows | 10 commands (`tools`, `notools`, `deleteselectedtool`, `console` …) |
| `commands/13_chat_fun.lua` | 310 | loopgoto/headsit, chat/spam/pm, chat windows, blockhead/creeper/bang/carpet/friend | 25 commands (`loopgoto`, `unloopgoto`, `headsit`, `chat` …) |
| `commands/14_parts_interaction.lua` | 247 | goto part/model, click detectors, proximity prompts, grab/removespecifictool | 21 commands (`bringpart`, `bringpartclass`, `gotopart`, `tweengotopart` …) |
| `commands/15_lighting_avatar.lua` | 569 | light, copytools, naked/spawn/hatspin, char surgery, dupetools, fullbright, stun/states/reach | 47 commands (`light`, `unlight`, `copytools`, `naked` …) |
| `commands/16_logs_fling.lua` | 427 | chat/join logs, fling family, kill helpers (attach/kill/bring/teleport) | 20 commands (`logs`, `chatlogs`, `joinlogs`, `chatlogswebhook` …) |
| `commands/17_visuals_misc.lua` | 334 | spin, xray, walltp, autoclick, hovername, hitbox, stareat, aimlock | 20 commands (`spin`, `unspin`, `xray`, `unxray` …) |
| `commands/18_server_watch.lua` | 626 | role/staff watch, terrain/destroyheight/antivoid, guiscale, voice, freezeua, autokeypress | 33 commands (`rolewatch`, `rolewatchstop`, `rolewatchleave`, `staffwatch` …) |
| `commands/19_plugins_cmd.lua` | 38 | plugin management commands, removecmd | 5 commands (`addplugin`, `removeplugin`, `reloadplugin`, `addallplugins` …) |
| `core/09_boot.lua` | 417 | boot sequence, late commands (debug/loop/kill/search), events, announcement & intro | 4 commands (`debug`, `loop`, `kill`, `search`) |

**Total:** 14,286 lines across 28 modules, 442 commands.

`tools/manifest.json` records the line range of every module in the concatenation,
the command names per file, and the divergence from the original source —
it is the machine-readable version of the table above.

---

## How to run

### Option A — remote (no local files)
Push this `src/` folder (plus `loader.lua`) to your GitHub repo, then execute:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YeildFE/infiniteyield/master/loader.lua"))()
```

The loader fetches each module from `BASE_REMOTE`
(`https://raw.githubusercontent.com/YeildFE/infiniteyield/master/src/` by default —
edit the constant at the top of `loader.lua` if your repo differs).

### Option B — local (offline after first install)
1. Execute `installer.lua` once (needs `writefile` support). It downloads every
   module to `infiniteyield/modules/`, installs `loader.lua`, and starts IY.
2. From then on just run:

```lua
loadstring(readfile("infiniteyield/loader.lua"))()
```

The loader always tries **local first**, then falls back to **GitHub** — so you
can edit any module on disk and your changes take effect immediately.

### Debug mode
Set `_G.IY_DEBUG = true` before executing the loader to (a) allow re-running IY
in the same session and (b) print each module as it loads.

---

## How to edit safely

- **Add a command** → put `addcmd('name', {'alias'}, function(args, speaker) … end)`
  at the top level of the command file that matches its category (any of them
  works; category files are organizational, not scope boundaries).
- **Add a helper function** → define it near the commands that use it, in the
  same file, *above* them.
- **Top-level `local` variables** are visible from their declaration point to
  the end of the *joined* chunk. Keep them declared above their users, exactly
  like the original script does.
- After heavy edits, rebuild a single file with `tools/rebuild.py --out bundle.lua`
  to distribute without the loader.

`tools/rebuild.py` can also re-verify the split against the original monolith
(adjust the `ORIGINAL` path constant if needed; the 11 modules that changed since
the split show as differences — the other 17 stay byte-identical).

---

## Package contents

```
InfiniteYield-Modular/
├── loader.lua        ← the only file users execute (hybrid local/remote loader)
├── installer.lua     ← one-time local installer (writefile-capable executors)
├── README.md
├── src/
│   ├── core/         ← environment, GUI, framework, engine, features, plugins, boot
│   └── commands/     ← 19 command slices, ordered & grouped by feature
└── tools/
    ├── manifest.json ← module map: load order, line ranges, commands, divergence notes
    └── rebuild.py    ← split verifier / single-file bundler
```
