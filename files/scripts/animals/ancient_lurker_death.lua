dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )

local x, y = EntityGetTransform( GetUpdatedEntityID() )
spawn_ancient_staff( x, y )

if not HasFlagPersistent( "d2d_ancient_lurker_defeated" ) then
	AddFlagPersistent( "d2d_ancient_lurker_defeated" )
	EntityLoad( "data/entities/items/pickup/heart_fullhp.xml", x, y )
end
