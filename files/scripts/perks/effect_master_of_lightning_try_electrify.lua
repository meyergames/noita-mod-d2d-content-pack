dofile_once("data/scripts/lib/utilities.lua")

local proj_id = GetUpdatedEntityID()
local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
if proj_comp then
	local dmg_proj = ComponentGetValue2( proj_comp, "damage" ) or -1
	local dmg_expl = ComponentObjectGetValue2( proj_comp, "config_explosion", "damage" ) or -1

	-- local dmg_add_fire = ComponentObjectGetValue2( proj_comp, "damage_by_type", "fire" )
	-- ^ *could* check for added damage, but wouldn't that cause lag on a rapidfire wand?

	if dmg_proj > 0 or dmg_expl > 0 then
		local lightning_count = ComponentObjectGetValue2( proj_comp, "config", "lightning_count" ) or -1
		local electricity_count = ComponentObjectGetValue2( proj_comp, "config_explosion", "electricity_count" ) or -1
		ComponentObjectSetValue2( proj_comp, "config", "lightning_count", lightning_count + 1 )
		ComponentObjectSetValue2( proj_comp, "config_explosion", "electricity_count", electricity_count + 1 )
	end
end