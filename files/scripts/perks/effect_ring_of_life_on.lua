dofile_once("data/scripts/lib/utilities.lua")

local player = get_player()

local var = getInternalVariableValue( player, "ring_of_life_triggered", "value_int")
if ( var == nil ) then
    addNewInternalVariable( player, "ring_of_life_triggered", "value_int", 0 )
else
    setInternalVariableValue( player, "ring_of_life_triggered", "value_int", 0 )
end
