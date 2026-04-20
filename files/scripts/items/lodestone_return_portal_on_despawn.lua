dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

if exists( get_player() ) then
    local px, py = EntityGetTransform( get_player() )
	GamePrintImportant( "The return portal has closed" )
	GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/rune/create", px, py )
end