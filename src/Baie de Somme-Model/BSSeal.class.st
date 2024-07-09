Class {
	#name : #BSSeal,
	#superclass : #CMAgent,
	#traits : 'TCMLocated',
	#classTraits : 'TCMLocated classTrait',
	#instVars : [
		'restingPlace',
		'sight',
		'alertLevel',
		'myRestingPlace',
		'restingPlaceMemory',
		'actionCount',
		'currentStatus',
		'disturbanceCount',
		'lastPlace'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSSeal >> actionCount [

	^ actionCount
]

{ #category : #accessing }
BSSeal >> actionCount: anObject [

	actionCount := anObject
]

{ #category : #accessing }
BSSeal >> alertLevel [

	^ alertLevel
]

{ #category : #accessing }
BSSeal >> alertLevel: anObject [

	alertLevel := anObject
]

{ #category : #behavior }
BSSeal >> alertRepository [

| friends |
friends := OrderedCollection new.

self myRestingPlace do: [ :cell | (cell hasOccupantsOfClass: self class) 
	ifTrue: [ cell theOccupants do: [ :each | each do: [ :each2 | friends add: each2 ] ] ] ].

friends isEmpty ifTrue: [ ^self ].
friends do: [ :seal | self giveAlertTo: seal ].
]

{ #category : #behavior }
BSSeal >> changeActionToCheckRepository [

self currentStatus: 'Check repository'.
self actionCount: (Cormas random * 10 + 5) rounded.
self stepCheckRepository.
]

{ #category : #behavior }
BSSeal >> changeActionToResting [

self currentStatus: 'Resting'.
self actionCount: 0.

(self patch sealRestingPlace = self restingPlace) ifTrue: [ self myRestingPlace: self patch ].

(self patch type = 'Sea') ifTrue: [ self moveTo: self myRestingPlace ].

self stepResting.
]

{ #category : #behavior }
BSSeal >> changeActionToSwimming [

self currentStatus: 'Swimming'.
self actionCount: (Cormas random * 10 + 15) rounded.
disturbanceCount := disturbanceCount + 1.
]

{ #category : #accessing }
BSSeal >> currentStatus [

	^ currentStatus 
]

{ #category : #accessing }
BSSeal >> currentStatus: anObject [

	currentStatus := anObject
]

{ #category : #behavior }
BSSeal >> defineVision [

|scope1 scope2|
	scope1 := OrderedCollection new.
	scope2 := OrderedCollection new.
	scope1 := patch neighbourhoodAndSelf.
	scope2 := scope1.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope2 := scope1.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	self sight: scope2.
]

{ #category : #accessing }
BSSeal >> disturbanceCount [

	^ disturbanceCount
]

{ #category : #accessing }
BSSeal >> disturbanceCount: anObject [

	disturbanceCount := anObject
]

{ #category : #behavior }
BSSeal >> escapeInSea [
"S'il y a un danger (promeneur ou bateau) trop près, les phoques préviennent leurs congénères et s'échappent à l'eau"
| candidatePatch occupiedRestingPlaces|
"Donner l'alerte:"
occupiedRestingPlaces := self sight select: [ :cell | ((cell hasOccupantsOfClass: self class) & (cell sealRestingPlace = self patch sealRestingPlace )) ].
occupiedRestingPlaces do: [ :cell | cell theOccupants do: [ :occupantTable | occupantTable do: [ :seal | (seal class = self class) ifTrue: [ self giveAlertTo: seal ] ] ] ].

"S'échapper à l'eau"
candidatePatch := self patch neighbourhood select: [ :cell | cell type = 'Sea'  ].
self moveTo: candidatePatch atRandom.
self changeActionToSwimming.
]

{ #category : #behavior }
BSSeal >> giveAlertTo: seal [

seal isAlerted.
]

{ #category : #initialization }
BSSeal >> initialize [

	super initialize.
	self alertLevel: 0.
	self disturbanceCount: 0.
	

]

{ #category : #behavior }
BSSeal >> isAlerted [

self alertLevel: 1.
]

{ #category : #accessing }
BSSeal >> lastPlace [

	^ lastPlace
]

{ #category : #accessing }
BSSeal >> lastPlace: anObject [

	lastPlace := anObject
]

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

{ #category : #behavior }
BSSeal >> monitorRepository [

| securityLevel |
securityLevel := 0.

(self sight anySatisfy: [:cell | (cell hasOccupantsOfClass: BSBoat) or: [ cell hasOccupantsOfClass: BSWalker ] ]) ifTrue: [ securityLevel := 1 ].

^ (securityLevel = 0)

]

{ #category : #behavior }
BSSeal >> monitorSurroundingsOnRepository [

(self patch neighbourhood anySatisfy: [ :cell | (cell hasOccupantsOfClass: BSWalker) or: [ cell hasOccupantsOfClass: BSBoat ] ])
	ifTrue: [ ^ self escapeInSea ].
	
self alertLevel: 0.
]

{ #category : #behavior }
BSSeal >> moveAroundRepository [

	| candidates |
	candidates := self patch neighbourhoodAndSelf select: [ :cell | 
		              cell type = 'Sea' ].
	candidates := candidates select: [ :cell | 
		              cell neighbourhood anySatisfy: [ :cell2 | 
			              cell2 sealRestingPlace = self restingPlace ] ].
	
candidates ifEmpty: [ ^ self changeActionToSwimming ] ifNotEmpty: [ self moveTo: candidates atRandom ].
]

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

{ #category : #moving }
BSSeal >> moveInDirectionOf: aCell constraintOnPath: aBlock [
	"Purpose: moves one cell in direction of a given location, taking a specified constraint on each cell of the path to destination.
Argument: aCell = <SpatialEntityElement>
Example: self moveTowards: self house patch constraintOnPath: [:c | c isClosed not]"

	| path candidate dist|
	dist:=3.
	
	self isSituated ifTrue: [
		self patch = aCell ifFalse: [
			path := self patch wayTo: aCell.
			"path remove: self patch."
			
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

self moveTowards: myRestingPlace constraintOnPath: [ :cell | (cell type = 'Sea') or: [ cell sealRestingPlace = self restingPlace ]].
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

{ #category : #stepping }
BSSeal >> step [
self defineVision.
"Cette méthode permet de déterminer l'action du phoque, s'il est sur un reposoir c'est qu'il se repose. Dans l'eau il peu soit nager, soit se diriger vers son reposoir."	
	self currentStatus ifNil: [ self stepSealStart ].
		
	(self currentStatus = 'Resting') ifTrue: [ ^ self stepResting ].
	(self currentStatus = 'Swimming') ifTrue: [ ^ self stepSwimming ].
	(self currentStatus = 'Check repository') ifTrue: [ ^ self stepCheckRepository ].
]

{ #category : #stepping }
BSSeal >> stepCheckRepository [
"Cette méthode vise à modéliser le comportement d'un phoque qui arrête de nager pour retourner se reposer sur son reposoir"
"Un contrôle pour vérifier que le phoque n'est pas déjà sur son reposoir auquel cas on arrête là"
(self patch sealRestingPlace = self restingPlace) ifTrue: [ ^ self changeActionToResting ].
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
	ifFalse: [ self moveTowardRepository ].

(self actionCount > 0) ifTrue: [ actionCount := actionCount - 1 ].


]

{ #category : #stepping }
BSSeal >> stepResting [

(self alertLevel < 1) 
	ifTrue: [self monitorSurroundingsOnRepository]
	ifFalse: [ self escapeInSea ].
]

{ #category : #stepping }
BSSeal >> stepSealStart [

(self patch type = 'Beach') ifTrue: [ self changeActionToResting ].

(self patch type = 'Sea') ifTrue: [ self changeActionToSwimming ].
]

{ #category : #stepping }
BSSeal >> stepSwimming [

(self actionCount = 0)
	ifTrue: [ (self patch neighbourhood anySatisfy: [:cell | cell sealRestingPlace = self restingPlace ])
		ifTrue: [ ^ self changeActionToCheckRepository ]
		ifFalse: [ ^ self moveTowardRepository ]
	].

self moveInWater.



]
