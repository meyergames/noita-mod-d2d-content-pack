dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local owner = EntityGetInRadiusWithTag( x, y, 2, "homing_target" )[1]

if owner then
	LoadGameEffectEntityTo( owner, "data/entities/misc/effect_berserk.xml" )
end
