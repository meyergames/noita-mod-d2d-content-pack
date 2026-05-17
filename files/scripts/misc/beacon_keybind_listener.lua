dofile_once( "data/scripts/lib/utilities.lua" )

local player = EntityGetRootEntity( GetUpdatedEntityID() )

function is_keybind_pressed()
    local binding = ModSettingGet( "D2DContentPack.beacon_keybind" )
    local mode = "key_code"
    for code in string.gmatch(binding, "[^,]+") do
        if code == "mouse_code" or code == "key_code" or code == "joystick_code" then
            mode = code
        else
            code = tonumber(code)
            if mode == "key_code" then
                if InputIsKeyJustDown(code) then
                  return true
                end
            elseif mode == "mouse_code" then
                if InputIsMouseButtonJustDown(code) then
                  return true
                end
            elseif mode == "joystick_code" then
                if InputIsJoystickButtonJustDown(0, code) then
                  return true
                end
            end
        end
    end
end

function amt_of_registered_beacons()
    local all_data = GlobalsGetValue( "d2d_beacons_data" )
    local _, count = all_data:gsub(",","")
    return count
end

if is_keybind_pressed() then
    local MAX_BEACONS = math.floor( ModSettingGet( "D2DContentPack.max_beacon_count" ) + 0.5 )

    local beacon_count = amt_of_registered_beacons()
    local x, y = EntityGetTransform( player )
    EntityLoad( "mods/D2DContentPack/files/entities/projectiles/beacon.xml", x, y )
    
    if MAX_BEACONS == 0 or beacon_count >= MAX_BEACONS then
        dofile( "mods/D2DContentPack/files/scripts/projectiles/beacon_utils.lua" )
        for i=1, beacon_count - MAX_BEACONS + 1 do
            beacon_destroy_oldest()
        end
        GamePrint( "Beacon " .. MAX_BEACONS .. "/" .. MAX_BEACONS .. " placed" )
    else
        GamePrint( "Beacon " .. beacon_count + 1 .. "/" .. MAX_BEACONS .. " placed" )
    end
end
