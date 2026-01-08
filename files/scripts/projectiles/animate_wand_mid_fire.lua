dofile_once( "data/scripts/lib/utilities.lua" )

local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
local wand = EZWand(EntityGetParent(entity_id))
local x, y = EntityGetTransform(entity_id)
local controlscomp = EntityGetFirstComponent(root, "ControlsComponent")
local cooldown_frames = 3600 * 5 -- 5 minute cooldown
local actionid = "action_d2d_animate_wand_mid_fire"
local cooldown_frame
local variablecomp = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
cooldown_frame = ComponentGetValue2( variablecomp, "value_int" )
local aim_x, aim_y = ComponentGetValue2(controlscomp, "mAimingVectorNormalized")
local manacost = 100

if GameGetFrameNum() >= cooldown_frame then
    if InputIsMouseButtonDown( 3 ) then -- is the middle mouse button pressed?
        local mana = wand.mana
        if ( mana >= manacost ) then
            wand.mana = mana - manacost
            ComponentSetValue2( variablecomp, "value_int", GameGetFrameNum() + cooldown_frames )

            -- remove the wand from the player's hand, and spawn a ghost to pick it up
            local ghost = EntityLoad( "mods/D2DContentPack/files/entities/animals/wand_ghost_loyalty.xml", x, y )
            wand:PlaceAt( x, y )
            wand:GiveTo( ghost )
            EntityLoad( "data/entities/particles/image_emitters/wand_effect.xml", x, y )

            -- entangled worlds stuff (?)
            if HasFlagPersistent(actionid) == false then
                GameAddFlagRun(table.concat({"new_",actionid}))
                AddFlagPersistent(actionid)
            end
                if ModIsEnabled("quant.ew") then
                    CrossCall( "d2d_ew_alt_fire", root, x, y, aim_x, aim_y, "mods/D2DContentPack/files/entities/projectiles/deck/blink.xml" )
                end
        else
            GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/out_of_mana", x, y )
        end
    end
elseif InputIsMouseButtonJustUp( 3 ) and ( cooldown_frame - GameGetFrameNum() ) > 120 then
    GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/out_of_mana", x, y )
    GamePrint( "'Mid Fire Animate' is on cooldown for " .. string.format( "%.0f", ( cooldown_frame - GameGetFrameNum() ) / 60 ) .. " more seconds" )
end
