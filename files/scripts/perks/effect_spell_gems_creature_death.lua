dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
if has_vscomp( entity_id, "no_gold_drop" ) then return end

local dmg_comp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
local max_hp = ComponentGetValue2( dmg_comp, "max_hp" )

-- scale from 10% chance at 0 HP to 20% chance at 500 HP
local chance_to_drop = remap( max_hp, 0, 20, 10, 20 )
if Random( 1, 100 ) < chance_to_drop then
	local x, y = EntityGetTransform( entity_id )
    EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/spell_gem.xml", x, y )
end