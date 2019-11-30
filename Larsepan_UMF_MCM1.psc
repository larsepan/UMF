;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; by Larsepan
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Scriptname Larsepan_UMF_MCM1 extends SKI_ConfigBase

;VERSION
int function GetVersion()
	return 1 ;Default Version - aka UMF 1.5.0
endFunction

;PROPERTIES
Actor Property PlayerRef  Auto  
Faction Property Assassin Auto
Faction Property DismissedFollowerFaction  Auto
Faction Property Thief Auto
Faction Property UMFfriendsFaction Auto 
FormList Property UMFList  Auto
GlobalVariable Property gCommandsToggle  Auto
GlobalVariable Property gConfigSwitch  Auto
GlobalVariable Property gFolRide Auto
GlobalVariable Property gIgnore Auto
GlobalVariable Property gLively Auto
GlobalVariable Property gNotif  Auto  
GlobalVariable Property pPlayerAnimalCount  Auto  
GlobalVariable Property pPlayerFollowerCount  Auto  
Keyword Property vampire Auto
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

;STATES
Bool bNotif = false;
Bool bSpell = True;
Bool bFolRide = false;
;Bool bLively = false;
Bool bIgnore = false;
int livelyIndex = 0

;OPTION IDS OR OIDS
Int notifOID 
Int spellOID
Int folRideOID
;Int livelyOID
Int livelyOID_M
Int ignoreOID

;OPTIONS LISTS
string[] livelyList

;HOTKEYS
int Property WaitKeyCode = -1 Auto
int Property FollowKeyCode = -1 Auto
int Property CheckKeyCode = -1 Auto
int Property DismissKeyCode = -1 Auto

;CHECK FOR VERSION UPDATE
Event OnVersionUpdate(int a_version)

	;if (a_version >= 2 && CurrentVersion < 2)
		;Debug.Trace(self + ": Updating to script version 2")
		;OnConfigInit()
	;endIf

EndEvent

;PAGES
Event OnConfigInIt()

Pages = new string [1]
Pages[0] = "$UMFconfig"

EndEvent

Event OnInIt()

	parent.OnInIt()	
	livelyList = new String[3]
	livelyList[0] = "$OFF"
	livelyList[1] = "$ON"
	livelyList[2] = "$ONhelm"
	
EndEvent

;PAGE RESET
Event OnPageReset(string page)

	;int checkComm = gCommand.GetValue() as int
	int checkLively = gLively.GetValue() as int
	int checkNotif = gNotif.GetValue() as int
	int checkRide = gFolRide.GetValue() as int
	int checkSpell = gConfigSwitch.GetValue() as int
	int checkIgnore = gIgnore.GetValue() as int

	
	;GLOBAL CHECKS
	;if(checkLively != bLively)
	;	bLively = !bLively
	;	SetToggleOptionValue(livelyOID, bLively)
	;endIf
	
	if(checkLively != livelyIndex)
		livelyIndex = checkLively
		SetMenuOptionValue(livelyOID_M, livelyList[livelyIndex])
	endIf	
	if(checkNotif != bNotif)
		bNotif = !bNotif
		SetToggleOptionValue(notifOID, bNotif)
	endIf
	if(checkRide != bFolRide)
		bFolRide = !bFolRide	
		SetToggleOptionValue(folRideOID, bFolRide)	
	endIf	
	if(checkSpell != bSpell)
		bSpell = !bSpell
		SetToggleOptionValue(spellOID, bSpell)		
	endIf	
	if(checkIgnore != bIgnore)
		bIgnore = !bIgnore
		SetToggleOptionValue(ignoreOID, bIgnore)
	endIf
	
	;IMAGE
	if(page == "")
		LoadCustomContent("LarsepanUMF/LarsepanUMF.dds")
		return
	else
		UnloadCustomContent()
	endIf
	
	;MENU LAYOUT
	if(page == "$UMFconfig")

			int unmap = OPTION_FLAG_WITH_UNMAP
			SetCursorFillMode(LEFT_TO_RIGHT)
			AddHeaderOption("$Followers") ;left
			AddHeaderOption("$Commands") ;right
			;iComm = AddToggleOption("$Commands", bComm) ;left
			ignoreOID = AddToggleOption("$IgnoreFriendlyFire", bIgnore) ;left			
			AddTextOptionST("Followers_Wait", "$Everyone", "$Wait") ;right
			;livelyOID = AddToggleOption("$UseLively", bLively) ;left
			livelyOID_M = AddMenuOption("$UseLively", livelyList[livelyIndex]) ;left
			AddTextOptionST("Followers_Follow", "$Everyone", "$Follows") ;right
			folRideOID = AddToggleOption("$UseRide", bFolRide) ;left
			AddTextOptionST("Followers_Check", "$Everyone", "$Check") ;right
			AddEmptyOption() ;SPACE left	
			AddTextOptionST("Followers_Dismiss", "$Everyone", "$Dismiss") ;right
		
			AddHeaderOption("$Options") ;left
			AddEmptyOption() ;SPACE right
			notifOID = AddToggleOption("$Notifications", bNotif) ;left
			AddHeaderOption("$Hotkeys") ;right
			spellOID = AddToggleOption("$UMFconfigSpell", bSpell) ;left
		
			AddKeyMapOptionST("Wait_KeyMap", "$WaitHotkey", WaitKeyCode, unmap)
			AddEmptyOption() ;SPACE left
			AddKeyMapOptionST("Follow_KeyMap", "$FollowHotkey", FollowKeyCode, unmap)
			AddHeaderOption("$Help") ;left
			AddKeyMapOptionST("Check_KeyMap", "$CheckHotkey", CheckKeyCode, unmap)
			AddTextOptionST("Fix_Followers", "$UpdateFix", "$Apply") ;left
			AddKeyMapOptionST("Dismiss_KeyMap", "$DismissHotkey", DismissKeyCode, unmap)
			AddTextOptionST("Clear_Followers", "$ClearFollowers", "$Apply") ;left
		
	endIf
	
EndEvent

Event OnOptionMenuOpen(int option)

	if(option == livelyOID_M)
		SetMenuDialogOptions(livelyList)
		SetMenuDialogStartIndex(livelyIndex)
		SetMenuDialogDefaultIndex(0)
	endIf

EndEvent

Event OnOptionMenuAccept(int option, int index)

	if(option == livelyOID_M)
		livelyIndex = index
		gLively.SetValue(livelyIndex)
		SetMenuOptionValue(livelyOID_M, livelyList[livelyIndex])
	endIf

EndEvent

Event OnOptionSelect(int option)
	int checkLively = gLively.GetValue() as int
	int checkNotif = gNotif.GetValue() as int
	int checkRide = gFolRide.GetValue() as int
	int checkSpell = gConfigSwitch.GetValue() as int
	int checkIgnore = gIgnore.GetValue() as int
	
	if(CurrentPage == "$UMFconfig")
	
		;if (option == livelyOID)

		;	if (checkLively == 0  && bLively == false)
		;		bLively = !bLively
		;		SetToggleOptionValue(livelyOID, bLively)
		;		gLively.SetValue(1)
		;		;ShowMessage("UMF Lively Followers set to... ON")
		;	elseif (checkLively == 1  && bLively == true)
		;		bLively = !bLively
		;		SetToggleOptionValue(livelyOID, bLively)
		;		gLively.SetValue(0)
		;		;ShowMessage("UMF Lively Followers set to... OFF")
		;	else
		;		gLively.SetValue(0)
		;		bLively = false;
		;		SetToggleOptionValue(livelyOID, bLively)
		;		ShowMessage("Toggle switch error: UMF Lively Followers set to... OFF")
		;	endIf
					
		if (option == ignoreOID)	
		
			if (checkIgnore == 0  && bIgnore == false)
				bool continue = false
				string Fwarning = "$UMF_YesNo1"
				continue = ShowMessage(Fwarning, true, "$Yes", "$No")
				if (continue)
					bIgnore = !bIgnore
					SetToggleOptionValue(ignoreOID, bIgnore)
					FriendlyFire(0)
					;ShowMessage("UMF Ignore Friendly Fire set to... ON", False)		
				endIf
			elseif (checkIgnore == 1  && bIgnore == true)
				bIgnore = !bIgnore
				SetToggleOptionValue(ignoreOID, bIgnore)
						FriendlyFire(1)
				;ShowMessage("UMF Ignore Friendly Fire set to... OFF", False)
			else
				gIgnore.SetValue(0)
				bIgnore = false;
				SetToggleOptionValue(ignoreOID, bIgnore)
				ShowMessage("$UMF_ERROR1", False)
			endIf	

		elseIf (option == notifOID)

			if (checkNotif == 0  && bNotif == false)
				bNotif = !bNotif
				SetToggleOptionValue(notifOID, bNotif)
				gNotif.SetValue(1)
				;ShowMessage("UMF Notifications have been set to... ON", False)
			elseif (checkNotif == 1  && bNotif == true)
				bNotif = !bNotif
				SetToggleOptionValue(notifOID, bNotif)
				gNotif.SetValue(0)
				;ShowMessage("UMF Notifications have been set to... OFF", False)
			else
				gNotif.SetValue(0)
				bNotif = false;
				SetToggleOptionValue(notifOID, bNotif)
				ShowMessage("$UMF_ERROR2", False)
			endIf
					
		elseIf (option == folRideOID)

			if (checkRide == 0  && bFolRide == false)
				bFolRide = !bFolRide
				SetToggleOptionValue(folRideOID, bFolRide)
				gFolRide.SetValue(1)
				;ShowMessage("UMF Ride Assistance set to... ON", False)
			elseif (checkRide == 1  && bFolRide == true)
				bFolRide = !bFolRide
				SetToggleOptionValue(folRideOID, bFolRide)
				gFolRide.SetValue(0)
				;ShowMessage("UMF Ride Assistance set to... OFF", False)
			else
				gFolRide.SetValue(0)
				bFolRide = false;
				SetToggleOptionValue(folRideOID, bFolRide)
				ShowMessage("$UMF_ERROR3", False)
			endIf
				
		elseIf (option == spellOID)
			float commands = gCommandsToggle.GetValue()
			if (checkSpell == 0  && bSpell == false)
				bSpell = !bSpell
				SetToggleOptionValue(spellOID, bSpell)
				gConfigSwitch.SetValue(1)
				if(!commands)
					if (PlayerRef.AddSpell(ConfigSpell))
					endIf
				else
					if (PlayerRef.AddSpell(CommandSpell))
					endIf
				endIf
				;ShowMessage("UMF Config Spell has been set to... ON", False)
			elseif (checkSpell == 1  && bSpell == true)
				bSpell = !bSpell
				SetToggleOptionValue(spellOID, bSpell)
				gConfigSwitch.SetValue(0)
				if(!commands)
					if (PlayerRef.RemoveSpell(ConfigSpell))
					endIf
				else
					if (PlayerRef.RemoveSpell(CommandSpell))
					endIf
				endIf
				;ShowMessage("UMF Config Spell has been set to... OFF", False)			
			else
				gConfigSwitch.SetValue(0)
				bSpell = false;
				SetToggleOptionValue(spellOID, bSpell)
				ShowMessage("$UMF_ERROR4", False)
			endIf

		endIf
	
	endIf

EndEvent

event OnOptionHighlight(int option)

	;if (option == livelyOID)
	if (option == livelyOID_M)
		SetInfoText("$UMF_INFO1")
	elseIf (option == ignoreOID)
		SetInfoText("$UMF_INFO2")
	elseIf (option == notifOID)
		SetInfoText("$UMF_INFO3")
	elseIf (option == folRideOID)
		SetInfoText("$UMF_INFO4")				
	elseIf (option == spellOID)
		SetInfoText("$UMF_INFO5")
	endIf
	
endEvent

State Followers_Wait
	
	event OnSelectST()	
		HotkeyWait(1)
	endEvent
	
	event OnHighlightST()
		SetInfoText("$UMF_INFO6")	
	endEvent
	
EndState

Function HotkeyWait(Int iMessage)

	float notif = gNotif.GetValue()	
	int fCount = pPlayerFollowerCount.GetValue() as int
	int aCount = pPlayerAnimalCount.GetValue() as int
	actor refTroll1 = TrollFollower1.GetReference() as actor
	int total = fCount + aCount
	if(refTroll1)
		total += 1
	endIf
	int iCountWait = CountWait()
	if(iCountWait != total)  ;If all the followers are waiting change total to zero
		(pDialogueFollower as DialogueFollowerScript).FollowerWait()
		(pDialogueFollower as DialogueFollowerScript).AnimalWait()
		(DLC1RadiantQuest as DLC1RadiantScript).TrollWait()
	else	
		total = 0
	endIf
	if (iMessage)
		if(notif == 1)
			int random
			random = Utility.RandomInt(0, 39)
			if(!total)
				if(random < 3)
					ShowMessage("$NotifWait1", False)
				elseIf((random > 2) && (random < 6)) 
					ShowMessage("$NotifWait2", False)
				else
					ShowMessage("$NotifWait3", False)				
				endIf
			else
				if(random < 10)
					ShowMessage("$NotifWait4", False)	
				elseIf((random > 9) && (random < 20)) 
					ShowMessage("$NotifWait5", False)	
				else
					ShowMessage("$NotifWait6", False)			
				endIf
			endIf
		else
			if(!total)
				ShowMessage("$NotifWait7", False)
			else
				ShowMessage("$NotifWait8", False)
			endIf
		endIf 
	else
		if(notif == 1)
			int random
			random = Utility.RandomInt(0, 39)
			if(!total)
				if(random < 3)
					debug.notification("$NotifWait1")
				elseIf((random > 2) && (random < 6)) 
					debug.notification("$NotifWait2")
				else
					debug.notification("$NotifWait3")				
				endIf
			else
				if(random < 10)
					debug.notification("$NotifWait4")	
				elseIf((random > 9) && (random < 20)) 
					debug.notification("$NotifWait5")	
				else
					debug.notification("$NotifWait6")			
				endIf
			endIf
		; else
			; if(total == 0 && refTroll1 == none)
				; debug.notification("$NotifWait7")
			; else
				; debug.notification("$NotifWait8")
			; endIf
		endIf 	
	endIf

EndFunction

State Followers_Follow

	event OnSelectST()
		HotkeyFollow(1)
	endEvent
	
	event OnHighlightST()
		SetInfoText("$UMF_INFO7")	
	endEvent
	
EndState

Function HotkeyFollow(Int iMessage)

	float notif = gNotif.GetValue()
	int fCount = pPlayerFollowerCount.GetValue() as int
	int aCount = pPlayerAnimalCount.GetValue() as int
	int iFollow
	int addFollow
	int iCheck = 0 ;this is just a helper for keeping notification amounts in check
	;zero equals follower notifs will take precedence
	;one equals animal notifs will take precedence
	;two equals trolls notifs
	actor refTroll1 = TrollFollower1.GetReference() as actor
	if(fCount)
		if(!aCount && !refTroll1)
			iCheck = 3
		endIf
		iFollow = FollowerFollow(iCheck, iMessage)
	endIf
	if(aCount)
		if(!fCount || !iFollow)
			iCheck = 1	
		endIf
		addFollow = AnimalFollow(iCheck, iMessage)
		iFollow += addFollow
	endIf
	if(refTroll1)
		if((!fCount && !aCount) || !iFollow)
			iCheck = 2
		endIf
		addFollow = TrollFollow(iCheck, iMessage)
		iFollow += addFollow
	endIf
	if (iMessage)
		if(notif == 1)
			int random
			random = Utility.RandomInt(0, 39)
			if(!fCount && !aCount && !refTroll1)
				if(random < 3)
					ShowMessage("$NotifFollow1", False)
				elseIf((random > 2) && (random < 6)) 
					ShowMessage("$NotifFollow2", False)
				else
					ShowMessage("$NotifFollow3", False)			
				endIf			
			elseIf(!iFollow)
				int iCountWait = CountWait()
				if(!iCountWait)
					ShowMessage("$NotifFollow4", False)
				endIf
			endIf
		else
			if(!fCount && !aCount && !refTroll1)
				ShowMessage("$NotifFollow5", False)
			else
				ShowMessage("$NotifFollow6", False)
			endIf
		endIf
	else
		if(notif == 1)
			int random
			random = Utility.RandomInt(0, 39)
			if(!fCount && !aCount && !refTroll1)
				if(random < 3)
					debug.notification("$NotifFollow1")
				elseIf((random > 2) && (random < 6)) 
					debug.notification("$NotifFollow2")
				else
					debug.notification("$NotifFollow3")			
				endIf			
			elseIf(!iFollow)
				int iCountWait = CountWait()
				if(!iCountWait)
					debug.notification("$NotifFollow4")		
				endIf
			endIf
		; else
			; if(!fCount && !aCount && !refTroll1)
				; debug.notification("$NotifFollow5")
			; else
				; debug.notification("$NotifFollow6")
			; endIf
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

State Followers_Check

	event OnSelectST()
		HotkeyCheck(1)
	endEvent
	
	event OnHighlightST()
		SetInfoText("$UMF_INFO8")	
	endEvent
	
EndState

Function HotkeyCheck(Int iMessage)

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
		if(iMessage)
			if(notif)
				if(iCatchup && !iWait)
					int random
					random = Utility.RandomInt(0, 39)
					if(random < 10)
						ShowMessage("$NotifCheck1", False)	
					elseIf((random > 9) && (random < 20)) 
						ShowMessage("$NotifCheck2", False)	
					else
						ShowMessage("$NotifCheck3", False)				
					endIf
					random = Utility.RandomInt(0, 39)
					if(random < 10)
						ShowMessage("$NotifCheck4", False)	
					elseIf((random > 9) && (random < 20)) 
						ShowMessage("$NotifCheck5", False)	
					else
						ShowMessage("$NotifCheck6", False)				
					endIf
				elseIf (iCatchup && iWait)
					int random
					random = Utility.RandomInt(0, 39)
					if(random < 10)
						ShowMessage("$NotifCheck1", False)	
					elseIf((random > 9) && (random < 20)) 
						ShowMessage("$NotifCheck2", False)	
					else
						ShowMessage("$NotifCheck3", False)				
					endIf
					random = Utility.RandomInt(0, 39)
					if(random < 10)
						ShowMessage("$NotifCheck7", False)	
					elseIf((random > 9) && (random < 20)) 
						ShowMessage("$NotifCheck8", False)	
					else
						ShowMessage("$NotifCheck9", False)				
					endIf
				endIf
			endIf
		else
			if(notif)
				if(iCatchup && !iWait)
					int random
					random = Utility.RandomInt(0, 39)
					if(random < 10)
						debug.notification("$NotifCheck1")	
					elseIf((random > 9) && (random < 20)) 
						debug.notification("$NotifCheck2")	
					else
						debug.notification("$NotifCheck3")				
					endIf
					utility.wait(2)
					random = Utility.RandomInt(0, 39)
					if(random < 10)
						debug.notification("$NotifCheck4")	
					elseIf((random > 9) && (random < 20)) 
						debug.notification("$NotifCheck5")	
					else
						debug.notification("$NotifCheck6")				
					endIf
				elseIf (iCatchup && iWait)
					int random
					random = Utility.RandomInt(0, 39)
					if(random < 10)
						debug.notification("$NotifCheck1")	
					elseIf((random > 9) && (random < 20)) 
						debug.notification("$NotifCheck2")	
					else
						debug.notification("$NotifCheck3")				
					endIf
					utility.wait(2)
					random = Utility.RandomInt(0, 39)
					if(random < 10)
						debug.notification("$NotifCheck7")	
					elseIf((random > 9) && (random < 20)) 
						debug.notification("$NotifCheck8")	
					else
						debug.notification("$NotifCheck9")				
					endIf
				endIf
			endIf		
		endIf
	endIf
	
	;COMMENTS WHEN NO FOLLOWERS NEED STOPPING OR CATCHING UP
	if (iMessage) ;I could use IsInMenuMode instead here - I think this is better though
		if(notif == 1 && !iCatchup && !iCount)
			int random
			random = Utility.RandomInt(0, 39)
			if(!iCount)
				if(PlayerRef.Haskeyword(vampire))
					if(random < 3)
						ShowMessage("$NotifRamble1", False)	
					elseIf((random > 2) && (random < 6)) 
						ShowMessage("$NotifRamble2", False)					
					elseIf((random > 5) && (random < 10)) 
						ShowMessage("$NotifRamble3", False)	
					else
						ShowMessage("$NotifRamble4", False)	
					endIf
				elseIf(PlayerRef.IsInFaction(Thief) || PlayerRef.IsInFaction(Assassin))
					if(random < 3)
						ShowMessage("$NotifRamble5", False)	
					elseIf((random > 2) && (random < 6)) 
						ShowMessage("$NotifRamble6", False)					
					elseIf((random > 5) && (random < 10)) 
						ShowMessage("$NotifRamble7", False)	
					else
						ShowMessage("$NotifRamble8", False)
					endIf			
				else
					if(random < 3)
						ShowMessage("$NotifRamble9", False)	
					elseIf((random > 2) && (random < 6)) 
						ShowMessage("$NotifRamble10", False)					
					elseIf((random > 5) && (random < 10))
						ShowMessage("$NotifRamble11", False)	
						ShowMessage("$NotifRamble12", False)
					else
						ShowMessage("$NotifRamble13", False)
					endIf			
				endIf
			else
				if(random < 10)
					ShowMessage("$NotifStop1", False)
				elseIf((random > 9) && (random < 20)) 
					ShowMessage("$NotifStop2", False)
				else
					ShowMessage("$NotifStop3", False)				
				endIf
			endIf
		else
			if(iCatchup)
				;no notification needed
			elseIf(!iCount)
				ShowMessage("$NotifStop4", False)
			else
				ShowMessage("$NotifStop5", False)
			endIf
		endIf
	else
		if(notif == 1 && !iCatchup && !iCount)
			int random
			random = Utility.RandomInt(0, 39)
			if(!iCount)
				if(PlayerRef.Haskeyword(vampire))
					if(random < 3)
						debug.notification("$NotifRamble1")	
					elseIf((random > 2) && (random < 6)) 
						debug.notification("$NotifRamble2")					
					elseIf((random > 5) && (random < 10)) 
						debug.notification("$NotifRamble3")	
					else
						debug.notification("$NotifRamble4")	
					endIf
				elseIf(PlayerRef.IsInFaction(Thief) || PlayerRef.IsInFaction(Assassin))
					if(random < 3)
						debug.notification("$NotifRamble5")	
					elseIf((random > 2) && (random < 6)) 
						debug.notification("$NotifRamble6")					
					elseIf((random > 5) && (random < 10)) 
						debug.notification("$NotifRamble7")	
					else
						debug.notification("$NotifRamble8")
					endIf			
				else
					if(random < 3)
						debug.notification("$NotifRamble9")	
					elseIf((random > 2) && (random < 6)) 
						debug.notification("$NotifRamble10")					
					elseIf((random > 5) && (random < 10))
						debug.notification("$NotifRamble11")
						utility.wait(1)						
						debug.notification("$NotifRamble12")
					else
						debug.notification("$NotifRamble13")
					endIf			
				endIf
			else
				if(random < 10)
					debug.notification("$NotifStop1")
				elseIf((random > 9) && (random < 20)) 
					debug.notification("$NotifStop2")
				else
					debug.notification("$NotifStop3")				
				endIf
			endIf
		else
			;if(iCatchup)
				;no notification needed
			;elseIf(!iCount)
			;	debug.notification("$NotifStop4")
			;else
			;	debug.notification("$NotifStop5")
			;endIf
		endIf	
	endIf

EndFunction

State Followers_Dismiss

	event OnSelectST()
		FollowerDismiss(1)
	endEvent
	
	event OnHighlightST()
		SetInfoText("$UMF_INFO9")	
	endEvent
	
EndState

Function FollowerDismiss(Int iMessage)

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
	if (iMessage)	
		if(notif == 1)	
			int random
			random = Utility.RandomInt(0, 39)		
			if(!iCount && !aCount)
				if(random < 3)
					ShowMessage("$NotifDismiss1", False)	
				elseIf((random > 2) && (random < 6)) 
					ShowMessage("$NotifDismiss2", False)	
				elseIf((random > 5) && (random < 10))	
					ShowMessage("$NotifDismiss3", False)				
				else
					ShowMessage("$NotifDismiss4", False)			
				endIf	
			elseIf(!iCount && aCount)
				ShowMessage("$NotifDismiss5", False)	
			elseIf(iCount && !aCount)
				ShowMessage("$NotifDismiss6", False)	
			else
				ShowMessage("$NotifDismiss7", False)		
			endIf
		else
			if(iCount == 0)
				ShowMessage("$NotifDismiss8", False)
			else
				ShowMessage("$NotifDismiss9", False)
			endIf			
		endIf
	else
		if(notif == 1)	
			int random
			random = Utility.RandomInt(0, 39)		
			if(!iCount && !aCount)
				if(random < 3)
					debug.notification("$NotifDismiss1")	
				elseIf((random > 2) && (random < 6)) 
					debug.notification("$NotifDismiss2")	
				elseIf((random > 5) && (random < 10))	
					debug.notification("$NotifDismiss3")				
				else
					debug.notification("$NotifDismiss4")			
				endIf	
			elseIf(!iCount && aCount)
				debug.notification("$NotifDismiss5")	
			elseIf(iCount && !aCount)
				debug.notification("$NotifDismiss6")	
			else
				debug.notification("$NotifDismiss7")		
			endIf
		;else
		;	if(iCount == 0)
		;		debug.notification("$NotifDismiss8")
		;	else
		;		debug.notification("$NotifDismiss9")
		;	endIf			
		endIf	
	endIf

EndFunction


State Fix_Followers ; TEXT

	event OnSelectST()

		float zOutF = pPlayerFollowerCount.GetValue()
		float zOutA = pPlayerAnimalCount.GetValue()
		actor refActor1 = FollowerRef1.GetReference() as actor
		actor refActor2 = FollowerRef2.GetReference() as actor
		actor refActor3 = FollowerRef3.GetReference() as actor
		actor refAnimal1 = AnimalRef1.GetReference() as actor
		actor refAnimal2 = AnimalRef2.GetReference() as actor
		actor refAnimal3 = AnimalRef3.GetReference() as actor
		actor refTroll1 = TrollFollower1.GetReference() as actor
		float countF
		float countA
		int ifCount
		int iaCount

		;FOLLOWER CHECK
		if(refActor1 != none)
			if(refActor1 == refActor2)
				FollowerRef2.Clear()
			endIf
			if(refActor1 == refActor3)
				FollowerRef3.Clear()
			endIf
			ifCount += 1
			If !(refActor1.IsInFaction(UMFfriendsFaction))
				refActor1.AddtoFaction(UMFfriendsFaction)
			endIf
			UMFList.AddForm(refActor1)
			refActor1.EvaluatePackage()
		endIf
		refActor2 = FollowerRef2.GetReference() as actor ;update since it might've been cleared
		if(refActor2 != none)
			if(refActor2 == refActor3)
				FollowerRef3.Clear()
			endIf
			if(refActor1 == none)
				FollowerRef2.Clear()
				FollowerRef1.ForceRefTo(refActor2)
			endIf
			ifCount += 1
			If !(refActor2.IsInFaction(UMFfriendsFaction))
				refActor2.AddtoFaction(UMFfriendsFaction)
			endIf
			UMFList.AddForm(refActor2)
			refActor2.EvaluatePackage()
		endIf
		refActor3 = FollowerRef3.GetReference() as actor ;update since it might've been cleared
		if(refActor3 != none)
			if(refActor1 == none)
				FollowerRef3.Clear()
				FollowerRef1.ForceRefTo(refActor3)
			endIf
			ifCount += 1
			If !(refActor3.IsInFaction(UMFfriendsFaction))
				refActor3.AddtoFaction(UMFfriendsFaction)
			endIf
			UMFList.AddForm(refActor3)
			refActor3.EvaluatePackage()
		endIf
	
		;ANIMAL CHECK
		if(refAnimal1 != none)
			if(refAnimal1 == refAnimal2)
				AnimalRef2.Clear()
			endIf
			if(refAnimal1 == refAnimal3)
				AnimalRef3.Clear()
			endIf
			iaCount += 1
			If !(refAnimal1.IsInFaction(UMFfriendsFaction))
				refAnimal1.AddtoFaction(UMFfriendsFaction)
			endIf
			UMFList.AddForm(refAnimal1)
			refAnimal1.EvaluatePackage()
		endIf
		refAnimal2 = AnimalRef2.GetReference() as actor ;update since it might've been cleared
		if(refAnimal2 != none)
			if(refAnimal2 == refAnimal3)
				AnimalRef3.Clear()
			endIf
			if(refAnimal1 == none)
				AnimalRef2.Clear()
				AnimalRef1.ForceRefTo(refAnimal2)
			endIf
			iaCount += 1
			If !(refAnimal2.IsInFaction(UMFfriendsFaction))
				refAnimal2.AddtoFaction(UMFfriendsFaction)
			endIf
			UMFList.AddForm(refAnimal2)
			refAnimal2.EvaluatePackage()
		endIf
		refAnimal3 = AnimalRef3.GetReference() as actor ;update since it might've been cleared
		if(refAnimal3 != none)
			if(refAnimal1 == none)
				AnimalRef3.Clear()
				AnimalRef1.ForceRefTo(refAnimal3)
			endIf
			iaCount += 1
			If !(refAnimal3.IsInFaction(UMFfriendsFaction))
				refAnimal3.AddtoFaction(UMFfriendsFaction)
			endIf
			UMFList.AddForm(refAnimal3)
			refAnimal3.EvaluatePackage()
		endIf
		if(refTroll1 != none)
			refTroll1.EvaluatePackage()
		endIf
		
		;SET GLOBALS IF NECESSARY
		countF = ifCount as float
		countA = iaCount as float	
		if(zOutF != countF)
			pPlayerFollowerCount.SetValue(ifCount)
		endIf
		if(zOutA != countA)
			pPlayerAnimalCount.SetValue(iaCount)
		endIf	
		if(!ifCount && !iaCount && !refTroll1)
			;there are no followers so no need for notification
		elseIf(!ifCount && !iaCount && refTroll1)
				ShowMessage("$RegisterFollowers1", False)
		elseIf(!refTroll1)
			if(ifCount != 1 && !iaCount)
				ShowMessage("$RegisterFollowers2{" + ifCount + "}", False)			
			elseIf(ifCount == 1 && !iaCount)
				ShowMessage("$RegisterFollowers3{" + ifCount + "}", False)			
			elseIf(!ifCount && iaCount != 1)
				ShowMessage("$RegisterFollowers4{" + iaCount + "}", False)			
			elseIf(!ifCount && iaCount == 1)
				ShowMessage("$RegisterFollowers5{" + iaCount + "}", False)					
			elseIf(ifCount != 1 && iaCount != 1)
				ShowMessage("$RegisterFollowers6{" + ifCount + "}{" + iaCount + "}", False)
			elseIf(ifCount == 1 && iaCount != 1)
				ShowMessage("$RegisterFollowers7{" + ifCount + "}{" + iaCount + "}", False)
			elseIf(ifCount != 1 && iaCount == 1)
				ShowMessage("$RegisterFollowers8{" + ifCount + "}{" + iaCount + "}", False)
			else
				ShowMessage("$RegisterFollowers9{" + ifCount + "}{" + iaCount + "}", False)	
			endIf
		else
			if(ifCount != 1 && !iaCount)
				ShowMessage("$RegisterFollowers10{" + ifCount + "}", False)			
			elseIf(ifCount == 1 && !iaCount)
				ShowMessage("$RegisterFollowers11{" + ifCount + "}", False)			
			elseIf(!ifCount && iaCount != 1)
				ShowMessage("$RegisterFollowers12{" + ifCount + "}", False)			
			elseIf(!ifCount && iaCount == 1)
				ShowMessage("$RegisterFollowers13{" + ifCount + "}", False)	
			elseIf(ifCount != 1 && iaCount != 1)
				ShowMessage("$RegisterFollowers14{" + ifCount + "}{" + iaCount + "}", False)
			elseIf(ifCount == 1 && iaCount != 1)
				ShowMessage("$RegisterFollowers15{" + ifCount + "}{" + iaCount + "}", False)
			elseIf(ifCount != 1 && iaCount == 1)
				ShowMessage("$RegisterFollowers16{" + ifCount + "}{" + iaCount + "}", False)
			else
				ShowMessage("$RegisterFollowers17{" + ifCount + "}{" + iaCount + "}", False)	
			endIf
		endIf	
		Int iIndex = UMFList.GetSize()
		ShowMessage("$RegisterUMFmanage{" + iIndex + "}", False)
	
	endEvent
	
	event OnHighlightST()
		SetInfoText("$UMF_INFO10")	
	endEvent
	
EndState

State Clear_Followers ; TEXT

	event OnSelectST()
	
		bool continue = false
		string Fwarning = "$ClearWarning"			
		continue = ShowMessage(Fwarning, true, "$Yes", "$No")
		if (continue)
			ShowMessage("$ClearStart", False)
			actor refActor1 = FollowerRef1.GetReference() as actor
			actor refActor2 = FollowerRef2.GetReference() as actor
			actor refActor3 = FollowerRef3.GetReference() as actor
			actor refAnimal1 = AnimalRef1.GetReference() as actor
			actor refAnimal2 = AnimalRef2.GetReference() as actor
			actor refAnimal3 = AnimalRef3.GetReference() as actor
			actor refTroll1 = TrollFollower1.GetReference() as actor
			float notif = gNotif.GetValue()

			if(refActor3 != none)
				(pDialogueFollower as DialogueFollowerScript).LarsepanDismissFollower(0, 0, refActor3)
			endIf
			if(refActor2 != none)
				(pDialogueFollower as DialogueFollowerScript).LarsepanDismissFollower(0, 0, refActor2)
			endIf
			if(refActor1 != none)
				(pDialogueFollower as DialogueFollowerScript).LarsepanDismissFollower(0, 0, refActor1)
			endIf
			if(refAnimal3 != none)
				(pDialogueFollower as DialogueFollowerScript).LarsepanDismissAnimal(refAnimal3)
			endIf
			if(refAnimal2 != none)
				(pDialogueFollower as DialogueFollowerScript).LarsepanDismissAnimal(refAnimal2)
			endIf
			if(refAnimal1 != none)
				(pDialogueFollower as DialogueFollowerScript).LarsepanDismissAnimal(refAnimal1)
			endIf
			if(refTroll1 != none)
				(DLC1RadiantQuest as DLC1RadiantScript).TrollDismissed()
			endIf
			Int iIndex = UMFList.GetSize()
			if(iIndex > 0)
				String Name
				while iIndex > 0
					iIndex -=1
					actor deleteMe = UMFList.GetAt(iIndex) as actor
					deleteMe.RemoveFromFaction(UMFfriendsFaction)
					Name = deleteMe.GetBaseObject().GetName()
					if(notif == 1)
						debug.notification("$Remove" + Name)
					endIf
				endWhile
				UMFList.Revert()
				debug.notification("$ClearFinish")
			endIf
		endIf

	endEvent
	
	event OnHighlightST()
		SetInfoText("$UMF_INFO11")
	endEvent
	
endState

Function FriendlyFire (int fNum)

	actor refActor1 = FollowerRef1.GetReference() as actor
	actor refActor2 = FollowerRef2.GetReference() as actor
	actor refActor3 = FollowerRef3.GetReference() as actor
	actor refAnimal1 = AnimalRef1.GetReference() as actor
	actor refAnimal2 = AnimalRef2.GetReference() as actor
	actor refAnimal3 = AnimalRef3.GetReference() as actor
	actor refTroll1 = TrollFollower1.GetReference() as actor
	if(fNum == 0)
		gIgnore.SetValue(1)
		if(refActor1 != none)	
			refActor1.IgnoreFriendlyHits(true)
		endIf
		if(refActor2 != none)
			refActor2.IgnoreFriendlyHits(true)		
		endIf
		if(refActor3 != none)		
			refActor3.IgnoreFriendlyHits(true)	
		endIf
		if(refAnimal1 != none)	
			refAnimal1.IgnoreFriendlyHits(true)	
		endIf
		if(refAnimal2 != none)	
			refAnimal2.IgnoreFriendlyHits(true)
		endIf
		if(refAnimal3 != none)
			refAnimal3.IgnoreFriendlyHits(true)
		endIf
		if(refTroll1 != none)
			refTroll1.IgnoreFriendlyHits(true)	
		endIf
	else
		gIgnore.SetValue(0)
		if(refActor1 != none)				
			refActor1.IgnoreFriendlyHits(false)
		endIf
		if(refActor2 != none)
				refActor2.IgnoreFriendlyHits(false)
		endIf
		if(refActor3 != none)		
				refActor3.IgnoreFriendlyHits(false)
		endIf
		if(refAnimal1 != none)
				refAnimal1.IgnoreFriendlyHits(false)	
		endIf
		if(refAnimal2 != none)	
				refAnimal2.IgnoreFriendlyHits(false)	
		endIf
		if(refAnimal3 != none)	
				refAnimal3.IgnoreFriendlyHits(false)	
		endIf
		if(refTroll1 != none)
			refTroll1.IgnoreFriendlyHits(false)	
		endIf
	endIf

EndFunction

Int Function FollowerFollow(Int Check, Int iMessage)

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
				;ShowMessage("refActor1 is in the same location.")
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
				;ShowMessage("refActor2 is in the same location.")
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
				;ShowMessage("refActor3 is in the same location.")
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
		if (iMessage)
			if(iCount && (fOne && fOne < 4000 || fTwo && fTwo < 4000 || fThree && fThree < 4000)) ;this is the default - followers are now following response
				if(random < 10)
					ShowMessage("$NotifFollow10", False)	
				elseIf((random > 9) && (random < 20)) 
					ShowMessage("$NotifFollow11", False)	
				else
					ShowMessage("$NotifFollow12", False)	
				endIf
			elseIf(iCount) ;farther away waiting followers are on their way
				if(random < 10)		
					ShowMessage("$NotifFollow7", False)
				elseIf((random > 9) && (random < 20)) 
					ShowMessage("$NotifFollow8", False)	
				else
					ShowMessage("$NotifFollow9", False)			
				endIf					
			elseIf(iFar && iFollow) ;a follower is currently following and a waiting follower is too far away to follow
				if(random < 10)
					ShowMessage("$NotifFollow13", False)
				elseIf((random > 9) && (random < 20)) 
					ShowMessage("$NotifFollow30", False)	
				else
					ShowMessage("$NotifFollow15", False)	
				endIf					
			elseIf(iFar) ;all waiting followers are too far away to follow
				if(random < 10)
					ShowMessage("$NotifFollow31", False)
				elseIf((random > 9) && (random < 20)) 
					ShowMessage("$NotifFollow30", False)	
				else
					ShowMessage("$NotifFollow15", False)	
				endIf
			else
				;all followers are already following
			endIf
		else
			if(iCount && (fOne && fOne < 4000 || fTwo && fTwo < 4000 || fThree && fThree < 4000)) 
				if(random < 10)
					debug.notification("$NotifFollow10")	
				elseIf((random > 9) && (random < 20)) 
					debug.notification("$NotifFollow11")	
				else
					debug.notification("$NotifFollow12")	
				endIf
			elseIf(iCount)
				if(random < 10)		
					debug.notification("$NotifFollow7")
				elseIf((random > 9) && (random < 20)) 
					debug.notification("$NotifFollow8")	
				else
					debug.notification("$NotifFollow9")			
				endIf
			elseIf(iFar && iFollow)
				if(random < 10)
					debug.notification("$NotifFollow13")
				elseIf((random > 9) && (random < 20)) 
					debug.notification("$NotifFollow30")	
				else
					debug.notification("$NotifFollow15")	
				endIf					
			elseIf(iFar)
				if(random < 10)
					debug.notification("$NotifFollow31")
				elseIf((random > 9) && (random < 20)) 
					debug.notification("$NotifFollow30")	
				else
					debug.notification("$NotifFollow15")	
				endIf
			else
				;all followers are already following
			endIf		
		endIf
	endIf
	iCount += iFar ;let's the return know that something happened here
	Return iCount
	
EndFunction

Int Function AnimalFollow(Int Check, Int iMessage)

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
				;ShowMessage("refAnimal1 is in the same location.")
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
				;ShowMessage("refAnimal2 is in the same location.")
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
				;ShowMessage("refAnimal3 is in the same location.")
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
		if (iMessage)
			if(iCount && (aOne && aOne < 4000 || aTwo && aTwo < 4000 || aThree && aThree < 4000)) ;this will only happen when there is no followers or troll
				if(random < 10)
					ShowMessage("$NotifFollow19", False)	
				elseIf((random > 9) && (random < 20)) 
					ShowMessage("$NotifFollow20", False)	
				else
					ShowMessage("$NotifFollow21", False)				
				endIf
			elseIf(iCount)
				if(random < 10)
					ShowMessage("$NotifFollow16", False)	
				elseIf((random > 9) && (random < 20)) 
					ShowMessage("$NotifFollow17", False)	
				else
					ShowMessage("$NotifFollow18", False)			
				endIf
			elseIf(iFar && iFollow)
				if(random < 10)
					ShowMessage("$NotifFollow13", False)
				elseIf((random > 9) && (random < 20)) 
					ShowMessage("$NotifFollow30", False)	
				else
					ShowMessage("$NotifFollow15", False)	
				endIf	
			elseIf(iFar)
				if(random < 10)
					ShowMessage("$NotifFollow26", False)
				elseIf((random > 9) && (random < 20)) 
					ShowMessage("$NotifFollow30", False)	
				else
					ShowMessage("$NotifFollow15", False)	
				endIf
			else
				;all animals are already following
			endIf
		else
			if(iCount && (aOne && aOne < 4000 || aTwo && aTwo < 4000 || aThree && aThree < 4000)) ;this will only happen when there are no followers
				if(random < 10)
					debug.notification("$NotifFollow19")	
				elseIf((random > 9) && (random < 20)) 
					debug.notification("$NotifFollow20")	
				else
					debug.notification("$NotifFollow21")				
				endIf
			elseIf(iCount)
				if(random < 10)
					debug.notification("$NotifFollow16")	
				elseIf((random > 9) && (random < 20)) 
					debug.notification("$NotifFollow17")	
				else
					debug.notification("$NotifFollow18")			
				endIf
			elseIf(iFar && iFollow)
				if(random < 10)
					debug.notification("$NotifFollow13")
				elseIf((random > 9) && (random < 20)) 
					debug.notification("$NotifFollow30")	
				else
					debug.notification("$NotifFollow15")	
				endIf	
			elseIf(iFar)
				if(random < 10)
					debug.notification("$NotifFollow26")
				elseIf((random > 9) && (random < 20)) 
					debug.notification("$NotifFollow30")	
				else
					debug.notification("$NotifFollow15")	
				endIf	
			else
				;all animals are already following				
			endIf		
		endIf
	endIf
	iCount += iFar ;let's the return know that something happened here
	Return iCount
	
EndFunction

Int Function TrollFollow(Int Check, Int iMessage)

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
		if (iMessage)
			if(iCount && (tOne && tOne < 4000))
				ShowMessage("$NotifFollow28", False)
			elseIf(iCount)
				ShowMessage("$NotifFollow27", False)		
			elseIf(iFar)
				ShowMessage("$NotifFollow29", False)
			else
				;troll is already following
			endIf
		else
			if(iCount && (tOne && tOne < 4000))
				debug.notification("$NotifFollow28")
			elseIf(iCount)
				debug.notification("$NotifFollow27")	
			elseIf(iFar)
				debug.notification("$NotifFollow29")
			else
				;troll is already following				
			endIf
		
		endIf
	endIf
	iCount += iFar ;let's the return know that something happened here	
	Return iCount
	
EndFunction


;KEYMAPS
state Wait_KeyMap
    event OnKeyMapChangeST(int newKeyCode, String conflictControl, String conflictName)
		if TestConflict(newKeyCode, conflictControl, conflictName)
			WaitKeyCode = newKeyCode
			RegisterKeys(WaitKeyCode, newKeyCode)
		endIf
    endEvent
    event OnDefaultST()
		int newKeyCode = -1
		WaitKeyCode = newKeyCode
		RegisterKeys(WaitKeyCode, newKeyCode)
    endEvent
    event OnHighlightST()
        SetInfoText("$KeymapWait")
    endEvent
endState

state Follow_KeyMap
    event OnKeyMapChangeST(int newKeyCode, String conflictControl, String conflictName)
		if TestConflict(newKeyCode, conflictControl, conflictName)
			FollowKeyCode = newKeyCode
			RegisterKeys(FollowKeyCode, newKeyCode)
		endIf
    endEvent
    event OnDefaultST()
		int newKeyCode = -1
		FollowKeyCode = newKeyCode
		RegisterKeys(FollowKeyCode, newKeyCode)
    endEvent
    event OnHighlightST()
        SetInfoText("$KeymapFollow")
    endEvent
endState

state Check_KeyMap
    event OnKeyMapChangeST(int newKeyCode, String conflictControl, String conflictName)
		if TestConflict(newKeyCode, conflictControl, conflictName)
			CheckKeyCode = newKeyCode
			RegisterKeys(CheckKeyCode, newKeyCode)
		endIf
    endEvent
    event OnDefaultST()
		int newKeyCode = -1
		CheckKeyCode = newKeyCode
		RegisterKeys(CheckKeyCode, newKeyCode)
    endEvent
    event OnHighlightST()
        SetInfoText("$KeymapCheck")
    endEvent
endState

state Dismiss_KeyMap
    event OnKeyMapChangeST(int newKeyCode, String conflictControl, String conflictName)
		if TestConflict(newKeyCode, conflictControl, conflictName)
			DismissKeyCode = newKeyCode
			RegisterKeys(DismissKeyCode, newKeyCode)
		endIf
    endEvent
    event OnDefaultST()
		int newKeyCode = -1
		DismissKeyCode = newKeyCode
		RegisterKeys(DismissKeyCode, newKeyCode)
    endEvent
    event OnHighlightST()
        SetInfoText("$KeymapDismiss")
    endEvent
endState

;ON HOTKEY PRESSED
event OnKeyDown(int KeyCode)
	;the zero in the below functions tell the function to select notification over show message
	if KeyCode == -1 || Utility.IsInMenuMode() || UI.IsTextInputEnabled()
		return
	endIf
	if KeyCode == WaitKeyCode
		HotkeyWait(0) 
	endIf
	if KeyCode == FollowKeyCode
		HotkeyFollow(0) 
	endIf
	if KeyCode == CheckKeyCode
		HotkeyCheck(0) 
	endIf
	if KeyCode == DismissKeyCode
		FollowerDismiss(0) 
	endIf	
	
endEvent

bool Function TestConflict(int keyCode, String conflictControl, String conflictName)

	if (conflictControl != "" && keyCode > 0)
		String msg 
		if (conflictName != "")
			msg = ("$UMFkeyConflict{" + conflictControl + " (" + conflictName + ")}")
		else
			msg = ("$UMFkeyConflict{" + conflictControl + "}")
		endIf
		return ShowMessage(msg, true, "$Yes", "$No")
	else
		return true
	endIf
	
EndFunction

Function RegisterKeys(int oldKey, int newKey)

	UnregisterForKey(oldKey)
	SetKeymapOptionValueST(newKey)
	RegisterForKey(newKey)
	
EndFunction

Event OnUpdate()

	actor refActor1 = FollowerRef1.GetReference() as actor
	actor refActor2 = FollowerRef2.GetReference() as actor
	actor refActor3 = FollowerRef3.GetReference() as actor
	actor refAnimal1 = AnimalRef1.GetReference() as actor
	actor refAnimal2 = AnimalRef2.GetReference() as actor
	actor refAnimal3 = AnimalRef3.GetReference() as actor
	actor refTroll1 = TrollFollower1.GetReference() as actor

	PlayerRef.StopCombatAlarm()
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
	
EndEvent


