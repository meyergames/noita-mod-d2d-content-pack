dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "mods/D2DContentPack/files/scripts/projectiles/beacon_utils.lua" )

function collision_trigger( colliding_entity_id )
	local x, y = EntityGetTransform( GetUpdatedEntityID() )

	GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/frozen/damage", x, y )
	beacon_deregister_global( x, y )
end