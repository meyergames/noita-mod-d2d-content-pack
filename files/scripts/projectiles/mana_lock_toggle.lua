dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local wand_entity_id = EntityGetParent( entity_id )
local player = get_player()

function enabled_changed( entity_id, is_enabled )
	if not exists( wand_entity_id ) then return end

	set_internal_bool( wand_entity_id, "d2d_mana_lock_enabled", is_enabled )
	if not is_enabled then
		set_internal_float( wand_entity_id, "d2d_mana_lock_lowest_mana", 999999 )
		GamePrint( wand_entity_id .. " > " .. get_internal_float( wand_entity_id, "d2d_mana_lock_lowest_mana" ) )
	else
		local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
		if EZWand.IsWand( wand_entity_id ) then
			local wand = EZWand( wand_entity_id )
			set_internal_float( wand_entity_id, "d2d_mana_lock_lowest_mana", wand.mana )
			GamePrint( wand_entity_id .. " > " .. get_internal_float( wand_entity_id, "d2d_mana_lock_lowest_mana" ) )
		end
	end
end