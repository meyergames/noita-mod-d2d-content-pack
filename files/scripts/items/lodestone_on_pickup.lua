dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local lodestone_id = GetUpdatedEntityID()

local action_entity_id = find_action_entity_by_id( "D2D_LODESTONE_PORTAL" )
if exists( action_entity_id ) then

	-- check if Summon Lodestone Portal was cast...
	local portal_x = get_internal_int( action_entity_id, "d2d_last_lodestone_portal_x" )
	local portal_y = get_internal_int( action_entity_id, "d2d_last_lodestone_portal_y" )

	-- ...if it was...
	if exists( portal_x ) and exists( portal_y ) then
		local px, py = EntityGetTransform( get_player() )

		-- ...teleport the player back, along with the stone
		GamePrintImportant( "You will be teleported back in 60 seconds" )

		local return_portal = EntityLoad( "mods/D2DContentPack/files/entities/misc/portal_lodestone_return.xml", px, py )
		local telecomp = EntityGetFirstComponentIncludingDisabled( return_portal, "TeleportComponent" )
		if exists( telecomp ) then
			ComponentSetValue2( telecomp, "target", portal_x, portal_y )

			-- reset the vars, so that this doesn't trigger again
			set_internal_int( action_entity_id, "d2d_last_lodestone_portal_x", 0 )
			set_internal_int( action_entity_id, "d2d_last_lodestone_portal_y", 0 )
		end

		-- remember the frame on which the portal was spawned, so that the remaining duration can be printed
		set_internal_int( lodestone_id, "d2d_lodestone_return_portal_spawn_frame", GameGetFrameNum() )

		-- make it known to the player
		GamePrintImportant( "The return portal closes in 60 seconds" )
		GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/new_biome/create", x, y )
	end
end
