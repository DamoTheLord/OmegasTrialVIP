GONT = GONT or {} -- GLOBAL OMEGA NETWORK TABLE DO NOT REMOVE
local cfg = GONT.VIPTrial

local function checkUserNeedRemoving( ply )
    if !sql.TableExists( cfg.TableName ) then return end
    if ply:GetUserGroup() != cfg.VIPRole then return end
    local curtime = os.time()
    local sqlQuery = sql.Query( "SELECT * FROM "..cfg.TableName.." WHERE SteamID='"..ply:SteamID().."';" )
    for id, row in pairs( sqlQuery ) do
        if curtime >= tonumber(row['TimeVIPExp']) then
            olibChatRegularMessage(cfg.ChatPrefix, cfg.ChatVIPExpired, ply)
            RunConsoleCommand("ulx", "adduser", ply:Name(), cfg.ReturnRole)
        else
            print('You have '..curtime-tonumber(row['TimeVIPExp'])..' seconds left on your trial VIP')
        end
    end
end
local function VIPExists(ply)
    localsqlQuery1 = sql.Query( "SELECT * FROM "..cfg.TableName.." WHERE SteamID='"..ply:SteamID().."';" )
    if sqlQuery1 != true then
        sql.Query( "INSERT INTO "..cfg.TableName.."( SteamID, Used, TimeVIPExp ) VALUES( '"..ply:SteamID().."', 0, 0 )" )
    end
    local sqlQuery = sql.Query( "SELECT * FROM "..cfg.TableName.." WHERE SteamID='"..ply:SteamID().."';" )
    for id, row in pairs( sqlQuery ) do
        if row['Used'] == '1' then return true else return false end
    end
end
local function RedeemVIP( ply )
    if ply:IsAdmin() then olibChatRegularMessage(cfg.ChatPrefix, 'Fuck off Seth.', ply) return end
    --[[if ply:IsAdmin() and cfg.PsCompatible == true then
        ply:PS_GivePoints(cfg.PsPointsForNonUsers)
        return
    end]]
    --[[if cfg.BlacklistEnabled and table.HasValue( cfg.BlacklistRanks, ply:GetUserGroup() ) then
        print('Blacklisted Rank!')
        return
    end]]
    if !sql.TableExists( cfg.TableName ) then
        sql.Query( "CREATE TABLE "..cfg.TableName.."( SteamID TEXT, Used INTEGER, TimeVIPExp TEXT )" )
    end
    local hours = ply:GetUTimeTotalTime() / 3600
    if !VIPExists( ply ) and hours >= cfg.HoursMinimum then
        local exptime = tostring(os.time()+cfg.ExpirySeconds)
        olibChatRegularMessage(cfg.ChatPrefix, cfg.ChatRedeemVIP, ply)
        sql.Query( "UPDATE "..cfg.TableName.." SET Used=1 WHERE SteamID='"..ply:SteamID().."'" )
        sql.Query( "UPDATE "..cfg.TableName.." SET TimeVIPExp='"..exptime.."' WHERE SteamID='"..ply:SteamID().."'" )
        RunConsoleCommand("ulx", "adduser", ply:Name(), cfg.VIPRole)
        timer.Create( tostring(ply:SteamID64())..'OMEGAVIPTRIAL', cfg.ExpirySeconds, 1, function()
            if !IsValid( ply ) then return end
            checkUserNeedRemoving(ply)
        end )
    else
        olibChatRegularMessage(cfg.ChatPrefix, cfg.ChatCannotRedeem, ply)
    end
end
concommand.Add( "vipfreetrial", function( ply, cmd, args )
    RedeemVIP(ply)
end )
concommand.Add( "droptable", function( ply, cmd, args )
    if !ply:IsAdmin() then return end
    if !sql.TableExists( args[1] ) then
        print('There was no table to drop')
    else
        print('Table: '..args[1]..' dropped!')
        sql.Query( "DROP TABLE "..args[1] )
    end
end )
hook.Add( "PlayerSay", "PlayerSayExample", function( ply, text, team )
	-- Make the chat message entirely lowercase
    if ( string.sub( string.lower( text ), 1, 9 ) == "!claimvip" ) then
        RedeemVIP(ply)
		return "" .. string.sub( text, 10 )
	end
end )
timer.Create('OmegaVIPCheck', 60, 0, function()
    if timer.Exists( "OmegaVIPCheck" ) then return end
    for k, v in pairs( player.GetAll() ) do
        checkUserNeedRemoving(v)
    end
end)
