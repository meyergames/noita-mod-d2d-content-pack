dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local nearby_mortals = EntityGetInRadiusWithTag( x, y, 30, "mortal" )
for i,mortal in ipairs( nearby_mortals ) do
	EntityInflictDamage( mortal, -0.12, "DAMAGE_HEALING", "nutrition", "NONE", 0, 0, mortal, x, y, 0 )
	GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y )
end