dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local proj_id = EntityGetRootEntity( entity_id )
if exists( proj_id ) then

	local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
	if exists( proj_comp ) then

		local action_id = GameTextGetTranslatedOrNot( ComponentObjectGetValue2( proj_comp, "config", "action_id" ) )
		if exists( action_id ) then
			if action_id == "D2D_BANANA_BOMB" then
				EntityAddComponent2( entity_id, "LuaComponent", 
				{
					script_source_file = "mods/D2DContentPack/files/scripts/projectiles/banana_bomb_spawn_heal_aura.lua",
					execute_every_n_frame = -1,
					execute_on_removed = true,
				} )
			elseif action_id == "D2D_BANANA_BOMB_SUPER" then
				EntityAddComponent2( entity_id, "LuaComponent", 
				{
					script_source_file = "mods/D2DContentPack/files/scripts/projectiles/banana_bomb_spawn_heal_aura_super.lua",
					execute_every_n_frame = -1,
					execute_on_removed = true,
				} )
			elseif action_id == "D2D_BANANA_BOMB_GIGA" then
				EntityAddComponent2( entity_id, "LuaComponent", 
				{
					script_source_file = "mods/D2DContentPack/files/scripts/projectiles/banana_bomb_spawn_heal_aura_giga.lua",
					execute_every_n_frame = -1,
					execute_on_removed = true,
				} )
			end
		end
	end
end