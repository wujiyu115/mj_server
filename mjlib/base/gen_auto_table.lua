package.path = "../../lualib/?.lua;"..package.path

local auto_table = require "auto_table"
local utils = require "utils"
local mjlib = require "mjlib"

local tested_tbl = {}

local function add_cache(t)
    local num = 0
    for i=1,9 do
        num = num * 10 + tbl[i]
    end

    if tested_tbl[num] then
        return true
    end
end

local function check_hu(t)
    for i=1,34 do
        if t[i] > 4 then
            return
        end
    end

    local num = 0
    for i=1,9 do
        num = num * 10 + t[i]
    end

    if tested_tbl[num] then
        return
    end

    tested_tbl[num] = true

    if not mjlib.get_hu_info(t) then
        print("测试失败")
        utils.print_array(t)
    end
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
            check_hu(t)
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

local function gen_auto_table()
    local t = {}
    for i=1,33 do
        table.insert(t,0)
    end

    table.insert(t,2)

    test_hu_sub(t, 1)

    utils.dump_table_2_file(auto_table, "./auto_table.lua")
end

local function gen_auto_table_with_eye()
    local auto_table_with_eye = {}

    local function add(item)
        local num = 0
        for i,v in ipairs(item) do
            num = num * 10 + v
        end
        auto_table_with_eye[num] = true
    end

    local function get(num)
        local t = {}
        while(num > 0) do
            local yushu = num%10
            num = math.floor(num/10)
            table.insert(t,1,yushu)
        end
        return t
    end

    for num,_ in pairs(auto_table) do
        local t = get(num)
        -- 在能加将的地方加一对牌
        if #t < 9 then
            local tmp = utils.copy_array(t)
            utils.print_array(tmp)
            table.insert(tmp,1,2)
            add(tmp)

            tmp = utils.copy_array(t)
            table.insert(tmp,2)
            add(tmp)
        end

        for i,c in ipairs(t) do
            if c <= 2 then
                local tmp = utils.copy_array(t)
                tmp[i] = c + 2
                add(tmp)
            end
        end
    end

    --utils.print_array(auto_table_with_eye)
    utils.dump_table_2_file(auto_table_with_eye, "./auto_table_with_eye.lua")
end

local function main()
    gen_auto_table()
    gen_auto_table_with_eye()
end

main()
