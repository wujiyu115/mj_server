local skynet = require "skynet"
local net = require "net"

local account, passwd = ...

local function connect()
    net:connect("127.0.0.1", 8888)
end

local CMD = {}

skynet.start(function ()
    skynet.dispatch("lua", function (_, session, cmd, ...)
        local f = CMD[cmd]

        assert(f, cmd)

        if session > 0  then
            skynet.ret(skynet.pack(f(...)))
        else
            f(...)
        end
    end)

    connect()
end)
