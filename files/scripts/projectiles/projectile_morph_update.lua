dofile_once( "data/scripts/lib/utilities.lua" )

local proj_id = GetUpdatedEntityID()

local continue = EntityHasTag( proj_id, "d2d_projectile_morph_parent" )
if not continue then return end

local px, py = EntityGetTransform( proj_id )
local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
if proj_comp then
	local proj_source = ComponentGetValue2( proj_comp, "mWhoShot" )
	if proj_source then
		local old_x, old_y = EntityGetTransform( proj_source )
		local new_x = get_internal_int( proj_source, "d2d_player_follow_projectile_previous_x" )
		local new_y = get_internal_int( proj_source, "d2d_player_follow_projectile_previous_y" )
		if new_x and get_distance( old_x, old_y, new_x, new_y ) < 100 then
			EntitySetTransform( proj_source, new_x, new_y )
		end

		-- reset the shooter's vertical velocity
		local vcomp = EntityGetFirstComponent( proj_source, "VelocityComponent" )
		local cdcomp = EntityGetFirstComponent( proj_source, "CharacterDataComponent" )
		if vcomp ~= nil then
			local v_vel_x, v_vel_y = ComponentGetValueVector2( vcomp, "mVelocity" )
			local d_vel_x, d_vel_y = ComponentGetValueVector2( cdcomp, "mVelocity" )

		    if ( v_vel_y > 0 ) then
				edit_component( proj_source, "VelocityComponent", function(vcomp,vars)
					ComponentSetValueVector2( vcomp, "mVelocity", v_vel_x, -6 ) end)
				
				edit_component( proj_source, "CharacterDataComponent", function(ccomp,vars)
					ComponentSetValueVector2( cdcomp, "mVelocity", d_vel_x, -12 ) end)

				v_vel_x, v_vel_y = ComponentGetValueVector2( vcomp, "mVelocity" )
				d_vel_x, d_vel_y = ComponentGetValueVector2( cdcomp, "mVelocity" )
			end
		end

		set_internal_int( proj_source, "d2d_player_follow_projectile_previous_x", px )
		set_internal_int( proj_source, "d2d_player_follow_projectile_previous_y", py )
	end
end