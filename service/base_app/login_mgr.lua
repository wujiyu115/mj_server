local sock_mgr = require "sock_mgr"
local player = require "player"
local player_mgr = require "player_mgr"

local M = {}

function M:init()
    self.new_conn_tbl = {}
    sock_mgr:register_callback(1, self.auth, self)
end

function M:auth(fd, proto_id, msg)
    if proto_id ~= 1 then
        return {errmsg = "invalid status"}
    end

    if msg.token ~= "token" then
        return {errmsg = "wrong token"}
    end

    self.new_conn_tbl[fd] = nil

    local obj = player.create(fd, msg.account)
    obj:load_from_db()

    player_mgr:add(obj)
end

return M
