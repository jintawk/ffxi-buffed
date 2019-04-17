config = require('config')
texts = require('texts')

defaults = {}
defaults.pos = {}
defaults.pos.x = 300
defaults.pos.y = 475
defaults.text = {}
defaults.text.font = 'Arial'
defaults.text.size = 8
defaults.flags = {}
defaults.flags.bold = true
defaults.flags.draggable = true
defaults.bg = {}
defaults.bg.alpha = 128

settings = config.load(defaults)
gui = texts.new(settings)

listGUI = texts.new(settings)
settings = config.load()

function clear_gui()
	listGUI:text("")
	listGUI:visible(false)
end

function UpdateGUI(currentBuffsToDisplay)
	local guiStr = "[" .. windower.ffxi.get_player().name .. "]"

	if currentBuffsToDisplay.count > 0 then
		for i = currentBuffsToDisplay.first, currentBuffsToDisplay.last do
			local fontColour = ""

			if currentBuffsToDisplay.items[i].active then
				fontColour = "\\cs(0, 255, 0)"
			else
				fontColour = "\\cs(255, 0, 0)"
			end

			guiStr = guiStr .. "\n" .. fontColour .. currentBuffsToDisplay.items[i].name 
		end
	end

	gui:text(guiStr)
	gui:visible(true)
end