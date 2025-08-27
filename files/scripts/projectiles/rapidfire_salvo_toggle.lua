dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local player = get_player()

function enabled_changed( entity_id, is_enabled )
	local enabled_int = 0
	if ( is_enabled ) then
		enabled_int = 1
	end

	local effect_id = getInternalVariableValue( player, "rapidfire_salvo_modifier_id", "value_int" )
	if ( effect_id == nil ) then
		local new_effect_id = EntityAddComponent( player, "ShotEffectComponent", { extra_modifier = "ctq_rapidfire_salvo" } )
		addNewInternalVariable( player, "rapidfire_salvo_modifier_id", "value_int", new_effect_id )
		effect_id = new_effect_id
	end

	EntitySetComponentIsEnabled( player, effect_id, is_enabled )
	-- if ( is_enabled ) then
	-- 	setInternalVariableValue( player, "volley_modifier_id", "value_int", new_effect_id )
	-- else
	-- 	GamePrint("Trying to remove " .. getInternalVariableValue( entity_id, "volley_modifier_id", "value_int" ) .. "..." )
	-- 	if ( getInternalVariableValue( entity_id, "volley_modifier_id", "value_int" ) ~= nil ) then
	-- 		GamePrint( "Removing component " .. getInternalVariableValue( entity_id, "volley_modifier_id", "value_int" ) .. "..." )
	-- 		EntityRemoveComponent( player, getInternalVariableValue( entity_id, "volley_modifier_id", "value_int" ) )
	-- 		setInternalVariableValue( entity_id, "volley_modifier_id", "value_int", -1 )
	-- 	end
	-- end
end