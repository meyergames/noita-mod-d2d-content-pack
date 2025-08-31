-- REQUIRES APOTHEOSIS MOD INSTALLED

dofile_once("mods/Apotheosis/lib/apotheosis/apotheosis_utils.lua")
local EZWand = dofile_once("mods/Apotheosis/lib/EZWand/EZWand.lua")
local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
local wand = EZWand(EntityGetParent(entity_id))
local x, y = EntityGetTransform(entity_id)
local controlscomp = EntityGetFirstComponent(root, "ControlsComponent")
local cooldown_frames = 30
local actionid = "action_ctq_alt_fire_mana_refill"
local cooldown_frame
local variablecomp = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
cooldown_frame = ComponentGetValue2( variablecomp, "value_int" )
local aim_x, aim_y = ComponentGetValue2(controlscomp, "mAimingVectorNormalized")
local manacost = 0

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

            wand.mana = wand.manaMax
            -- wand.currentCastDelay = wand.currentCastDelay + 30
            GamePlaySound( "data/audio/Desktop/player.bank", "player_projectiles/wall/create", x, y )

            local spells, attached_spells = wand:GetSpells()
            for i,spell in ipairs( spells ) do
                if ( spell.action_id == "CTQ_MANA_REFILL_ALT_FIRE" ) then
                    ComponentSetValue2( icomp, "uses_remaining", uses_remaining - 1 )
                    if ( uses_remaining == 1 ) then
                        GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/action_consumed", x, y )
                        EntityLoad("mods/RiskRewardBundle/files/particles/fade_alt_fire_mana_refill.xml", x, y )
                    end

                    break
                end
            end

            ComponentSetValue2( variablecomp, "value_int", GameGetFrameNum() + cooldown_frames )
            if HasFlagPersistent(actionid) == false then
                GameAddFlagRun(table.concat({"new_",actionid}))
                AddFlagPersistent(actionid)
            end
        elseif ( mana < manacost ) then
            GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/out_of_mana", x, y );
        end
    end
end