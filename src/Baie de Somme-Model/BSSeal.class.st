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
		'sealAction'
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

self sealAction: 'Check repository'.
self actionCount: (Cormas random * 100 + 5) rounded.
]

{ #category : #behavior }
BSSeal >> changeActionToResting [

|candidates|

candidates := self patch neighbourhood select: [ :cell | cell sealRestingPlace = self restingPlace ].

self sealAction: 'Resting'.
self actionCount: 0.
self moveTo: (candidates atRandom).
]

{ #category : #behavior }
BSSeal >> changeActionToSwimming [

self sealAction: 'Swimming'.
self actionCount: (Cormas random * 10 + 10) rounded.
]

{ #category : #behavior }
BSSeal >> changeRepository [

self selectRepository.
self changeActionToSwimming.
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
	self sight: scope2.
]

{ #category : #behavior }
BSSeal >> escapeInSea [

| candidatePatch occupiedRestingPlaces|

candidatePatch := self patch neighbourhood select: [ :cell | cell type = 'Sea'  ].

self moveTo: candidatePatch atRandom.
self changeActionToSwimming.

occupiedRestingPlaces := self patch neighbourhood select: [ :cell | cell hasOccupantsOfClass: self class ].
occupiedRestingPlaces do: [ :cell | cell theOccupants do: [ :occupantTable | occupantTable do: [ :seal | (seal class = #BSSeal) ifTrue: [ self giveAlertTo: seal ] ] ] ].
]

{ #category : #behavior }
BSSeal >> giveAlertTo: seal [

seal isAlerted.
]

{ #category : #initialization }
BSSeal >> initialize [

	super initialize.
	self alertLevel: 0.
	

]

{ #category : #behavior }
BSSeal >> isAlerted [

self alertLevel: 2.
]

{ #category : #behavior }
BSSeal >> lookForRepository [

| destinationToRepository |

destinationToRepository := (self patch neighbourhood select: [:cell | cell sealRestingPlace = self restingPlace ]) asOrderedCollection.

destinationToRepository isEmpty
 ifTrue: [^ self moveToRestingPlace].

(self myRestingPlace select: [ :cell | (cell hasOccupantsOfClass: BSWalker) or: [ cell hasOccupantsOfClass: BSBoat ] ]) isEmpty
	ifTrue: [ self moveTo: destinationToRepository atRandom ]
	ifFalse: [ self selectNewRestingPlace ]

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
	ifTrue: [ ^ self alertLevel: 2 ].
	
(self sight anySatisfy: [ :cell | (cell hasOccupantsOfClass: BSWalker) ])
	ifTrue: [ ^ self alertLevel: 1 ].
	
self alertLevel: 0.
]

{ #category : #behavior }
BSSeal >> moveAroundRepository [

	| candidates |
	candidates := self patch neighbourhoodAndSelf select: [ :cell | 
		              cell type = 'Sea' ].
	candidates := candidates reject: [ :cell | 
		              self patch hasOccupantsOfClass: BSBoat ].
	candidates := candidates select: [ :cell | 
		              self patch neighbourhood anySatisfy: [ :x | 
			              x sealRestingPlace = self restingPlace ] ].
	
candidates ifEmpty: [ self changeActionToSwimming. ] ifNotEmpty: [ self moveTo: candidates atRandom ].
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

| candidates |

candidates:= self patch neighbourhoodAndSelf select: [ :cell | (cell type = 'Sea')].

self moveTo: candidates atRandom.

self actionCount: actionCount - 1.
]

{ #category : #behavior }
BSSeal >> moveToRestingPlace [

| directionToRepository |

directionToRepository := (Cormas selectRandomlyFrom: restingPlaceMemory constrainedBy: [:cell | cell sealRestingPlace = self restingPlace ]).
self moveTowards: directionToRepository constraintOnPath: [ :cell | cell type = 'Sea' or: [ cell sealRestingPlace = self restingPlace ] ]


]

{ #category : #behavior }
BSSeal >> moveTowardRepository [

self moveTowards: myRestingPlace constraintOnPath: [ :cell | (cell type = 'Sea') or: [ (cell = myRestingPlace )] ].

(self patch neighbourhood anySatisfy: [ :cell | cell = myRestingPlace ])
	ifTrue: [ self changeActionToCheckRepository ].
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
BSSeal >> sealAction [

	^ sealAction
]

{ #category : #accessing }
BSSeal >> sealAction: anObject [

	sealAction := anObject
]

{ #category : #behavior }
BSSeal >> selectNewRestingPlace [

| formerRestingPlace |

formerRestingPlace := restingPlace.

self restingPlace: (Cormas selectRandomlyFrom: restingPlaceMemory constrainedBy: [ :cell | cell sealRestingPlace ~= formerRestingPlace ]) sealRestingPlace.
self myRestingPlace: (restingPlaceMemory select: [ :cell | cell sealRestingPlace = restingPlace ]).
]

{ #category : #behavior }
BSSeal >> selectRepository [

| formerRestingPlace |

formerRestingPlace := self myRestingPlace. 

self myRestingPlace: (self restingPlaceMemory select: [ :cell | cell ~= formerRestingPlace ]).
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
	
	self sealAction ifNil: [ self stepSealStart ].
		
	(self sealAction = 'Resting') ifTrue: [ self stepResting ].
	(self sealAction = 'Swimming') ifTrue: [ self stepSwimming ].
	(self sealAction = 'Check repository') ifTrue: [ self stepCheckRepository ].
]

{ #category : #stepping }
BSSeal >> stepCheckRepository [

self defineVision.

((self monitorRepository) & (self patch neighbourhoodAndSelf anySatisfy: [ :x | x sealRestingPlace = self restingPlace ])) ifTrue: [ ^ self changeActionToResting ].
(self actionCount = 0) ifTrue: [ ^ self changeActionToSwimming ].
self moveAroundRepository.
(self actionCount > 0) ifTrue: [ actionCount := actionCount - 1 ].


]

{ #category : #stepping }
BSSeal >> stepResting [

self defineVision.
(self alertLevel < 2) ifTrue: [self monitorSurroundingsOnRepository].
(self alertLevel > 1) ifTrue: [ self escapeInSea ].
]

{ #category : #stepping }
BSSeal >> stepSealStart [

(self patch type = 'Beach') ifTrue: [ self changeActionToResting ].

(self patch type = 'Sea') ifTrue: [ self changeActionToSwimming ].
]

{ #category : #stepping }
BSSeal >> stepSwimming [

self defineVision.
	
(self actionCount = 0)
	ifTrue: [ ^ self moveTowardRepository ].

self moveInWater.



]
