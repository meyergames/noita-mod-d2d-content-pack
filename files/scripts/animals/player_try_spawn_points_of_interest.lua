dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local px, py = EntityGetTransform( entity_id )

-- only try spawning the ghost if the player is in the collapsed mines
local biome_name = BiomeMapGetName( px, py )

function try_trigger_recent_update_message()
    if GameHasFlagRun( "d2d_poi_recent_update_message_displayed" ) then return end
    if not is_within_bounds( entity_id, 40, 400, 6640, 6800 ) then return end

    GameAddFlagRun( "d2d_poi_recent_update_message_displayed" )
    RemoveSettingFlag( "d2d_update_msg_displayed_ancient_lurker" )

    -- this print was added on 24 dec 2025; remove on 7 jan 2026
    if not HasFlagPersistent( "d2d_update_msg_displayed_ancient_lurker" ) then

        GamePrintImportant( "You sense an unfamiliar presence lurking in the Lukki Lair..." )

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

    if ModSettingGet( "D2DContentPack.spawn_ancient_lurker_manually" ) then
        if is_within_bounds( entity_id, -3900, -3750, 10000, 10150 ) then
            local nearby_hittables = EntityGetInRadiusWithTag( px, py, 200, "hittable" )
            for i,hittable_id in ipairs( nearby_hittables or {} ) do
                if exists( EntityGetFirstComponentIncludingDisabled( hittable_id, "OrbComponent" ) ) then
                    EntityAddComponent2( hittable_id, "LuaComponent", {
                        script_item_picked_up = "mods/D2DContentPack/files/scripts/animals/ancient_lurker_spawn.lua",
                        execute_every_n_frame = -1,
                    })
                    GameAddFlagRun( "d2d_poi_spawned_ancient_lurker" )
                end
            end
        end
    else
        EntityLoad( "mods/D2DContentPack/files/entities/animals/ancient_lurker.xml", -3840, 9850 )
        GameAddFlagRun( "d2d_poi_spawned_ancient_lurker" )
    end
end

function try_spawn_staff_of_finality()
    if GameHasFlagRun( "d2d_poi_spawned_staff_of_finality" ) then return end
    if not is_within_bounds( entity_id, 6800, 7900, -5400, -4500 ) then return end

    EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/staff_of_finality_stuck.xml", 7380, -5080 )
    GameAddFlagRun( "d2d_poi_spawned_staff_of_finality" )
end

function try_convert_chests_into_cursed()
    local chests = EntityGetWithTag( "chest" )
    if exists( chests ) and #chests > 0 then
        for i,chest in ipairs( chests ) do
            local was_tried_before = get_internal_bool( chest, "d2d_cursed_chest_convert_attempted" )

            if not was_tried_before and distance_between( get_player(), chest ) > 300 then
                local chance = 5
                if has_perk( "D2D_HUNT_CURSES" ) then
                    chance = 20
                end
                if Random( 1, 100 ) < chance then
                    local x, y = EntityGetTransform( chest )
                    EntityKill( chest )
                    EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/chest_random_cursed_d2d.xml", x, y )
                end

                set_internal_bool( chest, "d2d_cursed_chest_convert_attempted", true )
            end
        end
    end
end

function try_show_staff_of_loyalty_hints()
    if GameHasFlagRun( "d2d_poi_staff_of_loyalty_hint_3" ) then return end
    local held_wand = EZWand.GetHeldWand()
    if not exists( held_wand ) or not EntityHasTag( held_wand.entity_id, "d2d_starting_wand" ) then return end

    if not GameHasFlagRun( "d2d_poi_staff_of_loyalty_hint_3" ) then
        if is_within_bounds( entity_id, 1100, 1600, 5750, 6250 ) then
            GamePrint( "Your wand is starting to burn your fingers!" )
            GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/on_fire/create", px, py )
            GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/frozen/create", px, py )
            GameAddFlagRun( "d2d_poi_staff_of_loyalty_hint_3" )
            return
        end
        
        if not GameHasFlagRun( "d2d_poi_staff_of_loyalty_hint_2" ) then
            if is_within_bounds( entity_id, 600, 1600, 5600, 6250 ) then
                GamePrint( "Your wand is starting to glow hot..." )
                GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/on_fire/create", px, py )
                GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/frozen/create", px, py )
                GameAddFlagRun( "d2d_poi_staff_of_loyalty_hint_2" )
                return
            end
            
            if not GameHasFlagRun( "d2d_poi_staff_of_loyalty_hint_1" ) then
                if is_within_bounds( entity_id, -100, 1600, 5250, 6250 ) then
                    GamePrint( "Your wand feels warm to the touch..." )
                    GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/on_fire/create", px, py )
                    GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/frozen/create", px, py )
                    GameAddFlagRun( "d2d_poi_staff_of_loyalty_hint_1" )
                    return
                end
            end
        end
    end
end

function try_upgrade_staff_of_loyalty()
    if GameHasFlagRun( "d2d_poi_upgraded_staff_of_loyalty" ) then return end
    if not is_within_bounds( entity_id, 1750, 2680, 13050, 13275 ) then return end

    local held_wand = EZWand.GetHeldWand()
    if exists( held_wand ) and EntityHasTag( held_wand.entity_id, "d2d_staff_of_loyalty" ) then
        upgrade_staff_of_loyalty( held_wand )
        GameAddFlagRun( "d2d_poi_upgraded_staff_of_loyalty" )
    end
end

function try_reroll_challenge_perks()
    local nearby_perks = EntityGetWithTag( "perk" )
    for i,perk in ipairs( nearby_perks ) do
        local CHALLENGE_PERK_NAMES = "D2D_TIME_TRIAL,D2D_GLASS_HEART"
        local perk_id = get_internal_string( perk, "perk_id" )
        local x, y = EntityGetTransform( perk )
        local perk_biome = BiomeMapGetName( x, y )
        if exists( perk_id ) and string.find( CHALLENGE_PERK_NAMES, perk_id )
        and not ( string.find( perk_biome, "holy" ) or string.find( perk_biome, "EMPTY" ) ) then
            -- briefly set perk destroy chance to 0, so other perks remain
            -- (code copied from D2D_BLESSINGS_AND_CURSE)
            local value_to_cache = GlobalsGetValue( "TEMPLE_PERK_DESTROY_CHANCE", 100 )
            set_internal_int( get_player(), "blurse_cached_perk_destroy_chance", tonumber( value_to_cache ) )
            GlobalsSetValue( "TEMPLE_PERK_DESTROY_CHANCE", 0 )
            EntityAddComponent( entity_who_picked, "LuaComponent", 
            {
                _tags="perk_component",
                script_source_file="mods/D2DContentPack/files/scripts/perks/effect_blessings_and_curse_revert.lua",
                execute_every_n_frame="3",
                remove_after_executed="1",
            } )

            dofile_once( "data/scripts/perks/perk.lua" )
            perk_spawn_random( x, y, false )

            -- below message is irrelevant since the player should not even see the perk appear
            -- local itemcomp = EntityGetFirstComponent( perk, "ItemComponent" )
            -- if exists( itemcomp ) then
            --     local perk_name = GameTextGetTranslatedOrNot( ComponentGetValue2( itemcomp, "item_name" ) )
            --     if exists( perk_name ) then
            --         GamePrint( "The '" .. perk_name .. "' perk was rerolled" )
            --         GamePrint( "(Challenge Perks can't be taken outside of Holy Mountains)" )
            --     end
            -- end

            EntityKill( perk )
        end
    end
end


try_trigger_recent_update_message()
try_spawn_ghost_of_memories()
try_spawn_ancient_lurker()
try_spawn_staff_of_finality()
try_convert_chests_into_cursed()
try_show_staff_of_loyalty_hints()
try_upgrade_staff_of_loyalty()
try_reroll_challenge_perks()
