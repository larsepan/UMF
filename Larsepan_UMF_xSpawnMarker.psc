Scriptname Larsepan_UMF_xSpawnMarker extends ObjectReference  

Actor property playerRef auto
;I used the below reference for detecting player cell change
;https://www.creationkit.com/index.php?title=Detect_Player_Cell_Change_(Without_Polling)
Event OnCellDetach()
	Utility.Wait(0.1)
	MoveTo(playerRef)
 EndEvent
