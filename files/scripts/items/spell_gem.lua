dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "mods/D2DContentPack/files/scripts/actions.lua" )
local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")

function get_max_uses( card_action )
	local itemx_comp = EntityGetFirstComponentIncludingDisabled( card_action, "ItemActionComponent" )
	if itemx_comp then
		local spell_id = ComponentGetValue2( itemx_comp, "action_id" )
		for i,action in ipairs( actions ) do
			if action.id == spell_id then
				return action.max_uses
			end
		end
	end
end

function is_never_unlimited( card_action )
	local itemx_comp = EntityGetFirstComponentIncludingDisabled( card_action, "ItemActionComponent" )
	if itemx_comp then
		local spell_id = ComponentGetValue2( itemx_comp, "action_id" )
		for i,action in ipairs( actions ) do
			if action.id == spell_id then
				return action.never_unlimited
			end
		end
	end
end

function item_pickup( entity_item, entity_who_picked, item_name )
	local children = EntityGetAllChildren( entity_who_picked )
	for k=1,#children do
		child = children[k]

		local all_card_actions = {}

		-- insert all spells slotted in wands
	    if EntityGetName( child ) == "inventory_quick" then

	        local inventory_items = EntityGetAllChildren( child )
	        if( inventory_items ~= nil ) then
	            for z=1, #inventory_items do

	            	item = inventory_items[z]
	            	if item > 0 and EZWand.IsWand( item ) then
	            		local wand = EZWand( item )
	            		local spells,attached_spells = wand:GetSpells()
	            		for i,spell in ipairs( spells ) do
	            			table.insert( all_card_actions, spell.entity_id )
	            		end

	            		-- restore each wand's mana by 10x their charge speed,
	            		-- as a little extra for the low-mana-charge-wand lovers out there
	            		wand.mana = wand.mana + ( wand.manaChargeSpeed * 10 )
	            	end
	            end
	        end
	    end

	    -- insert all spells in the 'full' inventory
	    if EntityGetName( child ) == "inventory_full" then
	        local inv_card_actions = EntityGetAllChildren( child )
	        if( inv_card_actions ~= nil ) then
	            for z=1, #inv_card_actions do
	            	inv_card_action = inv_card_actions[z]

	            	local item_comp = EntityGetFirstComponentIncludingDisabled( inv_card_action, "ItemComponent" )
	            	if item_comp then
	    				table.insert( all_card_actions, inv_card_action )
	            	end
	            end
	        end
	    end

	    for i,card_action in ipairs( all_card_actions ) do
	    	local charge_amount = 0

		    local item_comp = EntityGetFirstComponentIncludingDisabled( card_action, "ItemComponent" )
			local max_uses = get_max_uses( card_action )
			if item_comp and max_uses and max_uses > -1 then

				local uses_remaining = ComponentGetValue2( item_comp, "uses_remaining" )
				if uses_remaining < max_uses then

					local do_restore = true
					-- if the spell is "never unlimited", give it a 75% chance to be skipped
					if is_never_unlimited( card_action ) then
						do_restore = Random( 1, 100 ) < 25
					end

					if do_restore then
						charge_amount = charge_amount + math.ceil( max_uses / 10 )

						if Random( 1, 10 ) < max_uses % 10 then
							charge_amount = charge_amount + 1
						end
					end
				end

				if charge_amount > 0 then
					local itemx_comp = EntityGetFirstComponentIncludingDisabled( card_action, "ItemActionComponent" )
					if itemx_comp then
						local new_uses = math.min( uses_remaining + charge_amount, max_uses )
						ComponentSetValue2( item_comp, "uses_remaining", new_uses )

						local spell_id = ComponentGetValue2( itemx_comp, "action_id" )
						for i,action in ipairs( actions ) do
							if action.id == spell_id then
								local diff = ( new_uses - uses_remaining )

								local msg = "+" .. diff .. " " .. GameTextGetTranslatedOrNot( action.name )
								if diff > 1 then msg = msg .. "s" end
								GamePrint( msg )
							end
						end
					end
				end
			end
	    end
	end

    -- play a little sound, show a little vfx
    local x, y = EntityGetTransform( entity_item )
	GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/pick_item_generic/create", x, y )
	EntityLoad( "data/entities/particles/gold_pickup_large.xml", x, y )

    -- destroy the gem
	EntityKill( entity_item )
end