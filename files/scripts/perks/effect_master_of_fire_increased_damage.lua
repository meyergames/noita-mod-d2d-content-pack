dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function shot( entity_id )
	if is_immune_to_fire() or not has_game_effect( get_player(), "ON_FIRE" ) then return end

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
				ComponentObjectSetValue( comp, "damage_by_type", b, tonumber(v) )
			end

			-- multiply other damage by x1.25
			dtypes = { "projectile", "explosion", "melee", "ice", "slice", "electricity", "radioactive", "drill" }
			for a,b in ipairs(dtypes) do
				local v = tonumber(ComponentObjectGetValue( comp, "damage_by_type", b ))
				v = v * 1.25
				ComponentObjectSetValue( comp, "damage_by_type", b, tonumber(v) )
			end
		end
	end
end