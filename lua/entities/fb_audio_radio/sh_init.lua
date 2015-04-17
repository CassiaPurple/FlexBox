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
ENT.Model = "models/props/cs_office/tv_plasma.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Value = 10
ENT.URL = ""
ENT.Range = 1500
ENT.Volume = .7
ENT.Levels = {0,0}
ENT.Loop = false

if CLIENT then
 
surface.CreateFont("FRadio_ScreenFont",
	{
		font = "Roboto",
		size = 24,
		weight = 700,
		antialias = true,
		outline = false
	}
)
surface.CreateFont("FRadio_ScreenFontSmall",
	{
		font = "Roboto",
		size = 16,
		weight = 100,
		antialias = true,
		outline = false
	}
)
surface.CreateFont("FRadio_ScreenFontSmaller",
	{
		font = "Roboto",
		size = 12,
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
if !globalstations then globalstations = {} 
else
	self:Stop()
end

self.URL = url

sound.PlayURL(url,
		"noblock",
		function(station,_,error)
			if IsValid(station) then

				station:SetVolume(self.Volume)
				if self.Loop then station:EnableLooping(true) end
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
	local fft = {}

	ang:RotateAroundAxis(ang:Right(),90)
	ang:RotateAroundAxis(ang:Forward(),180)
	ang:RotateAroundAxis(ang:Up(),-90)
	
	cam.Start3D2D(pos+ang:Up()*9.2,ang,0.15)
		local off = -350
		local textheight = -500
		local ee = -92
		local textcenter = ee / 8
		local playproxy = 0
		local e,f = 0,0
		if !globalstations then return end
		local globalstation = globalstations[self:EntIndex()]
		if IsValid(globalstation) then

		color_dim =
			HSVToColor((RealTime()*100)%360,1,0.4)
		if globalstation:GetState() != GMOD_CHANNEL_PLAYING and globalstation:GetState() != GMOD_CHANNEL_PAUSED then
			color_dim = color_black
		end
		playproxy = math.sin(RealTime()*6%360)*6

		if globalstation:GetState() != GMOD_CHANNEL_PLAYING then
			playproxy = 0
		end


		local moff = -off
		globalstation:FFT(fft,FFT_256)
		
		local xx = {}
		for i = 1, #fft, 8 do
			table.insert(xx,24+(moff*2.5*fft[i]/1.15))
		end
		globallevels[self:EntIndex()] = xx
		e,f = globalstation:GetLevel()

	else

		color_dim = black
		globallevels[self:EntIndex()] =  {0,0}
		
	end



	
	
	local bouncey = -30
	local xorigin = textcenter-16-16-16
	
	local color_rainbow = HSVToColor((RealTime()*100)%360,1,1)
	local glevel = globallevels[self:EntIndex()]

	
	if !color_dim then color_dim = Color(0,0,0) end

		draw.RoundedBox(6,
			ee*3, off,
			552, 320,
			color_dim)


		for i = 1, (#glevel) do
		if glevel[i] == nil then break end
		if i == #glevel then continue end
		draw.RoundedBox(0,
			tonumber(xorigin*(i/3)), bouncey,
			16, 
			math.Clamp(
			tonumber(-glevel[i]*e),
			-220,0)
			,
			color_rainbow)
		end
		for i = (#glevel), 1, -1 do

		if glevel[i] == nil then break end
		if i == #glevel then continue end
		draw.RoundedBox(0,
			tonumber(xorigin*(-i/3)-18), bouncey,
			16, tonumber(-glevel[i]*f),
			color_rainbow)
		end


		
		draw.DrawText(
		texttop,curfont,
		textcenter,textheight/2.5 - 4 + (16-draw.GetFontHeight(curfont))+playproxy,color_white,TEXT_ALIGN_CENTER)
		draw.DrawText(
		textbottom,"FRadio_ScreenFont",
		textcenter,textheight/2.5+4+14+playproxy,color_white,TEXT_ALIGN_CENTER)
		
		draw.DrawText(
			"FRadio v2",
			"FRadio_ScreenFontSmall",
			ee*3,off,color_white,TEXT_ALIGN_LEFT)

	cam.End3D2D()


end

end


function ENT:Initialize()
	
	
 	if CLIENT then 
 	
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
    	if !globalstations then return end
    	local globalstation = globalstations[self:EntIndex()]
    	local range = self.Range
    	local volmult = tonumber(self.Volume)
    	if volmult == nil then volmult = 0 end
    	local vol = math.Clamp((range-self:GetPos():Distance(LocalPlayer():GetPos()))/range,0,1)*math.Clamp(volmult,0,1)
	

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