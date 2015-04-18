-- SERVER ONLY, OFC

aowl.AddCommand("radio",
	function(ply,_,arg1,arg2)
	arg1 = tostring(arg1)
	arg2 = tostring(arg2)
	arg1 = arg1:lower()
	arg2 = arg2:lower()
	local function checkarg1()
		for k,v in pairs({"play","stop","pause","unpause"}) do
			if arg1 == v:lower() then return true end	
		end
	end
	local entcheck = ply:GetEyeTrace().Entity
	if !entcheck:GetClass():find("radio") then ply:PrintMessage(3,"Please look at a radio.") return end	
	if !checkarg1() then ply:PrintMessage(3,"Usage: radio play|stop|pause|unpause") return end
	if !arg2 and arg1 == "play" then ply:PrintMessage(3,"Usage: radio play,http://url.to.sound/file.ogg") return end	
	if arg1 == "play" then 
		entcheck:Play(arg2)
	end
	if arg1 == "stop" then 
		entcheck:Stop()
	end
	if arg1 == "pause" then 
		entcheck:Pause()
	end	
	if arg1 == "unpause" then 
		entcheck:Unpause()
	end	
end,"players")	
