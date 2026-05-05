dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	if entity_thats_responsible == 0 or entity_thats_responsible == GetUpdatedEntityID() then
		return damage, critical_hit_chance
	end

	local EFFECT_RADIUS = 80
	local nearby_players = EntityGetInRadiusWithTag( x, y, EFFECT_RADIUS, "player_unit" )
	if exists( nearby_players ) then
		for i,nearby_player in ipairs( nearby_players ) do
			
			if nearby_player ~= GetUpdatedEntityID() then
				local is_team_tank = get_internal_bool( nearby_player, "d2d_is_team_tank" )
				if is_team_tank then
					
					local x, y = EntityGetTransform( nearby_player )
					EntityInflictDamage( nearby_player, damage * 0.25, "DAMAGE_CURSE", "blood link", "NONE", 0, 0, nearby_player, x, y, 0 )
					
					return damage * 0.5, critical_hit_chance
				end
			end
		end
	end

    return damage, critical_hit_chance
end
