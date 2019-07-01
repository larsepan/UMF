;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname Larsepan_UMF__000E26F9 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Larsepan
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; don't dismiss the follower again if I've already dismissed them
If !(akspeaker.IsInFaction(DismissedFollowerFaction))
  (pDialogueFollower as DialogueFollowerScript).LarsepanDismissFollower(0, 0, akSpeaker)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

quest Property pDialogueFollower  Auto  

Faction Property DismissedFollowerFaction  Auto  
