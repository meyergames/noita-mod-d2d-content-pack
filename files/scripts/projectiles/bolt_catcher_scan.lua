dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local x, y = EntityGetTransform( GetUpdatedEntityID() )

local p_dcomp = EntityGetFirstComponentIncludingDisabled( get_player(), "DamageModelComponent" )
local p_hp = ComponentGetValue2( p_dcomp, "hp" )
local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )

for i,proj_id in ipairs( EntityGetInRadiusWithTag( x, y, 20, "projectile" ) ) do
	local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
	local proj_source = ComponentGetValue2( proj_comp, "mWhoShot" )

	-- only heal the player if the projectile isn't theirs
	if proj_source ~= get_player() then

		-- determine heal ratio based on the projectile's velocity
		local proj_velocity = ComponentGetValue2( proj_comp, "speed_min" ) -- default value, just in case
	    local vcomp = EntityGetFirstComponentIncludingDisabled( proj_id, "VelocityComponent" )
	    if vcomp ~= nil then
	        local vx, vy = ComponentGetValue2( vcomp, "mVelocity" )
	        proj_velocity = get_magnitude( vx, vy )
	    end
		local heal_ratio = remap( proj_velocity, 100, 1000, 0.5, 1.0 )

		-- heal the player
		local proj_dmg = ComponentGetValue2( proj_comp, "damage" )
		local proj_x, proj_y = EntityGetTransform( proj_id )
	    ComponentSetValue( p_dcomp, "hp", math.min( p_hp + ( proj_dmg * heal_ratio ), p_max_hp ) )
	    GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/glowing_laser/destroy", proj_x, proj_y )
		EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/bolt_catcher_heal.xml", proj_x, proj_y )

		-- return the projectile to caster
		local sx, sy = EntityGetTransform( proj_source )
    	GameShootProjectile( get_player(), x, y, sx, sy, proj_id )
	end

    -- "disable" the projectile's explosion
	ComponentObjectSetValue2( proj_comp, "config_explosion", "explosion_radius", 0 )
    ComponentObjectSetValue2( proj_comp, "config_explosion", "create_cell_probability", 0 )
    ComponentObjectSetValue2( proj_comp, "config_explosion", "damage", 0 )
    ComponentObjectSetValue2( proj_comp, "config_explosion", "damage_mortals", 0 )

    -- if the player has Volatile Blue Magic, copy the first projectile
    if i == 1 then
	    local wand = EZWand.GetHeldWand()
	    if exists( wand ) then
		    for _,action in pairs( get_all_wand_actions( wand ) ) do
		        local action_id = action.action_id
		        if action_id == "D2D_BLUE_MAGIC" then
		            local projectile_file = EntityGetFilename( proj_id )
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

		                -- update the dynamic spell
		    			local item_comp = EntityGetFirstComponentIncludingDisabled( action.entity_id, "ItemComponent" )
		    			if not exists( item_comp ) then return end

				        ComponentSetValue2( item_comp, "item_name", string.format( "%s: %s", GameTextGetTranslatedOrNot("$spell_d2d_blue_magic_name_prefix"), projectile_file:lower():match("([%w_]-).xml"):gsub("_"," ") ) )
				        ComponentSetValue2( item_comp, "always_use_item_name_in_ui", true )
		            end
		        end
		    end
		end
	end

    -- return the projectile
	-- EntityKill( proj_id )
end
