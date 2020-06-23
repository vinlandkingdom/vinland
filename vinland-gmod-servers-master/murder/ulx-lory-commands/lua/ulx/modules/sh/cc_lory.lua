local CATEGORY_NAME = "Lory"

local addons = ulx.command(CATEGORY_NAME, "ulx addons", function(ply)
    openUrl(ply, "https://steamcommunity.com/sharedfiles/filedetails/?edit=true&id=2137406850")
end, {"!addons", "!addon"})

addons:defaultAccess(ULib.ACCESS_ALL)
addons:help("Ver addons do servidor.")

local rules = ulx.command(CATEGORY_NAME, "ulx rules", function(ply)
    openUrl(ply, "https://steamcommunity.com/groups/lorybr/discussions/0/2257934448607145092/")
end, {"!rules", "!regras"})

rules:defaultAccess(ULib.ACCESS_ALL)
rules:help("Ver regras do servidor.")

local steamgroup = ulx.command(CATEGORY_NAME, "ulx steamgroup", function(ply)
    openUrl(ply, "https://steamcommunity.com/profiles/76561198200308077/")
end, {"!steam", "!group", "!grupo"})

steamgroup:defaultAccess(ULib.ACCESS_ALL)
steamgroup:help("Entre no nosso grupo da steam.")

local discord = ulx.command(CATEGORY_NAME, "ulx discord", function(ply)
    openUrl(ply, "https://discord.com/invite/PwwuFgD")
end, {"!discord"})

discord:defaultAccess(ULib.ACCESS_ALL)
discord:help("Entre no nosso discord.")

local vip = ulx.command(CATEGORY_NAME, "ulx vip", function(ply)
    openUrl(ply, "Em Breve")
end, {"!vip", "!doador", "!doar", "!donate"})

vip:defaultAccess(ULib.ACCESS_ALL)
vip:help("Ver informações sobre o vip.")

function openUrl(ply, url)
    ply:SendLua(string.format([[gui.OpenURL("%s")]], url))
end
