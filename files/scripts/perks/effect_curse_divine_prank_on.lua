dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )

addNewInternalVariable( owner, "divine_prank_safety_counter", "value_int", 0 )
addNewInternalVariable( owner, "divine_prank_cooldown_time", "value_int", 300 )
addNewInternalVariable( owner, "divine_prank_message_delay_time", "value_int", 0 )
-- addNewInternalVariable( owner, "divine_prank_propane_effect_id", "value_int", 0 )
addNewInternalVariable( owner, "divine_prank_enable_propane_effect", "value_int", 0 )
addNewInternalVariable( owner, "divine_prank_gods_are_fake_angry", "value_int", 0 )
-- addNewInternalVariable( owner, "divine_prank_print_cooldown_time", "value_int", 0 )

addNewInternalVariable( owner, "divine_prank_gods_angry_prank_triggered", "value_int", 0 )
addNewInternalVariable( owner, "divine_prank_propane_prank_triggered", "value_int", 0 )
addNewInternalVariable( owner, "divine_prank_polymorph_prank_triggered", "value_int", 0 )
