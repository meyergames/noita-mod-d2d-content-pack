dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )

addNewInternalVariable( owner, "master_of_fire_is_effect_active", "value_int", 0 )
addNewInternalVariable( owner, "master_of_fire_shot_effect_id", "value_int", 0 )
