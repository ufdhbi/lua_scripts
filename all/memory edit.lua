local ffi = require 'ffi'

local a = true

local settings = {
    main = {
        x = 100,
        y = 300
    }
}

local hook = {hooks = {}}
addEventHandler('onScriptTerminate', function(scr)
    if scr == script.this then
        for i, hook in ipairs(hook.hooks) do
            if hook.status then
                hook.stop()
            end
        end
    end
end)
ffi.cdef [[
    int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);
]]
function hook.new(cast, callback, hook_addr, size)
    local size = size or 5
    local new_hook = {}
    local detour_addr = tonumber(ffi.cast('intptr_t', ffi.cast('void*', ffi.cast(cast, callback))))
    local void_addr = ffi.cast('void*', hook_addr)
    local old_prot = ffi.new('unsigned long[1]')
    local org_bytes = ffi.new('uint8_t[?]', size)
    ffi.copy(org_bytes, void_addr, size)
    local hook_bytes = ffi.new('uint8_t[?]', size, 0x90)
    hook_bytes[0] = 0xE9
    ffi.cast('uint32_t*', hook_bytes + 1)[0] = detour_addr - hook_addr - 5
    new_hook.call = ffi.cast(cast, hook_addr)
    new_hook.status = false
    local function set_status(bool)
        new_hook.status = bool
        ffi.C.VirtualProtect(void_addr, size, 0x40, old_prot)
        ffi.copy(void_addr, bool and hook_bytes or org_bytes, size)
        ffi.C.VirtualProtect(void_addr, size, old_prot[0], old_prot)
    end
    new_hook.stop = function() set_status(false) end
    new_hook.start = function() set_status(true) end
    new_hook.start()
    table.insert(hook.hooks, new_hook)
    return setmetatable(new_hook, {
        __call = function(self, ...)
            self.stop()
            local res = self.call(...)
            self.start()
            return res
        end
    })
end

function arm(a, x, y)
    --if a then sampAddChatMessage(("x: %s | y: %s"):format(x, y), -100) a = false end
    armhook(a, settings.main.x, settings.main.y)
end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    armhook = hook.new("void (__cdecl *) (int, signed int, signed int)", arm, 0x005890A0)
    sampRegisterChatCommand('changearm',function(arg)
        local x, y = arg:match("(%d+) (%d+)")
        if x and y then
            settings.main.x, settings.main.y = tonumber(x), tonumber(y)
        end
    end)
    wait(-1)
end

function onScriptTerminate(script, quitGame)
	if script == thisScript() then
        inicfg.save(settings)
	end
end