dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "data/scripts/gun/procedural/gun_action_utils.lua" )
dofile_once( "data/scripts/game_helpers.lua" )

local BASE_AMT_OF_UPGRADES = 3

local entity_id    = GetUpdatedEntityID()
local player_id = EntityGetRootEntity( GetUpdatedEntityID() )
local x, y = EntityGetTransform( player_id )

local currbiome = BiomeMapGetName( x, y )
local flag = "adventurer_" .. tostring(currbiome) .. "_visited"

if ( GameHasFlagRun( flag ) == false ) then

	GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y)
	GameAddFlagRun( flag )

	local children = EntityGetAllChildren( player_id )
	for k=1,#children
	do child = children[k]
	    if EntityGetName( child ) == "inventory_quick" then
	        local inventory_items = EntityGetAllChildren(child)
	        if(inventory_items ~= nil) then 
	            for z=1,#inventory_items
	            do item = inventory_items[z]
	            	local EZWand = dofile_once("mods/RiskRewardBundle/files/scripts/lib/ezwand.lua")
	                if EZWand.IsWand( item ) then
            			local number_suffix = "th"
            			if z % 10 == 1 then number_suffix = "st"
            			elseif z % 10 == 2 then number_suffix = "nd"
            			elseif z % 10 == 3 then number_suffix = "rd" end

	                	local wand = EZWand( item )
	                	local upgrades_had = getInternalVariableValue( item, "adventurous_upgrades_had", "value_int" )
	                	if upgrades_had == nil then
	                		upgrades_had = 1
	                		addNewInternalVariable( item, "adventurous_upgrades_had", "value_int", upgrades_had )
	                	else
	                		upgrades_had = upgrades_had + 1
	                		setInternalVariableValue( item, "adventurous_upgrades_had", "value_int", upgrades_had )
	                	end

	                	-- if ( upgrades_had+1 < 10 ) then
	                	local amt_of_upgrades = BASE_AMT_OF_UPGRADES
	                	if upgrades_had % 5 == 4 then
	                		amt_of_upgrades = BASE_AMT_OF_UPGRADES * 5
                			GamePrint("Your " .. z .. number_suffix .. " wand got a massive upgrade!")
	                	else
                			GamePrint("Your " .. z .. number_suffix .. " wand got an upgrade.")
	                	end

	                	for i = 1, amt_of_upgrades do
	                		local rnd = Random( 0, 100 )
	                		if ( rnd <= 5 and wand.shuffle == true ) then -- 5% chance to make non-shuffle
	                			wand.shuffle = false

	                			local number_suffix = "th"
	                			if z % 10 == 1 then number_suffix = "st"
	                			elseif z % 10 == 2 then number_suffix = "nd"
	                			elseif z % 10 == 3 then number_suffix = "rd" end
	                			GamePrint("Your " .. z .. number_suffix .. " wand became non-shuffle!")

	                		elseif ( rnd <= 20 and wand.capacity < 20 ) then
	                			wand.capacity = wand.capacity + 1

	                		elseif ( rnd <= 35 and wand.spread > -30.0 ) then
	                			wand.spread = math.max( wand.spread - math.max( wand.spread * 0.5, 1.0 ), -30.0 )

	                		elseif ( rnd <= 50 and wand.manaMax < 5000 ) then
	                			wand.manaMax = math.min( wand.manaMax + math.max( wand.manaMax * 0.05, 10 ), 5000 )

	                		elseif ( rnd <= 65 and wand.manaChargeSpeed < 5000 ) then
	                			wand.manaChargeSpeed = math.min( wand.manaChargeSpeed + math.max( wand.manaChargeSpeed * 0.05, 10 ), 5000 )

	                		elseif ( rnd <= 80 and wand.castDelay > -21 ) then
                				wand.castDelay = math.max( wand.castDelay - math.max( wand.castDelay * 0.1, 2 ), -21 ) -- at least 0.03s reduction

	                		elseif ( rnd <= 95 and wand.rechargeTime > -21 ) then
	                			wand.rechargeTime = math.max( wand.rechargeTime - math.max( wand.rechargeTime * 0.1, 2 ), -21 ) -- at least 0.03s reduction

	                		end
						end

						local base_wand_name, show_in_ui = wand:GetName()
						if ( string.find( base_wand_name, " Mk." ) ) then
							base_wand_name = split_string( base_wand_name, " Mk." )[1]
						end
						
						if ( string.find( base_wand_name, "_" ) or base_wand_name == "" ) then
							base_wand_name = "Wand"
						end

						wand:SetName( base_wand_name .. " Mk." .. to_roman_numerals( upgrades_had + 1 ), true )
						-- end
	                end 
	            end 
	        end
	    end 
	end
end
