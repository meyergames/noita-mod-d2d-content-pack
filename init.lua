ModLuaFileAppend("data/scripts/lib/utilities.lua", "mods/RiskRewardBundle/files/scripts/utilities.lua")

ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/RiskRewardBundle/files/scripts/actions.lua")
ModLuaFileAppend("data/scripts/gun/gun_extra_modifiers.lua", "mods/RiskRewardBundle/files/scripts/gun_extra_modifiers.lua")
--ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/RiskRewardBundle/files/scripts/perks.lua")
ModLuaFileAppend("data/scripts/status_effects/status_list.lua", "mods/RiskRewardBundle/files/scripts/status_effects/status_list.lua")
ModLuaFileAppend("data/scripts/item_spawnlists.lua", "mods/RiskRewardBundle/files/scripts/items.lua")
ModMaterialsFileAdd("mods/RiskRewardBundle/files/materials/materials.xml")

ModLuaFileAppend("data/scripts/gun/procedural/gun_procedural.lua", "mods/RiskRewardBundle/files/scripts/gun_procedural.lua")
ModLuaFileAppend("data/scripts/biome_scripts.lua", "mods/RiskRewardBundle/files/scripts/biome_scripts.lua")
ModLuaFileAppend("data/scripts/items/heart_fullhp_temple.lua", "mods/RiskRewardBundle/files/scripts/items/heart_fullhp_temple_custom.lua")
ModLuaFileAppend("data/scripts/items/orb_pickup.lua", "mods/RiskRewardBundle/files/scripts/items/orb_pickup_custom.lua")
-- ModLuaFileAppend("data/scripts/items/chest_random.lua", "mods/RiskRewardBundle/files/scripts/items/chest_random_cursed.lua")

function OnModPostInit()
    ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/RiskRewardBundle/files/scripts/perks.lua")

    -- dofile_once( "mods/RiskRewardBundle/files/scripts/actions.lua" )
    -- OrganiseProgress()
end

function OnPlayerSpawned(player)
  local x, y = EntityGetTransform(player)

    -- spawn spells
--    CreateItemActionEntity("D2D_PAYDAY", x+50, y)
--    CreateItemActionEntity("D2D_OVERCLOCK", x+20, y)
--    CreateItemActionEntity("D2D_BANDAID", x+20, y)
--    CreateItemActionEntity("D2D_EMERGENCY_INJECTION", x+20, y)
--    CreateItemActionEntity("D2D_PENETRATING_SHOT", x+20, y)
--    CreateItemActionEntity("D2D_GIGA_DRAIN", x+20, y)
--    CreateItemActionEntity("D2D_GHOSTLY_MESSENGER", x+20, y)

    -- spawn perks
    dofile_once( "data/scripts/perks/perk.lua" )
--    local perk = perk_spawn( -2, 4971, "D2D_TIME_TRIAL" )
--    local perk = perk_spawn( x+20, y-20, "PEACE_WITH_GODS" )
    -- local perk = perk_spawn( 750, -100, "D2D_SET_IN_STONE" )
--    local perk = perk_spawn( x+20, y, "D2D_MASTER_OF_THUNDER" )

    --spawn random perk
    dofile_once( "data/scripts/perks/perk_list.lua" )
    local valid_perk_found = false
    while( not valid_perk_found ) do
        perk_to_spawn = random_from_array( perk_list )
        valid_perk_found = not perk_to_spawn.not_in_default_perk_pool
    end

    -- GamePrint( ModSettingGet( "v2drrb.time_trial_on_start" ) )
    if ( ModSettingGet( "Vic2D's Risk/Reward Bundle.time_trial_on_start" ) ) then
        GamePrint("time trial on start enabled!")
        local perk = perk_spawn( 800, -100, "D2D_TIME_TRIAL" )
    else
        local perk = perk_spawn( 800, -100, perk_to_spawn.id )
    end

    -- EntityLoad( "mods/RiskRewardBundle/files/entities/items/pickup/chest_random_cursed_d2d.xml", 750, -100 )
    

    --spawn items
--    EntityLoad( "mods/RiskRewardBundle/files/entities/misc/speedrun_finish_hitbox.xml", 0, 0 )
--    EntityLoad( "mods/RiskRewardBundle/files/entities/misc/speedrun_finish_hitbox.xml", -681, 4992 )
    -- EntityLoad( "mods/RiskRewardBundle/files/entities/items/pickup/chest_random_cursed.xml", 750, -100 )
    -- EntitySetTransform( player, 700, -100 )
end



local translations = ModTextFileGetContent("data/translations/common.csv")
local new_translations = ModTextFileGetContent("mods/RiskRewardBundle/translations.csv")
translations = translations .. "\n" .. new_translations .. "\n"
translations = translations:gsub("\r", ""):gsub("\n\n+", "\n")
ModTextFileSetContent("data/translations/common.csv", translations)
