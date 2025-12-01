dofile_once( "data/scripts/lib/utilities.lua" )

local THRESHOLD = 0.2

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )

local p_dcomp = EntityGetFirstComponentIncludingDisabled( owner, "DamageModelComponent" )
local p_hp = ComponentGetValue2( p_dcomp, "hp" )
local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )

if p_hp > p_max_hp * THRESHOLD then
	EntityInflictDamage( owner, p_max_hp * 0.01, "DAMAGE_CURSE", "emergency injection", "NONE", 0, 0, owner, x, y, 0)
else
	ComponentSetValue2( p_dcomp, "hp", p_hp + ( p_max_hp * 0.01 ) )
	GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y )
end