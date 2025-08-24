dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )

local cooldown_time = getInternalVariableValue( owner, "combustion_cooldown_time", "value_int" )
if ( cooldown_time > 0 ) then
    setInternalVariableValue( owner, "combustion_cooldown_time", "value_int", cooldown_time - 1 )
    return
end
if ( has_game_effect( "ON_FIRE") ) then return end

local rnd = Random( 1, 60 )
if ( rnd == 1 ) then
    GetGameEffectLoadTo( owner, "ON_FIRE", false )
    setInternalVariableValue( owner, "combustion_cooldown_time", "value_int", 60 )
end
