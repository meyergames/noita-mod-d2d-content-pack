dofile_once( "data/scripts/lib/utilities.lua" )

local control = EntityGetFirstComponent( get_player(),"ControlsComponent" )
if not control then return end

local x, y = EntityGetTransform( get_player() )
EntityLoad( "mods/D2DContentPack/files/particles/tele_particles.xml", x, y )
EntityApplyTransform( GetUpdatedEntityID(), ComponentGetValue2( control, "mMousePosition" ) )

EntityKill( GetUpdatedEntityID() )
