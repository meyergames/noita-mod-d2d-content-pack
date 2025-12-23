dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local current_x, current_y = EntityGetTransform( entity_id )

local last_x = get_internal_int( entity_id, "d2d_ancient_lurker_last_pos_x" )
local last_y = get_internal_int( entity_id, "d2d_ancient_lurker_last_pos_y" )
if last_x then
	local is_outside_orb_room = not string.find( BiomeMapGetName( current_x, current_y ), "orb" )
	and not string.find( BiomeMapGetName( last_x, last_y ), "orb" )

	if get_distance( last_x, last_y, current_x, current_y ) < 5 or is_outside_orb_room then
		EntityLoad( "mods/D2DContentPack/files/particles/tele_particles.xml", current_x, current_y )
		EntitySetTransform( entity_id, -3840, 10025 )
	end
end

set_internal_int( entity_id, "d2d_ancient_lurker_last_pos_x", current_x )
set_internal_int( entity_id, "d2d_ancient_lurker_last_pos_y", current_y )