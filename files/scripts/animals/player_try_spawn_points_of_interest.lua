dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local px, py = EntityGetTransform( entity_id )

-- only try spawning the ghost if the player is in the collapsed mines
local biome_name = BiomeMapGetName( px, py )

function try_trigger_recent_update_message()
    if GameHasFlagRun( "d2d_poi_recent_update_message_displayed" ) then return end
    if not is_within_bounds( entity_id, -165, 115, 6400, 6600 ) then return end

    GameAddFlagRun( "d2d_poi_recent_update_message_displayed" )

    -- this print was added on 24 dec 2025; remove on 7 jan 2026
    if not HasFlagPersistent( "d2d_update_msg_displayed_ancient_lurker" ) then

        GamePrintImportant( "An unfamiliar presence lurks within the Lukki Lair..." )
        GamePrintDelayed( "[D2D] A new boss can be found at the bottom of the Lukki Lair.", 300 )

        GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/orb_distant_monster/create", px, py )
        GameScreenshake( 75 )

        AddFlagPersistent( "d2d_update_msg_displayed_ancient_lurker" )
    elseif ModSettingGet( "D2DContentPack.enable_repeating_update_messages" ) then
        GamePrint( "[D2D] A new boss can be found lurking deep within the Lukki Lair..." )
    end
end

function try_spawn_ghost_of_memories()
    if GameHasFlagRun( "d2d_poi_spawned_ghost_of_memories" ) then return end
    if not is_within_bounds( entity_id, -1548, -1024, 392, 1110 ) then return end

    local targets = EntityGetWithTag( "homing_target" )
    if #targets > 0 then
        for i,target_id in ipairs( targets ) do
            local tx, ty = EntityGetTransform( target_id )

            -- if the enemy is west of the player and at least 300 units away, spawn the ghost
            if distance_between( entity_id, target_id ) > 300 and tx < px then

                -- spawn the ghost on top of the first faraway enemy
                EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/staff_of_remembrance_stuck.xml", tx, ty )
                
                -- add flag so this function isn't run again
                GameAddFlagRun( "d2d_poi_spawned_ghost_of_memories" )

                -- return so it only spawns one ghost
                return
            end
        end
    end
end

function try_spawn_ancient_lurker()
    if GameHasFlagRun( "d2d_poi_spawned_ancient_lurker" ) then return end
    if not is_within_bounds( entity_id, -4250, -3500, 9600, 10300 ) then return end

    EntityLoad( "mods/D2DContentPack/files/entities/animals/ancient_lurker.xml", -3840, 9850 )
    GameAddFlagRun( "d2d_poi_spawned_ancient_lurker" )
end

try_trigger_recent_update_message()
try_spawn_ghost_of_memories()
try_spawn_ancient_lurker()
