local skynet = require "skynet"

-- 创建玩家服务
local function create_one_player(account, passwd)
    skynet.newservice("player", account, passwd)
end

local function create_players()
    for i=1,1 do
        create_one_player("robot"..i, "robot"..1)
    end
end


local function main()
    skynet.newservice("debug_console", 9000)

    create_players()

    skynet.exit()
end

skynet.start(main)
