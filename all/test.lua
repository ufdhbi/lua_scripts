local sampev = require "samp.events"
local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampAddChatMessage(u8:decode("Тест кодировки"), -100)
    while true do
        wait(0)
        
    end
end
