local skynet = require "skynet"
require "skynet.manager"
local room_mgr = require "room_mgr"
local room_list = require "room_list"
local room = require "room"

local CMD = {}

function CMD.start()
    room_mgr:init()

    for _,v in ipairs(room_list) do
        local room_obj = room.create(v)
        room_mgr:add_room(room_obj)
    end
end

function CMD.enter_room()

end

function CMD.leave_room()

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
