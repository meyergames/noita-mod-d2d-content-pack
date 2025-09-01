-- REQUIRES APOTHEOSIS MOD INSTALLED

dofile_once("mods/Apotheosis/lib/apotheosis/apotheosis_utils.lua")
local EZWand = dofile_once("mods/Apotheosis/lib/EZWand/EZWand.lua")
local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
local wand = EZWand(EntityGetParent(entity_id))
local x, y = EntityGetTransform(entity_id)
local controlscomp = EntityGetFirstComponent(root, "ControlsComponent")
local cooldown_frames = 40
local actionid = "action_d2d_alt_fire_concrete_wall"
local cooldown_frame
local variablecomp = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
cooldown_frame = ComponentGetValue2( variablecomp, "value_int" )
local aim_x, aim_y = ComponentGetValue2(controlscomp, "mAimingVectorNormalized")
local manacost = 80

local uses_remaining = -1
local icomp = EntityGetFirstComponentIncludingDisabled( entity_id, "ItemComponent" )
if ( icomp ~= nil ) then
    uses_remaining = ComponentGetValue2( icomp, "uses_remaining" )
end
local is_always_cast = ComponentGetValue2( icomp,"permanently_attached" )

if GameGetFrameNum() >= cooldown_frame then
    if isButtonDown_AltFire() then
        local mana = wand.mana
        if ( mana > manacost and ( uses_remaining ~= 0 or is_always_cast ) ) then

            GameShootProjectile(root, x+aim_x*12, y+aim_y*12, x+aim_x*20, y+aim_y*20, EntityLoad("mods/D2DContentPack/files/entities/projectiles/concrete_wall_bullet_initial.xml", x, y))
            wand.mana = mana - manacost

            local spells, attached_spells = wand:GetSpells()
            for i,spell in ipairs( spells ) do
                if ( spell.action_id == "D2D_CONCRETE_WALL_ALT_FIRE" ) then
                    ComponentSetValue2( icomp, "uses_remaining", uses_remaining - 1 )
                    if ( uses_remaining == 1 ) then
                        GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/action_consumed", x, y );
                        EntityLoad("mods/D2DContentPack/files/particles/fade_alt_fire_concrete_wall.xml", x, y )
                    end

                    break
                end
            end

            ComponentSetValue2( variablecomp, "value_int", GameGetFrameNum() + cooldown_frames )
            if HasFlagPersistent(actionid) == false then
                GameAddFlagRun(table.concat({"new_",actionid}))
                AddFlagPersistent(actionid)
            end
                if ModIsEnabled("quant.ew") then
                    CrossCall("d2d_ew_alt_fire", root, x, y, aim_x, aim_y, "mods/D2DContentPack/files/entities/projectiles/concrete_wall_bullet_initial.xml")
                end
        elseif ( mana < manacost ) then
            GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/out_of_mana", x, y );
        end
    end
end