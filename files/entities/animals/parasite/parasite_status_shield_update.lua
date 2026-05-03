dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local shield_id = GetUpdatedEntityID()

local remaining_frames = get_internal_int( shield_id, "d2d_parasite_shield_remaining_frames" )
if remaining_frames and remaining_frames > -1 then
	if remaining_frames == 0 then
		local shield_comp = EntityGetFirstComponent( shield_id, "EnergyShieldComponent" )
		if exists( shield_comp ) then
			ComponentSetValue2( shield_comp, "energy", 0.0 )
		end
	else
		raise_internal_int( shield_id, "d2d_parasite_shield_remaining_frames", -1 )
	end
end
