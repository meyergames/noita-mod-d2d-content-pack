dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity( entity_id )
local x, y = EntityGetTransform( owner )

local function is_slotted_in_wand()
    local children = EntityGetAllChildren( owner )
    for k=1,#children do
        child = children[k]
        if EntityGetName( child ) == "inventory_quick" then
            local inventory_items = EntityGetAllChildren(child)
            if( inventory_items ~= nil ) then 
                for z=1, #inventory_items do
                    item = inventory_items[z]

                    local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
                    if EZWand.IsWand( item ) then
                        local wand = EZWand( item )
                        local spells, attached_spells = wand:GetSpells()
                        for i,spell in ipairs( spells ) do
                            if spell.action_id == "D2D_REWIND" or spell.action_id == "D2D_REWIND_ALT_FIRE" then
                                return true
                            end
                        end
                        for i,spell in ipairs( attached_spells ) do
                            if spell.action_id == "D2D_REWIND" or spell.action_id == "D2D_REWIND_ALT_FIRE" then
                                return true
                            end
                        end
                    end
                end 
            end
        end
    end
    return false
end



local platcomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterPlatformingComponent" )
local frames_in_air = ComponentGetValue2( platcomp, "mFramesInAirCounter" )

local controls = EntityGetFirstComponent( owner, "ControlsComponent" )
local is_fly_pressed = ComponentGetValue2( controls, "mButtonDownFly" )

local marker_id = get_internal_int( owner, "rewind_marker_id" )
if frames_in_air == 0 then
    if marker_id ~= nil and marker_id ~= -1 then
        EntityKill( marker_id )
        set_internal_int( get_player(), "rewind_marker_id", -1 )
    end
elseif is_fly_pressed and frames_in_air == 1 and is_slotted_in_wand() then
    GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/teleport/create", x, y )

    if marker_id ~= nil and marker_id ~= -1 then
        EntitySetTransform( marker_id, x, y )
    else
        marker_id = EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/rewind_marker.xml", x, y )
        set_internal_int( owner, "rewind_marker_id", marker_id )
    end
end