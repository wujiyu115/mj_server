local MongoLib = require "mongolib"

local dbconf = {
    host="127.0.0.1",
    port=27017,
    db="game",
    username="yun",
    password="yun",
    authmod="mongodb_cr"
}

local M = {}

function M:init()
    self.mongo = MongoLib.new()
    self.mongo:connect(dbconf)
    self.mongo:use("player")
end

function M:load_player(account)
    local it = self.mongo:find_one("player",{account = account},{_id = false})
    for k,v in pairs(it) do
        print(k,v)
    end
end

function M:save_player(obj)
    self.mongo:insert("player", obj)
end

return M
