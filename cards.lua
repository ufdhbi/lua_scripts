local events = require 'samp.events'
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local inicfg = require 'inicfg'

local settings = {
    position = {
        x = 0, 
        y = 0
    },
    size = {
        x = 0, 
        y = 0,
    },
    other = {
        render = false,
        imgSize = 25,
        fontSize = 16,
    }
}

settings = inicfg.load(settings)

local td = {}

local cards = {
    names = {
        ["1"] = "Т", 
        ["6"] = "6", 
        ["7"] = "7", 
        ["8"] = "8", 
        ["9"] = "9", 
        ["10"] = "10", 
        ["11"] = "В", 
        ["12"] = "Д", 
        ["13"] = "К"
    },
    suits = { 
        c = "Трефы", 
        d = "Бубны", 
        h = "Черви", 
        s = "Пики"
    },
    suits_image = {
        c = imgui.CreateTextureFromFile("moonloader/resource/trefa.png"), 
        d = imgui.CreateTextureFromFile("moonloader/resource/bubni.png"), 
        h = imgui.CreateTextureFromFile("moonloader/resource/heart.png"), 
        s = imgui.CreateTextureFromFile("moonloader/resource/piki.png")
    }
}

local Card = {}

function Card:startSession()

    local session = {
        pos = 0,
        data = {
            deck = {
                ["1c"] = true, ["1d"] = true, ["1h"] = true, ["1s"] = true,
                ["6c"] = true, ["6d"] = true, ["6h"] = true, ["6s"] = true,
                ["7c"] = true, ["7d"] = true, ["7h"] = true, ["7s"] = true,
                ["8c"] = true, ["8d"] = true, ["8h"] = true, ["8s"] = true,
                ["9c"] = true, ["9d"] = true, ["9h"] = true, ["9s"] = true,
                ["10c"] = true, ["10d"] = true, ["10h"] = true, ["10s"] = true,
                ["11c"] = true, ["11d"] = true, ["11h"] = true, ["11s"] = true,
                ["12c"] = true, ["12d"] = true, ["12h"] = true, ["12s"] = true,
                ["13c"] = true, ["13d"] = true, ["13h"] = true, ["13s"] = true,
            },
            myCards = {},
            opponentCards = {},
            bitCards = {},
            inBattleCards = {},
        }
    }

    local function controller(t, k, v)
        rawset(t, k, v)
        for k1, v1 in pairs(session.data) do
            for k2, v2 in pairs(v1) do
                if k2 == k and v1 ~= t then
                    session.data[k1][k2] = nil
                end
            end
        end
    end

    setmetatable(session, self)
    self.__index = self

    for k, v in pairs(session.data) do
        setmetatable(v, {__newindex = controller})
    end

    return session
end

function events.onShowTextDraw(id, data)
    td[id] = data
    if session ~= nil then
        if data.position.y < session.pos and data.text:find("ld_card:cd") then
            local card = data.text:gsub("ld_card:cd", "")
            session.data.inBattleCards[card] = true
        end
        if data.position.y == session.pos and data.text:find("ld_card:cd") then
            local card = data.text:gsub("ld_card:cd", "")
            session.data.myCards[card] = true
        end
    end
end

function events.onTextDrawHide(id)
    td[id] = nil
end

local text = "я лох xD"

print(text:gsub("xD", "*смёх*"))

function events.onServerMessage(clr, msg)
    if msg:find("^%[Игра%] %{ffffff%}Игра началась | Козырь:") then
        session = Card:startSession()
        local y = 0
        for _, data in pairs(td) do
            if data.text:find("ld_card") then
                local card = data.text:gsub("ld_card:cd", "")
                if data.position.y > y then y = data.position.y end
                session.data.myCards[card] = true
            end
        end
        session.pos = y
        buffers.cards.v = true
    end
    if session ~= nil then
        if msg:find(".+ вышел из игры или исключен за бездействие.") or msg:find("Игра закончена!") or msg:find("Вы проиграли.") or msg:find("Вам добавлен предмет \"Фишки для казино\"") then
            buffers.cards.v = false
            session = nil
        end
        if msg:find("^%[Игра%] %{ffffff%}.+ отбился%.") then
            for card, _ in pairs(session.data.inBattleCards) do
                session.data.bitCards[card] = true
            end
        end
        if msg:find("^%[Игра%] %{ffffff%}.+ затянул, ход переходит к .+%.") then
            local n = msg:match("^%[Игра%] %{ffffff%}(.+) затянул, ход переходит к .+%.")
            if nick ~= n then
                for card, _ in pairs(session.data.inBattleCards) do
                    session.data.opponentCards[card] = true
                end
            else
                for card, _ in pairs(session.data.myCards) do
                    session.data.bitCards[card] = true
                end
            end
        end
    end
end

function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(15, 15)
    style.WindowRounding = 5.0
    style.FramePadding = ImVec2(5, 5)
    style.FrameRounding = 4.0
    style.ItemSpacing = ImVec2(12, 8)
    style.ItemInnerSpacing = ImVec2(8, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 15.0
    style.ScrollbarRounding = 9.0
    style.GrabMinSize = 5.0
    style.GrabRounding = 3.0

    colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
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
end
apply_custom_style()

buffers = {
    cards = imgui.ImBool(false),
    set = false,
    settings = imgui.ImBool(false),
    renderCards = imgui.ImBool(settings.other.render),
    img = imgui.ImInt(settings.other.imgSize),
    font = imgui.ImInt(settings.other.fontSize)
}

local arial = nil
function imgui.BeforeDrawFrame()
    if arial == nil then
        local font_config = imgui.ImFontConfig()
        font_config.GlyphOffset.y = 2
        arial = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\arialbd.ttf', settings.other.fontSize, font_config, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
    end
end

function imgui.OnDrawFrame()
    if buffers.settings.v then
        imgui.Begin("Card Settings", buffers.settings)
        if imgui.Checkbox(u8("Показывать карты на экране"), buffers.renderCards) then
            settings.other.render = buffers.renderCards.v
        end
        imgui.PushItemWidth(100)
        if imgui.InputInt(u8("Размер иконки"),buffers.img) then
            settings.other.imgSize = buffers.img.v
        end
        if imgui.InputInt(u8("Размер шрифта"),buffers.font) then
            settings.other.fontSize = buffers.font.v
        end
        imgui.PopItemWidth()
        imgui.End()
    end
    if buffers.cards.v then
        if not buffers.set then
            imgui.SetNextWindowPos(imgui.ImVec2(settings.position.x, settings.position.y))
            imgui.SetNextWindowSize(imgui.ImVec2(settings.size.x, settings.size.y))
            buffers.set = true
        end
		imgui.Begin("Cards", buffers.cards, 1)
        imgui.Columns(2)
        imgui.SetColumnWidth(-1, 85)
        imgui.Text(u8("Не в игре"))
        imgui.NextColumn()
        for card, _ in pairs(session.data.deck) do
            local num, suit = card:match("(%d+)(.)")
            imgui.Image(cards.suits_image[suit], imgui.ImVec2(settings.other.imgSize, settings.other.imgSize))
            imgui.SameLine()
            imgui.PushFont(arial)
            imgui.Text(u8(cards.names[num]))
            imgui.PopFont()
            imgui.SameLine()
        end
        imgui.Separator()
        imgui.NextColumn()
        imgui.Text(u8("У оппонента"))
        imgui.NextColumn()
        for card, _ in pairs(session.data.opponentCards) do
            local num, suit = card:match("(%d+)(.)")
            imgui.Image(cards.suits_image[suit], imgui.ImVec2(settings.other.imgSize, settings.other.imgSize))
            imgui.SameLine()
            imgui.PushFont(arial)
            imgui.Text(u8(cards.names[num]))
            imgui.PopFont()
            imgui.SameLine()
        end
        imgui.Separator()
        imgui.NextColumn()
        imgui.Text(u8("Мои"))
        imgui.NextColumn()
        for card, _ in pairs(session.data.myCards) do
            local num, suit = card:match("(%d+)(.)")
            imgui.Image(cards.suits_image[suit], imgui.ImVec2(settings.other.imgSize, settings.other.imgSize))
            imgui.SameLine()
            imgui.PushFont(arial)
            imgui.Text(u8(cards.names[num]))
            imgui.PopFont()
            imgui.SameLine()
        end
        imgui.Separator()
        imgui.NextColumn()
        imgui.Text(u8("Бито"))
        imgui.NextColumn()
        for card, _ in pairs(session.data.bitCards) do
            local num, suit = card:match("(%d+)(.)")
            imgui.Image(cards.suits_image[suit], imgui.ImVec2(settings.other.imgSize, settings.other.imgSize))
            imgui.SameLine()
            imgui.PushFont(arial)
            imgui.Text(u8(cards.names[num]))
            imgui.PopFont()
            imgui.SameLine()
        end
        imgui.Separator()
        imgui.NextColumn()
        imgui.Text(u8("В бою"))
        imgui.NextColumn()
        for card, _ in pairs(session.data.inBattleCards) do
            local num, suit = card:match("(%d+)(.)")
            imgui.Image(cards.suits_image[suit], imgui.ImVec2(settings.other.imgSize, settings.other.imgSize))
            imgui.SameLine()
            imgui.PushFont(arial)
            imgui.Text(u8(cards.names[num]))
            imgui.PopFont()
            imgui.SameLine()
        end
        imgui.Separator()
        settings.position.x, settings.position.y = imgui.GetWindowPos().x, imgui.GetWindowPos().y
        settings.size.x, settings.size.y = imgui.GetWindowSize().x, imgui.GetWindowSize().y
		imgui.End()
    end
end

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    sampRegisterChatCommand("cardset", function() buffers.settings.v = not buffers.settings.v end)
    while true do
        wait(0)
        imgui.Process = buffers.cards.v or buffers.settings.v
    end
end

function onScriptTerminate(script, quitGame)
	if script == thisScript() then
        inicfg.save(settings)
	end
end


string allcards[36] = {
    "1c", "1d", "1h", "1s",
    "6c", "6d", "6h", "6s",
    "7c", "7d", "7h", "7s",
    "8c", "8d", "8h", "8s",
    "9c", "9d", "9h", "9s",
    "10c", "10d", "10h", "10s",
    "11c", "11d", "11h", "11s",
    "12c", "12d", "12h", "12s",
    "13c", "13d", "13h", "13s",
};

class card
{
public:
    string deck[36];
    string bit[36];
    string opp[36];
    string my[36];
    string battle[36];

    card() {
        memcpy(deck, allcards, sizeof(allcards));
    }

    void insertCard(string card, string array[36]) {
        for (int i = 0; sizeof(deck); i++) {
            if (card == deck[i] && deck != array) {
                deck[i] = "";
                array[i] = card;
                break;
            }
            if (card == bit[i] && bit != array) {
                bit[i] = "";
                array[i] = card;
                break;
            }
            if (card == my[i] && my != array) {
                my[i] = "";
                array[i] = card;
                break;
            }
            if (card == opp[i] && opp != array) {
                opp[i] = "";
                array[i] = card;
                break;
            }
            if (card == battle[i] && battle != array) {
                battle[i] = "";
                array[i] = card;
                break;
            }

        }
    }
};