dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local held_wand = EZWand.GetHeldWand()
if not exists( held_wand ) then return end
local spells_in_wand = get_all_wand_actions( held_wand )

local show_particles = false
for i,spell in ipairs( spells_in_wand ) do
	if spell.action_id == "D2D_DAMAGE_DOUBLE" then
		local item_comp = EntityGetFirstComponentIncludingDisabled( spell.entity_id, "ItemComponent" )
		if exists( item_comp ) then
	        local uses_remaining = ComponentGetValue2( item_comp, "uses_remaining" )
			if uses_remaining > 0 then
				show_particles = true
			end
		end
	end
end

local particle_comp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "ParticleEmitterComponent" )
if exists( particle_comp ) then
	ComponentSetValue2( particle_comp, "is_emitting", show_particles )
end
