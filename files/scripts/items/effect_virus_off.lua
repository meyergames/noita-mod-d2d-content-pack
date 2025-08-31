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
        -- if ( EntityGetIsAlive( owner ) ) then
        --     GamePrintImportant("The virus has been cured", "Though traces of it remain...")
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
