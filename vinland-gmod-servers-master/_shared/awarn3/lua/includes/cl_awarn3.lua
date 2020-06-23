AddCSLuaFile()
--[[
      __          __              ____  
     /\ \        / /             |___ \ 
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ < 
  / ____ \  /\  / (_| | |  | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/ 

	AWarn3 by Mr.President
]]


MsgC( AWARN3_CLIENT, "[AWarn3] ", AWARN3_WHITE, "AWarn3 is loading...\n" )

include( "includes/awarn3_localization.lua" )
include( "includes/sh_awarn3.lua" )
include( "includes/awarn3_concommands.lua" )
include( "includes/awarn3_permissions.lua" )
include( "includes/awarn3_vgui.lua" )

net.Receive( "awarn3_clientmessage", function()
	local message = net.ReadString()
	chat.AddText( AWARN3_WARNING , "[AWarn3] ", AWARN3_WHITE, message )
end )

net.Receive( "awarn3_warningmessage", function()

	local PlayerID = net.ReadString()
	local AdminID = net.ReadString()
	local WarningReason = net.ReadString()

	local pl = AWarn:GetPlayerFromID64( PlayerID ) or nil
	local admin = AWarn:GetPlayerFromID64( AdminID ) or nil
	
	local TARGET_COLOR 	= Color( 128,255,0 )
	local ADMIN_COLOR 	= Color( 128,255,0 )
	
	local plName = PlayerID
	local adminName = AdminID
	if IsValid( pl ) then plName = pl:GetName() end
	if IsValid( admin ) then adminName = admin:GetName() end
	
	local message = ""
	if LocalPlayer() == pl then
		message = ( AWarn.Localization:GetTranslation( "warnmessage1" ) ):format( adminName, WarningReason )
		chat.AddText( AWARN3_WARNING, "[AWarn3] ", AWARN3_WHITE, message )
		return
	end
	
	if LocalPlayer() == admin then
		message = ( AWarn.Localization:GetTranslation( "warnmessage2" ) ):format( plName, WarningReason )
		chat.AddText( AWARN3_WARNING, "[AWarn3] ", AWARN3_WHITE, message )
		return
	end
	message = ( AWarn.Localization:GetTranslation( "warnmessage3" ) ):format( plName, adminName, WarningReason )
	chat.AddText( AWARN3_WARNING, "[AWarn3] ", AWARN3_WHITE, message )
end )



net.Receive( "awarn3_chatmessagecolor", function()
	local messageContents = net.ReadTable()
	chat.AddText( AWARN3_CHATTAG, "[AWarn3] ", AWARN3_WHITE, unpack( messageContents ) )
end )

function AWarn:CreateWarningID( target_id, admin_id, reason )
	net.Start( "awarn3_createwarningid" )
	net.WriteString( target_id )
	net.WriteString( admin_id )
	net.WriteString( reason )
	net.SendToServer()
end

function AWarn:AddActiveWarning( target_id, amt )
	net.Start( "awarn3_addactivewarning" )
	net.WriteString( target_id )
	net.WriteInt( amt, 8 )
	net.SendToServer()
end

function AWarn:DeleteAllPlayerWarnings( target_pl )
	net.Start( "awarn3_deleteallplayerwarnings" )
	net.WriteString( target_pl )
	net.SendToServer()
end

function AWarn:SaveClientSettings()
	AWarn:CheckDirectory()
	local clientConfig = {}
	clientConfig.Colors = AWarn.Colors
	
	file.Write( "awarn3/client_configuration.txt", util.TableToJSON( clientConfig, true ) )
end

function AWarn:LoadClientSettings()
	if file.Exists( "awarn3/client_configuration.txt", "DATA" ) then
		local clientConfig = util.JSONToTable( file.Read( "awarn3/client_configuration.txt", "DATA" ) )
		AWarn.Colors = clientConfig.Colors
	else
		self:SaveClientSettings()
	end
end

AWarn:LoadClientSettings()