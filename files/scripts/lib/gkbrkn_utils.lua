
function WandGetActiveOrRandom( entity )
    local chosen_wand = nil
    local wands = {}
    local children = EntityGetAllChildren( entity )  or {}
    for key, child in pairs( children ) do
        if EntityGetName( child ) == "inventory_quick" then
            wands = EntityGetChildrenWithTag( child, "wand" )
            break
        end
    end
    if #wands > 0 then
        local inventory2 = EntityGetFirstComponent( entity, "Inventory2Component" )
        local active_item = ComponentGetValue2( inventory2, "mActiveItem" )
        for _,wand in pairs( wands ) do
            if wand == active_item then
                chosen_wand = wand
                break
            end
        end
        if chosen_wand == nil then
            chosen_wand =  random_from_array( wands )
        end
        return chosen_wand
    end
end
