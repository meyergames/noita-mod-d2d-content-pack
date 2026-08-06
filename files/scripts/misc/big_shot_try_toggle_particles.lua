dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local held_wand = EZWand.GetHeldWand()
if not exists( held_wand ) then return end
local spells_in_wand = get_all_wand_actions( held_wand )

local show_particles = false
for i,spell in ipairs( spells_in_wand ) do
	if spell.action_id == "D2D_BIG_SHOT" then
		local last_frame_used = get_internal_int( get_player(), "d2d_big_shot_last_frame_used" )
		if not exists( last_frame_used ) then last_frame_used = 0 end
		local frames_since_last_use = GameGetFrameNum() - last_frame_used
		if frames_since_last_use >= 1800 then
			show_particles = true
		end
	end
end

local particle_comp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "ParticleEmitterComponent" )
if exists( particle_comp ) then
	ComponentSetValue2( particle_comp, "is_emitting", show_particles )
end
