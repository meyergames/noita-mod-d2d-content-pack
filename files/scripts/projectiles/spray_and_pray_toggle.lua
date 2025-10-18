dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local player = get_player()

function enabled_changed( entity_id, is_enabled )
	local enabled_int = 0
	if ( is_enabled ) then
		enabled_int = 1
	end

	local effect_id = getInternalVariableValue( player, "spray_and_pray_modifier_id", "value_int" )
	if ( effect_id == nil ) then
		local new_effect_id = EntityAddComponent( player, "ShotEffectComponent", { extra_modifier = "d2d_spray_and_pray" } )
		addNewInternalVariable( player, "spray_and_pray_modifier_id", "value_int", new_effect_id )
		effect_id = new_effect_id
	end

	EntitySetComponentIsEnabled( player, effect_id, is_enabled )
end