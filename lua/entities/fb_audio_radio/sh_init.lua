AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "Audio"
ENT.PrintName		= "Radio"
ENT.Author			= "Ghost"
ENT.Contact			= "Don't"
ENT.Purpose			= "Exemplar material"
ENT.Instructions	= "Use with care. Always handle with gloves."
ENT.Model = "models/props_lab/citizenradio.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Value = 10

if CLIENT then
 
surface.CreateFont("FRadio_ScreenFont",
	{
		font = "Roboto",
		size = 16,
		weight = 500,
		antialias = true,
		outline = false
	}
)
surface.CreateFont("FRadio_ScreenFontSmall",
	{
		font = "Roboto",
		size = 12,
		weight = 100,
		antialias = true,
		outline = false
	}
)
surface.CreateFont("FRadio_ScreenFontSmaller",
	{
		font = "Roboto",
		size = 9,
		weight = 100,
		antialias = true,
		outline = false
	}
)
 

 
function ENT:Play(url)
	
local pos = self:GetPos()
sound.PlayURL(url,
		"3d noblock",
		function(station,_,error)
			if IsValid(station) then
				station:SetPos(self:GetPos())
				station:Play()
				
				globalstation = station	
			end
			print(error)
	end)
	
end

function ENT:Pause()
	
	if IsValid(globalstation) then
		if globalstation:GetState() != GMOD_CHANNEL_PAUSED then
		globalstation:Pause()
		end
	end
	
end

function ENT:Unpause()
	
	if IsValid(globalstation) then
		if globalstation:GetState() == GMOD_CHANNEL_PAUSED then
			globalstation:Play()
		end		
	end
	
end

function ENT:Stop()
	
	if IsValid(globalstation) then
		globalstation:Stop()
		globalstation = nil
	end	
	
end
 
function ENT:GetTexts()
	local function CustomNiceTime(seconds)
		if ( seconds == nil ) then return "a few seconds" end

	if ( seconds < 60 ) then
		local t = math.floor( seconds )
		return "00:" .. t
	end

	if ( seconds < 60 * 60 ) then
		local t = math.floor( seconds / 60 )
		local tt = math.floor( seconds / 60 ) - seconds
		return t .. ":" .. tt
	end

	if ( seconds < 60 * 60 * 24 ) then
		local t = math.floor( seconds / (60 * 60) )
		return t
	end

	if ( seconds < 60 * 60 * 24 * 7 ) then
		local t = math.floor( seconds / (60 * 60 * 24) )
		return t
	end
	
	if ( seconds < 60 * 60 * 24 * 7 * 52 ) then
		local t = math.floor( seconds / (60 * 60 * 24 * 7) )
		return t
	end

	local t = math.floor( seconds / (60 * 60 * 24 * 7 * 52) )
	return t 
end

	
	if type(globalstation) != "IGModAudioChannel" then return "ERROR", "XX:XX / XX:XX" end
	if !IsValid(globalstation) then
		return "Not playing", "--:-- / --:--"
	end
	if IsValid(globalstation) then
		local a = globalstation:GetState()
		if a == GMOD_CHANNEL_STALLED then
			return "Buffering...", "--:-- / --:--"
		elseif a == GMOD_CHANNEL_STOPPED then
			return "Not playing", "--:-- / --:--"
		elseif a == GMOD_CHANNEL_PLAYING then
			return "Playing", CustomNiceTime(math.Round(globalstation:GetTime()/globalstation:GetPlaybackRate())) .. " / ??:??"
		elseif a == GMOD_CHANNEL_PAUSED then
			return "Paused", CustomNiceTime(math.Round(globalstation:GetTime()/globalstation:GetPlaybackRate())) .. " / ??:??"
		end
			
	end	
end

--[[---------------------------------------------------------
   Name: Draw
   Purpose: Draw the model in-game.
   Remember, the things you render first will be underneath!
---------------------------------------------------------]]
function ENT:Draw()
      -- We want to override rendering, so don't call baseclass.
                                  -- Use this when you need to add to the rendering.
    self:DrawModel()       -- Draw the model.

	local pos = self:GetPos()
	local ang = self:GetAngles()
	local texttop,textbottom = self:GetTexts()
	local curfont = "FRadio_ScreenFont"
	ang:RotateAroundAxis(ang:Right(),90)
	ang:RotateAroundAxis(ang:Forward(),180)
	ang:RotateAroundAxis(ang:Up(),-90)
	
	cam.Start3D2D(pos+ang:Up()*9,ang,0.15)
		local off = -104
		local textcenter = (-42+120)/4.3
		draw.RoundedBox(6,
			-42, off,
			120, 32,
			color_white)
		draw.DrawText(
		texttop,curfont,
		textcenter,off + (16-draw.GetFontHeight(curfont)),Color(0,0,0),TEXT_ALIGN_CENTER)
		draw.DrawText(
		textbottom,"FRadio_ScreenFont",
		textcenter,off+14,Color(0,0,0),TEXT_ALIGN_CENTER)
	
	cam.End3D2D()


end

end


function ENT:Initialize()
	
 	if CLIENT then globalstation = nil elseif SERVER then

	self:SetModel( self.Model )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
 	
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
end
	
	
end
 
if SERVER then
 
function ENT:Use( activator, caller )

    return
end
 
function ENT:Think()
    if IsValid(self) then
    	self:SetModel(self.Model)
    end
 
end

function ENT:Play(url)
	
	for k,v in pairs(player.GetHumans()) do
			v:SendLua([[Entity(]] .. self:EntIndex() .. [[):Play("]] .. url .. [[")]])
	end
	
end
function ENT:Stop()
	
	for k,v in pairs(player.GetHumans()) do
			v:SendLua([[Entity(]] .. self:EntIndex() .. [[):Stop()]])
	end
	
end
function ENT:Pause()
	
	for k,v in pairs(player.GetHumans()) do
			v:SendLua([[Entity(]] .. self:EntIndex() .. [[):Pause()]])
	end
	
end
function ENT:Unpause()
	
	for k,v in pairs(player.GetHumans()) do
			v:SendLua([[Entity(]] .. self:EntIndex() .. [[):Unpause()]])
	end
	
end
function ENT:OnRemove()
	for k,v in pairs(player.GetHumans()) do
			v:SendLua([[if IsValid(globalstation)then globalstation:Stop()end]])
	end	
end
end
