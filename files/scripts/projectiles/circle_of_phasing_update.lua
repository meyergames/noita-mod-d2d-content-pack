dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local LIFETIME = 1200 -- 20 seconds

local entity_id = GetUpdatedEntityID()
if not exists( entity_id ) then return end
local x, y = EntityGetTransform( entity_id )

function is_left_blocked( player )
	local hitboxes = EntityGetComponent( player, "HitboxComponent" )
	if exists( hitboxes ) then
		for i,hitbox in ipairs( hitboxes ) do

		end
	end
end

local spawn_frame = get_internal_int( entity_id, "d2d_circle_of_phasing_spawn_frame" )
if not spawn_frame or spawn_frame > GameGetFrameNum() then
	set_internal_int( entity_id, "d2d_circle_of_phasing_spawn_frame", GameGetFrameNum() )
end
local frames_since_spawn = GameGetFrameNum() - spawn_frame
local radius = 32 + math.floor( frames_since_spawn / 150.0 ) -- increase to 40 over time, to help with un-stucking

local nearby_players = EntityGetInRadiusWithTag( x, y, radius, "player_unit" )
if exists( nearby_players ) then
	for i,player in ipairs( nearby_players ) do
		local ctrlcomp = EntityGetFirstComponentIncludingDisabled( player, "ControlsComponent" )
		local cplatcomp = EntityGetFirstComponentIncludingDisabled( player, "CharacterPlatformingComponent" )
		local cdatacomp = EntityGetFirstComponentIncludingDisabled( player, "CharacterDataComponent" )
		if exists( ctrlcomp ) and exists( cplatcomp ) and exists( cdatacomp ) then
			local px, py = EntityGetTransform( player )
			local prev_x = get_internal_float( player, "d2d_circle_of_phasing_prev_x" )
			local prev_y = get_internal_float( player, "d2d_circle_of_phasing_prev_y" )

			local go_left = ComponentGetValue2( ctrlcomp, "mButtonDownLeft" )
			local go_right = ComponentGetValue2( ctrlcomp, "mButtonDownRight" )
			local go_up = ComponentGetValue2( ctrlcomp, "mButtonDownUp" )
			local go_down = ComponentGetValue2( ctrlcomp, "mButtonDownDown" )
			local jump = 0.668 * 2 -- run_velocity (40) * 0.167 --> * 2 because it checks for prev_x every frame
			
			-- if the player cannot move horizontally, try noclipping
			if prev_x and math.abs( px - prev_x ) < 0.1 then
				if go_left then
					EntityApplyTransform( player, px - jump, py )
				elseif go_right then
					EntityApplyTransform( player, px + jump, py )
				end
			end

			-- same but vertically
			if prev_y and math.abs( py - prev_y ) < 0.1 then
				if go_up then
					EntityApplyTransform( player, px, py - jump )
				elseif go_down then
					EntityApplyTransform( player, px, py + jump )
				end
			end

			-- store this frame's x y for next frame's check
			set_internal_float( player, "d2d_circle_of_phasing_prev_x", px )
			set_internal_float( player, "d2d_circle_of_phasing_prev_y", py )

			-- reset changed variables after leaving the circle
			local comp_applied = get_internal_bool( player, "d2d_circle_of_phasing_applied" )
			if not comp_applied then
				EntityAddComponent2( player, "LuaComponent", {
					script_source_file = "mods/D2DContentPack/files/scripts/projectiles/circle_of_phasing_player_reset.lua",
					execute_every_n_frame = 1,
				})
				set_internal_bool( player, "d2d_circle_of_phasing_applied", true )
			end
			local reset_delay = get_internal_int( player, "d2d_circle_of_phasing_reset_delay" )
			if not reset_delay or reset_delay == 0 then
				make_player_spooky( player )
			end
			set_internal_int( player, "d2d_circle_of_phasing_reset_delay", 2 )

			-- if the circle has been active for a while, starting dealing damage
			-- proportional to the player's max hp to discourage them from using the circle too much
			local dmg_tick_speed = get_internal_int( player, "d2d_circle_of_phasing_damage_tick_speed" )
			if not dmg_tick_speed then
				dmg_tick_speed = 60
			end
			if GameGetFrameNum() % dmg_tick_speed == 0 then
				local curse_count = tonumber( GlobalsGetValue( "PLAYER_CURSE_COUNT", "0" ) )
				set_internal_int( player, "d2d_circle_of_phasing_damage_tick_speed", math.max( dmg_tick_speed - 2, curse_count ) )
				local dmg_comp = EntityGetFirstComponentIncludingDisabled( player, "DamageModelComponent" )
				if exists( dmg_comp ) then
					local p_hp = ComponentGetValue2( dmg_comp, "hp" )
					local p_max_hp = ComponentGetValue2( dmg_comp, "max_hp" )
					local dps = p_max_hp * 0.1
					EntityInflictDamage( player, math.min( dps / 60.0, p_hp - 0.04 ), "DAMAGE_CURSE", "circle of spooky", "NONE", 0, 0, player )
				end
			end
		end
	end
end



local nearby_projs = EntityGetInRadiusWithTag( x, y, radius, "projectile" )
if exists( nearby_projs ) then
	for i,proj_id in ipairs( nearby_projs ) do
		if proj_id ~= entity_id then
			local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
			if exists( proj_comp ) then
				local proj_already_phased = get_internal_bool( proj_id, "d2d_circle_of_phasing_applied" )
				if not proj_already_phased then
					EntityAddComponent2( proj_id, "LuaComponent", {
						script_source_file = "mods/D2DContentPack/files/scripts/projectiles/circle_of_phasing_proj_reset.lua",
						execute_every_n_frame = 1,
					})

					set_internal_bool( proj_id, "d2d_circle_of_phasing_init_cww", ComponentGetValue2( proj_comp, "collide_with_world" ) )
					set_internal_bool( proj_id, "d2d_circle_of_phasing_init_cwe", ComponentGetValue2( proj_comp, "collide_with_entities" ) )
					set_internal_bool( proj_id, "d2d_circle_of_phasing_applied", true )
					local sprite_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "SpriteComponent" )
					if exists( sprite_comp ) then
						local init_alpha = ComponentGetValue2( sprite_comp, "alpha" )
						set_internal_float( proj_id, "d2d_circle_of_phasing_init_alpha", init_alpha )
					end
				end

				ComponentSetValue2( proj_comp, "collide_with_world", false )
				ComponentSetValue2( proj_comp, "collide_with_entities", false )
				set_internal_int( proj_id, "d2d_circle_of_phasing_reset_delay", 2 )

				local sprite_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "SpriteComponent" )
				if exists( sprite_comp ) then
					ComponentSetValue2( sprite_comp, "alpha", 0.05 )
				end
				local particle_comps = EntityGetComponentIncludingDisabled( proj_id, "ParticleEmitterComponent" )
				if exists( particle_comps ) then
					for i,particle_comp in ipairs( particle_comps ) do
						ComponentSetValue2( particle_comp, "custom_alpha", 0.05 )
					end
				end
				local sparticle_comps = EntityGetComponentIncludingDisabled( proj_id, "SpriteParticleEmitterComponent" )
				if exists( sparticle_comps ) then
					for i,sparticle_comp in ipairs( sparticle_comps ) do
						ComponentSetValue2( sparticle_comp, "mNextEmitFrame", GameGetFrameNum() + 2 )
					end
				end
			end
		end
	end
end

