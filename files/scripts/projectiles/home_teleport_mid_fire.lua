dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
local wand = EZWand(EntityGetParent(entity_id))
local x, y = EntityGetTransform(entity_id)
local controlscomp = EntityGetFirstComponent(root, "ControlsComponent")
local cooldown_frames = 1800 -- 30s cooldown
local variablecomp = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
local cooldown_frame = ComponentGetValue2( variablecomp, "value_int" )
local aim_x, aim_y = ComponentGetValue2(controlscomp, "mAimingVectorNormalized")

if is_mid_fire_pressed() then
    if GameGetFrameNum() >= cooldown_frame then
        local target_x = x + ( aim_x * 50 )
        local target_y = y + ( aim_y * 50 )
        EntityLoad( "mods/D2DContentPack/files/entities/misc/portal_ring_of_returning.xml", target_x, target_y )

        -- induce costs
        ComponentSetValue2( variablecomp, "value_int", GameGetFrameNum() + cooldown_frames )
    else
        GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/out_of_mana", x, y )
        GamePrint( "Home Teleport is on cooldown for " .. string.format( "%.0f", math.ceil( ( cooldown_frame - GameGetFrameNum() ) / 60 ) ) .. " more seconds" )
    end
end
