dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
local x, y = EntityGetTransform( get_player() )
EntityLoad( "data/entities/items/wands/wand_good/wand_good_2.xml", x, y )
