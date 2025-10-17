dofile_once( "data/scripts/lib/utilities.lua" )

local old_generate_shop_item = generate_shop_item
function generate_shop_item( x, y, cheap_item, biomeid_, is_stealable )
	local item_id = old_generate_shop_item( x, y, cheap_item, biomeid_, is_stealable )

	local courier_perk_count = get_perk_pickup_count( "D2D_SPELL_COURIER" )
	if courier_perk_count > 0 then
		EntityAddComponent2( item_id, "LuaComponent", {
			script_item_picked_up="mods/D2DContentPack/files/scripts/perks/effect_spell_courier_item_bought.lua",
			execute_every_n_frame=-1,
		})
	end
end

function generate_shop_item_old( x, y, cheap_item, biomeid_, is_stealable )
	old_generate_shop_item( x, y, cheap_item, biomeid_, is_stealable )
end