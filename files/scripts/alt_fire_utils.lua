
function is_alt_fire_pressed()
  local binding = ModSettingGet( "D2DContentPack.alt_fire_keybind" )
  local mode = "key_code"
  for code in string.gmatch(binding, "[^,]+") do
      if code == "mouse_code" or code == "key_code" or code == "joystick_code" then
          mode = code
      else
          code = tonumber(code)
          if mode == "key_code" then
              if InputIsKeyDown(code) then
                return true
              end
          elseif mode == "mouse_code" then
              if InputIsMouseButtonDown(code) then
                return true
              end
          elseif mode == "joystick_code" then
              if InputIsJoystickButtonDown(0, code) then
                return true
              end
          end
      end
  end
end