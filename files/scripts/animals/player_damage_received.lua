dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
    if entity_thats_responsible == get_player() then return end
    
    local wand = EZWand.GetHeldWand()
    if not wand then return end

    local feedback_triggered = false
    for _,action in pairs( get_all_wand_actions( wand ) ) do
        local action_id = action.action_id
        if action_id == "D2D_BLUE_MAGIC" then
            local projectile_file = EntityGetFilename( projectile_thats_responsible )
            if projectile_file ~= "" then
            	-- if the projectile is a new one, play a sound
            	local old_file = get_internal_string( action.entity_id, "d2d_blue_magic_projectile_file" )
            	if not feedback_triggered and ( not exists( old_file ) or old_file ~= projectile_file ) then
            		local x, y = EntityGetTransform( get_player() )
            		GamePrint( "Blue Magic set to: " .. projectile_file:lower():match("([%w_]-).xml"):gsub("_"," ") )
					GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/charm/create", x, y )
					EntityLoad( "mods/D2DContentPack/files/particles/image_emitters/blue_magic.xml", x, y )
            		feedback_triggered = true
            	end

                set_internal_string( action.entity_id, "d2d_blue_magic_projectile_file", projectile_file )

                -- determine the attacker's cast delay
                -- if exists( entity_thats_responsible ) then
                -- 	local ai_comp = EntityGetFirstComponent( entity_thats_responsible, "AnimalAIComponent" )
                -- 	if exists( ai_comp ) then
                -- 		local cast_delay = ComponentGetValue2( ai_comp, "frames_between" )
                -- 		if exists( cast_delay ) then
                -- 			GamePrint( "cast delay set to " .. cast_delay )
                -- 			set_internal_int( action.entity_id, "d2d_blue_magic_cast_delay", cast_delay )
                -- 		end
                -- 	end
                -- end

                -- update the dynamic spell
    			local item_comp = EntityGetFirstComponentIncludingDisabled( action.entity_id, "ItemComponent" )
    			if not exists( item_comp ) then return end

		        ComponentSetValue2( item_comp, "item_name", string.format( "%s: %s", GameTextGetTranslatedOrNot("$spell_d2d_blue_magic_name_prefix"), projectile_file:lower():match("([%w_]-).xml"):gsub("_"," ") ) )
		        ComponentSetValue2( item_comp, "always_use_item_name_in_ui", true )
		        -- ComponentSetValue2( item_comp, "uses_remaining", 10 )
		        -- for _,sprite in pairs(EntityGetComponentIncludingDisabled( e, "SpriteComponent" ) or {}) do
		            -- if ComponentGetValue2( sprite, "image_file" ) == "mods/D2DContentPack/files/gkbrkn/actions/blue_magic/icon.png" then
		                -- ComponentSetValue2( sprite, "image_file", "mods/gkbrkn_noita/files/gkbrkn/actions/blue_magic/icon_locked.png" )
		            -- end
		        -- end
		        -- EntitySetVar( e, "gkbrkn_update_translation", 1 )
                -- dofile_once( "mods/D2DContentPack/files/scripts/projectiles/blue_magic_update_dynamic_spell.lua" )( action )
            end
        end
    end
end