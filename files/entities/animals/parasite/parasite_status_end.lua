dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local parasite_id = GetUpdatedEntityID()

-- re-enable the parasite's sprite and hitbox to make it visible
local sprite_comps = EntityGetComponent( parasite_id, "SpriteComponent" )
if exists( sprite_comps ) then
	for i,sprite_comp in ipairs( sprite_comp ) do
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

-- deregister its host, so it can move naturally again
set_internal_int( parasite_id, "d2d_parasite_host_id", 0 )
