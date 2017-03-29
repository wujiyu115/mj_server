local skynet = require "skynet"
local socket = require "socket"
local utils = require "utils"
local packer = require "packer"

local M = {
    dispatch_tbl = {},
    authed_fd = {}
}

function M:start(conf)
    self.gate = skynet.newservice("gate")

    skynet.call(self.gate, "lua", "open", conf)

    skynet.error("login service listen on port "..conf.port)
end

-------------------处理socket消息开始--------------------
function M:open(fd, addr)
    skynet.error("New client from : " .. addr)
    skynet.call(self.gate, "lua", "accept", fd)
end

function M:close(fd)
    self:close_conn(fd)
    skynet.error("socket close "..fd)
end

function M:error(fd, msg)
    self:close_conn(fd)
    skynet.error("socket error "..fd.." msg "..msg)
end

function M:warning(fd, size)
    self:close_conn(fd)
    skynet.error(string.format("%dK bytes havn't send out in fd=%d", size, fd))
end

function M:data(fd, msg)
    skynet.error(string.format("socket data fd = %d, len = %d ", fd, #msg))
    local proto_id, params = string.unpack(">Hs2", msg)

    skynet.error(string.format("msg id:%d content:%s", proto_id, params))
    params = utils.str_2_table(params)

    -- 没通过验证发送非验证消息
    if not self.authed_fd[fd] and proto_id ~= 1 then
        skynet.call(self.gate, "lua", "kick", fd)
        return
    end

    self:dispatch(fd, proto_id, params)
end

function M:close_conn(fd)
    self.authed_fd[fd] = nil
end

-------------------处理socket消息结束--------------------

-------------------网络消息回调函数开始------------------
function M:register_callback(id, func, obj)
    self.dispatch_tbl[id] = {func = func, obj = obj}
end

function M:dispatch(fd, proto_id, params)
    local t = self.dispatch_tbl[proto_id]
    if not t then
        skynet.error("can't find socket callback "..proto_id)
        return
    end

    local ret
    if t.obj then
        ret = t.func(t.obj, fd, proto_id, params)
    else
        ret = t.func(fd, proto_id, params)
    end

    if ret then
        skynet.error("ret msg:"..utils.table_2_str(ret))
        socket.write(fd, packer.pack(proto_id, ret))
    end
end

-------------------网络消息回调函数结束------------------

return M
