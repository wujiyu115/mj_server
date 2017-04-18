local skynet = require "skynet"
local net = require "net"
local status_mgr = require "status.mgr"
local handler_mgr = require "handler.mgr"
local player = require "player"

local account, passwd = ...

local function init()
    player:init(account, passwd)
    handler_mgr:init()
    status_mgr:enter("login")
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

    init()
end)
