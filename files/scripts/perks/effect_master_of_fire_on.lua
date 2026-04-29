dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )

addNewInternalVariable( owner, "master_of_fire_is_effect_active", "value_int", 0 )
addNewInternalVariable( owner, "master_of_fire_shot_effect_id", "value_int", 0 )

local dmg_comp = EntityGetFirstComponent( owner, "DamageModelComponent" )
if exists( dmg_comp ) then
	local old_mtp = ComponentObjectGetValue2( dmg_comp, "damage_multipliers", "fire" )
	local new_mtp = old_mtp * 0.35
	ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "fire", new_mtp )
end
