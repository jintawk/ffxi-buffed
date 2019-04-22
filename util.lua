function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function starts_with(str, start)
return str:sub(1, #start) == start
end
     
function ends_with(str, ending)
return ending == "" or str:sub(-#ending) == ending
end