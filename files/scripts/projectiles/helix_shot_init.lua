dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

-- first, make the projectile more consistent
local proj_id = EntityGetParent( GetUpdatedEntityID() )
if exists( proj_id ) then
	local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
	if exists( proj_comp ) then
		local speed_max = ComponentGetValue2( proj_comp, "speed_max" )
		ComponentSetValue2( proj_comp, "speed_min", speed_max )

		local lob_min = ComponentGetValue2( proj_comp, "lob_min" )
		ComponentSetValue2( proj_comp, "lob_max", lob_min )

		ComponentSetValue2( proj_comp, "lifetime_randomness", 0 )
	end
end

-- inverse the sinewave of every second helix projectile
local count = tonumber( GlobalsGetValue( "d2d_helix_shot_count", "0" ) )
GlobalsSetValue( "d2d_helix_shot_count", tostring( count + 1 ) )
if count % 2 == 1 then
	local sinecomp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "SineWaveComponent" )
	local m = ComponentGetValue2( sinecomp, "sinewave_m" )
	ComponentSetValue2( sinecomp, "sinewave_m", m * -1 )
end