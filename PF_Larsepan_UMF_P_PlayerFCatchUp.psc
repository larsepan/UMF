;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname PF_Larsepan_UMF_P_PlayerFCatchUp Extends Package Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(Actor akActor)
;BEGIN CODE
akActor.EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(Actor akActor)
;BEGIN CODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; by Larsepan
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Future script will involve a marker that moves on cell change.  
; This marker will be used as a base for spawning npcs

float spawnNo = gLocation.GetValue()
int iNewSpawn = spawnNo as Int
float xMod
float yMod
float x
float y
float z

if(iNewSpawn == 0)
	xMod = -96
	yMod = -64
	iNewSpawn += 1
elseIf(iNewSpawn == 1)
	xMod = 0
	yMod = -64
	iNewSpawn += 1
elseIf(iNewSpawn == 2)
	xMod = 96
	yMod = -64
	iNewSpawn += 1
elseIf(iNewSpawn == 3)
	xMod = -96
	yMod = -96
	iNewSpawn += 1
elseIf(iNewSpawn == 4)
	xMod = 0
	yMod = -96
	iNewSpawn += 1
else
	xMod = 96
	yMod = -96
	iNewSpawn = 0
endIf
	
if(xSpawnMarker.GetParentCell() == PlayerRef.GetParentCell())
	yMod += 64 ;since the player just changed cells, the followers can spawn here as well
	x = xMod * Math.Sin(xSpawnMarker.GetAngleZ())
	y = yMod * Math.Cos(xSpawnMarker.GetAngleZ())
	z = xSpawnMarker.GetHeight() - 0
	akActor.MoveTo(xSpawnMarker, x, y, z, true)
else
	x = xMod * Math.Sin(PlayerRef.GetAngleZ())
	y = yMod * Math.Cos(PlayerRef.GetAngleZ())
	z = PlayerRef.GetHeight() - 0
	akActor.MoveTo(PlayerRef, x, y, z, true)
endIf


if(!iNewSpawn)
	gLocation.SetValue(0)
else
	gLocation.Mod(-spawnNo)
	gLocation.Mod(iNewSpawn)
endIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
 
Actor Property PlayerRef  Auto  

GlobalVariable Property gLocation  Auto 

ObjectReference property xSpawnMarker auto
