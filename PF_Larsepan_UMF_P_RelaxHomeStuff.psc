;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname PF_Larsepan_UMF_P_RelaxHomeStuff Extends Package Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(Actor akActor)
;BEGIN CODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; by Larsepan
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	actor refActor1 = FollowerRef1.GetReference() as actor
	actor refActor2 = FollowerRef2.GetReference() as actor
	actor refActor3 = FollowerRef3.GetReference() as actor
	if (akActor == refActor1 || akActor == refActor2 || akActor == refActor3)
		akActor.UnequipItemSlot(30)
		akActor.UnequipItemSlot(31)
	endIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property FollowerRef1  Auto  

ReferenceAlias Property FollowerRef2  Auto  

ReferenceAlias Property FollowerRef3  Auto  
