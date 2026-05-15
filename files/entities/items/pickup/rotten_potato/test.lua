dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
local x, y = EntityGetTransform( get_player() )
spawn_perk( "D2D_PROMOTE_RANDOM_SPELL", x, y )
-- EntityLoad( "data/entities/items/wands/wand_good/wand_good_2.xml", x, y )
