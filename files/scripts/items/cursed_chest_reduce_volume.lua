dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
if has_perk( "D2D_HUNT_CURSES" ) then
	local audiocomp = EntityGetFirstComponentIncludingDisabled( entity_id, "AudioLoopComponent" )
	if not audiocomp then
		audiocomp = EntityAddComponent2( entity_id, "AudioLoopComponent", {
			file = "data/audio/Desktop/projectiles.bank",
			event_name = "player_projectiles/epilogue/wall/movement_loop",
			auto_play_if_enabled = true,
		})
	end
	ComponentSetValue2( audiocomp, "m_volume", 0.3 )
end
