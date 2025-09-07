if not ModIsEnabled( "Apotheosis" ) then return end

dofile_once( "data/scripts/lib/utilities.lua" )

local x, y = EntityGetTransform( GetUpdatedEntityID() )

local spawns_left = 5
while spawns_left > 0 do
    local spawn_x = x + Random( -8, 8 )
    local spawn_y = y + Random( -8, 8 )
    local folder = "animals/"
    -- if ModSettingGet( "Apotheosis.fairy_immortality" ) then folder = "animals/cat_immortal/" end
    -- -- ^ 10 x 5 immortal fairies could be way too OP

    local fairy_id = EntityLoad( "mods/Apotheosis/data/entities/" .. folder .. "fairy_cheap.xml", spawn_x, spawn_y )
    EntityAddTag( fairy_id, "fairy" )
    spawns_left = spawns_left - 1
end