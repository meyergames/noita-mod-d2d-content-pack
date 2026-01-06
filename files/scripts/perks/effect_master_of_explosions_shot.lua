dofile_once( "data/scripts/lib/utilities.lua" )

function shot( proj_id )
	local is_immune_to_explosions = has_game_effect( get_player(), "PROTECTION_EXPLOSION" )
	-- GamePrint("player has immunity: " .. tostring(is_immune_to_explosions))
	if is_immune_to_explosions then return end

    local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
    local proj_dmg = ComponentGetValue2( proj_comp, "damage" )
    local expl_dmg = ComponentObjectGetValue2( proj_comp, "config_explosion", "damage" )
    if proj_dmg > 0 and expl_dmg < 0.4 then
    	EntityAddComponent2( proj_id, "LuaComponent", {
    		script_source_file = "mods/D2DContentPack/files/scripts/perks/effect_master_of_explosions_create_small_explosion.lua",
    		execute_every_n_frame = -1,
    		execute_on_removed = true,
    	})
    end

	local master_of_explosions_pickup_count = get_perk_pickup_count( "D2D_MASTER_OF_EXPLOSIONS" )

	-- increase projectile's max_durability_to_destroy by 2 + 1 per Bomberman perk pickup
	local current_mdtd_value = ComponentObjectGetValue2( proj_comp, "config_explosion", "max_durability_to_destroy" )
	if current_mdtd_value then
		ComponentObjectSetValue2( proj_comp, "config_explosion", "max_durability_to_destroy", current_mdtd_value + 2 + master_of_explosions_pickup_count )
	end

	local etypes = { "ray_energy", "sparks_count_max", "camera_shake", "damage", "material_sparks_count_max" }
	for a,b in ipairs(etypes) do
		local value = ComponentObjectGetValue2( proj_comp, "config_explosion", b )
		if value then
			local v = tonumber( value )
			v = v * 1.0 + ( 1.0 * master_of_explosions_pickup_count )
			ComponentObjectSetValue( proj_comp, "config_explosion", b, tostring(v) )
		end
	end
end