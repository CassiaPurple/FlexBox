
function ClearISSATech()

	if IsValid( ISSAScoreboard ) then ISSAScoreboard:Remove()	end
	if IsValid( PublicScoreboard ) then PublicScoreboard:Remove()	end
	if IsValid( ISSAClock ) then ISSAClock:Remove()	end
	if IsValid( ISSAUptime ) then ISSAUptime:Remove()	end	
	
end

function ISSATech()
	
	ClearISSATech()

	ISSAScoreboard =  ents.Create("fb_user_scoreboard")
	ISSAScoreboard:Spawn()
	ISSAScoreboard:SetPos(Vector(-1102 , -1099 , -14135 ))
	ISSAScoreboard:SetAngles( Angle(0,-90,0) )
	ISSAScoreboard.PhysgunDisabled = true
	ISSAScoreboard:SetSolid( SOLID_NONE ) 

	PublicScoreboard =  ents.Create("fb_user_scoreboard")
	PublicScoreboard:Spawn()
	PublicScoreboard:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	PublicScoreboard:SetModelScale(0.01)		
	PublicScoreboard:SetColor( Color(0,0,0,0) )
	PublicScoreboard:SetPos(Vector(   -2115, -1727, -14520 ))
	PublicScoreboard:SetAngles( Angle(0,90,0) )
	PublicScoreboard.PhysgunDisabled = true
	PublicScoreboard:SetSolid( SOLID_NONE ) 
	
	
	ISSAClock =  ents.Create("fb_user_clock")
	ISSAClock:Spawn()
	ISSAClock:SetPos(Vector(-782 , -1336 , -14191 ))
	ISSAClock:SetAngles( Angle(0,90,0) )
	ISSAClock.PhysgunDisabled = true
	
	ISSAUptime =  ents.Create("fb_user_uptime")
	ISSAUptime:Spawn()
	ISSAUptime:SetPos(Vector( -1080 , -1462 , -14130 ))
	ISSAUptime:SetAngles( Angle(0,90,0) )
	ISSAUptime.PhysgunDisabled = true	 
	ISSAUptime:SetSolid( SOLID_NONE ) 
	
end