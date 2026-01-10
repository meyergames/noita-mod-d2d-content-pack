dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function item_pickup( entity_item, entity_pickupper, item_name )
	-- fix rotation glitch
	local abicomp = EntityGetFirstComponentIncludingDisabled( entity_item, "AbilityComponent" )
	if exists( abicomp ) then
		ComponentSetValue2( abicomp, "rotate_in_hand_amount", 1 )
	end
end