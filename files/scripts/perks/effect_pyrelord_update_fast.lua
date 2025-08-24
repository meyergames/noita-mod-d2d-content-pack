dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )

-- function recharge_mana( mtp ) -- mtp 1.0 = normal, mtp 1.5 = +50%, etc
local children = EntityGetAllChildren( owner )
for k=1,#children
do child = children[k]
    if EntityGetName( child ) == "inventory_quick" then 
        local inventory_items = EntityGetAllChildren(child) 
        if(inventory_items ~= nil) then 
            for z=1,#inventory_items
            do item = inventory_items[z]
                if EntityHasTag( item, "wand" ) then 
                    local ac_id = EntityGetFirstComponentIncludingDisabled( item, "AbilityComponent" )   
                    local mana = ComponentGetValue2( ac_id, "mana" )  
                    local mana_charge_speed = ComponentGetValue2( ac_id, "mana_charge_speed" )
                    local mtp = getInternalVariableValue( owner, "pyrelord_mana_charge_speed_mtp", "value_int" )

                    ComponentSetValue2( ac_id, "mana", math.max( mana + ( mana_charge_speed * ( mtp * 0.01 ) / 60 ), 0 ) )
                end 
            end 
        end 
        break 
    end 
end
-- end
