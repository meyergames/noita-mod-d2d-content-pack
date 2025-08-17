local rand = Random( 0, 100 )
if( rand < 40 ) then -- 40%
    add_projectile("data/entities/projectiles/deck/tnt.xml")
    c.fire_rate_wait = c.fire_rate_wait + 50
    c.spread_degrees = c.spread_degrees + 6.0
elseif( rand < 65 ) then -- 25%
    add_projectile("data/entities/projectiles/bomb.xml")
    c.fire_rate_wait = c.fire_rate_wait + 100
elseif( rand < 80 ) then -- 15%
    add_projectile("mods/RiskRewardBundle/files/entities/projectiles/banana_bomb.xml", 1)
    c.fire_rate_wait = c.fire_rate_wait + 50
    c.spread_degrees = c.spread_degrees + 6.0
elseif( rand < 90 ) then -- 10%
    add_projectile("data/entities/projectiles/deck/glitter_bomb.xml")
    c.fire_rate_wait = c.fire_rate_wait + 50
    c.spread_degrees = c.spread_degrees + 12.0
elseif( rand < 95 ) then -- 5%
    add_projectile("mods/RiskRewardBundle/files/entities/projectiles/bomb_dud.xml", 1)
    c.fire_rate_wait = c.fire_rate_wait + 100
elseif( rand < 99 ) then -- 4%
    add_projectile("mods/RiskRewardBundle/files/entities/projectiles/banana_bomb_super.xml", 1)
    c.fire_rate_wait = c.fire_rate_wait + 50
    c.spread_degrees = c.spread_degrees + 6.0
else
    add_projectile("data/entities/projectiles/bomb_holy.xml")
    current_reload_time = current_reload_time + 80
    shot_effects.recoil_knockback = shot_effects.recoil_knockback + 100.0
    c.fire_rate_wait = c.fire_rate_wait + 40
end
