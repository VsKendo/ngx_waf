local waf = require 'waf_init'
local uri = ngx.var.uri

local sql_injection_pattern = [=[(['"])\s*OR\s*]=]

if string.len(uri) >= 8 then
    local kind = string.sub(uri, 2, 8)
    if kind == 'sqlwaf1' then
        local uri_args, post_args = waf.get_args()
        for key, value in pairs(uri_args)
        do
            if ngx.re.match(ngx.unescape_uri(value), sql_injection_pattern, "isjo") then
                waf.reject_request()
                return
            end
        end
        for key, value in pairs(post_args)
        do
            if key ~= "csrfmiddlewaretoken" then
                if ngx.re.match(value, sql_injection_pattern, "isjo") then
                    waf.reject_request()
                    return
                end
            end
        end
    elseif  then

    end
end
local new_uri = "/"..string.sub(uri,9)
if new_uri ~="/" and new_uri ~= "//" then
    ngx.req.set_uri(new_uri, true)
end
