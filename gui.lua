require('strings')
config = require('config')
local texts = require('texts')

local defaults = {
	pos = { x = 300, y = 475 },
	text = { font = 'Arial', size = 8 },
	flags = { bold = false, draggable = true },
	bg = { alpha = 128 }
}

local settings = config.load(defaults)
local gui = texts.new(settings)

function UpdateGUI(currentBuffsToDisplay)
	if not currentBuffsToDisplay then
		gui:text("")
		gui:visible(false)
		return
	end

	local guiStr = "[" .. windower.ffxi.get_player().name .. "]"

	if currentBuffsToDisplay.count > 0 then
		for i = currentBuffsToDisplay.first, currentBuffsToDisplay.last do
			local fontColour = ""

			if currentBuffsToDisplay.items[i].debuff then
				fontColour = "\\cs(255, 0, 255)"
			elseif currentBuffsToDisplay.items[i].tracked == false then
				fontColour = "\\cs(255, 255, 255)"
			elseif currentBuffsToDisplay.items[i].active then
				fontColour = "\\cs(0, 255, 0)"
			else
				fontColour = "\\cs(255, 75, 0)"
			end

			local buffNameTrimmed = string.sub(currentBuffsToDisplay.items[i].name, 1, 20)

			guiStr = guiStr .. "\n" .. fontColour .. buffNameTrimmed
		end
	end

	gui:text(guiStr)
	gui:visible(true)
end