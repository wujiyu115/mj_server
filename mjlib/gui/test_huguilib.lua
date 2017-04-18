package.path = "../../lualib/?.lua;"..package.path

local utils = require "utils"
local mjlib = require "mjlib"
local hulib = require "huguilib"

local function test_gui_sub(t, gui_num)
    for i=1,34 do
        if t[i] > 0 then
            t[i] = t[i] - 1
            if gui_num == 0 then
                hulib.get_hu_info()
            end
        end
    end
end

local function test_gui(t, num)
    for i=1,34 do
        if t[i] > 0 then

        end
    end
end

local function add_ke(tbl)
    while true do
        local index = math.random(1,34)
        if tbl[index] <= 1 then
            tbl[index] = tbl[index] + 3
            return
        end
    end
end

local function add_shun(tbl)
    local t = {{1,7}, {10, 16}, {19, 25}}
    local i = math.random(1, #t)
    local min = t[i][1]
    local max = t[i][2]
    while(true) do
        local index = math.random(min, max)
        if tbl[index] < 4 and tbl[index + 1] < 4 and tbl[index + 2] < 4 then
            tbl[index] = tbl[index] + 1
            tbl[index + 1] = tbl[index + 1] + 1
            tbl[index + 2] = tbl[index + 2] + 1
            return
        end
    end
end

local function add_dui(tbl)
    while(true) do
        local index = math.random(1,34)
        if tbl[index] <= 2 then
            tbl[index] = tbl[index] + 2
            return
        end
    end
end

-- 随机测试
local function random_test()

end

local function test_one()
    -- 6万6万6万4筒4筒4筒4条4条5条5条6条6条发发
    local t = {
        0,0,0,   0,0,0,   0,0,0,
        1,0,1,   1,2,1,   0,1,0,
        0,0,0,   2,2,2,   0,0,0,
        0,0,0,0, 0,0,1}
    if not hulib.get_hu_info(t, nil, 34) then
        print("测试失败")
    else
        print("测试成功")
    end
end

local function test_one_color()
    local t = {}
    for i=1,34 do
        table.insert(t,0)
    end

    for eye = 1,9 do
        t[eye] = 2
        for level=1,4 do
            for i=1,9+7 do
                if i <= 9 then
                    t[i] = t[i] + 3
                else
                    t[i] = t[i] + 1
                    t[i+1] = t[i+1] + 1
                    t[i+2] = t[i+2] + 1
                end

                if level == 4 then

                end

                if i <= 9 then
                    t[i] = t[i] - 3
                else
                    t[i] = t[i] - 1
                    t[i+1] = t[i+1] - 1
                    t[i+2] = t[i+2] - 1
                end
            end
        end
    end
end

local function test_two_color()

end

local function test_full()

end

local function test_hu_sub(t, num)
    for j=1,16 do
        if j<= 9 then
            t[j] = t[j] + 3
        else
            local index = j - 9
            t[index] = t[index] + 1
            t[index + 1] = t[index + 1] + 1
            t[index + 2] = t[index + 2] + 1
        end

        if num == 4 then
            local valid = true
            for i=1,34 do
                if t[i] > 4 then
                    valid = false
                    break
                end
            end

            if valid and not hulib.get_hu_info(t) then
                print("测试失败")
                utils.print_array(t)
            end
        else
            test_hu_sub(t, num + 1)
        end

        if j<= 9 then
            t[j] = t[j] - 3
        else
            local index = j - 9
            t[index] = t[index] - 1
            t[index + 1] = t[index + 1] - 1
            t[index + 2] = t[index + 2] - 1
        end
    end
end

local function test_hu()
    local t = {}
    for i=1,33 do
        table.insert(t,0)
    end

    table.insert(t,2)

    test_hu_sub(t, 0)
end

local function main()
    test_one()
end

main()
