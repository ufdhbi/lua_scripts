local sampEvents = require 'samp.events'
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
local u8 = encoding.UTF8
local vkeys = require 'vkeys'
local rkeys = require 'rkeys'
local inicfg = require 'inicfg'
imgui.HotKey = require('imgui_addons').HotKey

local saved, enable = false, false
local inHand = {false, false}
local key, timestamp = 0, 0

local settings = {
    keys = {
        key1 = {v = {vkeys.VK_F2}},
        key2 = {v = {vkeys.VK_F3}},
        open = {v = {vkeys.VK_MENU, vkeys.VK_1}}
    },
    slot = 4,
    health = 10,
    save = {true, true},
    sound = true,
    wait = 50
}

if not doesDirectoryExist("moonloader\\config") then
    createDirectory("moonloader\\config")
end

if not doesFileExist("moonloader/config/" .. thisScript().name .. ".json") then
    local f = io.open("moonloader/config/" .. thisScript().name .. ".json", "w")
    f:write(encodeJson(settings))
    f:close()
else
    local f = io.open("moonloader/config/" .. thisScript().name .. ".json", 'r')
    if f then 
        settings = decodeJson(f:read('*a'))
        if settings.sound == nil then settings.sound = true end
        if settings.wait == nil then settings.wait = 50 end
        if settings.mode ~= nil then settings.mode = nil end
        f:close()
    end
end

function main()
    while not isSampAvailable() do wait(0) end
    key1 = rkeys.registerHotKey(settings.keys.key1.v, true, function ()
        if os.clock() - timestamp > 0.5 then
            sampSendChat("/inv")
            work = true
            key = 1
            saved = false
            timestamp = os.clock()
        else
            sampAddChatMessage("[SaveGun] Не нажимай так часто", -1)
        end
    end)
    key2 = rkeys.registerHotKey(settings.keys.key2.v, true, function ()
        if os.clock() - timestamp > 0.5 then
            sampSendChat("/inv")
            work = true
            key = 2
            saved = false
            timestamp = os.clock()
        else
            sampAddChatMessage("[SaveGun] Не нажимай так часто", -1)
        end
    end)
    open = rkeys.registerHotKey(settings.keys.open.v, true, function ()
		imgui_window.bEnable.v = not imgui_window.bEnable.v
    end)
    while true do
        wait(0)
        imgui.Process = imgui_window.bEnable.v
    end
end

imgui_window = {
    bEnable = imgui.ImBool(false),
	property = imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoResize,
    style_dark = function()
        local style = imgui.GetStyle()
        local colors = style.Colors
        local clr = imgui.Col
        local ImVec4 = imgui.ImVec4
        colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
        colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 0.90)
        colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
        colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
        colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
        colors[clr.CheckMark] = ImVec4(0.86, 0.07, 0.23, 1.00)
    end,
	colorTitle = imgui.ImVec4(0.86, 0.07, 0.23, 1.00),
	size = imgui.ImVec2(670, 300)
}

imgui_window.style_dark()

local buffers = {
    save = {imgui.ImBool(settings.save[1]), imgui.ImBool(settings.save[2])},
    health = imgui.ImInt(settings.health),
    sound = imgui.ImBool(settings.sound),
    wait = imgui.ImInt(settings.wait),
}

function imgui.OnDrawFrame()
    if imgui_window.bEnable then
        local tLastKeys = {}
		local sw, sh = getScreenResolution()
		imgui.Begin('##' .. thisScript().name, imgui_window.bEnable, imgui_window.property)
        imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize("SaveGun+").x) / 2);
        imgui.TextColored(imgui_window.colorTitle, "SaveGun+");
        if imgui.HotKey("##active3", settings.keys.open, tLastKeys, 100) then
            rkeys.changeHotKey(open, settings.keys.open.v)
        end
        imgui.SameLine()
        imgui.Text(u8('Открытие меню'))
        imgui.Spacing()
        imgui.Spacing()
        if imgui.Checkbox(u8('Проигрывать звук'), buffers.sound) then
            settings.sound = buffers.sound.v
        end

        imgui.PushItemWidth(170)
        if imgui.SliderInt(u8('Задержка'), buffers.wait, 0, 1000) then
            settings.wait = buffers.wait.v
        end
        imgui.PopItemWidth()
        imgui.Spacing()
        imgui.Spacing()
        if imgui.HotKey("##active", settings.keys.key1, tLastKeys, 100) then
            rkeys.changeHotKey(key1, settings.keys.key1.v)
        end
        imgui.SameLine()
        imgui.Text(u8('Мелкий калибр'))
        if imgui.HotKey("##active2", settings.keys.key2, tLastKeys, 100) then
            rkeys.changeHotKey(key2, settings.keys.key2.v)
        end
        imgui.SameLine()
        imgui.Text(u8('Крупный калибр'))
        imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize("> EXCLUSIVE EDITION").x) / 2)
        imgui.TextColored(imgui_window.colorTitle, "> EXCLUSIVE EDITION")
        if imgui.IsItemClicked() then
            os.execute("start https://vk.com/savegun")
        end
		imgui.SetWindowPos('##' .. thisScript().name, imgui.ImVec2(sw/2 - imgui.GetWindowSize().x/2, sh/2 - imgui.GetWindowSize().y/2))
		imgui.SetWindowSize('##' .. thisScript().name, imgui.ImVec2(380, 187))
		imgui.End()
	end
end

function onWindowMessage(msg, wparam, lparam)
    if msg == 0x100 or msg == 0x101 then
        if (wparam == 0x1B and imgui_window.bEnable.v) and not isPauseMenuActive() then
            consumeWindowMessage(true, false)
            if msg == 0x101 then
                imgui_window.bEnable.v = false
            end
		end
    end
end

function onScriptTerminate(script, quitGame)
	if script == thisScript() then
        local f = io.open("moonloader/config/" .. thisScript().name .. ".json", "w")
        if f then
            f:write(encodeJson(settings))
            f:close()
        end
	end
end

function savegun(a, b)
    if a then
        lua_thread.create(function()
            if not inHand[1] then
                sampSendClickTextdraw(2103)
                wait(settings.wait)
                sampSendClickTextdraw(2146 + settings.slot)
            else
                sampSendClickTextdraw(2146 + settings.slot)
                wait(settings.wait)
                sampSendClickTextdraw(2103)
            end
        end)
    end
    if b then
        lua_thread.create(function()
            if not inHand[2] then
                sampSendClickTextdraw(2104)
                wait(settings.wait)
                sampSendClickTextdraw(2147 + settings.slot)
            else
                sampSendClickTextdraw(2147 + settings.slot)
                wait(settings.wait)
                sampSendClickTextdraw(2104)
            end
        end)
    end
    lua_thread.create(function() 
        wait(300)
        work = false
        sampSendClickTextdraw(65535)
    end)
    if settings.sound then playSound() end
end

function sampEvents.onShowTextDraw(id, data)
    if work then
        if id == 2146 + settings.slot then
            inHand[1] = data.modelId ~= 19464
        end
        if id == 2147 + settings.slot then
            inHand[2] = data.modelId ~= 19464
        end
        if not saved then savegun(key == 1, key == 2) end
        saved = true
        return false
    end
end

function sampEvents.onToggleSelectTextDraw()
    if work then return false end
end

function sampEvents.onSetCameraBehind()
    if work then return false end
end

function sampEvents.onInterpolateCamera()
    if work then return false end
end

function playSound()
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt32(bs, 1190)
    raknetBitStreamWriteFloat(bs, 0)
    raknetBitStreamWriteFloat(bs, 0)
    raknetBitStreamWriteFloat(bs, 0)
    raknetEmulRpcReceiveBitStream(16, bs)
end