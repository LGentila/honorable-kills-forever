-- Honorable Kills Forever
-- Shows honorable kills: the character's total, today, yesterday, and an
-- account-wide total summed over every character that has logged in with
-- the add-on. They appear on a panel on the PvP window and, if the player
-- wants, on a counter that stays on the screen. The options panel sets
-- which lines each one shows. Each character's kills are also saved per
-- day. Texts follow the client language: French on frFR clients, English
-- everywhere else.

local ADDON_NAME = ...

---------------------------------------------------------------------------
-- Localization
---------------------------------------------------------------------------
local L = {
    TITLE          = "Honorable Kills",
    TOTAL          = "Total",
    TODAY          = "Today",
    YESTERDAY      = "Yesterday",
    ACCOUNT        = "Account",
    THIS_WEEK      = "This week",
    LAST_WEEK      = "Last week",
    CHARACTERS     = "Characters on this account",
    ACCOUNT_NOTE   = "Only characters logged in with the add-on are counted.",
    HINT_MOVE      = "Shift + drag to move",
    HINT_DRAG      = "Drag to move",
    HINT_OPTIONS   = "Right-click: options",
    THOUSANDS      = ",",
    COLON          = ": ",
    -- Options panel
    OPTIONS_DESC   = "Choose what the add-on shows, and where. Changes apply right away.",
    SCREEN_HEADER  = "On-screen counter",
    SCREEN_SHOW    = "Show the counter on the screen",
    PVP_HEADER     = "PvP window",
    PVP_SHOW       = "Show the panel on the PvP window",
    PVP_NOTE       = "To move the panel, Shift + drag it on the PvP window.",
    LINES          = "Lines:",
    LOCK           = "Lock position",
    LOCK_TIP       = "Uncheck to move the counter with the mouse. It locks again when you close the options.",
    RESET_POSITION = "Reset position",
    CHARACTERS_TIP = "Deleted a character? Remove it here so that it no longer counts in the account total.",
    REMOVE         = "Remove",
    CONFIRM        = "Confirm?",
    CURRENT        = "(this character)",
    NO_CHARACTERS  = "No character saved yet.",
    -- Chat messages
    SHOWN_ON       = "Shown on: %s",
    NOT_FOUND      = "PvP window not detected yet. Open it once, or use /hk attach <FrameName>.",
    RESET_DONE     = "Positions reset.",
    OPTIONS_COMBAT = "The options can't be opened during combat.",
    ATTACH_OK      = "The panel will be shown on %s.",
    ATTACH_ERR     = "No frame named \"%s\". Hover the window and type /fstack to find its name.",
    ATTACH_ARG     = "Give a frame name, for example: /hk attach PVPRankFrame",
    AUTO_DONE      = "Automatic PvP window detection re-enabled.",
    FORGET_ARG     = "Give a character name, for example: /hk forget Name",
    FORGET_OK      = "%s removed from the account total.",
    FORGET_ERR     = "No saved character named \"%s\".",
    FORGET_CURRENT = "%s is the character you are playing: it can only be removed from another character.",
    TEST_ON        = "Test mode: showing %s honorable kills (not saved). Type /hk test to stop.",
    TEST_OFF       = "Test mode off.",
    TEST_ERR       = "Usage: /hk test <number>, or /hk test to stop.",
    HELP = {
        "/hk: print your honorable kills in chat",
        "/hk options: open the options",
        "/hk reset: put the panel and the counter back in their default positions",
        "/hk attach <FrameName>: show the panel on another frame",
        "/hk auto: go back to automatic detection",
        "/hk forget <Name>: remove a character from the account total",
    },
}

if GetLocale() == "frFR" then
    local fr = {
        TITLE          = "Victoires honorables",
        TOTAL          = "Total",
        TODAY          = "Aujourd'hui",
        YESTERDAY      = "Hier",
        ACCOUNT        = "Compte",
        THIS_WEEK      = "Cette semaine",
        LAST_WEEK      = "Semaine dernière",
        CHARACTERS     = "Personnages du compte",
        ACCOUNT_NOTE   = "Seuls les personnages connectés avec l'add-on sont comptés.",
        HINT_MOVE      = "Maj + glisser pour déplacer",
        HINT_DRAG      = "Glissez pour déplacer",
        HINT_OPTIONS   = "Clic droit : options",
        THOUSANDS      = " ",
        COLON          = " : ",
        OPTIONS_DESC   = "Choisissez ce que l'add-on affiche, et où. Les changements s'appliquent tout de suite.",
        SCREEN_HEADER  = "Compteur à l'écran",
        SCREEN_SHOW    = "Afficher le compteur à l'écran",
        PVP_HEADER     = "Fenêtre JcJ",
        PVP_SHOW       = "Afficher le panneau sur la fenêtre JcJ",
        PVP_NOTE       = "Pour déplacer le panneau : Maj + glisser sur la fenêtre JcJ.",
        LINES          = "Lignes :",
        LOCK           = "Verrouiller la position",
        LOCK_TIP       = "Décochez pour déplacer le compteur avec la souris. Il se reverrouille quand vous fermez les options.",
        RESET_POSITION = "Réinitialiser la position",
        CHARACTERS_TIP = "Vous avez supprimé un personnage ? Retirez-le ici pour qu'il ne compte plus dans le total du compte.",
        REMOVE         = "Retirer",
        CONFIRM        = "Confirmer ?",
        CURRENT        = "(ce personnage)",
        NO_CHARACTERS  = "Aucun personnage enregistré pour l'instant.",
        SHOWN_ON       = "Affiché sur : %s",
        NOT_FOUND      = "Fenêtre JcJ pas encore détectée. Ouvrez-la une fois, ou utilisez /hk attach <NomDuCadre>.",
        RESET_DONE     = "Positions réinitialisées.",
        OPTIONS_COMBAT = "Les options ne peuvent pas s'ouvrir pendant un combat.",
        ATTACH_OK      = "Le panneau sera affiché sur %s.",
        ATTACH_ERR     = "Aucun cadre nommé « %s ». Survolez la fenêtre et tapez /fstack pour trouver son nom.",
        ATTACH_ARG     = "Indiquez un nom de cadre, par exemple : /hk attach PVPRankFrame",
        AUTO_DONE      = "Détection automatique de la fenêtre JcJ réactivée.",
        FORGET_ARG     = "Indiquez un nom de personnage, par exemple : /hk forget Nom",
        FORGET_OK      = "%s retiré du total du compte.",
        FORGET_ERR     = "Aucun personnage enregistré nommé « %s ».",
        FORGET_CURRENT = "%s est le personnage connecté : il ne peut être retiré que depuis un autre personnage.",
        TEST_ON        = "Mode test : affichage de %s victoires honorables (non enregistré). Tapez /hk test pour arrêter.",
        TEST_OFF       = "Mode test désactivé.",
        TEST_ERR       = "Utilisation : /hk test <nombre>, ou /hk test pour arrêter.",
        HELP = {
            "/hk : affiche vos victoires honorables dans la discussion",
            "/hk options : ouvre les options",
            "/hk reset : remet le panneau et le compteur à leur position par défaut",
            "/hk attach <NomDuCadre> : affiche le panneau sur un autre cadre",
            "/hk auto : revient à la détection automatique",
            "/hk forget <Nom> : retire un personnage du total du compte",
        },
    }
    for key, text in pairs(fr) do
        L[key] = text
    end
end

---------------------------------------------------------------------------
-- Settings
---------------------------------------------------------------------------
-- Known PvP windows, highest priority first:
--   PVPRankFrame : WoW Forever (PvP tab of the character window)
--   PVPUIFrame   : modern UI (PvP tab of the group finder)
--   PVPFrame     : The Burning Crusade to Cataclysm UI
--   HonorFrame   : Honor tab of the character window (classic UI)
local CANDIDATES = { "PVPRankFrame", "PVPUIFrame", "PVPFrame", "HonorFrame" }

local DEFAULT_X, DEFAULT_Y = 8, 8   -- PvP panel: from the window's bottom-left corner, inwards
local COUNTER_X, COUNTER_Y = 24, -60 -- counter: on the left edge, a little below the middle

local PADDING     = 8
local ICON_SIZE   = 18
local ROW_HEIGHT  = 16
local COLUMN_GAP  = 16
local MIN_WIDTH   = 150
local MAX_TOOLTIP_CHARACTERS = 15
local SECONDS_PER_DAY = 86400

-- Lines a display can show, top to bottom. "gap" adds space above a line
-- when another one is shown before it.
local ROWS = {
    { key = "lifetime",  label = L.TOTAL,     always = true },
    { key = "today",     label = L.TODAY },
    { key = "yesterday", label = L.YESTERDAY },
    { key = "account",   label = L.ACCOUNT,   always = true, gap = 4 },
}

-- Display settings, the same for every character of the account. Missing
-- values take these defaults, so settings added later need no migration.
-- The PvP panel shows everything, as before version 2.1.0, and the counter
-- is off: nothing changes for players who update.
local DEFAULTS = {
    pvp = {
        shown = true,
        rows = { lifetime = true, today = true, yesterday = true, account = true },
    },
    screen = {
        shown = false,
        rows = { lifetime = true, today = true, yesterday = true, account = false },
    },
}

local db
local loggedIn = false
local characterKey, characterInfo
local currentParent, currentParentName
local hookedFrames = {}
local pendingUpdate = false
local updating = false
local screenUnlocked = false
local testKills -- debug: simulated total set by /hk test, never saved

-- Defined with the options panel, used before it.
local OpenOptions, RefreshOptions

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------
local function Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cffffd100" .. L.TITLE .. "|r" .. L.COLON .. msg)
end

-- "Secret" values from the modern API cannot be compared or formatted
-- during combat.
local function IsSecret(value)
    return issecretvalue ~= nil and issecretvalue(value) and true or false
end

-- True when the value exists and can be read. Checked in this order because
-- a secret value cannot even be compared to nil.
local function IsUsable(value)
    return not IsSecret(value) and value ~= nil
end

-- The value as a number, or nil when it is hidden, missing or not a number.
local function ReadNumber(value)
    if IsUsable(value) then
        return tonumber(value)
    end
    return nil
end

local function SafeCall(fn, ...)
    if type(fn) ~= "function" then
        return nil
    end
    local ok, a, b = pcall(fn, ...)
    if ok then
        return a, b
    end
    return nil
end

local function SetShown(region, shown)
    if shown then
        region:Show()
    else
        region:Hide()
    end
end

local function SetEnabled(widget, enabled)
    if enabled then
        widget:Enable()
    else
        widget:Disable()
    end
end

local function SetColor(texture, r, g, b, a)
    if texture.SetColorTexture then
        texture:SetColorTexture(r, g, b, a)
    else
        texture:SetTexture(r, g, b, a)
    end
end

local function FormatNumber(n)
    if not IsUsable(n) then
        return "?"
    end
    n = tonumber(n)
    if not n then
        return "?"
    end
    n = math.floor(n)
    if BreakUpLargeNumbers then
        local ok, s = pcall(BreakUpLargeNumbers, n)
        if ok and type(s) == "string" then
            return s
        end
    end
    local s = tostring(n)
    local sign, digits = s:match("^(%-?)(%d+)$")
    if not digits then
        return s
    end
    digits = digits:reverse():gsub("(%d%d%d)", "%1" .. L.THOUSANDS):reverse()
    if digits:sub(1, #L.THOUSANDS) == L.THOUSANDS then
        digits = digits:sub(#L.THOUSANDS + 1)
    end
    return sign .. digits
end

local function GetFrameByName(name)
    local f = name and _G[name]
    if type(f) == "table" and type(f.IsObjectType) == "function" and f:IsObjectType("Frame") then
        return f
    end
    return nil
end

local function GetClassColor(class)
    local color = class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
    if color then
        return color.r, color.g, color.b
    end
    return 1, 1, 1
end

-- Fills in the missing values of a settings table from its defaults.
local function ApplyDefaults(target, defaults)
    for key, value in pairs(defaults) do
        if type(value) == "table" then
            if type(target[key]) ~= "table" then
                target[key] = {}
            end
            ApplyDefaults(target[key], value)
        elseif target[key] == nil then
            target[key] = value
        end
    end
end

local function InitDB()
    if db then
        return
    end
    HonorableKillsForeverDB = HonorableKillsForeverDB or {}
    db = HonorableKillsForeverDB
    db.positions = db.positions or {}
    db.characters = db.characters or {}
    ApplyDefaults(db, DEFAULTS)
end

---------------------------------------------------------------------------
-- Account-wide total
---------------------------------------------------------------------------
-- Characters are saved under "Name-Realm". WoW Forever has no realms:
-- since its 2026-11-20 hotfix, GetRealmName() returns "" there. Its
-- characters have a first name and a surname instead, and UnitName()
-- returns the surname where other clients return the realm. A full name
-- is unique in a region, so Forever characters are saved under
-- "Name Surname".
local function MakeKey(info)
    if info.surname then
        return info.name .. " " .. info.surname
    elseif info.realm ~= "" then
        return info.name .. "-" .. info.realm
    end
    return info.name
end

-- True when a saved entry is the current character under an older key:
-- saved with the realm WoW Forever returned before the hotfix, or without
-- the surname (up to version 2.0.1). What is missing on either side is not
-- compared.
local function IsCurrentCharacter(entry)
    local info = characterInfo
    if entry.name ~= info.name then
        return false
    end
    if entry.class and info.class and entry.class ~= info.class then
        return false
    end
    if entry.surname and info.surname then
        return entry.surname == info.surname
    end
    if entry.surname or info.surname then
        return true -- WoW Forever: the realm means nothing there
    end
    local realm = entry.realm or ""
    return realm == "" or info.realm == "" or realm == info.realm
end

local function StoreCharacter(kills)
    local entry = db.characters[characterKey] or {}
    entry.name, entry.surname = characterInfo.name, characterInfo.surname
    entry.realm, entry.class = characterInfo.realm, characterInfo.class
    entry.kills = kills
    db.characters[characterKey] = entry
    return entry
end

-- Adds the days of an older entry, keeping the highest count of each day.
local function MergeDays(into, days)
    if type(days) ~= "table" then
        return into
    end
    into = into or {}
    for day, count in pairs(days) do
        count = tonumber(count)
        if count and count > (tonumber(into[day]) or 0) then
            into[day] = count
        end
    end
    return into
end

-- Merges the current character's older entries into its entry, keeping the
-- highest count: a lifetime count never goes down.
local function MergeOldEntries()
    local current = db.characters[characterKey]
    local kills = current and tonumber(current.kills)
    local days = current and current.days
    local merged = false
    for key, entry in pairs(db.characters) do
        if key ~= characterKey and IsCurrentCharacter(entry) then
            local count = tonumber(entry.kills)
            if count and (not kills or count > kills) then
                kills = count
            end
            days = MergeDays(days, entry.days)
            db.characters[key] = nil -- clearing fields is allowed during pairs()
            merged = true
        end
    end
    if merged then
        StoreCharacter(kills).days = days
    end
end

local function InitCharacter()
    if not UnitName then
        return
    end
    local name, surname = UnitName("player")
    -- Hidden or not loaded yet: SaveCharacter() tries again later.
    if IsSecret(name) or IsSecret(surname) or not name or name == ""
        or name == UNKNOWNOBJECT then
        return
    end
    if surname == "" then
        surname = nil
    end
    local realm = GetRealmName and GetRealmName()
    if not IsUsable(realm) then
        realm = ""
    end
    local _, class = UnitClass("player")
    if not IsUsable(class) then
        class = nil
    end
    characterInfo = { name = name, surname = surname, realm = realm, class = class }
    characterKey = MakeKey(characterInfo)
    if db then
        MergeOldEntries()
    end
end

-- Saves the current character's lifetime kills. A 0 never overwrites a
-- saved positive count, in case the server data is not loaded yet.
local function SaveCharacter(lifetime)
    if not characterKey and loggedIn then
        InitCharacter() -- the name could not be read at login
    end
    if not (db and characterKey and IsUsable(lifetime)) then
        return
    end
    lifetime = tonumber(lifetime)
    if not lifetime then
        return
    end
    local entry = db.characters[characterKey]
    if entry and lifetime == 0 and (entry.kills or 0) > 0 then
        return
    end
    StoreCharacter(lifetime)
end

-- Sum of every saved character, optionally leaving one out.
local function GetAccountTotal(excludedKey)
    if not db then
        return nil
    end
    local total = 0
    for key, entry in pairs(db.characters) do
        if key ~= excludedKey then
            total = total + (tonumber(entry.kills) or 0)
        end
    end
    return total
end

local function GetSortedCharacters()
    local list = {}
    for key, entry in pairs(db.characters) do
        table.insert(list, { key = key, entry = entry })
    end
    table.sort(list, function(a, b)
        local ka, kb = a.entry.kills or 0, b.entry.kills or 0
        if ka ~= kb then
            return ka > kb
        end
        return a.key < b.key
    end)
    return list
end

local function CountFirstNames(characters)
    local firstNames = {}
    for _, item in ipairs(characters) do
        local name = item.entry.name or item.key
        firstNames[name] = (firstNames[name] or 0) + 1
    end
    return firstNames
end

-- Characters are shown by first name. The surname is added when "full" is
-- set or when several share a first name, and the realm, on clients that
-- still have realms, for characters of another realm.
local function GetCharacterName(item, firstNames, full)
    local entry = item.entry
    local name = entry.name or item.key
    if entry.surname and (full or firstNames[name] > 1) then
        name = name .. " " .. entry.surname
    end
    local info = characterInfo
    if info and not info.surname and info.realm ~= ""
        and entry.realm and entry.realm ~= "" and entry.realm ~= info.realm then
        name = name .. "-" .. entry.realm
    end
    return name
end

-- Removes a character from the account total, with its daily history.
local function ForgetCharacter(key)
    db.characters[key] = nil
end

---------------------------------------------------------------------------
-- Kills per day
---------------------------------------------------------------------------
-- Each character's kills are saved per day in its entry, as
-- days["2026-11-24"] = 37, only for days with at least one kill. A day
-- follows the game's "Today" count, which is assumed to restart at the
-- server's daily reset: it runs from one reset to the next, so a session
-- that goes past midnight stays on the same day. It is named after the date,
-- in server time, that holds its middle: a day that starts at 4am on the
-- 24th is the 24th.

-- Seconds until the next daily reset, or nil when the client doesn't say.
local function GetSecondsUntilReset()
    local seconds
    if C_DateAndTime and C_DateAndTime.GetSecondsUntilDailyReset then
        seconds = ReadNumber(SafeCall(C_DateAndTime.GetSecondsUntilDailyReset))
    end
    if not seconds and GetQuestResetTime then
        seconds = ReadNumber(SafeCall(GetQuestResetTime))
    end
    if seconds and seconds > 0 and seconds <= SECONDS_PER_DAY then
        return seconds
    end
    return nil
end

-- Name of the day "daysAgo" days before the current one.
local function GetDayKey(daysAgo)
    local year, month, day, secondsToday
    -- Server date and time, as in the calendar.
    local now = C_DateAndTime and C_DateAndTime.GetCurrentCalendarTime
        and SafeCall(C_DateAndTime.GetCurrentCalendarTime)
    if not IsSecret(now) and type(now) == "table" then
        year, month, day = ReadNumber(now.year), ReadNumber(now.month), ReadNumber(now.monthDay)
        local hour, minute = ReadNumber(now.hour), ReadNumber(now.minute)
        if hour and minute then
            secondsToday = hour * 3600 + minute * 60
        end
    end
    if not (year and month and day and secondsToday) then
        -- Computer date and time instead.
        local t = date("*t")
        year, month, day = t.year, t.month, t.day
        secondsToday = t.hour * 3600 + t.min * 60 + t.sec
    end
    -- How many days the middle of the current server day is from today: -1
    -- between midnight and a reset in the early morning, for example.
    local shift = 0
    local untilReset = GetSecondsUntilReset()
    if untilReset then
        shift = math.floor((secondsToday + untilReset - SECONDS_PER_DAY / 2) / SECONDS_PER_DAY)
    end
    -- At noon, daylight saving time changes, made at night, cannot shift the date.
    return date("%Y-%m-%d", time({
        year = year, month = month, day = day + shift - (daysAgo or 0), hour = 12,
    }))
end

-- A day's count only goes up: the highest value seen is kept.
local function SaveDay(entry, key, count)
    count = ReadNumber(count)
    if count and count > 0 and count > (tonumber(entry.days[key]) or 0) then
        entry.days[key] = count
    end
end

-- Saves today's count, and yesterday's: it completes the previous day when
-- it was played without the add-on, or when the game closed before saving.
local function SaveDays(today, yesterday)
    local entry = db and characterKey and db.characters[characterKey]
    if not entry then
        return
    end
    if type(entry.days) ~= "table" then
        entry.days = {}
    end
    SaveDay(entry, GetDayKey(0), today)
    SaveDay(entry, GetDayKey(1), yesterday)
end

---------------------------------------------------------------------------
-- Stats
---------------------------------------------------------------------------
local STATISTIC_TOTAL_HK = 588 -- "Honorable kills" in the statistics panel

-- Reads the character's stats, saves its total for the account count and
-- its counts per day, and adds the account total.
local function CollectStats()
    local s = {}
    -- Only the first value is used: the second one is the highest PvP rank
    -- reached, not a count of dishonorable kills.
    s.lifetime = SafeCall(GetPVPLifetimeStats)
    if not IsSecret(s.lifetime) and s.lifetime == nil and GetStatistic then
        local v = SafeCall(GetStatistic, STATISTIC_TOTAL_HK)
        if IsUsable(v) then
            s.lifetime = tonumber(v)
        end
    end
    s.today     = SafeCall(GetPVPSessionStats)
    s.yesterday = SafeCall(GetPVPYesterdayStats)
    s.thisWeek  = SafeCall(GetPVPThisWeekStats)
    s.lastWeek  = SafeCall(GetPVPLastWeekStats)
    SaveCharacter(s.lifetime)
    SaveDays(s.today, s.yesterday)
    s.account = GetAccountTotal()
    if testKills and not IsSecret(s.lifetime) then
        -- Display only: the real count stays saved for the account total.
        s.lifetime = testKills
        s.account = (GetAccountTotal(characterKey) or 0) + testKills
    end
    return s
end

---------------------------------------------------------------------------
-- Displays
---------------------------------------------------------------------------
-- The panel on the PvP window and the counter on the screen are built the
-- same way. Each one shows the lines checked for it in the options.
local displays = {}

local function CreateDisplay(name, settingsKey)
    local f = CreateFrame("Frame", name, UIParent,
        BackdropTemplateMixin and "BackdropTemplate" or nil)
    f.settingsKey = settingsKey
    f:SetSize(MIN_WIDTH, 100)
    f:Hide()
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetClampedToScreen(true)

    if f.SetBackdrop then
        f:SetBackdrop({
            bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 12,
            insets = { left = 3, right = 3, top = 3, bottom = 3 },
        })
        f:SetBackdropColor(0, 0, 0, 0.8)
        f:SetBackdropBorderColor(1, 0.82, 0, 0.9)
    end

    f.icon = f:CreateTexture(nil, "ARTWORK")
    f.icon:SetSize(ICON_SIZE, ICON_SIZE)
    f.icon:SetPoint("TOPLEFT", f, "TOPLEFT", PADDING, -PADDING)

    f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.title:SetPoint("LEFT", f.icon, "RIGHT", 4, 0)
    f.title:SetText(L.TITLE)

    f.lines = {}
    for i, row in ipairs(ROWS) do
        local label = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        label:SetTextColor(0.8, 0.8, 0.8)
        label:SetText(row.label)
        local value = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        value:SetJustifyH("RIGHT")
        value:SetText("?")
        f.lines[i] = { label = label, value = value }
    end

    table.insert(displays, f)
    return f
end

local pvpPanel = CreateDisplay("HonorableKillsForeverPanel", "pvp")
local counter = CreateDisplay("HonorableKillsForeverCounter", "screen")

-- Shown while the counter can be moved.
counter.highlight = counter:CreateTexture(nil, "BACKGROUND", nil, 7)
counter.highlight:SetPoint("TOPLEFT", counter, "TOPLEFT", 3, -3)
counter.highlight:SetPoint("BOTTOMRIGHT", counter, "BOTTOMRIGHT", -3, 3)
SetColor(counter.highlight, 0.2, 0.8, 0.2, 0.3)
counter.highlight:Hide()

counter.dragHint = counter:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
counter.dragHint:SetPoint("TOP", counter, "BOTTOM", 0, -2)
counter.dragHint:SetText(L.HINT_DRAG)
counter.dragHint:Hide()

local function UpdateIcons()
    local faction = UnitFactionGroup and UnitFactionGroup("player")
    local texture = "Interface\\TargetingFrame\\UI-PVP-FFA"
    if IsUsable(faction) and (faction == "Alliance" or faction == "Horde") then
        texture = "Interface\\TargetingFrame\\UI-PVP-" .. faction
    end
    for _, f in ipairs(displays) do
        f.icon:SetTexture(texture)
        f.icon:SetTexCoord(0, 0.65625, 0, 0.65625)
    end
end

-- Fills the lines and resizes the display to fit. Lines that are unchecked,
-- or whose stat this client does not give, are hidden. Returns how many
-- lines are shown.
local function Layout(f, stats)
    local checked = db[f.settingsKey].rows
    local y = -(PADDING + ICON_SIZE + 4)
    local labelWidth, valueWidth, shown = 0, 0, 0
    for i, row in ipairs(ROWS) do
        local line = f.lines[i]
        local value = stats[row.key]
        if checked[row.key] and (row.always or IsUsable(value)) then
            if shown > 0 then
                y = y - (row.gap or 0)
            end
            line.value:SetText(FormatNumber(value))
            line.label:ClearAllPoints()
            line.label:SetPoint("TOPLEFT", f, "TOPLEFT", PADDING + 2, y)
            line.value:ClearAllPoints()
            line.value:SetPoint("TOPRIGHT", f, "TOPRIGHT", -(PADDING + 2), y)
            line.label:Show()
            line.value:Show()
            labelWidth = math.max(labelWidth, line.label:GetStringWidth())
            valueWidth = math.max(valueWidth, line.value:GetStringWidth())
            y = y - ROW_HEIGHT
            shown = shown + 1
        else
            line.label:Hide()
            line.value:Hide()
        end
    end
    local contentWidth = math.max(
        MIN_WIDTH - 2 * PADDING,
        ICON_SIZE + 4 + f.title:GetStringWidth(),
        labelWidth + COLUMN_GAP + valueWidth + 4)
    f:SetSize(math.ceil(contentWidth + 2 * PADDING), math.ceil(-y + PADDING - 2))
    return shown
end

-- True when the display is turned on in the options and, for the PvP panel,
-- attached to the PvP window.
local function IsWanted(f)
    if not (db and db[f.settingsKey].shown) then
        return false
    end
    return f ~= pvpPanel or currentParent ~= nil
end

local function DoUpdate()
    local stats = CollectStats()
    for _, row in ipairs(ROWS) do
        if IsSecret(stats[row.key]) then
            -- In combat: keep the last values and retry afterwards.
            pendingUpdate = true
            return
        end
    end
    for _, f in ipairs(displays) do
        SetShown(f, IsWanted(f) and Layout(f, stats) > 0)
    end
end

-- Showing a display runs Update() again from its OnShow script: the guard
-- skips that nested call, as the outer one already does the work.
local function Update()
    if updating then
        return
    end
    updating = true
    xpcall(DoUpdate, geterrorhandler())
    updating = false
end

-- The server may update the counts slightly after the kill message.
local function UpdateSoon()
    if C_Timer and C_Timer.After then
        C_Timer.After(1, Update)
    else
        Update()
    end
end

local function AddTooltipStat(label, value)
    if IsUsable(value) then
        GameTooltip:AddDoubleLine(label, FormatNumber(value), 1, 0.82, 0, 1, 1, 1)
    end
end

-- The counter's tooltip opens towards the middle of the screen.
local function GetTooltipAnchor(f)
    if f == counter then
        local x = f:GetCenter()
        local width = UIParent:GetWidth()
        if x and width and x > width / 2 then
            return "ANCHOR_LEFT"
        end
    end
    return "ANCHOR_RIGHT"
end

local function ShowTooltip(f)
    GameTooltip:SetOwner(f, GetTooltipAnchor(f))
    if f == counter and screenUnlocked then
        GameTooltip:SetText(L.HINT_DRAG, 1, 1, 1)
        GameTooltip:Show()
        return
    end
    local s = CollectStats()
    GameTooltip:AddDoubleLine(L.CHARACTERS, FormatNumber(s.account), 1, 1, 1, 1, 1, 1)
    local characters = GetSortedCharacters()
    local firstNames = CountFirstNames(characters)
    for i, item in ipairs(characters) do
        if i > MAX_TOOLTIP_CHARACTERS then
            break
        end
        local r, g, b = GetClassColor(item.entry.class)
        GameTooltip:AddDoubleLine(GetCharacterName(item, firstNames),
            FormatNumber(item.entry.kills), r, g, b, 1, 1, 1)
    end
    GameTooltip:AddLine(L.ACCOUNT_NOTE, 0.6, 0.6, 0.6, true)
    -- Extra stats, only on clients that provide them.
    if IsUsable(s.thisWeek) or IsUsable(s.lastWeek) then
        GameTooltip:AddLine(" ")
        AddTooltipStat(L.THIS_WEEK, s.thisWeek)
        AddTooltipStat(L.LAST_WEEK, s.lastWeek)
    end
    GameTooltip:AddLine(" ")
    if f == pvpPanel then
        GameTooltip:AddLine(L.HINT_MOVE, 0.6, 0.6, 0.6)
    end
    GameTooltip:AddLine(L.HINT_OPTIONS, 0.6, 0.6, 0.6)
    GameTooltip:Show()
end

for _, f in ipairs(displays) do
    f:SetScript("OnShow", Update)
    f:SetScript("OnEnter", ShowTooltip)
    f:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    f:SetScript("OnMouseUp", function(_, button)
        if button == "RightButton" then
            OpenOptions()
        end
    end)
end

---------------------------------------------------------------------------
-- PvP panel: position and attachment to the PvP window
---------------------------------------------------------------------------
local function ApplyPvPPosition()
    if not currentParent then
        return
    end
    local pos = db.positions[currentParentName]
    pvpPanel:ClearAllPoints()
    pvpPanel:SetPoint("BOTTOMLEFT", currentParent, "BOTTOMLEFT",
        pos and pos.x or DEFAULT_X, pos and pos.y or DEFAULT_Y)
end

pvpPanel:SetScript("OnDragStart", function(self)
    if IsShiftKeyDown() and currentParent then
        self.isMoving = true
        GameTooltip:Hide()
        self:StartMoving()
    end
end)

pvpPanel:SetScript("OnDragStop", function(self)
    if not self.isMoving then
        return
    end
    self.isMoving = false
    self:StopMovingOrSizing()
    if self.SetUserPlaced then
        self:SetUserPlaced(false)
    end
    local left, bottom = self:GetLeft(), self:GetBottom()
    local parentLeft, parentBottom = currentParent:GetLeft(), currentParent:GetBottom()
    if left and bottom and parentLeft and parentBottom then
        db.positions[currentParentName] = {
            x = math.floor(left - parentLeft + 0.5),
            y = math.floor(bottom - parentBottom + 0.5),
        }
    end
    ApplyPvPPosition()
end)

local function FindTarget()
    if db.forcedFrame then
        return GetFrameByName(db.forcedFrame), db.forcedFrame
    end
    for _, name in ipairs(CANDIDATES) do
        local f = GetFrameByName(name)
        if f then
            return f, name
        end
    end
    return nil
end

local function Attach()
    if not db then
        return
    end
    local target, name = FindTarget()
    if not target or target == currentParent then
        return
    end
    currentParent, currentParentName = target, name
    pvpPanel:SetParent(target)
    pvpPanel:SetFrameStrata(target:GetFrameStrata())
    pvpPanel:SetFrameLevel(math.min(target:GetFrameLevel() + 50, 9000))
    ApplyPvPPosition()
    if not hookedFrames[target] then
        hookedFrames[target] = true
        target:HookScript("OnShow", Update)
    end
    Update()
end

local function Detach()
    currentParent, currentParentName = nil, nil
    pvpPanel:Hide()
    pvpPanel:SetParent(UIParent)
end

-- The preferred window may only be created the first time its tab is shown:
-- until the panel is attached to it, check again every second (negligible cost).
local watcher

local function IsOnPreferredFrame()
    return currentParentName ~= nil and currentParentName == (db.forcedFrame or CANDIDATES[1])
end

local function WatchForTarget()
    Attach()
    if watcher or IsOnPreferredFrame() or not (C_Timer and C_Timer.NewTicker) then
        return
    end
    watcher = C_Timer.NewTicker(1, function()
        Attach()
        if IsOnPreferredFrame() then
            watcher:Cancel()
            watcher = nil
        end
    end)
end

---------------------------------------------------------------------------
-- Screen counter: position and lock
---------------------------------------------------------------------------
-- Its top-left corner is saved relative to the top-left corner of the
-- screen, so that added lines make it grow downwards.
local function ApplyScreenPosition()
    counter:ClearAllPoints()
    local x, y = db.screen.x, db.screen.y
    if x and y then
        counter:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x, y)
    else
        counter:SetPoint("LEFT", UIParent, "LEFT", COUNTER_X, COUNTER_Y)
    end
end

local function StopScreenDrag()
    if not counter.isMoving then
        return
    end
    counter.isMoving = false
    counter:StopMovingOrSizing()
    if counter.SetUserPlaced then
        counter:SetUserPlaced(false)
    end
    local left, top = counter:GetLeft(), counter:GetTop()
    local parentLeft, parentTop = UIParent:GetLeft(), UIParent:GetTop()
    if left and top and parentLeft and parentTop then
        db.screen.x = math.floor(left - parentLeft + 0.5)
        db.screen.y = math.floor(top - parentTop + 0.5)
    end
    ApplyScreenPosition()
end

-- Unlocked, the counter is dragged without Shift and goes above every
-- window, the options included, so that it can be placed anywhere. Locked,
-- it cannot be moved, and open windows cover it.
local function SetScreenUnlocked(unlocked)
    screenUnlocked = unlocked and true or false
    if not screenUnlocked then
        StopScreenDrag()
    end
    counter:SetFrameStrata(screenUnlocked and "FULLSCREEN_DIALOG" or "LOW")
    SetShown(counter.highlight, screenUnlocked)
    SetShown(counter.dragHint, screenUnlocked)
    if counter.SetBackdropBorderColor then
        if screenUnlocked then
            counter:SetBackdropBorderColor(0.3, 1, 0.3, 1)
        else
            counter:SetBackdropBorderColor(1, 0.82, 0, 0.9)
        end
    end
end

counter:SetScript("OnDragStart", function(self)
    if screenUnlocked then
        self.isMoving = true
        GameTooltip:Hide()
        self:StartMoving()
    end
end)

counter:SetScript("OnDragStop", StopScreenDrag)

---------------------------------------------------------------------------
-- Options panel
---------------------------------------------------------------------------
-- In the game's options, AddOns tab. Every change applies right away.
local OPTIONS_WIDTH   = 600
local INDENT          = 44 -- settings that depend on the box above them
local LIST_SIZE       = 8  -- characters shown at once
local LIST_ROW_HEIGHT = 22
local LIST_WIDTH      = 450

local options = CreateFrame("Frame", "HonorableKillsForeverOptions", UIParent)
options:SetSize(OPTIONS_WIDTH, 540)
options:Hide()
options.name = L.TITLE -- the panel's name in the classic options window
local category -- the panel's category in the modern options window

local function PlayCheckSound(checked)
    if PlaySound and SOUNDKIT then
        SafeCall(PlaySound, checked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
            or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    end
end

local function ShowWidgetTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(self.tooltipTitle, 1, 1, 1)
    GameTooltip:AddLine(self.tooltipText, nil, nil, nil, true)
    GameTooltip:Show()
end

local function HideTooltip()
    GameTooltip:Hide()
end

local function CreateCheckbox(text, tooltip, onClick)
    local check = CreateFrame("CheckButton", nil, options, "UICheckButtonTemplate")
    check:SetSize(26, 26)
    -- The template's own label differs between game versions: use ours.
    local templateText = check.Text or check.text
    if templateText then
        templateText:SetText("")
        templateText:Hide()
    end
    check.label = check:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    check.label:SetPoint("LEFT", check, "RIGHT", 2, 1)
    check.label:SetText(text)
    -- Clicking the label ticks the box too.
    check:SetHitRectInsets(0, -(check.label:GetStringWidth() + 4), 0, 0)
    check:SetScript("OnClick", function(self)
        local checked = self:GetChecked() and true or false
        PlayCheckSound(checked)
        onClick(checked)
    end)
    if tooltip then
        check.tooltipTitle, check.tooltipText = text, tooltip
        check:SetScript("OnEnter", ShowWidgetTooltip)
        check:SetScript("OnLeave", HideTooltip)
    end
    return check
end

local function SetCheckEnabled(check, enabled)
    SetEnabled(check, enabled)
    local shade = enabled and 1 or 0.5
    check.label:SetTextColor(shade, shade, shade)
end

local function CreateHeader(text, y)
    local header = options:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    header:SetPoint("TOPLEFT", options, "TOPLEFT", 16, y)
    header:SetText(text)
    local rule = options:CreateTexture(nil, "ARTWORK")
    rule:SetSize(math.max(1, OPTIONS_WIDTH - 40 - header:GetStringWidth()), 1)
    rule:SetPoint("LEFT", header, "RIGHT", 8, 0)
    SetColor(rule, 1, 0.82, 0, 0.25)
end

-- One box per line of a display, side by side.
local function CreateLineChecks(settingsKey, y)
    local label = options:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    label:SetPoint("TOPLEFT", options, "TOPLEFT", INDENT, y - 7)
    label:SetText(L.LINES)
    local checks, previous = {}, nil
    for _, row in ipairs(ROWS) do
        local check = CreateCheckbox(row.label, nil, function(checked)
            db[settingsKey].rows[row.key] = checked
            Update()
        end)
        if previous then
            check:SetPoint("LEFT", previous.label, "RIGHT", 12, -1)
        else
            check:SetPoint("LEFT", label, "RIGHT", 6, 0)
        end
        check.key = row.key
        table.insert(checks, check)
        previous = check
    end
    return label, checks
end

local title = options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", options, "TOPLEFT", 16, -16)
title:SetText(L.TITLE)

local version = SafeCall(C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata,
    ADDON_NAME, "Version")
if type(version) == "string" and version ~= "" then
    local versionText = options:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    versionText:SetPoint("BOTTOMLEFT", title, "BOTTOMRIGHT", 8, 1)
    versionText:SetText(version)
end

local description = options:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
description:SetPoint("TOPLEFT", options, "TOPLEFT", 16, -42)
description:SetWidth(OPTIONS_WIDTH - 32)
description:SetJustifyH("LEFT")
description:SetText(L.OPTIONS_DESC)

-- On-screen counter
CreateHeader(L.SCREEN_HEADER, -74)

local screenShow = CreateCheckbox(L.SCREEN_SHOW, nil, function(checked)
    db.screen.shown = checked
    -- The first time, the counter is unlocked right away so that it can be placed.
    SetScreenUnlocked(checked and not (db.screen.x and db.screen.y))
    Update()
    RefreshOptions()
end)
screenShow:SetPoint("TOPLEFT", options, "TOPLEFT", 12, -92)

local screenLinesLabel, screenLines = CreateLineChecks("screen", -120)

local lockCheck = CreateCheckbox(L.LOCK, L.LOCK_TIP, function(checked)
    SetScreenUnlocked(not checked)
end)
lockCheck:SetPoint("TOPLEFT", options, "TOPLEFT", INDENT - 4, -148)

local resetButton = CreateFrame("Button", nil, options, "UIPanelButtonTemplate")
resetButton:SetText(L.RESET_POSITION)
local resetText = resetButton:GetFontString()
resetButton:SetSize(math.max(120, (resetText and resetText:GetStringWidth() or 0) + 24), 22)
resetButton:SetPoint("LEFT", lockCheck.label, "RIGHT", 16, 0)
resetButton:SetScript("OnClick", function()
    db.screen.x, db.screen.y = nil, nil
    ApplyScreenPosition()
end)

-- PvP window
CreateHeader(L.PVP_HEADER, -192)

local pvpShow = CreateCheckbox(L.PVP_SHOW, nil, function(checked)
    db.pvp.shown = checked
    Update()
    RefreshOptions()
end)
pvpShow:SetPoint("TOPLEFT", options, "TOPLEFT", 12, -210)

local pvpLinesLabel, pvpLines = CreateLineChecks("pvp", -238)

local pvpNote = options:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
pvpNote:SetPoint("TOPLEFT", options, "TOPLEFT", INDENT, -270)
pvpNote:SetText(L.PVP_NOTE)

-- Characters on this account, to remove the deleted ones from the total.
CreateHeader(L.CHARACTERS, -300)

local charactersTip = options:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
charactersTip:SetPoint("TOPLEFT", options, "TOPLEFT", 16, -318)
charactersTip:SetWidth(OPTIONS_WIDTH - 32)
charactersTip:SetJustifyH("LEFT")
charactersTip:SetText(L.CHARACTERS_TIP)

local list = CreateFrame("Frame", nil, options)
list:SetSize(LIST_WIDTH, LIST_SIZE * LIST_ROW_HEIGHT)
list:SetPoint("TOPLEFT", options, "TOPLEFT", 16, -340)
list:EnableMouseWheel(true)

local listRows = {}
local listOffset = 0
-- A character is removed on the second click of its button: the first one
-- asks for confirmation, for a few seconds.
local pendingRemoval, removalToken = nil, 0
local RefreshCharacterList

local function ScrollList(delta)
    listOffset = listOffset + delta
    RefreshCharacterList()
end

list:SetScript("OnMouseWheel", function(_, delta)
    ScrollList(-delta)
end)

local function OnRemoveClick(button)
    local key = button:GetParent().key
    if not key then
        return
    end
    if pendingRemoval == key then
        pendingRemoval = nil
        ForgetCharacter(key)
        Print(L.FORGET_OK:format(key))
        Update()
    else
        pendingRemoval = key
        removalToken = removalToken + 1
        local token = removalToken
        if C_Timer and C_Timer.After then
            C_Timer.After(4, function()
                if removalToken == token and pendingRemoval then
                    pendingRemoval = nil
                    RefreshCharacterList()
                end
            end)
        end
    end
    RefreshCharacterList()
end

for i = 1, LIST_SIZE do
    local row = CreateFrame("Frame", nil, list)
    row:SetSize(LIST_WIDTH, LIST_ROW_HEIGHT)
    row:SetPoint("TOPLEFT", list, "TOPLEFT", 0, -(i - 1) * LIST_ROW_HEIGHT)
    if i % 2 == 1 then
        local stripe = row:CreateTexture(nil, "BACKGROUND")
        stripe:SetAllPoints(row)
        SetColor(stripe, 1, 1, 1, 0.04)
    end
    row.name = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    row.name:SetPoint("LEFT", row, "LEFT", 6, 0)
    row.name:SetWidth(250)
    row.name:SetJustifyH("LEFT")
    if row.name.SetWordWrap then
        row.name:SetWordWrap(false)
    end
    row.kills = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    row.kills:SetPoint("RIGHT", row, "LEFT", 330, 0)
    row.kills:SetJustifyH("RIGHT")
    row.remove = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    row.remove:SetSize(100, 20)
    row.remove:SetPoint("LEFT", row, "LEFT", 344, 0)
    row.remove:SetScript("OnClick", OnRemoveClick)
    listRows[i] = row
end

local function CreateScrollButton(direction, delta)
    local button = CreateFrame("Button", nil, list)
    button:SetSize(18, 16)
    local path = "Interface\\Buttons\\UI-ScrollBar-Scroll" .. direction .. "Button-"
    button:SetNormalTexture(path .. "Up")
    button:SetPushedTexture(path .. "Down")
    button:SetDisabledTexture(path .. "Disabled")
    button:SetHighlightTexture(path .. "Highlight", "ADD")
    for _, texture in ipairs({ button:GetNormalTexture(), button:GetPushedTexture(),
        button:GetDisabledTexture(), button:GetHighlightTexture() }) do
        texture:SetTexCoord(0.2, 0.8, 0.25, 0.75)
    end
    button:SetScript("OnClick", function()
        ScrollList(delta)
    end)
    return button
end

local scrollUp = CreateScrollButton("Up", -1)
scrollUp:SetPoint("TOPLEFT", list, "TOPRIGHT", 6, -2)
local scrollDown = CreateScrollButton("Down", 1)
scrollDown:SetPoint("BOTTOMLEFT", list, "BOTTOMRIGHT", 6, 2)

local emptyText = list:CreateFontString(nil, "ARTWORK", "GameFontDisable")
emptyText:SetPoint("TOPLEFT", list, "TOPLEFT", 6, -4)
emptyText:SetText(L.NO_CHARACTERS)

RefreshCharacterList = function()
    local items = db and GetSortedCharacters() or {}
    local maxOffset = math.max(0, #items - LIST_SIZE)
    listOffset = math.max(0, math.min(listOffset, maxOffset))
    for i, row in ipairs(listRows) do
        local item = items[listOffset + i]
        row.key = item and item.key
        if item then
            -- The character being played cannot be removed: it would be
            -- saved again right away.
            local isCurrent = item.key == characterKey
            local name = GetCharacterName(item, nil, true)
            if isCurrent then
                name = name .. " |cff999999" .. L.CURRENT .. "|r"
            end
            row.name:SetText(name)
            row.name:SetTextColor(GetClassColor(item.entry.class))
            row.kills:SetText(FormatNumber(item.entry.kills))
            row.remove:SetText(item.key == pendingRemoval and L.CONFIRM or L.REMOVE)
            SetEnabled(row.remove, not isCurrent)
            row:Show()
        else
            row:Hide()
        end
    end
    local scrollable = #items > LIST_SIZE
    SetShown(scrollUp, scrollable)
    SetShown(scrollDown, scrollable)
    SetEnabled(scrollUp, listOffset > 0)
    SetEnabled(scrollDown, listOffset < maxOffset)
    SetShown(emptyText, #items == 0)
end

RefreshOptions = function()
    if not db then
        return
    end
    local screen, pvp = db.screen, db.pvp
    local shade
    screenShow:SetChecked(screen.shown and true or false)
    for _, check in ipairs(screenLines) do
        check:SetChecked(screen.rows[check.key] and true or false)
        SetCheckEnabled(check, screen.shown)
    end
    shade = screen.shown and 1 or 0.5
    screenLinesLabel:SetTextColor(shade, shade, shade)
    lockCheck:SetChecked(not screenUnlocked)
    SetCheckEnabled(lockCheck, screen.shown)
    SetEnabled(resetButton, screen.shown)

    pvpShow:SetChecked(pvp.shown and true or false)
    for _, check in ipairs(pvpLines) do
        check:SetChecked(pvp.rows[check.key] and true or false)
        SetCheckEnabled(check, pvp.shown)
    end
    shade = pvp.shown and 1 or 0.5
    pvpLinesLabel:SetTextColor(shade, shade, shade)

    RefreshCharacterList()
end

-- The "Defaults" button of the options window: what is shown, not where.
local function ResetDisplaySettings()
    if not db then
        return
    end
    db.pvp.shown, db.pvp.rows = nil, nil
    db.screen.shown, db.screen.rows = nil, nil
    ApplyDefaults(db, DEFAULTS)
    SetScreenUnlocked(false)
    Update()
    RefreshOptions()
end

options:SetScript("OnShow", function()
    RefreshOptions()
end)

-- Closing the options, or opening another page of them, locks the counter.
options:SetScript("OnHide", function()
    pendingRemoval = nil
    if screenUnlocked then
        SetScreenUnlocked(false)
    end
end)

-- Called by the options windows that know them.
options.refresh, options.OnRefresh = RefreshOptions, RefreshOptions
options.default, options.OnDefault = ResetDisplaySettings, ResetDisplaySettings

local function RegisterOptions()
    if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
        category = Settings.RegisterCanvasLayoutCategory(options, L.TITLE)
        Settings.RegisterAddOnCategory(category)
    elseif InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(options)
    end
end

OpenOptions = function()
    if InCombatLockdown and InCombatLockdown() then
        Print(L.OPTIONS_COMBAT)
        return
    end
    if options:IsVisible() then
        return
    end
    if category and Settings and Settings.OpenToCategory then
        local id = category.GetID and category:GetID() or category.ID
        SafeCall(Settings.OpenToCategory, id)
    elseif InterfaceOptionsFrame_OpenToCategory then
        -- The classic window may open on another panel the first time.
        InterfaceOptionsFrame_OpenToCategory(options)
        InterfaceOptionsFrame_OpenToCategory(options)
    end
end

---------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------
local events = CreateFrame("Frame")
for _, event in ipairs({
    "ADDON_LOADED",
    "PLAYER_LOGIN",
    "PLAYER_ENTERING_WORLD",
    "PLAYER_PVP_KILLS_CHANGED",  -- the character's kill counts changed
    "CHAT_MSG_COMBAT_HONOR_GAIN", -- backup: honorable kill message
    "PLAYER_REGEN_ENABLED",
}) do
    pcall(events.RegisterEvent, events, event)
end

events:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == ADDON_NAME then
            InitDB()
            ApplyScreenPosition()
        end
        -- Some PvP windows (e.g. Blizzard_PVPUI) are loaded on demand.
        Attach()
    elseif event == "PLAYER_LOGIN" then
        InitDB()
        loggedIn = true
        InitCharacter()
        UpdateIcons()
        WatchForTarget()
        Update()
        -- Keeps the counter right when the day changes without a kill.
        if C_Timer and C_Timer.NewTicker then
            C_Timer.NewTicker(60, function()
                if counter:IsShown() then
                    Update()
                end
            end)
        end
    elseif event == "CHAT_MSG_COMBAT_HONOR_GAIN" then
        UpdateSoon()
    elseif event == "PLAYER_REGEN_ENABLED" then
        if pendingUpdate then
            pendingUpdate = false
            Update()
        end
    else
        Update()
    end
end)

---------------------------------------------------------------------------
-- Slash commands
---------------------------------------------------------------------------
-- For players who want to go further: everything else is in the options.
SLASH_HONORABLEKILLSFOREVER1 = "/hk"
SLASH_HONORABLEKILLSFOREVER2 = "/honorablekillsforever"

SlashCmdList.HONORABLEKILLSFOREVER = function(msg)
    InitDB()
    local command, rest = (msg or ""):match("^%s*(%S*)%s*(.-)%s*$")
    command = (command or ""):lower()

    if command == "" then
        local s = CollectStats()
        local parts = {}
        for _, row in ipairs(ROWS) do
            local value = s[row.key]
            if row.always or IsUsable(value) then
                table.insert(parts, row.label .. L.COLON .. FormatNumber(value))
            end
        end
        Print(table.concat(parts, " | "))
        if currentParentName then
            Print(L.SHOWN_ON:format(currentParentName))
        else
            Print(L.NOT_FOUND)
        end
    elseif command == "options" or command == "config" then
        OpenOptions()
    elseif command == "reset" then
        db.positions = {}
        db.screen.x, db.screen.y = nil, nil
        ApplyPvPPosition()
        ApplyScreenPosition()
        Print(L.RESET_DONE)
    elseif command == "attach" then
        if rest == "" then
            Print(L.ATTACH_ARG)
        elseif not GetFrameByName(rest) then
            Print(L.ATTACH_ERR:format(rest))
        else
            db.forcedFrame = rest
            Detach()
            WatchForTarget()
            Print(L.ATTACH_OK:format(rest))
        end
    elseif command == "auto" then
        db.forcedFrame = nil
        Detach()
        WatchForTarget()
        Print(L.AUTO_DONE)
    elseif command == "test" then
        -- Debug only, deliberately left out of the help.
        if rest == "" then
            testKills = nil
            Print(L.TEST_OFF)
        else
            local digits = rest:gsub("[%s,%.]", "")
            if not digits:match("^%d+$") or #digits > 12 then
                Print(L.TEST_ERR)
                return
            end
            testKills = tonumber(digits)
            Print(L.TEST_ON:format(FormatNumber(testKills)))
        end
        Update()
    elseif command == "forget" then
        if rest == "" then
            Print(L.FORGET_ARG)
            return
        end
        local wanted, removed, isCurrent = rest:lower(), {}, false
        for key, entry in pairs(db.characters) do
            if key:lower() == wanted or (entry.name or ""):lower() == wanted then
                if key == characterKey then
                    isCurrent = true -- it would be saved again right away
                else
                    table.insert(removed, key)
                end
            end
        end
        if isCurrent then
            Print(L.FORGET_CURRENT:format(characterKey))
        end
        if #removed == 0 then
            if not isCurrent then
                Print(L.FORGET_ERR:format(rest))
            end
            return
        end
        for _, key in ipairs(removed) do
            ForgetCharacter(key)
            Print(L.FORGET_OK:format(key))
        end
        Update()
        RefreshOptions()
    else
        for _, line in ipairs(L.HELP) do
            Print(line)
        end
    end
end

---------------------------------------------------------------------------
-- Start
---------------------------------------------------------------------------
SetScreenUnlocked(false)

-- If the options cannot be registered, the rest of the add-on still works.
local registered, registerError = pcall(RegisterOptions)
if not registered then
    geterrorhandler()(registerError)
end
