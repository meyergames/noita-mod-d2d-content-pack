dofile_once( "data/scripts/lib/utilities.lua" )

local THRESHOLD = 70

local proj_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( proj_id )

local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
if proj_comp then
	local owner_id = ComponentGetValue2( proj_comp, "mWhoShot" )

	local dist = distance_between( owner_id, proj_id )
	-- if dist > THRESHOLD * 0.1 then
		-- local load_entity = ComponentObjectGetValue2( proj_id, "config_explosion", "load_this_entity" )
		-- if not load_entity then
			-- GamePrint( "TEST" )
			-- ComponentObjectSetValue2( proj_id, "config_explosion", "load_this_entity", "mods/D2DContentPack/files/entities/projectiles/deck/small_explosion.xml" )
			-- GamePrint( ComponentObjectGetValue2( proj_id, "config_explosion", "load_this_entity" ) )
		-- end
	-- end

	if owner_id and dist > THRESHOLD then
		EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/small_explosion.xml", x, y )
		EntityKill( proj_id )
	end
end
