dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )

local is_immune_to_fire = has_game_effect( owner, "PROTECTION_FIRE" )
if ( is_immune_to_fire ) then
   if ( GameHasFlagRun( "PERK_PICKED_PROTECTION_FIRE" ) ) then
   	remove_perk( "PROTECTION_FIRE" )
   end

   if ( GameHasFlagRun( " PERK_PICKED_BLEED_OIL" ) ) then
   	remove_perk( "BLEED_OIL" )
   end

   if ( GameHasFlagRun( " PERK_PICKED_FREEZE_FIELD" ) ) then
   	remove_perk( "FREEZE_FIELD" )
   end
end

addNewInternalVariable( owner, "pyrelord_is_effect_active", "value_int", 0 )
addNewInternalVariable( owner, "pyrelord_shot_effect_id", "value_int", 0 )
addNewInternalVariable( owner, "pyrelord_mana_charge_speed_mtp", "value_int", 25 )

-- comp = EntityGetFirstComponent( owner, "DamageModelComponent" )
-- if ( comp ~= nil ) then
-- 	local old_mtp = ComponentObjectGetValue2( comp, "damage_multipliers", "fire" )
-- 	local new_mtp = 0.0
--    GamePrint("mtp old: " .. old_mtp)
-- 	ComponentObjectSetValue2( comp, "damage_multipliers", "fire", new_mtp )
--    GamePrint("mtp new: " .. ComponentObjectGetValue2( comp, "damage_multipliers", "fire" ) )
-- end
