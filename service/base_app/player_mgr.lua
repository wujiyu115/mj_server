local M = {}

function M:init()
    self.player_tbl = {}
end

function M:get_by_id(id)
    return self.player_tbl[id]
end

function M:add(obj)
    self.player_tbl[obj.id] = obj
end

function M:remove(obj)
    self.player_tbl[obj.id] = nil
end

return M


