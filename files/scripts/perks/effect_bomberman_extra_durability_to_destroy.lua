dofile_once( "data/scripts/lib/utilities.lua" )

function shot( entity_id )
	local is_immune_to_explosions = has_game_effect( get_player(), "PROTECTION_EXPLOSION" )
	-- GamePrint("player has immunity: " .. tostring(is_immune_to_explosions))
	if ( is_immune_to_explosions ) then return end

    local projectile = EntityGetFirstComponentIncludingDisabled( entity_id, "ProjectileComponent" )
	local bomberman_pickup_count = get_perk_pickup_count( "CTQ_BOMBERMAN" )

	-- increase projectile's max_durability_to_destroy by 2 + 1 per Bomberman perk pickup
	local current_mdtd_value = ComponentObjectGetValue2( projectile, "config_explosion", "max_durability_to_destroy" )
	ComponentObjectSetValue2( projectile, "config_explosion", "max_durability_to_destroy", current_mdtd_value + 2 + bomberman_pickup_count )

	local etypes = { "ray_energy", "sparks_count_max", "camera_shake", "damage", "material_sparks_count_max", "physics_explosion_power.max", "stains_radius" }
	for a,b in ipairs(etypes) do
		local v = tonumber(ComponentObjectGetValue2( projectile, "config_explosion", b ))
		v = v * 1.0 + ( 1.0 * bomberman_pickup_count )
		ComponentObjectSetValue( projectile, "config_explosion", b, tostring(v) )
	end

	-- local current_raynrg_value = ComponentObjectGetValue2( projectile, "config_explosion", "ray_energy" )
	-- ComponentObjectSetValue2( projectile, "config_explosion", "ray_energy", current_raynrg_value * 1.0 + ( 0.5 * bomberman_pickup_count ) )

	-- ComponentObjectAdjustValues( projectile, "config_explosion", {
    --         max_durability_to_destroy=function( value ) return tonumber( value ) + demolitionist_bonus end,
    --         knockback_force=function( value ) return tonumber( value ) * explosion_multiplier end,
    --         explosion_radius=function( value ) return tonumber( value ) * explosion_multiplier end,
    --         ray_energy=function( value ) return tonumber( value ) * explosion_multiplier end,
    --         cell_explosion_power=function( value ) return tonumber( value ) * explosion_multiplier end,
    --         cell_explosion_radius_min=function( value ) return tonumber( value ) * explosion_multiplier end,
    --         cell_explosion_radius_max=function( value ) return tonumber( value ) * explosion_multiplier end,
    --         cell_explosion_velocity_min=function( value ) return tonumber( value ) * explosion_multiplier end,
    --         cell_explosion_damage_required=function( value ) return tonumber( value ) * explosion_multiplier end,
    --         cell_explosion_probability=function( value ) return tonumber( value ) * explosion_multiplier end,
    --         cell_explosion_power_ragdoll_coeff=function( value ) return tonumber( value ) * explosion_multiplier end,
    --     })
end