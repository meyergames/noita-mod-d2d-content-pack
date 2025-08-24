dofile( "data/scripts/lib/utilities.lua" )

--local entity_id    = GetUpdatedEntityID()
--local pos_x, pos_y = EntityGetTransform( entity_id )
--
--local e_dcomp = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )
--local e_hp = ComponentGetValue2( e_dcomp, "hp" )
--local e_max_hp = ComponentGetValue2( e_dcomp, "max_hp" )
--
--
--local p_dcomp = EntityGetFirstComponentIncludingDisabled( get_player(), "DamageModelComponent" )
--local p_hp = ComponentGetValue2( p_dcomp, "hp" )
--local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )
--
----healing effect
--local heal_amount = math.max( e_max_hp * 0.1, 0.2 )
--ComponentSetValue( p_dcomp, "hp", p_hp + heal_amount )
--GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", pos_x, pos_y)
--if ( e_hp <= 0 ) then
--    ComponentSetValue( p_dcomp, "max_hp", p_max_hp + (heal_amount * 0.5) )
--    GamePrint("+" .. heal_amount * 25 .. " max HP")
--    GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/megalaser", pos_x, pos_y )
--end

local DAMAGE = 0.51

local entity_id = GetUpdatedEntityID()
local e_x, e_y = EntityGetTransform( entity_id )
local e_dcomp = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )
local e_hp = ComponentGetValue2( e_dcomp, "hp" )
local e_max_hp = ComponentGetValue2( e_dcomp, "max_hp" )

local player_id = get_player()
local p_x, p_y = EntityGetTransform( player_id )
local p_dcomp = EntityGetFirstComponentIncludingDisabled( player_id, "DamageModelComponent" )
local p_hp = ComponentGetValue2( p_dcomp, "hp" )
local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )


--check if enemy bleeds something the player can digest
local blood_mat = ComponentGetValue2( e_dcomp, "blood_material" )
--EntityIngestMaterial( player_id, CellFactory_GetType( blood_mat ), 20 )
if ( not string.find( blood_mat, "blood" ) and not string.find( blood_mat, "slime" ) and not string.find( blood_mat, "sludge" ) and not string.find( blood_mat, "lava" ) and not string.find( blood_mat, "diamond" ) ) then
    return
--    if ( string.find( blood_mat, "slime" ) and not GameHasFlagRun( "PERK_PICKED_BLEED_SLIME" ) ) then
--        return
--    elseif ( string.find( blood_mat, "oil" ) and not GameHasFlagRun( "PERK_PICKED_BLEED_OIL") ) then
--        return
--    else
--        return
--    end
end
--check if player is close enough to absorb
local dist = get_distance( p_x, p_y, e_x, e_y )
--GamePrint("> dist to player: " .. dist)
--if ( dist > 50 ) then
--    return
--end


EntityLoad( "mods/RiskRewardBundle/files/entities/projectiles/giga_drain_explosion.xml", e_x, e_y )
GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/megalaser/create", e_x, e_y )

local dir_x, dir_y = vec_normalize( p_x - e_x, p_y - e_y )

local bubble_amt = math.min( math.max( math.ceil( e_max_hp * 0.5 ), 1 ), 20 )
for i = 1, bubble_amt do
    local rdir_x, rdir_y = vec_rotate( dir_x, dir_y, Random( -22.5, 22.5 ) )
    local speed = Random( 10, 40 )
    shoot_projectile( entity_id, "mods/RiskRewardBundle/files/entities/projectiles/deck/giga_drain_bubble.xml", e_x, e_y, rdir_x * speed, rdir_y * speed)
end

local damage_to_be_dealt = DAMAGE * ComponentObjectGetValue2( e_dcomp, "damage_multipliers", "drill" )

local max_hp_bubble_amt = math.min( math.max( math.ceil( e_max_hp * 0.25 ), 1 ), 5 )
for i = 1, max_hp_bubble_amt do
    if ( e_hp <= damage_to_be_dealt or Random( 0, 20 ) == 1 ) then
        local rdir_x, rdir_y = vec_rotate( dir_x, dir_y, Random( -22.5, 22.5 ) )
        local speed = Random( 10, 40 )
        shoot_projectile( entity_id, "mods/RiskRewardBundle/files/entities/projectiles/deck/giga_drain_max_hp_bubble.xml", e_x, e_y, rdir_x * speed, rdir_y * speed)
    end
--    local gained_max_hp = math.min( heal_amount * 0.5 )
--    ComponentSetValue( p_dcomp, "max_hp", p_max_hp + gained_max_hp  )
--    GamePrint("+" .. gained_max_hp * 25 .. " max HP")
--    GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/megalaser", p_x, p_y )
end

EntityInflictDamage( entity_id, DAMAGE, "DAMAGE_DRILL", "giga drain", "BLOOD_EXPLOSION", 0, 0, player_id, e_x, e_y, 0 )

--healing effect
--local heal_amount = math.max( e_max_hp * 0.1, 0.08 )
--ComponentSetValue( p_dcomp, "hp", math.min( p_hp + heal_amount, p_max_hp ) )
--GamePlaySound("data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", p_x, p_y)
--GamePrint("> enemy hp: " .. e_hp * 25 .. " / " .. e_max_hp * 25)
--if ( e_hp <= 0 ) then
--    local gained_max_hp = math.min( heal_amount * 0.5 )
--    ComponentSetValue( p_dcomp, "max_hp", p_max_hp + gained_max_hp  )
--    GamePrint("+" .. gained_max_hp * 25 .. " max HP")
--    GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/megalaser", p_x, p_y )
--end
