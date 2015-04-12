LocSafeguard = {}
LocSafeguard.Positions = {}
LocSafeguard.Whitelists = {}

function LocSafeguard.AddPrevent(location,corner1,corner2,spawnloc,msg) 
	if msg == nil or type(msg) != "string" then msg="You are not allowed in this location." end
	LocSafeguard.Positions[location] = {} 
	LocSafeguard.Positions[location][1] = corner1 
	LocSafeguard.Positions[location][2] = corner2 
	LocSafeguard.Positions[location][3] = spawnloc 
	hook.Add("Think","LocSafeguard.Locations." .. location,
	function() 
		for k,v in pairs(ents.FindInBox(LocSafeguard.Positions[location][1],LocSafeguard.Positions[location][2])) do 
			if v:GetClass() == "player" then 
				if !LocSafeguard.CheckWhitelist(location,v) then 
					v:SetPos(LocSafeguard.Positions[location][3]) 
					v:SetMoveType(MOVETYPE_WALK) 
					v:PrintMessage(3, msg)
					MsgC(Color(0,255,255),"[LocSafeguard] ",color_white,"Sending "..v:Nick().." to "..tostring(spawnloc).."\n")
				end 
			end 
		end 
	end)
end

function LocSafeguard.CheckWhitelist(whitelist,ply) 
	whitelist = LocSafeguard.Whitelists[whitelist] 
	for k,v in pairs(whitelist) do 
		if ply == v then 
			return true 
		end 
	end 
end

function LocSafeguard.SetWhitelist(location,whitelist) 
	LocSafeguard.Whitelists[location] = whitelist 
end

function LocSafeguard.AddWhitelist(location,player) 
	table.insert(LocSafeguard.Whitelists[location],player) 
end