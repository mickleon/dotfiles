local mainMod = "SUPER"

local terminal = "kitty"
local fileManager = "nautilus"
local menu = "wofi"

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(
	mainMod .. " + SHIFT + " .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker --autocopy --notify"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("copyq menu"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window -z"))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output -m eDP-1 -z"))
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region -z"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("~/.local/bin/screenshot-ocr"))

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprland-run"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
hl.bind("ALT + F11", hl.dsp.window.fullscreen())

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
	mainMod .. " + SHIFT + right",
	hl.dsp.window.resize({ x = 100, y = 0, relative = true }),
	{ repeating = true },
	{ description = "Increase window width with keyboard" }
)
hl.bind(
	mainMod .. " + SHIFT + left",
	hl.dsp.window.resize({ x = -100, y = 0, relative = true }),
	{ repeating = true },
	{ description = "Reduce window width with keyboard" }
)
hl.bind(
	mainMod .. " + SHIFT + down",
	hl.dsp.window.resize({ x = 0, y = 100, relative = true }),
	{ repeating = true },
	{ description = "Increase window height with keyboard" }
)
hl.bind(
	mainMod .. " + SHIFT + up",
	hl.dsp.window.resize({ x = 0, y = -100, relative = true }),
	{ repeating = true },
	{ description = "Reduce window height with keyboard" }
)

hl.bind(mainMod .. " + ALT + left", hl.dsp.window.swap({ direction = "l" }), { description = "Swap tiled window left" })
hl.bind(
	mainMod .. " + ALT + right",
	hl.dsp.window.swap({ direction = "r" }),
	{ description = "Swap tiled window right" }
)
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.swap({ direction = "u" }), { description = "Swap tiled window up" })
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.swap({ direction = "d" }), { description = "Swap tiled window down" })

-- TODO: rewrite to lua
-- binde = ALT,Tab,cyclenext                 # Cycle between windows
-- binde = ALT,Tab,bringactivetotop

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	-- hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	hl.dsp.exec_cmd("ashell msg volume-up"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	-- hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	hl.dsp.exec_cmd("ashell msg volume-down"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	-- hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	hl.dsp.exec_cmd("ashell msg volume-toggle-mute"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	-- hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	hl.dsp.exec_cmd("ashell msg microphone-toggle-mute"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessUp",
	-- hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
	hl.dsp.exec_cmd("ashell msg brightness-up"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	-- hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
	hl.dsp.exec_cmd("ashell msg brightness-down"),
	{ locked = true, repeating = true }
)

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
