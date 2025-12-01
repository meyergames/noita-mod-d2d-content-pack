dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local x, y = EntityGetTransform( owner )

-- Speed up the player until the effect is removed, like with OnFire
multiply_move_speed( owner, "time_trial", 1.15 )

-- to keep track of variables
set_internal_int( owner, "time_trial_start_y", y )
set_internal_int( owner, "time_trial_update_count", 0 )
set_internal_bool( owner, "is_doing_time_trial", true )
set_internal_bool( owner, "reached_time_trial_finish", false )
