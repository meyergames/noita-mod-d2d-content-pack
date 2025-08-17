dofile_once( "data/scripts/lib/utilities.lua" );

local EFFECT_DURATION = 90

local player = get_player()

function damage_received( damage, desc, entity_who_caused, is_fatal )
    GamePrint("Damage taken!")
--	if entity_who_caused == entity or entity_who_caused == EntityGetParent( entity ) or entity_who_caused == NULL_ENTITY or damage <= 0 then return; end
--    local now = GameGetFrameNum();
--	if now - EntityGetVariableNumber( entity, "gkbrkn_rexplosion_last_proc", 0 ) < 5 then return; end
    
    setInternalVariableValue( player, "player_energizer_timer", "value_int", EFFECT_DURATION )
    if( energizer_timer == 0 ) then
        local effect_id = EntityAddComponent( player, "ShotEffectComponent", { extra_modifier = "ctq_thunderlord_boost" } )
        setInternalVariableValue( player, "energizer_comp_id", "value_int", effect_id )
    end
end

local var = getInternalVariableValue( player, "player_energizer_timer", "value_int")
if ( var ~= nil and var > 0 ) then
    GamePrint("Remaining time: " .. var)
    setInternalVariableValue( player, "player_energizer_timer", var - 10 )

    local updated_value = getInternalVariableValue( player, "player_energizer_timer", "value_int")
    if ( updated_value <= 0 )
        EntityRemoveComponent( player, getInternalVariableValue( player, "energizer_comp_id", "value_int" ) )
    end
end
