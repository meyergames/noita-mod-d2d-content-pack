dofile_once("data/scripts/lib/utilities.lua")

GamePrint("testingggggg bomberman_start.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity( entity_id )

GamePrint("testingggggg bomberman_start.lua x2")

comp = EntityGetFirstComponent( owner, "DamageModelComponent" )


--if( GameHasFlagRun( "PERK_PICKED_PROTECTION_EXPLOSION" ) ) then
--    remove_perk( "PROTECTION_EXPLOSION" )
--    EntityAddComponent2( owner, "UIIconComponent",
--    {
--        name = "Explosion Immunity (nullified)",
--        description = "This perk no longer provides immunity to explosions.",
--        icon_sprite_file = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_protection_explosion_nullified.png",
--        display_above_head = false,
--        display_in_hud = true,
--        is_perk = true,
--    })
--end
--
--if( GameHasFlagRun( "PERK_PICKED_EXPLODING_CORPSES" ) ) then
--    remove_perk( "PROTECTION_EXPLOSION" )
--    EntityAddComponent2( owner, "UIIconComponent",
--    {
--        name = "Exploding Corpses (nullified)",
--        description = "This perk no longer provides immunity to explosions.",
--        icon_sprite_file = "mods/cheytaq_first_mod/files/gfx/ui_gfx/perk_exploding_corpses_nullified.png",
--        display_above_head = false,
--        display_in_hud = true,
--        is_perk = true,
--    })
--end

EntityAddComponent( owner, "ShotEffectComponent", { extra_modifier = "ctq_bomberman_boost" } )



--if ( comp ~= nil ) then
--	local old_mtp = ComponentObjectGetValue2( comp, "damage_multipliers", "fire" )
--	local new_mtp = old_mtp * -0.1
--    GamePrint("mtp old: " .. old_mtp)
--	ComponentObjectSetValue2( comp, "damage_multipliers", "fire", new_mtp )
--    GamePrint("mtp new: " .. ComponentObjectGetValue2( comp, "damage_multipliers", "fire" ) )
--end
