dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )

addNewInternalVariable( owner, "master_of_lightning_is_effect_active", "value_int", 0 )
addNewInternalVariable( owner, "master_of_lightning_shot_effect_id", "value_int", 0 )
addNewInternalVariable( owner, "master_of_lightning_extra_boost_timer", "value_int", 0 )
addNewInternalVariable( owner, "master_of_lightning_mana_charge_speed_mtp", "value_int", 0 )

--comp = EntityGetFirstComponent( owner, "DamageModelComponent" )
--if ( comp ~= nil ) then
--	local old_mtp = ComponentObjectGetValue2( comp, "damage_multipliers", "fire" )
--	local new_mtp = old_mtp * 0.5
--    GamePrint("mtp old: " .. old_mtp)
--	ComponentObjectSetValue2( comp, "damage_multipliers", "fire", new_mtp )
--    GamePrint("mtp new: " .. ComponentObjectGetValue2( comp, "damage_multipliers", "fire" ) )
--end
