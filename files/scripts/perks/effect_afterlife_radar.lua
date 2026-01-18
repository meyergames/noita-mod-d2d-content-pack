dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local player_id = EntityGetRootEntity( GetUpdatedEntityID() )
local pos_x, pos_y = EntityGetTransform( player_id )
pos_y = pos_y - 4 -- offset to middle of character

local indicator_distance = 24

local grave_id = EntityGetWithTag( "d2d_afterlife_grave" )[1]
local grave_x, grave_y
if not exists( grave_id ) then
	grave_x = get_internal_float( player_id, "d2d_afterlife_grave_x" )
	grave_y = get_internal_float( player_id, "d2d_afterlife_grave_y" )
else
	grave_x, grave_y = EntityGetTransform( grave_id )
end
if not exists( grave_x ) then return end



local dir_x = grave_x - pos_x
local dir_y = grave_y - pos_y
local distance = get_magnitude(dir_x, dir_y)

-- sprite positions around character
dir_x,dir_y = vec_normalize(dir_x,dir_y)
local indicator_x = pos_x + dir_x * indicator_distance
local indicator_y = pos_y + dir_y * indicator_distance

-- display sprite based on proximity
if distance > 2500 then
	GameCreateSpriteForXFrames( "mods/D2DContentPack/files/particles/radar_grave_faint.png", indicator_x, indicator_y )
elseif distance > 1000 then
	GameCreateSpriteForXFrames( "mods/D2DContentPack/files/particles/radar_grave_medium.png", indicator_x, indicator_y )
elseif distance > 20 then
	GameCreateSpriteForXFrames( "mods/D2DContentPack/files/particles/radar_grave_strong.png", indicator_x, indicator_y )
else
	local grave_detected_frames = get_internal_int( player_id, "d2d_afterlife_grave_detected_frames" )
	if grave_detected_frames and grave_detected_frames >= 15 then
		-- TODO: destroy the effect's Lua components BEFORE destroying the effect itself;
		-- otherwise, the player's death is still triggered
		local effect_id = EntityGetAllChildren( player_id, "d2d_afterlife_effect" )[1]
		local luacomps = EntityGetComponent( effect_id, "LuaComponent" )
		local removed = false
		for i,luacomp in ipairs( luacomps ) do
			EntityRemoveComponent( effect_id, luacomp )
			removed = true
		end

		-- return the player sprite to normal
		local spritecomp_body = EntityGetFirstComponent( player_id, "SpriteComponent" )
		if exists( spritecomp_body ) then
			local image_file = get_internal_string( player_id, "d2d_afterlife_cached_sprite_body" )
			ComponentSetValue2( spritecomp_body, "image_file", image_file )
		end

		local children = EntityGetAllChildren( player_id )
		if exists( children ) then
			for i,child in ipairs( children ) do

				-- make the arm unspooky
				if EntityGetName( child ) == "arm_r" then
					local spritecomp_arm = EntityGetFirstComponent( child, "SpriteComponent" )
					if exists( spritecomp_arm ) then
						local image_file = get_internal_string( player_id, "d2d_afterlife_cached_sprite_arm" )
						ComponentSetValue2( spritecomp_arm, "image_file", image_file )
					end
				end
		
				-- unhide the cape
			    if EntityGetName( child ) == "cape" then
					for i,child_vp_comp in ipairs( EntityGetComponent( child, "VerletPhysicsComponent" ) ) do
						ComponentSetValue2( child_vp_comp, "follow_entity_transform", true )
					end
			    end
			end
		end

		-- destroy the effect and the grave
		if removed then
			EntityKill( effect_id )
			EntityKill( grave_id )
		end
	else
		raise_internal_int( player_id, "d2d_afterlife_grave_detected_frames", 1 )
	end
end
