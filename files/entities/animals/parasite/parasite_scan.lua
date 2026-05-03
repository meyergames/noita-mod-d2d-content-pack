dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local parasite_id = GetUpdatedEntityID()

-- if the parasite is invisible but has no valid host, make it visible again
local host_id = get_internal_bool( parasite_id, "d2d_parasite_host_id" )
if exists( host_id ) and not EntityGetIsAlive( host_id ) then
	set_internal_int( parasite_id, "d2d_parasite_host_id", 0 )

	-- re-enable the parasite's sprite and hitbox to make it visible
	local sprite_comps = EntityGetComponentIncludingDisabled( parasite_id, "SpriteComponent" )
	if exists( sprite_comps ) then
		for i,sprite_comp in ipairs( sprite_comps ) do
			EntitySetComponentIsEnabled( parasite_id, sprite_comp, true )
		end
	end
	local hitbox_comp = EntityGetFirstComponentIncludingDisabled( parasite_id, "HitboxComponent" )
	if exists( hitbox_comp ) then
		EntitySetComponentIsEnabled( parasite_id, hitbox_comp, true )
	end
	local ai_comp = EntityGetFirstComponentIncludingDisabled( parasite_id, "AnimalAIComponent" )
	if exists( ai_comp ) then
		EntitySetComponentIsEnabled( parasite_id, ai_comp, true )
	end
	
	-- reset the parasite's herd
	local gd_comp = EntityGetFirstComponentIncludingDisabled( parasite_id, "GenomeDataComponent" )
	if exists( gd_comp ) then
		local herd_id = ComponentGetValue2( gd_comp, "herd_id" )
		if exists( herd_id ) then
			ComponentSetValue( gd_comp, "herd_id", "boss_limbs" )
		end
	end
end
