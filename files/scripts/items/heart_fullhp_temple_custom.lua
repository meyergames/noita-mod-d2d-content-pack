dofile_once("data/scripts/lib/utilities.lua")

local old_item_pickup = item_pickup

item_pickup = function( entity_item, entity_who_picked, name )
    EntityRemoveIngestionStatusEffect( entity_who_picked, "VIRAL_INFECTION" )
    old_item_pickup( entity_item, entity_who_picked, name )

--	local deepest_hm = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_DEPTH", "0" ) )
--    GamePrint( "Deepest Holy Mountain: " .. deepest_hm )
--
--    local hm_visits = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )
--    GamePrint( "Holy Mountains visited: " .. hm_visits )
end
