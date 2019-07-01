ScriptName TrainedAnimalScript extends ReferenceAlias


DialogueFollowerScript Property DialogueFollower Auto
GlobalVariable Property gNotif  Auto
GlobalVariable Property PlayerAnimalCount  Auto 

Event OnUpdateGameTime()
	
	;UMF 1.4.3 REMOVED 3 DAY WAIT TIMER	
	actor fRef = Self.GetActorReference()
	;kill the update if the follower isn't waiting anymore
	;USLEEP advises checking for an empty alias here.																															   
	if(fRef)						   
		If fRef.GetActorValue("WaitingforPlayer") == 0
			UnRegisterForUpdateGameTime()
		Else
			DialogueFollower.LarsepanDismissAnimal(fRef)
			UnRegisterForUpdateGameTime()   
		EndIf	
	endIf
	
EndEvent

Event OnUnload()
	actor fRef = Self.GetActorReference()
	;if follower unloads while waiting for the player, wait three days then dismiss him.
	If fRef.GetActorValue("WaitingforPlayer") == 1
		(GetOwningQuest() as DialogueFollowerScript).LarsepanAnimalWait(fRef)
	EndIf

EndEvent

Event OnDeath(Actor akKiller)

	float notif = gNotif.GetValue()
	float count = PlayerAnimalCount.GetValue()
	int iCount = count as int
	PlayerAnimalCount.Mod(-count)
	iCount -=1
	count = iCount as float
	if(iCount < 0)
		PlayerAnimalCount.SetValue(0)
	else
		PlayerAnimalCount.Mod(count)
	endIf
	if(notif == 1)
		debug.notification(iCount + "/3 animals")				
		;debug.notification("PlayerAnimalCount has been set to " + iCount + ".")	
	endIf						  
	Self.Clear()
	
EndEvent

