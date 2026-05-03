dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local host_id = EntityGetRootEntity( GetUpdatedEntityID() )
dofile_once( "mods/D2DContentPack/files/entities/animals/parasite/parasite_utils.lua" )
try_infect( host_id )
