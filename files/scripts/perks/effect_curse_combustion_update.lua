dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local x, y = EntityGetTransform( owner )

local cooldown_time = getInternalVariableValue( owner, "combustion_cooldown_time", "value_int" )
if ( cooldown_time > 0 ) then
    setInternalVariableValue( owner, "combustion_cooldown_time", "value_int", cooldown_time - 1 )
    return
end
if ( has_game_effect( owner, "ON_FIRE" ) ) then return end

local p_dcomp = EntityGetFirstComponentIncludingDisabled( owner, "DamageModelComponent" )
local p_hp = ComponentGetValue2( p_dcomp, "hp" )
local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )
if ( p_hp < p_max_hp * 0.2 ) then return end

local rnd = Random( 1, 60 )
if ( rnd == 1 ) then
    shoot_projectile( owner, "mods/RiskRewardBundle/files/entities/projectiles/deck/nolla_firebomb.xml", x, y, 0, 0 )
    setInternalVariableValue( owner, "combustion_cooldown_time", "value_int", 60 )
end
