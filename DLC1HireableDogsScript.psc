Scriptname DLC1HireableDogsScript extends Quest  Conditional

Faction Property PlayerFollowerFaction  Auto  

DialogueFollowerScript Property DialogueFollower Auto

GlobalVariable Property PlayerAnimalCount Auto

DLC1RadiantScript property DLC1Radiant auto

Function HireDog(actor NewDog)
	(DialogueFollower as DialogueFollowerScript).SetAnimal(NewDog)

	NewDog.SetPlayerTeammate(abCanDoFavor = false)
EndFunction

Function BootCurrentAnimalAndHireDog(actor NewDog)
	if PlayerAnimalCount.GetValue() >= 3
		(DialogueFollower as DialogueFollowerScript).DismissAnimal()
	endif
	HireDog(NewDog)
endFunction

