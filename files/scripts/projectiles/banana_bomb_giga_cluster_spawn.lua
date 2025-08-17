dofile( "data/scripts/lib/utilities.lua" )

local SPAWN_AMOUNT = 5

local entity_id = GetUpdatedEntityID()
local e_x, e_y = EntityGetTransform( entity_id )

--local dir_x, dir_y = vec_normalize( p_x - e_x, p_y - e_y )
--local dir_x, dir_y = 

for i = 1, SPAWN_AMOUNT do
    local rdir_x, rdir_y = vec_rotate( 0, 1, Random( -22.5, 22.5 ) )
    local speed = Random( 400, 700 )
    shoot_projectile( entity_id, "mods/cheytaq_first_mod/files/entities/projectiles/banana_bomb_super.xml", e_x, e_y, rdir_x * speed, rdir_y * speed)
end
