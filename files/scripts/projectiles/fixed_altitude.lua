dofile_once( "data/scripts/lib/utilities.lua" )

local is_effect_enabled = false

function enabled_changed( entity_id, is_enabled )
	is_effect_enabled = is_enabled
	GamePrint( tostring(is_effect_enabled) )
end

function shot( projectile_id )
	if reflecting then return end

	GamePrint( tostring(is_effect_enabled) )
	if not is_effect_enabled then return end

	local entity_id = GetUpdatedEntityID()
	local owner = EntityGetRootEntity( entity_id )

	local vcomp = EntityGetFirstComponent( owner, "VelocityComponent" )
	local cdcomp = EntityGetFirstComponent( owner, "CharacterDataComponent" )
    if vcomp ~= nil then
		local v_vel_x, v_vel_y = ComponentGetValueVector2( vcomp, "mVelocity" )
		local d_vel_x, d_vel_y = ComponentGetValueVector2( cdcomp, "mVelocity" )

	    if ( v_vel_y > 0 ) then
			-- edit_component( player, "VelocityComponent", function(vcomp,vars)
			-- 	ComponentSetValueVector2( vcomp, "mVelocity", v_vel_x, ( v_vel_y * 0.25 ) - 6 ) end)
			
			-- edit_component( player, "CharacterDataComponent", function(ccomp,vars)
			-- 	ComponentSetValueVector2( cdcomp, "mVelocity", d_vel_x, ( d_vel_y * 0.25 ) - 12 ) end)
			edit_component( owner, "VelocityComponent", function(vcomp,vars)
				ComponentSetValueVector2( vcomp, "mVelocity", v_vel_x, -6 ) end)
			
			edit_component( owner, "CharacterDataComponent", function(ccomp,vars)
				ComponentSetValueVector2( cdcomp, "mVelocity", d_vel_x, -12 ) end)

			v_vel_x, v_vel_y = ComponentGetValueVector2( vcomp, "mVelocity" )
			d_vel_x, d_vel_y = ComponentGetValueVector2( cdcomp, "mVelocity" )
		end
    end
end