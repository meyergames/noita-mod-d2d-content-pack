dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function item_pickup( entity_item, entity_pickupper, item_name )
	-- fix rotation glitch
	local abicomp = EntityGetFirstComponentIncludingDisabled( entity_item, "AbilityComponent" )
	if exists( abicomp ) then
		ComponentSetValue2( abicomp, "rotate_in_hand_amount", 1 )
	end

	-- try inject script_shot on player
	if not has_lua( entity_pickupper, "d2d_staff_of_loyalty_on_shot" ) then
		EntityAddComponent2( entity_pickupper, "LuaComponent", {
			_tags = "d2d_staff_of_loyalty_on_shot",
			script_shot = "mods/D2DContentPack/files/scripts/items/wands/staff_of_loyalty_on_shot.lua",
			execute_every_n_frame = -1,
		})
	end
end