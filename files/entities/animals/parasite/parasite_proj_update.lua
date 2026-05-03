dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local proj_id = GetUpdatedEntityID()
if not exists( proj_id ) then return end
local proj_x, proj_y = EntityGetTransform( proj_id )

local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
if exists( proj_comp ) then
	local mWhoShot = ComponentGetValue2( proj_comp, "mWhoShot" )
	if exists( mWhoShot ) then
		EntitySetTransform( mWhoShot, proj_x, proj_y )
	end
end
