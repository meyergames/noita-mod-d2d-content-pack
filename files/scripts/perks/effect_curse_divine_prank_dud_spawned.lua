dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )

local effect_id = getInternalVariableValue( owner, "divine_prank_propane_effect_id", "value_int" )
if effect_id ~= nil and effect_id > -1 then
	EntityRemoveComponent( owner, effect_id )
    setInternalVariableValue( owner, "divine_prank_propane_effect_id", "value_int", -1 )
	GamePrint("propane modifier removed!")
end
