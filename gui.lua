require('strings')
config = require('config')
-- shared Slate UI lib when present; the bundled copy makes a standalone clone work
local slate_ok
slate_ok, slate = pcall(require, 'slate')
if not slate_ok then
	slate = require('slate_bundled')
end

local defaults = {
	pos = { x = 300, y = 475 },
	ui = {
		scale = 1,
		minimized = false,
	},
}

-- global: buffed.lua reads settings.buffs from this same table
settings = config.load(defaults)

local UI_W  = 170
local ROW_H = 17

local ui = {
	built = false,
	panel = nil,
	rows = {},        -- pooled name labels
}

local function build_ui()
	if ui.built then
		return
	end
	ui.built = true
	slate.set_scale(tonumber(settings.ui.scale) or 1)

	ui.panel = slate.Panel({
		x = settings.pos.x,
		y = settings.pos.y,
		w = UI_W,
		content_h = 40,
		title = 'BUFFED',
		minimized = settings.ui.minimized,
		on_move = function(x, y)
			settings.pos.x = x
			settings.pos.y = y
			config.save(settings)
		end,
		on_minimize = function(min)
			settings.ui.minimized = min
			config.save(settings)
		end,
	})
end

local function ensure_rows(n)
	for i = #ui.rows + 1, n do
		local row = slate.Label({size = 10, color = slate.color.text})
		ui.panel:add(row, 10, 4 + (i - 1) * ROW_H)
		ui.rows[i] = row
	end
end

function UpdateGUI(currentBuffsToDisplay)
	if not currentBuffsToDisplay or currentBuffsToDisplay.count == 0 then
		if ui.built then
			ui.panel:hide()
		end
		return
	end

	build_ui()

	local n = currentBuffsToDisplay.count
	ensure_rows(n)
	ui.panel:content_height(4 + n * ROW_H + 4)

	local slot = 0
	for i = currentBuffsToDisplay.first, currentBuffsToDisplay.last do
		local item = currentBuffsToDisplay.items[i]
		if item then
			slot = slot + 1
			local row = ui.rows[slot]
			ui.panel:place(row, 10, 4 + (slot - 1) * ROW_H)
			row:text(string.sub(item.name, 1, 20))
			if item.debuff then
				row:color(slate.color.bad)
			elseif item.tracked == false then
				row:color(slate.color.text)
			elseif item.active then
				row:color(slate.color.ok)
			else
				row:color(slate.color.warn)
			end
		end
	end

	if not ui.panel:visible() then
		ui.panel:show()
	end

	if not ui.panel:is_minimized() then
		for i = 1, #ui.rows do
			ui.rows[i]:visible(i <= slot)
		end
	end
end

-- Slate protocol + user commands; buffed had no command handler before
windower.register_event('addon command', function(...)
	if slate.handle_command(...) then
		return
	end
	local args = {...}
	local cmd = (args[1] or ''):lower()
	if cmd == 'scale' then
		local n = tonumber(args[2])
		if n and n >= 0.5 and n <= 3 then
			settings.ui.scale = n
			config.save(settings)
			slate.set_scale(n)
			windower.add_to_chat(207, 'buffed: HUD scale set to ' .. n)
		else
			windower.add_to_chat(207, 'buffed: usage //buffed scale <0.5-3>')
		end
	else
		windower.add_to_chat(207, 'buffed: commands: scale <n>. Buff lists live in data/settings.xml.')
	end
end)
