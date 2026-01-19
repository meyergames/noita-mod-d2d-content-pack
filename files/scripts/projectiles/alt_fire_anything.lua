dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local me = GetUpdatedEntityID()
local caster = EntityGetRootEntity(me)
local controls = EntityGetFirstComponent(caster, "ControlsComponent")
if not controls then return end

local always_enable_right_click = ModSettingGet( "D2DContentPack.alt_fire_always_enable_right_click" )
if is_alt_fire_pressed() or ( always_enable_right_click and InputIsMouseButtonDown( 2 ) ) then
  if not ModSettingGet( "D2DContentPack.alt_fire_enable_in_inventory" ) and GameIsInventoryOpen() then return end

  local platform_shooter = EntityGetFirstComponent(caster, "PlatformShooterPlayerComponent")
  if not platform_shooter then return end
  ComponentSetValue2(platform_shooter, "mForceFireOnNextUpdate", true)
  local vscs = EntityGetComponent(caster, "VariableStorageComponent") or {}
  for _, vsc in ipairs(vscs) do
  	if ComponentGetValue2(vsc, "name") == "alt_fire_cause" then
  		EntityRemoveComponent(caster, vsc)
  	end
  end
  EntityAddComponent2(
  	caster,
  	"VariableStorageComponent",
  	{ name = "alt_fire_cause", value_string = "alt_fire", value_int = GameGetFrameNum() }
  )

end
