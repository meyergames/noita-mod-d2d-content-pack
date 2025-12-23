dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
-- local owner = EntityGetParent( entity_id )
local x, y = EntityGetTransform( entity_id )
local owner = EntityGetInRadiusWithTag( x, y, 2, "homing_target" )[1]

local cancel_infatuation = false

-- if the entity is already berserk, don't infatuate them
local berserk_effect = GameGetGameEffect( owner, "BERSERK" )
if berserk_effect ~= 0 then
	cancel_infatuation = true
end

-- give entities a chance to resist infatuation and turn berserk instead, based on their remaining HP
-- local effect_id = GameGetGameEffect( owner, "CHARM" )
local dcomp = EntityGetFirstComponentIncludingDisabled( GetUpdatedEntityID(), "DamageModelComponent" )
if dcomp then
	local hp = ComponentGetValue2( dcomp, "hp" )
	local max_hp = ComponentGetValue2( dcomp, "max_hp" )

	-- creatures with 10 max hp have 5% base chance to resist; creatures with 500+ max hp have 90% base chance to resist
	local base_chance = remap( max_hp, 0.04, 20, 5, 90 )

	-- multiply base chance by 1.0 when at 100% hp, or by 0.1 when at 0% hp
	local percent_chance_to_backfire = remap( ( 1.0 / max_hp ) * hp, 1, 0, base_chance, 0 )

	if Random( 1, 100 ) < percent_chance_to_backfire then
		-- EntityKill( get_child_with_name( owner, "effect_charmed_short_d2d.xml" ) )
		LoadGameEffectEntityTo( owner, "data/entities/misc/effect_berserk.xml" )
		cancel_infatuation = true
	end
end

-- check if there are other infatuated creatures
-- local was_other_charmed = false
local others = EntityGetWithTag( "homing_target" )
if others and #others > 1 then
	for i,other in ipairs( others ) do

		-- don't scan the owner of this script
		if other ~= owner then
			local is_charmed = GameGetGameEffect( other, "CHARM" ) ~= 0
			if is_charmed then

				-- make half of the infatuated creatures turn berserk when a new creature is infatuated
				if other % 5 ~= 0 then
					EntityKill( get_child_with_name( other, "effect_charmed_short_d2d.xml" ) )

					LoadGameEffectEntityTo( other, "data/entities/misc/effect_berserk.xml" )
					-- was_other_charmed = true
				end
			end
		end
	end
end

-- disable bosses from being infatuated
local is_boss = EntityGetComponentIncludingDisabled( owner, "BossHealthBarComponent" )
if is_boss then
	cancel_infatuation = true
end


if cancel_infatuation then
	EntityKill( get_child_with_name( owner, "effect_charmed_short_d2d.xml" ) )
end
