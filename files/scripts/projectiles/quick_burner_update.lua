dofile_once( "data/scripts/lib/utilities.lua" )

local THRESHOLD = 70

local proj_id = GetUpdatedEntityID()
local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
if proj_comp then
	local owner_id = ComponentGetValue2( proj_comp, "mWhoShot" )

	if owner_id and distance_between( owner_id, proj_id ) > THRESHOLD then
		EntityKill( proj_id )
	end
end
