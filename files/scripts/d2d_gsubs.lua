
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

alter_wand_of_destruction()
alter_contact_damage()