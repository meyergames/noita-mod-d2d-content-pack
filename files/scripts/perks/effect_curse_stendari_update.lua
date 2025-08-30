dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )

if ( has_game_effect( owner, "WET" ) ) then
	local dcomp = EntityGetFirstComponentIncludingDisabled( owner, "DamageModelComponent" )
	local p_hp = ComponentGetValue2( dcomp, "hp" )
   	local p_max_hp = ComponentGetValue2( dcomp, "max_hp" )

   	EntityInflictDamage( owner, p_max_hp * 0.01, "NONE", "wetness (stendari curse)", "NONE", 0, 0, owner, x, y, 0 )
end
