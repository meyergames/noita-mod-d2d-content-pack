dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent(entity_id)
local x, y = EntityGetTransform( owner )

local has_reached_finish = get_internal_int( owner, "reached_time_trial_finish" )

setInternalVariableValue( owner, "is_doing_time_trial", "value_int", 0)

-- check whether the player made it
local update_count = get_internal_int( owner, "time_trial_update_count" )
if ( update_count == 59 and has_reached_finish == 0 ) then
    GamePrintImportant( "You failed the time trial", "A curse has been laid upon you." )
    GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/perk/create", x, y )
    apply_random_curse( owner )

    -- remove the 15% movement speed buff
    reset_move_speed( owner, "time_trial" )
    
    -- remove Time Trial entity from player
    EntityKill( entity_id )

    -- show the spent perk icon
    swap_perk_icon_for_spent( owner, "d2d_time_trial" )
end
