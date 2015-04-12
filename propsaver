-- Prop Saver v2
-- by user4992

PropIndex = 0

if !IsValid(LoadedProps) then
LoadedProps = {}
end

if !IsValid(LoadedOwners) then
LoadedOwners = {}
end

function AddPropToTable( entity, model, pos, ang, scale, owner, static, material, color )

--	PropIndex = PropIndex + 1

	local CurrentProp = {
	["entity"] = entity,
	["model"] = model,
	["pos"] = pos,
	["ang"] = ang,
	["scale"] = scale,
	["owner"] = owner,
	["static"] = static,
	["material"] = material,
	["color"] = color,
	}


	return CurrentProp	
	
end

function LoadPropTable( LoadingTable , TableOwner )

	for i=1,#LoadingTable do
	
		SpawnPropFromTable( i , LoadingTable , TableOwner )

	end	
	
end

function SpawnPropFromTable( index , CurrentPropTable , Owner )


	Loading = CurrentPropTable[index]
	
	SpawnedProp = ents.Create( Loading["entity"] )
 	
 	if Loading["entity"] ~= "prop_physics" then
 			SpawnedProp:Spawn()
 	end


 	SpawnedProp:SetModel( Loading["model"] )	
	SpawnedProp:SetPos( Loading["pos"] )
	SpawnedProp:SetAngles( Loading["ang"] )
	SpawnedProp:SetOwner( Loading["owner"] )
	SpawnedProp:SetMaterial( Loading["material"] )
	SpawnedProp:SetColor( Loading["color"] )
	
	SpawnedProp.PhysgunDisabled = Loading["static"] 

	if isnumber(Loading["scale"]) then
		if Loading["scale"] != 1 then
			SpawnedProp:SetModelScale( Loading["scale"] )
		end
	end
	


 	if Loading["entity"] != "prop_physics" then SpawnedProp:Spawn() end

	SpawnedProp:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	SpawnedProp:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	SpawnedProp:SetSolid( SOLID_VPHYSICS )         -- Toolbox

	if Loading["notsolid"] then SpawnedProp:SetSolid( SOLID_NONE )    end
	
		if Loading["static"] == true  then 
 			SpawnedProp:SetMoveType(MOVETYPE_NONE)
 			local l = SpawnedProp:GetPhysicsObject()
	 		l:EnableMotion(false) 
 			l:Sleep()
		end	
	
	PropIndex = PropIndex + 1
		
	LoadedProps[PropIndex] = SpawnedProp
	LoadedOwners[PropIndex] = Owner
	
end

function ClearTableProps( CleaningOwner )

		if #LoadedProps > 0 then
			for k, v in pairs( LoadedProps ) do
				if IsValid( v ) then
					

					if isstring(CleaningOwner) and !(CleaningOwner == "") then 
						
						if CleaningOwner == LoadedOwners[ tonumber(k) ] then
							v:Remove()	
						end


					else
						v:Remove()
--						print("no owner stated, wiping all")
						
					end
				
			end
		end
	end

end

function DefineProp( prop )

	local PropClass = tostring( prop:GetClass() )
	local PropModel = tostring( prop:GetModel() )
	local PropPos = tostring( math.Round(prop:GetPos().x ,0) .." , ".. math.Round(prop:GetPos().y ,0) .." , ".. math.Round(prop:GetPos().z ,0))
	local AngDissect = prop:GetAngles()
	local PropAng = tostring( math.Round(AngDissect.x ,0) .." , ".. math.Round(AngDissect.y ,0) .." , ".. math.Round(AngDissect.z ,0) )
	local PropMat = tostring( prop:GetMaterial() )
	local PropColor = table.ToString( prop:GetColor() )
	
	print( '{ ["entity"] = "'.. PropClass ..'" , ["model"] = "' .. PropModel .. '" , ["pos"] = Vector(' .. PropPos .. '), ["ang"] = Angle('.. PropAng ..'), ["owner"] = nil , ["static"] = true , ["material"] = "' .. PropMat .. '" , ["color"] = White }, ')
	
end



