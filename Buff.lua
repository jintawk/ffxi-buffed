--[[Class object of a ffxi Buff (spell/Buff) - MMcGinty 2018]]

Buff = {};
Buff.__index = Buff;

--[[
    Create a new Buff
]]
function Buff.new(params)
	local buff = setmetatable({}, Buff)

	buff.name = params[1]
	buff.active = params[2]
	buff.debuff = params[3]
	buff.tracked = params[4]

	return buff
end