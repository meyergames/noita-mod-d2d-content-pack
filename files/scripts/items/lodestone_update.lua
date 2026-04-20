dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

-- register the lodestone's position for Summon Lodestone Portal's destination
local lodestone_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( lodestone_id )
GlobalsSetValue( "D2D_LODESTONE_X", x )
GlobalsSetValue( "D2D_LODESTONE_Y", y )

local action_entity_id = find_action_entity_by_id( "D2D_LODESTONE_PORTAL" )
if exists( action_entity_id ) then

	-- check if Summon Lodestone Portal was cast...
	local portal_x = get_internal_int( action_entity_id, "d2d_last_lodestone_portal_x" )
	local portal_y = get_internal_int( action_entity_id, "d2d_last_lodestone_portal_y" )

	-- ...if it was...
	if exists( portal_x ) and exists( portal_y ) then
		local px, py = EntityGetTransform( get_player() )

		-- ...and the player is close to the lodestone (i.e. they teleported)...
		if get_distance( x, y, px, py ) < 100 then

			-- ...spawn a return portal!
			local return_portal = EntityLoad( "mods/D2DContentPack/files/entities/misc/portal_lodestone_return.xml", x, y - 80 )
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
			GamePrintImportant( "A return portal has opened", "It will close in 60 seconds" )
			GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/new_biome/create", x, y )
		end
	end
end

-- print the remaining duration to remind the player, if there is a return portal
local return_portal = EntityGetWithTag( "d2d_lodestone_return_portal" )[1]
if return_portal then
	local spawn_frame = get_internal_int( lodestone_id, "d2d_lodestone_return_portal_spawn_frame" )
	if exists( spawn_frame ) then
		local frames_elapsed = GameGetFrameNum() - spawn_frame
		if frames_elapsed >= 3000 then -- i.e. with 10 sec remaining
			if frames_elapsed == 3000 then
				GamePrintImportant( "The portal is about to close" )
				GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/heartbeat/create", x, y )
			end
			local seconds_left = math.floor( ( 3600 - frames_elapsed ) / 60 )
			GamePrint( seconds_left .. "..." )
		elseif frames_elapsed == 2700 then
			GamePrint( "15 seconds left" )
		elseif frames_elapsed == 1800 then
			GamePrint( "30 seconds left" )
		elseif frames_elapsed == 900 then
			GamePrint( "45 seconds left" )
		end
	end
end
