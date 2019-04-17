-- [ Windower settings ]
_addon.name = 'buffed'
_addon.version = '1.31'
_addon.author = 'iintawk/iynvoco (Asura)'
_addon.command = 'buffed'

-- [ Lib imports ]
require('actions')
require('tables')
require('sets')

-- [ Lib variable imports ]
res = require('resources')

-- [ Local Lib/Class imports ]
require "Buff"
require "List"

-- [ Local Lib/Helper imports ]
require "gui"

-- [ Init settings ]
defaults = {}
defaults.buffs = S{	"Haste", "Refresh" }

settings = config.load(defaults)

-- [ Functions ]
function GetBuffIdsFromResources(buffName)
	local buffIds = {}
	local numBuffs = 0

	for key, val in pairs(res.buffs) do
		if val.en == buffName then
			numBuffs = numBuffs + 1
			buffIds[numBuffs] = key			
		end
	end

	return buffIds
end

function Update()
	if windower == nil or windower.ffxi == nil or windower.ffxi.get_player() == nil or windower.ffxi.get_player().buffs == nil then
		windower.add_to_chat(207, "! rdm-help can't start - something is nil")
		return
	end

	local buffsToDisplay = List.new()
	local currentPlayerBuffs = windower.ffxi.get_player().buffs

	for key,val in pairs(settings.buffs) do
		local resourceBuffIds = GetBuffIdsFromResources(key)		
		
		if next(resourceBuffIds) == nil then
			windower.add_to_chat(207, "! rdm-help: Unknown buff in settings -> " .. tostring(key))					
		else		
			local trackedBuff = Buff.new({ key, false })

			for i = 1, #currentPlayerBuffs do
				for j = 1, #resourceBuffIds do
					if currentPlayerBuffs[i] == resourceBuffIds[j] then
						trackedBuff.active = true					
						break							
					end
				end

				if trackedBuff.active then
					break
				end
			end

			buffsToDisplay:push_back(trackedBuff)
		end
	end

	UpdateGUI(buffsToDisplay)
end

-- [ Events ]
windower.register_event('load', function()
	Update()
end)

windower.register_event('zone change', function(new_id, old_id)
	Update()
end)

windower.register_event('iob change', function(main_iob_id, main_iob_level, sub_iob_id, sub_iob_level)
	Update()
end)

windower.register_event('login', function(name)
	Update()
end)

windower.register_event('gain buff', function(buff_id)
	Update()
end)

windower.register_event('lose buff', function(buff_id)
	Update()
end)

windower.register_event('time change', function(new, old)
	Update()
end)