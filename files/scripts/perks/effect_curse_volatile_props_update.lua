dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local player = GetUpdatedEntityID()
local x, y = EntityGetTransform( player )
local nearby_props = EntityGetInRadiusWithTag( x, y, 50, "prop" )

for i,prop in ipairs( nearby_props ) do
	if EntityHasTag( prop, "mortal" ) then
		local dmg_comp = EntityGetFirstComponentIncludingDisabled( prop, "DamageModelComponent" )
		if exists( dmg_comp ) then

			local max_hp = ComponentGetValue2( dmg_comp, "max_hp" )

			-- ignore temple statues etc 
			if max_hp < 40 then

				-- destroy the prop in max. 4 cycles
				local prop_x, prop_y = EntityGetTransform( prop )
				EntityInflictDamage( prop, max_hp * 0.3, "NONE", "volatile props (curse)", "NO_RAGDOLL_FILE", 0, 0, player, prop_x, prop_y, 0 )

			end
		end
	end
end