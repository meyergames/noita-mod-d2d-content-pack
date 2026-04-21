dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local shield_comp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "EnergyShieldComponent" )
if exists( shield_comp ) then
	if ComponentGetValue2( shield_comp, "energy" ) <= 0.1 then
		EntityKill( GetUpdatedEntityID() )
	end
end