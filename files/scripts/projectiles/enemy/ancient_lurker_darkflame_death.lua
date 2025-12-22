dofile_once( "data/scripts/lib/utilities.lua" )

local proj_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( proj_id )

local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
if proj_comp then
	local lurker = EntityGetWithName( "Vanhakupla" )
	if lurker then

		-- spawn AoE flames
		-- local flame_amt = 6
		-- for i = 1, flame_amt do
		--     local rdir_x, rdir_y = vec_rotate( 0, 1, Random( -22.5, 22.5 ) )
		-- 	GameShootProjectile( lurker, x, y, x+rdir_x, y+rdir_y, EntityLoad( "mods/D2DContentPack/files/entities/projectiles/enemy/ancient_lurker_darkflame_lesser.xml", x, y ) )
		-- end
		local flame_amt = 6
		if get_internal_int( lurker, "d2d_ancient_lurker_phase" ) == 2 then flame_amt = 12 end
		for i = 1, flame_amt do
		    local rdir_x, rdir_y = vec_rotate( 0, 1, math.rad( ( 360 / flame_amt ) * i ) )
			GameShootProjectile( lurker, x, y, x+rdir_x, y+rdir_y, EntityLoad( "mods/D2DContentPack/files/entities/projectiles/enemy/ancient_lurker_darkflame_lesser.xml", x, y ) )
		end

		-- reset damage multipliers
		local dmg_comp = EntityGetFirstComponent( lurker, "DamageModelComponent" )
		if dmg_comp then
			local mtp_proj = 0.1
			local mtp_holy = 1.0
			local phase = get_internal_int( lurker, "d2d_ancient_lurker_phase" )
			if not phase or phase < 2 then
				mtp_proj = 0.25
				mtp_holy = 2.0
			end
			ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "projectile", mtp_proj )
        	ComponentObjectSetValue2( dmg_comp, "damage_multipliers", "holy", mtp_holy )

			local children = EntityGetAllChildren( lurker )
			if children then
				for i,child in ipairs( children ) do
					if EntityHasTag( child, "d2d_ancient_lurker_shield") then
						local ptc_comps = EntityGetComponentIncludingDisabled( child, "ParticleEmitterComponent" )
						if ptc_comps and #ptc_comps > 0 then
							for i,ptc_comp in ipairs( ptc_comps ) do
							ComponentSetValue2( ptc_comp, "custom_alpha", 0.3 )
							end
						end
					end
				end
			end
		end
	end
end