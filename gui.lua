require('strings')
config = require('config')
local texts = require('texts')

local defaults = {}
defaults.pos = {}
defaults.pos.x = 300
defaults.pos.y = 475
defaults.text = {}
defaults.text.font = 'Arial'
defaults.text.size = 8
defaults.flags = {}
defaults.flags.bold = false
defaults.flags.draggable = true
defaults.bg = {}
defaults.bg.alpha = 128

local settings = config.load(defaults)
local gui = texts.new(settings)

function UpdateGUI(currentBuffsToDisplay)
	if currentBuffsToDisplay == nil then
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

			local buffNameTrimmed = currentBuffsToDisplay.items[i].name 

			if string.len(buffNameTrimmed) > 20 then
				buffNameTrimmed = string.slice(buffNameTrimmed, 1, 20) .. "..."
			end

			guiStr = guiStr .. "\n" .. fontColour .. buffNameTrimmed
		end
	end

	gui:text(guiStr)
	gui:visible(true)
end