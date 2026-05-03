dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local parasite_id = GetUpdatedEntityID()

-- heal by 1 hp every second
-- local dmg_comp = EntityGetFirstComponentIncludingDisabled( parasite_id, "DamageModelComponent" )
-- if exists( dmg_comp ) then
-- 	local hp = ComponentGetValue2( dmg_comp, "hp" )
-- 	local max_hp = ComponentGetValue2( dmg_comp, "max_hp" )
-- 	ComponentSetValue2( dmg_comp, "hp", math.min( hp + 0.04, max_hp ) )
-- end
