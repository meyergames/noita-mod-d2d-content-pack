dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	if GameHasFlagRun( "d2d_afterlife_triggered" ) then return end

	local player_id = GetUpdatedEntityID()

    for _,dcomp in ipairs( EntityGetComponent( player_id, "DamageModelComponent" ) or {} ) do
		local hp = ComponentGetValue2( dcomp, "hp" )
		local max_hp = ComponentGetValue2( dcomp, "max_hp" )

		if damage >= hp then
			local x, y = EntityGetTransform( player_id )
			set_internal_float( player_id, "d2d_afterlife_grave_x", x )
			set_internal_float( player_id, "d2d_afterlife_grave_y", y )

			-- drop all the player's items and teleport them to the mountain top
			GameDropAllItems( player_id )
			EntityLoad( "mods/D2DContentPack/files/entities/misc/portal_afterlife.xml", x, y )
			EntityLoad( "mods/D2DContentPack/files/entities/misc/afterlife_grave.xml", x, y )

			-- give them an effect
			local dist = get_distance( x, y, 230, -69 )
			local pw_x, pw_y = GetParallelWorldPosition( x, y )
			local path = "mods/D2DContentPack/files/entities/misc/status_effects/effect_afterlife_15m.xml"
			-- if ( pw_x ~= 0 or pw_y ~= 0 ) then
			-- 	path = "mods/D2DContentPack/files/entities/misc/status_effects/effect_afterlife_10m.xml"
			-- elseif dist < 3140 then
			-- 	if dist > 1593 then
			-- 		path = "mods/D2DContentPack/files/entities/misc/status_effects/effect_afterlife_2m.xml"
			-- 	end
			-- elseif dist < 5119 + 69 then
			-- 	path = "mods/D2DContentPack/files/entities/misc/status_effects/effect_afterlife_3m.xml"
			-- elseif dist < 6644 + 69 then
			-- 	path = "mods/D2DContentPack/files/entities/misc/status_effects/effect_afterlife_4m.xml"
			-- elseif dist < 8703 + 69 then
			-- 	path = "mods/D2DContentPack/files/entities/misc/status_effects/effect_afterlife_5m.xml"
			-- elseif dist < 10740 + 69 then
			-- 	path = "mods/D2DContentPack/files/entities/misc/status_effects/effect_afterlife_6m.xml"
			-- elseif dist >= 10740 + 69 then
			-- 	path = "mods/D2DContentPack/files/entities/misc/status_effects/effect_afterlife_7m.xml"
			-- end
			local effect_id = LoadGameEffectEntityTo( player_id, path )
			local uicomp = EntityGetFirstComponent( effect_id, "UIIconComponent" )
			if uicomp then
				-- this somehow doesn't work when set in the XML
				ComponentSetValue2( uicomp, "is_perk", false )
				ComponentSetValue2( uicomp, "display_above_head", false )
			end

			-- respawn the player at the mountain entrance with max. 1000 hp
			-- ComponentSetValue2( dcomp, "max_hp", 4 )
			-- ComponentSetValue2( dcomp, "hp", damage + math.max( max_hp * 0.25, 4 ) )
			if max_hp > 40 then
				set_internal_bool( player_id, "d2d_max_hp_was_over_1000", true )
			end
			local new_max_hp = math.min( max_hp, 40 )
			ComponentSetValue2( dcomp, "max_hp", new_max_hp )
			ComponentSetValue2( dcomp, "hp", damage + new_max_hp )

			-- set the max health cap to 1000, if the player doesn't already have the Glass Cannon health cap
			if not has_perk( "GLASS_CANNON" ) then
				-- ComponentSetValue2( dcomp, "max_hp_cap", 40 )
				GameAddFlagRun( "d2d_1000_max_health_cap" )
			end

			GamePrintImportant( "You've entered the Afterlife", "Make it back to your grave to reclaim your life" )
			try_make_player_spooky( player_id )

			-- delete this effect so it doesn't trigger again
			GameAddFlagRun( "d2d_afterlife_triggered" )
			EntityRemoveComponent( player_id, GetUpdatedComponentID() )

			-- replace the perk icon with its spent variant
			swap_perk_icon_for_spent( player_id, "d2d_afterlife" )
		end
	end
end