dofile_once( "data/scripts/lib/utilities.lua" )

--GamePrintImportant("You accept the challenge", "Reach the next Holy Mountain within 60 seconds")


-- Check if this perk is picked up within a Holy Mountain
--local bccomp = EntityGetFirstComponentIncludingDisabled( owner, "BiomeCheckerComponent" )
--if bccomp then
--    local biome_name = ComponentGetValue2( bccomp, "current_biome_name" )
--    if ( biome_name ~= "holymountain" ) then
--        GamePrint("Whoopsie daisy!")
--        return
--    end
--end



local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent(entity_id)

-- Speed up the player until the effect is removed, like with OnFire
multiply_move_speed( owner, "time_trial", 1.15 )

local x, y = EntityGetTransform( owner )
local pos_string = tostring(x) .. "," .. tostring(y)
EntityAddComponent2( owner, "VariableStorageComponent", {
    name = "player_start_pos",
    value_string = pos_string,
})

local hms_visited = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )
local biomes_visited = tonumber( GlobalsGetValue( "visited_biomes_count", "0" ) )

-- to keep track of variables
set_internal_int( owner, "is_doing_time_trial", 1 )
set_internal_int( owner, "visited_biomes_count_on_trial_start", biomes_visited )
set_internal_int( owner, "hms_visited_on_trial_start", hms_visited )
set_internal_int( owner, "time_trial_update_count", 0 )
--addNewInternalVariable( owner, "time_trial_duration", "value_int", 60 )
set_internal_int( owner, "reached_time_trial_finish", 0 )
set_internal_int( owner, "time_trial_start_y", y )



-- if the gods are angry at the player, apply a viral infection
-- if( tonumber( GlobalsGetValue("STEVARI_DEATHS", 0) ) >= 3 and GlobalsGetValue( "TEMPLE_PEACE_WITH_GODS" ) ~= "1" ) then
--     GamePrintImportant( "The gods are still angry at you", "You're gonna have a hard time..." )
--     EntityIngestMaterial( owner, CellFactory_GetType( "magic_liquid_infected_healthium" ), 60 )
-- end

-- warps the player into the Holy Mountain's drop-down tunnel
--EntitySetTransform( owner, 190, y - 100 )
