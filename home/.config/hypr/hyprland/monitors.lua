-----------------------
-----  MONITORS  ------
-----------------------
-- Режимы работы с внешним HDMI-монитором (аналог Win+P):
--   internal  — только экран ноутбука, HDMI выключен
--   extend    — расширение: HDMI справа от ноутбука
--   extend_l  — расширение: HDMI слева
--   extend_up — расширение: HDMI сверху
--   duplicate — дублирование: HDMI показывает экран ноутбука (источник eDP-1)
--   mirror    — зеркалирование наоборот: ноутбук показывает HDMI (источник HDMI,
--               внешний монитор работает в родном разрешении — удобно для проектора/ТВ)
--   external  — только внешний монитор, экран ноутбука выключен
--
-- Переключение: SUPER+SHIFT+F7 - меню (wofi),
-- или из терминала: hyprctl eval 'display.set("duplicate")'

local M = {}

local INTERNAL = "eDP-1"
local HDMI_FALLBACK = "HDMI-A-1"

local INTERNAL_MODE = "preferred"
local INTERNAL_SCALE = 1
local EXTERNAL_MODE = "preferred" -- например "2560x1440@144" или "highrr"
local EXTERNAL_SCALE = 1 -- для 4K обычно 1.5 или 2

-- Режим, который включается при подключении HDMI
local DEFAULT_MODE = "extend"

M.order = { "extend", "duplicate", "mirror", "external", "internal" }

M.labels = {
	internal = "Только ноутбук",
	extend = "Расширение →",
	extend_l = "Расширение ←",
	extend_up = "Расширение ↑",
	duplicate = "Дублирование (ноутбук → HDMI)",
	mirror = "Зеркалирование (HDMI → ноутбук)",
	external = "Только HDMI",
}

M.current = DEFAULT_MODE

-- В 0.56.2 hl.get_monitors() возвращает только активные НЕзеркальные
-- мониторы. Отключённый правилом или зеркальный HDMI всё ещё подключён.
-- Список разъёмов читаем один раз, физический статус — при переключении.
local hdmi_paths = {}
local paths = io.popen("printf '%s\\n' /sys/class/drm/card*-HDMI-A-*/status", "r")
if paths then
	for path in paths:lines() do
		local name = path:match("/card%d+%-(HDMI%-A%-%d+)/status$")
		if name then
			table.insert(hdmi_paths, { path = path, name = name })
		end
	end
	paths:close()
end

local function hdmi_name()
	for _, connector in ipairs(hdmi_paths) do
		local file = io.open(connector.path, "r")
		if file then
			local status = file:read("*l")
			file:close()
			if status == "connected" then
				return connector.name
			end
		end
	end
end

local connected_hdmi = hdmi_name()
local selected_hdmi = connected_hdmi or HDMI_FALLBACK
local transition = 0

local function internal_on()
	-- hl.monitor() изменяет существующее правило, а не заменяет его.
	hl.monitor({
		output = INTERNAL,
		mode = INTERNAL_MODE,
		position = "0x0",
		scale = INTERNAL_SCALE,
		disabled = false,
		mirror = "",
	})
end

local function external(position, extra)
	local spec = {
		output = selected_hdmi,
		mode = EXTERNAL_MODE,
		position = position,
		scale = EXTERNAL_SCALE,
		disabled = false,
		mirror = "",
	}
	for k, v in pairs(extra or {}) do
		spec[k] = v
	end
	hl.monitor(spec)
end

M.states = {
	internal = function()
		internal_on()
		external("auto-right", { disabled = true })
	end,

	extend = function()
		internal_on()
		external("auto-right")
	end,

	extend_l = function()
		internal_on()
		external("auto-left")
	end,

	extend_up = function()
		internal_on()
		external("auto-up")
	end,

	duplicate = function()
		internal_on()
		external("auto", { mirror = INTERNAL })
	end,

	mirror = function()
		external("0x0")
		hl.monitor({
			output = INTERNAL,
			mode = INTERNAL_MODE,
			position = "auto",
			scale = INTERNAL_SCALE,
			disabled = false,
			mirror = selected_hdmi,
		})
	end,

	external = function()
		external("0x0")
		hl.monitor({ output = INTERNAL, disabled = true, mirror = "" })
	end,
}

local function notify(text)
	hl.notification.create({ text = "Дисплей: " .. text, timeout = 2000 })
end

function M.set(name, quiet)
	local apply = M.states[name]
	if not apply then
		notify("неизвестный режим «" .. tostring(name) .. "»")
		return
	end
	local output = hdmi_name()
	if name ~= "internal" and not output then
		notify("HDMI не подключён")
		return
	end
	selected_hdmi = output or selected_hdmi
	transition = transition + 1
	local ticket = transition
	M.pending = name

	local function finish()
		apply()
		M.current = name
		M.pending = nil
		if not quiet then
			notify(M.labels[name])
		end
	end

	if not output then
		internal_on()
		-- Не запрещаем включение ещё отсутствующего HDMI: при подключении
		-- disabled-выхода Hyprland не отправляет monitor.added.
		external("auto-right")
		M.current = "internal"
		M.pending = nil
		if not quiet then
			notify(M.labels.internal)
		end
		return
	end
	if name == "internal" then
		-- Аварийный возврат на ноутбук не должен ждать исправности HDMI.
		finish()
		return
	end

	-- Правила применяются отложенно. Сначала включаем оба выхода и снимаем
	-- зеркала; иначе при duplicate <-> mirror можно получить mirror-of-mirror.
	internal_on()
	external("auto-right")
	local attempts = 0
	local function wait_for_sources()
		if ticket ~= transition then
			return -- более новый запрос отменил этот переход
		end
		if hdmi_name() ~= output then
			M.set("internal", true)
			return
		end
		local ready = {}
		for _, mon in ipairs(hl.get_monitors()) do
			if not mon.is_mirror then
				ready[mon.name] = true
			end
		end
		if ready[INTERNAL] and ready[output] then
			finish()
			return
		end
		attempts = attempts + 1
		if attempts >= 40 then
			M.pending = nil
			notify("не удалось включить оба экрана; проверьте hyprctl configerrors и rollinglog")
			return
		end
		hl.timer(wait_for_sources, { timeout = 50, type = "oneshot" })
	end
	hl.timer(wait_for_sources, { timeout = 50, type = "oneshot" })
end

function M.cycle()
	local idx = 0
	for i, name in ipairs(M.order) do
		if name == (M.pending or M.current) then
			idx = i
		end
	end
	M.set(M.order[idx % #M.order + 1])
end

-- Глобально, чтобы можно было вызывать через `hyprctl eval`
_G.display = M

-- added/removed возникают и при программном включении/выключении.
-- В 0.56.2 аргумент — userdata HL.Monitor, его имя доступно через mon.name.
local function connection_changed(mon)
	local name = type(mon) == "string" and mon or mon.name
	if not name or not name:match("^HDMI") then
		return
	end
	hl.timer(function()
		local output = hdmi_name()
		if output == connected_hdmi then
			return
		end
		connected_hdmi = output
		if output then
			M.set(DEFAULT_MODE)
		else
			-- Отменяем незавершённый переход и возвращаем экран ноутбука.
			transition = transition + 1
			M.pending = nil
			M.current = "internal"
			internal_on()
			-- Не оставляем disabled=true для следующего подключения HDMI:
			-- иначе монитор не включится и событие added не придёт.
			external("auto-right")
		end
	end, { timeout = 100, type = "oneshot" })
end

hl.on("monitor.added", connection_changed)
hl.on("monitor.removed", connection_changed)

-- Меню выбора режима через wofi
local menu_cmd = [[
choice=$(printf '%s\n' extend extend_l extend_up duplicate mirror external internal | wofi --dmenu --prompt 'Дисплей') \
  && hyprctl eval "display.set('$choice')"
]]

hl.bind("SUPER + SHIFT + F7", hl.dsp.exec_cmd(menu_cmd), { description = "Display mode menu" })

-- Стартовое состояние
if connected_hdmi then
	M.set(DEFAULT_MODE, true)
else
	M.current = "internal"
	internal_on()
end

return M
