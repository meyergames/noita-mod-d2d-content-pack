dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
local wand = EZWand(EntityGetParent(entity_id))
local x, y = EntityGetTransform(entity_id)
local controlscomp = EntityGetFirstComponent(root, "ControlsComponent")
local cooldown_frames = 20
local actionid = "action_D2D_alt_fire_rewind"
local cooldown_frame
local variablecomp = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
cooldown_frame = ComponentGetValue2( variablecomp, "value_int" )
local aim_x, aim_y = ComponentGetValue2(controlscomp, "mAimingVectorNormalized")
local manacost = 40

local uses_remaining = -1
local icomp = EntityGetFirstComponentIncludingDisabled( entity_id, "ItemComponent" )
if ( icomp ~= nil ) then
    uses_remaining = ComponentGetValue2( icomp, "uses_remaining" )
end
local is_always_cast = ComponentGetValue2( icomp,"permanently_attached" )

if GameGetFrameNum() >= cooldown_frame then
    if is_alt_fire_pressed() then
        if not ModSettingGet( "D2DContentPack.alt_fire_enable_in_inventory" ) and GameIsInventoryOpen() then return end
        
        local mana = wand.mana

        if mana > manacost then
            local marker_id = get_internal_int( get_player(), "rewind_marker_id" )
            if marker_id ~= nil and marker_id ~= -1 then
                local x, y = EntityGetTransform( marker_id )
                GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/teleport/destroy", x, y )
                EntitySetTransform( get_player(), x, y )

                EntityKill( marker_id )
                set_internal_int( get_player(), "rewind_marker_id", -1 )
            end

            ComponentSetValue2( variablecomp, "value_int", GameGetFrameNum() + cooldown_frames )
        elseif ( mana < manacost ) then
            GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/out_of_mana", x, y );
        end
    end
end