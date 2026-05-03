dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local px, py = EntityGetTransform( entity_id )

-- only try spawning the ghost if the player is in the collapsed mines
local biome_name = BiomeMapGetName( px, py )

local function try_spawn( filename, spawn_x, spawn_y )
    if get_distance( px, py, spawn_x, spawn_y ) > 512 then
        return false
    end

    EntityLoad( filename, spawn_x, spawn_y )
    return true
end

function try_trigger_recent_update_message()
    if GameHasFlagRun( "d2d_poi_recent_update_message_displayed" ) then return end
    if not is_within_bounds( entity_id, 600, 800, -240, -80 ) then return end

    GameAddFlagRun( "d2d_poi_recent_update_message_displayed" )
    RemoveFlagPersistent( "d2d_update_msg_displayed_cursed_chests" )

    -- this print was added on 10 apr 2026
    if not HasFlagPersistent( "d2d_update_msg_displayed_toolbox" ) then

        GamePrint( "[D2D] UPDATE: The Summon Toolbox perk has received a buff!" )
        GamePrintDelayed( "[D2D] UPDATE: Toolboxes can now contain a variety of Passive and Other-type spells.", 120 )

        AddFlagPersistent( "d2d_update_msg_displayed_toolbox" )
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
    if try_spawn( "mods/D2DContentPack/files/entities/items/pickup/staff_of_finality_stuck.xml", 250, -26130 ) then
        GameAddFlagRun( "d2d_poi_spawned_staff_of_finality" )
    end
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

function try_spawn_afa_copy_1()
    if GameHasFlagRun( "d2d_afa_copy_1_spawned" ) then return end
    if not is_within_bounds( entity_id, -4600, -4000, 3500, 4200 ) then return end
    -- in the orb room next to the early Magical Temple

    CreateItemActionEntity( "D2D_ALT_FIRE_ANYTHING", -4324, 3859 )

    GameAddFlagRun( "d2d_afa_copy_1_spawned" )
end

function try_spawn_afa_copy_2()
    if GameHasFlagRun( "d2d_afa_copy_2_spawned" ) then return end
    if not is_within_bounds( entity_id, -4250, -3500, 9700, 10300 ) then return end
    -- in the orb room at the bottom of the Lukki Lair

    CreateItemActionEntity( "D2D_ALT_FIRE_ANYTHING", -3810, 10102 )
    
    GameAddFlagRun( "d2d_afa_copy_2_spawned" )
end

function try_spawn_afa_copy_3()
    if GameHasFlagRun( "d2d_afa_copy_3_spawned" ) then return end
    if not is_within_bounds( entity_id, 10100, 11000, 15750, 16500 ) then return end
    -- in the orb room at the bottom of the Wizards' Den

    CreateItemActionEntity( "D2D_ALT_FIRE_ANYTHING", 10526, 16160 )
    
    GameAddFlagRun( "d2d_afa_copy_3_spawned" )
end

function try_spawn_afa_copies()
    if ModIsEnabled( "alt_fire_anything" ) then return end
    if ModSettingGet( "D2D_ALT_FIRE_ANYTHING_disabled" ) then return end

    try_spawn_afa_copy_1()
    try_spawn_afa_copy_2()
    try_spawn_afa_copy_3()
end

function try_spawn_staff_of_nutrition()
    if GameHasFlagRun( "d2d_poi_spawned_staff_of_nutrition" ) then return end
    if not is_within_bounds( entity_id, 0, 400, 6650, 7000 ) then return end

    local targets = EntityGetWithTag( "homing_target" )
    if #targets > 0 then
        for i,target_id in ipairs( targets ) do
            local tx, ty = EntityGetTransform( target_id )

            -- if the enemy is west of the player and at least 300 units away, spawn the ghost
            if distance_between( entity_id, target_id ) > 300 and ty > 6650 then

                -- spawn the ghost on top of the first faraway enemy
                EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/staff_of_nutrition_stuck.xml", tx, ty )
                
                -- add flag so this function isn't run again
                GameAddFlagRun( "d2d_poi_spawned_staff_of_nutrition" )

                -- return so it only spawns one ghost
                return
            end
        end
    end
end

function try_cap_max_health()
    if not ModSettingGet( "D2DContentPack.cap_max_health" ) and not GameHasFlagRun( "d2d_afterlife_health_cap" ) then return end

    local dmg_comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
    if exists( dmg_comp ) then
        local p_hp = ComponentGetValue2( dmg_comp, "hp" )
        local p_max_hp = ComponentGetValue2( dmg_comp, "max_hp" )

        local HP_LIMIT = 40
        if p_max_hp > HP_LIMIT then
            ComponentSetValue2( dmg_comp, "max_hp", HP_LIMIT )

            if p_hp > HP_LIMIT then
                ComponentSetValue2( dmg_comp, "hp", HP_LIMIT )
            end

            if p_max_hp >= 41 then
                if ModSettingGet( "D2DContentPack.cap_max_health" ) then
                    GamePrint( "[D2D] You've chosen to cap your max health." )
                    GamePrintDelayed( "[D2D] This limit can be removed in mod settings.", 120 )

                    local shield = EntityLoad( "mods/D2DContentPack/files/entities/misc/health_cap_shield.xml", px, py )
                    EntityAddChild( entity_id, shield )
                else
                    GamePrint( "Your max health is limited to 1000 due to Afterlife." )
                end
            end
        end
    end
end

function try_add_staff_drop_to_reflective_weirdo()
    if GameHasFlagRun( "d2d_poi_spawned_staff_of_light" ) then return end

    local targets = EntityGetWithTag( "d2d_apoth_wraith_returner" )
    if exists( targets ) then
        for i,target in ipairs( targets ) do
            if is_within_bounds( entity_id, -5200, -4500, 400, 1000 ) then
                -- kill the wraith and spawn the staff
            end
            local had_staff_drop_added = get_internal_bool( target, "had_staff_drop_added" )
            if not had_staff_drop_added then
                set_internal_bool( target, "had_staff_drop_added", true )
                EntityAddComponent2( target, "LuaComponent", {
                    script_death = "mods/D2DContentPack/files/scripts/animals/wraith_returner_drop_staff.lua"
                })
            end
        end
    end
end

function try_spawn_indulgence_copy_1()
    if GameHasFlagRun( "d2d_indulgence_copy_1_spawned" ) then return end
    if not is_within_bounds( entity_id, 14800, 15400, -3600, -3000 ) then return end
    
    CreateItemActionEntity( "D2D_INDULGENCE_ALT_FIRE", 15100, -3333 )
    if not HasFlagPersistent( "d2d_indulgence_unlocked" ) then
        AddFlagPersistent( "d2d_indulgence_unlocked" )
    end

    GameAddFlagRun( "d2d_indulgence_copy_1_spawned" )
end

function try_spawn_indulgence_copy_2()
    if GameHasFlagRun( "d2d_indulgence_copy_2_spawned" ) then return end
    if not is_within_bounds( entity_id, -14300, -13700, 16300, 16900 ) then return end

    CreateItemActionEntity( "D2D_INDULGENCE_ALT_FIRE", 14075, 16625 )
    if not HasFlagPersistent( "d2d_indulgence_unlocked" ) then
        AddFlagPersistent( "d2d_indulgence_unlocked" )
    end

    GameAddFlagRun( "d2d_indulgence_copy_2_spawned" )
end

function try_spawn_guaranteed_cursed_chest()
    if GameHasFlagRun( "d2d_guaranteed_cursed_chest_spawned" ) then return end

    local spawn_x, spawn_y = -3325, 3575
    if get_distance( px, py, spawn_x, spawn_y ) > 512 then return end

    EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/chest_random_cursed_d2d.xml", spawn_x, spawn_y )
    GameAddFlagRun( "d2d_guaranteed_cursed_chest_spawned" )
end

function try_spawn_lodestone()
    if GameHasFlagRun( "d2d_lodestone_spawned" ) then return end

    local spawn_x, spawn_y = 2717, 12277
    if get_distance( px, py, spawn_x, spawn_y ) > 512 then return end

    EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/lodestone.xml", spawn_x, spawn_y )
    CreateItemActionEntity( "D2D_LODESTONE_PORTAL", spawn_x, spawn_y - 20 )
    EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/books/book_lodestone.xml", spawn_x - 20, spawn_y )
    
    GameAddFlagRun( "d2d_lodestone_spawned" )
end

function try_destroy_old_apoth_lukki_portals()
    local new_x
    local new_y
    local red_portals = EntityGetWithTag( "lukki_portal_red" )
    local green_portals = EntityGetWithTag( "lukki_portal_green" )
    local blue_portals = EntityGetWithTag( "lukki_portal_blue" )
    local portal_x
    local portal_y

    for i,portal in ipairs( red_portals ) do
        new_x = tonumber( GlobalsGetValue( "D2D_APOTH_RED_PORTAL_X", "0" ) )
        new_y = tonumber( GlobalsGetValue( "D2D_APOTH_RED_PORTAL_Y", "0" ) )
        portal_x, portal_y = EntityGetTransform( portal )
        if get_distance( portal_x, portal_y, new_x, new_y ) > 30 then
            EntityKill( portal )
        else
            local was_biome_name_set = get_internal_bool( portal, "d2d_apoth_portal_destination_set" )
            if not was_biome_name_set then
                local dest_x = GlobalsGetValue( "apotheosis_markerportal_red_x", "0" )
                local dest_y = GlobalsGetValue( "apotheosis_markerportal_red_y", "0" )
                local biome_name = GameTextGetTranslatedOrNot( BiomeMapGetName( dest_x, dest_y ) )
                if biome_name == "_EMPTY_" then biome_name = "the surface" end

                EntityAddComponent2( portal, "UIInfoComponent", {
                    name = "Portal to " .. biome_name
                } )
                set_internal_bool( portal, "d2d_apoth_portal_destination_set", true )
            end
        end
    end
    for i,portal in ipairs( green_portals ) do
        new_x = tonumber( GlobalsGetValue( "D2D_APOTH_GREEN_PORTAL_X", "0" ) )
        new_y = tonumber( GlobalsGetValue( "D2D_APOTH_GREEN_PORTAL_Y", "0" ) )
        portal_x, portal_y = EntityGetTransform( portal )
        if get_distance( portal_x, portal_y, new_x, new_y ) > 30 then
            EntityKill( portal )
        else
            local was_biome_name_set = get_internal_bool( portal, "d2d_apoth_portal_destination_set" )
            if not was_biome_name_set then
                local dest_x = GlobalsGetValue( "apotheosis_markerportal_green_x", "0" )
                local dest_y = GlobalsGetValue( "apotheosis_markerportal_green_y", "0" )
                local biome_name = GameTextGetTranslatedOrNot( BiomeMapGetName( dest_x, dest_y ) )
                if biome_name == "_EMPTY_" then biome_name = "the surface" end

                EntityAddComponent2( portal, "UIInfoComponent", {
                    name = "Portal to " .. biome_name
                } )
                set_internal_bool( portal, "d2d_apoth_portal_destination_set", true )
            end
        end
    end
    for i,portal in ipairs( blue_portals ) do
        new_x = tonumber( GlobalsGetValue( "D2D_APOTH_BLUE_PORTAL_X", "0" ) )
        new_y = tonumber( GlobalsGetValue( "D2D_APOTH_BLUE_PORTAL_Y", "0" ) )
        portal_x, portal_y = EntityGetTransform( portal )
        if get_distance( portal_x, portal_y, new_x, new_y ) > 30 then
            EntityKill( portal )
        else
            local was_biome_name_set = get_internal_bool( portal, "d2d_apoth_portal_destination_set" )
            if not was_biome_name_set then
                local dest_x = GlobalsGetValue( "apotheosis_markerportal_blue_x", "0" )
                local dest_y = GlobalsGetValue( "apotheosis_markerportal_blue_y", "0" )
                local biome_name = GameTextGetTranslatedOrNot( BiomeMapGetName( dest_x, dest_y ) )
                if biome_name == "_EMPTY_" then biome_name = "the surface" end

                EntityAddComponent2( portal, "UIInfoComponent", {
                    name = "Portal to " .. biome_name
                } )
                set_internal_bool( portal, "d2d_apoth_portal_destination_set", true )
            end
        end
    end
end

function try_apply_mana_battery()
    if get_perk_pickup_count( "D2D_MANA_BATTERY" ) == 0 then return end

    local wands = EntityGetWithTag( "wand" )
    if not exists( wands ) then return end
    
    for i,wand_id in ipairs( wands ) do
        local already_applied = get_internal_bool( wand_id, "d2d_mana_battery_applied" )
        if not already_applied and EZWand.IsWand( wand_id ) then
            local wand = EZWand( wand_id )
            wand.manaMax = wand.manaMax * 10 + Random( 0, 9 )
            wand.mana = wand.manaMax
            wand.manaChargeSpeed = 0
            set_internal_bool( wand_id, "d2d_mana_battery_applied", true )
        end
    end
end

try_trigger_recent_update_message()
try_spawn_ghost_of_memories()
try_spawn_ancient_lurker()
-- try_spawn_staff_of_finality()
try_convert_chests_into_cursed()
try_show_staff_of_loyalty_hints()
try_upgrade_staff_of_loyalty()
try_reroll_challenge_perks()
try_spawn_afa_copies()
try_spawn_staff_of_nutrition()
try_cap_max_health()
-- try_add_staff_drop_to_reflective_weirdo()
try_spawn_indulgence_copy_1()
try_spawn_indulgence_copy_2()
try_spawn_guaranteed_cursed_chest()
try_spawn_lodestone()
try_destroy_old_apoth_lukki_portals()
try_apply_mana_battery()
