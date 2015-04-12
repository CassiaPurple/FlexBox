-- !home command
-- by user4992
--
-- to be run on server only

	aowl.AddCommand("home", function( ply )
	
		for k, v in pairs( HomeLocations ) do 
	
			if IsValid(ply) then
				if ply:SteamID() == v["owner"] then

					print("sending "..ply:GetName().." home")
		
					ply:SetPos( v["loc"] )
			
				end
			end
		end

	end)