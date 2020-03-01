local encoding = require 'encoding'
encoding.default = 'CP1251'
local function u8d(s) return encoding.UTF8:decode(s) end
local sampev = require 'samp.events'
local enable = false

function sampev.onShowDialog(id, style, title, b1, b2, text)
    if title:find(u8d("Статистика игрового аккаунта")) and enable then
        local fname = u8d("%s, %s, %s, %s, %s"):format(id, style, title, b1, b2)
        if not doesFileExist(fname) then
            local f = io.open(fname, 'w+')
            if f then
                f:write(text)
                f:close()
                sampAddChatMessage(u8d("Диалог со статистикой записан в файл %s"):format(fname), 0xFFFF00)
            end
        else
            local f = io.open(fname, 'r')
            local data = f:read("*all")
            f:close()
            return {id, style, title, b1, b2, data}
        end
        enable = false
    end
end


function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand("fpay", function(p)
        local nick, sum = p:match("(.+) (%d+)")
        if nick and sum then
            sampAddChatMessage(u8d("SMS из банка:{FFFFFF} Перевод {33aa33}%s ${ffffff} на счет %s успешно выполнен."):format(sum, nick), 0xFFFF00)
        end
    end)
    sampRegisterChatCommand("fstats", function() enable = true sampSendChat("/stats") end)
    wait(-1)
end
