-- translate
Translator = {}
Translator.languages = {}
Translator.language = "english"
local rootFolder = (GM or GAMEMODE).Folder:sub(11) .. "/gamemode/"

function Translator:LoadLanguage(name, overridePath)
    local tempG = {}
    tempG.pt = {}
    local meta = {}
    meta.__index = _G
    setmetatable(tempG, meta)
    local f = CompileFile(overridePath or (rootFolder .. "lang/" .. name .. ".lua"))
    if not f then return end
    setfenv(f, tempG)
    local b, err = pcall(f)

    if b then
        Translator.languages[name] = tempG.pt
    else
        MsgC(Color(255, 50, 50), "Loading translation failed " .. name .. "\nError: " .. err .. "\n")
    end
end

function Translator:GetLanguage()
    return self.language or "english"
end

function Translator:GetLanguageTable()
    local lang = self:GetLanguage()

    return self.languages[lang] or self.languages["english"]
end

function Translator:ChangeLanguage(lang)
    self.language = lang
    GAMEMODE:SetupTeams()

    if SERVER then
        self:NetworkLanguage()
    end
end

local files = file.Find(rootFolder .. "lang/*", "LUA")

for _, v in pairs(files) do
    AddCSLuaFile(rootFolder .. "lang/" .. v)
    local name = v:sub(1, -5)
    Translator:LoadLanguage(name)
end

if SERVER then
    util.AddNetworkString("translator_language")

    hook.Add("Think", "Translator", function()
        local lang = GAMEMODE and GAMEMODE.Language and GAMEMODE.Language:GetString()

        if not lang or lang == "" then
            lang = "english"
        end

        if lang ~= Translator.language then
            Translator:ChangeLanguage(lang)
        end
    end)

    function Translator:NetworkLanguage(ply)
        net.Start("translator_language")
        net.WriteString(self:GetLanguage())

        if ply ~= nil then
            net.Send(ply)
        else
            net.Broadcast()
        end
    end

    hook.Add("PlayerInitialSpawn", "Translator", function(ply)
        Translator:NetworkLanguage(ply)
    end)
else
    net.Receive("translator_language", function(len)
        local lang = net.ReadString()
        Translator:ChangeLanguage(lang)
    end)
end

function Translator:Translate(languageTable, names)
    for _, name in pairs(names) do
        local a = rawget(languageTable, name)

        if a ~= nil then
            if type(a) == "function" then
                local ret = a(name)
                if ret ~= nil then return ret end
            end

            return a
        end
    end

    local a = rawget(languageTable, "default")

    if a ~= nil then
        if type(a) == "function" then
            local ret = a(names[1])
            if ret ~= nil then return ret end
        end

        return a
    end
end

-- translation convience funcitons
-- replaces a phrases {variables} with replacements in reptable
function Translator:VarTranslate(s, reptable)
    for k, v in pairs(reptable) do
        s = s:gsub("{" .. k .. "}", v)
    end

    return s
end

function Translator:QuickVar(s, k, v)
    s = s:gsub("{" .. k .. "}", v)

    return s
end

-- replaces {variables} with replacements but outputed in a table to allow additional formatting like colors
-- used for ChatText(msgs)
function Translator:AdvVarTranslate(phrase, replacements)
    local out = {}
    local s = phrase
    repeat
        local a, b, c = s:match("([^{]*){([^}]+)}(.*)")

        if a then
            if #a > 0 then
                table.insert(out, {
                    text = a
                })
            end

            if type(replacements) == "function" then
                local rep = replacements(b)

                table.insert(out, rep or {
                    text = "{" .. b .. "}"
                })
            else
                local rep = replacements[b] or "{" .. b .. "}"

                if type(rep) == "function" then
                    table.insert(out, rep(b))
                elseif type(rep) == "table" then
                    table.insert(out, rep)
                else
                    table.insert(out, {
                        text = rep
                    })
                end
            end

            s = c
        end
    until not a

    if #s > 0 then
        table.insert(out, {
            text = s
        })
    end

    return out
end

-- the actual translator
local tmeta = {}

local function get(args)
    return Translator:Translate(Translator:GetLanguageTable(), args)
end

local function trans(self, ...)
    local args = {...}
    local a = get(args)
    if a ~= nil then return tostring(a) end
    local first = args[1]
    if first then return "<" .. tostring(first) .. ">" end

    return "<no-trans>"
end

tmeta.__index = trans
tmeta.__call = trans
tmeta.__newindex = function(self, key, value) end
local tablemeta = {}

local function transtable(self, ...)
    local args = {...}
    local a = get(args)
    if type(a) == "table" then return a end
end

tablemeta.__index = transtable
tablemeta.__call = transtable
tablemeta.__newindex = function(self, key, value) end
translate = {}
translate.table = {}
setmetatable(translate, tmeta)
setmetatable(translate.table, tablemeta)