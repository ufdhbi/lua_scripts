local encoding = require 'encoding'
encoding.default = 'CP1251'
local function u8d(s) return encoding.UTF8:decode(s) end


function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampAddChatMessage(u8d"Тест кодировки", -100)
    while true do
        wait(0)
        
    end
end
