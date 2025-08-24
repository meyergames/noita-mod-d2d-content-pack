dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity( entity_id )

local is_boost_active = getInternalVariableValue( owner, "sporadic_speed_boost_active", "value_int" ) == 1
if ( Random( 0, 100 ) == 0 and not is_boost_active ) then
	multiply_move_speed( owner, "sporadic_speed", 4 )
	setInternalVariableValue( owner, "sporadic_speed_boost_active", "value_int", 1 )
else
	reset_move_speed( owner, "sporadic_speed" )
	setInternalVariableValue( owner, "sporadic_speed_boost_active", "value_int", 0 )
end
