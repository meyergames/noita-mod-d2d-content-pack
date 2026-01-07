dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local audiocomp = EntityGetFirstComponent( entity_id, "AudioLoopComponent" )
if audiocomp then
	if has_perk( "D2D_HUNT_CURSES" ) then
		ComponentSetValue2( audiocomp, "m_volume", 0.3 )
	else
		ComponentSetValue2( audiocomp, "m_volume", 0 )
	end
end