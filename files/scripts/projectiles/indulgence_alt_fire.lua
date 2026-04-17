dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
local wand = EZWand(EntityGetParent(entity_id))
local x, y = EntityGetTransform(entity_id)
local controlscomp = EntityGetFirstComponent(root, "ControlsComponent")
local cooldown_frames = 20
local actionid = "action_D2D_indulgence_alt_fire"
local cooldown_frame
local variablecomp = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
cooldown_frame = ComponentGetValue2( variablecomp, "value_int" )
local aim_x, aim_y = ComponentGetValue2(controlscomp, "mAimingVectorNormalized")
-- local manacost = 40

if is_alt_fire_pressed() and GameGetFrameNum() >= cooldown_frame then
	local spells, always_casts = wand:GetSpells()
	local indulgence_index = -1
	-- loop through all spells behind Indulgence; the first spell with less-than-max uses is selected,
	-- and if the player has enough money, gains a use.
	for i,spell in ipairs( spells ) do
		if spell.action_id == "D2D_INDULGENCE_ALT_FIRE" and i ~= #spells then -- i.e. if it's not the last spell
			indulgence_index = i
		elseif indulgence_index > -1 then
			local icomp = EntityGetFirstComponentIncludingDisabled( spells[i].entity_id, "ItemComponent" )
			if icomp ~= nil then
				-- if the spell doesn't have limited uses, skip
			    local uses_remaining = ComponentGetValue2( icomp, "uses_remaining" )
				if uses_remaining > -1 then

					-- determine the spell's max uses
					local max_uses = -1
					local lua_data = get_actions_lua_data( spells[i].action_id )
					if lua_data.max_uses then
						max_uses = lua_data.max_uses
					end

					-- does the spell even need more uses?
					if uses_remaining < max_uses then

						-- how much money does the player have?
						local player = get_player()
						local wcomp = EntityGetFirstComponent( player, "WalletComponent" )
						if not exists( wcomp ) then return end
						local money = ComponentGetValue2( wcomp, "money" )

						-- determine the cost for this spell
						local cast_price
						if spells[i].action_id == "DIVIDE_10" then
							cast_price = 1000
						elseif max_uses <= 2 then -- i.e. Circle of Vigour
							cast_price = 500
						elseif max_uses <= 5 then -- i.e. Black Hole
							cast_price = 100
						elseif max_uses <= 10 then
							cast_price = 50
						elseif max_uses <= 20 then
							cast_price = 20
						else
							cast_price = 10
						end
						if lua_data.never_unlimited then cast_price = cast_price * 2 end

						-- increase price if gods are angry
						if not has_perk( "PEACE_WITH_GODS" ) then
							local stevari_deaths = tonumber( GlobalsGetValue( "STEVARI_DEATHS", "0" ) )
							if stevari_deaths >= 3 then
								cast_price = cast_price * 2
							elseif stevari_deaths >= 1 then
								cast_price = cast_price * 1.5
							end
						end

						-- increase price further based on past indulgence
						if money >= cast_price then
							raise_internal_int( get_player(), "d2d_indulgence_money_spent_pre_scaling", cast_price )
						end
						local money_spent = get_internal_int( get_player(), "d2d_indulgence_money_spent_pre_scaling" )
						cast_price = math.floor( cast_price * ( 1.0 + ( money_spent * 0.00001 ) ) )

						-- give the spell a charge and incur its cost
						local spell_name = GameTextGetTranslatedOrNot( lua_data.name )
						if money >= cast_price then
							ComponentSetValue2( icomp, "uses_remaining", math.min( uses_remaining + 1, max_uses ) )
							ComponentSetValue2( wcomp, "money", money - cast_price )

							local msg = "+1 " .. spell_name .. " (cost " .. cast_price .. " gold)"
							GamePrint( msg )
							shoot_projectile( spells[i].entity_id, "data/entities/particles/gold_pickup.xml", x, y, 0, 0 )
							GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/goldnugget/create", x, y )

						    ComponentSetValue2( variablecomp, "value_int", GameGetFrameNum() + cooldown_frames )
							trigger_wand_refresh( wand, cooldown_frames )

						    break
						else
							GamePrint( "Not enough money for " .. spell_name .. " (cost: " .. cast_price .. ")" )
					        GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/out_of_mana", x, y )
					    	ComponentSetValue2( variablecomp, "value_int", GameGetFrameNum() + cooldown_frames )
						end
					end
				end
			end
		end
	end
end
