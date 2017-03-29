local skynet = require "skynet"
require "skynet.manager"
local base_app_mgr = require "base_app_mgr"
local player_mgr = require "player_mgr"

local CMD = {}

function CMD.start()
    -- 初始化base_app_mgr
    base_app_mgr:init()
    base_app_mgr:create_base_apps()
    base_app_mgr:start_base_apps()

    player_mgr:init()
end

-- 为玩家分配一个baseapp
function CMD.get_base_app_addr(account_info)
    return {ip = "127.0.0.1", port = "9001", token = "token"}
end

local function lua_dispatch(_, session, cmd, ...)
    local f = CMD[cmd]
    assert(f, "base_app_mgr can't dispatch cmd ".. (cmd or nil))

    if session > 0 then
        skynet.ret(skynet.pack(f(...)))
    else
        f(...)
    end
end

local function init()
    skynet.register("base_app_mgr")

    skynet.dispatch("lua", lua_dispatch)

    skynet.error("base_app_mgr booted...")
end

skynet.start(init)
