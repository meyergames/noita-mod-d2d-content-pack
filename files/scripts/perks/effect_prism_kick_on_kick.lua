dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function is_facing_prop( player )
	local x, y = EntityGetTransform( player )
	local props = EntityGetInRadiusWithTag( x, y, 13, "prop" )
	return exists( props ) and #props > 0
end

function kick( entity_who_kicked )
	if is_facing_prop( entity_who_kicked ) then return end

	local pickup_count = get_perk_pickup_count( "D2D_PRISM_KICK" )

	local children = EntityGetAllChildren( entity_who_kicked )
	for k=1,#children do
		child = children[k]
	    if EntityGetName( child ) == "inventory_full" then
	        local inventory_items = EntityGetAllChildren(child)
	        if( inventory_items ~= nil ) then
            	local item = inventory_items[#inventory_items]

        		local item_comp = EntityGetFirstComponentIncludingDisabled( item, "ItemComponent" )
        		local inv_slot_x, inv_slot_y = ComponentGetValue2( item_comp, "inventory_slot" )
            	if inv_slot_x ~= 15 then return end

            	local ia_comp = EntityGetFirstComponentIncludingDisabled( item, "ItemActionComponent" )
            	if ia_comp then
            		local action_id = ComponentGetValue2( ia_comp, "action_id" )
            		local data = get_actions_lua_data( action_id )
            		if #data.related_projectiles == 0 then return end
            		
            		local proj_path = data.related_projectiles[1]
            		local uses_remaining = ComponentGetValue2( item_comp, "uses_remaining" )
					if not data.recursive and uses_remaining ~= 0 and exists( proj_path ) then
						if exists( data ) then
							local ox, oy = EntityGetTransform( GetUpdatedEntityID() )
							local mx, my = DEBUG_GetMouseWorld()
							local dir_x = mx - ox
							local dir_y = my - oy
							shoot_projectile( entity_who_kicked, proj_path, ox, oy, dir_x, dir_y )

							-- maybe save a use if the player has more than 1 stack of this perk
							local chance_to_spare_use = 0
							if pickup_count == 2 then
								if data.never_unlimited then
									chance_to_spare_use = 25
								else
									chance_to_spare_use = 50
								end
							elseif pickup_count >= 3 then
								if data.never_unlimited then
									chance_to_spare_use = 75
								else
									chance_to_spare_use = 90
								end
							end

							SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() )
							local rnd = Random( 1, 100 )
							if uses_remaining > 0 then
								if rnd <= chance_to_spare_use then
									local x, y = EntityGetTransform( GetUpdatedEntityID() )
									GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y )
								else
									ComponentSetValue2( item_comp, "uses_remaining", uses_remaining - 1 )
									if uses_remaining == 1 then
										GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/action_consumed", x, y )
									end
								end
							end
						end
            		end
	            end
	        end
	    end
	end
end