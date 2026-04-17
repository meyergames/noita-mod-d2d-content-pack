dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local pickup_count = get_perk_pickup_count( "D2D_LEECH_LIFE" )

local entity_id = GetUpdatedEntityID()
local e_x, e_y = EntityGetTransform( entity_id )
local e_dcomp = EntityGetFirstComponentIncludingDisabled( entity_id, "DamageModelComponent" )
local e_hp = ComponentGetValue2( e_dcomp, "hp" )
local e_max_hp = ComponentGetValue2( e_dcomp, "max_hp" )

EntityLoad( "mods/D2DContentPack/files/entities/projectiles/giga_drain_explosion.xml", e_x, e_y )
GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/megalaser/create", e_x, e_y )

local player_id = get_player()
local p_x, p_y = EntityGetTransform( player_id )
local dir_x, dir_y = vec_normalize( p_x - e_x, p_y - e_y )

local bubble_amt = math.min( math.max( math.ceil( e_max_hp * 0.25 ), 1 ), 10 ) * pickup_count
for i = 1, bubble_amt do
    local rdir_x, rdir_y = vec_rotate( dir_x, dir_y, Random( -22.5, 22.5 ) )
    local speed = Random( 10, 40 )
    shoot_projectile( entity_id, "mods/D2DContentPack/files/entities/projectiles/deck/giga_drain_bubble.xml", e_x, e_y, rdir_x * speed, rdir_y * speed)
end

local max_hp_bubble_amt = math.min( math.max( math.ceil( e_max_hp * 0.125 ), 1 ), 5 ) * pickup_count
for i = 1, max_hp_bubble_amt do
    local rdir_x, rdir_y = vec_rotate( dir_x, dir_y, Random( -22.5, 22.5 ) )
    local speed = Random( 10, 40 )
    shoot_projectile( entity_id, "mods/D2DContentPack/files/entities/projectiles/deck/giga_drain_max_hp_bubble.xml", e_x, e_y, rdir_x * speed, rdir_y * speed)
end
