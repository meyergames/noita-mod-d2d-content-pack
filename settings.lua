dofile("data/scripts/lib/mod_settings.lua")

--Key binding data
local listening_alt_fire = false
local listening_mid_fire = false
local there_has_been_input = false
local key_inputs ={}
local mouse_inputs = {}
local joystick_inputs = {}
local old_binding = 0
local current_keybind = ""

--Keybinds
local keybind_name = "Keybind"
local keybind_desc_altfire = "Edit your Alt Fire keybind"
local keybind_desc_midfire = "Edit your Mid Fire keybind"
local keybind_tutorial_altfire = "\nHit the prompt below to input a new alt-fire binding.\nThe default setting is the right mouse button."
local keybind_explanation_midfire = "\nSome special wands in this mod use \"Mid Fire\" spells."
local keybind_tutorial_midfire = "\nHit the prompt below to input a new mid-fire binding.\nThe default setting is the middle mouse button."
local keybind_newbinding = "SET NEW BINDING"
local keybind_current_altfire = "Current binding: "
local keybind_current_midfire = "Current binding: "

mouse_codes = {
  MOUSE_LEFT = 1,
  MOUSE_RIGHT = 2,
  MOUSE_MIDDLE = 3,
  MOUSE_WHEEL_UP = 4,
  MOUSE_WHEEL_DOWN = 5,
  MOUSE_X1 = 6,
  MOUSE_X2 = 7,
}

key_codes = {
  A = 4,
  B = 5,
  C = 6,
  D = 7,
  E = 8,
  F = 9,
  G = 10,
  H = 11,
  I = 12,
  J = 13,
  K = 14,
  L = 15,
  M = 16,
  N = 17,
  O = 18,
  P = 19,
  Q = 20,
  R = 21,
  S = 22,
  T = 23,
  U = 24,
  V = 25,
  W = 26,
  X = 27,
  Y = 28,
  Z = 29,
  ONE = 30,
  TWO = 31,
  THREE = 32,
  FOUR = 33,
  FIVE = 34,
  SIX = 35,
  SEVEN = 36,
  EIGHT = 37,
  NINE = 38,
  ZERO = 39,
  RETURN = 40,
  ESCAPE = 41,
  BACKSPACE = 42,
  TAB = 43,
  SPACE = 44,
  MINUS = 45,
  EQUALS = 46,
  LEFTBRACKET = 47,
  RIGHTBRACKET = 48,
  BACKSLASH = 49,
  NONUSHASH = 50,
  SEMICOLON = 51,
  APOSTROPHE = 52,
  GRAVE = 53,
  COMMA = 54,
  PERIOD = 55,
  SLASH = 56,
  CAPSLOCK = 57,
  F1 = 58,
  F2 = 59,
  F3 = 60,
  F4 = 61,
  F5 = 62,
  F6 = 63,
  F7 = 64,
  F8 = 65,
  F9 = 66,
  F10 = 67,
  F11 = 68,
  F12 = 69,
  PRINTSCREEN = 70,
  SCROLLLOCK = 71,
  PAUSE = 72,
  INSERT = 73,
  HOME = 74,
  PAGEUP = 75,
  DELETE = 76,
  END = 77,
  PAGEDOWN = 78,
  RIGHT = 79,
  LEFT = 80,
  DOWN = 81,
  UP = 82,
  NUMLOCKCLEAR = 83,
  KP_DIVIDE = 84,
  KP_MULTIPLY = 85,
  KP_MINUS = 86,
  KP_PLUS = 87,
  KP_ENTER = 88,
  KP_1 = 89,
  KP_2 = 90,
  KP_3 = 91,
  KP_4 = 92,
  KP_5 = 93,
  KP_6 = 94,
  KP_7 = 95,
  KP_8 = 96,
  KP_9 = 97,
  KP_0 = 98,
  KP_PERIOD = 99,
  NONUSBACKSLASH = 100,
  APPLICATION = 101,
  POWER = 102,
  KP_EQUALS = 103,
  F13 = 104,
  F14 = 105,
  F15 = 106,
  F16 = 107,
  F17 = 108,
  F18 = 109,
  F19 = 110,
  F20 = 111,
  F21 = 112,
  F22 = 113,
  F23 = 114,
  F24 = 115,
  EXECUTE = 116,
  HELP = 117,
  MENU = 118,
  SELECT = 119,
  STOP = 120,
  AGAIN = 121,
  UNDO = 122,
  CUT = 123,
  COPY = 124,
  PASTE = 125,
  FIND = 126,
  MUTE = 127,
  VOLUMEUP = 128,
  VOLUMEDOWN = 129,
  KP_COMMA = 133,
  KP_EQUALSAS400 = 134,
  INTERNATIONAL1 = 135,
  INTERNATIONAL2 = 136,
  INTERNATIONAL3 = 137,
  INTERNATIONAL4 = 138,
  INTERNATIONAL5 = 139,
  INTERNATIONAL6 = 140,
  INTERNATIONAL7 = 141,
  INTERNATIONAL8 = 142,
  INTERNATIONAL9 = 143,
  LANG1 = 144,
  LANG2 = 145,
  LANG3 = 146,
  LANG4 = 147,
  LANG5 = 148,
  LANG6 = 149,
  LANG7 = 150,
  LANG8 = 151,
  LANG9 = 152,
  ALTERASE = 153,
  SYSREQ = 154,
  CANCEL = 155,
  CLEAR = 156,
  PRIOR = 157,
  RETURN2 = 158,
  SEPARATOR = 159,
  OUT = 160,
  OPER = 161,
  CLEARAGAIN = 162,
  CRSEL = 163,
  EXSEL = 164,
  KP_00 = 176,
  KP_000 = 177,
  THOUSANDSSEPARATOR = 178,
  DECIMALSEPARATOR = 179,
  CURRENCYUNIT = 180,
  CURRENCYSUBUNIT = 181,
  KP_LEFTPAREN = 182,
  KP_RIGHTPAREN = 183,
  KP_LEFTBRACE = 184,
  KP_RIGHTBRACE = 185,
  KP_TAB = 186,
  KP_BACKSPACE = 187,
  KP_A = 188,
  KP_B = 189,
  KP_C = 190,
  KP_D = 191,
  KP_E = 192,
  KP_F = 193,
  KP_XOR = 194,
  KP_POWER = 195,
  KP_PERCENT = 196,
  KP_LESS = 197,
  KP_GREATER = 198,
  KP_AMPERSAND = 199,
  KP_DBLAMPERSAND = 200,
  KP_VERTICALBAR = 201,
  KP_DBLVERTICALBAR = 202,
  KP_COLON = 203,
  KP_HASH = 204,
  KP_SPACE = 205,
  KP_AT = 206,
  KP_EXCLAM = 207,
  KP_MEMSTORE = 208,
  KP_MEMRECALL = 209,
  KP_MEMCLEAR = 210,
  KP_MEMADD = 211,
  KP_MEMSUBTRACT = 212,
  KP_MEMMULTIPLY = 213,
  KP_MEMDIVIDE = 214,
  KP_PLUSMINUS = 215,
  KP_CLEAR = 216,
  KP_CLEARENTRY = 217,
  KP_BINARY = 218,
  KP_OCTAL = 219,
  KP_DECIMAL = 220,
  KP_HEXADECIMAL = 221,
  LCTRL = 224,
  LSHIFT = 225,
  LALT = 226,
  LGUI = 227,
  RCTRL = 228,
  RSHIFT = 229,
  RALT = 230,
  RGUI = 231,
  MODE = 257,
  AUDIONEXT = 258,
  AUDIOPREV = 259,
  AUDIOSTOP = 260,
  AUDIOPLAY = 261,
  AUDIOMUTE = 262,
  MEDIASELECT = 263,
  WWW = 264,
  MAIL = 265,
  CALCULATOR = 266,
  COMPUTER = 267,
  AC_SEARCH = 268,
  AC_HOME = 269,
  AC_BACK = 270,
  AC_FORWARD = 271,
  AC_STOP = 272,
  AC_REFRESH = 273,
  AC_BOOKMARKS = 274,
  BRIGHTNESSDOWN = 275,
  BRIGHTNESSUP = 276,
  DISPLAYSWITCH = 277,
  KBDILLUMTOGGLE = 278,
  KBDILLUMDOWN = 279,
  KBDILLUMUP = 280,
  EJECT = 281,
  SLEEP = 282,
  APP1 = 283,
  APP2 = 284,
  SPECIAL_COUNT = 512,
}

joystick_codes = {
  ANALOG_00_MOVED = 1,
  ANALOG_01_MOVED = 2,
  ANALOG_02_MOVED = 3,
  ANALOG_03_MOVED = 4,
  ANALOG_04_MOVED = 5,
  ANALOG_05_MOVED = 6,
  ANALOG_06_MOVED = 7,
  ANALOG_07_MOVED = 8,
  ANALOG_08_MOVED = 9,
  ANALOG_09_MOVED = 10,
  DPAD_UP = 11,
  DPAD_DOWN = 12,
  DPAD_LEFT = 13,
  DPAD_RIGHT = 14,
  START = 15,
  BACK = 16,
  LEFT_THUMB = 17,
  RIGHT_THUMB = 18,
  LEFT_SHOULDER = 19,
  RIGHT_SHOULDER = 20,
  LEFT_STICK_MOVED = 21,
  RIGHT_STICK_MOVED = 22,
  BUTTON_0 = 23,
  BUTTON_1 = 24,
  BUTTON_2 = 25,
  BUTTON_3 = 26,
  BUTTON_4 = 27,
  BUTTON_5 = 28,
  BUTTON_6 = 29,
  BUTTON_7 = 30,
  BUTTON_8 = 31,
  BUTTON_9 = 32,
  BUTTON_10 = 33,
  BUTTON_11 = 34,
  BUTTON_12 = 35,
  BUTTON_13 = 36,
  BUTTON_14 = 37,
  BUTTON_15 = 38,
  LEFT_STICK_LEFT = 39,
  LEFT_STICK_RIGHT = 40,
  LEFT_STICK_UP = 41,
  LEFT_STICK_DOWN = 42,
  RIGHT_STICK_LEFT = 43,
  RIGHT_STICK_RIGHT = 44,
  RIGHT_STICK_UP = 45,
  RIGHT_STICK_DOWN = 46,
  ANALOG_00_DOWN = 47,
  ANALOG_01_DOWN = 48,
  ANALOG_02_DOWN = 49,
  ANALOG_03_DOWN = 50,
  ANALOG_04_DOWN = 51,
  ANALOG_05_DOWN = 52,
  ANALOG_06_DOWN = 53,
  ANALOG_07_DOWN = 54,
  ANALOG_08_DOWN = 55,
  ANALOG_09_DOWN = 56,
  A = 23,
  B = 24,
  X = 25,
  Y = 26
}

function input_listen(key_inputs,mouse_inputs,joystick_inputs,mod_setting)
  local there_is_input = false
  for _, code in pairs(key_codes) do
      if InputIsKeyDown(code) then
          there_is_input = true
          there_has_been_input = true
          if has_value(key_inputs, code) == false then
              table.insert(key_inputs, code)
          end
      end
  end
  for _, code in pairs(mouse_codes) do
      if InputIsMouseButtonDown(code) then
          there_is_input = true
          there_has_been_input = true
          if has_value(mouse_inputs, code) == false then
              table.insert(mouse_inputs, code)
          end
      end
  end
  for _, code in pairs(joystick_codes) do
      if InputIsJoystickButtonDown(0, code) then
          there_is_input = true
          there_has_been_input = true
          if has_value(joystick_inputs, code) == false then
              table.insert(joystick_inputs, code)
          end
      end
  end

  --Decided variable forces only a single keybind for input and blocks combo inputs, can be remove to disable this limiter
  local decided = false
  local binding = "key_code,"
  for _, code in pairs(key_inputs) do
    if decided == true then break end
    binding = table.concat({binding,tostring(code),","})
    decided = true
  end
  binding = binding .. "mouse_code,"
  for _, code in pairs(mouse_inputs) do
    if decided == true then break end
    binding = table.concat({binding,tostring(code),","})
    decided = true
  end
  binding = binding .. "joystick_code,"
  for _, code in pairs(joystick_inputs) do
    if decided == true then break end
    binding = table.concat({binding,tostring(code),","})
    decided = true
  end
  binding = binding:sub(1, -2)
  ModSettingSet( mod_setting, binding )

  if there_has_been_input and not there_is_input then
      listening_alt_fire = false
      listening_mid_fire = false
      there_has_been_input = false
      key_inputs = {}
      mouse_inputs = {}
      joystick_inputs = {}
      if ModSettingGet( mod_setting ) == "key_code,mouse_code,joystick_code" then
          ModSettingSet( mod_setting, old_binding )
      end
  end
end

function has_value (table, value)
  for _, v in ipairs(table) do
      if v == value then
          return true
      end
  end
  return false
end

function ModSettingsUpdate(init_scope)
    local old_version = mod_settings_get_version(mod_id)
    mod_settings_update(mod_id, mod_settings, init_scope)
end

function ModSettingsGuiCount()
    return mod_settings_gui_count(mod_id, mod_settings)
end

function ModSettingsGui(gui, in_main_menu)
    mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
end

local mod_id = "D2DContentPack" -- This should match the name of your mod's folder.
mod_settings_version = 1      -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings =
{
    {
        category_id = "default_settings",
        ui_name = "General",
        ui_description = "",
        settings = {
            {
                id = "enable_repeating_update_messages",
                ui_name = "Repeat in-game messages about new updates",
                ui_description = "When this setting is enabled, in-game messages about\nnew updates to this mod will be shown once per run.",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
        }
    },
    {
        category_id = "perk_settings",
        ui_name = "Perks",
        ui_description = "",
        settings = {
            {
                id = "always_spawn_mod_reworks",
                ui_name = "Always spawn mod reworks",
                ui_description = "When enabled, reworks for perks from other mods can spawn\neven if the original mod is not enabled.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "spawn_challenge_perk_sometimes",
                ui_name = "Sometimes spawn a Challenge Perk on new game start",
                ui_description = "When you start a new game with this setting enabled, there's\na 5% chance for Time Trial or Glass Heart to spawn at the\nmountain entrance.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
        },
    },
    {
        category_id = "item_settings",
        ui_name = "Items",
        ui_description = "",
        settings = {
            {
                id = "auto_emergency_injection_threshold",
                ui_name = "Emergency Injection auto-use threshold",
                ui_description = "When you have an Emergency Injection in your inventory,\nit will automatically be used below this percentage of your\nmax HP. A value of 0 disables this functionality.",
                value_default = 0.05,
                value_min = 0,
                value_max = 0.2,
                value_display_multiplier = 100,
                value_display_formatting = " $0 %",
                scope = MOD_SETTING_SCOPE_RUNTIME,
            },
            -- {
            --     id = "auto_pickup_hammer",
            --     ui_name = "Auto pickup Hammer",
            --     ui_description = "Whether to automatically pick up the Hammer item.",
            --     value_default = true,
            --     scope = MOD_SETTING_SCOPE_RESTART,
            -- },
        },
    },
    {
        category_id = "spell_settings",
        ui_name = "Spells",
        ui_description = "",
        settings = {
            {
                id = "beacon_hide_distance_threshold",
                ui_name = "Beacon indicator max distance",
                ui_description = "How far away must a Beacon be, before its indicator is hidden?\nA value of 0 means beacon indicators will always be visible.",
                value_default = 2000,
                value_min = 0,
                value_max = 5000,
                scope = MOD_SETTING_SCOPE_RUNTIME,
            },
            {
                id = "alt_fire_enable_in_inventory",
                ui_name = "Enable Alt/Mid Fire spells while inventory is open",
                ui_description = "When enabled, this mod's Alt/Mid Fire spells will function even\nwhen the inventory is opened.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_RUNTIME,
            },
        },
    },
    {
        category_id = "alt_fire_settings",
        ui_name = "Keybind: Alt Fire",
        ui_description = "Which button should be used to alt-fire?",
        foldable = true,
        _folded = true,
        settings = {
            {
                id = "alt_fire_keybind",
                ui_name = "",
                value_default = "key_code,mouse_code,2,joystick_code",
                ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
                            if listening_alt_fire then
                                input_listen(key_inputs,mouse_inputs,joystick_inputs,"D2DContentPack.alt_fire_keybind")
                            end

                            local _id = 0
                            local function id()
                              _id = _id + 1
                              return _id
                            end

                            local keybind_string = ""
                            local keybind_setting = ModSettingGet("D2DContentPack.alt_fire_keybind")
                            local mode = "key_code"
                            for code in string.gmatch(keybind_setting, "[^,]+") do
                              if code == "mouse_code" or code == "key_code" or code == "joystick_code" then
                                  mode = code
                              else
                                  if keybind_string ~= "" then
                                      keybind_string = keybind_string .. " + "
                                  end
                                  code = tonumber(code)
                                  if mode == "key_code" then
                                      for key, value in pairs(key_codes) do
                                          if value == code then
                                              keybind_string = keybind_string .. key
                                              ModSettingSet("D2DContentPack.alt_fire_keybind_translated",key)
                                          end
                                      end
                                  elseif mode == "mouse_code" then
                                      for key, value in pairs(mouse_codes) do
                                          if value == code then
                                              keybind_string = keybind_string .. key
                                              ModSettingSet("D2DContentPack.alt_fire_keybind_translated",key)
                                          end
                                      end
                                  elseif mode == "joystick_code" then
                                      for key, value in pairs(joystick_codes) do
                                          if value == code then
                                              keybind_string = keybind_string .. key
                                              ModSettingSet("D2DContentPack.alt_fire_keybind_translated",key)
                                          end
                                      end
                                  end
                              end
                            end

                            GuiColorSetForNextWidget(gui, 1, 1, 1, 0.5)
                            GuiText(gui, 5, 0, keybind_tutorial_altfire)
                            if listening_alt_fire then
                              GuiColorSetForNextWidget(gui, 1, 0, 0, 1)
                              GuiOptionsAdd(gui, GUI_OPTION.NonInteractive)
                            end
                            if GuiButton(gui, id(), 10, 5, keybind_newbinding) then
                              key_inputs = {}
                              mouse_inputs = {}
                              joystick_inputs = {}
                              listening_alt_fire = true
                              there_has_been_input = false
                              old_binding = ModSettingGet("D2DContentPack.alt_fire_keybind")
                            end
                            GuiColorSetForNextWidget(gui, 1, 1, 1, 0.5)
                            GuiText(gui, 5, 5, keybind_current_altfire .. keybind_string)
                            GuiText(gui, 0, -5, " ")
                            end
            },
            {
                id = "alt_fire_keybind_translated",
                ui_name = "Secret setting",
                value_default = "MOUSE_RIGHT",
                text_max_length = 20,
                allowed_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789",
                hidden = true,
            },
            {
                id = "alt_fire_always_enable_right_click",
                ui_name = "Always enable right-click Alt Fire",
                ui_description = "If enabled, this mod's Alt Fire spells can always be triggered\nwith a right-click, regardless of the configured keybind.",
                value_default = true,
                scope = MOD_SETTING_SCOPE_RUNTIME,
            },
        },
    },
    {
        category_id = "mid_fire_settings",
        ui_name = "Keybind: Mid Fire",
        ui_description = "Which button should be used to mid-fire?",
        foldable = true,
        _folded = true,
        settings = {
            {
                id = "mid_fire_keybind",
                ui_name = "",
                value_default = "key_code,mouse_code,2,joystick_code",
                ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
                            if listening_mid_fire then
                                input_listen(key_inputs,mouse_inputs,joystick_inputs,"D2DContentPack.mid_fire_keybind")
                            end

                            local _id = 0
                            local function id()
                              _id = _id + 1
                              return _id
                            end

                            local keybind_string = ""
                            local keybind_setting = ModSettingGet("D2DContentPack.mid_fire_keybind")
                            local mode = "key_code"
                            for code in string.gmatch(keybind_setting, "[^,]+") do
                              if code == "mouse_code" or code == "key_code" or code == "joystick_code" then
                                  mode = code
                              else
                                  if keybind_string ~= "" then
                                      keybind_string = keybind_string .. " + "
                                  end
                                  code = tonumber(code)
                                  if mode == "key_code" then
                                      for key, value in pairs(key_codes) do
                                          if value == code then
                                              keybind_string = keybind_string .. key
                                              ModSettingSet("D2DContentPack.mid_fire_keybind_translated",key)
                                          end
                                      end
                                  elseif mode == "mouse_code" then
                                      for key, value in pairs(mouse_codes) do
                                          if value == code then
                                              keybind_string = keybind_string .. key
                                              ModSettingSet("D2DContentPack.mid_fire_keybind_translated",key)
                                          end
                                      end
                                  elseif mode == "joystick_code" then
                                      for key, value in pairs(joystick_codes) do
                                          if value == code then
                                              keybind_string = keybind_string .. key
                                              ModSettingSet("D2DContentPack.mid_fire_keybind_translated",key)
                                          end
                                      end
                                  end
                              end
                            end

                            GuiColorSetForNextWidget(gui, 1, 1, 1, 0.5)
                            GuiText(gui, 5, 0, keybind_explanation_midfire)
                            GuiColorSetForNextWidget(gui, 1, 1, 1, 0.5)
                            GuiText(gui, 5, 0, keybind_tutorial_midfire)
                            if listening_mid_fire then
                              GuiColorSetForNextWidget(gui, 1, 0, 0, 1)
                              GuiOptionsAdd(gui, GUI_OPTION.NonInteractive)
                            end
                            if GuiButton(gui, id(), 10, 5, keybind_newbinding) then
                              key_inputs = {}
                              mouse_inputs = {}
                              joystick_inputs = {}
                              listening_mid_fire = true
                              there_has_been_input = false
                              old_binding = ModSettingGet("D2DContentPack.mid_fire_keybind")
                            end
                            GuiColorSetForNextWidget(gui, 1, 1, 1, 0.5)
                            GuiText(gui, 5, 5, keybind_current_midfire .. keybind_string)
                            GuiText(gui, 0, -5, " ")
                            end
            },
            {
                id = "mid_fire_keybind_translated",
                ui_name = "Secret setting",
                value_default = "MOUSE_MIDDLE",
                text_max_length = 20,
                allowed_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789",
                hidden = true,
            },
            {
                id = "mid_fire_always_enable_middle_click",
                ui_name = "Always enable middle-click Mid Fire",
                ui_description = "If enabled, this mod's Mid Fire spells can always be triggered\nwith a middle-click, regardless of the configured keybind.",
                value_default = true,
                scope = MOD_SETTING_SCOPE_RUNTIME,
            },
        },
    },
    {
        category_id = "starting_wand_settings",
        ui_name = "Starting Wands",
        ui_description = "",
        settings = {
            {
                id = "more_starting_wand_variety",
                ui_name = "More starting wand variety",
                ui_description = "When enabled, your starting wand may contain a wider\nvariety of the base game's projectile spells.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "dynamite_as_default_bomb",
                ui_name = "Start with dynamite more often",
                ui_description = "When enabled, your starting bomb wand has a higher chance\nto contain dynamite.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "sometimes_start_with_glass_shard",
                ui_name = "Sometimes start with Glass Shard",
                ui_description = "When enabled, your starting wand may sometimes contain\nthe Glass Shard spell.",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "sometimes_start_with_sniper_bolt",
                ui_name = "Sometimes start with Sniper Bolt",
                ui_description = "When enabled, your starting wand may sometimes contain\nthe Sniper Bolt spell.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "sometimes_start_with_banana_bomb",
                ui_name = "Sometimes start with Banana Bomb",
                ui_description = "When enabled, your starting bomb wand may sometimes contain\nthe Banana Bomb spell.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            -- {
            --     id = "afa_compat",
            --     ui_name = "Disable alt fire spells if Alt Fire Anything is enabled",
            --     ui_description = "If the Alt Fire Anything mod is enabled, disable this\nmod's individual alt fire spell variations.",
            --     value_default = true,
            --     scope = MOD_SETTING_SCOPE_NEW_GAME,
            -- },
            -- {
            --     id = "Spells",
            --     ui_name = "Enabled/disabled spells",
            --     ui_fn = mod_setting_vertical_spacing,
            --     not_setting = true,
            -- },
        },
    },
    {
        category_id = "enemy_settings",
        ui_name = "Enemies",
        ui_description = "",
        settings = {
            {
                id = "spawn_ancient_lurker_manually",
                ui_name = "Spawn Ancient Lurker manually",
                ui_description = "When enabled, the Ancient Lurker will appear only after\npicking up a specific nearby circular object.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_RUNTIME,
            },
        },
    },
    {
        category_id = "anti_cheese_settings",
        ui_name = "Anti-cheese settings",
        ui_description = "",
        settings = {
            {
                id = "nerf_greek_spells",
                ui_name = "Make Greek spells limited-use",
                ui_description = "For when infinite casts of anything make the game too easy for you.\nYou'll have to get creative if you want (near-)unlimited spells...",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "cap_max_health",
                ui_name = "Limit max health to 1000",
                ui_description = "For when overusing a certain exploit makes the game too easy for you.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
        },
    },
    {
        category_id = "content_toggles",
        ui_name = "Toggle individual reworks, spells and perks",
        ui_description = "",
        settings = {
        }
    },
}

function ModSettingsUpdate(init_scope)
    local old_version = mod_settings_get_version(mod_id)
    mod_settings_update(mod_id, mod_settings, init_scope)
end

function ModSettingsGuiCount()
    return mod_settings_gui_count(mod_id, mod_settings)
end

function ModSettingsGui(gui, in_main_menu)
    mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
end

function do_custom_tooltip( callback, z, x_offset, y_offset )
    if z == nil then z = -12 end
    local left_click,right_click,hover,x,y,width,height,draw_x,draw_y,draw_width,draw_height = GuiGetPreviousWidgetInfo( gui );
    local screen_width,screen_height = GuiGetScreenDimensions( gui );
    if x_offset == nil then x_offset = 0; end
    if y_offset == nil then y_offset = 0; end
    if draw_y > screen_height * 0.5 then
        y_offset = y_offset - height;
    end
    if hover == 1 then
        local screen_width, screen_height = GuiGetScreenDimensions( gui );
        GuiZSet( gui, z );
        GuiLayoutBeginLayer( gui );
            GuiLayoutBeginVertical( gui, ( x + x_offset + width * 2 ) / screen_width * 100, ( y + y_offset ) / screen_height * 100 );
                GuiBeginAutoBox( gui );
                    if callback ~= nil then callback(); end
                    GuiZSetForNextWidget( gui, z + 1 );
                GuiEndAutoBoxNinePiece( gui );
            GuiLayoutEnd( gui );
        GuiLayoutEndLayer( gui );
    end
end

function HasSettingFlag(name)
    return ModSettingGet(name) or false
end

function AddSettingFlag(name)
    ModSettingSet(name, true)
  --  ModSettingSetNextValue(name, true)
end

function RemoveSettingFlag(name)
    ModSettingRemove(name)
end

-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui( gui, in_main_menu )
    screen_width, screen_height = GuiGetScreenDimensions(gui)

    mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )

    local id = 46323
    local function new_id() id = id + 1; return id end

    GuiOptionsAdd( gui, GUI_OPTION.NoPositionTween )

    --GuiLayoutBeginVertical( gui, 0, 0, false, 0, 3 )
    if(not in_main_menu)then

        -- PERK REWORKS
        dofile("mods/D2DContentPack/files/scripts/perks.lua")
        local filtered_perk_reworks = {}
        for i,perk in ipairs( d2d_perk_reworks ) do
            if not perk.not_in_default_perk_pool then
                table.insert( filtered_perk_reworks, perk )
            end
        end

        GuiLayoutBeginHorizontal( gui, 0, 0, false, 15, 10 )
        if GuiButton( gui, new_id(), 0, 0, "Enable All Reworks" )then
            for k, v in pairs( filtered_perk_reworks ) do
                RemoveSettingFlag(v.id.."_disabled")
            end
        end
        if GuiButton( gui, new_id(), 0, 0, "Disable All Reworks" )then
            for k, v in pairs( filtered_perk_reworks ) do
                AddSettingFlag(v.id.."_disabled")
            end
        end
        GuiLayoutEnd(gui)

        for k, v in pairs( filtered_perk_reworks ) do

            GuiLayoutBeginHorizontal( gui, 0, 0, false, 2, 2 )


            local clicked,right_clicked = GuiImageButton( gui, new_id(), 0, 0, "", v.perk_icon )
            if clicked then
                if HasSettingFlag( v.id.."_disabled") then
                    RemoveSettingFlag( v.id.."_disabled" )
                else
                    AddSettingFlag( v.id.."_disabled" )
                    RemoveSettingFlag( v.id.."_spawn_at_start" )
                end
            end
            if right_clicked then
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    RemoveSettingFlag( v.id.."_spawn_at_start" )
                elseif not HasSettingFlag( v.id.."_disabled") then
                    AddSettingFlag( v.id.."_spawn_at_start" )
                end
            end

            local original_source = "the base game"
            if v.source_mod_name then
                original_source = v.source_mod_name
            end
            local tooltip_text = GameTextGetTranslatedOrNot(v.ui_description) .. "\n" .. "(Replaces '" .. v.ui_name_vanilla .. "' from " .. original_source .. ")"
            if HasSettingFlag( v.id.."_disabled" ) then
                GuiTooltip( gui, tooltip_text, "[ Click to enable ]" );
            else
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    GuiTooltip( gui, tooltip_text, "[ Click to disable]   [ Right-click to disable spawn at start]" )
                else
                    GuiTooltip( gui, tooltip_text, "[ Click to disable]   [ Right-click to enable spawn at start ]" )
                end
            end

            GuiImage( gui, new_id(), -20.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_square.png", 1, 1.2, 0 )
            if HasSettingFlag( v.id.."_disabled" ) then
                GuiZSetForNextWidget( gui, -80 )
                GuiOptionsAddForNextWidget(gui, GUI_OPTION.NonInteractive)
                GuiImage( gui, new_id(), -20.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_disabled_overlay.png", 1, 1.2, 0 )
            end

            if HasSettingFlag( v.id.."_disabled" ) then
                GuiTooltip( gui, tooltip_text, "[ Click to enable ]" );
            else
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    GuiTooltip( gui, tooltip_text, "[ Click to disable ]   [ Right-click to disable spawn at start]" )
                else
                    GuiTooltip( gui, tooltip_text, "[ Click to disable ]   [ Right-click to enable spawn at start ]" )
                end
            end

            if HasSettingFlag( v.id.."_spawn_at_start" ) then
                GuiColorSetForNextWidget( gui, 0, 1, 0, 1 )
            else
                GuiColorSetForNextWidget( gui, 1, 1, 1, 1 )
            end

            -- local new_ui_name = GameTextGetTranslatedOrNot( v.ui_name )
            -- local vanilla_ui_name = GameTextGetTranslatedOrNot( v.ui_name_vanilla )
            -- local name_to_show = vanilla_ui_name
            -- if new_ui_name ~= vanilla_ui_name then
            --     name_to_show = vanilla_ui_name .. " -> " .. new_ui_name
            -- end
            -- if v.source_mod_name then
            --     name_to_show = new_ui_name .. " (from mod: " .. v.source_mod_name .. ")"
            -- end
            GuiText( gui, 0, 3, GameTextGetTranslatedOrNot( v.ui_name ) )
            GuiLayoutEnd(gui)
        end




        -- SPELLS
        dofile("mods/D2DContentPack/files/scripts/actions.lua")
        local filtered_actions = {}
        for i,action in ipairs( d2d_actions ) do
            if action.spawn_probability ~= "0" then
                table.insert( filtered_actions, action )
            end
        end

        GuiLayoutBeginHorizontal( gui, 0, 0, false, 15, 10 )
        if GuiButton( gui, new_id(), 0, 0, "Enable All Spells" )then
            for k, v in pairs( filtered_actions ) do
                RemoveSettingFlag(v.id.."_disabled")
            end
        end
        if GuiButton( gui, new_id(), 0, 0, "Disable All Spells" )then
            for k, v in pairs( filtered_actions ) do
                AddSettingFlag(v.id.."_disabled")
            end
        end
        GuiLayoutEnd(gui)

        for k, v in pairs( filtered_actions ) do

            GuiLayoutBeginHorizontal( gui, 0, 0, false, 2, 2 )

            local clicked,right_clicked = GuiImageButton( gui, new_id(), 0, 0, "", v.sprite )
            if clicked then
                if HasSettingFlag( v.id.."_disabled") then
                    RemoveSettingFlag(v.id.."_disabled")
                else
                    AddSettingFlag(v.id.."_disabled")
                    RemoveSettingFlag(v.id.."_spawn_at_start")
                end
            end
            if right_clicked then
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    RemoveSettingFlag(v.id.."_spawn_at_start")
                elseif not HasSettingFlag( v.id.."_disabled") then
                    AddSettingFlag(v.id.."_spawn_at_start")
                end
            end

            if HasSettingFlag( v.id.."_disabled" ) then
                GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to enable ]" )
            else
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to disable ]   [ Right-click to disable spawn at start]" )
                else
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to disable ]   [ Right-click to enable spawn at start ]" )
                end
            end

            -- GuiImage( gui, new_id(), -36.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_square.png", 1, 1.2, 0 )
            GuiImage( gui, new_id(), -20.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_square.png", 1, 1.2, 0 )
            if(HasSettingFlag(v.id.."_disabled"))then
                GuiZSetForNextWidget( gui, -80 )
                GuiOptionsAddForNextWidget(gui, GUI_OPTION.NonInteractive)
                GuiImage( gui, new_id(), -20.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_disabled_overlay.png", 1, 1.2, 0 )
            end

            if HasSettingFlag( v.id.."_disabled" ) then
                GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to enable ]" )
            else
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to disable ]   [ Right-click to disable spawn at start]" )
                else
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to disable ]   [ Right-click to enable spawn at start ]" )
                end
            end

            if HasSettingFlag( v.id.."_spawn_at_start" ) then
                GuiColorSetForNextWidget( gui, 0, 1, 0, 1 )
            else
                GuiColorSetForNextWidget( gui, 1, 1, 1, 1 )
            end
            GuiText( gui, 0, 3, GameTextGetTranslatedOrNot(v.name) )

            
            GuiLayoutEnd(gui)
            
        end





        -- PERKS
        local filtered_perks = {}
        for i,perk in ipairs( d2d_perks ) do
            if not perk.not_in_default_perk_pool then
                table.insert( filtered_perks, perk )
            end
        end
        -- if d2d_apoth_perks then
        --     for i,perk in ipairs( d2d_apoth_perks ) do
        --         if not perk.not_in_default_perk_pool then
        --             table.insert( filtered_perks, perk )
        --         end
        --     end
        -- end

        GuiLayoutBeginHorizontal( gui, 0, 0, false, 15, 10 )
        if GuiButton( gui, new_id(), 0, 0, "Enable All Perks" )then
            for k, v in pairs( filtered_perks ) do
                RemoveSettingFlag(v.id.."_disabled")
            end
        end
        if GuiButton( gui, new_id(), 0, 0, "Disable All Perks" )then
            for k, v in pairs( filtered_perks ) do
                AddSettingFlag(v.id.."_disabled")
            end
        end
        GuiLayoutEnd(gui)

        for k, v in pairs( filtered_perks ) do

            GuiLayoutBeginHorizontal( gui, 0, 0, false, 2, 2 )


            local clicked,right_clicked = GuiImageButton( gui, new_id(), 0, 0, "", v.perk_icon )
            if clicked then
                if HasSettingFlag( v.id.."_disabled") then
                    RemoveSettingFlag(v.id.."_disabled")
                else
                    AddSettingFlag(v.id.."_disabled")
                    RemoveSettingFlag(v.id.."_spawn_at_start")
                end
            end
            if right_clicked then
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    RemoveSettingFlag( v.id.."_spawn_at_start" )
                elseif not HasSettingFlag( v.id.."_disabled") then
                    AddSettingFlag( v.id.."_spawn_at_start" )
                end
            end

            if(HasSettingFlag(v.id.."_disabled"))then
                GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to enable ]" );
            else
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to disable ]   [ Right-click to disable spawn at start]" )
                else
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to disable ]   [ Right-click to enable spawn at start ]" )
                end
            end

            GuiImage( gui, new_id(), -20.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_square.png", 1, 1.2, 0 )
            if(HasSettingFlag(v.id.."_disabled"))then
                GuiZSetForNextWidget( gui, -80 )
                GuiOptionsAddForNextWidget(gui, GUI_OPTION.NonInteractive)
                GuiImage( gui, new_id(), -20.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_disabled_overlay.png", 1, 1.2, 0 )
            end

            if(HasSettingFlag(v.id.."_disabled"))then
                GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to enable ]" );
            else
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to disable ]   [ Right-click to disable spawn at start]" )
                else
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to disable ]   [ Right-click to enable spawn at start ]" )
                end
            end

            if HasSettingFlag( v.id.."_spawn_at_start" ) then
                GuiColorSetForNextWidget( gui, 0, 1, 0, 1 )
            else
                GuiColorSetForNextWidget( gui, 1, 1, 1, 1 )
            end
            GuiText( gui, 0, 3, GameTextGetTranslatedOrNot(v.ui_name) )
            GuiLayoutEnd(gui)
        end
    else
        GuiColorSetForNextWidget( gui, 1, 0, 0, 1 )
        GuiText( gui, 0, 0, "Individual spells and perks can only be enabled/disabled in-game." )
    end
    for i = 1, 5 do
        GuiText( gui, 0, 0, "" )
    end
    --GuiLayoutEnd(gui)
end