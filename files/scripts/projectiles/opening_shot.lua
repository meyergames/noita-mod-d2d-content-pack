dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

GamePrint("opening shot! 1")
local x, y = EntityGetTransform( GetUpdatedEntityID() )
local entity_id = EntityGetInRadiusWithTag( x, y, 5, "homing_target" )[1]
-- local owner = EntityGetParent( entity_id )

local dmg_comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
if dmg_comp then
	GamePrint("opening shot! 2")
	local hp = ComponentGetValue2( dmg_comp, "hp" )
	local max_hp = ComponentGetValue2( dmg_comp, "max_hp" )

	if hp > max_hp - 0.04 then
		GamePrint("opening shot! 3")
		EntityInflictDamage( entity_id, 0.8, "DAMAGE_PROJECTILE", "opening shot", "NORMAL", 0, 0, entity_id, x, y, 0 )
	end
end