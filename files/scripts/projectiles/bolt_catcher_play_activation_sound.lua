dofile_once( "data/scripts/lib/utilities.lua" )
local x, y = EntityGetTransform( GetUpdatedEntityID() )

GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/shield/activate", x, y )