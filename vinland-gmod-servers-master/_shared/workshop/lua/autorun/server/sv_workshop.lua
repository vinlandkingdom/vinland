DOWNLOADER = {}
DOWNLOADER.__index = DOWNLOADER

DOWNLOADER.ResourceExtensions = {
    --Models
    mdl = true,
    vtx = true,
    --Sounds
    wav = true,
    mp3 = true,
    ogg = true,
    --Materials, Textures
    vmt = true,
    vtf = true,
    png = true
}

function DOWNLOADER:Traverse(subPath, basePath, foundExts)
    local files, dirs = file.Find(subPath .. "*", basePath)

    for _, f in pairs(files) do
        local ext = string.GetExtensionFromFilename(f)
        foundExts[ext] = true
        if ext == "bsp" and string.StripExtension(f) == game.GetMap() then return true end
    end

    for _, d in pairs(dirs) do
        if self:Traverse(subPath .. d .. "/", basePath, foundExts) then return true end
    end
end

function DOWNLOADER:AddWorkshopResources()
    local addons = engine.GetAddons()
    print("[DOWNLOADER] STARTING TO ADD RESOURCES FOR " .. #addons .. " ADDONS...")

    for _, addon in pairs(addons) do
        if addon.downloaded and addon.mounted then
            local found_exts = {}
            local shouldAdd = self:Traverse("", addon.title, found_exts)

            -- if addon fails initial test but does not contain a map, check for resource files
            if not shouldAdd and not found_exts.bsp then
                for res_ext, _ in pairs(self.ResourceExtensions) do
                    if found_exts[res_ext] then
                        shouldAdd = true
                        break
                    end
                end
            end

            if shouldAdd then
                resource.AddWorkshop(addon.wsid)
                print("[DOWNLOADER] ADDING RESOURCE FOR '" .. addon.title .. "' WITH WSID '" .. addon.wsid .. "'")
            end
        end
    end

    print("[DOWNLOADER] FINISHED TO ADD RESOURCES")
end

function DOWNLOADER:CheckUnusedPlayermodels()
    print("[DOWNLOADER] STARTING TO CHECK POINTSHOP PLAYERMODELS")
    local models = player_manager.AllValidModels()

    for k, model in pairs(models) do
        model = string.lower(model)

        if not string.StartWith(model, "models/player/group") then
            local found = false

            for _, psItem in pairs(PS.Items) do
                if psItem.Model and string.lower(psItem.Model) == model then
                    found = true
                    break
                end
            end

            if not found then
                MsgC(Color(255, 0, 0), "[DOWNLOADER] MODEL " .. k .. " NOT FOUND IN POINTSHOP: " .. model .. "\n")
            end
        end
    end

    print("[DOWNLOADER] FINISHED POINTSHOP SEARCH")
end

function DOWNLOADER:Start()
    self:AddWorkshopResources()

    if PS then
        timer.Simple(5, function()
            self:CheckUnusedPlayermodels()
            DOWNLOADER = nil
        end)
    else
        MsgC(Color(255, 0, 0), "[DOWNLOADER] POINTSHOP 1 NOT FOUND\n")
        DOWNLOADER = nil
    end
end

-- Generated using: Universal | Workshop Collection Generator
-- https://csite.io/tools/gmod-universal-workshop
resource.AddWorkshop("1564246250") -- All Might Playermodel [My Hero One's Justice]
resource.AddWorkshop("2075639376") -- Big Smoke Playermodel
resource.AddWorkshop("1712553850") -- Cam Head (PM &amp; NPC)
resource.AddWorkshop("159269477") -- Corvo playermodel
resource.AddWorkshop("431813760") -- Assassin's Creed Chronicles China: Shao Jun Playermodel
resource.AddWorkshop("1573451927") -- CS:GO Knives SWEPs Compressed
resource.AddWorkshop("1342698706") -- Dio Anime Version Fixed Playermodel
resource.AddWorkshop("1715516319") -- Earth Chan [PM &amp; NPC]
resource.AddWorkshop("1342528542") -- FKG Setaria Green Playermodel &amp; NPC
resource.AddWorkshop("1982247237") -- Father Doofy
resource.AddWorkshop("703107302") -- Goku
resource.AddWorkshop("1582359658") -- Hatsune Miku (Heartless)
resource.AddWorkshop("293674909") -- Haus The Plague Doktor
resource.AddWorkshop("237872885") -- Jesus Playermodel
resource.AddWorkshop("635618365") -- Kashima (Kancolle) Playermodel and NPC
resource.AddWorkshop("1510010810") -- Jotaro model Anime reskin
resource.AddWorkshop("485879458") -- Kermit The Frog Player Model &amp; NPC
resource.AddWorkshop("1224790718") -- Kokichi Oma Playermodel &amp; NPC [2.0]
resource.AddWorkshop("391383735") -- Left Shark playermodel
resource.AddWorkshop("620303294") -- LOL | Definitely Not Udyr | NPCs + Playermodels
resource.AddWorkshop("974221698") -- Lucoa P.M. &amp; NPC
resource.AddWorkshop("1398066681") -- Little Witch Academia - Akko
resource.AddWorkshop("1334096779") -- Lym's Invasion Cyberman Playermodel
resource.AddWorkshop("687405396") -- MAGES Playermodel/NPC
resource.AddWorkshop("1562914035") -- MHA:OJ's ''Deku'' P.M. Duo!
resource.AddWorkshop("104533079") -- Minecraft Playermodel
resource.AddWorkshop("1722787783") -- Monika (Doki Doki Literature Club) (Ragdoll)
resource.AddWorkshop("1767064178") -- Nekopara Vanilla Playermodel &amp; NPCs
resource.AddWorkshop("905397141") -- NieR: Automata 2B ENHANCED (V2) [PM/NPC]
resource.AddWorkshop("917473762") -- Nier:Automata || 9S [PM/RAG]
resource.AddWorkshop("1998016501") -- Peely Banana[PM &amp; Ragdoll]
resource.AddWorkshop("964754279") -- Pepsi-Man Ragdoll
resource.AddWorkshop("1766798789") -- Rorshach Playermodel Fix
resource.AddWorkshop("572267883") -- Santa Claus Playermodel and NPC
resource.AddWorkshop("1668408858") -- Sao Fatal Bullet - LLENN V2 [PM &amp; NPC]
resource.AddWorkshop("1154384700") -- Spiderman Playermodel
resource.AddWorkshop("1586714339") -- Spiderman: Far From Home Playermodel (Custom)
resource.AddWorkshop("604939814") -- Star Wars: The Force Awakens Z6 Riot Control Stunbaton [Prop]
resource.AddWorkshop("1826106073") -- Stonks playermodel
resource.AddWorkshop("717705046") -- Tda Gahata Meiji
resource.AddWorkshop("309754452") -- Tda Hatsune Miku Append (v2)
resource.AddWorkshop("312131644") -- Tda Kuro Miku Append (v2)
resource.AddWorkshop("619509828") -- Tda Nyakita Neru Classic
resource.AddWorkshop("1215291684") -- TF2 Pydic (Pyro/Medic Fusion) [Ragdoll]
resource.AddWorkshop("908040809") -- Tohru P.M. &amp; NPC
resource.AddWorkshop("241187700") -- TRON Anon Playermodel
resource.AddWorkshop("1135026995") -- Yowane Haku (Bikini)
resource.AddWorkshop("1395549626") -- Zero Two Fixed Playermodel
resource.AddWorkshop("2066347752") -- [Konosuba] Megumin P.M.
resource.AddWorkshop("1109564654") -- [Naruto]Madara Uchiha Playermodel
resource.AddWorkshop("1126257815") -- [Naruto]Naruto Six Path Sage Mode
resource.AddWorkshop("1380429026") -- Death: A Grim Bundle (PMs)
resource.AddWorkshop("157854748") -- GTA San Andreas: Carl "CJ" Johnson Playermodel
resource.AddWorkshop("471518115") -- MGS2 Solid Snake Playermodel
resource.AddWorkshop("1567760820") -- PaperBag Playermodel
resource.AddWorkshop("1176872233") -- Watch Dogs 2 Wrench P.M.
resource.AddWorkshop("2020141130") -- Ereshkigal
resource.AddWorkshop("263644195") -- Anbu Kakashi Hatake
resource.AddWorkshop("638229249") -- White Rock Shooter (Digitrevx) Playermodel and NPC
resource.AddWorkshop("732580858") -- CS Office
resource.AddWorkshop("127328627") -- GM Nightmare Church HD - Horror Free Roam Scary Map - High Quality
resource.AddWorkshop("284771106") -- gm wwhousse
resource.AddWorkshop("148215278") -- GMod Tower: Accessories Pack
resource.AddWorkshop("2072084179") -- gm_tunnels_v2
resource.AddWorkshop("937017839") -- Gta V house
resource.AddWorkshop("217808514") -- md_clue
resource.AddWorkshop("367415423") -- ph_Chalet
resource.AddWorkshop("1738480835") -- ph_westerncity
resource.AddWorkshop("400754706") -- Museum
resource.AddWorkshop("262374517") -- mu_abandoned
resource.AddWorkshop("703014890") -- mu_bank
resource.AddWorkshop("2134064426") -- mu_school
resource.AddWorkshop("1506830124") -- mu_springbreak
resource.AddWorkshop("439856500") -- Pointshop 2 Content
resource.AddWorkshop("329545557") -- Pointshop Particle Hats
resource.AddWorkshop("966036650") -- ttt_aircraft_v3
resource.AddWorkshop("195227686") -- TTT_Dolls
resource.AddWorkshop("889034501") -- ttt_minecraft_b5
resource.AddWorkshop("534491717") -- ttt_rooftops_2016
resource.AddWorkshop("340180450") -- zs_castle_keep_snowy
resource.AddWorkshop("428782656") -- zs_last_mansion_v3
resource.AddWorkshop("171222056") -- Custom Trails Pack #2 (FOR POINTSHOP)
resource.AddWorkshop("161466256") -- Custom Trails Pack (For Pointshop)
resource.AddWorkshop("112806637") -- Gmod Legs 3
resource.AddWorkshop("183688016") -- Double Jump
resource.AddWorkshop("1853618226") -- AWarn3 Server Content
resource.AddWorkshop("846689879") -- Trails for Pointshop/Pointshop2
resource.AddWorkshop("719634946") -- UNDERTALE - MTT Resort
