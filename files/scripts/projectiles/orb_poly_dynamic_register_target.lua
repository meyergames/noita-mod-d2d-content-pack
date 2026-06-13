dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local player = get_player()
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local nearby_enemies = EntityGetInRadiusWithTag( x, y, 50, "homing_target" )
GamePrint( "enemies found: " .. #nearby_enemies )
for i,enemy in ipairs( nearby_enemies ) do
	if enemy ~= player then
		local target_filename = EntityGetFilename( enemy )
		if target_filename and target_filename ~= "" then
			GamePrint( "target set: " .. target_filename )
			set_internal_string( player, "d2d_dynamic_poly_target", target_filename )
			for key,value in pairs( PolymorphTableGet() ) do
				GamePrint( key .. ": " .. value )
			end
			PolymorphTableSet( { [1] = target_filename } ) -- empty the table
			GamePrint( "-----------" )
			for key,value in pairs( PolymorphTableGet() ) do
				GamePrint( key .. ": " .. value )
			end
			-- PolymorphTableAddEntity( target_filename, false, true )
			LoadGameEffectEntityTo( player, "mods/D2DContentPack/files/entities/misc/status_effects/effect_polymorph_dynamic.xml" )
			-- local init_poly_table = PolymorphTableGet()
			-- PolymorphTableSet( {} ) -- empty the table
			-- PolymorphTableAddEntity( target_filename, false, true )
			-- LoadGameEffectEntityTo( player, "data/entities/misc/effect_polymorph_random.xml" )
			-- PolymorphTableSet( init_poly_table )
		end
	end
end
