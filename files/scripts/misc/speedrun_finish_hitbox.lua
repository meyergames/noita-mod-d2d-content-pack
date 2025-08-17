dofile_once("data/scripts/lib/utilities.lua")

function item_pickup( entity_item, entity_who_picked, name )
    GamePrint("Hitbox picked up!!! 1/2")

    local is_doing_time_trial = getInternalVariableValue( entity_who_picked, "is_doing_time_trial", "value_int" )
    if ( is_doing_time_trial == 1 ) then
        GamePrint("Hitbox picked up!!! 2/2")
        setInternalVariableValue( entity_who_picked, "reached_time_trial_finish", "value_int", 1)
    end
end
