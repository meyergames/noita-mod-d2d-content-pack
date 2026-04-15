dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
local EZWand = dofile_once( "mods/D2DContentPack/files/scripts/lib/ezwand.lua" )
local wand = EZWand.GetHeldWand()

local proj_id = GetUpdatedEntityID()
local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
local was_already_applied = get_internal_bool( proj_id, "d2d_missing_mana_to_dmg_applied" )
if exists( wand ) and exists( proj_comp ) and not was_already_applied then
	-- local proj_mana_cost = ComponentObjectGetValue2( proj_comp, "config", "action_mana_drain" )
	-- local mana_cost_mtp = remap( proj_mana_cost, 5, 120, 1.0, 4.0 )

	-- determine how long it takes for the wand to regain full mana
	local time_until_full_mana = wand.manaMax / math.max( wand.manaChargeSpeed, 10 )

	-- the spell is barely effective if the wand recharges its mana quickly
	local effectiveness = ( time_until_full_mana * 0.1 ) -- 1s = 10%, 10s = 100%, 20s = 200%, ...

	local dmg_mtp = 1.0 + ( ( wand.mana * 0.001 ) * effectiveness )

	multiply_proj_dmg( proj_id, dmg_mtp, "missing_mana_to_dmg" )
	set_internal_bool( proj_id, "d2d_missing_mana_to_dmg_applied", true )
end