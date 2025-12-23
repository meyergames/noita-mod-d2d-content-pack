dofile_once( "data/scripts/lib/utilities.lua" )

local proj_id = GetUpdatedEntityID()

local px, py = EntityGetTransform( proj_id )
local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
if proj_comp then
	local proj_source = ComponentGetValue2( proj_comp, "mWhoShot" )
	if proj_source then
		-- local old_x, old_y = EntityGetTransform( proj_source )
		-- if new_x and get_distance( old_x, old_y, new_x, new_y ) < 100 then
			EntitySetTransform( proj_source, px, py )
		-- end

		-- destroy this projectile if the player is too far away
		local ai_comp = EntityGetFirstComponent( proj_source, "AnimalAIComponent" )
		local vel_comp = EntityGetFirstComponent( proj_id, "VelocityComponent" )
		if ai_comp and vel_comp then
			local target_id = ComponentGetValue2( ai_comp, "mGreatestPrey" )
			local magnitude = get_magnitude( ComponentGetValue2( vel_comp, "mVelocity" ) )

			local passed_player = get_internal_bool( proj_source, "d2d_ancient_lurker_passed_player" )
			-- check if the projectile at any point is near the player
			if not passed_player and distance_between( proj_id, get_player() ) < 100 then
				set_internal_bool( proj_source, "d2d_ancient_lurker_passed_player", true )
			end

			-- end the projectile early if it flies past the player at reasonable speed
			if target_id and distance_between( proj_id, get_player() ) > 100 and passed_player and magnitude < 400 then
				EntityKill( proj_id )
			end
		end
	end
end