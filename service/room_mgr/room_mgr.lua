local room_list = require "room_list"

local M = {}

function M:init()
    self.room_tbl = {}
end

function M:create_room_by_list()
    for _,v in ipairs(room_list) do
        --skynet.error("创建房间 "..v.name)
        local addr = skynet.newservice(v.service, v.id)
        self.room_tbl[room.id] = {addr = addr}
    end
end

function M:get_room(id)
end

function M:remove_room(id)
end

return M
