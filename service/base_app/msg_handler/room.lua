local skynet = require "skynet"

local M = {}

function M.create_room(cfg)
    local id = skynet.call("room_mgr", "lua", "create_room", cfg)
    return {room_id = id}
end

function M.join_room()

end

return M
