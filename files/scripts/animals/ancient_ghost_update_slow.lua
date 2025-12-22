dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local current_x, current_y = EntityGetTransform( entity_id )

local last_x = get_internal_int( entity_id, "d2d_ancient_lurker_last_pos_x" )
local last_y = get_internal_int( entity_id, "d2d_ancient_lurker_last_pos_y" )
if last_x then
	if get_distance( last_x, last_y, current_x, current_y ) < 5 then
		EntitySetTransform( entity_id, -3840, 9850 )
	end
end

set_internal_int( entity_id, "d2d_ancient_lurker_last_pos_x", current_x )
set_internal_int( entity_id, "d2d_ancient_lurker_last_pos_y", current_y )