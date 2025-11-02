dofile_once( "data/scripts/lib/utilities.lua" )

local old_spawn_heart = spawn_heart
function spawn_heart( x, y )
	local r = ProceduralRandom( x, y )
	SetRandomSeed( x, y )
	local heart_spawn_percent = 0.7
	
	local year, month, day = GameGetDateAndTimeLocal()
	if ( month == 2 ) and ( day == 14 ) then heart_spawn_percent = 0.35 end


	if (r > heart_spawn_percent) then
		local entity = EntityLoad( "data/entities/items/pickup/heart.xml", x, y )
	elseif (r > 0.3) then
		SetRandomSeed( x+45, y-2123 )
		local rnd = Random( 1, 100 )
		
		if (rnd <= 90) or (y < 512 * 3) then
			rnd = Random( 1, 1000 )
			
			if( Random( 1, 300 ) == 1 ) then spawn_mimic_sign( x, y ) end

			-- local config_curses_enabled = ModSettingGet("D2DContentPack.enable_curses")
			if ( rnd < 950 - get_perk_pickup_count( "D2D_HUNT_CURSES" ) * 150 ) 
				and not has_perk( "D2D_LIFT_CURSES" ) then
				local entity = EntityLoad( "data/entities/items/pickup/chest_random.xml", x, y )
			elseif ( rnd < 1000 ) then
				local entity = EntityLoad( "mods/D2DContentPack/files/entities/items/pickup/chest_random_cursed_d2d.xml", x, y )
			else
				local entity = EntityLoad( "data/entities/items/pickup/chest_random_super.xml", x, y )
			end
		else
			rnd = Random( 1, 100 )
			if( Random( 1, 30 ) == 1 ) then spawn_mimic_sign( x, y ) end

			if( rnd <= 95 ) then
				local entity = EntityLoad( "data/entities/animals/chest_mimic.xml", x, y )
			else
				local entity = EntityLoad( "data/entities/items/pickup/chest_leggy.xml", x, y )
			end
		end
	end
end
