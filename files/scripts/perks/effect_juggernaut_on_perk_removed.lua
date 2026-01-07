dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local perk_entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity( perk_entity_id )

local dmcomp = EntityGetFirstComponent( owner, "DamageModelComponent" )
if exists( dmcomp ) then
	ComponentObjectSetValue2( comp, "damage_multipliers", "healing", 1 )
end
