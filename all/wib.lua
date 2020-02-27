local ffi = require('ffi')


ffi.cdef [[
    typedef int BOOL;
    typedef unsigned long HANDLE;
    typedef HANDLE HWND;
    HWND GetActiveWindow(void);
    BOOL IsIconic(HWND hWnd);
]]

_globals = {
    window = 0,
    nop = false,
    timestamp = 0
}

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    local memory = require "memory"
    memory.setuint8(7634870, 1)
    memory.setuint8(7635034, 1)
    memory.fill(7623723, 144, 8)
    memory.fill(5499528, 144, 6)
    _globals.window = ffi.C.GetActiveWindow()
    wait(-1)
end

function onSendRpc()

    if ffi.C.IsIconic(_globals.window) ~= 0 then
        if _globals.timestamp == 0 then
            _globals.timestamp = os.time()
        else
            if os.time() - _globals.timestamp >= 600 then
                
            end
        end
    end

    return ffi.C.IsIconic(_globals.window) == 0
end