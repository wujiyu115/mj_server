local id_mgr = require "id_mgr"

local M = {}

function M:init()
    id_mgr:init()
    self.room_tbl = {}
    self.player_2_room = {}
end

function M:create(game_id, player_id)
    local id = id_mgr:gen_id(game_id)
    self.room_tbl = {id = id, player_id = player_id}
    self.player_2_room[player_id] = id
end

function M:close(room_id, player_id)
    self.room_tbl[room_id] = nil
    self.player_2_room[player_id] = nil
end

function M:get_room_by_player()

end

return M
