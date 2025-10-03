dofile_once( "data/scripts/lib/utilities.lua" )

-- local is_effect_enabled = false

-- function enabled_changed( entity_id, is_enabled )
-- 	is_effect_enabled = is_enabled
-- end

-- if not is_effect_enabled then return end

-- disable the wand's mana regen
local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local wand = EZWand.GetHeldWand()
wand.mana = math.max( wand.mana - ( wand.manaChargeSpeed / 60 ), 1 )
