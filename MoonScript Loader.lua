script_name('Moonscript Loader')
script_authors('ufdhbi', 'FYP')

local moonscript = require 'moonscript'
local moonPath = 'moonloader\\moonscript\\'
local luaPath = 'moonloader\\moonscript\\moonc\\'

if not doesDirectoryExist(luaPath) then
    createDirectory(luaPath)
end

local ffi = require 'ffi'
ffi.cdef[[
	typedef void* HANDLE;
	typedef void* LPSECURITY_ATTRIBUTES;
	typedef unsigned long DWORD;
	typedef int BOOL;
	typedef const char *LPCSTR;
	typedef struct _FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
	} FILETIME, *PFILETIME, *LPFILETIME;

	BOOL __stdcall GetFileTime(HANDLE hFile, LPFILETIME lpCreationTime, LPFILETIME lpLastAccessTime, LPFILETIME lpLastWriteTime);
	HANDLE __stdcall CreateFileA(LPCSTR lpFileName, DWORD dwDesiredAccess, DWORD dwShareMode, LPSECURITY_ATTRIBUTES lpSecurityAttributes, DWORD dwCreationDisposition, DWORD dwFlagsAndAttributes, HANDLE hTemplateFile);
	BOOL __stdcall CloseHandle(HANDLE hObject);
]]

--- Config
autoreloadDelay    = 500 -- ms
---

local function get_file_modify_time(fpath)
	local handle = ffi.C.CreateFileA(fpath,
		0x80000000, -- GENERIC_READ
		0x00000001 + 0x00000002, -- FILE_SHARE_READ | FILE_SHARE_WRITE
		nil,
		3, -- OPEN_EXISTING
		0x00000080, -- FILE_ATTRIBUTE_NORMAL
		nil)
	local filetime = ffi.new('FILETIME[3]')
	if handle ~= -1 then
		local result = ffi.C.GetFileTime(handle, filetime, filetime + 1, filetime + 2)
		ffi.C.CloseHandle(handle)
		if result ~= 0 then
			return {tonumber(filetime[2].dwLowDateTime), tonumber(filetime[2].dwHighDateTime)}
		end
	end
	return nil
end

local function get_files(fpath, ext)
    local files = {}
    local handleFile, nameFile = findFirstFile(fpath .. ext)
    while nameFile do
        if handleFile then
            if not nameFile then
                findClose(handleFile)
            else
                local time = get_file_modify_time(moonPath .. nameFile)
                if time ~= nil then
                files[moonPath .. nameFile] = time
                end
                nameFile = findNextFile(handleFile)
            end
        end
    end
    return files
end

local function get_lua_code_from_moon(code, fpath)
    local code, err = moonscript.to_lua(code)
    if code ~= nil then
        return code
    else
        print(fpath, err)
        return nil
    end       
end

local function read_file(fpath)
    local file = io.open(fpath)
    if file ~= nil then
        local content = file:read('*a')
        file:close()
        if content ~= nil then
            return content
        else
            print('Failed to read', fpath)
            return nil
        end
    else
        print('Could not open', fpath)
        return nil
    end
end

local function unload_moonc()
    for k, v in pairs(script.list()) do
        if v.path:find(luaPath) then
            v:unload()
        end
    end
end

local function compile_moon(fpath)
    local content = read_file(fpath)
    if content ~= nil then
        local code = get_lua_code_from_moon(content, fpath)
        if code ~= nil then
            local fpath = fpath:gsub(moonPath, luaPath):gsub('%.moon', '%.lua')
            local f = io.open(fpath, 'w+')
            if f ~= nil then
                f:write(code)
                f:close()
                for k, v in pairs(script.list()) do
                    if v.path:find(fpath) then
                        v:unload()
                        print('Reloading "' .. v.name:gsub('%.lua', '%.moon') .. '"...')
                        script.load(fpath)
                        return
                    end
                end
                print('Loading "' .. fpath:gsub(luaPath, moonPath):gsub('%.lua', '%.moon') .. '"...')
                script.load(fpath)
                return
            end
        end
    end
end

function main()
    load_moon()
    while true do
        wait(autoreloadDelay)
        for fpath, saved_time in pairs(moonFiles) do
            local file_time = get_file_modify_time(fpath)
            if file_time ~= nil and (file_time[1] ~= saved_time[1] or file_time[2] ~= saved_time[2]) then
                compile_moon(fpath)
                moonFiles[fpath] = file_time -- update time
            end
        end
    end
end

function load_moon(fpath)
    moonFiles = get_files(moonPath, '*.moon')
    unload_moonc()
    for fpath, _ in pairs(moonFiles) do
        compile_moon(fpath)
    end
end