-- order https://vk.com/id384479896
local ffi = require 'ffi'

ffi.cdef [[
    typedef int BOOL;
    typedef unsigned long HANDLE;
    typedef HANDLE HWND;
    HWND GetActiveWindow(void);
    BOOL IsIconic(HWND hWnd);
]]

_vars = {
    window = 0,
    nop = false,
    timestamp = 0
}

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    patch_work()
    _vars.window = ffi.C.GetActiveWindow()
    while true do
        wait(0)
        if _vars.window ~= 0 then
            if ffi.C.IsIconic(_vars.window) == 1 then
                if _vars.timestamp == 0 then 
                    _vars.timestamp = os.time() 
                    _vars.nop = true 
                else
                    if os.time() - _vars.timestamp > 600 then
                        _vars.nop = false
                        wait(10000)
                        if ffi.C.IsIconic(_vars.window) ~= 1 then
                            _vars.timestamp = os.time()
                            _vars.nop = true
                        end
                    end
                end
            else
                _vars.nop = false
                _vars.timestamp = 0
            end
        end
    end
end

function onSendPacket() return not _vars.nop end

function patch_work()
    local memory = require "memory"
    memory.setuint8(7634870, 1)
    memory.setuint8(7635034, 1)
    memory.fill(7623723, 144, 8)
    memory.fill(5499528, 144, 6)
end