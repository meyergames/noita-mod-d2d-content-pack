dofile_once( "data/scripts/lib/utilities.lua" )
dofile( "data/scripts/game_helpers.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
	local wand = EZWand.GetHeldWand()

	if wand then -- first try to upgrade the player's held wand
		dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
		apply_random_wand_upgrades( wand, get_perk_pickup_count( "D2D_WANDSMITH" ), "held wand" )
		
		GamePrintImportant( "Your held wand got upgraded!" )
	else -- if no wand is held, get the first wand
		local children = EntityGetAllChildren( entity_who_picked )
		for k=1,#children do
			child = children[k]
		    if EntityGetName( child ) == "inventory_quick" then
		        local inventory_items = EntityGetAllChildren(child)
		        if inventory_items ~= nil then
		            for z=1, #inventory_items do
		            	item = inventory_items[z]

		                if item and EZWand.IsWand( item ) then
		                	local wand = EZWand( item )
		                	if wand then
				    			dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
				    			apply_random_wand_upgrades( wand, get_perk_pickup_count( "D2D_EVOLVING_WANDS" ), "first wand" )

								GamePrintImportant( "Your first wand got upgraded!" )
						    	break
						    end
		                end
		            end 
		        end
		    end 
		end
	end

	local x, y = EntityGetTransform( entity_item )

	EntityLoad("mods/D2DContentPack/files/particles/image_emitters/hammer.xml", x, y-12)
	-- EntityLoad("data/entities/particles/heart_out.xml", x, y-8)

	GameTriggerMusicCue( "item" )

	-- remove the item from the game
	EntityKill( entity_item )
	-- remove nearby temple heart + spell refresher
	for _,item_id in ipairs( EntityGetInRadiusWithTag( x, y, 32, "drillable" ) ) do
		EntityKill( item_id )
	end
end
