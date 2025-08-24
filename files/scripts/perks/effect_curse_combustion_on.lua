dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )

addNewInternalVariable( owner, "combustion_cooldown_time", "value_int", 0 )
