dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )

if not HasFlagPersistent( "d2d_ancient_lurker_defeated" ) then
	AddFlagPersistent( "d2d_ancient_lurker_defeated" )
end

local x, y = EntityGetTransform( GetUpdatedEntityID() )
spawn_ancient_staff( x, y )