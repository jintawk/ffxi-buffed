-- Offline smoke test for buffed's mythril port (gui.lua): drives UpdateGUI so
-- the Panel + per-buff Labels (and every colour branch) run for real. Stubs
-- windower/texts/images/config + strings. Run with local Lua 5.1.

_addon = {name = 'buffed'}
coroutine.schedule = function() end

local events = {}
windower = {
    windower_path = 'C:/Program Files (x86)/Windower/',
    addon_path = 'C:/nonexistent-buffed-harness/',
    register_event = function(name, fn) events[name] = fn end,
    add_to_chat = function() end,
}
package.preload['strings'] = function() return {} end
package.preload['config'] = function()
    return {load = function(d) return d end, save = function() end, register = function() end}
end
package.preload['texts'] = function()
    return {new = function(str)
        local t = {_str = str, _visible = false}
        function t:hide() self._visible = false end
        function t:show() self._visible = true end
        function t:visible(v) if v ~= nil then self._visible = v end return self._visible end
        function t:text(s) self._str = s end
        function t:pos() end function t:color() end function t:alpha() end function t:size() end
        function t:extents() return 40, 12 end
        function t:hover() return false end
        function t:destroy() end
        return t
    end}
end
package.preload['images'] = function()
    return {new = function(s)
        local t = {_visible = false, _alpha = s.color and s.color.alpha}
        function t:show() self._visible = true end
        function t:hide() self._visible = false end
        function t:visible(v) if v ~= nil then self._visible = v end return self._visible end
        function t:pos() end function t:size() end function t:color() end
        function t:alpha(a) self._alpha = a end
        function t:repeat_xy() end function t:destroy() end
        return t
    end}
end

package.path = 'C:/Program Files (x86)/Windower/addons/libs/?.lua;'
    .. 'C:/Program Files (x86)/Windower/addons/buffed/?.lua;' .. package.path

dofile('C:/Program Files (x86)/Windower/addons/buffed/gui.lua')

local function check(cond, msg)
    if not cond then print('FAIL: ' .. msg) os.exit(1) end
end
check(type(UpdateGUI) == 'function', 'UpdateGUI defined')

-- one of each colour branch: debuff (bad), tracked==false (text), active (ok),
-- inactive tracked (warn)
local buffs = {
    count = 4, first = 1, last = 4,
    items = {
        {name = 'Poison',    debuff = true},
        {name = 'Signet',    tracked = false},
        {name = 'Haste',     active = true},
        {name = 'Protect',   active = false, tracked = true},
    },
}
UpdateGUI(buffs)

-- empty list hides the panel without error
UpdateGUI({count = 0, first = 1, last = 0, items = {}})
UpdateGUI(nil)

-- and re-show
UpdateGUI(buffs)

-- command handler: scale + fallthrough
events['addon command']('scale', '1.5')
events['addon command']('help')

print('ALL OK')
