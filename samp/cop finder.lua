script_name("Cop Finder")
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local events = require 'samp.events'
local memory = require 'memory'

local parse = false
local pid = -1
local inc = 1
local wanted_list = {}

function events.onServerMessage(c, m)
    if parse and pid ~= -1 and m == '[Ошибка] {FFFFFF}Игрок находится в каком-то здании' then
        --print("Игрок", pid, "в здании")
        pid = -1
        return false
    end
end

function events.onShowDialog(id, style, title, b1, b2, text)
    if parse and id == 0 then
        if #text > 0 then
            lua_thread.create(function()
                for k, v in ipairs(split(text, "\n")) do
                    if v:find("уровень розыска") then
                        n, i, w = v:match("(.+)%((%d+)%) %- (%d+)")
                        sampSendChat("/find " .. i)
                        --print("Работаю по игроку:", n, i, w)
                        pid = i
                        while pid ~= -1 do wait(0) end
                        --print("цикл пройден")
                    end
                end
                if inc == 6 then
                    --print("Сбор данных закончен")
                    imgui_window.bEnable.v = true
                    parse = false
                    inc = 1
                else
                    inc = inc + 1
                    --print("Продолжаю собирать данные", inc)
                    sampSendChat("/wanted " .. inc)
                end
            end)
        else
            if inc == 6 then
                --print("Сбор данных закончен")
                imgui_window.bEnable.v = true
                parse = false
                inc = 1
            else
                inc = inc + 1
                --print("Продолжаю собирать данные", inc)
                sampSendChat("/wanted " .. inc)
            end
        end
        sampSendDialogResponse(id, 2, 0, "")
        return false
    end
end

function events.onSetRaceCheckpoint(type, pos)
    if type == 1 and parse then
        local mx, my, mz = getCharCoordinates(playerPed)
        local dist = getDistanceBetweenCoords3d(mx, my, mz, pos.x, pos.y, pos.z)
        table.insert(wanted_list, {n:gsub("{.+}", ""), i, ("%.2f"):format(dist), w})
        --print("Получена позиция игрока:", n)
        pid = -1
        return false
    end
end

imgui_window = {
    bEnable = imgui.ImBool(false),
	property = imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove,
    style_dark = function()
        local style = imgui.GetStyle()
        local colors = style.Colors
        local clr = imgui.Col
        local ImVec4 = imgui.ImVec4
        colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
        colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
        colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 0.90)
        colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
        colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
        colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
        colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
        colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
        colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
        colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
        colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
        colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
        colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
        colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
        colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
        colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
        colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
        colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
        colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
        colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
        colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
        colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
        colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
        colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
        colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
        colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
        colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
        colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
        colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
        colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
        colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
        colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
        colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
        colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
        colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
        colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
        colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
        colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
        colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
        colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
    end,
	colorTitle = imgui.ImVec4(0.86, 0.07, 0.23, 1.00),
	size = imgui.ImVec2(670, 300)
}

imgui_window.style_dark()

function imgui.OnDrawFrame()
	if imgui_window.bEnable then
		local sw, sh = getScreenResolution()
		imgui.Begin('##' .. thisScript().name, imgui_window.bEnable, imgui_window.property)
        imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(thisScript().name).x) / 2);
        imgui.TextColored(imgui_window.colorTitle, thisScript().name);
        imgui.Spacing()
        imgui.Spacing()
        imgui.Columns(3, _, false)
        imgui.SetColumnWidth(-1, 180)
        imgui.Text("Nickname[id]")
        imgui.NextColumn()
        imgui.SetColumnWidth(-1, 70)
        imgui.Text("Distance")
        imgui.NextColumn()
        imgui.Text("Wanted")
        imgui.Separator()
        imgui.NextColumn()
        for k, v in ipairs(wanted_list) do
            imgui.Text(("%s[%s]"):format(v[1], v[2]))
            if imgui.IsItemClicked() then
                sampSendChat("/find " .. v[2])
                imgui_window.bEnable.v = false
                wanted_list = {}
            end
            imgui.NextColumn()
            imgui.Text(tostring(v[3]) .. ' m')
            imgui.NextColumn()
            for i = 1, v[4] do
                imgui.Image(star, imgui.ImVec2(15, 15))
                if i ~= v[4] then
                    imgui.SameLine()
                end
            end
            imgui.NextColumn()
        end
		imgui.SetWindowPos('##' .. thisScript().name, imgui.ImVec2(sw/2 - imgui.GetWindowSize().x/2, sh/2 - imgui.GetWindowSize().y/2))
		imgui.SetWindowSize('##' .. thisScript().name, imgui.ImVec2(400, -1))
		imgui.End()
	end
end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    star = imgui.CreateTextureFromMemory(memory.strptr(star_data), #star_data)
	sampRegisterChatCommand("xfind", function() sampSendChat("/wanted " .. inc) parse = true wanted_list = {} end)
    while true do
        wait(0)
        imgui.Process = imgui_window.bEnable.v
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

function split(str, delim, plain)
    local tokens, pos, plain = {}, 1, not (plain == false) --[[ delimiter is plain text by default ]]
    repeat
        local npos, epos = string.find(str, delim, pos, plain)
        table.insert(tokens, string.sub(str, pos, npos and npos - 1))
        pos = epos and epos + 1
    until not pos
    return tokens
end

star_data ="\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x0F\x00\x00\x00\x0F\x08\x06\x00\x00\x00\x3B\xD6\x95\x4A\x00\x00\x00\x06\x62\x4B\x47\x44\x00\xFF\x00\xFF\x00\xFF\xA0\xBD\xA7\x93\x00\x00\x01\x24\x49\x44\x41\x54\x28\x91\xB5\x92\xBD\x4A\x03\x41\x14\x85\xBF\xB3\x1A\x9B\x88\x8F\xA0\x08\xD9\xAC\x61\x2D\x02\x9A\xF8\x53\x5B\xC4\x47\xD1\x4A\xC1\x42\xD0\x4A\xB0\x11\xB4\x16\x5F\xC1\xC6\xCE\xCA\x56\xCC\x0F\x76\x92\x84\xA4\xF0\x19\x44\x53\x98\xEC\x5E\x8B\xA8\xEC\x26\xBB\xC1\x14\x9E\x66\x60\xCE\xFD\xE6\xCC\xBD\x33\xF0\x5F\xB2\x7A\x61\x67\x92\xEF\xA4\x82\xCF\x85\x25\xCC\xEE\xAC\xEA\x2D\x4F\x0D\x33\xB0\x13\x20\x8B\x74\x9C\x56\xA2\xC4\xD4\x86\xBF\x48\x18\x74\x80\x39\xA0\x4F\x40\x5E\x5B\xAD\xD7\x44\xD8\x9E\x72\x0B\x30\xEB\xE2\x28\x07\xA1\x0B\xDA\x05\xB6\x23\x75\x8F\x60\xF7\xE0\x74\x08\xAD\x0B\x83\x8E\x36\xBB\x6F\x32\x43\xD4\xBD\x2B\xD0\x41\x6A\x0B\x63\x91\xBA\x66\xBD\xB9\xEF\x48\x98\xCA\xED\x43\xA4\xF3\x3F\xA2\x97\x2A\x35\xF7\x24\xEC\x77\x60\x2A\x35\x4F\x81\xB3\xC9\x89\x76\xA1\x72\xEB\x28\xD6\x73\x54\x56\x5D\xE9\x20\x72\x63\xA0\xD1\xD5\x46\xCB\x8D\x9D\x15\xF3\x1B\x6B\x19\xC2\x8F\x77\x86\x53\x1E\x55\x9F\xEC\xCC\xBC\xFC\x97\xCF\x9F\x8D\xF8\x3B\x5B\xCF\x8B\x80\x03\xB0\x87\xE1\x0A\x40\x86\x5E\x98\x8F\x96\x8F\x7E\x92\x55\xC0\x90\x6E\x31\x7C\x95\xDB\x3B\x04\xB8\xC0\x0D\x10\x60\xF8\x09\x37\xFA\x0E\xAE\x79\x15\xAB\xF9\xC5\x64\xCF\x2F\x5A\xCD\xAB\xA4\xC2\xD3\xEA\x0B\x68\xEB\x5B\x21\x54\xC6\x6B\x88\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82"
