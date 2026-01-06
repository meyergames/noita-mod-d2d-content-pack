dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
	local player = GetUpdatedEntityID()

	if exists( entity_thats_responsible ) and damage > 0 then
		local effect = get_child_with_tag( player, "d2d_heal_block_effect" )
		if exists( effect ) then
			EntityKill( effect )
		end
		EntityAddChild( player, EntityLoad( "mods/D2DContentPack/files/entities/misc/status_effects/effect_heal_block.xml", x, y ) )
	end

    return damage, critical_hit_chance
end