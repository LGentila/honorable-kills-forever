-- Honorable Kills Forever
-- Shows honorable kills on the PvP window: the character's total, today,
-- yesterday, and an account-wide total summed over every character that
-- has logged in with the add-on. Texts follow the client language: French
-- on frFR clients, English everywhere else.

local ADDON_NAME = ...

---------------------------------------------------------------------------
-- Localization
---------------------------------------------------------------------------
local L = {
    TITLE        = "Honorable Kills",
    TOTAL        = "Total",
    TODAY        = "Today",
    YESTERDAY    = "Yesterday",
    ACCOUNT      = "Account",
    THIS_WEEK    = "This week",
    LAST_WEEK    = "Last week",
    CHARACTERS   = "Characters on this account",
    ACCOUNT_NOTE = "Only characters logged in with the add-on are counted.",
    HINT_MOVE    = "Shift + drag to move",
    THOUSANDS    = ",",
    COLON        = ": ",
    SHOWN_ON     = "Shown on: %s",
    NOT_FOUND    = "PvP window not detected yet. Open it once, or use /hk attach <FrameName>.",
    RESET_DONE   = "Position reset.",
    ATTACH_OK    = "The panel will be shown on %s.",
    ATTACH_ERR   = "No frame named \"%s\". Hover the window and type /fstack to find its name.",
    ATTACH_ARG   = "Give a frame name, for example: /hk attach PVPRankFrame",
    AUTO_DONE    = "Automatic PvP window detection re-enabled.",
    FORGET_ARG   = "Give a character name, for example: /hk forget Name",
    FORGET_OK    = "%s removed from the account total.",
    FORGET_ERR   = "No saved character named \"%s\".",
    TEST_ON      = "Test mode: showing %s honorable kills (not saved). Type /hk test to stop.",
    TEST_OFF     = "Test mode off.",
    TEST_ERR     = "Usage: /hk test <number>, or /hk test to stop.",
    HELP = {
        "/hk: print your honorable kills in chat",
        "/hk reset: move the panel back to its default position",
        "/hk attach <FrameName>: show the panel on another frame",
        "/hk auto: go back to automatic detection",
        "/hk forget <Name>: remove a character from the account total",
    },
}

if GetLocale() == "frFR" then
    local fr = {
        TITLE        = "Victoires honorables",
        TOTAL        = "Total",
        TODAY        = "Aujourd'hui",
        YESTERDAY    = "Hier",
        ACCOUNT      = "Compte",
        THIS_WEEK    = "Cette semaine",
        LAST_WEEK    = "Semaine dernière",
        CHARACTERS   = "Personnages du compte",
        ACCOUNT_NOTE = "Seuls les personnages connectés avec l'add-on sont comptés.",
        HINT_MOVE    = "Maj + glisser pour déplacer",
        THOUSANDS    = " ",
        COLON        = " : ",
        SHOWN_ON     = "Affiché sur : %s",
        NOT_FOUND    = "Fenêtre JcJ pas encore détectée. Ouvrez-la une fois, ou utilisez /hk attach <NomDuCadre>.",
        RESET_DONE   = "Position réinitialisée.",
        ATTACH_OK    = "Le panneau sera affiché sur %s.",
        ATTACH_ERR   = "Aucun cadre nommé « %s ». Survolez la fenêtre et tapez /fstack pour trouver son nom.",
        ATTACH_ARG   = "Indiquez un nom de cadre, par exemple : /hk attach PVPRankFrame",
        AUTO_DONE    = "Détection automatique de la fenêtre JcJ réactivée.",
        FORGET_ARG   = "Indiquez un nom de personnage, par exemple : /hk forget Nom",
        FORGET_OK    = "%s retiré du total du compte.",
        FORGET_ERR   = "Aucun personnage enregistré nommé « %s ».",
        TEST_ON      = "Mode test : affichage de %s victoires honorables (non enregistré). Tapez /hk test pour arrêter.",
        TEST_OFF     = "Mode test désactivé.",
        TEST_ERR     = "Utilisation : /hk test <nombre>, ou /hk test pour arrêter.",
        HELP = {
            "/hk : affiche vos victoires honorables dans la discussion",
            "/hk reset : remet le panneau à sa position par défaut",
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

local DEFAULT_X, DEFAULT_Y = 8, 8 -- from the bottom-left corner, inwards

local PADDING     = 8
local ICON_SIZE   = 18
local ROW_HEIGHT  = 16
local COLUMN_GAP  = 16
local MIN_WIDTH   = 150
local MAX_TOOLTIP_CHARACTERS = 15

-- Rows shown in the panel, top to bottom. "gap" adds space above a row.
local ROWS = {
    { key = "lifetime",  label = L.TOTAL,     always = true },
    { key = "today",     label = L.TODAY },
    { key = "yesterday", label = L.YESTERDAY },
    { key = "account",   label = L.ACCOUNT,   always = true, gap = 4 },
}

local db
local characterKey, characterInfo
local currentParent, currentParentName
local hookedFrames = {}
local pendingUpdate = false
local testKills -- debug: simulated total set by /hk test, never saved

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

---------------------------------------------------------------------------
-- Account-wide total
---------------------------------------------------------------------------
local function InitCharacter()
    local name = UnitName and UnitName("player")
    if not name then
        return
    end
    local realm = (GetRealmName and GetRealmName()) or ""
    local _, class = UnitClass("player")
    characterKey = name .. "-" .. realm
    characterInfo = { name = name, realm = realm, class = class }
end

-- Saves the current character's lifetime kills. A 0 never overwrites a
-- saved positive count, in case the server data is not loaded yet.
local function SaveCharacter(lifetime)
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
    entry = entry or {}
    entry.name, entry.realm, entry.class = characterInfo.name, characterInfo.realm, characterInfo.class
    entry.kills = lifetime
    db.characters[characterKey] = entry
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

---------------------------------------------------------------------------
-- Stats
---------------------------------------------------------------------------
local STATISTIC_TOTAL_HK = 588 -- "Honorable kills" in the statistics panel

-- Reads the character's stats, saves its total for the account count and
-- adds the account total.
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
    s.account = GetAccountTotal()
    if testKills and not IsSecret(s.lifetime) then
        -- Display only: the real count stays saved for the account total.
        s.lifetime = testKills
        s.account = (GetAccountTotal(characterKey) or 0) + testKills
    end
    return s
end

---------------------------------------------------------------------------
-- Panel
---------------------------------------------------------------------------
local panel = CreateFrame("Frame", "HonorableKillsForeverPanel", UIParent,
    BackdropTemplateMixin and "BackdropTemplate" or nil)
panel:SetSize(MIN_WIDTH, 100)
panel:Hide()
panel:SetMovable(true)
panel:EnableMouse(true)
panel:RegisterForDrag("LeftButton")
panel:SetClampedToScreen(true)

if panel.SetBackdrop then
    panel:SetBackdrop({
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    panel:SetBackdropColor(0, 0, 0, 0.8)
    panel:SetBackdropBorderColor(1, 0.82, 0, 0.9)
end

local icon = panel:CreateTexture(nil, "ARTWORK")
icon:SetSize(ICON_SIZE, ICON_SIZE)
icon:SetPoint("TOPLEFT", panel, "TOPLEFT", PADDING, -PADDING)

local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("LEFT", icon, "RIGHT", 4, 0)
title:SetText(L.TITLE)

for _, row in ipairs(ROWS) do
    row.labelText = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row.labelText:SetTextColor(0.8, 0.8, 0.8)
    row.labelText:SetText(row.label)
    row.valueText = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row.valueText:SetJustifyH("RIGHT")
    row.valueText:SetText("?")
end

local function UpdateIcon()
    local faction = UnitFactionGroup and UnitFactionGroup("player")
    if faction == "Alliance" or faction == "Horde" then
        icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-" .. faction)
    else
        icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA")
    end
    icon:SetTexCoord(0, 0.65625, 0, 0.65625)
end

-- Fills the rows and resizes the panel to fit. Rows whose stat is not
-- available on this client are hidden.
local function Layout(stats)
    local y = -(PADDING + ICON_SIZE + 4)
    local labelWidth, valueWidth = 0, 0
    for _, row in ipairs(ROWS) do
        local value = stats[row.key]
        if row.always or IsUsable(value) then
            y = y - (row.gap or 0)
            row.valueText:SetText(FormatNumber(value))
            row.labelText:ClearAllPoints()
            row.labelText:SetPoint("TOPLEFT", panel, "TOPLEFT", PADDING + 2, y)
            row.valueText:ClearAllPoints()
            row.valueText:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -(PADDING + 2), y)
            row.labelText:Show()
            row.valueText:Show()
            labelWidth = math.max(labelWidth, row.labelText:GetStringWidth())
            valueWidth = math.max(valueWidth, row.valueText:GetStringWidth())
            y = y - ROW_HEIGHT
        else
            row.labelText:Hide()
            row.valueText:Hide()
        end
    end
    local contentWidth = math.max(
        MIN_WIDTH - 2 * PADDING,
        ICON_SIZE + 4 + title:GetStringWidth(),
        labelWidth + COLUMN_GAP + valueWidth + 4)
    panel:SetSize(math.ceil(contentWidth + 2 * PADDING), math.ceil(-y + PADDING - 2))
end

local function Update()
    local stats = CollectStats()
    for _, row in ipairs(ROWS) do
        if IsSecret(stats[row.key]) then
            -- In combat: keep the last values and retry afterwards.
            pendingUpdate = true
            return
        end
    end
    Layout(stats)
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

local function GetClassColor(class)
    local color = class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
    if color then
        return color.r, color.g, color.b
    end
    return 1, 1, 1
end

panel:SetScript("OnShow", Update)

panel:SetScript("OnEnter", function(self)
    local s = CollectStats()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine(L.CHARACTERS, 1, 1, 1)
    local characters = GetSortedCharacters()
    for i, item in ipairs(characters) do
        if i > MAX_TOOLTIP_CHARACTERS then
            break
        end
        local entry = item.entry
        local name = entry.name or item.key
        if characterInfo and entry.realm and entry.realm ~= characterInfo.realm then
            name = name .. "-" .. entry.realm
        end
        local r, g, b = GetClassColor(entry.class)
        GameTooltip:AddDoubleLine(name, FormatNumber(entry.kills), r, g, b, 1, 1, 1)
    end
    GameTooltip:AddLine(L.ACCOUNT_NOTE, 0.6, 0.6, 0.6, true)
    -- Extra stats, only on clients that provide them.
    if IsUsable(s.thisWeek) or IsUsable(s.lastWeek) then
        GameTooltip:AddLine(" ")
        AddTooltipStat(L.THIS_WEEK, s.thisWeek)
        AddTooltipStat(L.LAST_WEEK, s.lastWeek)
    end
    GameTooltip:AddLine(" ")
    GameTooltip:AddLine(L.HINT_MOVE, 0.6, 0.6, 0.6)
    GameTooltip:Show()
end)

panel:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

---------------------------------------------------------------------------
-- Position and attachment to the PvP window
---------------------------------------------------------------------------
local function ApplyPosition()
    if not currentParent then
        return
    end
    local pos = db.positions[currentParentName]
    panel:ClearAllPoints()
    panel:SetPoint("BOTTOMLEFT", currentParent, "BOTTOMLEFT",
        pos and pos.x or DEFAULT_X, pos and pos.y or DEFAULT_Y)
end

panel:SetScript("OnDragStart", function(self)
    if IsShiftKeyDown() and currentParent then
        self.isMoving = true
        self:StartMoving()
    end
end)

panel:SetScript("OnDragStop", function(self)
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
    ApplyPosition()
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
    panel:SetParent(target)
    panel:SetFrameStrata(target:GetFrameStrata())
    panel:SetFrameLevel(math.min(target:GetFrameLevel() + 50, 9000))
    ApplyPosition()
    panel:Show()
    if not hookedFrames[target] then
        hookedFrames[target] = true
        target:HookScript("OnShow", Update)
    end
    Update()
end

local function Detach()
    currentParent, currentParentName = nil, nil
    panel:Hide()
    panel:SetParent(UIParent)
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
-- Events
---------------------------------------------------------------------------
local function InitDB()
    if db then
        return
    end
    HonorableKillsForeverDB = HonorableKillsForeverDB or {}
    db = HonorableKillsForeverDB
    db.positions = db.positions or {}
    db.characters = db.characters or {}
end

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
        end
        -- Some PvP windows (e.g. Blizzard_PVPUI) are loaded on demand.
        Attach()
    elseif event == "PLAYER_LOGIN" then
        InitDB()
        InitCharacter()
        UpdateIcon()
        WatchForTarget()
        Update()
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
    elseif command == "reset" then
        db.positions = {}
        ApplyPosition()
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
        local wanted, removed = rest:lower(), {}
        for key, entry in pairs(db.characters) do
            if key:lower() == wanted or (entry.name or ""):lower() == wanted then
                table.insert(removed, key)
            end
        end
        if #removed == 0 then
            Print(L.FORGET_ERR:format(rest))
            return
        end
        for _, key in ipairs(removed) do
            db.characters[key] = nil
            Print(L.FORGET_OK:format(key))
        end
        Update()
    else
        for _, line in ipairs(L.HELP) do
            Print(line)
        end
    end
end
