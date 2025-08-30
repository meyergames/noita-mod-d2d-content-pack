dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )


local mana_charge_speed_mtp = getInternalVariableValue( owner, "master_of_thunder_mana_charge_speed_mtp", "value_int" )
if ( mana_charge_speed_mtp == 0 ) then return end
-- local mana_charge_speed_mtp = 100 -- equals +100% i.e. x2

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

                    ComponentSetValue2( ac_id, "mana", math.max( mana + ( mana_charge_speed * ( mana_charge_speed_mtp * 0.01 ) / 60 ), 0 ) )
                end 
            end 
        end 
        break 
    end 
end
