dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local ox, oy = EntityGetTransform( GetUpdatedEntityID() )
local mx, my = DEBUG_GetMouseWorld()
local dist = get_distance( ox, oy, mx, my )

local dir_x = mx - ox
local dir_y = my - oy
-- dir_x,dir_y = vec_normalize(dir_x,dir_y)

local filename

local rand = Random( 0, 1000 )
if( rand < 250 ) then -- 25%
    filename = "data/entities/projectiles/bomb.xml"
elseif( rand < 400 ) then -- 15%
    filename = "mods/D2DContentPack/files/entities/projectiles/banana_bomb.xml"
elseif( rand < 500 ) then -- 10% (1/10)
    filename = "data/entities/projectiles/deck/glitter_bomb.xml"
elseif( rand < 550 ) then -- 5% (1/20)
    filename = "mods/D2DContentPack/files/entities/projectiles/bomb_dud.xml"
elseif( rand < 570 ) then -- 2% (1/50)
    filename = "mods/D2DContentPack/files/entities/projectiles/banana_bomb_super.xml"
elseif( rand < 580 ) then -- 1% (1/100)
    filename = "data/entities/projectiles/bomb_holy.xml"
elseif( rand < 585 ) then -- 0.5% (1/200)
    filename = "mods/D2DContentPack/files/entities/projectiles/banana_bomb_giga.xml"
elseif( rand < 590 ) then -- 0.5% (1/200)
    filename = "data/entities/projectiles/propane_tank.xml"
else -- about 41%
    filename = "data/entities/projectiles/deck/tnt.xml"
end

shoot_projectile( entity_id, filename, ox, oy, dir_x, dir_y )