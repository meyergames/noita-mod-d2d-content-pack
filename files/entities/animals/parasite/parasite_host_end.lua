dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local host_id = GetUpdatedEntityID()
if not exists( host_id ) then return end
local x, y = EntityGetTransform( host_id )

local parasite_max_hp = get_internal_int( host_id, "d2d_parasite_max_hp" )
if exists( parasite_max_hp ) then
	if parasite_max_hp >= 4 then
		EntityLoad( "mods/D2DContentPack/files/entities/animals/parasite/parasite_entity_t3.xml", x, y )
	elseif parasite_max_hp >= 2 then
		EntityLoad( "mods/D2DContentPack/files/entities/animals/parasite/parasite_entity_t2.xml", x, y )
	else
		EntityLoad( "mods/D2DContentPack/files/entities/animals/parasite/parasite_entity_t1.xml", x, y )
	end
else
	EntityLoad( "mods/D2DContentPack/files/entities/animals/parasite/parasite_entity_t1.xml", x, y )
end
