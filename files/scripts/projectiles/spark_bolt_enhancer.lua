dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local proj_id = EntityGetRootEntity( entity_id )
if exists( proj_id ) then

	local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
	if exists( proj_comp ) then

		local action_name = GameTextGetTranslatedOrNot( ComponentObjectGetValue2( proj_comp, "config", "action_name" ) )
		if exists( action_name ) and string.find( string.lower( action_name ), "spark bolt" ) then

			-- double dmg
			multiply_proj_dmg( proj_id, 2.0 )
			-- multiply_proj_speed( proj_id, 2.0 )

			-- add knockback
			ComponentSetValue2( proj_comp, "knockback_force", 5 )
			ComponentSetValue2( proj_comp, "muzzle_flash_file", "mods/D2DContentPack/files/particles/muzzle_flashes/muzzle_flash_laser_death_ray.xml" )

			-- make the bolts more destructive
			local prev_mdtd = ComponentObjectGetValue2( proj_comp, "config_explosion", "max_durability_to_destroy" )
			local prev_raynrg = ComponentObjectGetValue2( proj_comp, "config_explosion", "ray_energy" )
			ComponentObjectSetValue2( proj_comp, "config_explosion", "max_durability_to_destroy", prev_mdtd + 2 )
			ComponentObjectSetValue2( proj_comp, "config_explosion", "ray_energy", prev_raynrg * 2 )

			-- play a sound
			GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/laser_wraith/create", x, y )

			-- cool muzzle
			-- dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
			-- local proj_source = ComponentGetValue2( proj_comp, "mWhoShot" )
			-- EntityLoadAtWandTip( proj_source, "mods/D2DContentPack/files/particles/muzzle_flashes/muzzle_flash_laser_death_ray.xml" )
		end
	end
end