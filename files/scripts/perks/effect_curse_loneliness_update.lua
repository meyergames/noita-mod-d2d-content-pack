dofile_once( "data/scripts/lib/utilities.lua" )

local EFFECT_RADIUS_DETECT = 100

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local x, y = EntityGetTransform( owner )



local nearby_enemies = EntityGetInRadiusWithTag( x, y, EFFECT_RADIUS_DETECT, "mortal" )
if( #nearby_enemies == 1 ) then -- the player counts as an enemy...
    local prev_loneliness_value = getInternalVariableValue( owner, "loneliness_counter", "value_int" )
    local new_loneliness_value = prev_loneliness_value + 1
    setInternalVariableValue( owner, "loneliness_counter", "value_int", new_loneliness_value )
    GamePrint( "entity count: " .. #nearby_enemies .. " (" .. new_loneliness_value .. ")" )

    if( new_loneliness_value == 30 ) then
        GamePrint("You are starting to feel lonely...")
    end
    if( new_loneliness_value >= 30 and new_loneliness_value % 2 == 0 ) then
        local dcomp = EntityGetFirstComponentIncludingDisabled( owner, "DamageModelComponent" )
        local hp = ComponentGetValue2( dcomp, "hp" )
        local max_hp = ComponentGetValue2( dcomp, "max_hp" )

        EntityInflictDamage( owner, max_hp * 0.01, "NONE", "loneliness", "NONE", 0, 0, owner, x, y, 0 )
    end
else
    setInternalVariableValue( owner, "loneliness_counter", "value_int", 0 )
end


-- old code, which polymorphs the player after they stand still for 10 seconds
-- if( rounded_x == prev_x and rounded_y == prev_y and Random( 0, 1 ) == 1 ) then
--     local prev_still_counter = getInternalVariableValue( owner, "divine_joke_still_counter", "value_int" )
--     local new_still_counter = prev_still_counter + 1
--     setInternalVariableValue( owner, "divine_joke_still_counter", "value_int", new_still_counter )

--     if( new_still_counter >= 10 and #enemies == 0 ) then
--         LoadGameEffectEntityTo( owner, "data/entities/misc/effect_polymorph.xml" )
--         setInternalVariableValue( owner, "divine_joke_still_counter", "value_int", 0 )

--         GamePrint("The gods chuckle as they totally prank you.")
--         setInternalVariableValue( owner, "divine_joke_cooldown_time", "value_int", 120 )
--     end
-- else
--     setInternalVariableValue( owner, "divine_joke_still_counter", "value_int", 0 )
-- end
