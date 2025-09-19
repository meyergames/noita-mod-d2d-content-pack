dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
    local entity_id    = GetUpdatedEntityID()
    local enemy        = entity_id
    local pos_x, pos_y = EntityGetTransform( enemy )

    SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

    if ModIsEnabled( "Apotheosis" ) then
        local dcomp = EntityGetFirstComponentIncludingDisabled( enemy, "DamageModelComponent" )
        local max_hp = ComponentGetValue2( dcomp, "max_hp" )

        local fairy_spawn_amt = math.min( math.max( math.ceil( max_hp * 0.5 ), 1 ), 10 )

        local spawns_left = fairy_spawn_amt
        local big_fairy_spawned = false
        while spawns_left > 0 do
            local spawn_pos_var = ( fairy_spawn_amt - 1 ) * 2
            local spawn_x = pos_x + Random( -spawn_pos_var, spawn_pos_var )
            local spawn_y = pos_y + Random( -spawn_pos_var, spawn_pos_var )

            if not big_fairy_spawned and spawns_left >= 4 and Random( 0, 10 ) == 0 then
                local fairy_id = EntityLoad( "mods/Apotheosis/data/entities/animals/fairy_big.xml", spawn_x, spawn_y )
                GetGameEffectLoadTo( fairy_id, "CHARM", false )
                EntityAddTag( fairy_id, "fairy" )
                spawns_left = spawns_left - 4
                big_fairy_spawned = true
            else
                local folder = "animals/cat_immortal/"
                -- if not ModSettingGet( "Apotheosis.fairy_immortality" ) then folder = "animals/" end
                -- -- ^ mortal fairy spawns often end up dead within seconds (fire etc)

                local fairy_id = EntityLoad( "mods/Apotheosis/data/entities/" .. folder .. "fairy_cheap.xml", spawn_x, spawn_y )
                EntityAddTag( fairy_id, "fairy" )
                spawns_left = spawns_left - 1
            end

            -- raise_internal_int( get_player(), "player_fairies_spawned", 1 )  
            -- local fairies_rescued = get_internal_int( get_player(), "player_fairies_spawned" )
        end
    end
end