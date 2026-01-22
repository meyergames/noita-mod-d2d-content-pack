dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local CATCH_RADIUS = 15
-- local CATCH_RADIUS_T2 = 70

local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
local wand = EZWand(EntityGetParent(entity_id))
local x, y = EntityGetTransform(entity_id)
local controlscomp = EntityGetFirstComponent(root, "ControlsComponent")
local cooldown_frames = 1800 -- 30s cooldown
local actionid = "action_d2d_animate_wand_mid_fire"
local cooldown_frame
local variablecomp = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
cooldown_frame = ComponentGetValue2( variablecomp, "value_int" )
local aim_x, aim_y = ComponentGetValue2(controlscomp, "mAimingVectorNormalized")
local manacost = 0

-- start on cooldown, since everytime the staff is called back it gets a new copy of the spell
if cooldown_frame == 0 then
    ComponentSetValue2( variablecomp, "value_int", GameGetFrameNum() + cooldown_frames )
end

if is_mid_fire_pressed() then
    local mana = wand.mana
    if ( mana >= manacost ) then
        local staff_tier = get_internal_int( wand.entity_id, "d2d_staff_tier" )

        local is_animated = get_internal_bool( wand.entity_id, "d2d_staff_of_loyalty_is_animated" )
        if is_animated then
            local dist = distance_between( get_player(), wand.entity_id )
            if dist < CATCH_RADIUS then
                -- if the wand is already out, clone the wand and give it to the player
                local clone = wand:Clone()
                clone:PutInPlayersInventory()
                EntityAddTag( clone.entity_id, "d2d_staff_of_loyalty" )
                set_internal_int( clone.entity_id, "d2d_staff_tier", staff_tier )
                set_internal_bool( clone.entity_id, "d2d_staff_of_loyalty_is_animated", false )

                -- kill the ghost
                local ghost = EntityGetRootEntity( wand.entity_id )
                local gx, gy = EntityGetTransform( ghost )
                EntityKill( ghost )

                -- sfx/vfx for feedback
                EntityLoad( "mods/D2DContentPack/files/particles/tele_particles.xml", gx, gy )
                GamePlaySound( "data/audio/Desktop/ui.bank", "ui/item_move_success", x, y )
            else
                GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/out_of_mana", x, y )
                GamePrint( "The staff is too far away!" )
            end

        elseif GameGetFrameNum() >= cooldown_frame then

            -- if it is not, remove the wand from the player's hand, and spawn a ghost to pick it up
            local ghost = EntityLoad( "mods/D2DContentPack/files/entities/animals/wand_ghost_loyalty.xml", x, y )
            wand:PlaceAt( x, y )
            wand:GiveTo( ghost )

            -- if the staff is evolved, charm it too
            if staff_tier == 2 then
                GetGameEffectLoadTo( fairy_id, "CHARM", false )
            end

            EntityLoad( "data/entities/particles/image_emitters/wand_effect.xml", x, y )
            set_internal_bool( wand.entity_id, "d2d_staff_of_loyalty_is_animated", true )

            -- induce costs
            ComponentSetValue2( variablecomp, "value_int", GameGetFrameNum() + cooldown_frames )
            wand.mana = mana - manacost

        else

            GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/out_of_mana", x, y )
            GamePrint( "You can animate the staff again in " .. string.format( "%.0f", math.ceil( ( cooldown_frame - GameGetFrameNum() ) / 60 ) ) .. " seconds" )

        end

        -- entangled worlds stuff (?)
        if HasFlagPersistent(actionid) == false then
            GameAddFlagRun(table.concat({"new_",actionid}))
            AddFlagPersistent(actionid)
        end
        if ModIsEnabled("quant.ew") then
            CrossCall( "d2d_ew_alt_fire", root, x, y, aim_x, aim_y, "mods/D2DContentPack/files/entities/projectiles/deck/blink.xml" )
        end
    end
end
