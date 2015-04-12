if !aowl then ErrorNoHalt("EEK! AOWL WASN'T RAN BEFORE THIS!") return end
aowl.AddCommand("cspectate",
	function(ply,_,mode,ent) 
		local spmodes = {
			{id=0,name="None"},
			{id=1,name="Deathcam"},
			{id=2,name="TF2 Freezecam"},
			{id=3,name="Fixed view"},
			{id=4,name="First-person"},
			{id=5,name="Chasecam"},
			{id=6,name="Free roam"}
			} 
		if tonumber(mode) == nil then 
			mode = 0 
		else 
			mode = tonumber(mode) 
		end 
		local function checkmode(m) 
			for k,v in pairs(spmodes) do 
				if m == v.id then 
					return true 
				end 
			end 
		end 
		
		if !checkmode(mode) then 
			mode = 0 
		end 
		local function chooseplayer()
			local x = {}
			for k,v in pairs(player.GetAll()) do
				if v != ply then table.insert(x,v)	 end
			end
			return table.Random(x)
		end
		
		ent = easylua.FindEntity(ent)
		if ent == NULL or ent == nil then ent = chooseplayer() end
		if mode == 0 then 
			ply:UnSpectate() 
			local health,armor = ply:Health(), ply:Armor()
			ply:KillSilent()
			ply:ConCommand("aowl revive")
			ply:SetHealth(health)ply:SetArmor(armor)
			hook.Remove("Think","CSpec_StripWeapons_" .. ply:EntIndex())
			ply:PrintMessage(3, "Stopped spectating") 
			
		else ply:Spectate(mode) 
			ply:PrintMessage(3, [[Spectating in mode "]] .. spmodes[mode+1].name .. [["]]) 
			ply:Strip()

				hook.Add("Think","CSpec_StripWeapons_" .. ply:EntIndex(),function() if IsValid(ply) then ply:Strip() if !ply:Alive() then hook.Remove("Think","CSpec_StripWeapons_" .. ply:EntIndex()) end else hook.Remove("Think","CSpec_StripWeapons_" .. ply:EntIndex()) end
				 end)

			ply:SpectateEntity(ent)
			end end,"players")
