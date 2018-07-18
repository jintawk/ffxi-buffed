--[[
Copyright (c) 2014, Matt McGinty
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
    * Neither the name of <addon name> nor the
    names of its contributors may be used to endorse or promote products
    derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <your name> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

_addon.name = 'rdm-help'
_addon.version = '1.0'
_addon.author = 'Jintawk/Jynvoco (Asura)'
_addon.command = 'skill'

require('actions')
require('tables')
require('sets')
require('texts')

config = require('config')
texts = require('texts')
res = require('resources')

require "List"
require "Buff"
require "util"

defaults = {}
defaults.pos = {}
defaults.pos.x = 300
defaults.pos.y = 475
defaults.text = {}
defaults.text.font = 'Courier New'
defaults.text.size = 10
defaults.flags = {}
defaults.flags.bold = true
defaults.flags.draggable = true
defaults.bg = {}
defaults.bg.alpha = 128

buffList = {
	"Light Arts", 
	"Addendum: White", 
	"Composure",
	"Refresh",
	"Enthunder II",
	"Phalanx",
	"Stoneskin",
	"Blink",
}

settings = config.load(defaults)
gui = texts.new(settings)

function Update()
	if windower == nil or windower.ffxi == nil or windower.ffxi.get_player() == nil or windower.ffxi.get_player().buffs == nil then
		windower.add_to_chat(207, "! rdm-help can't start - something is nil")
		return
	end

	local buffStatus = List.new()

	for i = 1, #buffList do
		local buffId = GetBuffId(buffList[i])

		windower.add_to_chat(207, "gbi " .. buffList[i] .. " = " .. buffId)

		if buffList[i] == nil then
			windower.add_to_chat(207, "! rdm-help: Unknown buffid -> " .. buffId)						
		elseif buffId == -1 then
			windower.add_to_chat(207, "! rdm-help: Unknown buff -> " .. buffList[i])					
		else		
			local buff = Buff.new({ buffList[i], buffId, "OFF" })
			local activeBuffs = windower.ffxi.get_player().buffs

			for j = 1, #activeBuffs do
				if activeBuffs[j] == buffId then
					windower.add_to_chat(207, "buff found ! " .. buff.name)
					buff.active = "ON"
				end
			end

			buffStatus:push_back(buff)
			windower.add_to_chat(207, "Added " .. buff.name .. " " .. buff.id .. " " .. buff.active)			
		end
	end

	UpdateGUI(buffStatus)
end

function GetBuffId(buffName)
	for key, val in pairs(res.buffs) do
		if val.en == buffName then
			return key
		end
	end

	return -1
end

function UpdateGUI(buffStatus)
	local guiStr = "rdm-help"

	for i = buffStatus.first, buffStatus.first + buffStatus.count - 1 do
		if buffStatus.items[i].active == "ON" then
			guiStr = guiStr .. "\n\\cs(255, 255, 255)" .. buffStatus.items[i].name .. ": \\cs(0,255,0)" .. buffStatus.items[i].active
		else
			guiStr = guiStr .. "\n\\cs(255, 255, 255)" .. buffStatus.items[i].name .. ": \\cs(255,0,0)" .. buffStatus.items[i].active
		end
	end

	gui:text(guiStr)
	gui:visible(true)
end

windower.register_event('load', function()
	Update()
end())

windower.register_event('zone change', function()
	Update()
end())

windower.register_event('job change', function()
	Update()
end())

windower.register_event('login', function()
	Update()
end())

windower.register_event('gain buff', function(buff_id)
	windower.add_to_chat(207, "gain ")
	Update()
end)

windower.register_event('lose buff', function(buff_id)
	windower.add_to_chat(207, "lose" )
	Update()
end)

