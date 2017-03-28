local skynet = require "skynet"

local M = {}

M.__index = M

function M.create(info)
    local o = {
        id = info.id,
        addr = skynet.newservice(info.service, info.id)
    }

    setmetatable(o, M)
    return o
end

-- 玩家进入房间
function M:add_player(player)
    local info = {id = player.id}
    skynet.call(self.addr, "lua", "enter", info)
end

function M:remove_player(player)
    skynet.call(self.addr, "lua", "leave", player.id)
end

return M
