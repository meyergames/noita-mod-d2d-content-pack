dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local dmgcomp = EntityGetFirstComponent( get_player(), "DamageModelComponent" )
if exists( dmgcomp ) then
	local hp = ComponentGetValue2( dmgcomp, "hp" )
	local max_hp = ComponentGetValue2( dmgcomp, "max_hp" )

	local x, y = EntityGetTransform( get_player() )
	EntityInflictDamage( get_player(), max_hp * 100, "DAMAGE_SLICE", "claimed by the afterlife", "BLOOD_EXPLOSION", 0, 0, GetUpdatedEntityID(), x, y, 0 )
end

-- kill the player again if they haven't died yet
if EntityGetIsAlive( get_player() ) then
	EntityKill( get_player() )
end
