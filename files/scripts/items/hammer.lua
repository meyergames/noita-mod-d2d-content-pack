dofile_once( "data/scripts/lib/utilities.lua" )
dofile( "data/scripts/game_helpers.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	local children = EntityGetAllChildren( entity_who_picked )
	for k=1,#children do
		child = children[k]
	    if EntityGetName( child ) == "inventory_quick" then
	        local inventory_items = EntityGetAllChildren(child)
	        if inventory_items ~= nil then
	            for z=1, #inventory_items do
	            	item = inventory_items[z]

	            	local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
	                if item and EZWand.IsWand( item ) then
            			local number_suffix = "th"
            			if z % 10 == 1 then number_suffix = "st"
            			elseif z % 10 == 2 then number_suffix = "nd"
            			elseif z % 10 == 3 then number_suffix = "rd" end

				    	dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
	                	local wand = EZWand( item )
	                	if wand then
					    	apply_random_wand_upgrades( wand, get_perk_pickup_count( "D2D_WANDSMITH" ), z .. number_suffix .. " wand" )
					    end
	                end
	            end 
	        end
	    end 
	end

	local x, y = EntityGetTransform( entity_item )

	EntityLoad("mods/D2DContentPack/files/particles/image_emitters/hammer.xml", x, y-12)
	-- EntityLoad("data/entities/particles/heart_out.xml", x, y-8)

	GamePrintImportant( "Your wands got upgraded!" )
	GameTriggerMusicCue( "item" )

	-- remove the item from the game
	EntityKill( entity_item )
	-- remove nearby temple heart + spell refresher
	for _,item_id in ipairs( EntityGetInRadiusWithTag( x, y, 32, "drillable" ) ) do
		EntityKill( item_id )
	end
end
