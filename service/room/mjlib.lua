local utils = require "utils"

local M = {}

-- 创建一幅牌
function M.create(zi, hua)
    local t = {}

    -- 万、筒、条 
    for i = 0,2 do
        for j=1,9 do
            table.insert((t), i*16 + j)
            table.insert((t), i*16 + j)
            table.insert((t), i*16 + j)
            table.insert((t), i*16 + j)
        end
    end

    -- 字牌
    if zi then
        for i = 1,7 do
            table.insert((t), 0x30 + i)
            table.insert((t), 0x30 + i)
            table.insert((t), 0x30 + i)
            table.insert((t), 0x30 + i)
        end
    end

    -- 花牌
    if hua then
        for i = 1, 7 do
            table.insert((t), 0x40 + i)
            table.insert((t), 0x40 + i)
            table.insert((t), 0x40 + i)
            table.insert((t), 0x40 + i)
        end
    end

    return t
end

-- 洗牌
function M.shuffle(t)
    for i=#t,2,-1 do
        local tmp = t[i]
        local index = math.random(1, i - 1)
        t[i] = t[index]
        t[index] = tmp
    end
end

function M.test()
    local t = M.create()
    M.shuffle(t)
    utils.print(t)
end

return M
