dofile_once( "data/scripts/lib/utilities.lua" )

function shot( entity_id )
	local is_immune_to_fire = has_game_effect( get_player(), "PROTECTION_FIRE" )
	local is_on_fire = has_game_effect( get_player(), "ON_FIRE" )

	-- GamePrint("player has immunity: " .. tostring(is_immune_to_explosions))
	if ( is_immune_to_fire or not is_on_fire ) then return end

	local comps = EntityGetComponent( entity_id, "ProjectileComponent" )
	if( comps ~= nil ) then
		for i,comp in ipairs(comps) do
			local damage = ComponentGetValue2( comp, "damage" )
			damage = damage * 2.0
			ComponentSetValue2( comp, "damage", damage )
			
			-- multiply fire damage by x2.5
			local dtypes = { "fire" }
			for a,b in ipairs(dtypes) do
				local v = tonumber(ComponentObjectGetValue( comp, "damage_by_type", b ))
				v = v * 2.5
				ComponentObjectSetValue( comp, "damage_by_type", b, tostring(v) )
			end

			-- multiply other damage by x1.5
			dtypes = { "projectile", "explosion", "melee", "ice", "slice", "electricity", "radioactive", "drill" }
			for a,b in ipairs(dtypes) do
				local v = tonumber(ComponentObjectGetValue( comp, "damage_by_type", b ))
				v = v * 1.5
				ComponentObjectSetValue( comp, "damage_by_type", b, tostring(v) )
			end
		end
	end
end