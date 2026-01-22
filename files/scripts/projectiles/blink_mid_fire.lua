dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
local wand = EZWand(EntityGetParent(entity_id))
local x, y = EntityGetTransform(entity_id)
local controlscomp = EntityGetFirstComponent(root, "ControlsComponent")
local cooldown_frames = 60
local actionid = "action_d2d_blink_mid_fire"
local cooldown_frame
local variablecomp = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
cooldown_frame = ComponentGetValue2( variablecomp, "value_int" )
local aim_x, aim_y = ComponentGetValue2(controlscomp, "mAimingVectorNormalized")
local manacost = 200

local uses_remaining = -1
local icomp = EntityGetFirstComponentIncludingDisabled( entity_id, "ItemComponent" )
if ( icomp ~= nil ) then
    uses_remaining = ComponentGetValue2( icomp, "uses_remaining" )
end
local is_always_cast = ComponentGetValue2( icomp,"permanently_attached" )

if GameGetFrameNum() >= cooldown_frame then
    if is_mid_fire_pressed() then
        local mana = wand.mana
        if ( mana >= manacost and ( uses_remaining ~= 0 or is_always_cast ) ) then
            wand.mana = mana - manacost
            ComponentSetValue2( variablecomp, "value_int", GameGetFrameNum() + cooldown_frames )

            -- teleport the player
            GameShootProjectile(root, x+aim_x*12, y+aim_y*12, x+aim_x*20, y+aim_y*20, EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/blink.xml", x, y ) )

            -- deal damage (cannot kill)
			local p_dcomp = EntityGetFirstComponentIncludingDisabled( root, "DamageModelComponent" )
			local p_hp = ComponentGetValue2( p_dcomp, "hp" )
			local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )

            dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )
            local mtp = determine_blink_dmg_mtp()
            EntityInflictDamage( root, math.min( p_max_hp * mtp, p_hp - 0.04 ), "DAMAGE_SLICE", "experimental teleportation", "NONE", 0, 0, root, x, y, 0)
            
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
end