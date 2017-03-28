local skynet = require "skynet"
local utils = require "utils"

local M = {}

function M:start(conf)
    self.gate = skynet.newservice("gate")

    skynet.call(self.gate, "lua", "open", conf)

    skynet.error("login service listen on port "..conf.port)
end

-------------------处理socket消息开始--------------------
function M:open(fd, addr)
    skynet.error("New client from : " .. addr)
end

function M:close(fd)
    skynet.error("socket close "..fd)
end

function M:error(fd, msg)
    skynet.error("socket error "..fd)
end

function M:warning(fd, size)
    -- size K bytes havn't send out in fd
    skynet.error("socket warning "..fd)
end

function M:data(fd, msg)
    skynet.error("socket data fd "..fd)
    local proto_id, params = string.unpack(">Hs2", msg)

    params = utils.str_2_table(params)

    self:dispatch(fd, proto_id, params)
end
-------------------处理socket消息结束--------------------

-------------------网络消息回调函数开始------------------
function M:register_callback()
    self.dispatch_tbl = {
        [1] = self.login,
        [3] = self.register
    }
end

function M:dispatch(fd, proto_id, params)
    local f = self.dispatch_tbl[proto_id]
    if not f then
        return
    end

    local ret_msg = f(self, fd, params)
    if ret_msg then
        socket.send(fd, packer.pack(proto_id, ret_msg))
    end
end

function M:login(fd, msg)
    local success, errmsg = account_mgr:verify(msg.account, msg.passwd)
    if not success then
        return {errmsg = errmsg}
    end

    return {token = "token"}
end

function M:register(fd, msg)
    if account_mgr:get_by_account(msg.account) then
        return {errmsg = "account exist"}
    end

    local success, info = account_mgr:register(msg.account, msg.passwd)

    return info
end
-------------------网络消息回调函数结束------------------

return M
