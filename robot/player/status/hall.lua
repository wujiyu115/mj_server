local net = require "net"
local player = require "player"

local M = {}

function M:enter()
    player:send_request("room.create_room", {})
end

function M:tick()

end

function M:leave()

end

return M
