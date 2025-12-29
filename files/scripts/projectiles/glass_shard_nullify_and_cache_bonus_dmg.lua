dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local proj_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( proj_id )

local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
if exists( proj_comp ) then
	local proj_dmg = ComponentGetValue2( proj_comp, "damage" )
	if exists( proj_dmg ) then
		ComponentSetValue2( proj_comp, "damage", 0 ) -- original dmg is 0.04 *slice*
		raise_internal_float( proj_id, "d2d_glass_shard_bonus_dmg", proj_dmg )
	end
end