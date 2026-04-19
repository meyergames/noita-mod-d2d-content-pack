dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local x, y = EntityGetTransform( GetUpdatedEntityID() )
GlobalsSetValue( "D2D_LODESTONE_X", x )
GlobalsSetValue( "D2D_LODESTONE_Y", y )
