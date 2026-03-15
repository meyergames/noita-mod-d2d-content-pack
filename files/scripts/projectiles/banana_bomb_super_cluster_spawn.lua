dofile( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local SPAWN_AMOUNT = 5

local entity_id = GetUpdatedEntityID()
local e_x, e_y = EntityGetTransform( entity_id )

--local dir_x, dir_y = vec_normalize( p_x - e_x, p_y - e_y )
--local dir_x, dir_y = 

for i = 1, SPAWN_AMOUNT do
    local rdir_x, rdir_y = vec_rotate( 0, 1, Random( -22.5, 22.5 ) )
    local speed = Random( 300, 525 )

    local cluster_entity_id = EntityLoad( "mods/D2DContentPack/files/entities/projectiles/banana_bomb.xml" )
    GameShootProjectile( entity_id, e_x, e_y, rdir_x * speed, rdir_y * speed, cluster_entity_id )

    if any_wand_contains_spell( get_player(), "D2D_BANANA_BOMB_ENHANCER" ) then
        EntityAddComponent2( cluster_entity_id, "LuaComponent", 
        {
            script_source_file = "mods/D2DContentPack/files/scripts/projectiles/banana_bomb_spawn_heal_aura.lua",
            execute_every_n_frame = -1,
            execute_on_removed = true,
        } )
    end
end
