dofile_once("data/scripts/lib/utilities.lua")

GamePrint("Energizer: Initializing...")
local player = get_player()

local var = getInternalVariableValue( player, "player_energizer_timer", "value_int")
if ( var == nil ) then
    addNewInternalVariable( player, "player_energizer_timer", "value_int", 0 )
    addNewInternalVariable( player, "energizer_comp_id", "value_int", 0 )
else
    setInternalVariableValue( player, "player_energizer_timer", "value_int", 0 )
    setInternalVariableValue( player, "energizer_comp_id", "value_int", 0 )
end

GamePrint("Energizer: Initialized")
