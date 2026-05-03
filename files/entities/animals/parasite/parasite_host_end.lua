dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local host_id = GetUpdatedEntityID()
if not exists( host_id ) then return end
local x, y = EntityGetTransform( host_id )

GamePrint( "DEATH!" )
EntityLoad( "mods/D2DContentPack/files/entities/animals/parasite/parasite.xml", x, y )
