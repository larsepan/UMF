Scriptname Larsepan_UMF_UpdateSpawnLocation extends activemagiceffect  

Actor property playerRef auto
ObjectReference property xSpawnMarker auto
;I used the below reference for detecting player cell change
;https://www.creationkit.com/index.php?title=Detect_Player_Cell_Change_(Without_Polling)
Event OnEffectStart(Actor akTarget, Actor akCaster)
   Utility.Wait(0.1) ; Required.
   xSpawnMarker.MoveTo(playerRef)
EndEvent
