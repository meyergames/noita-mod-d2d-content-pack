dofile_once( "data/scripts/lib/utilities.lua" )

local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
local wand = EZWand(EntityGetParent(entity_id))
local x, y = EntityGetTransform(entity_id)
local controlscomp = EntityGetFirstComponent(root, "ControlsComponent")
local actionid = "action_d2d_alt_fire_concrete_wall"
local variablecomp = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
local aim_x, aim_y = ComponentGetValue2(controlscomp, "mAimingVectorNormalized")

local shield_id = EntityGetWithTag( "alt_fire_ctrl_shield" )[1]

if InputIsMouseButtonDown( 2 ) and not GameIsInventoryOpen() then -- is the right mouse button pressed?
	local itf_comp = EntityGetComponent( shield_id, "InheritTransformComponent" )
    local _x, _y, _sx, _sy, rot = ComponentGetValue2( itf_comp, "Transform" )
	rot = math.atan(x+aim_x*20, y+aim_y*20)

	GamePrint("test")
	GamePrint(rot)

	ComponentSetValue2( itf_comp, "Transform", _x, _y, _sx, _sy, rot )
end