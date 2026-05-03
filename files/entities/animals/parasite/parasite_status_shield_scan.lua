dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local host_id = EntityGetParent( GetUpdatedEntityID() )
if not exists( host_id ) then return end
local x, y = EntityGetTransform( host_id )

EntityInflictDamage( host_id, 0.04, "NONE", "parasiitti", "NONE", 0, 0, host_id, x, y, 0 )
