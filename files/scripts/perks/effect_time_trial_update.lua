dofile_once("data/scripts/lib/utilities.lua")

local DURATION_IN_SEC = 60

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent(entity_id)
local x, y = EntityGetTransform( owner )

function on_time_trial_win()
    set_internal_bool( owner, "reached_time_trial_finish", true )
    set_internal_bool( owner, "is_doing_time_trial", false )

    local time_trial_duration = get_internal_int( owner, "time_trial_update_count" )
    local chest = ""
    if time_trial_duration <= 15 then
        GamePrintImportant( "The gods are in disbelief", "" )
        chest = "mods/D2DContentPack/files/entities/items/pickup/chest_time_trial_t3.xml"

        AddFlagPersistent( "d2d_time_trial_bronze" )
        GameAddFlagRun( "d2d_time_trial_bronze_this_run" )
    elseif time_trial_duration <= 30 then
        GamePrintImportant( "The gods are in awe", "" )
        chest = "mods/D2DContentPack/files/entities/items/pickup/chest_time_trial_t2.xml"

        AddFlagPersistent( "d2d_time_trial_bronze" )
        AddFlagPersistent( "d2d_time_trial_silver" )
        GameAddFlagRun( "d2d_time_trial_bronze_this_run" )
        GameAddFlagRun( "d2d_time_trial_silver_this_run" )
    else
        GamePrintImportant( "The gods admire your speed", "" )
        chest = "mods/D2DContentPack/files/entities/items/pickup/chest_time_trial_t1.xml"

        AddFlagPersistent( "d2d_time_trial_bronze" )
        AddFlagPersistent( "d2d_time_trial_silver" )
        AddFlagPersistent( "d2d_time_trial_gold" )
        GameAddFlagRun( "d2d_time_trial_bronze_this_run" )
        GameAddFlagRun( "d2d_time_trial_silver_this_run" )
        GameAddFlagRun( "d2d_time_trial_gold_this_run" )
    end

    local spx = x
    local spy = y - 50
    local nearby_entities = EntityGetInRadius( x, y, 220 )
    for i,nearby_entity in ipairs( nearby_entities ) do
        local filename = EntityGetFilename( nearby_entity )
        if string.find( filename, "temple_statue_01" ) then
            spx, spy = EntityGetTransform( nearby_entity )
            spx = spx + 79
            spy = spy + 38
        end
    end

    EntityLoad( chest, spx, spy )
    GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/chest/create", x, y )

    -- remove Time Trial entity from player
    EntityKill( entity_id )
end



local old_update_count = get_internal_int( owner, "time_trial_update_count" )
if old_update_count then
    local new_update_count = old_update_count + 1
    set_internal_int( owner, "time_trial_update_count", new_update_count )

    local start_y = get_internal_int( owner, "time_trial_start_y" )
    if y > start_y + 1000 then
        local nearby_entities = EntityGetInRadius( x, y, 200 )
        for i,nearby_entity in ipairs( nearby_entities ) do
            local filename = EntityGetFilename( nearby_entity )
            if string.find( filename, "temple_statue_01" ) then
                on_time_trial_win()
            end
        end
    end

    if new_update_count >= DURATION_IN_SEC - 10 then
        GamePrint( ( DURATION_IN_SEC - new_update_count ) .. "..." )
    elseif new_update_count % 10 == 0 then
        GamePrint( ( DURATION_IN_SEC - new_update_count ) .. " seconds remaining" )
    end
else
    set_internal_int( owner, "time_trial_update_count", 0 )
end
