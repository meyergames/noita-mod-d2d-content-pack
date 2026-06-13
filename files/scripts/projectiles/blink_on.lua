dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local control = EntityGetFirstComponent( get_player(),"ControlsComponent" )
if not control then return end

local x, y = EntityGetTransform( get_player() )
EntityLoad( "mods/D2DContentPack/files/particles/tele_particles.xml", x, y )
-- set_internal_int( get_player(), "d2d_blink_origin_x", x )
-- set_internal_int( get_player(), "d2d_blink_origin_y", y )

local tx, ty = ComponentGetValue2( control, "mMousePosition" )
EntityApplyTransform( GetUpdatedEntityID(), tx, ty )

-- local portal_back = EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/blink_portal_back.xml", tx, ty )
-- local telecomp = EntityGetFirstComponentIncludingDisabled( portal_back, "TeleportComponent" )
-- ComponentSetValue2( telecomp, "target", x, y )

EntityKill( GetUpdatedEntityID() )
