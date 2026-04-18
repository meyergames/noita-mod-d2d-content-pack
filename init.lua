ModLuaFileAppend("data/scripts/lib/utilities.lua", "mods/D2DContentPack/files/scripts/utilities.lua")

ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/D2DContentPack/files/scripts/actions.lua")
-- ModLuaFileAppend("data/scripts/gun/gun.lua", "mods/D2DContentPack/files/scripts/gun.lua")
ModLuaFileAppend("data/scripts/gun/gun_extra_modifiers.lua", "mods/D2DContentPack/files/scripts/gun_extra_modifiers.lua")
--ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/D2DContentPack/files/scripts/perks.lua")
ModLuaFileAppend("data/scripts/status_effects/status_list.lua", "mods/D2DContentPack/files/scripts/status_effects/status_list.lua")
ModLuaFileAppend("data/scripts/item_spawnlists.lua", "mods/D2DContentPack/files/scripts/items.lua")
ModMaterialsFileAdd("mods/D2DContentPack/files/materials/materials.xml")

ModLuaFileAppend("data/scripts/gun/procedural/gun_procedural.lua", "mods/D2DContentPack/files/scripts/gun_procedural.lua")
ModLuaFileAppend("data/scripts/buildings/forge_item_convert.lua", "mods/D2DContentPack/files/scripts/buildings/forge_item_convert.lua")
ModLuaFileAppend("data/scripts/biomes/temple_altar.lua", "mods/D2DContentPack/files/scripts/biomes/temple_altar.lua")
ModLuaFileAppend("data/scripts/items/heart_fullhp_temple.lua", "mods/D2DContentPack/files/scripts/items/heart_fullhp_temple_custom.lua")
ModLuaFileAppend("data/scripts/items/orb_pickup.lua", "mods/D2DContentPack/files/scripts/items/orb_pickup_custom.lua")
ModLuaFileAppend("data/scripts/items/generate_shop_item.lua", "mods/D2DContentPack/files/scripts/items/generate_shop_item.lua")
ModLuaFileAppend( "data/scripts/gun/gun.lua", "mods/D2DContentPack/files/scripts/gun_append.lua" )

if ModIsEnabled( "Apotheosis" ) then
    ModLuaFileAppend( "mods/Apotheosis/files/scripts/animals/cat_pet.lua", "mods/D2DContentPack/files/scripts/animals/cat_pet.lua" )
end

if ModIsEnabled("anvil_of_destiny") then
  ModLuaFileAppend("mods/anvil_of_destiny/files/scripts/modded_content.lua", "mods/D2DContentPack/files/scripts/aod/aod_modded_content_append.lua")
end

function OnModInit()
    if ModIsEnabled( "Apotheosis" ) then
        local file = "mods/Apotheosis/data/entities/animals/wraith_returner_apotheosis.xml"
        local content = ModTextFileGetContent( file )
        content = content:gsub(
            "<Entity name=\"$enemy_apotheosis_wraith_returner_apotheosis\" >",
            "<Entity name=\"$enemy_apotheosis_wraith_returner_apotheosis\" tags=\"d2d_apoth_wraith_returner\" >")
        ModTextFileSetContent( file, content )
        -- GamePrint("GSUBBED BABY")
    end

    -- if ModIsEnabled( "gkbrkn_noita" ) then
    --     local file = "mods/gkbrkn_noita/files/gkbrkn/misc/player_damage_received.lua"
    --     local content = ModTextFileGetContent( file )
    --     content = content:gsub(
    --         "if not EntityHasVar( action, \"gkbrkn_blue_magic_projectile_file\" ) then",
    --         "if true then" )
    --     ModTextFileSetContent( file, content )
    --     GamePrint("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    -- end
end

function OnModPostInit()
    ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/D2DContentPack/files/scripts/perks.lua")
    -- ModLuaFileAppend("data/scripts/gun/procedural/starting_wand.lua", "mods/D2DContentPack/files/scripts/items/wands/starting_wand_append.lua")

    dofile_once( "mods/D2DContentPack/files/scripts/d2d_gsubs.lua" )

end

function OnPlayerSpawned( player )
    if GameHasFlagRun( "d2d_content_pack_init_happened" ) then return end
    GameAddFlagRun( "d2d_content_pack_init_happened" )

    if not HasFlagPersistent( "d2d_force_init_mod_settings" ) then
        ModSettingSet( "D2D_TINKER_WITH_WANDS_MORE_disabled", true )
        ModSettingSet( "D2D_STABILIZE_disabled", true )
        AddFlagPersistent( "d2d_force_init_mod_settings" )
    end
    if ModIsEnabled( "new_enemies" ) then
        ModSettingSet( "D2DContentPack.spawn_ancient_lurker_manually", true )
    end

    dofile_once( "data/scripts/lib/utilities.lua" )
    dofile_once( "data/scripts/perks/perk.lua" )
    dofile( "mods/D2DContentPack/files/scripts/actions.lua" )
    dofile( "mods/D2DContentPack/files/scripts/perks.lua" )

    -- maybe spawn a challenge perk
    if ModSettingGet( "D2DContentPack.spawn_challenge_perk_sometimes" ) then
        local rnd = Random( 0, 100 )
        if ( rnd <= 5 ) then
            local rnd2 = Random( 1, 2 )
            if rnd2 == 1 then
                local perk = perk_spawn( 800, -100, "D2D_TIME_TRIAL" )
            elseif rnd2 == 2 then
                local perk = perk_spawn( 800, -100, "D2D_GLASS_HEART" )
            end
        end
    end

    -- spawn perks at start, if the player chose any in the mod settings
    for k, v in pairs( d2d_actions ) do
        if HasSettingFlag( v.id.."_spawn_at_start" ) then
            CreateItemActionEntity( v.id, 800, -100 )
        end
    end
    for k, v in pairs( d2d_perks ) do
        if HasSettingFlag( v.id.."_spawn_at_start" ) then
            perk_spawn( 800, -100, v.id, true )
        end
    end
    for k, v in pairs( d2d_perk_reworks ) do
        if HasSettingFlag( v.id.."_spawn_at_start" ) then
            perk_spawn( 800, -100, v.id, true )
        end
    end
    for k, v in pairs( d2d_curses ) do
        if HasSettingFlag( v.id.."_spawn_at_start" ) then
            perk_spawn( 800, -100, v.id, true )
        end
    end
    for k, v in pairs( d2d_blurses ) do
        if HasSettingFlag( v.id.."_spawn_at_start" ) then
            perk_spawn( 800, -100, v.id, true )
        end
    end

    dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )

    EntityAddComponent( player, "LuaComponent", 
    {
        script_source_file="mods/D2DContentPack/files/scripts/perks/challenge_perk_scan.lua",
        execute_every_n_frame="60",
    } )

    EntityAddComponent( player, "LuaComponent", 
    {
        script_source_file="mods/D2DContentPack/files/scripts/animals/player_try_spawn_points_of_interest.lua",
        execute_every_n_frame="60",
    } )

    -- this is for Blue Magic
    EntityAddComponent( player, "LuaComponent", 
    {
        script_damage_received="mods/D2DContentPack/files/scripts/animals/player_damage_received.lua",
    } )
    
    local rnd = Random( 1, 100 )
    local spawn_loadout = rnd <= ModSettingGet( "D2DContentPack.loadout_spawn_chance" )
                          or not HasFlagPersistent( "d2d_class_loadouts_introduced" )
    if spawn_loadout then
        dofile_once( "mods/D2DContentPack/files/scripts/loadouts/init_loadouts.lua" )
    end

    EntityAddComponent2( player, "ShotEffectComponent", {
        extra_modifier = "d2d_proj_dmg_mtp",
    })
end

local translations = ModTextFileGetContent("data/translations/common.csv")
local new_translations = ModTextFileGetContent("mods/D2DContentPack/translations.csv")
translations = translations .. "\n" .. new_translations .. "\n"
translations = translations:gsub("\r", ""):gsub("\n\n+", "\n")
ModTextFileSetContent("data/translations/common.csv", translations)
