dofile_once( "data/scripts/lib/utilities.lua" )

local proj_id = GetUpdatedEntityID()


local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
if proj_comp then
	local owner_id = ComponentGetValue2( proj_comp, "mWhoShot" )

	local dist = distance_between( owner_id, proj_id )
	local max_dist = get_internal_int( proj_id, "controlled_reach_max_dist" )
	if owner_id and max_dist > 0 and dist > max_dist then
		EntityKill( proj_id )
	end
end