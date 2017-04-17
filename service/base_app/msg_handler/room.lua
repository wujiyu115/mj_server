local skynet = require "skynet"

local M = {}

function M.create_table(cfg)
    local id = skynet.call("room_mgr", "lua", "create_table", cfg)
    return {table_id = id}
end

function M.join_table()

end

return M
