function undo_test_entspawn()
	if type(spawned) != "table" then spawned = {} end
	for k,v in pairs(spawned) do
		if IsValid(Entity(v)) then
		Entity(v):Remove()
	end		
end
end

function reinit_issa()
	undo_test_entspawn()
	ISSA()
end

local function EL_CreateEntity(class, callback, pos, static)
	local mdl = "error.mdl"

	if IsEntity(class) and class:IsValid() then
		ent = class
	elseif class:find(".mdl", nil, true) then
		mdl = class
		class = "prop_physics"

		ent = ents.Create(class)
		ent:SetModel(mdl)
		
	else
		ent = ents.Create(class)
	end

	if callback and type(callback) == 'function' then
		callback(ent);
	end

	ent:Spawn()
	
	ent:SetPos(pos)
	if static then
	ent:SetMoveType(MOVETYPE_NONE)
	local l = ent:GetPhysicsObject() 
	l:EnableMotion(false)
	l:Sleep()
	else
	ent:PhysWake()
	ent:SetMoveType(MOVETYPE_VPHYSICS)
end

	ent:SetHealth(1000000)

	table.insert(spawned, ent:EntIndex())
	
	return ent
end

local function MakePropsFromTable(proptab,static)
	for k,v in pairs(proptab) do
		local mdl = v.model
		local pos = v.position
		local ang = v.angles
		local clr = v.color
		local mat = v.material
		local rfx = v.renderfx
		local initf = v.initphys
		local mss = v.mass
		
		
		if mat == nil or mat == "" or type(mat) != "string" then mat = "do not" end
		if clr == nil or type(clr) != "table" then clr = Color(255,255,255,255) end
		if ang == nil or type(ang) != "Angle" then ang = Angle(0,0,0) end
		if pos == nil or type(pos) != "Vector" then vec = Vector(0,0,0) end
		if rfx == nil or rfx == 0 or type(rfx) != "number" then rfx = kRenderFxNone end	
		if mss == nil or type(mss) != "number" then mss = "do not touch" end
		
		if !static or initf then
		EL_CreateEntity("prop_physics",function(s)
			if IsValid(s) then
			s:SetModel(mdl)
			
			s:SetAngles(ang)
			if mat != "do not" then
			s:SetMaterial(mat)
			end
			s:SetColor(clr)
			s:SetRenderFX(rfx)
			if mss != "do not touch" then
				timer.Simple(0.5,function()
				s:GetPhysicsObject():SetMass(mss)
				s.PhysgunDisabled = v.disablephys
			end)
	end

		end
		
		end,pos,false)
		else
		EL_CreateEntity("prop_physics",function(s)
			s:SetModel(mdl)
			
			s:SetAngles(ang)
			if mat != "do not" then
			s:SetMaterial(mat)
			end
			s:SetColor(clr)
			s:SetRenderFX(rfx)
			s:SetMoveType(MOVETYPE_NONE)
			timer.Simple(0.5,function()
				s.PhysgunDisabled = true
		end)
		end,pos,true)
		end
		
		
	end
end


local proptable_adminroom = {

{
	["material"] = "",
	["position"] = Vector(-782.92962646484, -1258.4345703125, -14191.541992188),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/holo_rails.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(-0.011416403576732, 90.058395385742, -0.2364501953125),
},
{
	["material"] = "",
	["position"] = Vector(-828.89770507813, -1443.4846191406, -14191.611328125),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/desk_officer.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.016212329268456, 90.025924682617, 0.0074222818948328),
},
{
	["material"] = "",
	["position"] = Vector(-895.85211181641, -1441.3270263672, -14191.661132813),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/flagpole.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.10612408816814, 88.932441711426, 0.073825888335705),
},
{
	["material"] = "",
	["position"] = Vector(-960.46228027344, -1462.0469970703, -14162.702148438),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/holo_wall_unit.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(-9.0790729245782e-007, -9.5852172421473e-008, 0),
},
{
	["material"] = "",
	["position"] = Vector(-1061.9361572266, -1463.5386962891, -14191.548828125),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/counter.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.041398204863071, 90.04076385498, 0.016400035470724),
},
{
	["material"] = "",
	["position"] = Vector(-1159.3059082031, -1463.6049804688, -14191.958984375),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/counter_sinks.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.088661290705204, 89.999969482422, -0.021026611328125),
},
{
	["material"] = "",
	["position"] = Vector(-1097.2818603516, -1202.6439208984, -14191.537109375),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/holograms/console_hr.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.018548788502812, -0.0024618678726256, -0.034271240234375),
},
{
	["material"] = "models/lt_c/sci_fi/ground_locker_small",
	["position"] = Vector(-980.17413330078, -1096.6748046875, -14191.556640625),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/ground_locker_small.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.13725829124451, -90.05029296875, -0.05169677734375),
},
{
	["material"] = "models/lt_c/sci_fi/ground_locker_small",
	["position"] = Vector(-959.60980224609, -1096.51171875, -14191.421875),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/ground_locker_small.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.34532698988914, -90.027549743652, 0.028152737766504),
},
{
	["material"] = "models/lt_c/sci_fi/ground_locker_small",
	["position"] = Vector(-939.06707763672, -1096.5080566406, -14191.291992188),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/ground_locker_small.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.43702855706215, -90.028442382813, 0.012482299469411),
},
{
	["material"] = "models/lt_c/sci_fi/ground_locker_small",
	["position"] = Vector(-918.43298339844, -1096.9128417969, -14191.603515625),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/ground_locker_small.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(-0.036623246967793, -90.093803405762, 0.0032718603033572),
},
{
	["material"] = "models/lt_c/sci_fi/ground_locker_small",
	["position"] = Vector(-897.84924316406, -1096.8288574219, -14191.66796875),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/ground_locker_small.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(-0.023389851674438, -89.980735778809, 0.0035662786103785),
},
{
	["material"] = "models/lt_c/sci_fi/box_crate",
	["position"] = Vector(-959.79278564453, -1305.3957519531, -14148.411132813),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/box_crate.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.13244217634201, -75.947624206543, -0.15048217773438),
},
{
	["material"] = "models/lt_c/sci_fi/box_crate",
	["position"] = Vector(-981.2626953125, -1303.6895751953, -14191.599609375),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/box_crate.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.012364892289042, -88.516914367676, 0.0057110241614282),
},
{
	["material"] = "models/lt_c/sci_fi/box_crate",
	["position"] = Vector(-930.02001953125, -1308.8212890625, -14191.771484375),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/box_crate.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(-0.040176279842854, -83.287368774414, 0.036965284496546),
}

}

local proptable_loungearea = {

{
	["material"] = "models/props/cs_office/table_coffee",
	["position"] = Vector(-930.02270507813, -1071.2615966797, -14191.500976563),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props/cs_office/table_coffee.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(-0.00044555269414559, 90.000175476074, -0.000213623046875),
},
{
	["material"] = "models/props/cs_office/bookshelf1",
	["position"] = Vector(-989.25103759766, -1079.3743896484, -14191.380859375),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props/cs_office/bookshelf1.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(-0.99835383892059, 90.001686096191, 0.0071335174143314),
},
{
	["material"] = "models/props/cs_office/bookshelf1",
	["position"] = Vector(-1042.2171630859, -1080.8552246094, -14191.500976563),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props/cs_office/bookshelf2.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(-1.3649284483108e-005, 89.974822998047, 9.9625931397895e-006),
},
{
	["material"] = "models/props/cs_office/bookshelf1",
	["position"] = Vector(-1095.2763671875, -1080.9437255859, -14191.624023438),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props/cs_office/bookshelf3.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(-0.01509000454098, 89.990036010742, 0.00091988645726815),
},
{
	["material"] = "models/props/cs_militia/couch",
	["position"] = Vector(-1190.1184082031, -1034.7066650391, -14192.526367188),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props/cs_militia/couch.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(-0.076279371976852, -90.019416809082, -0.002105712890625),
},
{
	["material"] = "models/props/cs_militia/couch",
	["position"] = Vector(-1158.125, -872.26641845703, -14192.439453125),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props/cs_militia/couch.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.0068671866320074, -134.36175537109, -0.002655029296875),
},
{
	["material"] = "models/props/cs_militia/caseofbeer01",
	["position"] = Vector(-1110.3597412109, -827.33062744141, -14191.005859375),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props/cs_militia/caseofbeer01.mdl",
	["initphys"] = true,
	["renderfx"] = 0,
	["angles"] = Angle(1.0098459720612, -14.347641944885, 1.7465353012085),
},
{
	["material"] = "models/props/cs_militia/caseofbeer01",
	["position"] = Vector(-1091.2283935547, -804.25848388672, -14191.517578125),
	["color"] = Color(255, 255, 255, 255),
	["initphys"] = true,
	["model"] = "models/props/cs_militia/caseofbeer01.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(-0.025547321885824, -44.817840576172, -0.041778564453125),
},
{
	["material"] = "models/props/cs_militia/couch",
	["position"] = Vector(-1049.0773925781, -762.26037597656, -14192.529296875),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props/cs_militia/couch.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(-0.13068972527981, -134.88151550293, -0.079559326171875),
},
{
	["material"] = "models/props/cs_militia/bar01",
	["position"] = Vector(-902.80480957031, -767.02758789063, -14191.577148438),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props/cs_militia/bar01.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.0079956175759435, -179.7048034668, -0.0107421875),
},
{
	["material"] = "models/props/cs_militia/barstool01",
	["position"] = Vector(-927.89672851563, -833.80737304688, -14191.603515625),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props/cs_militia/barstool01.mdl",
	["initphys"] = true,
	["mass"] = 100,
	["renderfx"] = 0,
	["angles"] = Angle(0.16798190772533, -86.450813293457, 0.0077834529802203),
},
{
	["material"] = "models/props/cs_militia/barstool01",
	["position"] = Vector(-893.51672363281, -834.77423095703, -14191.641601563),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props/cs_militia/barstool01.mdl",
	["initphys"] = true,
	["mass"] = 100,
	["renderfx"] = 0,
	["angles"] = Angle(-0.45908263325691, -93.990867614746, -0.00408935546875),
},
{
	["material"] = "models/props/cs_militia/barstool01",
	["initphys"] = true,
	["mass"] = 100,
	["position"] = Vector(-862.60278320313, -834.68896484375, -14191.618164063),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props/cs_militia/barstool01.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.0052774013020098, -90.107986450195, 0.018328279256821),
},
{
	["material"] = "models/props/cs_office/tv_plasma",
	["position"] = Vector(-888.70385742188, -712.49206542969, -14120.494140625),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props/cs_office/tv_plasma.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(3.1363201141357, -90, 0),
},
{
	["material"] = "models/props/cs_office/vending_machine",
	["position"] = Vector(-794.40277099609, -962.18115234375, -14191.579101563),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props/cs_office/vending_machine.mdl",
	["initphys"] = true,
	["disablephys"] = true,
	["renderfx"] = 0,
	["mass"] = 12000,
	["angles"] = Angle(0.042909540235996, -90.009666442871, 0.011983592994511),
}
}
local proptable_serverroom = {

{
	["material"] = "",
	["position"] = Vector(-745.35534667969, -835.24584960938, -14191.524414063),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/desk_officer.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(-0.3584848344326, 0.24109646677971, -0.10903930664063),
},
{
	["material"] = "",
	["position"] = Vector(-745.89495849609, -808.69696044922, -14158.044921875),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/holo_laptop.mdl",
	["initphys"] = true,
	["renderfx"] = 0,
	["angles"] = Angle(-2.5440988540649, -90.029090881348, 0.33599323034286),
},
{
	["material"] = "",
	["position"] = Vector(-767.63635253906, -782.28338623047, -14129.682617188),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/lamp.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(9.9969881262041e-008, -4.8164076815738e-007, 0),
},
{
	["material"] = "",
	["position"] = Vector(-755.69372558594, -726.23919677734, -14137.49609375),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/generator_portable.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.02223446406424, 0.013264971785247, 0.26100382208824),
},
{
	["material"] = "",
	["position"] = Vector(-767.56903076172, -763.78314208984, -14191.286132813),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/ground_locker_small.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.51451516151428, 0.00047015334712341, 0.0073485798202455),
},
{
	["material"] = "",
	["position"] = Vector(-767.54150390625, -743.21105957031, -14191.307617188),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/ground_locker_small.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.41008239984512, 0.011575662530959, -2.1011042008467e-006),
},
{
	["material"] = "",
	["position"] = Vector(-767.56420898438, -722.62969970703, -14191.251953125),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/ground_locker_small.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.52403205633163, 0.16242164373398, 0),
},
{
	["material"] = "",
	["position"] = Vector(-678.39929199219, -729.08850097656, -14191.505859375),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/holo_rails.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.026776298880577, 179.92391967773, 0.42454025149345),
},
{
	["material"] = "",
	["position"] = Vector(-622.60028076172, -759.69439697266, -14191.674804688),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props_lab/servers.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.0023612058721483, -179.8210144043, 0.0081188669428229),
},
{
	["material"] = "",
	["position"] = Vector(-653.26477050781, -867.43609619141, -14191.575195313),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/sci_fi/dm_container.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(-0.015194163657725, 101.76270294189, 0.055175308138132),
},
{
	["material"] = "",
	["position"] = Vector(-482.43957519531, -877.47521972656, -14191.112304688),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props_lab/workspace003.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.018928065896034, 90.083641052246, 0.11878726631403),
},
{
	["material"] = "",
	["position"] = Vector(-546.56524658203, -761.54071044922, -14191.452148438),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props_lab/servers.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(-0.86877244710922, 179.96771240234, -0.000244140625),
},
{
	["material"] = "",
	["position"] = Vector(-482.43957519531, -877.47521972656, -14191.112304688),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props_lab/workspace003.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.018928065896034, 90.083641052246, 0.11878726631403),
},
{
	["material"] = "",
	["position"] = Vector(-477.48071289063, -760.61163330078, -14191.599609375),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props_lab/servers.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(0.15040723979473, -174.1932220459, -0.00042724609375),
},
{
	["material"] = "",
	["position"] = Vector(-456.45190429688, -834.30810546875, -14154.00390625),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/lt_c/holo_keypad_large.mdl",
	["renderfx"] = 0,
	["angles"] = Angle(4.6755960214639e-010, -179.99996948242, -1.9190308648831e-006),
}

}

local proptable_windows = {
{
	["material"] = "phoenix_storms/scrnspace",
	["position"] = Vector(-554.04992675781, -705.99389648438, -14124.694335938),
	["color"] = Color(255, 255, 255, 255),
	["model"] = "models/props_building_details/storefront_template001a_bars.mdl",
	["angles"] = Angle(1.2902912177831e-015, 90, -1.327746304014e-006),
	["renderfx"] = 0,
},
{
	["material"] = "phoenix_storms/scrnspace",
	["position"] = Vector(-620.61242675781, -705.99389648438, -14124.694335938),
	["color"] = Color(255, 255, 255, 255),
	["renderfx"] = 0,
	["angles"] = Angle(1.2902909001458e-015, 90, 0),
	["model"] = "models/props_building_details/storefront_template001a_bars.mdl",
},
{
	["material"] = "phoenix_storms/scrnspace",
	["position"] = Vector(-687.17492675781, -705.99389648438, -14124.694335938),
	["color"] = Color(255, 255, 255, 255),
	["renderfx"] = 0,
	["angles"] = Angle(1.2902909001458e-015, 90, -2.1011048829678e-006),
	["model"] = "models/props_building_details/storefront_template001a_bars.mdl",
},
{
	["material"] = "phoenix_storms/scrnspace",
	["position"] = Vector(-1080.9677734375, -762.58630371094, -14118.471679688),
	["color"] = Color(255, 255, 255, 255),
	["renderfx"] = 0,
	["angles"] = Angle(1.2157877371521e-008, 135, 89.998794555664),
	["model"] = "models/props_building_details/storefront_template001a_bars.mdl",
},
{
	["material"] = "phoenix_storms/scrnspace",
	["position"] = Vector(-1153.1370849609, -834.75512695313, -14118.474609375),
	["color"] = Color(255, 255, 255, 255),
	["renderfx"] = 0,
	["angles"] = Angle(1.2256738735061e-008, 135.00001525879, 89.998794555664),
	["model"] = "models/props_building_details/storefront_template001a_bars.mdl",
},
{
	["material"] = "phoenix_storms/scrnspace",
	["position"] = Vector(-1213.9095458984, -1180.6314697266, -14125.009765625),
	["color"] = Color(255, 255, 255, 255),
	["renderfx"] = 0,
	["angles"] = Angle(-2.7796071000452e-010, -180, -89.999786376953),
	["model"] = "models/props_building_details/storefront_template001a_bars.mdl",
},
{
	["material"] = "phoenix_storms/scrnspace",
	["position"] = Vector(-1213.9095458984, -1282.6942138672, -14125.008789063),
	["color"] = Color(255, 255, 255, 255),
	["renderfx"] = 0,
	["angles"] = Angle(-3.1722169335779e-010, -179.99998474121, -89.999816894531),
	["model"] = "models/props_building_details/storefront_template001a_bars.mdl",
},
{
	["material"] = "phoenix_storms/scrnspace",
	["position"] = Vector(-1213.9095458984, -1384.7569580078, -14125.0078125),
	["color"] = Color(255, 255, 255, 255),
	["renderfx"] = 0,
	["angles"] = Angle(-3.1722166560222e-010, -179.99998474121, -89.999816894531),
	["model"] = "models/props_building_details/storefront_template001a_bars.mdl",
},
		
}

function ISSA()

MakePropsFromTable(proptable_adminroom,true)
MakePropsFromTable(proptable_loungearea,true)
MakePropsFromTable(proptable_serverroom,true)
MakePropsFromTable(proptable_windows,true)

end

timer.Simple(15,function() ISSA() reinit_issa() end)
