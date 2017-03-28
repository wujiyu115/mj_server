local skynet = require "skynet"

local function main()
    skynet.newservice("debug_console", 8000)

    -- 登陆服务
    local login = skynet.newservice("login")
    skynet.call(login, "lua", "start", {
        port = 8888,
        maxclient = 1000,
        nodelay = true,
    })

    -- base_app_mgr
    skynet.uniqueservice("base_app_mgr")

    -- room_mgr
    local room_mgr_service = skynet.uniqueservice("room_mgr")
    skynet.call(room_mgr_service, "lua", "start")

    skynet.exit()
end

skynet.start(main)
