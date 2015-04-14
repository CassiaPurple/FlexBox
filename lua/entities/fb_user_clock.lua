-- World clock
-- by user4992
--
-- Timezones crudely set, no automatic procedure in place
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "user's stuff"
ENT.PrintName		= "World Clock"
ENT.Author			= "user4992"
ENT.Contact			= "nno"
ENT.Purpose			= "nil"
ENT.Instructions	= "nil"

if CLIENT then
 
local function GetTime( component )
	local ostime = os.date("!*t")
	local ret = ostime[component]
	return tonumber(ret)  
end

local function FullTime( timezone , useS )

 	local Hour = GetTime("hour") + timezone
 	if Hour < 0 then Hour = Hour + 24 end
 	if Hour > 23 then Hour = Hour - 24 end

	local Minute = GetTime("min")
	local Second = GetTime("sec")
 	
 	if Hour < 10 then H = "0"..Hour else H = Hour end
 	if Minute < 10 then M = "0"..Minute else M = Minute end
 	if Second < 10 then S = "0"..Second else S = Second end
 		
 		if useS == true then
    return(H ..":".. M ..":".. S) 
	else  
	return(H ..":".. M ) 	
	end

 	
 	end

local function DrawTZ( owner , tz)

	local textcolor = Color(160,140,0,255)

	local offset = Vector(0,0,TZIndex*6 + CIndex * 12)

	TZIndex = TZIndex -1
	
	cam.Start3D2D(Pos + base + offset + Ang1:Up() * 0, Ang1, 0.4)
		draw.DrawText(FullTime(tz , false), "CloseCaption_Normal", 18, 0, textcolor, TEXT_ALIGN_LEFT)
		draw.DrawText(owner, "CloseCaption_Normal", 8, 0, textcolor, TEXT_ALIGN_RIGHT)
	cam.End3D2D()
	
	
end

local function DrawCenter(  )

	local textcolor = Color(160,140,0,255)

	local offset = Vector(0,0, TZIndex*6 + CIndex * 12 )
	
	
	CIndex = CIndex -1


	cam.Start3D2D(Pos + base + offset + Ang1:Up() * 0, Ang1, 0.7)
		draw.DrawText(FullTime(0 , true), "CloseCaption_Normal", -3, 0, textcolor, TEXT_ALIGN_CENTER)
	cam.End3D2D()
	
	
end


function ENT:Draw()
 
    self:DrawModel()      
	Ang1 = self:GetAngles() 
	Pos = self:GetPos()
	
--    Ang1:RotateAroundAxis( Ang1:Right() , 0 )   
    Ang1:RotateAroundAxis( Ang1:Up() , 180 )
 	Ang1:RotateAroundAxis( Ang1:Forward() , 90 ) 	

	cam.Start3D2D(Pos + Ang1:Up() * 0, Ang1, 0.4)
	draw.RoundedBox( 1, -70, -220, 128, 183, Color(0,0,0,200) ) 
	cam.End3D2D()

	base = Vector(0,0,85) 
 	TZIndex = 0
 	CIndex = 0
 
	DrawTZ( "Flex", -6) 
	DrawTZ( "KaosHeaven", -5)
	DrawTZ( "Raspy", -5)
	DrawTZ( "SeaMelon", -4)
	DrawTZ( "görma", -4)
	DrawTZ( "user4992", -3)
	DrawCenter( )
	DrawTZ( "Ghost", 0)
	DrawTZ( "Henke", 2)
	DrawTZ( "Fa$ter", 2)

	
end

elseif SERVER then

function ENT:Initialize()
 
	self:SetModel( "models/lt_c/holo_wall_unit.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )         
    
    self:SetBodygroup(1,1)
    
--        local phys = self:GetPhysicsObject()
--	if (phys:IsValid()) then
--		phys:Wake()
--	end

	
end
 
function ENT:Use( activator, caller )
    return
end
 
function ENT:Think()

end

end


