Class {
	#name : #BSSeal,
	#superclass : #CMAgent,
	#traits : 'TCMLocated',
	#classTraits : 'TCMLocated classTrait',
	#instVars : [
		'restingPlace',
		'sightSea',
		'sightLand',
		'sightRepository',
		'alertLevel',
		'myRestingPlace',
		'restingPlaceMemory',
		'energyInWater',
		'energy'
	],
	#category : #'Baie de Somme-Model'
}

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
BSSeal >> defineVision [

self defineVisionLand.
self defineVisionSea.
]

{ #category : #behavior }
BSSeal >> defineVisionLand [

|scope1 scope2|
	scope1 := OrderedCollection new.
	scope2 := OrderedCollection new.
	scope1 := patch neighbourhoodAndSelf.
	scope2 := scope1 select: [ :cell | cell type = 'Land' ].
	scope1 := scope2.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope2 := scope1 select: [ :cell | cell type = 'Land' ].
	scope1 := scope2.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope2 := scope1 select: [ :cell | cell type = 'Land' ].
	self sightLand: scope2.
]

{ #category : #behavior }
BSSeal >> defineVisionSea [

|scope1 scope2|
	scope1 := OrderedCollection new.
	scope2 := OrderedCollection new.
	scope1 := patch neighbourhoodAndSelf.
	scope2 := scope1 select: [ :cell | cell type = 'Sea' ].
	scope1 := scope2.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope2 := scope1 select: [ :cell | cell type = 'Sea' ].
	scope1 := scope2.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope2 := scope1 select: [ :cell | cell type = 'Sea' ].
	self sightSea: scope2.
]

{ #category : #accessing }
BSSeal >> energy [

	^ energy
]

{ #category : #accessing }
BSSeal >> energy: anObject [

	energy := anObject
]

{ #category : #accessing }
BSSeal >> energyInWater [

	^ energyInWater
]

{ #category : #accessing }
BSSeal >> energyInWater: anObject [

	energyInWater := anObject
]

{ #category : #behavior }
BSSeal >> escapeInSea [

self randomWalkConstrainedBy: 	[ :cell | cell type = 'Sea' ].
self alertLevel: 0.
]

{ #category : #behavior }
BSSeal >> giveAlertTo: seal [

seal isAlerted.
]

{ #category : #initialization }
BSSeal >> initialize [

	super initialize.
	self alertLevel: 0.
	self energyInWater: 0.
	self energy: (30 + (Cormas random * 90) rounded).
	self energyInWater: ((Cormas random * self energy) rounded). 
	
	

]

{ #category : #behavior }
BSSeal >> isAlerted [

self alertLevel: 3.
]

{ #category : #behavior }
BSSeal >> lookForRepository [

| destinationToRepository |

destinationToRepository := (self patch neighbourhood select: [:cell | cell sealRestingPlace = self restingPlace ]) asOrderedCollection.

destinationToRepository isEmpty
 ifTrue: [^ self moveToRestingPlace].

(self myRestingPlace select: [ :cell | cell hasOccupantsOfClass: BSWalker ]) isEmpty
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
BSSeal >> monitorSurroundings [

| danger |
danger := 0.

(self patch neighbourhood select: [ :cell | cell hasOccupantsOfClass: BSWalker "or: [ cell hasOccupantsOfClass: BSBoat ]" ]) isNotEmpty ifTrue: [ ^ self alertLevel: 2 ].

self monitorLand ifFalse: [ ^ self ].
alertLevel := alertLevel + 1. danger := 1.
]

{ #category : #behavior }
BSSeal >> moveInWater [

self randomWalkConstrainedBy: [ :cell | cell type = 'Sea' ].

energyInWater:= energyInWater - 1.
]

{ #category : #behavior }
BSSeal >> moveToRestingPlace [

| directionToRepository |

directionToRepository := (Cormas selectRandomlyFrom: restingPlaceMemory constrainedBy: [:cell | cell sealRestingPlace = self restingPlace ]).
self moveTowards: directionToRepository constraintOnPath: [ :cell | cell type = 'Sea' or: [ cell sealRestingPlace = self restingPlace ] ]


]

{ #category : #accessing }
BSSeal >> myRestingPlace [

	^ myRestingPlace
]

{ #category : #accessing }
BSSeal >> myRestingPlace: anObject [

	myRestingPlace := anObject
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

{ #category : #behavior }
BSSeal >> selectNewRestingPlace [

| formerRestingPlace |

formerRestingPlace := restingPlace.

self restingPlace: (Cormas selectRandomlyFrom: restingPlaceMemory constrainedBy: [ :cell | cell sealRestingPlace ~= formerRestingPlace ]) sealRestingPlace.
self myRestingPlace: (restingPlaceMemory select: [ :cell | cell sealRestingPlace = restingPlace ]).
]

{ #category : #accessing }
BSSeal >> sightLand [

	^ sightLand
]

{ #category : #accessing }
BSSeal >> sightLand: anObject [

	sightLand := anObject
]

{ #category : #accessing }
BSSeal >> sightRepository [

	^ sightRepository
]

{ #category : #accessing }
BSSeal >> sightRepository: anObject [

	sightRepository := anObject
]

{ #category : #accessing }
BSSeal >> sightSea [

	^ sightSea
]

{ #category : #accessing }
BSSeal >> sightSea: anObject [

	sightSea := anObject
]

{ #category : #stepping }
BSSeal >> step [

	(self patch type = 'Sea') 
		ifTrue: [ self stepInSea ]
		ifFalse: [ self stepOnLand ].
]

{ #category : #stepping }
BSSeal >> stepAlert [

(self alertLevel > 1) ifTrue: [ ^ self escapeInSea ].

(self alertLevel = 1) ifTrue: [ ^ energyInWater := energyInWater + 1 ].

(self patch type = 'Land') ifTrue: [energyInWater := energyInWater + 2].
]

{ #category : #stepping }
BSSeal >> stepInSea [

(self energyInWater = 0) ifTrue: [ ^ self lookForRepository ].
self moveInWater.


]

{ #category : #stepping }
BSSeal >> stepOnLand [

(self alertLevel = 3) ifTrue: [ ^ self ].
self defineVision.
self monitorSurroundings.
(self alertLevel = 2) ifTrue: [ self alertRepository ].
]
