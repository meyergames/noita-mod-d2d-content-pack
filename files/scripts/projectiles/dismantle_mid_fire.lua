dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity( entity_id )
local wand = EZWand( EntityGetParent( entity_id ) )
local x, y = EntityGetTransform( entity_id )

local cooldown_frames = 90 -- 1.5s cooldown
local variablecomp = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
local cooldown_frame = ComponentGetValue2( variablecomp, "value_int" )

if is_mid_fire_pressed() and GameGetFrameNum() >= cooldown_frame then
	-- get all spells
	local spells, always_casts = wand:GetSpells()
	if #spells == 0 then return end

	-- track points, based on how worthy the sacrifice was
	-- for every 10 points, guarantee a random upgrade
	local points = 0.0

	-- local spells_to_destroy = {}
	for i,spell in ipairs( spells ) do
		local was_spell_dismantled_before = false

		-- mark the spell as being dismantled before, if it wasn't already
		local lua_data = get_actions_lua_data( spell.action_id )
		local spells_had = get_internal_string( entity_id, "d2d_dismantle_spells_had" ) or ""
		if string.find( spells_had, spell.action_id ) then
			was_spell_dismantled_before = true
		else
			set_internal_string( entity_id, "d2d_dismantle_spells_had", spells_had .. spell.action_id .. "," )
		end

		-- assign this spell's point value based on the spell's price
		local value = lua_data.price * 0.01

		-- if the spell was dismantled before, reduce its value significantly
		if was_spell_dismantled_before then
			value = value * 0.25
		end

		-- if lua_data.type == "ACTION_TYPE_PASSIVE"
		-- or lua_data.type == "ACTION_TYPE_OTHER" 
		-- or lua_data.type == "ACTION_TYPE_MATERIAL" then
		-- 	value = value * 2
		-- end

		-- max. 1 upgrade per dismantled spell
		if value > 10 then value = 10 end
		points = points + value

		-- destroy the spell
		wand:RemoveSpells( spell.action_id )
		EntityKill( spell.entity_id )
	end

	-- play explosion sfx
	GamePlaySound( "data/audio/Desktop/explosion.bank", "explosions/glitter", x, y )

	-- determine how many upgrades the player gets
	local amt_of_upgrades = math.floor( points / 10 )
	local remaining_points = math.floor( points ) % 10
	local was_upgrade_created = false

	if amt_of_upgrades > 0 then
		generate_random_toolbox_spells( amt_of_upgrades, true )
		was_upgrade_created = true
	end
	if remaining_points > 0 and Random( 1, 10 ) <= remaining_points then
		generate_random_toolbox_spells( 1, true )
		was_upgrade_created = true
	end

	-- play the wand sound if at least one upgrade was created
	if was_upgrade_created then
		GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/wand/create", x, y )
	end

    -- incur wand recharge time
    ComponentSetValue2( variablecomp, "value_int", GameGetFrameNum() + cooldown_frames )
	local acomp = EntityGetFirstComponentIncludingDisabled( wand.entity_id, "AbilityComponent" )
	ComponentSetValue2( acomp, "mReloadNextFrameUsable", GameGetFrameNum() + cooldown_frames )
	ComponentSetValue2( acomp, "mReloadFramesLeft", cooldown_frames )
	ComponentSetValue2( acomp, "reload_time_frames", cooldown_frames )
end


-- local points_cached = get_internal_int( entity_id, "d2d_dismantle_points_cached" )
-- if points_cached ~= -1 then
-- 	-- determine how many upgrades the player gets
-- 	local amt_of_upgrades = math.floor( points_cached / 10 )
-- 	local remaining_points = math.floor( points_cached ) % 10
-- 	local was_upgrade_created = false

-- 	if amt_of_upgrades > 0 then
-- 		generate_random_toolbox_spells( amt_of_upgrades, true )
-- 		was_upgrade_created = true
-- 	end
-- 	if remaining_points > 0 and Random( 1, 10 ) <= remaining_points then
-- 		generate_random_toolbox_spells( 1, true )
-- 		was_upgrade_created = true
-- 	end

-- 	-- play the wand sound if at least one upgrade was created
-- 	if was_upgrade_created then
-- 		GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/wand/create", x, y )
-- 	end

--     -- incur wand recharge time
--     ComponentSetValue2( variablecomp, "value_int", GameGetFrameNum() + cooldown_frames )
-- 	local acomp = EntityGetFirstComponentIncludingDisabled( wand.entity_id, "AbilityComponent" )
-- 	ComponentSetValue2( acomp, "mReloadNextFrameUsable", GameGetFrameNum() + cooldown_frames )
-- 	ComponentSetValue2( acomp, "mReloadFramesLeft", cooldown_frames )
-- 	ComponentSetValue2( acomp, "reload_time_frames", cooldown_frames )

-- 	set_internal_int( entity_id, "d2d_dismantle_points_cached", -1 )
-- end