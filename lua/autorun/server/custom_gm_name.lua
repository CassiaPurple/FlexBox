local sv_gamename = CreateConVar ("sv_gamename", "", {FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_GAMEDLL})

hook.Add ('GetGameDescription', "custdesc", function ()
	return "FlexBox (QBox)"
end)