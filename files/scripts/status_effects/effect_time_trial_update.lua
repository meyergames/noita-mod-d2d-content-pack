dofile_once("data/scripts/lib/utilities.lua")

local DURATION_IN_SEC = 60

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent(entity_id)
local x, y = EntityGetTransform( owner )

--local time_trial_duration = getInternalVariableValue( owner, "time_trial_duration", "value_int" )
local old_update_count = getInternalVariableValue( owner, "time_trial_update_count", "value_int" )
if old_update_count then
    local new_update_count = old_update_count + 1
    setInternalVariableValue( owner, "time_trial_update_count", "value_int", new_update_count )

    local old_hm_count = getInternalVariableValue( owner, "hms_visited_on_trial_start", "value_int" )
    local new_hm_count = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )
--    local has_finished = getInternalVariableValue( owner, "reached_time_trial_finish", "value_int" )
--    if ( has_finished == 1 ) then
    if ( new_hm_count > old_hm_count and getInternalVariableValue( owner, "reached_time_trial_finish", "value_int" ) ) then
        -- if the player made peace with the gods, give some extra time, once
        setInternalVariableValue( owner, "reached_time_trial_finish", "value_int", 1 )
        setInternalVariableValue( owner, "is_doing_time_trial", "value_int", 0)
        dofile_once("mods/RiskRewardBundle/files/scripts/status_effects/effect_runordie_win.lua")
    elseif ( new_update_count >= DURATION_IN_SEC - 10 ) then
        GamePrint( ( DURATION_IN_SEC - new_update_count ) .. "..." )
--        if ( new_update_count == 50 and GlobalsGetValue( "TIME_TRIAL_GODS_LENIENCE_USED", "0" ) == "0" ) then
--            GamePrint( "The gods give you some extra time..." )
--
--            setInternalVariableValue( owner, "time_trial_duration", "value_int", 75 )
--            GlobalsSetValue( "TIME_TRIAL_GODS_LENIENCE_USED", "1" )
--        end
    elseif ( new_update_count % 10 == 0 ) then
        GamePrint( ( DURATION_IN_SEC - new_update_count ) .. " seconds remaining" )
    end
end
