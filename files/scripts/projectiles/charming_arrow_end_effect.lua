dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local parent_id = EntityGetParent( entity_id )
local comp_id = GetUpdatedComponentID()

GamePrint( "COUNTING DOWN FR" )
local charm_effect_id = GameGetGameEffect( parent_id, "CHARM" )
if charm_effect_id ~= 0 then
	EntityRemoveComponent( parent_id, charm_effect_id )
	GamePrint( "EFFECT REMOVED?? ok not yet, apparently / we'll do this later" )
end
