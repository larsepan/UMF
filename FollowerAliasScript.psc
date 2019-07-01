ScriptName FollowerAliasScript extends ReferenceAlias

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Larsepan edits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DialogueFollowerScript Property DialogueFollower Auto
Faction Property CurrentHirelingFaction Auto
GlobalVariable Property gNotif  Auto  
GlobalVariable Property PlayerFollowerCount  Auto  


Event OnUpdateGameTime()
	
	;UMF 1.4.3 REMOVED 3 DAY WAIT TIMER
	actor fRef = Self.GetActorReference()
	;kill the update if the follower isn't waiting anymore
	if(fRef)
		If fRef.GetActorValue("WaitingforPlayer") == 0
			UnRegisterForUpdateGameTime()
		Else
		;	debug.trace(self + "Dismissing the follower because he is waiting and 3 days have passed.")
			DialogueFollower.LarsepanDismissFollower(5, 0, fRef )
			UnRegisterForUpdateGameTime()
		EndIf
	endIf
	
EndEvent

Event OnUnload()
	actor fRef = Self.GetActorReference()
	;if follower unloads while waiting for the player, wait three days then dismiss him.
	If fRef.GetActorValue("WaitingforPlayer") == 1
		(GetOwningQuest() as DialogueFollowerScript).LarsepanFollowerWait(fRef)
	EndIf

EndEvent

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	actor fRef = Self.GetActorReference()
	If (akTarget == Game.GetPlayer())
; 		debug.trace(self + "Dismissing follower because he is now attacking the player")
		(GetOwningQuest() as DialogueFollowerScript).LarsepanDismissFollower(0, 0, fRef)
	EndIf

EndEvent

Event OnDeath(Actor akKiller)
; 	debug.trace(self + "Clearing the follower because the player killed him.")
	float notif = gNotif.GetValue()
	float count = PlayerFollowerCount.GetValue()
	int iCount = count as int
	;;;;
	PlayerFollowerCount.Mod(-count)	
	iCount -=1
	count = iCount as float
	if(iCount < 1 )
		PlayerFollowerCount.SetValue(0)
		iCount = 0
	else
		PlayerFollowerCount.Mod(count)
	endIf
	if(notif == 1)
		debug.notification(iCount + "/3 followers")				
		;debug.notification("PlayerFollowerCount has been set to " + iCount + ".")	
	endIf
	;;;;
	
	Self.GetActorRef().RemoveFromFaction(CurrentHirelingFaction)
	Self.Clear()
	
EndEvent
