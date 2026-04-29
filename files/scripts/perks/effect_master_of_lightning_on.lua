dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )

addNewInternalVariable( owner, "master_of_lightning_is_effect_active", "value_int", 0 )
addNewInternalVariable( owner, "master_of_lightning_shot_effect_id", "value_int", 0 )
addNewInternalVariable( owner, "master_of_lightning_extra_boost_timer", "value_int", 0 )
addNewInternalVariable( owner, "master_of_lightning_mana_charge_speed_mtp", "value_int", 0 )

local dmg_comp = EntityGetFirstComponent( owner, "DamageModelComponent" )
if exists( dmg_comp ) then
	local old_mtp = ComponentObjectGetValue2( dmg_comp, "damage_multipliers", "electricity" )
	local new_mtp = 0.35
	ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "electricity", new_mtp )
end
