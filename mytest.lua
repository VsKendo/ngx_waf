local replace = function (str)
    local ret = string.gsub(str, "script", "")
    return ret
end
local escape = function (str)
    local ret = string.gsub(str, "<", "&lt;")
    ret = string.gsub(ret, ">", "&gt;")
    ret = string.gsub(ret, " ", "&nbsp;")
    return ret
end

local str = "<script> $.get('/delete_post/') </script>"
print(replace(str))
print(escape(str))
