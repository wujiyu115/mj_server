local skynet = require "skynet"
require "skynet.manager"
local room_mgr = require "room_mgr"

local CMD = {}

function CMD.start()
    room_mgr:init()
end

function CMD.create_room()
    return room_mgr:create(1, 2)
end

function CMD.join_room()

end

local function dispatch(_, session, cmd, ...)
    local f = CMD[cmd]
    assert(f, "room_mgr接收到非法lua消息: "..cmd)

    if session == 0 then
        f(...)
    else
        skynet.ret(skynet.pack(f(...)))
    end
end

skynet.start(function ()
    skynet.dispatch("lua", dispatch)

    skynet.register("room_mgr")

    skynet.error("room_mgr booted...")
end)
