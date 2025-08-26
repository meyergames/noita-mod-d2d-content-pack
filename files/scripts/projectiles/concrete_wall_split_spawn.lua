dofile( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local e_x, e_y = EntityGetTransform( entity_id )
local p_x, p_y = EntityGetTransform( get_player() )

local id_to_spawn = "mods/RiskRewardBundle/files/entities/projectiles/concrete_wall_bullet_split.xml"

local proj_dir_x, proj_dir_y = vec_normalize( e_x - p_x, e_y - p_y )
local dir_xa, dir_ya = vec_rotate( proj_dir_x, proj_dir_y, -4.7 )
local dir_xb, dir_yb = vec_rotate( proj_dir_x, proj_dir_y, 4.7 )
local speed = 125

shoot_projectile( entity_id, id_to_spawn, e_x, e_y, dir_xa * speed, dir_ya * speed)
shoot_projectile( entity_id, id_to_spawn, e_x, e_y, dir_xb * speed, dir_yb * speed)
