dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local proj_id = GetUpdatedEntityID()

local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
if proj_comp then
	ComponentSetValue2( proj_comp, "penetrate_entities", false )
end