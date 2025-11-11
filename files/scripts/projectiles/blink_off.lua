dofile_once( "data/scripts/lib/utilities.lua" )

local x, y = EntityGetTransform( get_player() )
EntityLoad( "mods/D2DContentPack/files/particles/tele_particles.xml", x, y )
GamePlaySound( "data/audio/Desktop/player.bank", "player_projectiles/megalaser/launch", x, y )
