dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local px, py = EntityGetTransform( entity_id )

-- only try spawning the ghost if the player is in the collapsed mines
local biome_name = BiomeMapGetName( px, py )
if not string.find( GameTextGetTranslatedOrNot( biome_name ), "collapsed mines" ) then return end

local targets = EntityGetWithTag( "homing_target" )
if #targets > 0 then
    for i,target_id in ipairs( targets ) do
        local tx, ty = EntityGetTransform( target_id )

        -- if the enemy is west of the player and at least 300 units away, spawn one ancient ghost
        if distance_between( entity_id, target_id ) > 300 and tx < px then

            if GameHasFlagRun( "d2d_content_pack_ancient_ghost_spawned" ) then return end
            GameAddFlagRun( "d2d_content_pack_ancient_ghost_spawned" )

            -- spawn the ghost on top of the first faraway enemy
            EntityLoad( "mods/D2DContentPack/files/entities/animals/ancient_ghost.xml", tx, ty )

            -- remove this script from the player
            EntityRemoveComponent( entity_id, GetUpdatedComponentID() )
        end
    end
end
