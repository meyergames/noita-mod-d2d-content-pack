dofile_once( "data/scripts/lib/utilities.lua" )

local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
local wand = EZWand(EntityGetParent(entity_id))
local x, y = EntityGetTransform(entity_id)
local controlscomp = EntityGetFirstComponent(root, "ControlsComponent")
local cooldown_frames = 60
local actionid = "action_d2d_mid_fire_blink"
local cooldown_frame
local variablecomp = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
cooldown_frame = ComponentGetValue2( variablecomp, "value_int" )
local aim_x, aim_y = ComponentGetValue2(controlscomp, "mAimingVectorNormalized")
local manacost = 80

if GameGetFrameNum() >= cooldown_frame then
    if InputIsMouseButtonDown( 3 ) then -- is the right mouse button pressed?
        local mana = wand.mana
        if (mana > manacost) then
            GameShootProjectile(root, x+aim_x*12, y+aim_y*12, x+aim_x*20, y+aim_y*20, EntityLoad("mods/D2DContentPack/files/entities/projectiles/deck/blink.xml", x, y))
            wand.mana = mana - manacost
            ComponentSetValue2( variablecomp, "value_int", GameGetFrameNum() + cooldown_frames )
            if HasFlagPersistent(actionid) == false then
                GameAddFlagRun(table.concat({"new_",actionid}))
                AddFlagPersistent(actionid)
            end
                if ModIsEnabled("quant.ew") then
                    CrossCall("d2d_ew_alt_fire", root, x, y, aim_x, aim_y, "mods/D2DContentPack/files/entities/projectiles/deck/blink.xml")
                end
        else
            GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/out_of_mana", x, y );
        end
    end
end