-- Scoreboard
-- by user4992


ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "user's stuff"
ENT.PrintName		= "Scoreboard"
ENT.Author			= "user4992"
ENT.Contact			= "nno"
ENT.Purpose			= "nil"
ENT.Instructions	= "nil"

if CLIENT then
 
  local function trimname(name) 
  	name = name:gsub(":.+:","") 
  	name = name:gsub("<.+=.+>","") 
  	name = name:gsub("%^%d+","") 
  	name = string.Trim(name, " ") 	return name end 

 local function	makename(ply)
 	local a,b = trimname(ply:Nick()), trimname(ply:GetRealName())
 		if a == b then return a else return (a .. " / " .. b)
 			end
	end

 function GetPlayerInfo( me )

 	Players = player.GetAll()
 	
 	
 	
    for k,v in pairs(Players) do

		DrawPlayerInfo( v , k , me )

	end
	
	
end

function PrettyRank( rank )
	
	if rank == "owners" then return("OWN")
	elseif rank == "developers" then return("DEV")
	elseif rank == "admins" then return("ADM")
	elseif rank == "moderators" then return("MOD")
	elseif rank == "respected" then return("RSP")
	elseif rank == "players" then return("PLY")
	else return("???")
	end 
	
	
end

function GetClientCountry( index , ent)
	
	return ent:GetNWString( "Country"..tostring(index) )
	
end

function GetClientTimer( index , ent )
	
	return ent:GetNWString( "CTimer"..tostring(index) )

end

function DrawPlayerInfo(player , ID , myself)

	local BGColor = Color(50,50,50,150)
	
	TZIndex = TZIndex - 1
	PCount = PCount + 1


	PSize = 6
	local BaseOffset = tonumber(PCount * (PSize))
	local BaseVec = Vector(0,0,13 - BaseOffset) 
	local Compensation = Vector(0,0, #Players *PSize/2) 

--	FinalVector = Pos + offset
	FinalVector = Pos + BaseVec + Compensation
	
	RedColor = Color(255,50,50,255)
	BlueColor = Color(50,50,255,255)

	local PlayerID = ID
	name = makename(player)
	
		
		
	RankColor = team.GetColor(player:Team())
	usertime = tonumber(player:GetUTimeTotalTime())
	money = tonumber(player:GetMoney())
	rank = player:GetUserGroup()
	frags = player:Frags()
	deaths = player:Deaths()
	IsAFK = player:IsAFK()

	
	if !player:IsBot() then
	TimeC = tonumber( GetClientTimer( player:SteamID() , myself ) )

	if isnumber(TimeC) then	
	CHour = string.Right( "00".. math.floor(TimeC / 3600) ,2 )
	CMin = string.Right( "00".. math.floor(TimeC / 60) - CHour*60 ,2)
	CSec = string.Right( "00".. math.floor(TimeC) - CMin*60 ,2)
	PrettyTime = CHour ..":".. CMin 
	
	else
	PrettyTime = "--:--"	
	end

	ping = tonumber(player:Ping()).."ms"

	else
	PrettyTime = "--:--"
	ping = "BOT"
	end
    Country =  GetClientCountry( player:SteamID() , myself )

--	Say(TimeC)

	NameStr = string.sub( name, 0 , 75)
	Hours = math.round(usertime/3600 ,0)
	
	
	RankStr = PrettyRank( rank )
	
	Frag000 = "000"..math.abs(frags)
	FragStr = string.Right( Frag000, 3)
	if frags < 0 then FragStr = "-"..FragStr end

	Death000 = "000"..math.abs(deaths)
	DeathStr = string.Right( Death000, 3)
	
	Health = player:Health()
	HPStr =  string.Right( "000"..Health , 3)

	cam.Start3D2D( FinalVector , Ang1, 0.2)

		draw.RoundedBox( 0, -285, 1, 567, 1, BGColor ) 

		draw.RoundedBox( 1, -285, 4, 3, 25, RankColor ) 
		draw.RoundedBox( 1, 279, 4, 3, 25, RankColor ) 

		draw.DrawText(Hours.."h", "CloseCaption_Normal", -249, 0, RankColor, TEXT_ALIGN_RIGHT)
		draw.DrawText(RankStr, "CloseCaption_Normal", -249, 15, RankColor, TEXT_ALIGN_RIGHT)
		
		draw.DrawText(NameStr, "CloseCaption_Normal", -243, 0, RankColor, TEXT_ALIGN_LEFT)

		draw.DrawText(FragStr.."K", "CloseCaption_Normal", -243, 15, RankColor, TEXT_ALIGN_LEFT)
		draw.DrawText(DeathStr.."D", "CloseCaption_Normal", -203, 15, RankColor, TEXT_ALIGN_LEFT)

		if IsAFK == true then
		draw.DrawText(" AFK", "CloseCaption_Normal", -170, 15, BlueColor, TEXT_ALIGN_LEFT)
		else
		if Health > 0 then
		draw.DrawText("+"..Health, "CloseCaption_Normal", -170, 15, RankColor, TEXT_ALIGN_LEFT)
		else
		draw.DrawText("DEAD", "CloseCaption_Normal", -170, 15, RedColor, TEXT_ALIGN_LEFT)
		end
		end
		draw.DrawText(money.."$", "CloseCaption_Normal", 230, 0, RankColor, TEXT_ALIGN_RIGHT)

		draw.DrawText(Country , "CloseCaption_Normal", 230, 15, RankColor, TEXT_ALIGN_RIGHT)

		
		draw.DrawText(ping, "CloseCaption_Normal", 275, 0, RankColor, TEXT_ALIGN_RIGHT)

		draw.DrawText(PrettyTime, "CloseCaption_Normal", 275, 15, RankColor, TEXT_ALIGN_RIGHT)


		
	cam.End3D2D()
	
	
end

--[[---------------------------------------------------------
   Name: Draw
   Purpose: Draw the model in-game.
   Remember, the things you render first will be underneath!
---------------------------------------------------------]]
function ENT:Draw()
    -- self.BaseClass.Draw(self)  -- We want to override rendering, so don't call baseclass.
                                  -- Use this when you need to add to the rendering.
    self:DrawModel()       -- Draw the model.
	Ang1 = self:GetAngles() --+ Angle(0, 90, 90)
	Pos = self:GetPos()
	
	
	local LineColor = Color(50,50,50,50)

--    Ang1:RotateAroundAxis( Ang1:Right() , 0 )   
    Ang1:RotateAroundAxis( Ang1:Up() , 90 )
 	Ang1:RotateAroundAxis( Ang1:Forward() , 90 )    
    
	cam.Start3D2D(Pos + Ang1:Up() * 0, Ang1, 0.4)
	draw.RoundedBox( 1, -143, -119, 285, 200, Color(0,0,0,245) ) 
	
	draw.RoundedBox( 1, -124, -114, 1, 190, LineColor ) 
	draw.RoundedBox( 1, 116, -114, 1, 190, LineColor ) 
	
	cam.End3D2D()

	TZIndex = 0
	PCount = 0
	PSize = 6

	offset = Vector(0,0,TZIndex*PSize)

	GetPlayerInfo( self )

end

elseif SERVER then

function ENT:Initialize()
 
	self:SetModel( "models/lt_c/holograms/fwd_sensors.mdl" )
	self:PhysicsInit( SOLID_BBOX )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_FLY )   -- after all, gmod is a physics
	self:SetSolid( SOLID_BBOX )         -- Toolbox
    
    self:SetBodygroup(1,1)
    self:SetModelScale(5)
    --local phys = self:GetPhysicsObject()
	--if (phys:IsValid()) then
	--		phys:Wake()
	--end

	
	GetCountries( self )

end

 	function GetCountries( ent )

		if !IsValid(Countries) then
		Countries = {}
		end
	
		for k,v in pairs(player.GetAll()) do

			if IsValid(ent) and IsValid(v) then
			CurID = v:SteamID()
--			if IsValid(ent) and IsValid( player:GetByID( k ) ) then
--			CurID =  player:GetByID( k )
			GeoData = v:GeoIP()
			Countries[ CurID ] = GeoData.country_name --  GeoIP.Get( CurID:IP()).country_name

			local NWName = "Country" .. tostring( v:SteamID() )
			
			ent:SetNWString( NWName , Countries[ CurID ]  )
			end

		end
end

 function GetConnectedTime( ent )

		if !IsValid(CTimers) then
		CTimers = {}
		end
	
		for k,v in pairs(player.GetAll()) do

--			if IsValid(ent) and IsValid(v) then
--			CurID = v.SteamID()
			if IsValid(ent) and IsValid( v ) then
			CurID =  v:SteamID()
			CTimers[ CurID ] = v:TimeConnected() 

			local NWName = "CTimer" .. tostring( v:SteamID() )
			
			ent:SetNWString( NWName , CTimers[ CurID ]  )
			end

		end

end

hook.Add( "PlayerConnect" , "CountryWatcher" , function() GetCountries(self) end)

function ENT:Use( activator, caller )
    return
end
 
function ENT:Think()
    -- We don't need to think, we are just a prop after all!
    GetConnectedTime( self )
end

end

