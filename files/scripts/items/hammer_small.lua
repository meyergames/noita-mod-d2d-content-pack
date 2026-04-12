dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
dofile( "data/scripts/game_helpers.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	local x, y = EntityGetTransform( entity_item )

	-- spawn the spells
	spawn_random_upgrade_spells( 1, x, y )

	-- play vfx
	EntityLoad("mods/D2DContentPack/files/particles/image_emitters/hammer.xml", x, y-12)
	GameTriggerMusicCue( "item" )

	-- remove the item from the game
	EntityKill( entity_item )

	-- remove nearby temple heart + spell refresher
	for _,item_id in ipairs( EntityGetInRadiusWithTag( x, y, 32, "drillable" ) ) do
		EntityKill( item_id )
	end
end
