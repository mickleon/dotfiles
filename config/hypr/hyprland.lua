require("hyprland.env")
require("hyprland.look")
require("hyprland.input")
require("hyprland.keybindings")
require("hyprland.windows")

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("PATH=$PATH:/usr/sbin ashell")
	hl.exec_cmd("copyq --start-server")
end)

-----------------------
----- PERMISSIONS -----
-----------------------

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
	},
})
