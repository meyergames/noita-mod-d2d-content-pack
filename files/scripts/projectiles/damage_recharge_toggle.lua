dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local player = get_player()

function enabled_changed( entity_id, is_enabled )
	local has_modifier = get_internal_bool( get_player(), "d2d_damage_recharge_modifier_applied" ) or false
	if not has_modifier then
		EntityAddComponent( player, "ShotEffectComponent", { extra_modifier = "d2d_damage_recharge" } )
		set_internal_bool( get_player(), "d2d_damage_recharge_modifier_applied", true )
	end
	
	set_internal_bool( get_player(), "d2d_damage_recharge_enabled", is_enabled )
end