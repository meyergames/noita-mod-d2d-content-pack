dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local staff_id = GetUpdatedEntityID()
local parent_id = EntityGetRootEntity( staff_id )
local x, y = EntityGetTransform( staff_id )

-- check if the staff has a bind id
local s_bind_id = get_internal_int( staff_id, "d2d_staff_of_curses_bind_id" )
if exists( s_bind_id ) then
	-- check if the parent is a player
	if not EntityHasTag( parent_id, "player_unit" ) then
		-- find the player with matching bind id
		local nearby_players = EntityGetWithTag( "player_unit" )
		if exists( nearby_players ) then
			for i,player in ipairs( nearby_players ) do
				local p_bind_id = get_internal_int( player, "d2d_staff_of_curses_bind_id" )
				-- if found, equip it
				if exists( p_bind_id ) and p_bind_id == s_bind_id then
					local dmg_comp = EntityGetFirstComponentIncludingDisabled( player, "DamageModelComponent" )
					if exists( dmg_comp ) then
						local p_hp = ComponentGetValue2( dmg_comp, "hp" )
						local p_max_hp = ComponentGetValue2( dmg_comp, "max_hp" )
						local dmg = math.min( p_max_hp * 0.05, p_hp - 0.04 )
						EntityInflictDamage( player, dmg, "DAMAGE_CURSE", "staff of curses", "NONE", 0, 0, staff_id, x, y, 0 )
						GamePrint( "The staff did not appreciate that." )
					end

					-- if the player's wand inv is full, drop the first wand to make space for it
					local held_wands = get_all_wands( player )
					if #held_wands == 4 then
						-- select the first unequipped wand
						local wand_to_drop = held_wands[1]
						if wand_to_drop == EZWand.GetHeldWand().entity_id then
							wand_to_drop = held_wands[2]
						end

						if wand_to_drop then
							-- remove the wand from the parent (player)
							EntityRemoveFromParent( wand_to_drop )
							-- disable its non-enabled_in_world components
							for i,comp in ipairs( EntityGetAllComponents( wand_to_drop ) ) do
								EntitySetComponentIsEnabled( wand_to_drop, comp, ComponentHasTag( comp, "enabled_in_world" ) )
							end
							-- then set the wand's position to the player's
							local px, py = EntityGetTransform( player )
							EntitySetTransform( wand_to_drop, px, py )
						end
					end

					local wand = EZWand( staff_id )
					wand:PutInPlayersInventory()
				end
			end
		end
	end
else
	local nearby_player_count = #EntityGetInRadiusWithTag( x, y, 100, "player_unit" )
	if nearby_player_count == 0 then
		local players = EntityGetWithTag( "player_unit" )

		if exists( players ) then
			for i,player in ipairs( players ) do
				if distance_between( player, staff_id ) > 100 then
					local is_obliteration = EntityHasTag( staff_id, "d2d_staff_of_obliteration" )
					on_staff_of_curses_picked_up( staff_id, player, is_obliteration )
				end
			end
		end
	end
end
