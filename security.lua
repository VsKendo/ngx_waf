local waf = require 'waf_init'
local uri = ngx.var.uri

local sql_injection_pattern = [=[(['"])\s*OR\s*]=]
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

local change = false
if string.len(uri) >= 8 then
    local kind = string.sub(uri, 2, 8)
    if kind == 'sqlwaf1' then
        change = true
        ngx.log(ngx.ALERT, "sqlwaf1 triggered")
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
    elseif kind == 'xsswaf1' then
        change = true
        ngx.log(ngx.ALERT, "xsswaf1 triggered")
        local uri_args, post_args = waf.get_args()
        for key, value in pairs(uri_args)
        do
            -- uri_args[key] = replace(value)
            ngx.log(ngx.ALERT, "[get] key: ",key)
            ngx.log(ngx.ALERT, "[get] value: ",value)
            if type(value) == 'table' then
                for i, v in ipairs(value) do
                    val[i] = replace(v)
                end
            else
                uri_args[key] = replace(value)
            end
        end
        ngx.req.set_uri_args(uri_args)
        for key, val in pairs(post_args) do
            if type(val) == "table" then
                for i, v in ipairs(val) do
                    val[i] = replace(v)
                end
            else
                post_args[key] = replace(val)
            end
            -- uri_args[key] = replace(value)
        end
        local new_post_data = ngx.encode_args(post_args)
        ngx.req.set_body_data(new_post_data)
    elseif kind == 'xsswaf2' then
        change = true
        local uri_args, post_args = waf.get_args()
        for key, value in pairs(uri_args)
        do
            -- uri_args[key] = replace(value)
            if type(value) == 'table' then
                for i, v in ipairs(value) do
                    val[i] = escape(v)
                end
            else
                uri_args[key] = escape(value)
            end
        end
        ngx.req.set_uri_args(uri_args)
        for key, val in pairs(post_args) do
            if type(val) == "table" then
                for i, v in ipairs(val) do
                    val[i] = escape(v)
                end
            else
                post_args[key] = escape(val)
            end
        end
        local new_post_data = ngx.encode_args(post_args)
        ngx.req.set_body_data(new_post_data)
    end
end
local new_uri = "/"..string.sub(uri,9)
if change and new_uri and new_uri ~="/" and new_uri ~= "//" then
    ngx.req.set_uri(new_uri, true)
end
