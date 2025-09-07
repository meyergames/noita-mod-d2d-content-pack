dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local targets = EntityGetInRadiusWithTag( x, y, 500, "homing_target" )
if ( #targets > 0 ) then
    for i,target_id in ipairs(targets) do
        local target_x, target_y = EntityGetTransform( target_id )
        local target_is_far_away = distance_between( entity_id, target_id ) > 300
        local effect_id = getInternalVariableValue( target_id, "feline_affection_tried_to_spawn_cat", "value_int" )

        if target_is_far_away and effect_id == nil then
            addNewInternalVariable( target_id, "feline_affection_tried_to_spawn_cat", "value_int", 1 )
            if Random( 0, math.max( 25 - ( 5 * get_perk_pickup_count( "D2D_FELINE_AFFECTION" ) ), 5 ) ) == 0 then
                local cat_id = spawn_random_cat( target_x, target_y )
                EntityAddTag( cat_id, "cat" )
                set_internal_int( cat_id, "is_spawned_through_feline_affection", 1 )
                -- EntityLoad( "mods/Apotheosis/files/entities/special/conjurer_cat_spawner.xml", target_x, target_y )
            end
        end
    end
end

-- find cats to give the "cat" tag, including those spawned through other means (e.g. Spells To Cats)
local cats = EntityGetInRadiusWithTag( x, y, 500, "helpless_animal" )
if ( #cats > 0 ) then
    for i,cat in ipairs( cats ) do
        if string.find( EntityGetName(cat), "cat_" ) then
            EntityAddTag( cat, "cat" )
        end
    end
end
