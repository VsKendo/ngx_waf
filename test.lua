ngx.say("hello");
local ngx_var = ngx.var

local scheme = ngx_var.scheme
local host = ngx_var.host
local uri = ngx_var.request_uri

local full_url = scheme .. "://" .. host .. uri

ngx.say("Full URL: ", ngx.var.uri)

local getArg = ngx.req.get_uri_args();
for k, v in pairs(getArg) do
    ngx.say("[get]key: ", k, " value:", v);
end

ngx.req.read_body();
local postArg = ngx.req.get_post_args();
for k, v in pairs(postArg) do
    ngx.say("[POST]key: ", k, " value:", v);
end

local headers = ngx.req.get_headers()
for k,v in pairs(headers) do
ngx.say("[header] name: ", k, " v:", v)
end