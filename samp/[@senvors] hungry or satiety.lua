_COLOR = 0xFFFFFF00
_FLAGS = 0
_FONT = "Arial"
_FSIZE = 11


-- modify: ufdhbi

local inicfg = require 'inicfg'

local set = inicfg.load(nil, "hs")
if set == nil then
    ini = {settings = {x = 500, y = 400, mode = false}}
    inicfg.save(ini, "hs")
    set = inicfg.load(nil, "hs")
end

hun = 0
pos = false

register_chat_command = {
    ["pos"] = function()
        sampAddChatMessage("[hungry/satiety]{ffffff} Для сохранения положения нажмите {ffcece}ЛКМ.", RandomColor())
        showCursor(true, true)
        pos = true
    end,
    ["mode"] = function()
        set.settings.mode = not set.settings.mode
        sampAddChatMessage("[hungry/satiety]{ffffff} Режим расчета: {ffcece}"..(set.settings.mode and "Голод" or "Сытость")..".", RandomColor())
        inicfg.save(set, "hs")
    end
}

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    font = renderCreateFont(_FONT, _FSIZE, _FLAGS)
    server = decodeJson(jsonData())
    register_command(register_chat_command)
    while true do
    wait(0)
        if pos then
            local int_posX, int_posY = getCursorPos()
            set.settings.x,set.settings.y = int_posX, int_posY
            if isKeyDown(0x01) then
                showCursor(false, false)
                sampAddChatMessage("[hungry/satiety]{ffffff} Положение сохранено.", RandomColor())
                pos = false
                inicfg.save(set, "hs")
            end
        end
        if srv_inf ~= nil or pos then
            local param = (pos and 100 or (set.settings.mode and (100 - math.floor((hun / srv_inf.del) * 100)) or (math.floor((hun / srv_inf.del) * 100))))
            renderFontDrawText(font, tostring(param), set.settings.x, set.settings.y, _COLOR)
        end
    end
end


function onReceiveRpc(id,bs)
    if id == 134 then
        if server ~= nil then
            srv_inf = server[sampGetCurrentServerAddress()]
            if srv_inf ~= nil then
                local textdraw = read_bitstream(bs)
                if textdraw.x == srv_inf["1"][1] and textdraw.y == srv_inf["1"][2] and textdraw.color == srv_inf["1"][3] then
                    hun = textdraw.hun
                    --return false
                end
                for _, val in ipairs(srv_inf["2"]) do
                    if textdraw.x == val[1] and textdraw.y == val[2] and textdraw.color == val[3] then
                        --return false
                    end
                end
            end
        end
    end
end

function read_bitstream(bs)
    local data = {}
    data.id = raknetBitStreamReadInt16(bs)
    raknetBitStreamIgnoreBits(bs, (server[sampGetCurrentServerAddress()].read and 40 or 104))
    data.hun = raknetBitStreamReadFloat(bs) + server[sampGetCurrentServerAddress()].count
    raknetBitStreamIgnoreBits(bs, (server[sampGetCurrentServerAddress()].read and 96 or 32))
    data.color = raknetBitStreamReadInt32(bs)
    raknetBitStreamIgnoreBits(bs, 64)
    data.x = tonumber(string.format("%.2f",raknetBitStreamReadFloat(bs)))
    data.y = tonumber(string.format("%.2f",raknetBitStreamReadFloat(bs)))
    return data
end

function register_command(tbl)
    for key, val in pairs(tbl) do
        sampRegisterChatCommand("hs."..key, val)
    end
end

function RandomColor()
    math.randomseed(os.time())
    return string.format("0x%06X",join_argb(math.random(0, 255), math.random(0, 255), math.random(0, 255)))
end

function join_argb(r, g, b)
    local argb = b  -- b
    argb = bit.bor(argb, bit.lshift(g, 8))
    argb = bit.bor(argb, bit.lshift(r, 16))
    return argb
end

function jsonData()
    return '{"185.169.134.43":{"1":[549.5,60,-1436898180],"2":[[547.5,58,-16777216],[549.5,60,1622575210]],"read":false,"count":-549.5,"del":54.5},"185.169.134.4":{"1":[549.5,60,-1436898180],"2":[[547.5,58,-16777216],[549.5,60,1622575210]],"read":false,"count":-549.5,"del":54.5},"194.61.44.64":{"1":[631,48,-16703223],"2":[[630,46,-16777216],[631,48,-11695266]],"read":true,"count":0.5,"del":3},"194.61.44.61":{"1":[631,48,-16703223],"2":[[630,46,-16777216],[631,48,-11695266]],"read":true,"count":0.5,"del":3},"185.169.134.91":{"1":[550,38,-13447886],"2":[[550,38,-16751616],[547.29998779297,36.200000762939,-16777216]],"read":false,"count":-546,"del":58},"185.169.134.3":{"1":[549.5,60,-1436898180],"2":[[547.5,58,-16777216],[549.5,60,1622575210]],"read":false,"count":-549.5,"del":54.5},"185.169.134.107":{"1":[549.5,60,-1436898180],"2":[[547.5,58,-16777216],[549.5,60,1622575210]],"read":false,"count":-549.5,"del":54.5},"5.254.105.202":{"1":[631,48,-16703223],"2":[[630,46,-16777216],[631,48,-11695266]],"read":true,"count":0.5,"del":3},"185.169.134.44":{"1":[549.5,60,-1436898180],"2":[[547.5,58,-16777216],[549.5,60,1622575210]],"read":false,"count":-549.5,"del":54.5},"5.254.105.204":{"1":[631,48,-16703223],"2":[[630,46,-16777216],[631,48,-11695266]],"read":true,"count":0.5,"del":3},"185.169.134.85":{"1":[498,102,-2139062144],"2":[[547.5,58,-16777216],[549.5,60,1622575210]],"read":false,"count":0,"del":106},"185.169.134.59":{"1":[549.5,60,-1436898180],"2":[[547.5,58,-16777216],[549.5,60,1622575210]],"read":false,"count":-549.5,"del":54.5},"5.254.123.4":{"1":[631,48,-16703223],"2":[[630,46,-16777216],[631,48,-11695266]],"read":true,"count":0.5,"del":3},"185.169.134.68":{"1":[550,38,-13447886],"2":[[550,38,-16751616],[547.29998779297,36.200000762939,-16777216]],"read":false,"count":-546,"del":58},"185.169.134.109":{"1":[549.5,60,-1436898180],"2":[[547.5,58,-16777216],[549.5,60,1622575210]],"read":false,"count":-549.5,"del":54.5},"5.254.123.3":{"1":[631,48,-16703223],"2":[[630,46,-16777216],[631,48,-11695266]],"read":true,"count":0.5,"del":3},"5.254.123.6":{"1":[631,48,-16703223],"2":[[630,46,-16777216],[631,48,-11695266]],"read":true,"count":0.5,"del":3},"194.61.44.67":{"1":[631,48,-16703223],"2":[[630,46,-16777216],[631,48,-11695266]],"read":true,"count":0.5,"del":3},"185.169.134.61":{"1":[549.5,60,-1436898180],"2":[[547.5,58,-16777216],[549.5,60,1622575210]],"read":false,"count":-549.5,"del":54.5},"194.61.44.68":{"1":[631,48,-16703223],"2":[[630,46,-16777216],[631,48,-11695266]],"read":true,"count":0.5,"del":3},"185.169.134.45":{"1":[549.5,60,-1436898180],"2":[[547.5,58,-16777216],[549.5,60,1622575210]],"read":false,"count":-549.5,"del":54.5},"185.169.134.5":{"1":[549.5,60,-1436898180],"2":[[547.5,58,-16777216],[549.5,60,1622575210]],"read":false,"count":-549.5,"del":54.5},"185.169.134.67":{"1":[550,38,-13447886],"2":[[550,38,-16751616],[547.29998779297,36.200000762939,-16777216]],"read":false,"count":-546,"del":58}}'
end