AddCSLuaFile()
easylua.StartEntity("fb_flex_radio")

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "Audio"
ENT.PrintName		= "Flex's Radio"
ENT.Author			= "Flex"
ENT.Instructions	= "Don't put in water. Even if it's a suicide attempt."
ENT.Model = "models/hunter/plates/plate1x2.mdl"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Value = 10
ENT.URL = ""
ENT.Range = 1500
ENT.Levels = {0,0}
ENT.AdminOnly = true
ENT.Rainbow = false

if CLIENT then

surface.CreateFont("FRadio_ScreenFont",
	{
		font = "Roboto",
		size = 18,
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
surface.CreateFont("FRadio_ScreenFontBig",
	{
		font = "Roboto",
		size = 32,
		weight = 100,
		antialias = true,
		outline = false
	}
)




function ENT:Play(url)
self.URL = url
if !string.find(url:lower(),".ogg",1,true) then
local pos = self:GetPos()
sound.PlayURL(url,
		"3d noblock",
		function(station,_,error)
			if IsValid(station) then

				station:SetPos(self:GetPos())
				station:Play()

				globalstations[self:EntIndex()] = station
			end
			print(error)
	end)

else
sound.PlayURL(url,
		"noblock",
		function(station,_,error)
			if IsValid(station) then

				station:Play()

				globalstations[self:EntIndex()] = station
			end
			print(error)
	end)

end

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
			return "Playing: "..self:GetSongName(), string.ToMinutesSeconds(math.Round(globalstation:GetTime()/globalstation:GetPlaybackRate())) .. " / " .. (string.ToMinutesSeconds(math.Round(globalstation:GetLength())) or "00:00")
		elseif a == GMOD_CHANNEL_PAUSED then
			return "Paused", string.ToMinutesSeconds(math.Round(globalstation:GetTime()/globalstation:GetPlaybackRate())) .. " / " .. (string.ToMinutesSeconds(math.Round(globalstation:GetLength())) or "00:00")
		end

	end
end

function ENT:GetSongName(  )

	local FixedName = "---"

	local globalstation = globalstations[self:EntIndex()]

	if IsValid(globalstation) then
		FixedName = tostring( globalstation:GetFileName() )

		if isstring(FixedName) then

		FixedName = string.Replace( FixedName, "_", " " )

		FixedName = string.Replace( FixedName, "%20", " " )
		FixedName = string.Replace( FixedName, "%28", "(" )
		FixedName = string.Replace( FixedName, "%29", ")" )

		FixedName = string.GetFileFromFilename( FixedName )

		FixedName = string.JavascriptSafe( FixedName )

		NEnd = string.find( FixedName , ".mp3" ,0 , false )


		FixedName = string.sub( FixedName , 0 , NEnd )

		end
--  		FixedName = string.Trim(FixedName, ".mp3")
  	end
		return FixedName
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
	local curfont = "FRadio_ScreenFontBig"


	ang:RotateAroundAxis(ang:Right(),180)
	ang:RotateAroundAxis(ang:Forward(),180)
	ang:RotateAroundAxis(ang:Up(),-90)

	cam.Start3D2D(pos+ang:Up()*3,ang,0.15)
		local off = -220
		local ee = -460
		local textcenter = -92 / 4

		local globalstation = globalstations[self:EntIndex()]
		if IsValid(globalstation) then
		local levels_l,levels_r
		levels_l,levels_r = globalstation:GetLevel()

		local moff = -off
		globallevels[self:EntIndex()] = {moff*1.7*levels_r,moff*1.7*levels_l}
	else
		globallevels[self:EntIndex()] =  {0,0}
	end




	local x,y = globallevels[self:EntIndex()][1],globallevels[self:EntIndex()][2]

	local color_rainbow = HSVToColor((RealTime()*100)%360,1,1)
	local color_flex_green = Color(33,91,51)
	local color_lime = Color(0,math.Max(RealTime(),math.Min(0,255)),0)

		draw.RoundedBox(0,
			ee, off,
			920, 440,
			color_black)


		local glevel = globallevels[self:EntIndex()]

		local xorigin = textcenter-32-32-32

		for i = 1, (#glevel) do
		if glevel[i] == nil then break end
		draw.RoundedBox(0,
			tonumber(xorigin*(i/3)), -off,
			32, tonumber(-glevel[i]),
			color_rainbow)
		end
		for i = (#glevel), 1, -1 do
		if glevel[i] == nil then break end
		draw.RoundedBox(0,
			tonumber(xorigin*(-i/3)-18), -off,
			32, tonumber(-glevel[i]),
			color_rainbow)
		end
		for i = 1, (#glevel) do
		if glevel[i] == nil then break end
		draw.RoundedBox(0,
			tonumber(xorigin*(-i/3)+84), -off,
			32, tonumber(-glevel[i]),
			color_rainbow)
		end
		for i = 1, (#glevel) do
		if glevel[i] == nil then break end
		draw.RoundedBox(0,
			tonumber(xorigin*(-i/3)-84-84-52), -off,
			32, tonumber(-glevel[i]),
			color_rainbow)
		end
		--[[draw.DrawText(
		texttop,curfont,
		textcenter,off/2.5 + (16-draw.GetFontHeight(curfont)),color_flex_green,TEXT_ALIGN_CENTER)
		draw.DrawText(
		textbottom,"FRadio_ScreenFontBig",
		textcenter,off/2.5+14,color_flex_green,TEXT_ALIGN_CENTER)]]--

		draw.DrawText(texttop.." ["..textbottom.."]",curfont,ee,off,color_lime)

	cam.End3D2D()


end

end


function ENT:Initialize()


 	if CLIENT then
 	if #ents.FindByClass("fb_flex_radio") > 1 then return end
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
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetMaterial("models/gibs/metalgibs/metal_gibs")

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
    	local vol = math.Clamp((range-self:GetPos():Distance(LocalPlayer():GetPos()))/range,0,1)
 	if IsValid(globalstation) then


	else

	end


    	if IsValid(globalstation) then
    		if !string.find(self.URL,".ogg",1,true) then
    			globalstation:SetPos(self:GetPos())
    			return end
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
function ENT:OnRemove()
	for k,v in pairs(player.GetHumans()) do
			v:SendLua([[if IsValid(globalstations]] .. "[" .. self:EntIndex() .. "]" .. [[)then globalstations]] .. "[" .. self:EntIndex() .. "]" .. [[:Stop()end]])
	end
end


end
easylua.EndEntity()