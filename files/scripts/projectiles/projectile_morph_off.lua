dofile_once( "data/scripts/lib/utilities.lua" )

local proj_id = GetUpdatedEntityID()

local continue = EntityHasTag( proj_id, "d2d_projectile_morph_parent" )
if not continue then return end

local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
if proj_comp then
	local proj_source = ComponentGetValue2( proj_comp, "mWhoShot" )
	if proj_source then

		-- re-enable player input
		-- set_controls_enabled( true )
		-- local ctrl_comp = EntityGetFirstComponentIncludingDisabled( proj_source, "ControlsComponent" )
		-- if ctrl_comp then
		-- 	ComponentSetValue2( ctrl_comp, "enabled", true )
		-- end

		-- show the player and any extra hats/necklaces/etc
		local sprite_comps = EntityGetComponent( proj_source, "SpriteComponent" )
		if sprite_comps and #sprite_comps > 0 then
			for i,sprite_comp in ipairs( sprite_comps ) do
				local image_file = ComponentGetValue2( sprite_comp, "image_file" )

				-- ignore the controller cursor sprite
				if not string.find( image_file, "data/ui_gfx/mouse_cursor.png" ) then
					ComponentSetValue2( sprite_comp, "visible", true )
				end
			end
		end

		
		local children = EntityGetAllChildren( proj_source )
		for k=1,#children do
			child = children[k]

			-- show the arm
		    if EntityGetName( child ) == "arm_r" then
				for i,child_sprite_comp in ipairs( EntityGetComponent( child, "SpriteComponent" ) ) do
					ComponentSetValue2( child_sprite_comp, "visible", true )
				end
		    end

			-- show the cape
		    if EntityGetName( child ) == "cape" then
				for i,child_vp_comp in ipairs( EntityGetComponent( child, "VerletPhysicsComponent" ) ) do
					ComponentSetValue2( child_vp_comp, "follow_entity_transform", true )
				end
		    end

			-- show all wands
		    if EntityGetName( child ) == "inventory_quick" then
		        local inventory_items = EntityGetAllChildren( child )
		        if( inventory_items ~= nil ) then
		            for z=1, #inventory_items do
		            	item = inventory_items[z]

		            	if item then
		            		local sprite_comps = EntityGetComponent( item, "SpriteComponent" )
		            		if sprite_comps and #sprite_comps > 0 then
				            	for i,item_sprite_comp in ipairs( sprite_comps ) do
									ComponentSetValue2( item_sprite_comp, "visible", true )
				            	end
				            end
			            end
		            end
		        end
		    end
		end
	end
end