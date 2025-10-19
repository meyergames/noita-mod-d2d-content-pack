dofile_once( "data/scripts/lib/utilities.lua" )

-- disable the wand's mana regen
local parent_id = EntityGetParent( GetUpdatedEntityID() )
local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
if parent_id and EZWand.IsWand( parent_id ) then
	local wand = EZWand( parent_id )

	local mtp = 1.0
	local concentrated_mana_effect_id = GameGetGameEffect( get_player(), "MANA_REGENERATION" )
	if concentrated_mana_effect_id ~= 0 then
		local held_wand = EZWand.GetHeldWand()
		if wand.entity_id == held_wand.entity_id then
			mtp = 4.0
		end
	end

	wand.mana = math.max( wand.mana - ( ( wand.manaChargeSpeed / 60 ) * mtp ), 1 )
end
