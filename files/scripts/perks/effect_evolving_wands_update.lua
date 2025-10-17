dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "data/scripts/gun/procedural/gun_action_utils.lua" )
dofile_once( "data/scripts/game_helpers.lua" )

local BASE_AMT_OF_UPGRADES = 3

local entity_id    = GetUpdatedEntityID()
local player_id = EntityGetRootEntity( GetUpdatedEntityID() )
local x, y = EntityGetTransform( player_id )

local currbiome = BiomeMapGetName( x, y )
local flag = "evolving_wands_" .. tostring(currbiome) .. "_visited"

if ( GameHasFlagRun( flag ) == false ) then
	local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
	local wand = EZWand.GetHeldWand()

	if wand then -- first try to upgrade the player's held wand
		dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
		apply_random_wand_upgrades( wand, get_perk_pickup_count( "D2D_WANDSMITH" ), "held wand" )
		
		GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y )
		GameAddFlagRun( flag )
	else -- if no wand is held, get the first wand
		local children = EntityGetAllChildren( player_id )
		for k=1,#children do
			child = children[k]
		    if EntityGetName( child ) == "inventory_quick" then
		        local inventory_items = EntityGetAllChildren(child)
		        if inventory_items ~= nil then
		            for z=1, #inventory_items do
		            	item = inventory_items[z]

		            	if EZWand.IsWand( item ) then
		            		local wand = EZWand( item )
					    	dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
					    	apply_random_wand_upgrades( wand, get_perk_pickup_count( "D2D_EVOLVING_WANDS" ), "first wand" )

							GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y )
							GameAddFlagRun( flag )

		            		break
		            	end
		            end
		        end
		    end
		end
	end
end
