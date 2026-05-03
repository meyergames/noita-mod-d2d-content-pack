dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local old_item_pickup = item_pickup
item_pickup = function( entity_item, entity_who_picked, name )
	if get_perk_pickup_count( "D2D_MANA_BATTERY" ) >= 1 then
		local held_wand = EZWand.GetHeldWand()
		if not exists( held_wand ) then
			held_wand = get_all_wands( get_player() )[1]
		end
		held_wand.mana = held_wand.manaMax
	end

    old_item_pickup( entity_item, entity_who_picked, name )
end
