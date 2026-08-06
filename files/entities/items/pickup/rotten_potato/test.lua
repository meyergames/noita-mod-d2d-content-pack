dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local last_frame_used = get_internal_int( get_player(), "d2d_rotten_potato_last_frame_used" )
if not exists( last_frame_used ) then last_frame_used = 0 end
if GameGetFrameNum() - last_frame_used < 60 then return end
set_internal_int( get_player(), "d2d_rotten_potato_last_frame_used", GameGetFrameNum() )

---- TEST LOGIC GOES BELOW THIS POINT ----



local x, y = EntityGetTransform( get_player() )
EntitySetTransform( get_player(), 250, -26130 )
-- spawn_perk( "D2D_PROMOTE_RANDOM_SPELL", x, y )
-- EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/chest_random_cursed_d2d.xml", x, y - 50 )
-- local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
-- local staff = init_staff_of_finality( x, y )
-- staff:PlaceAt( x, y )
-- spawn_lunar_staff( x, y )

