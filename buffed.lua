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
	
	if settings.buffs[jobKey] ~= nil then
		settingsBuffsToUse = settings.buffs[jobKey]
	else
		buffsToDisplay = nil
		UpdateGUI(buffsToDisplay)
	end

	if buffsToDisplay == nil then return end

	for key,val in pairs(Split(settingsBuffsToUse, ",")) do

		local resourceBuffIds = GetBuffIdsFromResources(val)

		if next(resourceBuffIds) == nil then
			windower.add_to_chat(207, "! rdm-help: Unknown buff in settings -> " .. tostring(val))
		else
			local trackedBuff = Buff.new({ val, false, false, true })

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

	-- Debuffs
	for i = 1, #currentPlayerBuffs do
		local debuff = Buff.new({ "", true, true, false })

		if currentPlayerBuffs[i] == 1 then
			debuff.name = "Weakness"
		elseif currentPlayerBuffs[i] == 2 then
			debuff.name = "Sleep"
		elseif currentPlayerBuffs[i] == 3 then
			debuff.name = "Poison"
		elseif currentPlayerBuffs[i] == 4 then
			debuff.name = "Paralysis"
		elseif currentPlayerBuffs[i] == 5 then
			debuff.name = "Blindness"
		elseif currentPlayerBuffs[i] == 6 then
			debuff.name = "Silence"
		elseif currentPlayerBuffs[i] == 7 then
			debuff.name = "Petrification"
		elseif currentPlayerBuffs[i] == 8 then
			debuff.name = "Disease"
		elseif currentPlayerBuffs[i] == 9 then
			debuff.name = "Curse"
		elseif currentPlayerBuffs[i] == 10 then
			debuff.name = "Stun"
		elseif currentPlayerBuffs[i] == 11 then
			debuff.name = "Bind"
		elseif currentPlayerBuffs[i] == 12 then
			debuff.name = "Weight"
		elseif currentPlayerBuffs[i] == 13 then
			debuff.name = "Slow"
		elseif currentPlayerBuffs[i] == 14 then
			debuff.name = "Charm"
		elseif currentPlayerBuffs[i] == 15 then
			debuff.name = "Doom"
		elseif currentPlayerBuffs[i] == 16 then
			debuff.name = "Amnesia"
		elseif currentPlayerBuffs[i] == 17 then
			debuff.name = "Charm"
		elseif currentPlayerBuffs[i] == 18 then
			debuff.name = "Gradual Petrification"
		elseif currentPlayerBuffs[i] == 19 then
			debuff.name = "Sleep"
		elseif currentPlayerBuffs[i] == 20 then
			debuff.name = "Curse"
		elseif currentPlayerBuffs[i] == 21 then
			debuff.name = "Addle"
		elseif currentPlayerBuffs[i] == 22 then
			debuff.name = "Intimidate"
		elseif currentPlayerBuffs[i] == 23 then
			debuff.name = "Kaustra"
		elseif currentPlayerBuffs[i] == 28 then
			debuff.name = "Terror"
		elseif currentPlayerBuffs[i] == 29 then
			debuff.name = "Mute"
		elseif currentPlayerBuffs[i] == 30 then
			debuff.name = "Bane"
		elseif currentPlayerBuffs[i] == 31 then
			debuff.name = "Plague"
		elseif currentPlayerBuffs[i] == 128 then
			debuff.name = "Burn"
		elseif currentPlayerBuffs[i] == 129 then
			debuff.name = "Frost"
		elseif currentPlayerBuffs[i] == 130 then
			debuff.name = "Choke"
		elseif currentPlayerBuffs[i] == 131 then
			debuff.name = "Rasp"
		elseif currentPlayerBuffs[i] == 132 then
			debuff.name = "Shock"
		elseif currentPlayerBuffs[i] == 133 then
			debuff.name = "Drown"
		elseif currentPlayerBuffs[i] == 134 then
			debuff.name = "Dia"
		elseif currentPlayerBuffs[i] == 135 then
			debuff.name = "Bio"
		elseif currentPlayerBuffs[i] == 136 then
			debuff.name = "STR Down"
		elseif currentPlayerBuffs[i] == 137 then
			debuff.name = "DEX Down"
		elseif currentPlayerBuffs[i] == 138 then
			debuff.name = "VIT Down"
		elseif currentPlayerBuffs[i] == 139 then
			debuff.name = "AGI Down"
		elseif currentPlayerBuffs[i] == 140 then
			debuff.name = "INT Down"
		elseif currentPlayerBuffs[i] == 141 then
			debuff.name = "MND Down"
		elseif currentPlayerBuffs[i] == 142 then
			debuff.name = "CHR Down"
		elseif currentPlayerBuffs[i] == 144 then
			debuff.name = "Max HP Down"
		elseif currentPlayerBuffs[i] == 145 then
			debuff.name = "Max MP Down"
		elseif currentPlayerBuffs[i] == 146 then
			debuff.name = "Accuracy Down"
		elseif currentPlayerBuffs[i] == 147 then
			debuff.name = "Attack Down"
		elseif currentPlayerBuffs[i] == 148 then
			debuff.name = "Evasion Down"
		elseif currentPlayerBuffs[i] == 149 then
			debuff.name = "Defense Down"
		elseif currentPlayerBuffs[i] == 156 then
			debuff.name = "Flash"
		elseif currentPlayerBuffs[i] == 167 then
			debuff.name = "Magic Def. Down"
		elseif currentPlayerBuffs[i] == 174 then
			debuff.name = "Magic Acc. Down"
		elseif currentPlayerBuffs[i] == 175 then
			debuff.name = "Magic Atk. Down"
		elseif currentPlayerBuffs[i] == 186 then
			debuff.name = "Helix"
		elseif currentPlayerBuffs[i] == 189 then
			debuff.name = "Max TP Down"
		elseif currentPlayerBuffs[i] == 192 then
			debuff.name = "Requiem"
		elseif currentPlayerBuffs[i] == 193 then
			debuff.name = "Lullaby"
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