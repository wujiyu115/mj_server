local hu_table = require "hu_table"

local CardType = {
    [0x10] = {min = 1, max = 9, chi = true},
    [0x20] = {min = 10, max = 18, chi = true},
    [0x30] = {min = 19, max = 27, chi = true},
    [0x40] = {min = 28, max = 34, chi = false},
}

local CardDefine = {
    0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, -- 万
    0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, -- 筒
    0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, -- 条
    0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, -- 东、南、西、北、中、发、白
}

local M = {}

M.COLOR_WAN = 0x10
M.COLOR_TONG = 0x20
M.COLOR_TIAO = 0x30
M.COLOR_ZI = 0x40
M.COLOR_HUA = 0x50

-- 创建一幅牌,牌里存的不是牌本身，而是牌的序号
function M.create(zi)
    local t = {}

    local num = 3*9

    if zi then
        num = num + 7
    end

    for i=1,num do
        for _=1,4 do
            table.insert(t, i)
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

function M.can_peng(hand_cards, card)
    return hand_cards[card] >= 2
end

function M.can_angang(hand_cards, card)
    return hand_cards[card] == 4
end

function M.can_gang(hand_cards, card)
    return hand_cards[card] == 3
end

function M.can_chi(hand_cards, card1, card2)
    if not hand_cards[card1] or not hand_cards[card2] then
        return false
    end

    if hand_cards[card1] == 0 or  hand_cards[card2] == 0 then
        return false
    end

    local color1 = CardDefine[hand_cards[card1]] & 0xf0
    local color2 = CardDefine[hand_cards[card2]] & 0xf0

    if color1 ~= color2 then
        return false
    end

    -- 本种花色不能吃
    if not CardType[color1].chi then
        return false
    end

    return true
end

function M.can_left_chi(hand_cards, card)
    return M.can_chi(hand_cards, card + 1, card + 2)
end

function M.can_middle_chi(hand_cards, card)
    return M.can_chi(hand_cards, card - 1, card + 1)
end

function M.can_right_chi(hand_cards, card)
    return M.can_chi(hand_cards, card - 2, card - 1)
end

function M.get_hu_info(hand_cards, waves, self_card, other_card)
    local hand_cards_tmp = {}
    for i,v in ipairs(hand_cards) do
        hand_cards_tmp[i] = v
    end

    if other_card then
        hand_cards_tmp[other_card] = hand_cards_tmp[other_card] + 1
    end

    local first_info = {
        eye_count = 0,       -- 能做成将的有几对
        dui_count = 0,      -- 对子数量
        dui_array = {},
        peng_count = 0,     -- 刻子数量
        normal_cards = {},   -- 普通牌
        zi_cards = {}       -- 字牌
    }

    for color, cfg in pairs(CardType) do
        if cfg.chi then
            M.check_hu_chi(hand_cards_tmp, cfg, first_info)
        else
            M.check_hu(hand_cards_tmp, cfg, first_info)
        end
    end
end

function M.check_hu(cards, cfg, first_info)
    for i = cfg.min, cfg.max do
        local count = cards[i]

        if count == 1 or count == 4 then
            return false
        end

        if count == 2 then
            if first_info.eye_count > 0 then
                return false
            end

            first_info.eye_count = 1
        elseif count == 3 then
            first_info.peng_count = first_info.peng_count + 1
        end
    end
end

function M.check_hu_chi(info)
    local tbl = {}
    local eye_tbl = {}
    for i = cfg.min, cfg.max do
        repeat
            local count = cards[i]
            if count > 0 then
                table.insert(tbl, count)
                if count >= 2 then
                    eye_tbl[i] = true
                end
            else
                if #tbl == 0 then
                    break
                end

                if not M.check_sub(tbl, info) then
                    return false
                end
                tbl = {}
                eye_tbl = {}
            end
        until(true)
    end

    return true
end

function M.check_sub(tbl, info)
    local count = #tbl
    local yu = (count % 3)

    if yu == 1 then
        return false
    elseif yu == 2 then
        if info.eye_count > 0 then
            return false
        end
    end

    if has_eye and info.eye_count > 0 then
        return false
    end
end

local wave_tbl = {
    [3] = 3, [4] = 3,

    [31] = 30, [32] = 30, [33] = 33, [34] =  33, 

    [44] = 33,

    [111] = 111, [112] = 111, [113] = 111, [114] = 114,
    [122] = 111, [123] = 111, [124] = 111,
    [133] = 111, [134] = 111,
    [141] = 141, [142] = 141, [143] = 141, [144] = 144,

    [222] = 222, [223] = 222, [224] = 222,
    [233] = 222, [234] = 222,
    [244] = 222,

    [311] = 300, [312] = 300, [313] = 300, [314] = 300,
    [322] = 300, [323] = 300, [324] = 300,
    [331] = 330, [332] = 330, [333] = 333, [334] = 333,
    [341] = 330, [342] = 330, [343] = 330, [344] = 333,

    [411] = 411, [412] = 411, [413] = 411, [414] = 414,
    [422] = 411, [423] = 411, [424] = 411,
    [433] = 411, [434] = 411,
    [441] = 441, [442] = 441, [443] = 441, [444] = 444,
}

-- 检查是否匹配
function M.check_wave_old(tbl)
    repeat
       local num = tbl[1]
        if tbl[2] then
            num = num*10 + tbl[2]
            if tbl[3] then
                num = num*10 + tbl[3]
            end
        end

        local sub_value = wave_tbl[num]
        if not sub_value then
            return false
        end

        --print(sub_value)
        if sub_value > 99 then
            tbl[1] = tbl[1] - math.floor(sub_value/100)
            tbl[2] = tbl[2] - math.floor(sub_value/10)%10
            tbl[3] = tbl[3] - (sub_value%10)
        elseif sub_value > 9 then
            tbl[1] = tbl[1] - math.floor(sub_value/10)%10
            tbl[2] = tbl[2] - (sub_value%10)
        else
            tbl[1] = tbl[1] - sub_value
        end

        while(tbl[1] == 0) do
            table.remove(tbl, 1)
        end

        if not tbl[1] then
            return true
        end
    until(false)

    return false
end

function M.check_wave(tbl)
    if hu_table.check(tbl) then
        return true
    end

    return false
end

-- 检查是否匹配3*n + 2
function M.check_wave_and_eye(tbl)
    local len = #tbl
    if len == 1 then
        return true
    end

    -- 找出可能的所有将
    for i,v in ipairs(tbl) do
        repeat
            if v < 2 then
                break
            end

            local tmp_tbl_1 = {}
            for ii,vv in ipairs(tbl) do
                table.insert(tmp_tbl_1, vv)
            end

            if v > 2 then
                tmp_tbl_1[i] = v - 2
            else
                if i == 1 then
                    table.remove(tmp_tbl_1, 1)
                elseif i == len then
                    table.remove(tmp_tbl_1)
                else
                    for ii = i + 1, len do
                        table.insert(tmp_tbl_2, tbl[ii])
                    end
                    tmp_tbl_1[i] = nil
                end
            end

            if not M.check_wave(tmp_tbl_1) then
                break
            end

            if next(tmp_tbl_2) then
                if not M.check_wave(tmp_tbl_2) then
                    break
                end
            end

            return true
        until(true)
    end
end

function M.test()
    local t = M.create()
    M.shuffle(t)
end

return M
