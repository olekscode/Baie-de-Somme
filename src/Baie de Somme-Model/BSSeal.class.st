"BSSeal represents a seal in the Baie de Somme simulation.
This class implements the behavior of seals, including resting, moving, and reacting to human presence.
Seals are sensitive to disturbances and will move to different resting places based on their alert level."

Class {
	#name : #BSSeal,
	#superclass : #CMAgent,
	#traits : 'TCMLocated',
	#classTraits : 'TCMLocated classTrait',
	#instVars : [
		'restingPlace',		"Current resting place of the seal"
		'sight',		"Visual range of the seal"
		'alertLevel',		"Current alert level (0-100)"
		'myRestingPlace',	"Preferred resting place"
		'restingPlaceMemory',	"Memory of known resting places"
		'actionCount',		"Counter for current action"
		'currentStatus',	"Current state (e.g., 'Resting', 'Moving')"
		'disturbanceCount',	"Number of disturbances experienced"
		'lastPlace'		"Last visited location"
	],
	#category : #'Baie de Somme-Model'
}

"Returns the current action count"
{ #category : #accessing }
BSSeal >> actionCount [
	^ actionCount
]

"Sets the action count to the specified value"
{ #category : #accessing }
BSSeal >> actionCount: anObject [
	actionCount := anObject
]

"Returns the current alert level"
{ #category : #accessing }
BSSeal >> alertLevel [
	^ alertLevel
]

"Sets the alert level to the specified value"
{ #category : #accessing }
BSSeal >> alertLevel: anObject [
	alertLevel := anObject
]

"Changes the seal's action to 'Check repository' and sets an appropriate duration.
This action involves checking potential resting places."
{ #category : #behavior }
BSSeal >> changeActionToCheckRepository [
	self currentStatus: 'Check repository'.
	self actionCount: (Cormas random * 10 + 5) rounded.
	self stepCheckRepository.
]

"Changes the seal's action to 'Resting' and updates its state.
If the seal is in the sea, it moves to its preferred resting place.
Updates the resting place's seal count."
{ #category : #behavior }
BSSeal >> changeActionToResting [
	self currentStatus: 'Resting'.
	self actionCount: 0.
	(self patch sealRestingPlace = self restingPlace name) ifTrue: [ self myRestingPlace: self patch ].
	(self patch type = 'Sea') ifTrue: [ self moveTo: self myRestingPlace ].
	self restingPlace addSeal: self.
	self stepResting.
]

"Changes the seal's action to 'Swimming' and sets an appropriate duration.
Increments the disturbance count as swimming is often a response to disturbance."
{ #category : #behavior }
BSSeal >> changeActionToSwimming [
	self currentStatus: 'Swimming'.
	self actionCount: (Cormas random * 10 + 15) rounded.
	disturbanceCount := disturbanceCount + 1.
]

"Returns the seal's current status (e.g., 'Resting', 'Swimming', 'Check repository')"
{ #category : #accessing }
BSSeal >> currentStatus [
	^ currentStatus 
]

"Sets the seal's current status"
{ #category : #accessing }
BSSeal >> currentStatus: anObject [
	currentStatus := anObject
]

"Defines the seal's visual range by expanding the neighborhood in two steps.
This determines how far the seal can see potential threats or resting places."
{ #category : #behavior }
BSSeal >> defineVision [
	|scope1 scope2|
	scope1 := OrderedCollection new.
	scope2 := OrderedCollection new.
	scope1 := patch neighbourhoodAndSelf.
	scope2 := scope1 asOrderedCollection.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope1 := scope2.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	self sight: scope2.
]

"Returns the number of disturbances the seal has experienced"
{ #category : #accessing }
BSSeal >> disturbanceCount [
	^ disturbanceCount
]

"Sets the number of disturbances the seal has experienced"
{ #category : #accessing }
BSSeal >> disturbanceCount: anObject [
	disturbanceCount := anObject
]

"Escapes to the sea when disturbed.
Selects a random sea cell in the neighborhood and moves there,
then changes action to swimming."
{ #category : #behavior }
BSSeal >> escapeInSea [
	| candidatePatch |
	candidatePatch := self patch neighbourhood select: [ :cell | cell type = 'Sea'  ].
	self moveTo: candidatePatch atRandom.
	self changeActionToSwimming.
]

"Triggers an alert at the current resting place.
This method is called when the seal detects a potential threat."
{ #category : #behavior }
BSSeal >> giveAlert [
	self restingPlace isAlarmed
]

"Initializes a new seal with default values:
- Sets alert level to 0
- Sets disturbance count to 0
- Inherits basic agent initialization from superclass"
{ #category : #initialization }
BSSeal >> initialize [
	super initialize.
	self alertLevel: 0.
	self disturbanceCount: 0.
]

"Sets the seal's alert level to 1 and marks the resting place as having an ongoing interaction.
This method is called when the seal detects a potential threat."
{ #category : #behavior }
BSSeal >> isAlerted [
	self alertLevel: 1.
	self restingPlace interactionOnGoing: true.
]

"Returns the last place visited by the seal"
{ #category : #accessing }
BSSeal >> lastPlace [
	^ lastPlace
]

"Sets the last place visited by the seal"
{ #category : #accessing }
BSSeal >> lastPlace: anObject [
	lastPlace := anObject
]

"Monitors the land for potential threats from walkers.
Calculates a threat level based on the number and proximity of walkers.
Returns true if the threat level exceeds a threshold (5)."
{ #category : #behavior }
BSSeal >> monitorLand [
	| number dist|
	number := 0.
	(self sightLand do: [ :cell | dist := self patch distanceTo: cell. (cell hasOccupantsOfClass: BSWalker) 
		ifTrue: [ cell theOccupants do: [ :each | each do: [ :each2 | number := number + (each2 groupSize / dist) ]]]
	]).
	(number > 5) 
		ifTrue: [  ^ true ]
		ifFalse: [ ^ false ].
]

"Monitors the repository (resting place) for potential threats.
Checks for the presence of boats or walkers in the vicinity.
Returns true if the area is secure (no threats detected)."
{ #category : #behavior }
BSSeal >> monitorRepository [
	| securityLevel |
	securityLevel := 0.
	(self sight anySatisfy: [:cell | (cell hasOccupantsOfClass: BSBoat) or: [ cell hasOccupantsOfClass: BSWalker ] ]) ifTrue: [ securityLevel := 1 ].
	^ (securityLevel = 0)
]

"Monitors the surroundings of the repository for potential threats.
If walkers or boats are detected, increases the alert level."
{ #category : #behavior }
BSSeal >> monitorSurroundingsOnRepository [
	(self sight anySatisfy: [ :cell | (cell hasOccupantsOfClass: BSWalker) or: [ cell hasOccupantsOfClass: BSBoat ] ])
		ifTrue: [ self alertLevel: 1.
]

"Moves the seal around the repository (resting place).
Selects a random sea cell near the resting place to move to.
If no suitable cells are found, changes action to swimming."
{ #category : #behavior }
BSSeal >> moveAroundRepository [
	| candidates |
	candidates := self patch neighbourhoodAndSelf select: [ :cell | 
		cell type = 'Sea' ].
	candidates := candidates select: [ :cell | 
		cell neighbourhood anySatisfy: [ :cell2 | 
			cell2 sealRestingPlace = self restingPlace name ] ].
	candidates ifEmpty: [ ^ self changeActionToSwimming ] ifNotEmpty: [ self moveTo: candidates atRandom ].
]

"Moves the seal away from detected threats.
Selects a safe sea cell that is not near any walkers or boats.
If no safe cells are found, resets the alert level."
{ #category : #behavior }
BSSeal >> moveAwayFromThreat [
	|candidates|
	candidates := OrderedCollection new.
	self patch neighbourhoodAndSelf do: [ :cell | (cell neighbourhood anySatisfy: [ :cell2 | (cell2 hasOccupantsOfClass: BSBoat) or: [ cell2 hasOccupantsOfClass: BSWalker ] ]) ifFalse: [candidates add: cell]].
	candidates:= candidates select: [ :cell | cell type = 'Sea' ].
	candidates ifEmpty: [ ^ self alertLevel: 0 ].
	self moveTo: (candidates atRandom).
	self alertLevel: 0.
]

"Moves the seal one cell in the direction of a given location.
Takes into account constraints on the path (e.g., only moving through sea cells).
This is a general-purpose movement method used by other movement behaviors."
{ #category : #moving }
BSSeal >> moveInDirectionOf: aCell constraintOnPath: aBlock [
	| path candidate dist|
	dist:=3.
	self isSituated ifTrue: [
		self patch = aCell ifFalse: [
			path := self patch wayTo: aCell.
			path do: [ :cell | (self patch distanceTo: cell) < dist ifTrue: 
				[ candidate := cell asOrderedCollection. dist := self patch distanceTo: cell ] ].
			candidate:= candidate select: [ :c | aBlock value: c ].
			candidate isNotEmpty ifTrue: [ self moveTo: candidate atRandom ]] ]
]

{ #category : #behavior }
BSSeal >> moveInWater [

| candidates elicitedCandidate |


candidates:= self patch neighbourhoodAndSelf select: [ :cell | (cell type = 'Sea')].
candidates := (candidates reject: [ :cell | cell = lastPlace ]).

elicitedCandidate := candidates atRandom.
self lastPlace: self patch.
self moveTo: candidates atRandom.

self actionCount: actionCount - 1.
]

{ #category : #behavior }
BSSeal >> moveToRestingPlace [

self moveTowards: myRestingPlace constraintOnPath: [ :cell | cell type = 'Sea' or: [ cell = self myRestingPlace ] ]


]

{ #category : #behavior }
BSSeal >> moveTowardRepository [

(self patch neighbourhood anySatisfy: [:cell | cell sealRestingPlace = self restingPlace name ])
		ifTrue: [ ^ self changeActionToCheckRepository ].

self moveTowards: myRestingPlace constraintOnPath: [ :cell | (cell type = 'Sea') or: [ cell sealRestingPlace = self restingPlace name ]].
]

{ #category : #accessing }
BSSeal >> myRestingPlace [

	^ myRestingPlace
]

{ #category : #accessing }
BSSeal >> myRestingPlace: anObject [

	myRestingPlace := anObject
]

{ #category : #'as yet unclassified' }
BSSeal >> playWithBoat [

| candidates|
candidates := OrderedCollection new.

candidates := self sight select: [ :cell | (cell hasOccupantsOfClass: BSBoat) and: [ cell type = 'Sea']].

self moveTowards: (candidates atRandom) constraintOnPath: [ :cell | cell type = 'Sea' ].

self curiosity: self curiosity - 1.
]

{ #category : #pov }
BSSeal >> pov [

	^ Color black 
]

{ #category : #accessing }
BSSeal >> restingPlace [

	^ restingPlace
]

{ #category : #accessing }
BSSeal >> restingPlace: anObject [

	restingPlace := anObject
]

{ #category : #accessing }
BSSeal >> restingPlaceMemory [

	^ restingPlaceMemory
]

{ #category : #accessing }
BSSeal >> restingPlaceMemory: anObject [

	restingPlaceMemory := anObject
]

{ #category : #accessing }
BSSeal >> sight [

	^ sight
]

{ #category : #accessing }
BSSeal >> sight: anObject [

	sight := anObject
]

{ #category : #control }
BSSeal >> step [
self defineVision.
"Cette méthode permet de déterminer l'action du phoque, s'il est sur un reposoir c'est qu'il se repose. Dans l'eau il peu soit nager, soit se diriger vers son reposoir."	
	self currentStatus ifNil: [ self stepSealStart ].
		
	(self currentStatus = 'Resting') ifTrue: [ ^ self stepResting ].
	(self currentStatus = 'Swimming') ifTrue: [ ^ self stepSwimming ].
	(self currentStatus = 'Check repository') ifTrue: [ ^ self stepCheckRepository ].
	(self currentStatus = 'Alarmed') ifTrue: [ ^ self escapeInSea ]
]

{ #category : #stepping }
BSSeal >> stepCheckRepository [
"Cette méthode vise à modéliser le comportement d'un phoque qui arrête de nager pour retourner se reposer sur son reposoir"
"Un contrôle pour vérifier que le phoque n'est pas déjà sur son reposoir auquel cas on arrête là"
(self patch sealRestingPlace = self restingPlace name ) ifTrue: [ ^ self changeActionToResting ].
"Si cela fait trop longtemps qu'il attend, il retourne nager, il est dérangé"
(self actionCount = 0) ifTrue: [ ^ self changeActionToSwimming ].

(self patch neighbourhood anySatisfy: [ :cell | cell = myRestingPlace ])
	"Si le phoque est à côté de son reposoir il contrôle qu'il n'y a personne autour"
	ifTrue: [ (self monitorRepository)
		"et s'il n'y a personne autour il va sur son reposoir et se repose"
		ifTrue: [ ^ self changeActionToResting ] 
		"Sinon le phoque attend près de son reposoir"
		]
	"S'il n'est pas à côté de son reposoir il avance vers lui"
	ifFalse: [ self moveTowards: myRestingPlace constraintOnPath: [ :cell | (cell type = 'Sea') or: [ cell sealRestingPlace = self restingPlace name ]]. ].

(self actionCount > 0) ifTrue: [ actionCount := actionCount - 1 ].


]

{ #category : #stepping }
BSSeal >> stepResting [

self monitorSurroundingsOnRepository.

]

{ #category : #stepping }
BSSeal >> stepSealStart [

(self patch type = 'Beach') ifTrue: [ self changeActionToResting ].

(self patch type = 'Sea') ifTrue: [ self changeActionToSwimming ].
]

{ #category : #stepping }
BSSeal >> stepSwimming [

(self actionCount = 0)
	ifTrue: [ ^ self moveTowardRepository ].

self moveInWater.



]
