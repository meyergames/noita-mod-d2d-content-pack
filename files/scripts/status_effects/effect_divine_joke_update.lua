dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local x, y = EntityGetTransform( owner )

local rounded_x = math.floor( x + 0.5 )
local rounded_y = math.floor( y + 0.5 )
local prev_x = math.floor( getInternalVariableValue( owner, "divine_joke_prev_x", "value_int" ) + 0.5 )
local prev_y = math.floor( getInternalVariableValue( owner, "divine_joke_prev_y", "value_int" ) + 0.5 )
setInternalVariableValue( owner, "divine_joke_prev_x", "value_int", rounded_x )
setInternalVariableValue( owner, "divine_joke_prev_y", "value_int", rounded_y )

if( rounded_x == prev_x and rounded_y == prev_y ) then
    local prev_still_counter = getInternalVariableValue( owner, "divine_joke_still_counter", "value_int" )
    local new_still_counter = prev_still_counter + 1
    setInternalVariableValue( owner, "divine_joke_still_counter", "value_int", new_still_counter )

    if( new_still_counter >= 10 ) then
        LoadGameEffectEntityTo( owner, "data/entities/misc/effect_polymorph.xml" )
        setInternalVariableValue( owner, "divine_joke_still_counter", "value_int", 0 )

        GamePrint("The gods chuckle as they totally prank you.")
    end
else
    setInternalVariableValue( owner, "divine_joke_still_counter", "value_int", 0 )
end
