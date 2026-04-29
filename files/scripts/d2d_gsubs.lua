
local function esc( str )
    return str:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

local function alter_wand_of_destruction()
    -- add unique tag to the wand
    local file = "data/entities/items/wands/wand_good/wand_good_2.xml"
    local content = ModTextFileGetContent( file )
    content = content:gsub( "wand,wand_good", "wand,wand_good,d2d_wand_of_destruction" )
    ModTextFileSetContent( file, content )

    -- make the wand hold Unstable Nucleus
    file = "data/entities/items/wands/wand_good/wand_good_2.lua"
    content = ModTextFileGetContent( file )
    content = content:gsub(
        "gun.mana_max = ",
        "gun.mana_max = {3200,3500} -- old: " )
    content = content:gsub(
        "gun.mana_charge_speed = ",
        "gun.mana_charge_speed = {45,58} -- old: " ) -- i.e. about 1 minute for full mana
    content = content:gsub(
        "gun.reload_time = ",
        "gun.reload_time = 597 -- old: " ) -- i.e. 9.95s
    content = content:gsub(
        "gun.deck_capacity = ",
        "gun.deck_capacity = 10 -- old: " ) -- i.e. 10 capacity
    content = content:gsub(
        "local action_count = 4",
        "local action_count = 0" ) -- i.e. no spells
    content = content:gsub(
        "NUKE",
        "D2D_UNSTABLE_NUCLEUS" )
    ModTextFileSetContent( file, content )
end

local function alter_contact_damage()
    -- prevent Contact Damage from damaging allies
    local file = "data/scripts/perks/contact_damage.lua"
    local content = ModTextFileGetContent( file )
    content = content:gsub(
        esc( "if ( entity_id ~= root_id ) then" ),
        esc( "if entity_id ~= root_id and not GameGetGameEffect( entity_id, \"CHARM\" ) then" ) )
    ModTextFileSetContent( file, content )
end

local function add_delta_drop_to_ylialkemisti()
    local file = "data/entities/animals/boss_alchemist/death.lua"
    local content = ModTextFileGetContent( file )
    content = content:gsub(
        esc( "local opts = {" ),
        esc( "local opts = { \"D2D_DELTA\" }" ) )
    ModTextFileSetContent( file, content )
end

local function alter_apotheosis_portals()
    if not ModIsEnabled( "Apotheosis" ) then return end



    -- make the red portal stay after use
    local file = "mods/Apotheosis/files/entities/projectiles/deck/markerportals/portal_red_portal.xml"
    local content = ModTextFileGetContent( file )
    content = content:gsub(
        esc( "lukki_portal" ),
        esc( "lukki_portal\" tags=\"lukki_portal_red" ) )
    content = content:gsub(
        esc( "lifetime=\"600\"" ),
        esc( "lifetime=\"-1\"" ) )
    ModTextFileSetContent( file, content )

    file = "mods/Apotheosis/files/scripts/magic/markerportals/portal_use_red.lua"
    content = ModTextFileGetContent( file )
    content = content:gsub(
        esc( "EntityKill( entity_id )" ),
        esc( "-- EntityKill( entity_id )" ) )
    ModTextFileSetContent( file, content )



    -- green too
    file = "mods/Apotheosis/files/entities/projectiles/deck/markerportals/portal_green_portal.xml"
    content = ModTextFileGetContent( file )
    content = content:gsub(
        esc( "lukki_portal" ),
        esc( "lukki_portal\" tags=\"lukki_portal_green" ) )
    content = content:gsub(
        esc( "lifetime=\"600\"" ),
        esc( "lifetime=\"-1\"" ) )
    ModTextFileSetContent( file, content )

    file = "mods/Apotheosis/files/scripts/magic/markerportals/portal_use_green.lua"
    content = ModTextFileGetContent( file )
    content = content:gsub(
        esc( "EntityKill( entity_id )" ),
        esc( "-- EntityKill( entity_id )" ) )
    ModTextFileSetContent( file, content )



    -- blue too
    file = "mods/Apotheosis/files/entities/projectiles/deck/markerportals/portal_blue_portal.xml"
    content = ModTextFileGetContent( file )
    content = content:gsub(
        "lukki_portal",
        "lukki_portal\" tags=\"lukki_portal_blue" )
    content = content:gsub(
        esc( "lifetime=\"600\"" ),
        esc( "lifetime=\"-1\"" ) )
    ModTextFileSetContent( file, content )

    file = "mods/Apotheosis/files/scripts/magic/markerportals/portal_use_blue.lua"
    content = ModTextFileGetContent( file )
    content = content:gsub(
        esc( "EntityKill( entity_id )" ),
        esc( "-- EntityKill( entity_id )" ) )
    ModTextFileSetContent( file, content )

end

local function alter_fireball()
    -- it's supposed to be a *FIRE*ball, for pete's sake!!(!)
    local file = "data/entities/projectiles/deck/fireball.xml"
    local content = ModTextFileGetContent( file )
    content = content:gsub(
        "speed_min=\"160\"",
        "speed_min=\"270\"" )
    content = content:gsub(
        "speed_max=\"170\"",
        "speed_max=\"300\"" )
    content = content:gsub(
        "fire=\"0.25\"",
        "fire=\"2.5\"" )
    content = content:gsub(
        "damage=\"2\"",
        "damage=\"1\"" )
    content = content:gsub(
        "explosion_radius=\"15\"",
        "explosion_radius=\"30\"" )
    ModTextFileSetContent( file, content )
end

alter_wand_of_destruction()
alter_contact_damage()
add_delta_drop_to_ylialkemisti()
alter_apotheosis_portals()
alter_fireball()
