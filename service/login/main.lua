local skynet = require "skynet"
require "skynet.manager"
local sock_mgr = require "sock_mgr"

local CMD = {}

function CMD.start(conf)
    sock_mgr:start(conf)
end

skynet.start(function()
    skynet.dispatch("lua", function(_, session, cmd, subcmd, ...)
        if cmd == "socket" then
            local f = sock_mgr[subcmd]
            f(sock_mgr, ...)
            -- socket api don't need return
        else
            local f = CMD[cmd]
            if not f then
                return
            end

            skynet.ret(skynet.pack(f(subcmd, ...)))
        end
    end)

    skynet.register("login")
end)
