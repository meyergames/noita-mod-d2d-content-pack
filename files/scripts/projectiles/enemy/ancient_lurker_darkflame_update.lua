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
		if ai_comp then
			local target_id = ComponentGetValue2( ai_comp, "mGreatestPrey" )
			if target_id and distance_between( proj_source, target_id ) > 150 then
				local last_cast_frame = get_internal_int( proj_id, "d2d_ancient_lurker_darkflame_last_cast_frame" )
				if last_cast_frame then
					local frames_since_cast = GameGetFrameNum() - last_cast_frame
					if frames_since_cast > 60 then
						EntityKill( proj_id )
					end
				end
			end
		end
	end
end