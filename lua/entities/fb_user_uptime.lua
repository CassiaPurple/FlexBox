-- Uptime counter
-- by user4992
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "user's stuff"
ENT.PrintName		= "Uptime counter"
ENT.Author			= "user4992"
ENT.Contact			= "nno"
ENT.Purpose			= "nil"
ENT.Instructions	= "nil"

if CLIENT then
 
local function GetUptime(  )
 	
--	time = tonumber( RealTime() )  
	OurTime = CurTime()

 	local Hour = math.floor( OurTime / 3600 )

	local Minute = math.floor( (OurTime / 60) - (Hour*60) )
	local Second = math.floor( OurTime - (Minute*60) - (Hour*3600) )
 	
 	if Hour < 10 then H = "0"..Hour else H = Hour end
 	if Minute < 10 then M = "0"..Minute else M = Minute end
 	if Second < 10 then S = "0"..Second else S = Second end
    return(H ..":".. M ..":".. S) 

 	end

function ENT:Draw()

   self:DrawModel()       
	Ang1 = self:GetAngles() --+ Angle(0, 90, 90)
	Pos = self:GetPos()
	
	local index
	index = 0

--  Ang1:RotateAroundAxis( Ang1:Right() , 0 )   
    Ang1:RotateAroundAxis( Ang1:Up() , 90 )
 	Ang1:RotateAroundAxis( Ang1:Forward() , 90 ) 
--	cam.Start3D2D(Pos + Ang1:Up() * 0, Ang1, 0.4)
--	draw.RoundedBox( 1, -70, -220, 128, 183, Color(0,0,0,150) ) 
--	cam.End3D2D()
 
 	local textcolor = Color(0,0,0,255)

	local base = Vector(1,0,11)

	cam.Start3D2D(Pos + base + Ang1:Up() * 0, Ang1, 0.7)
		draw.DrawText(GetUptime(), "CloseCaption_Bold", 1, 0, textcolor, TEXT_ALIGN_CENTER)
	cam.End3D2D()
	
	cam.Start3D2D(Pos + base + Ang1:Up() * 0, Ang1, 0.2)
		draw.DrawText("Uptime", "CloseCaption_Bold", 100, 60, textcolor, TEXT_ALIGN_CENTER)
	cam.End3D2D()
	
end

elseif SERVER then

function ENT:Initialize()
 
	self:SetModel( "models/lt_c/holograms/shields.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )     
	self:SetMoveType( MOVETYPE_FLY )   
	self:SetSolid( SOLID_BBOX )        
    
    self:SetModelScale(3)
    
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

