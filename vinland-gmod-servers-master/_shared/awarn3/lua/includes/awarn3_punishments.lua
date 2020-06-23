--[[
      __          __              ____  
     /\ \        / /             |___ \ 
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ < 
  / ____ \  /\  / (_| | |  | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/ 

	AWarn3 by Mr.President
]]

MsgC( AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, "Loading Punishments Module\n" )


AWarn.Punishments = {}

function AWarn:RegisterPunishment( pTbl )
	self.Punishments[ pTbl.warnings ] = pTbl
end

function AWarn:GetPunishment( warnings )
	if not self.Punishments[ warnings ] then
		MsgC( AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, AWarn.Localization:GetTranslation( "nopunishment" ) .. "\n" )
		return nil
	end
	return self.Punishments[ warnings ]
end

function AWarn:SavePunishments()
	self:CheckDirectory()
	file.Write( "awarn3/punishments.txt", util.TableToJSON( self.Punishments, true ) )
end

function AWarn:LoadPunishments()
	if file.Exists( "awarn3/punishments.txt", "DATA" ) then
		self.Punishments = util.JSONToTable( file.Read( "awarn3/punishments.txt", "DATA" ) )
		MsgC( AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, AWarn.Localization:GetTranslation( "punishmentsloaded" ) .. "\n" )
	else
		self:SavePunishments()
	end
end

function AWarn:CheckForPunishment( pl, warnings )
	if not IsValid( pl ) then return end
	if not pl:IsPlayer() then return end
	if not self.Punishments[ warnings ] then return end
	if self.Punishments[ warnings ].pType == "kick" then
		if not self:GetOption( "awarn_kick" ) then return end
		self:Kick( pl, self.Punishments[ warnings ].pMessage, self.Punishments[ warnings ].sMessage )
		
	elseif self.Punishments[ warnings ].pType == "ban" then		
		if not self:GetOption( "awarn_ban" ) then return end
		if self:GetOption( "awarn_reset_after_ban" ) then self:UpdatePlayerWarnings( AWarn:SteamID64( pl ), 0 ) end
		self:Ban( pl, self.Punishments[ warnings ].pLength or 0, self.Punishments[ warnings ].pMessage, self.Punishments[ warnings ].sMessage )
	
	end	
end

function AWarn:Kick( pl, pMessage, sMessage )
	if not IsValid( pl ) then return end
	self:SendChatMessage( { sMessage:format( pl:GetName() ) }, nil )
	if ulx then
		ULib.kick( pl, pMessage, nil )
	elseif SAM then
	
	else
		pl:Kick( pMessage )
	end
end

function AWarn:Ban( pl, length, pMessage, sMessage )
	if not IsValid( pl ) then return end
	self:SendChatMessage( { sMessage:format( pl:GetName() ) }, nil )
	if ulx then
		ULib.ban( pl, length, pMessage )
	elseif xAdmin then
		xAdmin.RegisterNewBan( pl, "CONSOLE", pMessage, length )
		pl:Kick( pMessage )
	elseif SAM then
		SAM.AddBan( pl:SteamID(), nil, length * 60, pMessage )
	else
		pl:Ban( length, false )
		pl:Kick( pMessage )
	end
end

net.Receive( "awarn3_networkpunishments", function( len, pl )
	if not AWarn:CheckPermission( pl, "awarn_options" ) then return end
	
	local requestType = net.ReadString()
	
	if requestType == "update" then
	
		AWarn:SendPunishmentsToPlayer( pl )
		
	elseif requestType == "write" then
		
		local pTable = net.ReadTable()
		AWarn.Punishments = pTable
		AWarn:SavePunishments()
	
	end
end )

function AWarn:SendPunishmentsToPlayer( pl )
	net.Start( "awarn3_networkpunishments" )
	net.WriteTable( AWarn.Punishments )
	
	if pl then
		net.Send( pl )
	else
		net.Broadcast()
	end
end

local PUNISHMENT = {}
PUNISHMENT.warnings = 3
PUNISHMENT.pType = "kick"
PUNISHMENT.pLength = nil
PUNISHMENT.pMessage = "AWarn: You were kicked for exceeding the warning threshold."
PUNISHMENT.sMessage = "%s was kicked for reaching a warning threshold."
AWarn:RegisterPunishment( PUNISHMENT )

local PUNISHMENT = {}
PUNISHMENT.warnings = 5
PUNISHMENT.pType = "kick"
PUNISHMENT.pLength = nil
PUNISHMENT.pMessage = "AWarn: You were kicked for exceeding the warning threshold."
PUNISHMENT.sMessage = "%s was kicked for reaching a warning threshold."
AWarn:RegisterPunishment( PUNISHMENT )

local PUNISHMENT = {}
PUNISHMENT.warnings = 7
PUNISHMENT.pType = "ban"
PUNISHMENT.pLength = 0
PUNISHMENT.pMessage = "AWarn: You have been permanently banned for exceeding the warning threshold."
PUNISHMENT.sMessage = "%s was banned permanently for reaching a warning threshold."
AWarn:RegisterPunishment( PUNISHMENT )


AWarn:LoadPunishments()