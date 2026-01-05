dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
if has_vscomp( entity_id, "no_gold_drop" ) then return end

-- scale from 20% chance to drop at 0 HP, to 50% chance at 500 HP
local dmg_comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
if dmg_comp then
	local max_hp = ComponentGetValue2( dmg_comp, "max_hp" )
	local chance_to_drop = remap( max_hp, 0, 20, 20, 50 )
	local rnd = Random( 1, 100 )
	while rnd < chance_to_drop do
		local x, y = EntityGetTransform( entity_id )

		local offset_x = Random( -4, 4 )
		local offset_y = Random( -4, 4 )
		EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/spell_gem.xml", x + offset_x, y + offset_y )

		-- reset rnd
		rnd = Random( 1, 100 )
	end
end
