local ISSAPOS1 = Vector(-459.13723754883, -697.74530029297, -14185.62109375)
local ISSAPOS2 = Vector(-1207.7590332031, -1468.224609375, -14057.595703125)
local ISSAWHITELIST = {"STEAM_0:0:62588856","STEAM_0:0:20232608","STEAM_0:0:80669850","STEAM_0:0:69785433","STEAM_0:0:58178275"}

local function CheckWhitelist(ply)
	for k,v in pairs(ISSAWHITELIST) do
		if ply:SteamID() == v then	return true end
	end
end
local function SetWhitelist()
	for k,v in pairs(player.GetAll()) do
		if CheckWhitelist(v) then
			v:SetPData("IsOnB1ISSAWhitelist",true)
		else	
			v:SetPData("IsOnB1ISSAWhitelist",false)
		end
	end
end
SetWhitelist()

function RestrictISSA()
	hook.Add("Think","RestrictISSA",function()
		for k,v in pairs(ents.FindInBox(ISSAPOS1, ISSAPOS2)) do
				if type(v) == "Player" and v:IsPlayer() then

					if v:GetPData("IsOnB1ISSAWhitelist") != "true" then
						v:SetMoveType(MOVETYPE_WALK)
						v:Spawn()
					end


				end

		end
	end)
end

RestrictISSA()