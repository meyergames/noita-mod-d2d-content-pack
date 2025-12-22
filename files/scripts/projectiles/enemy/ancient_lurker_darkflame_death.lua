dofile_once( "data/scripts/lib/utilities.lua" )

local proj_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( proj_id )

local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
if proj_comp then
	local lurker = EntityGetWithName( "$animal_d2d_ancient_lurker" )
	if lurker then

		local phase = get_internal_int( lurker, "d2d_ancient_lurker_phase" )

		local flame_amt = 6
		if phase and phase >= 2 then
			flame_amt = 8
			
			local shockwave_id = EntityLoad( "mods/D2DContentPack/files/entities/projectiles/enemy/ancient_lurker_shockwave.xml", x, y )
			GameShootProjectile( lurker, x, y, x, y + 1, shockwave_id )
		end
		for i = 1, flame_amt do
		    local rdir_x, rdir_y = vec_rotate( 0, 1, math.rad( ( 360 / flame_amt ) * i ) )
			GameShootProjectile( lurker, x, y, x+rdir_x, y+rdir_y, EntityLoad( "mods/D2DContentPack/files/entities/projectiles/enemy/ancient_lurker_darkflame_lesser.xml", x, y ) )
		end

		
		-- toggle shield
		local dmg_comp = EntityGetFirstComponent( lurker, "DamageModelComponent" )
		if dmg_comp then

			local phase = get_internal_int( lurker, "d2d_ancient_lurker_phase" )
			local enable_shield = false
			if phase and phase == 2 then
				enable_shield = true
			elseif phase and phase == 3 then
				enable_shield = false
			end

			local children = EntityGetAllChildren( lurker )
			if children then
				for i,child in ipairs( children ) do
					if EntityHasTag( child, "d2d_ancient_lurker_shield" ) then
						local ptc_comps = EntityGetComponentIncludingDisabled( child, "ParticleEmitterComponent" )
						if ptc_comps and #ptc_comps > 0 then
							for i,ptc_comp in ipairs( ptc_comps ) do
								local alpha = 0
								if enable_shield then alpha = 1.0 end

								ComponentSetValue2( ptc_comp, "custom_alpha", alpha )
							end
						end
					end
				end
			end

			set_internal_bool( lurker, "d2d_ancient_lurker_shield_is_active", enable_shield )
		end
	end
end