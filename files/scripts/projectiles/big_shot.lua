dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local MAX_FRAMES = 1800

local proj_id = GetUpdatedEntityID()

local last_frame_used = get_internal_int( get_player(), "d2d_big_shot_last_frame_used" )
if not exists( last_frame_used ) then last_frame_used = 0 end
local frames_since_last_use = GameGetFrameNum() - last_frame_used
local mtp = remap( frames_since_last_use, 0, MAX_FRAMES, 1.0, 4.0 )

multiply_proj_dmg( proj_id, mtp, "damage_mult" )
set_internal_int( get_player(), "d2d_big_shot_last_frame_used", GameGetFrameNum() )
-- using "get_player()" as a global here, since I'd otherwise have to fetch the spell card from here



-- play a sound effect based on how charged the shot was
local x, y = EntityGetTransform( proj_id )
if frames_since_last_use >= MAX_FRAMES then
	GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/black_hole_big/create", x, y )
elseif frames_since_last_use >= ( MAX_FRAMES / 2 ) then
	GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/black_hole/create", x, y )
end
