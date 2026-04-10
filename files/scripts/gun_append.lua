local __draw_actions_for_shot = _draw_actions_for_shot
_draw_actions_for_shot = function(...)
	local me = GetUpdatedEntityID()
	local vscs = EntityGetComponent(me, "VariableStorageComponent") or {}
	for _, vsc in ipairs(vscs) do
		if ComponentGetValue2(vsc, "name") ~= "alt_fire_cause" then goto continue end
		local frame = ComponentGetValue2(vsc, "value_int")
		if frame ~= GameGetFrameNum() - 1 then
			EntityRemoveComponent(me, vsc)
			goto continue
		end
		local cause = ComponentGetValue2(vsc, "value_string")
		if cause == "alt_fire" then
			while #deck > 0 do
				local data = deck[1]
				table.insert(discarded, data)
				table.remove(deck, 1)
				if data.id == "D2D_ALT_FIRE_ANYTHING" then break end
			end
		else
			error("unknown cause of alt fire")
		end
		EntityRemoveComponent(me, vsc)
		::continue::
	end

	local ret = { __draw_actions_for_shot(...) }
	local piles = { discarded, hand, deck }
	for _, pile in ipairs(piles) do
		local i = 1
		while i <= #pile do
			local data = pile[i]
			---@diagnostic disable-next-line: undefined-field
			if data.in_fake_hand then
				---@diagnostic disable-next-line: inject-field
				data.in_fake_hand = nil
				table.remove(pile, i)
				table.insert(deck, 1, data)
			else
				i = i + 1
			end
		end
	end

	return unpack(ret)
end

local _move_hand_to_discarded = move_hand_to_discarded
move_hand_to_discarded = function(...)
	local i = 1
	while i <= #hand do
		local data = hand[i]
		---@diagnostic disable-next-line: undefined-field
		if data.in_fake_hand then
			---@diagnostic disable-next-line: inject-field
			data.in_fake_hand = nil
			table.remove(hand, i)
			table.insert(deck, 1, data)
		else
			i = i + 1
		end
	end
	return _move_hand_to_discarded(...)
end

-- local _order_deck = order_deck
-- order_deck = function()

-- 	GamePrint( "order!" )
-- 	_order_deck()
-- end

local _order_deck = order_deck
order_deck = function()
	if reflecting then return end
	
	if GlobalsGetValue( "d2d_try_stabilize_wand" ) == "true" and Random( 1, 100 ) > 1 then
		-- temporarily set the wand to its opposite shuffle setting
		gun.shuffle_deck_when_empty = not gun.shuffle_deck_when_empty

		_order_deck()

		-- reset the wand's shuffle setting
		gun.shuffle_deck_when_empty = not gun.shuffle_deck_when_empty
	else
		_order_deck()
	end
end

local _play_action = play_action
play_action = function( action )
	if not action.skip then
		_play_action( action )
	end
end