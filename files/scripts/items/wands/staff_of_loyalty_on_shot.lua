dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function shot( projectile_entity_id )
	local player = GetUpdatedEntityID()
	local held_wand = EZWand.GetHeldWand()
	if exists( held_wand ) and EntityHasTag( held_wand.entity_id, "d2d_staff_of_loyalty" ) then

		local proj_comp = EntityGetFirstComponent( projectile_entity_id, "ProjectileComponent" )
		if exists( proj_comp ) then

			local spell_name = GameTextGetTranslatedOrNot( ComponentObjectGetValue2( proj_comp, "config", "action_name" ) )
			if string.find( string.lower( spell_name ), "spark bolt" ) then

				multiply_proj_dmg( projectile_entity_id, 2.0 )
				multiply_proj_speed( projectile_entity_id, 2.0 )
				
				local x, y = EntityGetTransform( player )
				GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/laser_wraith/create", x, y )
				GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/laser_wraith/create", x, y )

				-- cool muzzle
				EntityLoadAtWandTip( player, held_wand.entity_id )

				-- show a message once
				if not GameHasFlagRun( "d2d_staff_of_loyalty_spark_bolt_fired" ) then
					GamePrint( "The staff seems to respond to the spark bolt..." )
					GameAddFlagRun( "d2d_staff_of_loyalty_spark_bolt_fired" )
				end
			end
		end
	end
end