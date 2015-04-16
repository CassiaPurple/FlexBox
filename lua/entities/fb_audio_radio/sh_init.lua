AddCSLuaFile()
easylua.StartEntity("fb_audio_radio")

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "Audio"
ENT.PrintName		= "Radio"
ENT.Author			= "Ghost"
ENT.Contact			= "Don't"
ENT.Purpose			= "Exemplar material"
ENT.Instructions	= "Use with care. Always handle with gloves."
ENT.Model = "models/props/de_inferno/tv_monitor01.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Value = 10
ENT.URL = ""
ENT.Range = 1500
ENT.Volume = .7
ENT.Levels = {0,0}

if CLIENT then
 
surface.CreateFont("FRadio_ScreenFont",
	{
		font = "Roboto",
		size = 18,
		weight = 700,
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
 

function ENT:SetRange(range)
	range = tonumber(range)
	if range == nil then return end
	self.Range = range
end

function ENT:SetVolume(vol)
	vol = tonumber(vol)
	if vol == nil then vol = 0 end
	self.Volume = vol
end


function ENT:Play(url)
self:Stop()
self.URL = url

sound.PlayURL(url,
		"noblock",
		function(station,_,error)
			if IsValid(station) then

				station:Play()
				
				globalstations[self:EntIndex()] = station	
			end
			if error != nil then
			print(error)
			end
	end)

end

function ENT:Pause()
	local globalstation = globalstations[self:EntIndex()]
	if IsValid(globalstation) then
		if globalstation:GetState() != GMOD_CHANNEL_PAUSED then
		globalstation:Pause()
		end
	end
	
end

function ENT:Unpause()
	local globalstation = globalstations[self:EntIndex()]
	if IsValid(globalstation) then
		if globalstation:GetState() == GMOD_CHANNEL_PAUSED then
			globalstation:Play()
		end		
	end
	
end

function ENT:Stop()
	local globalstation = globalstations[self:EntIndex()]
	if IsValid(globalstation) then
		globalstation:Stop()
		globalstation = nil
	end	
	
end
 
function ENT:GetTexts()

	local globalstation = globalstations[self:EntIndex()]
	if type(globalstation) != "IGModAudioChannel" then return "Not playing", "--:-- / --:--" end
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
			return "Playing", string.ToMinutesSeconds(math.Round(globalstation:GetTime()/globalstation:GetPlaybackRate())) 
			.. " / "
			.. string.ToMinutesSeconds(math.Round(globalstation:GetLength()/globalstation:GetPlaybackRate()))
		elseif a == GMOD_CHANNEL_PAUSED then
			return "Paused", string.ToMinutesSeconds(math.Round(globalstation:GetTime()/globalstation:GetPlaybackRate())) 
			.. " / "
			.. string.ToMinutesSeconds(math.Round(globalstation:GetLength()/globalstation:GetPlaybackRate()))
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
	local color_dim

	ang:RotateAroundAxis(ang:Right(),90)
	ang:RotateAroundAxis(ang:Forward(),180)
	ang:RotateAroundAxis(ang:Up(),-90)
	
	cam.Start3D2D(pos+ang:Up()*10.467,ang,0.15)
		local off = -60
		local ee = -92
		local textcenter = ee / 4.5
		local playproxy = 0
		local globalstation = globalstations[self:EntIndex()]
		if IsValid(globalstation) then
		local levels_l,levels_r 
		color_dim =
			HSVToColor((RealTime()*100)%360,1,0.4)
		if globalstation:GetState() != GMOD_CHANNEL_PLAYING and globalstation:GetState() != GMOD_CHANNEL_PAUSED then
			color_dim = color_black
		end
		playproxy = math.sin(RealTime()*6%360)*6

		if globalstation:GetState() != GMOD_CHANNEL_PLAYING then
			playproxy = 0
		end
		levels_l,levels_r = globalstation:GetLevel()

		local moff = -off
		globallevels[self:EntIndex()] = {moff*1.7*levels_r,moff*1.7*levels_l}
	else

		color_dim = black
		globallevels[self:EntIndex()] =  {0,0}
		
	end



	local x,y = globallevels[self:EntIndex()][1],globallevels[self:EntIndex()][2]
	x,y = -x,-y
	local bouncey = -off - 18
	local color_rainbow = HSVToColor((RealTime()*100)%360,1,1)
	if !color_dim then color_dim = Color(0,0,0) end

		draw.RoundedBox(6,
			ee, off,
			146, -off*1.7,
			color_dim)


		draw.RoundedBox(0,
			textcenter+2, bouncey,
			16, x,
			color_rainbow)
		draw.RoundedBox(0,
			textcenter+6+16, bouncey,
			16, x*0.75,
			color_rainbow)
		draw.RoundedBox(0,
			textcenter+(5+16)*2, bouncey,
			16, x*0.5,
			color_rainbow)

		draw.RoundedBox(0,
			textcenter-18, bouncey,
			16, y,
			color_rainbow)

		draw.RoundedBox(0,
			textcenter-18 - 4 - 16, bouncey,
			16, y*0.75,
			color_rainbow)
		draw.RoundedBox(0,
			textcenter-18 - 4 - 16 - 4 - 16, bouncey,
			16, y*0.5,
			color_rainbow)

		
		draw.DrawText(
		texttop,curfont,
		textcenter,off/2.5 + (16-draw.GetFontHeight(curfont))+playproxy,color_white,TEXT_ALIGN_CENTER)
		draw.DrawText(
		textbottom,"FRadio_ScreenFont",
		textcenter,off/2.5+14+playproxy,color_white,TEXT_ALIGN_CENTER)
		
		draw.DrawText(
			"FRadio v1b",
			"FRadio_ScreenFontSmall",
			ee,off,color_white,TEXT_ALIGN_LEFT)

	cam.End3D2D()


end

end


function ENT:Initialize()
	
	
 	if CLIENT then 
 	if #ents.FindByClass("fb_audio_radio") > 1 then return end
 	if globalstations then
 		for k,v in pairs(globalstations) do
 			if IsValid(v) then v:Stop() v = nil end
		end
		
		
	end
	globalstations = {}
 	if globallevels then
 		for k,v in pairs(globallevels) do
 			v = nil 
		end
		
		
	end
	globallevels = {}	
 elseif SERVER then

	self:SetModel( self.Model )
	self:SetModelScale(1.5)
	self:PhysicsInit( SOLID_BBOX )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_BBOX )         -- Toolbox
 	
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
 
end
function ENT:Think()
	if SERVER then
    if IsValid(self) then
    	self:SetModel(self.Model)
    end
    elseif CLIENT then
    	local globalstation = globalstations[self:EntIndex()]
    	local range = self.Range
    	local volmult = tonumber(self.Volume)
    	if volmult == nil then volmult = 0 end
    	local vol = math.Clamp((range-self:GetPos():Distance(LocalPlayer():GetPos()))/range,0,1)*math.Clamp(volmult,0,1)
 	if IsValid(globalstation) then


	else
		
	end
	

    	if IsValid(globalstation) then
    		globalstation:SetVolume(vol)

		end


		
	end
 
end
if SERVER then

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
function ENT:SetRange(range)
	for k,v in pairs(player.GetHumans()) do
			v:SendLua([[Entity(]] .. self:EntIndex() .. [[):SetRange(]] .. tonumber(range) .. [[)]])
	end
end

function ENT:OnRemove()
	for k,v in pairs(player.GetHumans()) do
			v:SendLua([[if IsValid(globalstations]] .. "[" .. self:EntIndex() .. "]" .. [[)then globalstations]] .. "[" .. self:EntIndex() .. "]" .. [[:Stop()end]])
	end	
end


end
easylua.EndEntity()