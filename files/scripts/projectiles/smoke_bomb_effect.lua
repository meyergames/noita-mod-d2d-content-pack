dofile_once( "data/scripts/lib/utilities.lua" )

local EFFECT_RADIUS = 25

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local player = get_player()
local x, y = EntityGetTransform( entity_id )

local mortals = EntityGetInRadiusWithTag( x, y, EFFECT_RADIUS, "mortal" )
for i,mortal in ipairs(mortals) do
	LoadGameEffectEntityTo( mortal, "data/entities/misc/effect_invisibility_short.xml" )
end

-- local matconv_id = EntityAddComponent2( entity_id, "MagicConvertMaterialComponent", 
-- {
-- 	from_material = CellFactory_GetType( "air" ),
-- 	to_material = CellFactory_GetType( "smoke_invisibility" ),
-- 	is_circle = true,
-- 	radius = EFFECT_RADIUS,
-- 	kill_when_finished = true,
-- } )