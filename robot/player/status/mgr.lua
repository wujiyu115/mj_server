local login = require "status.login"
local room = require "status.room"

local status_tbl = {
    ["login"] = login,
    ["room"] = room
}

local M = {
    cur = nil
}

function M.enter(name)
    if self.cur then
        self.cur.leave()
    end
    self.cur = status_tbl[name]
    self.cur.enter()
end

return M




