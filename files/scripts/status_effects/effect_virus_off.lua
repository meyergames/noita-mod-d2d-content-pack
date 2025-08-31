dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent(entity_id)

reset_move_speed( owner, "viral_infection" )


if ( owner ~= nil ) and ( owner ~= NULL_ENTITY ) and EntityGetIsAlive( owner ) then
    local damagemodel = EntityGetFirstComponentIncludingDisabled( owner, "DamageModelComponent")
	ComponentObjectSetValue2( damagemodel, "damage_multipliers", "healing", 1.0 )

    local var_store_pos = get_variable_storage_component( owner, "player_start_pos" )
    local stored_values = ComponentGetValue2(var_store_pos, "value_string")
    if stored_values then
        local properties = split_string(stored_values, ",")
        local start_x = tonumber(properties[1])
        local start_y = tonumber(properties[2])

        local end_x, end_y = EntityGetTransform( owner )
        local dist = get_distance( start_x, start_y, end_x, end_y )
        -- if ( end_y > start_y and dist > 1000 ) then
    
            --skip the health increase, now that the Time Trial perk exists
--            local hp = ComponentGetValue2( damagemodel, "hp" )
--            local old_max_hp = ComponentGetValue2( damagemodel, "max_hp" )
--            local new_max_hp = old_max_hp * (1.0 + (end_y * 0.0001))
--            ComponentSetValue( damagemodel, "max_hp", new_max_hp )
--            ComponentSetValue( damagemodel, "hp", new_max_hp )
--
--            GamePrint("The gods admire your speed. Max health increased from " .. (old_max_hp * 25) .. " to " .. (new_max_hp * 25))
--            GamePrintImportant( "The gods admire your speed", "You have been rewarded with extra max health" )

    --                if ( end_y > 10000 ) then
    --                    GamePrintImportant("The gods admire your insanity", "You have been rewarded with tons of extra health")
    --                elseif ( end_y > 6000 ) then
    --                    GamePrintImportant("The gods admire your courage", "You have been rewarded with lots of extra health")
    --                else
    --                    GamePrintImportant("The gods admire your speed", "You have been rewarded with extra health")
    --                end
        -- else
        -- GamePrintImportant("The virus has been cured", "Though traces of it remain...")
        -- end

        --remove the variable storage component
        EntityRemoveComponent( owner, var_store_pos )
    end

    local viruses_cured = GlobalsGetValue( "viruses_half_cured", 0 )
    GlobalsSetValue( "viruses_half_cured", viruses_cured + 1 )
    EntityIngestMaterial( owner, CellFactory_GetType("magic_liquid_infected_healthium_weak"), 1)
end

--finally, remove this status effect
--EntityRemoveComponent( owner, entity_id )
