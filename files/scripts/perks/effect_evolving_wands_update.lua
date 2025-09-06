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

	GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y)
	GameAddFlagRun( flag )

	local children = EntityGetAllChildren( player_id )
	for k=1,#children do
		child = children[k]
	    if EntityGetName( child ) == "inventory_quick" then
	        local inventory_items = EntityGetAllChildren(child)
	        if( inventory_items ~= nil ) then 
	            for z=1, #inventory_items do
	            	item = inventory_items[z]

	            	local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
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

                		local rnd = Random( 0, 100 )
	                	local is_mega_upgrade = false
	                	if upgrades_had % 5 == 0 then
	                		is_mega_upgrade = true
                			GamePrint("Your " .. z .. number_suffix .. " wand got an all-round upgrade!")
	                	end

                		if ( is_mega_upgrade or ( rnd <= 5 and wand.shuffle == true ) ) then -- 5% chance to make non-shuffle
                			wand.shuffle = false

                			if not is_mega_upgrade then
                				GamePrint("Your " .. z .. number_suffix .. " wand became non-shuffle!")
                				goto upgrades_finished
                			end
                		end

                		if ( is_mega_upgrade or ( rnd <= 20 and wand.capacity < 20 ) ) then
                			local old_capacity = wand.capacity
                			wand.capacity = old_capacity + 1

                			if not is_mega_upgrade then
                				GamePrint( "Your " .. z .. number_suffix .. " wand's capacity was increased! (" .. old_capacity .. " > " .. wand.capacity .. ")" )
                				goto upgrades_finished
                			end
                		end

                		if ( is_mega_upgrade or ( rnd <= 40 and wand.spread > -30.0 ) ) then
                			local old_spread = wand.spread
                			wand.spread = math.max( wand.spread - math.max( wand.spread * 0.5, 3.0 ), -30.0 )

                			if not is_mega_upgrade then
                				GamePrint("Your " .. z .. number_suffix .. " wand's accuracy was increased. (" .. old_spread .. " > " .. wand.spread .. ")" )
                				goto upgrades_finished
                			end
                		end

                		if ( is_mega_upgrade or ( rnd <= 60 and wand.manaMax < 5000 ) ) then
                			local old_mana_max = wand.manaMax
                			wand.manaMax = math.min( old_mana_max + math.max( old_mana_max * 0.1, 30 ), 5000 )

                			if not is_mega_upgrade then
                				GamePrint("Your " .. z .. number_suffix .. " wand's max mana was increased. (" .. old_mana_max .. " > " .. wand.manaMax .. ")" )
                				goto upgrades_finished
                			end
                		end

                		if ( is_mega_upgrade or ( rnd <= 80 and wand.manaChargeSpeed < 5000 ) ) then
                			local old_mana_charge_speed = wand.manaChargeSpeed
                			wand.manaChargeSpeed = math.min( old_mana_charge_speed + math.max( old_mana_charge_speed * 0.1, 30 ), 5000 )

                			if not is_mega_upgrade then
                				GamePrint("Your " .. z .. number_suffix .. " wand's mana charge speed was increased. (" .. old_mana_charge_speed .. " > " .. wand.manaChargeSpeed .. ")" )
                				goto upgrades_finished
                			end
                		end

                		if ( is_mega_upgrade or ( rnd <= 100 ) ) then
                			local old_cast_delay = wand.castDelay
                			local old_recharge_time = wand.rechargeTime

                			if ( wand.castDelay > -21 ) then
            					wand.castDelay = math.max( old_cast_delay - math.max( old_cast_delay * 0.1, 2 ), -21 ) -- at least 0.03s reduction
            				end
            				if ( wand.rechargeTime > -21) then
                				wand.rechargeTime = math.max( old_recharge_time - math.max( old_recharge_time * 0.1, 3 ), -21 ) -- at least 0.05s reduction
                			end

                			if not is_mega_upgrade then
                				GamePrint("Your " .. z .. number_suffix .. " wand's fire rate was increased! (" .. string.format( "%.2f", old_cast_delay / 60 ) .. "/" .. string.format( "%.2f", old_recharge_time / 60 ) .. " > " .. string.format( "%.2f", wand.castDelay / 60 ) .. "/" .. string.format( "%.2f", wand.rechargeTime / 60 ) .. ")" )
                				goto upgrades_finished
                			end
                		end

                		::upgrades_finished::

						-- local base_wand_name, show_in_ui = wand:GetName()
						-- if ( string.find( base_wand_name, " Mk." ) ) then
						-- 	base_wand_name = split_string( base_wand_name, " Mk." )[1]
						-- end

						-- if ( string.find( base_wand_name, "_" ) or base_wand_name == "" ) then
						-- 	base_wand_name = "Wand"
						-- end

						-- wand:SetName( base_wand_name .. " Mk." .. to_roman_numerals( upgrades_had + 1 ), true )
	                end
	            end 
	        end
	    end 
	end
end
