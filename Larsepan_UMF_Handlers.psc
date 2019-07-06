;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; by Larsepan
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Scriptname Larsepan_UMF_Handlers extends Quest  

Faction Property BladesFaction Auto
ReferenceAlias Property FollowerRef1  Auto  
ReferenceAlias Property FollowerRef2  Auto  
ReferenceAlias Property FollowerRef3  Auto 

;Future shared functions home

Actor Function FindReadyActor()
	actor refActor1 = FollowerRef1.GetReference() as actor
	actor refActor2 = FollowerRef2.GetReference() as actor
	actor refActor3 = FollowerRef3.GetReference() as actor
	actor returnActor
	actor backupActor
	if(refActor1)
		If !(refActor1.IsInFaction(BladesFaction))
			if(refActor1.GetActorValue("WaitingforPlayer") == 0)
				returnActor = refActor1
			endIf
			backupActor = refActor1
		endIf
	endIf
	if(refActor2 && !returnActor)
		If !(refActor2.IsInFaction(BladesFaction))
			if(refActor2.GetActorValue("WaitingforPlayer") == 0)
				returnActor = refActor2
			endIf
			backupActor = refActor2
		endIf
	endIf
	if(refActor3 && !returnActor)
		If !(refActor3.IsInFaction(BladesFaction))
			if(refActor3.GetActorValue("WaitingforPlayer") == 0)
				returnActor = refActor3
			endIf
			backupActor = refActor3
		endIf
	endIf
	if(!returnActor)
		returnActor = backupActor
	endIf	

	Return returnActor
EndFunction
