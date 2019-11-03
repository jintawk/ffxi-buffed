-- [ Windower settings ]
_addon.name = 'buffed'
_addon.version = '1.31'
_addon.author = 'Jintawk/Jynvoco (Asura)'
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
require "util"

-- [ Init settings ]
defaults = {}

settings = config.load(defaults)

-- [ vars ]
local cachedBuffIds = {}

-- [ Functions ]
function GetBuffIdsFromResources(buffName)
	if cachedBuffIds[buffName] ~= nil then 
		return cachedBuffIds[buffName] 
	end

	local numBuffs = 0
	cachedBuffIds[buffName] = {}

	for key, val in pairs(res.buffs) do
		if windower.regex.match(val.en, buffName) then
			numBuffs = numBuffs + 1
			cachedBuffIds[buffName][numBuffs] = key		
		end
	end

	return cachedBuffIds[buffName]
end

function Update()
	if windower == nil or windower.ffxi == nil or windower.ffxi.get_player() == nil or windower.ffxi.get_player().buffs == nil then		
		return
	end

	local buffsToDisplay = List.new()
	local currentPlayerBuffs = windower.ffxi.get_player().buffs

	local settingsBuffsToUse = nil
	local jobKey = (windower.ffxi.get_player().main_job .. windower.ffxi.get_player().sub_job):lower()

	--dbg
	if settings.buffs[jobKey] ~= nil then
		settingsBuffsToUse = settings.buffs[jobKey]
	else 
		buffsToDisplay = nil
		UpdateGUI(buffsToDisplay)
		return
	end

	for key,val in pairs(split(settingsBuffsToUse, ",")) do

		local resourceBuffIds = GetBuffIdsFromResources(val)		
		
		if next(resourceBuffIds) == nil then
			windower.add_to_chat(207, "! rdm-help: Unknown buff in settings -> " .. tostring(val))					
		else		
			local trackedBuff = Buff.new({ val, false })

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

windower.register_event('job change', function(main_iob_id, main_iob_level, sub_iob_id, sub_iob_level)
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