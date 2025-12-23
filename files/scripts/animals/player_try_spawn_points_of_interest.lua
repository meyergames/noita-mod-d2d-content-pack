dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local px, py = EntityGetTransform( entity_id )

-- only try spawning the ghost if the player is in the collapsed mines
local biome_name = BiomeMapGetName( px, py )

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
                EntityLoad( "mods/D2DContentPack/files/entities/animals/ghost_of_memories.xml", tx, ty )

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

try_spawn_ghost_of_memories()
try_spawn_ancient_lurker()
