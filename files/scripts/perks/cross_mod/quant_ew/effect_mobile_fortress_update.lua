dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local EFFECT_RADIUS = 48

-- entity id and internal vars
local player = EntityGetRootEntity( GetUpdatedEntityID() )
if not exists( player ) then return end
local x, y = EntityGetTransform( player )

local nearby_allies = {}
-- local nearby_players = EntityGetInRadiusWithTag( x, y, EFFECT_RADIUS, "player_unit" )
local nearby_players = EntityGetInRadiusWithTag( x, y, EFFECT_RADIUS, "helpless_animal" )
table.insert( nearby_players, player )
for i,nearby_player in ipairs( nearby_players ) do
	table.insert( nearby_allies, nearby_player )
end
-- charmed enemies count, too
local maybe_allies = EntityGetInRadiusWithTag( x, y, EFFECT_RADIUS, "homing_target" )
for i,maybe_ally in ipairs( maybe_allies ) do
	if GameGetGameEffect( maybe_ally, "CHARM" ) ~= 0 then
		table.insert( nearby_allies, maybe_ally )
	end
end

local shields = {}
local children = EntityGetAllChildren( GetUpdatedEntityID() )
for i,child in ipairs( children ) do
	if EntityHasTag( child, "d2d_mobile_fortress_shield" ) then
		table.insert( shields, child )
	end
end

-- increase each player's mana regen
if exists( nearby_allies ) and #nearby_allies > 1 then
	for i,nearby_ally in ipairs( nearby_allies ) do
		if EntityHasTag( nearby_ally, "player_unit" ) then
			local held_wand_id = get_held_wand_id_of_player( nearby_ally )
			GamePrint( held_wand_id )
			local wand = EZWand( held_wand_id )
			GamePrint( wand.entity_id )

			local bonus_mtp = -0.5 + ( #nearby_players * 0.5 )
			GamePrint( "#nearby_players: " .. #nearby_players )
			if bonus_mtp < 0.5 then bonus_mtp = 0.5 end
			GamePrint( "bonus_mtp: " .. bonus_mtp )

			wand.mana = math.min( wand.mana + ( ( wand.manaChargeSpeed / 60 ) * bonus_mtp ), wand.manaMax )
		end
	end
end

if exists( shields ) and #shields >= 1 then
	for i,shield in ipairs( shields ) do
		local shield_comp = EntityGetFirstComponentIncludingDisabled( shield, "EnergyShieldComponent" )
		if exists( shield_comp ) then
			local max_energy = ComponentGetValue2( shield_comp, "max_energy" )
			local ring_emitter = EntityGetComponent( shield, "ParticleEmitterComponent" )[1]

			-- if there's 2 players, raise the first shield
			-- if there's 3 players, raise the second shield
			-- if there's 4 players, raise the third shield
			if max_energy < 1.0 and i <= #nearby_allies - 1 then
				ComponentSetValue2( shield_comp, "max_energy", 1.0 )
				ComponentSetValue2( shield_comp, "is_emitting", true )
				ComponentSetValue2( ring_emitter, "is_emitting", true )
			elseif max_energy > 0.0 and i > #nearby_allies - 1 then
				ComponentSetValue2( shield_comp, "max_energy", 0.0 )
				ComponentSetValue2( shield_comp, "energy", 0.0 )
				ComponentSetValue2( ring_emitter, "is_emitting", false )
			end

			-- once per second, update the first shieĺd's mana regen particles based on nearby players
			if GameGetFrameNum() % 60 == 0 and i == 1 then
				local regen_emitter = EntityGetComponent( shield, "ParticleEmitterComponent" )[3]

				-- if there's more than one player, emit mana particles
				local other_players = #nearby_players - 1

				ComponentSetValue2( regen_emitter, "count_min", math.max( 2 * other_players, 1 ) )
				ComponentSetValue2( regen_emitter, "count_max", math.max( 3 * other_players, 1 ) )
			end
		end
	end
end
