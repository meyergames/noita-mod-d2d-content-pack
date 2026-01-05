dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

for _,wand_id in pairs( EntityGetWithTag( "wand" ) ) do
	local already_spawned_aura = get_internal_bool( wand_id, "d2d_twwm_wand_aura_spawned" )
	if not already_spawned_aura then
		local itemcomp = EntityGetFirstComponent( wand_id, "ItemComponent" )
		if exists( itemcomp ) then
			if not ComponentGetValue2( itemcomp, "has_been_picked_by_player" ) then
				local wx, wy = EntityGetTransform( wand_id )
				if not string.find( BiomeMapGetName( wx, wy ), "holy" ) then
					EntityLoad( "mods/D2DContentPack/files/entities/misc/wand_tinkering_aura.xml", wx, wy )	
					set_internal_bool( wand_id, "d2d_twwm_wand_aura_spawned", true )
				end
			end
		end
	end
end
