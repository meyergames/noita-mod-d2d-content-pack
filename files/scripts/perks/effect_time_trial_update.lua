dofile_once("data/scripts/lib/utilities.lua")

local DURATION_IN_SEC = 60

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent(entity_id)
local x, y = EntityGetTransform( owner )

--local time_trial_duration = getInternalVariableValue( owner, "time_trial_duration", "value_int" )
local old_update_count = getInternalVariableValue( owner, "time_trial_update_count", "value_int" )
if old_update_count then
    local new_update_count = old_update_count + 1
    set_internal_int( owner, "time_trial_update_count", new_update_count )

    local old_hm_count = get_internal_int( owner, "hms_visited_on_trial_start" )
    local new_hm_count = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )
--    local has_finished = getInternalVariableValue( owner, "reached_time_trial_finish", "value_int" )
--    if ( has_finished == 1 ) then

    if new_hm_count > old_hm_count then
        local start_y = set_internal_int( owner, "time_trial_start_y", y )

        if start_y < y - 1000 then
            local nearby_entities = EntityGetInRadius( x, y, 200 )
            for i,nearby_entity in ipairs( nearby_entities ) do
                local filename = EntityGetFilename( nearby_entity )
                if string.find( filename, "temple_statue_01" ) then
                    set_internal_int( owner, "reached_time_trial_finish", 1 )
                    set_internal_int( owner, "is_doing_time_trial", 0 )
                    dofile_once( "mods/D2DContentPack/files/scripts/perks/effect_time_trial_win.lua" )
                end
            end
        end
    elseif new_update_count >= DURATION_IN_SEC - 10 then
        GamePrint( ( DURATION_IN_SEC - new_update_count ) .. "..." )
    elseif new_update_count % 10 == 0 then
        GamePrint( ( DURATION_IN_SEC - new_update_count ) .. " seconds remaining" )
    end
end
