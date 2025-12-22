dofile_once( "data/scripts/lib/utilities.lua" )

local proj_id = GetUpdatedEntityID()
local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
if proj_comp then
	local owner_id = ComponentGetValue2( proj_comp, "mWhoShot" )
	if owner_id == 0 then owner_id = get_player() end

	local ox, oy = EntityGetTransform( owner_id )
	local mx, my = DEBUG_GetMouseWorld()

	local dist = get_distance( ox, oy, mx, my )
	set_internal_int( proj_id, "d2d_command_attack_max_dist", dist )
end