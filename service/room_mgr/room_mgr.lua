local M = {}

function M:init()
    self.room_tbl = {}
end

function M:get_room(id)
    return self.room_tbl[id]
end

function M:add_room(room)
    self.room_tbl[room.id] = room
end

function M:remove_room(id)
    self.room_tbl[id] = nil
end

return M
