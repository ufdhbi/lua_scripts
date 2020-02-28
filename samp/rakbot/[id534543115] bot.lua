local encoding = require 'encoding'
encoding.default = 'CP1251'
local function u8d(s) return encoding.UTF8:decode(s) end

local botInfo = {
    spawn = "",
    timestamp = 0,
    routes_count = {SF = 2, LS = 2}, -- тут не забудь изменить количество маршрутов которые добавишь в таблицу routes
    last_route = ""
}
local spawns = {
    ["LS"] = {"1154.07", "-1770.19", "16.59"},
    ["SF"] = {"-1968.47", "115.13", "27.69"}
}

local routes = {
    ["LS"] = {
        ["num1"] = "bum1",
        ["num2"] = "bum2"
    },
    ["SF"] = {
        ["num1"] = "bum1",
        ["num2"] = "bum2"
    }
}

function onPrintLog(str)
    if u8d(str):find(u8d("Сохраненный маршрут: остановлен")) then
        botInfo.timestamp = os.time()
    end
end

function onSpawned(x, y, z)
    for k, v in pairs(spawns) do
        local tx, ty, tz = tostring(x):format("%.2f"), tostring(y):format("%.2f") tostring(z):format("%.2f")
        if v[1] == tx and v[2] == ty and v[3] == tz then
            printLog("Bot spawned in " .. k)
            botInfo.spawn = k
            math.randomseed(os.time())
            local x = math.random(0, botInfo.routes_count[k])
            local i = 1
            for k, v in pairs(routes[k]) do
                if i == x then
                    runCommand("!route " .. k)
                end
                i = i + 1
            end
        end
    end
end

function onSendRpc(id, data, size)
    if os.time() - botInfo.timestamp >= 1200 and botInfo.timestamp ~= 0 then
        for k, v in pairs(routes[botInfo.spawn]) do
            if k == botInfo.last_route then
                runCommand("!route " .. v)
                botInfo.timestamp = 0
                break
            end
            if v == botInfo.last_route then
                runCommand("!route " .. v)
                botInfo.timestamp = 0
                break
            end
        end
    end
end
