local MongoLib = require "mongolib"

local mongo_host = "127.0.0.1"
local mongo_db = "mj_server"

local M = {}

function M:init()
    self.mongo = MongoLib.new()
    self.mongo:connect(mongo_host)
    self.mongo:use(mongo_db)
    self.account_tbl = {}
    self:load_all()
end

function M:load_all()
    local record_list = mongo:find_all("account")

    for _,v in pairs(record_list) do
        self.account_tbl[v.account] = v
    end
end

function M:get_by_account(account)
    return self.account_tbl[account]
end

-- 验证账号密码
function M:verify(account, passwd)
    local info = self.account_tbl[account]
    if not info then
        return false, "account not exist"
    end

    if info.passwd ~= passwd then
        return false, "wrong password"
    end

    return true
end

-- 注册账号
function M.register(info)
    if self.account_tbl[info.account] then
        return false, "account exists"
    end

    local info = {account = info.account, passwd = info.passwd}
    self.account_tbl[account] = info
    mongo:insert("account", info)

    return true, info
end

return M
