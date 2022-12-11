-- [ Windower settings ]
_addon.name = 'buffed'
_addon.version = '1.4'
_addon.author = 'Jintawk/Jynvoco (Asura)'
_addon.command = 'buffed'

-- [ Lib imports ]
require('actions')
require('tables')
require('sets')

-- [ Lib variable imports ]
local res = require('resources')

-- [ Local Lib/Class imports ]
require "Buff"
require "List"

-- [ Local Lib/Helper imports ]
require "gui"
require "util"
require "debuffs"

-- [ Init settings ]
local defaults = {}
local settings = config.load(defaults)

-- [ vars ]
local cachedBuffIds = {}

-- [ Functions ]
function GetBuffIdsFromResources(buffName)
	if cachedBuffIds[buffName] ~= nil then
		return cachedBuffIds[buffName]
	end

	cachedBuffIds[buffName] = {}

	for key, val in pairs(res.buffs) do
		if windower.regex.match(val.en, buffName) then
			table.insert(cachedBuffIds[buffName], key)
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

	if settings.buffs[jobKey] == nil then
		UpdateGUI(buffsToDisplay)
		return
	end

	settingsBuffsToUse = settings.buffs[jobKey]

	for _, val in pairs(Split(settingsBuffsToUse, ",")) do
		local resourceBuffIds = GetBuffIdsFromResources(val)
		
		if next(resourceBuffIds) == nil then
			windower.add_to_chat(207, "! rdm-help: Unknown buff in settings -> " .. tostring(val))
			return
		end

		local trackedBuff = Buff.new({ val, false, false, true })
		for _, buffId in pairs(resourceBuffIds) do
			for _, currentBuffId in pairs(currentPlayerBuffs) do
				if buffId == currentBuffId then
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

	-- Debuffs
	for _, currentBuffId in pairs(currentPlayerBuffs) do
		local debuff = Buff.new({ "", true, true, false })

		if debuffNames[currentBuffId] then
			debuff.name = debuffNames[currentBuffId]
		else
			debuff.debuff = false
		end

		if string.len(debuff.name) > 0 then
			buffsToDisplay:push_back(debuff)
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