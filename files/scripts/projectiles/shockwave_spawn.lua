dofile_once( "data/scripts/lib/utilities.lua" )

local proj_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( proj_id )

local shockwave = EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/shockwave.xml", x, y )
local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
if proj_comp then
	local who_shot = ComponentGetValue2( proj_comp, "mWhoShot" )
	if who_shot then
		local shockwave_proj_comp = EntityGetFirstComponent( shockwave, "ProjectileComponent" )
		if shockwave_proj_comp then
			ComponentSetValue2( shockwave_proj_comp, "mWhoShot", who_shot )
		end
	end
end
