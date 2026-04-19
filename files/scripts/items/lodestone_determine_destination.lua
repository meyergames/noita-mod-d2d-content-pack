dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local tx = tonumber( GlobalsGetValue( "D2D_LODESTONE_X", "0" ) )
local ty = tonumber( GlobalsGetValue( "D2D_LODESTONE_Y", "0" ) )

if tx and ty and tx ~= 0 and ty ~= 0 then
	local telecomp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "TeleportComponent" )
	ComponentSetValue2( telecomp, "target", tx, ty - 20 )
end
