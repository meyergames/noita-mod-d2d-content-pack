dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

-- disable the wand's mana regen
local entity_id = GetUpdatedEntityID()
local wand_entity_id = EntityGetParent( entity_id )
local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")

if wand_entity_id and EZWand.IsWand( wand_entity_id ) then
	local wand = EZWand( wand_entity_id )

	local mtp = 1.0
	local concentrated_mana_effect_id = GameGetGameEffect( get_player(), "MANA_REGENERATION" )
	if concentrated_mana_effect_id ~= 0 then
		local held_wand = EZWand.GetHeldWand()
		if wand.entity_id == held_wand.entity_id then
			mtp = 4.0
		end
	end

	-- counter natural mana charge speed
	wand.mana = math.max( wand.mana - ( ( wand.manaChargeSpeed / 60 ) * mtp ), 0.01 )

	-- if the player tries to increase the wand's mana through any spell, revert it
	local is_enabled = get_internal_bool( wand_entity_id, "d2d_mana_lock_enabled" )
	if is_enabled then
		local cached_mana = get_internal_float( wand_entity_id, "d2d_mana_lock_lowest_mana" )
		if not exists( cached_mana ) or cached_mana > wand.mana then
			set_internal_float( wand_entity_id, "d2d_mana_lock_lowest_mana", wand.mana )
			cached_mana = get_internal_float( wand_entity_id, "d2d_mana_lock_lowest_mana" )
			GamePrint( wand_entity_id .. " > " .. cached_mana )
		end
		if wand.mana > cached_mana then
			local diff = wand.mana - cached_mana
			wand.mana = math.max( cached_mana - diff, 0.01 )
		end
	end
end
