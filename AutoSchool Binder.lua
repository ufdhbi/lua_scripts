script_name("AutoSchool")
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local events = require 'samp.events'

local playerData = {}

function playerData:new(id)

    local data = {
        id = id,
        nickname = sampGetPlayerNickname(id),
        lvl = sampGetPlayerScore(id)
    }

    setmetatable(data, self)
    self.__index = self

    return data
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

local licensesRP = {
    car = {
        "������������, � ��������� ��������� NICK � � ���� ��������� �������.",
        "���������� ��� �������.",
        "/n /pass ID.",
        "/me ������ ����� � ������� �� ������� ������",
        "/me ������ ��� � �������� �������������, ����� ���� ������� ����� �������",
        "�������� �� ���� ��� ����� ������������ ����� ��������.",
        "/f ����� ��������� ������� � �������� || ���������: �������� ���������",
        "�������������� �� ����� �������� � �������� ���� ���������� ��������.",
        "��� ������ ����������� ������ ������������.",
        "/n /me ���������� ������ ������������",
        "/me ���������� ������ ������������",
        "�������� ���������, ��������� ���� � ���������� � ����� \"�����\".",
        "/n ������� ��������� ����� ����� �� ������� [Ctrl], �������� ���� [Alt].",
        "� ������ ���������� �� ������������� �����������.",
        "���������� �������� ������� �� �������� � ���������� ������ �������.",
        "������ ��������� ������ � ������������ ������� ������.",
        "������� �� �������� ������ ������� � ������� ��������.",
        "����������� � ��������, ����� ���� ��������� �������� �� ���.",
        "������ ������� ���������� ����, ������ ��� ����� � ������ ���������.",
        "/me ��������� ����, ����� ���� ������ ������",
        "/me ����� ��������� ������",
        "/me ������ ��� � �������� �������",
        "/me ������ ������ ����� ������������ �������������, ����� ���� ������� �������",
        "/me ����� ���������� ����������, ��������� ������ ��",
        "/me ������ ����",
        "/f �������� ������� � �������� || ���������: �������� ��������� || ���������: �������."
    },
    heli = {
        "������������, � ��������� ��������� NICK � � ���� ��������� �������.",
        "���������� ��� ������� � ���. �����.",
        "/n /pass ID /med ID",
        "��������� ���������� �������� ���������� 3.000$. ��������.",
        "/n /pay ID 3000",
        "/me ������ ����� � ������� �� ������� ����",
        "/me ������ ��� � �������� �������������, ����� ���� ������� ���",
        "�������� �� ���� ��� ����� ������������ ����� ��������.",
        "/f ����� ��������� ������� � �������� || ���������: ��������� ���������",
        "�������� �� ����� ������, ����� ���� ����� ���� ��������.",
        "��� ������ �������� ��������, ����������� ������ ������������.",
        "/n /me ����� ��������, ����� ���� ���������� ������ ������������",
        "/me ����� ��������, ����� ���� ���������� ������ ������������",
        "������ �������� ��������� � ��������, ������ ���� �� ���������� ���������.",
        "����� ����, ��� �������� ���� - ������������� � �� �����, ������ ����� �������.",
        "/me ��������� ����, ����� ���� ������ ������",
        "/me ����� ��������� ������",
        "/me ������ ��� � �������� �������",
        "/me ������ ������ ����� �������� ������, ����� ���� ������� �������",
        "/me ����� ���������� ����������, ��������� ������ ��",
        "/me ������ ����",
        "/f �������� ������� � �������� || ���������: ��������� ��������� || ���������: �������.",
    },
    gun = {
        "������������, ���� ����� NICK, � �������� ��������.",
        "����� �������� ������� ����������? �� ������ ��������� ��� �� ������?",
        "��������� �������� �� ������ ��������� - 10.000$, � �� ������ - 30.000$.",
        "������, ���������� ��� ��� ������� � ���. �����.",
        "/do � ����� ���� ��������� �������� � ����������.",
        "/me ������ ����, ����� ���� ������� �� ���� ������ ��������",
        "/me ���� � ���� �����, ����� ���� �������� ��������",
        "/todo ��� ���� ��������*����� ���� ������� �������� �������� ��������",
    },
    ins = {
        "������������, � ��������� ����� NICK. �� ����� ���� ������-�� ������������ ���� ���������?",
        "������, ������������ ��� ��� �������, ���. ����� � ���.",
        "/do ���� � �������� � �����������, �������� � ���������� � ������ ����.",
        "/me ������ ����, ������ ���������, ����� ���� ����� ��������� ��",
        "/me ���� �������� ������ \"AutoSchool-Insurance\", ���� � ��������",
        "/me ������� ��������� �������� ��������",
    },
    inv = {
        "������� ������� �����, � ��������� ��������� - NICK. �� �� �������������?",
        "������, �������������, ������� ��� ��� � ����� �� ������ �����������?",
        "�������. ������������ ��� ���� ���������, � ������ �������, �������� � ���.�����.",
        "/n [/pass ID] [/med ID] [/lic ID]",
        "������, ������ � ����� ��� ��������� ��������.",
        "�� ����� ��������?",
        "��� � ���� ��� �������?",
        "��� ����� Skype?",
        "��� �� ������ \"��\"?",
        "���� ����� ����� ������������ ��� ���������� � IC ���, �� ��������� ��� �� ������� \"����.�������������.\".",
        "������, ��� �����..",
        "/n /sms [��� ����� ��������] MG RP (� ������ �� ���������� ������� ��������� �������� �� ������� \"����.�������������.\".)",
        "�������.. �� �������� �� ���������� � ���������.",
        "/f ������� �IDP ���������� � ������� �� ����������.",
        "��������� � ��������� ��� ���.���������, ��� ������� �����.",
    }
}

local data = {
    ["�������� �� �������� ���������"] = "car",
    ["�������� �� ��������� ���������"] = "heli",
    ["�������� �� ������/������ ���������"] = "gun",
    ["���������"] = "ins",
    ["�������������"] = "inv"
}

exam = {false, "", 1}

imgui_window.style_dark()

function imgui.OnDrawFrame()
	if imgui_window.bEnable then
		local sw, sh = getScreenResolution()
		imgui.Begin('##' .. thisScript().name, imgui_window.bEnable, imgui_window.property)
        imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(thisScript().name).x) / 2);
        imgui.TextColored(imgui_window.colorTitle, thisScript().name);
        imgui.Spacing()
        imgui.Spacing()
        imgui.cText(("%s[%s] | Lvl: %s"):format(target.nickname, target.id, target.lvl))
        imgui.Spacing()
        imgui.Separator()
        imgui.Spacing()
        for k, v in pairs(data) do
            if imgui.Button(u8(k), imgui.ImVec2(-1, 23)) then
                exam = {true, v, 1}
                sampAddChatMessage("[ASH Binder] ������� {00FF00}Y{FFFFFF} ��� ������ ��������", -1)
                sampAddChatMessage("[ASH Binder] ���� �� ����, ������� {00FF00}N{FFFFFF}", -1)
                imgui_window.bEnable.v = false
            end
        end
		imgui.SetWindowPos('##' .. thisScript().name, imgui.ImVec2(sw/2 - imgui.GetWindowSize().x/2, sh/2 - imgui.GetWindowSize().y/2))
		imgui.SetWindowSize('##' .. thisScript().name, imgui.ImVec2(400, -1))
		imgui.End()
	end
end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    while true do
        wait(0)
        imgui.Process = imgui_window.bEnable.v
        local result, ped = getCharPlayerIsTargeting()
        if result and isKeyJustPressed(0xA0) then
            local _, id = sampGetPlayerIdByCharHandle(ped)
            if target == nil then target = playerData:new(id) end
            imgui_window.bEnable.v = true
        end
        if exam[1] and not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(0x59) then
            sampSendChat(licensesRP[exam[2]][exam[3]]:gsub("NICK", sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(playerPed)))):gsub("ID", select(2, sampGetPlayerIdByCharHandle(playerPed))):gsub("IDP", target.id):gsub("_", " "))
            if #licensesRP[exam[2]] > exam[3] + 1 then
                sampAddChatMessage("[ASH Binder] ��������� ������ �����: " .. licensesRP[exam[2]][exam[3] + 1], 0xFFFF00)
                exam[3] = exam[3] + 1
            else
                print(#licensesRP[exam[2]], exam[3] + 1)
                sampAddChatMessage("[ASH Binder] ������� �����������", 0xFFFF00)
                exam = {false, "", 1}
                target = nil
            end
        end
        if exam[1] and not sampIsChatInputActive() and not sampIsDialogActive() and isKeyJustPressed(0x4E) then
            if exam[2] ~= "inv" then
                sampSendChat("�� ��������� ������� ����� ������, ������������� �� ���������.")
                wait(1000)
                sampSendChat("/f �������� ������� � �������� || ���������: �� ������.")
            else
                sampSendChat("��������, �� �� ��� �� ���������, �� �������: \"����. �������������\"")
            end
            exam = {false, "", 1}
            target = nil
        end
    end
end

function onWindowMessage(msg, wparam, lparam)
    if msg == 0x100 or msg == 0x101 then
        if (wparam == 0x1B and imgui_window.bEnable.v) and not isPauseMenuActive() then
            consumeWindowMessage(true, false)
            if msg == 0x101 then
                imgui_window.bEnable.v = false
                target = nil
            end
		end
    end
end

function imgui.cText(str)
    imgui.SetCursorPosX((imgui.GetWindowWidth() - imgui.CalcTextSize(str).x) / 2);
    imgui.Text(str);
end