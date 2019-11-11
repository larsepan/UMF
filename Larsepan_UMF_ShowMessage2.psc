;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; by Larsepan
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Scriptname Larsepan_UMF_ShowMessage2 Extends ActiveMagicEffect

;THIS WILL BE THE COMMANDS VERSION OF THIS MENU

;PROPERTIES
Actor Property PlayerRef  Auto  
Faction Property Assassin Auto
Faction Property DismissedFollowerFaction  Auto ;will this be used?
Faction Property Thief Auto
Faction Property UMFfriendsFaction Auto
FormList Property UMFList  Auto  ;will this be used?
GlobalVariable Property gCommandsToggle  Auto
GlobalVariable Property gNotif  Auto
GlobalVariable Property pPlayerAnimalCount  Auto   
GlobalVariable Property pPlayerFollowerCount  Auto
Keyword Property vampire Auto
Message Property UMFConfigSubD1  Auto 
Message Property UMFConfigSubC2  Auto 
Message Property UMFConfigSubE3  Auto ;Shows CommandMenu toggle status.  I might include further options here in the future.
Message Property UMFYesNoMenu4  Auto  
quest Property DLC1RadiantQuest  Auto
quest Property pDialogueFollower  Auto
ReferenceAlias Property AnimalRef1  Auto  
ReferenceAlias Property AnimalRef2  Auto  
ReferenceAlias Property AnimalRef3  Auto 
ReferenceAlias Property FollowerRef1  Auto  
ReferenceAlias Property FollowerRef2  Auto  
ReferenceAlias Property FollowerRef3  Auto 
ReferenceAlias Property TrollFollower1 Auto	  
SPELL Property ConfigSpell  Auto 
SPELL Property CommandSpell  Auto  

;CHECK FOR PLAYER ON EFFECT START
Event OnEffectStart(actor akTarget, actor akCaster)

	If akCaster == PlayerRef 
		CommandsMenu()
	EndIf
	
EndEvent

;COMMANDS MAIN MENU
Function CommandsMenu(Int aiButton = 0)

	aiButton = UMFConfigSubC2.Show()	;SubC1 is the original commands menu alias
	If aiButton == 0 ; Exit
		;Debug.Notification("Exiting...")	
	elseIf aiButton == 1 ; everyone Wait
		SetWait()
	elseIf aiButton == 2 ; everyone Follow
		SetFollow()
	elseIf aiButton == 3 ; Stops in-fights, helps followers catch up
		CheckFollowers()
	elseIf aiButton == 4 ; Dismiss Everyone
		Dismiss()
	elseIf aiButton == 5 ; MORE
		CommandsOptions()
		;Debug.Notification("To UMF Config menu...")		
	EndIf	

EndFunction

Function CommandsOptions(Int aiButton = 0)

	float commands = gCommandsToggle.GetValue()
	aiButton = UMFConfigSubE3.Show()	;SubC1 is the original commands menu alias	
	If(!commands)
		Debug.Notification("Error.  Global CommandsToggle was in OFF status.  Fixing.")
		gCommandsToggle.SetValue(1)
	endIf
	
	If aiButton == 0 ; back
		CommandsMenu()	
	elseIf aiButton == 1 ; Commands Menu is ON
		CommandsToggle()
	elseIf aiButton == 2 ; Exit
		;Exit		
	EndIf	

EndFunction

Function CommandsToggle(Int aiButton = 0)

	aiButton = UMFYesNoMenu4.Show() 
	If aiButton == 0  ; Yes
		;Remove CommandsMenu Spell
		;Add UMFConfig Spell
		gCommandsToggle.SetValue(0)
		PlayerRef.AddSpell(ConfigSpell)
		PlayerRef.RemoveSpell(CommandSpell)
		;Exit menus
	ElseIf aiButton == 1 ; No
		CommandsOptions()
	EndIf

EndFunction

Function CheckFollowers()

	float notif = gNotif.GetValue()
	actor refActor1 = FollowerRef1.GetReference() as actor
	actor refActor2 = FollowerRef2.GetReference() as actor
	actor refActor3 = FollowerRef3.GetReference() as actor
	actor refAnimal1 = AnimalRef1.GetReference() as actor
	actor refAnimal2 = AnimalRef2.GetReference() as actor
	actor refAnimal3 = AnimalRef3.GetReference() as actor
	actor refTroll1 = TrollFollower1.GetReference() as actor
	actor target1
	actor target2
	actor target3
	actor target4
	actor target5
	actor target6
	actor target7
	int iCount
	int iCatchup
	int iWait
	float fOne
	float fTwo
	float fThree
	float aOne
	float aTwo
	float aThree
	float tOne
	if(refActor1)
		fOne = refActor1.GetDistance(PlayerRef)
		target1 = refActor1.GetCombatTarget()
		;debug.notification("refActor1 is " + fOne + " units away.")
	endIf	
	if(refActor2)
		fTwo = refActor2.GetDistance(PlayerRef)
		target2 = refActor2.GetCombatTarget()
		;debug.notification("refActor2 is " + fTwo + " units away.")
	endIf	
	if(refActor3)
		fThree = refActor3.GetDistance(PlayerRef)
		target3 = refActor3.GetCombatTarget() 
		;debug.notification("refActor3 is " + fThree + " units away.")
	endIf
	if(refAnimal1)
		aOne = refAnimal1.GetDistance(PlayerRef)
		target4 = refAnimal1.GetCombatTarget()
		;debug.notification("refAnimal1 is " + aOne + " units away.")		
	endIf	
	if(refAnimal2)
		aTwo = refAnimal2.GetDistance(PlayerRef)
		target5 = refAnimal2.GetCombatTarget() 
		;debug.notification("refAnimal2 is " + aTwo + " units away.")
	endIf	
	if(refAnimal3)
		aThree = refAnimal3.GetDistance(PlayerRef)
		target6 = refAnimal3.GetCombatTarget() 
		;debug.notification("refAnimal3 is " + aThree + " units away.")
	endIf	
	if(refTroll1)
		tOne = refTroll1.GetDistance(PlayerRef)
		target7 = refTroll1.GetCombatTarget()
		;debug.notification("refTroll1 is " + tOne + " units away.")
	endIf		
	if(target1.IsInFaction(UMFfriendsFaction) || target2.IsInFaction(UMFfriendsFaction) || target3.IsInFaction(UMFfriendsFaction) || target4.IsInFaction(UMFfriendsFaction) || target5.IsInFaction(UMFfriendsFaction) || target6.IsInFaction(UMFfriendsFaction) || target7.IsInFaction(UMFfriendsFaction))
		;PlayerRef.StopCombatAlarm()
		if(fOne)		
			refActor1.StopCombatAlarm()
			iCount += 1
		endIf
		if(fTwo)
			refActor2.StopCombatAlarm()
			iCount += 1
		endIf
		if(fThree)		
			refActor3.StopCombatAlarm()	
			iCount += 1
		endIf
		if(aOne)
			refAnimal1.StopCombatAlarm()
			iCount += 1		
		endIf
		if(aTwo)
			refAnimal2.StopCombatAlarm()
			iCount += 1
		endIf
		if(aThree)
			refAnimal3.StopCombatAlarm()
			iCount += 1
		endIf
		if(tOne)
			refTroll1.StopCombatAlarm()	
			iCount += 1
		endIf
		if(iCount > 0)
			RegisterForSingleUpdate(2)
		endIf
	endIf
	
	;MAKE STRAY FOLLOWERS CATCH UP	
	if(!iCount)
		if (fOne > 1024)
			if (!PlayerRef.IsOnMount() && !refActor1.IsOnMount())
				if(refActor1.GetActorValue("WaitingforPlayer") == 0 as float)
					if(PlayerRef.HasLOS(refActor1) == false)
						;move actor to player
						Float x = -200.0 * Math.Sin(PlayerRef.GetAngleZ())
						Float y = -200.0 * Math.Cos(PlayerRef.GetAngleZ())
						Float z = PlayerRef.GetHeight() - 0
						refActor1.MoveTo(PlayerRef, x, y, z, true)
						iCatchup += 1
					endIf
				else
					iWait += 1
				endIf
			endIf
		endIf	
		if (fTwo > 1024)
			if (!PlayerRef.IsOnMount() && !refActor2.IsOnMount())
				if(refActor2.GetActorValue("WaitingforPlayer") == 0 as float)
					if(PlayerRef.HasLOS(refActor2) == false)
						;move actor to player
						Float x = -200.0 * Math.Sin(PlayerRef.GetAngleZ())
						Float y = -200.0 * Math.Cos(PlayerRef.GetAngleZ())
						Float z = PlayerRef.GetHeight() - 0
						refActor2.MoveTo(PlayerRef, x, y, z, true)
						iCatchup += 1
					endIf
				else
					iWait += 1
				endIf
			endIf
		endIf		
		if (fThree > 1024)
			if (!PlayerRef.IsOnMount() && !refActor3.IsOnMount())
				if(refActor3.GetActorValue("WaitingforPlayer") == 0 as float)
					if(PlayerRef.HasLOS(refActor3) == false)
						;move actor to player
						Float x = -200.0 * Math.Sin(PlayerRef.GetAngleZ())
						Float y = -200.0 * Math.Cos(PlayerRef.GetAngleZ())
						Float z = PlayerRef.GetHeight() - 0
						refActor3.MoveTo(PlayerRef, x, y, z, true)
						iCatchup += 1
					endIf
				else
					iWait += 1
				endIf
			endIf
		endIf		
		if (aOne > 1024)
			if(refAnimal1.GetActorValue("WaitingforPlayer") == 0 as float)
				if(PlayerRef.HasLOS(refAnimal1) == false)
					;move actor to player
					Float x = -200.0 * Math.Sin(PlayerRef.GetAngleZ())
					Float y = -200.0 * Math.Cos(PlayerRef.GetAngleZ())
					Float z = PlayerRef.GetHeight() - 0
					refAnimal1.MoveTo(PlayerRef, x, y, z, true)
					iCatchup += 1
				endIf
			else
				iWait += 1
			endIf
		endIf		
		if (aTwo > 1024)
			if(refAnimal2.GetActorValue("WaitingforPlayer") == 0 as float)
				if(PlayerRef.HasLOS(refAnimal2) == false)
					;move actor to player
					Float x = -200.0 * Math.Sin(PlayerRef.GetAngleZ())
					Float y = -200.0 * Math.Cos(PlayerRef.GetAngleZ())
					Float z = PlayerRef.GetHeight() - 0
					refAnimal2.MoveTo(PlayerRef, x, y, z, true)
					iCatchup += 1
				endIf
			else
				iWait += 1
			endIf
		endIf		
		if (aThree > 1024)
			if(refAnimal3.GetActorValue("WaitingforPlayer") == 0 as float)
				if(PlayerRef.HasLOS(refAnimal3) == false)
					;move actor to player
					Float x = -200.0 * Math.Sin(PlayerRef.GetAngleZ())
					Float y = -200.0 * Math.Cos(PlayerRef.GetAngleZ())
					Float z = PlayerRef.GetHeight() - 0
					refAnimal3.MoveTo(PlayerRef, x, y, z, true)
					iCatchup += 1
				endIf
			else
				iWait += 1
			endIf
		endIf		
		if (tOne > 1024)
			if(refTroll1.GetActorValue("WaitingforPlayer") == 0 as float)
				if(PlayerRef.HasLOS(refTroll1) == false)
					;move actor to player
					Float x = -200.0 * Math.Sin(PlayerRef.GetAngleZ())
					Float y = -200.0 * Math.Cos(PlayerRef.GetAngleZ())
					Float z = PlayerRef.GetHeight() - 0
					refTroll1.MoveTo(PlayerRef, x, y, z, true)
					iCatchup += 1
				endIf
			else
				iWait += 1
			endIf
		endIf		
		if(notif)
			if(iCatchup && !iWait)
				int random
				random = Utility.RandomInt(0, 39)
				if(random < 10)
					debug.notification("Everyone here?")	
				elseIf((random > 9) && (random < 20)) 
					debug.notification("Everyone keeping up?")	
				else
					debug.notification("Everyone accounted for?")				
				endIf
				random = Utility.RandomInt(0, 39)
				utility.wait(2)
				if(random < 10)
					debug.notification("I think so...")	
				elseIf((random > 9) && (random < 20)) 
					debug.notification("I believe so...")	
				else
					debug.notification("Seems so...")			
				endIf
			elseIf (iCatchup && iWait)
				int random
				random = Utility.RandomInt(0, 39)
				if(random < 10)
					debug.notification("Everyone here?")	
				elseIf((random > 9) && (random < 20)) 
					debug.notification("Everyone keeping up?")	
				else
					debug.notification("Everyone accounted for?")				
				endIf
				random = Utility.RandomInt(0, 39)
				utility.wait(2)
				if(random < 10)
					debug.notification("I guess so...")		
				elseIf((random > 9) && (random < 20)) 
					debug.notification("Mostly...")	
				else
					debug.notification("Good enough...")		
				endIf
			endIf
		endIf		
	endIf
	
	;COMMENTS WHEN NO FOLLOWERS NEED STOPPING OR CATCHING UP
	if(notif == 1 && !iCatchup && !iCount)
		int random
		random = Utility.RandomInt(0, 39)
		if(!iCount)
			if(PlayerRef.Haskeyword(vampire))
				if(random < 3)
					debug.notification("Listen to them. Children of the night. What music they make.")	
				elseIf((random > 2) && (random < 6)) 
					debug.notification("Despair has its own calms.")					
				elseIf((random > 5) && (random < 10)) 
					debug.notification("The blood is life... and it shall be mine!")	
				else
					debug.notification("Hmm...")	
				endIf
			elseIf(PlayerRef.IsInFaction(Thief) || PlayerRef.IsInFaction(Assassin))
				if(random < 3)
					debug.notification("Life isn't fair, it's just fairer than death, that's all.")	
				elseIf((random > 2) && (random < 6)) 
					debug.notification("Good work.  Sleep well.  I'll most likely kill you in the morning.")					
				elseIf((random > 5) && (random < 10)) 
					debug.notification("I might not be left-handed.")	
				else
					debug.notification("Hmm...")
				endIf			
			else
				if(random < 3)
					debug.notification("Villains! I say to you now... Knock off all that evil!")	
				elseIf((random > 2) && (random < 6)) 
					debug.notification("Stop there!  You stench of unfathomable evil!")					
				elseIf((random > 5) && (random < 10))
					debug.notification("You're not going to a justice of the peace!")	
					utility.wait(1)
					debug.notification("All you're going to get is a big piece of JUSTICE!")
				else
					debug.notification("Hmm...")
				endIf			
			endIf
		else
			if(random < 10)
				debug.notification("Cease...")
			elseIf((random > 9) && (random < 20)) 
				debug.notification("Stop that...")
			else
				debug.notification("Enough...")				
			endIf
		endIf
	endIf
	
EndFunction

Function Dismiss()

	float notif = gNotif.GetValue()
	actor refActor1 = FollowerRef1.GetReference() as actor
	actor refActor2 = FollowerRef2.GetReference() as actor
	actor refActor3 = FollowerRef3.GetReference() as actor
	actor refAnimal1 = AnimalRef1.GetReference() as actor
	actor refAnimal2 = AnimalRef2.GetReference() as actor
	actor refAnimal3 = AnimalRef3.GetReference() as actor
	actor refTroll1 = TrollFollower1.GetReference() as actor
	int iCount
	int aCount
	if(refActor3 != none)
		(pDialogueFollower as DialogueFollowerScript).LarsepanDismissFollower(404, 0, refActor3)
		iCount += 1
	endIf
	if(refActor2 != none)
		(pDialogueFollower as DialogueFollowerScript).LarsepanDismissFollower(404, 0, refActor2)
		iCount += 1
	endIf
	if(refActor1 != none)
		(pDialogueFollower as DialogueFollowerScript).LarsepanDismissFollower(404, 0, refActor1)
		iCount += 1
	endIf
	if(refAnimal3 != none)
		(pDialogueFollower as DialogueFollowerScript).MassLarsepanDismissAnimal(refAnimal3)
		aCount += 1
	endIf
	if(refAnimal2 != none)
		(pDialogueFollower as DialogueFollowerScript).MassLarsepanDismissAnimal(refAnimal2)
		aCount += 1
	endIf
	if(refAnimal1 != none)
		(pDialogueFollower as DialogueFollowerScript).MassLarsepanDismissAnimal(refAnimal1)
		aCount += 1
	endIf
	if(refTroll1 != none)
		(DLC1RadiantQuest as DLC1RadiantScript).TrollDismissed()
		aCount += 1
	endIf
	if(notif == 1)
		if(!iCount && !aCount)
			int random
			random = Utility.RandomInt(0, 39)
			if(random < 3)
				debug.notification("You there, the one hiding.  You're dismissed.")	
			elseIf((random > 2) && (random < 6)) 
				debug.notification("I suppose I could dismiss myself...")	
			elseIf((random > 5) && (random < 10))	
				debug.notification("*sigh*")				
			else
				debug.notification("Hmm...")			
			endIf
		elseIf(!iCount && aCount)
			debug.notification("All animals have been dismissed.")	
		elseIf(iCount && !aCount)
			debug.notification("All followers have been dismissed.")	
		else
			debug.notification("All followers and animals have been dismissed.")		
		endIf
	endIf
	
EndFunction


Function SetWait()

	float notif = gNotif.GetValue()	
	int fCount = pPlayerFollowerCount.GetValue() as int
	int aCount = pPlayerAnimalCount.GetValue() as int
	actor refTroll1 = TrollFollower1.GetReference() as actor
	int total = fCount + aCount
	if(refTroll1)
		total += 1
	endIf
	int iCountWait = CountWait()
	if(iCountWait != total) ;If all the followers are waiting change total to zero
		(pDialogueFollower as DialogueFollowerScript).FollowerWait()
		(pDialogueFollower as DialogueFollowerScript).AnimalWait()
		(DLC1RadiantQuest as DLC1RadiantScript).TrollWait()
	else	
		total = 0
	endIf
	if(notif == 1)
		int random
		random = Utility.RandomInt(0, 39)
		if(!total)
			if(random < 3)
				debug.notification("I guess I'll wait...")	
			elseIf((random > 2) && (random < 6)) 
				debug.notification("Waiting...")	
			else
				debug.notification("Hmm...")				
			endIf
		else
			if(random < 10)
				debug.notification("Holding...")	
			elseIf((random > 9) && (random < 20)) 
				debug.notification("Staying...")	
			else
				debug.notification("Waiting...")			
			endIf	
		endIf
	endIf

EndFunction

Function SetFollow()

	float notif = gNotif.GetValue()
	int fCount = pPlayerFollowerCount.GetValue() as int
	int aCount = pPlayerAnimalCount.GetValue() as int
	int iCheck = 0 ;this is just a helper for keeping notification amounts in check
	int iFollow
	int addFollow
	;zero equals follower notifs will take precedence
	;one equals animal notifs will take precedence
	;two equals trolls notifs
	actor refTroll1 = TrollFollower1.GetReference() as actor
	if(fCount)
		if(!aCount && !refTroll1)
			iCheck = 3
		endIf
		iFollow = FollowerFollow(iCheck)
	endIf
	if(aCount)
		if(!fCount || !iFollow)
			iCheck = 1	
		endIf
		addFollow = AnimalFollow(iCheck)
		iFollow += addFollow
	endIf
	if(refTroll1)
		if((!fCount && !aCount) || !iFollow)
			iCheck = 2
		endIf
		addFollow = TrollFollow(iCheck)
		iFollow += addFollow
	endIf
	if(notif == 1)
		int random
		random = Utility.RandomInt(0, 39)
		if(!fCount && !aCount && !refTroll1)
			if(random < 3)
				debug.notification("You there, hiding.  Follow me.")
			elseIf((random > 2) && (random < 6)) 
				debug.notification("Who am I following?")
			else
				debug.notification("Hmm...")			
			endIf
		elseIf(!iFollow)
			int iCountWait = CountWait()
			if(!iCountWait)
				debug.notification("Hmm...")
			endIf
		endIf
	endIf
	
EndFunction

Int Function CountWait()

	actor refActor1 = FollowerRef1.GetReference() as actor
	actor refActor2 = FollowerRef2.GetReference() as actor
	actor refActor3 = FollowerRef3.GetReference() as actor
	actor refAnimal1 = AnimalRef1.GetReference() as actor
	actor refAnimal2 = AnimalRef2.GetReference() as actor
	actor refAnimal3 = AnimalRef3.GetReference() as actor
	actor refTroll1 = TrollFollower1.GetReference() as actor
	int iCount
	if(refActor1.GetActorValue("WaitingforPlayer") == 1)
		iCount += 1
	endIf
	if(refActor2.GetActorValue("WaitingforPlayer") == 1)
		iCount += 1
	endIf
	if(refActor3.GetActorValue("WaitingforPlayer") == 1)
		iCount += 1
	endIf
	if(refAnimal1.GetActorValue("WaitingforPlayer") == 1)
		iCount += 1
	endIf
	if(refAnimal2.GetActorValue("WaitingforPlayer") == 1)
		iCount += 1
	endIf
	if(refAnimal3.GetActorValue("WaitingforPlayer") == 1)
		iCount += 1
	endIf
	if(refTroll1.GetActorValue("WaitingforPlayer") == 1)
		iCount += 1
	endIf
	Return iCount
	
EndFunction

Int Function FollowerFollow(Int Check)

	actor refActor1 = FollowerRef1.GetReference() as actor
	actor refActor2 = FollowerRef2.GetReference() as actor
	actor refActor3 = FollowerRef3.GetReference() as actor
	int iFar ;counts waiting followers who are too far away to follow
	int iCount ;counts waiting followers who changed from waiting to following
	int iFollow ;counts followers currently following
	float fOne
	float fTwo
	float fThree
	float notif = gNotif.GetValue()	
	if(refActor1)
		If (refActor1.GetActorValue("WaitingforPlayer") == 1)
			fOne = refActor1.GetDistance(PlayerRef)
			;debug.notification("refActor1 is " + fOne + " units away.")
			if(refActor1.getCurrentLocation().IsSameLocation(PlayerRef.getCurrentLocation()))
				refActor1.SetActorValue("WaitingForPlayer", 0)
				pDialogueFollower.SetObjectiveDisplayed(10, abdisplayed = false)
				;debug.messagebox("refActor1 is in the same location.")
				iCount +=1
			else	
				if (fOne < 10000)
					refActor1.SetActorValue("WaitingForPlayer", 0)
					pDialogueFollower.SetObjectiveDisplayed(10, abdisplayed = false)
					;pFollowerAlias.UnregisterForUpdateGameTime() 
					iCount +=1
				else
					iFar += 1			
				endIf
			endIf
		else
			iFollow += 1
		endIf
	endIf
	if(refActor2)
		If (refActor2.GetActorValue("WaitingforPlayer") == 1)
			fTwo = refActor2.GetDistance(PlayerRef)
			;debug.notification("refActor2 is " + fTwo + " units away.")
			if(refActor2.getCurrentLocation().IsSameLocation(PlayerRef.getCurrentLocation()))
				refActor2.SetActorValue("WaitingForPlayer", 0)
				pDialogueFollower.SetObjectiveDisplayed(12, abdisplayed = false)
				;debug.messagebox("refActor2 is in the same location.")
				iCount +=1
			else	
				if (fTwo < 10000)
					refActor2.SetActorValue("WaitingForPlayer", 0)
					pDialogueFollower.SetObjectiveDisplayed(12, abdisplayed = false)
					;pFollowerAlias.UnregisterForUpdateGameTime() 
					iCount +=1
				else
					iFar += 1			
				endIf
			endIf
		else
			iFollow += 1
		endIf
	endIf
	if(refActor3)
		If (refActor3.GetActorValue("WaitingforPlayer") == 1)
			fThree = refActor3.GetDistance(PlayerRef)
			;debug.notification("refActor3 is " + fThree + " units away.")
			if(refActor3.getCurrentLocation().IsSameLocation(PlayerRef.getCurrentLocation()))
				refActor3.SetActorValue("WaitingForPlayer", 0)
				pDialogueFollower.SetObjectiveDisplayed(14, abdisplayed = false)
				;debug.messagebox("refActor3 is in the same location.")
				iCount +=1
			else	
				if (fThree < 10000)
					refActor3.SetActorValue("WaitingForPlayer", 0)
					pDialogueFollower.SetObjectiveDisplayed(14, abdisplayed = false)
					;pFollowerAlias.UnregisterForUpdateGameTime() 
					iCount +=1
				else
					iFar += 1			
				endIf
			endIf
		else
			iFollow += 1
		endIf
	endIf
	if(notif == 1)
		int random
		random = Utility.RandomInt(0, 39)
		if(iCount && (fOne && fOne < 4000 || fTwo && fTwo < 4000 || fThree && fThree < 4000)) ;this is the default - nearby waiting followers are now following response
			if(random < 10)
				debug.notification("Coming...")	
			elseIf((random > 9) && (random < 20)) 
				debug.notification("Moving...")	
			else
				debug.notification("Following...")	
			endIf
		elseIf(iCount) ;farther away waiting followers are on their way
			if(random < 10)		
				debug.notification("A far away shout acknowledges you...")
			elseIf((random > 9) && (random < 20)) 
				debug.notification("A distant voice acknowledges you...")	
			else
				debug.notification("You hear a distant acknowledgement...")			
			endIf
		elseIf(iFar && iFollow) ;a follower is currently following and a waiting follower is too far away to follow
			if(random < 10)
				debug.notification("Well some are following...")
			elseIf((random > 9) && (random < 20)) 
				debug.notification("You hear no response...")	
			else
				debug.notification("Perhaps they are too far away...")
			endIf			
		elseIf(iFar)  ;all waiting followers are too far away to follow
			if(random < 10)
				debug.notification("You near no acknowledgement...")
			elseIf((random > 9) && (random < 20)) 
				debug.notification("You hear no response...")	
			else
				debug.notification("Perhaps they are too far away...")
			endIf
		else
			;all followers are already following
		endIf
		utility.wait(0.5)
	endIf
	iCount += iFar ;let's the return know that something happened here	
	Return iCount
	
EndFunction

Int Function AnimalFollow(Int Check)

	actor refActor1 = AnimalRef1.GetReference() as actor
	actor refActor2 = AnimalRef2.GetReference() as actor
	actor refActor3 = AnimalRef3.GetReference() as actor	
	int iFar
	int iCount
	int iFollow
	float aOne
	float aTwo
	float aThree
	float notif = gNotif.GetValue()

	if(refActor1)
		If (refActor1.GetActorValue("WaitingforPlayer") == 1)
			aOne = refActor1.GetDistance(PlayerRef)
			;debug.notification("refAnimal1 is " + aOne + " units away.")
			if(refActor1.getCurrentLocation().IsSameLocation(PlayerRef.getCurrentLocation()))
				refActor1.SetActorValue("WaitingForPlayer", 0)
				pDialogueFollower.SetObjectiveDisplayed(20, abdisplayed = false)
				;debug.messagebox("refAnimal1 is in the same location.")
				iCount +=1
			else	
				if (aOne < 10000)
					refActor1.SetActorValue("WaitingForPlayer", 0)
					pDialogueFollower.SetObjectiveDisplayed(20, abdisplayed = false)
					;pFollowerAlias.UnregisterForUpdateGameTime() 
					iCount +=1
				else
					iFar += 1			
				endIf
			endIf
		else
			iFollow += 1
		endIf
	endIf
	if(refActor2)
		If (refActor2.GetActorValue("WaitingforPlayer") == 1)
			aTwo = refActor2.GetDistance(PlayerRef)
			;debug.notification("refAnimal2 is " + aTwo + " units away.")
			if(refActor2.getCurrentLocation().IsSameLocation(PlayerRef.getCurrentLocation()))
				refActor2.SetActorValue("WaitingForPlayer", 0)
				pDialogueFollower.SetObjectiveDisplayed(22, abdisplayed = false)
				;debug.messagebox("refAnimal2 is in the same location.")
				iCount +=1
			else	
				if (aTwo < 10000)
					refActor2.SetActorValue("WaitingForPlayer", 0)
					pDialogueFollower.SetObjectiveDisplayed(22, abdisplayed = false)
					;pFollowerAlias.UnregisterForUpdateGameTime() 
					iCount +=1
				else
					iFar += 1			
				endIf
			endIf
		else
			iFollow += 1
		endIf
	endIf	
	if(refActor3)
		If (refActor3.GetActorValue("WaitingforPlayer") == 1)
			aThree = refActor3.GetDistance(PlayerRef)
			;debug.notification("refAnimal3 is " + aThree + " units away.")
			if(refActor3.getCurrentLocation().IsSameLocation(PlayerRef.getCurrentLocation()))
				refActor3.SetActorValue("WaitingForPlayer", 0)
				pDialogueFollower.SetObjectiveDisplayed(24, abdisplayed = false)
				;debug.messagebox("refAnimal3 is in the same location.")
				iCount +=1
			else	
				if (aThree < 10000)
					refActor3.SetActorValue("WaitingForPlayer", 0)
					pDialogueFollower.SetObjectiveDisplayed(24, abdisplayed = false)
					;pFollowerAlias.UnregisterForUpdateGameTime() 
					iCount +=1
				else
					iFar += 1			
				endIf
			endIf
		else
			iFollow += 1
		endIf
	endIf	
	if(notif == 1 && Check == 1)
		int random
		random = Utility.RandomInt(0, 39)
		if(iCount && (aOne && aOne < 4000 || aTwo && aTwo < 4000 || aThree && aThree < 4000)) ;this will only happen when there is no followers or troll
			if(random < 10)
				debug.notification("They rumble...")	
			elseIf((random > 9) && (random < 20)) 
				debug.notification("They snarl...")	
			else
				debug.notification("They growl...")				
			endIf
		elseIf(iCount)
			if(random < 10)
				debug.notification("A faint bay echoes...")	
			elseIf((random > 9) && (random < 20)) 
				debug.notification("A faint howl echoes...")	
			else
				debug.notification("A faint growl echoes...")			
			endIf
		elseIf(iFar && iFollow)
			if(random < 10)
				debug.notification("Well some are following...")
			elseIf((random > 9) && (random < 20)) 
				debug.notification("You hear no response...")	
			else
				debug.notification("Perhaps they are too far away...")
			endIf			
		elseIf(iFar)
			if(random < 10)
				debug.notification("You near no acknowledgement...")
			elseIf((random > 9) && (random < 20)) 
				debug.notification("You hear no response...")	
			else
				debug.notification("Perhaps they are too far away...")
			endIf
		else
			;all animals are already following			
		endIf
		utility.wait(0.5)
	endIf
	iCount += iFar ;let's the return know that something happened here	
	Return iCount
	
EndFunction

Int Function TrollFollow(Int Check)

	float tOne
	int iCount
	int iFar
	float notif = gNotif.GetValue()
	actor troll = TrollFollower1.GetReference() as actor
	if(troll)
		If (troll.GetActorValue("WaitingforPlayer") == 1)
			tOne = troll.GetDistance(PlayerRef)
			if(troll.getCurrentLocation().IsSameLocation(PlayerRef.getCurrentLocation()))
				troll.SetActorValue("WaitingForPlayer", 0)
				iCount +=1
			else	
				if (tOne < 10000)
					troll.SetActorValue("WaitingForPlayer", 0)
					iCount +=1
				else
					iFar += 1
				endIf
			endIf
		else
			Return iCount ;this is here because there is a one troll max at the moment
		endIf
	endIf	
	if(notif == 1 && Check == 2)
		if(iCount && (tOne < 4000))
			debug.notification("The troll follows...")	
		elseIf(iCount)
			debug.notification("A trollish bellow echoes in the distance...")
		elseIf(iFar)
			debug.notification("The troll may be too far away...")	
		else
			;troll is already following
		endIf
		utility.wait(0.5)
	endIf
	iCount += iFar ;let's the return know that something happened here		
	Return iCount
	
EndFunction

Event OnUpdate()

	actor refActor1 = FollowerRef1.GetReference() as actor
	actor refActor2 = FollowerRef2.GetReference() as actor
	actor refActor3 = FollowerRef3.GetReference() as actor
	actor refAnimal1 = AnimalRef1.GetReference() as actor
	actor refAnimal2 = AnimalRef2.GetReference() as actor
	actor refAnimal3 = AnimalRef3.GetReference() as actor
	actor refTroll1 = TrollFollower1.GetReference() as actor
	actor target1 = refActor1.GetCombatTarget()
	actor target2 = refActor2.GetCombatTarget() 
	actor target3 = refActor3.GetCombatTarget() 
	actor target4 = refAnimal1.GetCombatTarget() 
	actor target5 = refAnimal2.GetCombatTarget() 
	actor target6 = refAnimal3.GetCombatTarget() 
	actor target7 = refTroll1.GetCombatTarget()
	if(target1.IsInFaction(UMFfriendsFaction) || target2.IsInFaction(UMFfriendsFaction) || target3.IsInFaction(UMFfriendsFaction) || target4.IsInFaction(UMFfriendsFaction) || target5.IsInFaction(UMFfriendsFaction) || target6.IsInFaction(UMFfriendsFaction) || target7.IsInFaction(UMFfriendsFaction))
		;PlayerRef.StopCombatAlarm()
		if(refActor1 != none)
			refActor1.StopCombatAlarm()	
		endIf
		if(refActor2 != none)
			refActor2.StopCombatAlarm()
		endIf
		if(refActor3 != none)		
			refActor3.StopCombatAlarm()	
		endIf
		if(refAnimal1 != none)
			refAnimal1.StopCombatAlarm()	
		endIf
		if(refAnimal2 != none)
			refAnimal2.StopCombatAlarm()	
		endIf
		if(refAnimal3 != none)
			refAnimal3.StopCombatAlarm()	
		endIf
		if(refTroll1 != none)
			refTroll1.StopCombatAlarm()	
		endIf	
	endIf
	
EndEvent