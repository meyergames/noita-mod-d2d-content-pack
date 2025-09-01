dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent(entity_id)
local x, y = EntityGetTransform( owner )

local has_reached_finish = getInternalVariableValue( owner, "reached_time_trial_finish", "value_int" )
--if ( has_reached_finish == 1 ) then return end

setInternalVariableValue( owner, "is_doing_time_trial", "value_int", 0)

-- register player's starting position
local start_x = 0
local start_y = 0

local var_store_pos = get_variable_storage_component( owner, "player_start_pos" )
local stored_pos_values = ComponentGetValue2(var_store_pos, "value_string")
if stored_pos_values then
    local properties = split_string(stored_pos_values, ",")
    local start_x = tonumber(properties[1])
    local start_y = tonumber(properties[2])

    --remove the variable storage component
    EntityRemoveComponent( owner, var_store_pos )
end



-- check whether the player made it
local update_count = getInternalVariableValue( owner, "time_trial_update_count", "value_int" )
--GamePrint( "Update count at time of effect removal: " .. update_count )
if ( update_count == 59 and has_reached_finish == 0 ) then
    GamePrintImportant( "You failed the time trial", "A curse has been laid upon you." )
    GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/perk/create", x, y )
    apply_random_curse( owner )

    remove_perk( "D2D_TIME_TRIAL" )
    EntityAddComponent2( owner, "UIIconComponent",
    {
        name = "Time Trial: Lost",
        description = "You lost the time trial, earning you a curse.",
        icon_sprite_file = "mods/D2DContentPack/files/gfx/ui_gfx/perks/time_trial_016_lost.png",
        display_above_head = false,
        display_in_hud = true,
        is_perk = true,
    })

    -- remove the 15% movement speed buff
    reset_move_speed( owner, "time_trial" )

    -- warp the player back
--    EntitySetTransform( owner, start_x, start_y )

    return
end

--setInternalVariableValue( owner, "time_trial_duration", "value_int", 60 )

