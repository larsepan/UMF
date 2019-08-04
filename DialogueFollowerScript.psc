;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Larsepan
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ScriptName DialogueFollowerScript extends Quest Conditional

GlobalVariable Property pPlayerFollowerCount Auto
GlobalVariable Property pPlayerAnimalCount Auto
GlobalVariable Property gNotif  Auto
GlobalVariable Property gFriendAgg Auto
FormList Property UMFList  Auto  
ReferenceAlias Property pFollowerAlias Auto
ReferenceAlias Property pFollowerAlias2  Auto  
ReferenceAlias Property pFollowerAlias3  Auto  
ReferenceAlias property pAnimalAlias Auto
ReferenceAlias property pAnimalAlias2 Auto
ReferenceAlias property pAnimalAlias3 Auto
Faction Property pDismissedFollower Auto
Faction Property pCurrentHireling Auto
Faction Property UMFfriendsFaction Auto
Message Property  FollowerDismissMessage Auto
Message Property AnimalDismissMessage Auto
Message Property  FollowerDismissMessageWedding Auto
Message Property  FollowerDismissMessageCompanions Auto
Message Property  FollowerDismissMessageCompanionsMale Auto
Message Property  FollowerDismissMessageCompanionsFemale Auto
Message Property  FollowerDismissMessageWait Auto
SetHirelingRehire Property HirelingRehireScript Auto


;Property to tell follower to say dismissal line
Int Property iFollowerDismiss Auto Conditional

; PATCH 1.9: 77615: remove unplayable hunting bow when follower is dismissed
Weapon Property FollowerHuntingBow Auto
Ammo Property FollowerIronArrow Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SET-FOLLOWER edits
;no need for two functions
;parameter includes actor for call
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function SetFollower(ObjectReference FollowerRef)

	actor refActor1 = pFollowerAlias.GetReference() as actor
	actor refActor2 = pFollowerAlias2.GetReference() as actor
	actor refActor3 = pFollowerAlias3.GetReference() as actor
	float ignoreCheck = gFriendAgg.GetValue()
	actor FollowerActor = FollowerRef as Actor
	float count = pPlayerFollowerCount.GetValue()
	int iCount
	float notif = gNotif.GetValue()
	

	;FollowerActor.SetActorValue("Morality", 0)
	
	if(refActor3 != none)
		iCount += 1
	endIf
	if(refActor2 != none)
		iCount += 1
	endIf
	if(refActor1 != none)
		iCount += 1
	endIf
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; search for unassigned alias and place
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	if(refActor1 == none)
		pFollowerAlias.ForceRefTo(FollowerActor)
;		if(notif == 1)
;			debug.notification("Follower set to Follower1 alias.")
;		endIf
		refActor1 = FollowerActor
	elseIf(refActor2 == none)
		pFollowerAlias2.ForceRefTo(FollowerActor)
;		if(notif == 1)
;			debug.notification("Follower set to Follower2 alias.")
;		endIf
		refActor2 = FollowerActor
	elseIf(refActor3 == none)
		pFollowerAlias3.ForceRefTo(FollowerActor)
;		if(notif == 1)
;			debug.notification("Follower set to Follower3 alias.")
;		endIf
		refActor3 = FollowerActor
	else ;either the count is off or there is a duplicate actor in the aliases
	
		LarsepanCorrectFollowers()
		if(refActor1 == none)
			pFollowerAlias.ForceRefTo(FollowerActor)
;			if(notif == 1)
;				debug.notification("Follower set to Follower1 alias.")
;			endIf
			refActor1 = FollowerActor
		elseIf(refActor2 == none)
			pFollowerAlias2.ForceRefTo(FollowerActor)
;			if(notif == 1)
;				debug.notification("Follower set to Follower2 alias.")
;			endIf
			refActor2 = FollowerActor
		elseIf(refActor3 == none)
			pFollowerAlias3.ForceRefTo(FollowerActor)
;			if(notif == 1)
;				debug.notification("Follower set to Follower3 alias.")
;			endIf
		else
			if(notif == 1)
				debug.notification("Count Error: You already have three followers.")
			endIf																													  
			Return
		endIf
	endIf
	iCount += 1
	FollowerActor.RemoveFromFaction(pDismissedFollower)
	If FollowerActor.GetRelationshipRank(Game.GetPlayer()) < 3 && FollowerActor.GetRelationshipRank(Game.GetPlayer()) >= 0
		FollowerActor.SetRelationshipRank(Game.GetPlayer(), 3)
	EndIf
	FollowerActor.SetPlayerTeammate()
	FollowerActor.EvaluatePackage()
	if(ignoreCheck == 1)
		FollowerActor.IgnoreFriendlyHits(true)	
	endIf
	If !(FollowerActor.IsInFaction(UMFfriendsFaction))
		FollowerActor.AddtoFaction(UMFfriendsFaction)
		UMFList.AddForm(FollowerActor)
	endIf
	pPlayerFollowerCount.Mod(-count)
	pPlayerFollowerCount.Mod(iCount)
	if(notif == 1)
		debug.notification(iCount + "/3 followers")	
	endIf

EndFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SET-ANIMAL edits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function SetAnimal(ObjectReference AnimalRef)

	actor refActor1 = pAnimalAlias.GetReference() as actor
	actor refActor2 = pAnimalAlias2.GetReference() as actor
	actor refActor3 = pAnimalAlias3.GetReference() as actor
	float ignoreCheck = gFriendAgg.GetValue()
	;actor fol1 = pFollowerAlias.GetReference() as actor
	;actor fol2 = pFollowerAlias2.GetReference() as actor
	;actor fol3 = pFollowerAlias3.GetReference() as actor
	actor AnimalActor = AnimalRef as Actor
	float count = pPlayerAnimalCount.GetValue()
	int iCount
	float notif = gNotif.GetValue()
	
	if(refActor3 != none)
		iCount += 1
	endIf
	if(refActor2 != none)
		iCount += 1
	endIf
	if(refActor1 != none)
		iCount += 1
	endIf
	
	if(refActor1 == none)
		pAnimalAlias.ForceRefTo(AnimalActor)
;		if(notif == 1)
;			debug.notification("Follower set to Follower1 alias.")
;		endIf
		refActor1 = AnimalActor
	elseIf(refActor2 == none)
		pAnimalAlias2.ForceRefTo(AnimalActor)
;		if(notif == 1)
;			debug.notification("Follower set to Follower2 alias.")
;		endIf
		refActor2 = AnimalActor
	elseIf(refActor3 == none)
		pAnimalAlias3.ForceRefTo(AnimalActor)
;		if(notif == 1)
;			debug.notification("Follower set to Follower3 alias.")
;		endIf
		refActor3 = AnimalActor
	else ;either the count is off or there is a duplicate actor in the aliases
	
		LarsepanCorrectAnimals()
		if(refActor1 == none)
			pAnimalAlias.ForceRefTo(AnimalActor)
;			if(notif == 1)
;				debug.notification("Follower set to Follower1 alias.")
;			endIf
			refActor1 = AnimalActor
		elseIf(refActor2 == none)
			pAnimalAlias2.ForceRefTo(AnimalActor)
;			if(notif == 1)
;				debug.notification("Follower set to Follower2 alias.")
;			endIf
			refActor2 = AnimalActor
		elseIf(refActor3 == none)
			pAnimalAlias3.ForceRefTo(AnimalActor)
;			if(notif == 1)
;				debug.notification("Follower set to Follower3 alias.")
;			endIf
		else
			if(notif == 1)
				debug.notification("Count Error: You already have three followers.")
			endIf	
			Return
		endIf
	endIf
	iCount += 1
	;don't allow lockpicking
	AnimalActor.SetActorValue("Lockpicking", 0)
	AnimalActor.SetRelationshipRank(Game.GetPlayer(), 3)
	AnimalActor.SetPlayerTeammate(abCanDoFavor = false)	
	AnimalActor.EvaluatePackage()
	if(ignoreCheck == 1)
		AnimalActor.IgnoreFriendlyHits(true)	
	endIf
	If !(AnimalActor.IsInFaction(UMFfriendsFaction))
		AnimalActor.AddtoFaction(UMFfriendsFaction)
		UMFList.AddForm(AnimalActor)
	endIf
	;AnimalActor.AllowPCDialogue(True)
	pPlayerAnimalCount.Mod(-count)
	pPlayerAnimalCount.Mod(iCount)
	if(notif == 1)	
		debug.notification(iCount + "/3 animals")	
	endIf
	
EndFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;FOLLOWER-WAIT - first function is for default with no actor argument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function FollowerWait()

	;This function will be called by the commands menu
	;This is a failsafe function for unexpected calls
	
	actor refActor1 = pFollowerAlias.GetReference() as actor
	actor refActor2 = pFollowerAlias2.GetReference() as actor
	actor refActor3 = pFollowerAlias3.GetReference() as actor
	float notif = gNotif.GetValue()
	
	if(refActor1 != none)
		if (refActor1.GetActorValue("WaitingforPlayer") == 0)
			refActor1.SetActorValue("WaitingForPlayer", 1)
			pFollowerAlias.RegisterForUpdateGameTime(72)
		endIf
	endIf
	if(refActor2 != none)
		if (refActor2.GetActorValue("WaitingforPlayer") == 0)
			refActor2.SetActorValue("WaitingForPlayer", 1)
			pFollowerAlias2.RegisterForUpdateGameTime(72)
		endIf
	endIf
	if(refActor3 != none)
		if (refActor3.GetActorValue("WaitingforPlayer") == 0)
			refActor3.SetActorValue("WaitingForPlayer", 1)
			pFollowerAlias3.RegisterForUpdateGameTime(72)
		endIf
	endIf
		
	;SetObjectiveDisplayed(10, abforce = true)
	;all followers will wait 3 days
	
	;if(notif == 1)
	;	debug.notification("Multiple followers may follow this command due to default FollowerWait function.")
	;endIf

EndFunction

Function LarsepanFollowerWait(ObjectReference FollowerRef)

	actor refActor1 = pFollowerAlias.GetReference() as actor
	actor refActor2 = pFollowerAlias2.GetReference() as actor
	actor refActor3 = pFollowerAlias3.GetReference() as actor
	actor FollowerActor = FollowerRef as actor
	FollowerActor.SetActorValue("WaitingForPlayer", 1)
	;SetObjectiveDisplayed(10, abforce = true)
	;follower will wait 3 days
	
	;if you tell this actor, in person, to wait, they will wait there indefinitely
	if(refActor1 == FollowerActor)
			pFollowerAlias.RegisterForUpdateGameTime(72)
	elseIf(refActor2 == FollowerActor)
			pFollowerAlias2.RegisterForUpdateGameTime(72)
	elseIf(refActor3 == FollowerActor)
			pFollowerAlias3.RegisterForUpdateGameTime(72)
	endIf

EndFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ANIMAL-WAIT 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function AnimalWait()

	;This function will be called by the commands menu
	;It also might be called by a custom follower
	actor refActor1 = pAnimalAlias.GetReference() as actor
	actor refActor2 = pAnimalAlias2.GetReference() as actor
	actor refActor3 = pAnimalAlias3.GetReference() as actor
	float notif = gNotif.GetValue()
	
	if(refActor1 != none)
		if (refActor1.GetActorValue("WaitingforPlayer") == 0)
			refActor1.SetActorValue("WaitingForPlayer", 1)
			pFollowerAlias.RegisterForUpdateGameTime(72)
		endIf
	endIf
	if(refActor2 != none)
		if (refActor2.GetActorValue("WaitingforPlayer") == 0)
			refActor2.SetActorValue("WaitingForPlayer", 1)
			pFollowerAlias2.RegisterForUpdateGameTime(72)
		endIf
	endIf
	if(refActor3 != none)
		if (refActor3.GetActorValue("WaitingforPlayer") == 0)
			refActor3.SetActorValue("WaitingForPlayer", 1)
			pFollowerAlias3.RegisterForUpdateGameTime(72)
		endIf
	endIf
		
	;SetObjectiveDisplayed(10, abforce = true)
	;all followers will wait 3 days
	;if(notif == 1)
	;	debug.notification("Multiple animals may follow this command due to default FollowerWait function.")
	;endIf
	
EndFunction

Function LarsepanAnimalWait(ObjectReference FollowerRef)

	actor refActor1 = pAnimalAlias.GetReference() as actor
	actor refActor2 = pAnimalAlias2.GetReference() as actor
	actor refActor3 = pAnimalAlias3.GetReference() as actor
	actor AnimalActor = FollowerRef as actor
	AnimalActor.SetActorValue("WaitingForPlayer", 1)
	;SetObjectiveDisplayed(20, abforce = true)
	
	;if you tell this actor, in person, to wait, they will wait there indefinitely
	if(refActor1 == AnimalActor)
		pAnimalAlias.RegisterForUpdateGameTime(72)
	elseIf(refActor2 == AnimalActor)
		pAnimalAlias2.RegisterForUpdateGameTime(72)
	elseIf(refActor3 == AnimalActor)
		pAnimalAlias3.RegisterForUpdateGameTime(72)
	endIf
	
EndFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;FOLLOWER-FOLLOW - first function is for default with no actor argument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function FollowerFollow()

	;This is a failsafe function for unexpected calls
	actor refActor1 = pFollowerAlias.GetReference() as actor
	actor refActor2 = pFollowerAlias2.GetReference() as actor
	actor refActor3 = pFollowerAlias3.GetReference() as actor
	float notif = gNotif.GetValue()

	if(refActor1 != none)
		refActor1.SetActorValue("WaitingForPlayer", 0)
		pFollowerAlias.UnregisterForUpdateGameTime() 
		SetObjectiveDisplayed(10, abdisplayed = false)
	endIf
	if(refActor2 != none)
		refActor2.SetActorValue("WaitingForPlayer", 0)
		pFollowerAlias2.UnregisterForUpdateGameTime() 
		SetObjectiveDisplayed(12, abdisplayed = false)
	endIf
	if(refActor3 != none)
		refActor3.SetActorValue("WaitingForPlayer", 0)
		pFollowerAlias3.UnregisterForUpdateGameTime() 
		SetObjectiveDisplayed(14, abdisplayed = false)
	endIf
	;all followers will stop waiting and follow

	;if(notif == 1)
	;	debug.notification("Multiple followers may follow this command due to default FollowerFollow function.")
	;endIf

EndFunction

Function LarsepanFollowerFollow(ObjectReference FollowerRef)

	actor refActor1 = pFollowerAlias.GetReference() as actor
	actor refActor2 = pFollowerAlias2.GetReference() as actor
	actor refActor3 = pFollowerAlias3.GetReference() as actor
	actor FollowerActor = FollowerRef as actor

	if(refActor1 == FollowerActor)
		pFollowerAlias.UnregisterForUpdateGameTime() 
		SetObjectiveDisplayed(10, abdisplayed = false)
	elseIf(refActor2 == FollowerActor)
		pFollowerAlias2.UnregisterForUpdateGameTime() 
		SetObjectiveDisplayed(12, abdisplayed = false)
	elseIf(refActor3 == FollowerActor)
		pFollowerAlias3.UnregisterForUpdateGameTime() 
		SetObjectiveDisplayed(14, abdisplayed = false)
	endIf
	FollowerActor.SetActorValue("WaitingForPlayer", 0)


EndFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ANIMAL-FOLLOW
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function AnimalFollow()

	;This is a failsafe function for unexpected calls
	actor refActor1 = pAnimalAlias.GetReference() as actor
	actor refActor2 = pAnimalAlias2.GetReference() as actor
	actor refActor3 = pAnimalAlias3.GetReference() as actor
	float notif = gNotif.GetValue()

	if(refActor1 != none)
		refActor1.SetActorValue("WaitingForPlayer", 0)
		pAnimalAlias.UnregisterForUpdateGameTime() 
		SetObjectiveDisplayed(20, abdisplayed = false)
	endIf
	if(refActor2 != none)
		refActor2.SetActorValue("WaitingForPlayer", 0)
		pAnimalAlias2.UnregisterForUpdateGameTime() 
		SetObjectiveDisplayed(22, abdisplayed = false)
	endIf
	if(refActor3 != none)
		refActor3.SetActorValue("WaitingForPlayer", 0)
		pAnimalAlias3.UnregisterForUpdateGameTime() 
		SetObjectiveDisplayed(24, abdisplayed = false)
	endIf
	;all followers will stop waiting and follow

	;if(notif == 1)
	;	debug.notification("Multiple animals may follow this command due to default FollowerFollow function.")
	;endIf

EndFunction

Function LarsepanAnimalFollow(ObjectReference FollowerRef)

	actor refActor1 = pAnimalAlias.GetReference() as actor
	actor refActor2 = pAnimalAlias2.GetReference() as actor
	actor refActor3 = pAnimalAlias3.GetReference() as actor
	actor AnimalActor = FollowerRef as actor
	
	if(refActor1 == AnimalActor)
		pAnimalAlias.UnregisterForUpdateGameTime() 
		SetObjectiveDisplayed(20, abdisplayed = false)
	elseIf(refActor2 == AnimalActor)
		pAnimalAlias2.UnregisterForUpdateGameTime() 
		SetObjectiveDisplayed(22, abdisplayed = false)
	elseIf(refActor3 == AnimalActor)
		pAnimalAlias3.UnregisterForUpdateGameTime() 
		SetObjectiveDisplayed(24, abdisplayed = false)
	endIf
	AnimalActor.SetActorValue("WaitingForPlayer", 0)

EndFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DISMISS-FOLLOWER  - first function is for default with no actor argument
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function DismissFollower(Int iMessage = 0, Int iSayLine = 1) 

	;I'm not sure how often this failsafe function will be called by the vanilla game
	;It also might be called by a custom follower
	;This function will dismiss the first alias that is not waiting
	actor refActor1 = pFollowerAlias.GetReference() as actor
	actor refActor2 = pFollowerAlias2.GetReference() as actor
	actor refActor3 = pFollowerAlias3.GetReference() as actor
	actor DismissedFollowerActor
	float count = pPlayerFollowerCount.GetValue()
	float ignoreCheck = gFriendAgg.GetValue()
	;float notif = gNotif.GetValue()
	int iCount
	int iDismiss
	
	if (refActor1)
		if (refActor1.GetActorValue("WaitingforPlayer") == 0)
			DismissedFollowerActor = refActor1
			iDismiss = 1
		endIf
		iCount += 1
	endIf
	if (refActor2)
		if (refActor2.GetActorValue("WaitingforPlayer") == 0)
			DismissedFollowerActor = refActor2
			iDismiss = 2
		endIf
		iCount += 1
	endIf
	if (refActor3)
		if (refActor3.GetActorValue("WaitingforPlayer") == 0)
			DismissedFollowerActor = refActor3
			iDismiss = 3
		endIf
		iCount += 1
	endIf
	if(!iDismiss && iCount)
		DismissedFollowerActor = refActor1
		;All actors are waiting.  Dismissing first alias.
	endIf

	if(iCount)
		If DismissedFollowerActor && DismissedFollowerActor.IsDead() == False
			If iMessage == 0
				FollowerDismissMessage.Show()
			ElseIf iMessage == 1
				FollowerDismissMessageWedding.Show()
			ElseIf iMessage == 2
				FollowerDismissMessageCompanions.Show()
			ElseIf iMessage == 3
				FollowerDismissMessageCompanionsMale.Show()
			ElseIf iMessage == 4
				FollowerDismissMessageCompanionsFemale.Show()
			ElseIf iMessage == 5
				FollowerDismissMessageWait.Show()
			Else
				;failsafe
				FollowerDismissMessage.Show()
			EndIf

			DismissedFollowerActor.StopCombatAlarm()
			DismissedFollowerActor.AddToFaction(pDismissedFollower)
			DismissedFollowerActor.SetPlayerTeammate(false)
			DismissedFollowerActor.RemoveFromFaction(pCurrentHireling)
			DismissedFollowerActor.SetActorValue("WaitingForPlayer", 0)

			; PATCH 1.9: 77615: remove unplayable hunting bow when follower is dismissed
			DismissedFollowerActor.RemoveItem(FollowerHuntingBow, 999, true)
			DismissedFollowerActor.RemoveItem(FollowerIronArrow, 999, true)
			; END Patch 1.9 fix

			;hireling rehire function
			HirelingRehireScript.DismissHireling(DismissedFollowerActor.GetActorBase())
			If iSayLine == 1
				iFollowerDismiss = 1
				DismissedFollowerActor.EvaluatePackage()
				;Wait for follower to say line
				Utility.Wait(2)
			EndIf
			if(iDismiss == 1)
				pFollowerAlias.UnregisterForUpdateGameTime()
				pFollowerAlias.Clear()
				;If possible, refill that first alias
				if(refActor2 != none)
					Utility.Wait(1)
					pFollowerAlias2.Clear()
					pFollowerAlias.ForceRefTo(refActor2)
					pFollowerAlias2.UnregisterForUpdateGameTime() 	
					;if(notif == 1)
						;debug.notification("Follower1 alias cleared and replaced by Follower2 alias.")
					;endIf
					LarsepanCorrectFollowers()
				elseIf(refActor3 != none)
					Utility.Wait(1)
					pFollowerAlias3.Clear()
					pFollowerAlias.ForceRefTo(refActor3)
					pFollowerAlias3.UnregisterForUpdateGameTime() 	
					;if(notif == 1)
						;debug.notification("Follower1 alias cleared and replaced by Follower3 alias.")
					;endIf
					LarsepanCorrectFollowers()
				else
					;the player has no followers
				endIf
			elseIf(iDismiss == 2)
				pFollowerAlias2.UnregisterForUpdateGameTime() 
				pFollowerAlias2.Clear()
			else
				pFollowerAlias3.UnregisterForUpdateGameTime() 
				pFollowerAlias3.Clear()
			endIf

			iFollowerDismiss = 0

			If iMessage == 2
				;don't adjust count if Companions have replaced follower
			else
				pPlayerFollowerCount.Mod(-count)				
				iCount -=1
				if(iCount < 1 )
					pPlayerFollowerCount.SetValue(0) ;might as well reset the zero value
					iCount = 0
				else
					pPlayerFollowerCount.Mod(iCount)
				endIf
				; if(notif == 1)
					; debug.notification(iCount + "/3 followers")				
					; ;debug.notification("PlayerFollowerCount has been set to " + iCount + ".")	
				; endIf
			EndIf
			if(ignoreCheck == 1)
				DismissedFollowerActor.IgnoreFriendlyHits(false)
			endIf
		EndIf		
	else
		;debug.notification("Player has no followers to dismiss.")
	endIf

EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;LarsepanDismissFollower
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function LarsepanDismissFollower(Int iMessage = 0, Int iSayLine = 1, ObjectReference FollowerRef)
	
	actor DismissedFollowerActor = FollowerRef as actor

	if(DismissedFollowerActor)
		actor refActor1 = pFollowerAlias.GetReference() as actor
		actor refActor2 = pFollowerAlias2.GetReference() as actor
		actor refActor3 = pFollowerAlias3.GetReference() as actor

		;float notif = gNotif.GetValue()
		float count = pPlayerFollowerCount.GetValue()
		float ignoreCheck = gFriendAgg.GetValue()
		int iCount
		if (refActor1)
		iCount += 1
		endIf
		if (refActor2)
		iCount += 1
		endIf
		if (refActor3)
		iCount += 1
		endIf
		if(ignoreCheck == 1)
			DismissedFollowerActor.IgnoreFriendlyHits(false)
		endIf
		If (DismissedFollowerActor.IsDead() == False)
			If iMessage == 0
				FollowerDismissMessage.Show()
			ElseIf iMessage == 1
				FollowerDismissMessageWedding.Show()
			ElseIf iMessage == 2
				FollowerDismissMessageCompanions.Show()
			ElseIf iMessage == 3
				FollowerDismissMessageCompanionsMale.Show()
			ElseIf iMessage == 4
				FollowerDismissMessageCompanionsFemale.Show()
			ElseIf iMessage == 5
				FollowerDismissMessageWait.Show()
			ElseIf iMessage == 404
				;Do nothing
			Else
				;failsafe
				FollowerDismissMessage.Show()
			EndIf
			
			DismissedFollowerActor.StopCombatAlarm()
			DismissedFollowerActor.AddToFaction(pDismissedFollower)
			DismissedFollowerActor.SetPlayerTeammate(false)
			DismissedFollowerActor.RemoveFromFaction(pCurrentHireling)
			DismissedFollowerActor.SetActorValue("WaitingForPlayer", 0)	

			; PATCH 1.9: 77615: remove unplayable hunting bow when follower is dismissed
			DismissedFollowerActor.RemoveItem(FollowerHuntingBow, 999, true)
			DismissedFollowerActor.RemoveItem(FollowerIronArrow, 999, true)
			; END Patch 1.9 fix

			;hireling rehire function
			HirelingRehireScript.DismissHireling(DismissedFollowerActor.GetActorBase())
			If iSayLine == 1
				iFollowerDismiss = 1
				DismissedFollowerActor.EvaluatePackage()
				;Wait for follower to say line
				Utility.Wait(2)
			EndIf		
			
			;match actor with alias
			if(DismissedFollowerActor == refActor1)
				pFollowerAlias.UnregisterForUpdateGameTime()
				pFollowerAlias.Clear()
				;If possible, refill that first alias
				if(refActor2 != none)
					Utility.Wait(1)
					pFollowerAlias2.Clear()
					pFollowerAlias.ForceRefTo(refActor2)
					pFollowerAlias2.UnregisterForUpdateGameTime() 	
					;if(notif == 1)
						;debug.notification("Follower1 alias cleared and replaced by Follower2 alias.")
					;endIf
					LarsepanCorrectFollowers()
				elseIf(refActor3 != none)
					Utility.Wait(1)
					pFollowerAlias3.Clear()
					pFollowerAlias.ForceRefTo(refActor3)
					pFollowerAlias3.UnregisterForUpdateGameTime() 	
					;if(notif == 1)
						;debug.notification("Follower1 alias cleared and replaced by Follower3 alias.")
					;endIf
					LarsepanCorrectFollowers()
				else
					;the player has no followers
				endIf
			elseIf(DismissedFollowerActor == refActor2)
				pFollowerAlias2.UnregisterForUpdateGameTime() 
				pFollowerAlias2.Clear()
			elseIf(DismissedFollowerActor == refActor3)
				pFollowerAlias3.UnregisterForUpdateGameTime() 
				pFollowerAlias3.Clear()
			else
				; if(notif == 1)
					; debug.notification("Error.  This actor has no alias match.")
				; endIf			
			endIf
			
			iFollowerDismiss = 0

			If iMessage == 2
				;don't adjust count if Companions have replaced follower
			else
				pPlayerFollowerCount.Mod(-count)				
				iCount -=1
				if(iCount < 1 )
					pPlayerFollowerCount.SetValue(0) ;might as well reset the zero value
					iCount = 0
				else
					pPlayerFollowerCount.Mod(iCount)
				endIf
				; if(notif == 1)
					; debug.notification(iCount + "/3 followers")				
					; ;debug.notification("PlayerFollowerCount has been set to " + iCount + ".")	
				; endIf
			EndIf
			if(ignoreCheck == 1)
				DismissedFollowerActor.IgnoreFriendlyHits(false)
			endIf	
		EndIf
	else
		;debug.notification("Player has no followers to dismiss.")
	endIf
	
EndFunction


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DISMISS-ANIMAL edits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function DismissAnimal()

	;This function will be called by the commands menu
	;It also might be called by a custom follower
	actor refActor1 = pAnimalAlias.GetReference() as actor
	actor refActor2 = pAnimalAlias2.GetReference() as actor
	actor refActor3 = pAnimalAlias3.GetReference() as actor
	actor DismissedAnimalActor
	;float notif = gNotif.GetValue()
	float count = pPlayerAnimalCount.GetValue()
	float ignoreCheck = gFriendAgg.GetValue()
	int iCount
	
	if (refActor3)
		iCount += 1
	endIf
	if (refActor2)
		iCount += 1
	endIf
	if (refActor1)
		iCount += 1
	else
		if(refActor2)
			pAnimalAlias2.clear()
			DismissedAnimalActor = refActor2
			pAnimalAlias.ForceRefTo(refActor2)
			pAnimalAlias2.UnregisterForUpdateGameTime()
			Utility.Wait(1)
			;if(notif == 1)
				;debug.notification("Follower2 alias was moved to Follower1.")
			;endIf	
		elseif(refActor3)
			pAnimalAlias3.clear()
			DismissedAnimalActor = refActor3
			pAnimalAlias.ForceRefTo(refActor3)
			pAnimalAlias3.UnregisterForUpdateGameTime() 
			Utility.Wait(1)
			;if(notif == 1)
				;debug.notification("Follower3 alias was moved to Follower1.")
			;endIf
		else
			; if(notif == 1)
				; debug.notification("Dismissal error: DismissFollower function found no actor for dismissal.")
			; endIf
			Return
		endIf
	endIf

	if(iCount)
		If pAnimalAlias && pAnimalAlias.GetActorReference().IsDead() == False
			;actor DismissedAnimalActor = pAnimalAlias.GetReference() as Actor
			pAnimalAlias.UnregisterForUpdateGameTime() 
			DismissedAnimalActor.SetActorValue("Variable04", 0)
			;DismissedAnimalActor.AllowPCDialogue(False)
			pPlayerAnimalCount.Mod(-count)
			iCount -=1
			if(iCount < 0)
				pPlayerAnimalCount.SetValue(0)
				iCount = 0
			else
				pPlayerAnimalCount.Mod(iCount)
			endIf
			; if(notif == 1)
				; debug.notification(iCount + "/3 animals")				
				; ;debug.notification("PlayerAnimalCount has been set to " + iCount + ".")	
			; endIf
			pAnimalAlias.Clear()
			AnimalDismissMessage.Show()
			if(ignoreCheck == 1)
				DismissedAnimalActor.IgnoreFriendlyHits(false)
			endIf
		EndIf
		
		;if possible, fill first alias
		if(refActor2)
			Utility.Wait(1)
			pAnimalAlias2.Clear()
			pAnimalAlias.ForceRefTo(refActor2)
			pAnimalAlias2.UnregisterForUpdateGameTime() 
			;if(notif == 1)
				;debug.notification("Animal1 alias cleared and replaced by Animal2 alias.")
			;endIf
			LarsepanCorrectAnimals()
		elseIf(refActor3)
			Utility.Wait(1)
			pAnimalAlias3.Clear()
			pAnimalAlias.ForceRefTo(refActor3)
			pAnimalAlias3.UnregisterForUpdateGameTime() 
			;if(notif == 1)
				;debug.notification("Animal1 alias cleared and replaced by Animal2 alias.")
			;endIf
			LarsepanCorrectAnimals()
		else
			;player has dismissed all animals
		endIf
	endIf
	
EndFunction

Function LarsepanDismissAnimal(ObjectReference FollowerRef)

	actor DismissedAnimalActor = FollowerRef as actor
	
	if(DismissedAnimalActor)
		actor refActor1 = pAnimalAlias.GetReference() as actor
		actor refActor2 = pAnimalAlias2.GetReference() as actor
		actor refActor3 = pAnimalAlias3.GetReference() as actor

		;float notif = gNotif.GetValue()
		float count = pPlayerAnimalCount.GetValue()
		float ignoreCheck = gFriendAgg.GetValue()
		int iCount
		if (refActor1)
		iCount += 1
		endIf
		if (refActor2)
		iCount += 1
		endIf
		if (refActor3)
		iCount += 1
		endIf

		If (DismissedAnimalActor.IsDead() == False)
			;actor DismissedAnimalActor = pAnimalAlias.GetActorRef() as Actor
			DismissedAnimalActor.SetActorValue("Variable04", 0)
			DismissedAnimalActor.SetActorValue("WaitingForPlayer", 0)	
			;DismissedAnimalActor.AllowPCDialogue(False)
			;;;;
			pPlayerAnimalCount.Mod(-count)
			iCount -=1
			if(iCount < 0)
				pPlayerAnimalCount.SetValue(0)
				iCount = 0
			else
				pPlayerAnimalCount.Mod(iCount)
			endIf
			; if(notif == 1)
				; debug.notification(iCount + "/3 animals")				
				; ;debug.notification("PlayerAnimalCount has been set to " + iCount + ".")	
			; endIf
			;;;;
			if(DismissedAnimalActor == refActor1)
				pAnimalAlias.UnregisterForUpdateGameTime() 
				pAnimalAlias.Clear()		
				if(refActor2 != none)
					Utility.Wait(1)
					pAnimalAlias2.Clear()
					pAnimalAlias.ForceRefTo(refActor2)
					pAnimalAlias2.UnregisterForUpdateGameTime() 
					;if(notif == 1)
						;debug.notification("Animal1 alias cleared and replaced by Animal2 alias.")
					;endIf
				elseIf(refActor3 != none)
					Utility.Wait(1)
					pAnimalAlias3.Clear()
					pAnimalAlias.ForceRefTo(refActor3)
					pAnimalAlias3.UnregisterForUpdateGameTime() 
					;if(notif == 1)
						;debug.notification("Animal1 alias cleared and replaced by Animal2 alias.")
					;endIf
				else
					;player has dismissed all animals
				endIf			
			elseIf(DismissedAnimalActor == refActor2)
				pAnimalAlias2.UnregisterForUpdateGameTime()
				pAnimalAlias2.Clear()		
			elseIf(DismissedAnimalActor == refActor3)
				pAnimalAlias3.UnregisterForUpdateGameTime()
				pAnimalAlias3.Clear()				
			else
				;debug.notification("Error:  Actor has no alias match.")			
			endIf
			
			AnimalDismissMessage.Show()
			if(ignoreCheck == 1)
				DismissedAnimalActor.IgnoreFriendlyHits(false)
			endIf
		EndIf
	else
		;debug.notification("Player has no animals to dismiss.")		
	endIf

EndFunction

Function MassLarsepanDismissAnimal(ObjectReference FollowerRef)

	actor DismissedAnimalActor = FollowerRef as actor
		
		if(DismissedAnimalActor)
			actor refActor1 = pAnimalAlias.GetReference() as actor
			actor refActor2 = pAnimalAlias2.GetReference() as actor
			actor refActor3 = pAnimalAlias3.GetReference() as actor
			float count = pPlayerAnimalCount.GetValue()
			float ignoreCheck = gFriendAgg.GetValue()
			int iCount
			if (refActor1)
			iCount += 1
			endIf
			if (refActor2)
			iCount += 1
			endIf
			if (refActor3)
			iCount += 1
			endIf

			If (DismissedAnimalActor.IsDead() == False)
				DismissedAnimalActor.SetActorValue("Variable04", 0)
				DismissedAnimalActor.SetActorValue("WaitingForPlayer", 0)	
				;;;;
				pPlayerAnimalCount.Mod(-count)
				iCount -=1
				if(iCount < 0)
					pPlayerAnimalCount.SetValue(0)
					iCount = 0
				else
					pPlayerAnimalCount.Mod(iCount)
				endIf
				;;;;
				if(DismissedAnimalActor == refActor1)
					pAnimalAlias.UnregisterForUpdateGameTime() 
					pAnimalAlias.Clear()					
				elseIf(DismissedAnimalActor == refActor2)
					pAnimalAlias2.UnregisterForUpdateGameTime()
					pAnimalAlias2.Clear()		
				elseIf(DismissedAnimalActor == refActor3)
					pAnimalAlias3.UnregisterForUpdateGameTime()
					pAnimalAlias3.Clear()				
				else
					;debug.notification("Error:  Actor has no alias match.")			
				endIf
				
				if(ignoreCheck == 1)
					DismissedAnimalActor.IgnoreFriendlyHits(false)
				endIf
			EndIf
		else
			;debug.notification("Player has no animals to dismiss.")		
		endIf

EndFunction

Function LarsepanCorrectFollowers()

	float notif = gNotif.GetValue()	
	float zOut = pPlayerFollowerCount.GetValue()
	actor refActor1 = pFollowerAlias.GetReference() as actor
	actor refActor2 = pFollowerAlias2.GetReference() as actor
	actor refActor3 = pFollowerAlias3.GetReference() as actor
	int count
	float fCount
	if(refActor1 != none)
		if(refActor1 == refActor2)
			pFollowerAlias2.Clear()
		endIf
		if(refActor1 == refActor3)
			pFollowerAlias3.Clear()
		endIf
		count += 1
	endIf
	refActor2 = pFollowerAlias2.GetReference() as actor  ;update since it might've been cleared
	if(refActor2 != none)
		if(refActor2 == refActor3)
			pFollowerAlias3.Clear()
		endIf
		if(refActor1 == none)
			pFollowerAlias2.Clear()
			pFollowerAlias.ForceRefTo(refActor2)
		endIf
		count += 1
	endIf
	refActor3 = pFollowerAlias3.GetReference() as actor  ;update since it might've been cleared
	if(refActor3 != none)
		if(refActor1 == none)
			pFollowerAlias3.Clear()
			pFollowerAlias.ForceRefTo(refActor3)
		endIf
		count += 1
	endIf
	fCount = count as float
	if(zOut != fCount)
		pPlayerFollowerCount.SetValue(fCount)
	else
	;do nothing
	endIf
	
EndFunction

Function LarsepanCorrectAnimals()

	float notif = gNotif.GetValue()	
	float zOut = pPlayerAnimalCount.GetValue()
	actor refActor1 = pAnimalAlias.GetReference() as actor
	actor refActor2 = pAnimalAlias2.GetReference() as actor
	actor refActor3 = pAnimalAlias3.GetReference() as actor
	int count
	float fCount
	if(refActor1 != none)
		if(refActor1 == refActor2)
			pAnimalAlias2.Clear()
		endIf
		if(refActor1 == refActor3)
			pAnimalAlias3.Clear()
		endIf
		count += 1
	endIf
	refActor2 = pAnimalAlias2.GetReference() as actor  ;update since it might've been cleared
	if(refActor2 != none)
		if(refActor2 == refActor3)
			pAnimalAlias3.Clear()
		endIf
		if(refActor1 == none)
			pAnimalAlias2.Clear()
			pAnimalAlias.ForceRefTo(refActor2)
		endIf
		count += 1
	endIf
	refActor3 = pAnimalAlias3.GetReference() as actor  ;update since it might've been cleared
	if(refActor3 != none)
		if(refActor1 == none)
			pAnimalAlias3.Clear()
			pAnimalAlias.ForceRefTo(refActor3)
		endIf
		count += 1
	endIf
	fCount = count as float
	if(zOut != fCount)
		pPlayerAnimalCount.SetValue(fCount)
	else
	;do nothing
	endIf
	
EndFunction
