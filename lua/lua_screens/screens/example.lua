ENT.Width=100
ENT.Height=100
ENT.Scale=0.2

if SERVER then return end

function SCREEN:create( ent )end

ENT.Draw3D2D=function(self,wide,tall)
	draw.RoundedBox(0,0,0,wide,tall,Color(0,0,0,200))
	draw.DrawText("Sample Text","DermaLarge",wide/2,tall/2,color_white)
end


function ENT:OnMouseClick(...)
	--Stuff for use key goes here.
end
