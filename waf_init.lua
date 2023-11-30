local html = [[
    <html xmlns="http://www.w3.org/1999/xhtml"><head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
      <title>Access denied</title>
      <style>
        p {
          line-height: 20px;
          margin: 0;
          -qt-block-indent: 0;
          text-indent: 0px;
        }
        ul {
          list-style-type: none;
          margin-top: 0;
          -qt-list-indent: 1;
        }
        li {
          list-style-type: none;
          margin-top: 12px;
          margin-bottom: 0px;
          margin-left: 0px;
          margin-right: 0px;
          -qt-block-indent: 0;
          text-indent: 0px;
        }
      </style>
    </head>
    <body style="font: 14px/1.5 Microsoft Yahei, sans-serif; color: #555">
      <div style="width: 600px; padding: 5%">
        <div style="
            height: 40px;
            line-height: 40px;
            color: #fff;
            font-size: 16px;
            overflow: hidden;
            background: #6bb3f6;
            padding-left: 20px;
          ">
          Web Application Firewall Alert
        </div>
        <div style="
            border: 1px dashed #cdcece;
            border-top: none;
            font-size: 14px;
            background: #fff;
            color: #555;
            line-height: 24px;
            height: 220px;
            padding: 20px 20px 0 20px;
            overflow-y: auto;
            background: #f3f7f9;
          ">
          <p><span style="font-weight: 600; color: #fc4f03; font-size: 16px">Your request has been blocked by the administrator!</span></p>
          <p>Possible reasons: The request contains illegal parameters.</p>
          <p style="margin-top: 12px; margin-bottom: 12px; -qt-block-indent: 1">What should I do?</p>
          <ul>
            <li>1&rpar;&nbsp;Check your request parameters</li>
            <li>2&rpar;&nbsp;If this is a hosted website, please contact the server provider</li>
            <li>3&rpar;&nbsp;If this is a wrong interception, please contact the website administrator
            </li></ul></div></div></body></html>
]]

local function reject_request()
    ngx.header.content_type = "text/html"
    ngx.status = ngx.HTTP_FORBIDDEN
    ngx.say(html)
    ngx.exit(ngx.status)
    return 
end

local function get_args()
    ngx.req.read_body()
    return ngx.req.get_uri_args(), ngx.req.get_post_args()
end

return {
    reject_request = reject_request,
    get_args = get_args
}