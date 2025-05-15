Class {
	#name : 'BSWalkerAlone',
	#superclass : 'BSWalker',
	#instVars : [
		'destinationMemory'
	],
	#category : 'Baie de Somme-Model',
	#package : 'Baie de Somme-Model'
}

{ #category : 'accessing' }
BSWalkerAlone class >> entityName [

	^ 'PromeneurSeul'
]

{ #category : 'behavior' }
BSWalkerAlone >> checkPosition [

	self walkerPath ifNotEmpty: [ ^ self ].

	self way remove: self patch.

	self defineDestination
]

{ #category : 'behavior' }
BSWalkerAlone >> defineDestination [

	self way 
	ifNotEmpty: [ 
		self walkerDestination: way first.
		self walkerPath: (self patch
				 wayTo: self walkerDestination
				 constraint: [ :cell | 
				 cell type = 'Beach' or: [ cell sealRestingPlace = 'Home' ] ]) ]
	ifEmpty: [ ^ self walkerAction: 'Out'].
	
	self walkerPath remove: self patch
]

{ #category : 'behavior' }
BSWalkerAlone >> defineVisionWihtBinolucars [

|scope1 scope2|
	scope1 := OrderedCollection new.
	scope2 := OrderedCollection new.
	scope1 := patch neighbourhoodAndSelf.
	scope2 := scope1.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope1 := scope2.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope1 := scope2.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	self sight: scope2.
]

{ #category : 'behavior' }
BSWalkerAlone >> defineVisionWihtoutBinolucars [

|scope1 scope2|
	scope1 := OrderedCollection new.
	scope2 := OrderedCollection new.
	scope1 := patch neighbourhoodAndSelf.
	scope2 := scope1.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	self sight: scope2.
]

{ #category : 'accessing' }
BSWalkerAlone >> destinationMemory [

	^ destinationMemory
]

{ #category : 'accessing' }
BSWalkerAlone >> destinationMemory: anObject [

	destinationMemory := anObject
]

{ #category : 'initialization' }
BSWalkerAlone >> initialize [ 

| arg |

	super initialize.
	arg := Random new next.

	(arg < 0.5) 
		ifTrue: [ groupSize := (Random new next * 5 + 1) rounded ] 
		ifFalse: [(arg > 0.9) 
			ifTrue: [ groupSize := (Random new next * 5 + 11) rounded ]
			ifFalse: [groupSize := (Random new next * 5 + 6) rounded]].
	
	sealExpectation := 3.
	
]

{ #category : 'behavior' }
BSWalkerAlone >> lookForSpot [

self destinationMemory isNotEmpty
ifTrue: [ ^ self walkerDestination: self destinationMemory atRandom ].

self moveAlongBeach.
]

{ #category : 'behavior' }
BSWalkerAlone >> moveAlongBeach [
	
	|potentialDest|
potentialDest := self patch neighbourhood select: [ :cell | cell ~= self previousCell ].
potentialDest := potentialDest select: [ :cell | (cell type = 'Land') and: [ cell neighbourhood anySatisfy: [:y | y type = 'Sea'] ] ].

potentialDest isEmpty ifTrue: [ ^ self uTurn ].

self walkerDestination: potentialDest atRandom.
]

{ #category : 'behavior' }
BSWalkerAlone >> moveToASeal [

	(self patch neighbourhood select: [ :each | each type = 'Sea' ]) isEmpty
		ifFalse: [ ^ self moveAlongBeach ]
		ifTrue: [ ^ self previousCell: self patch; moveTowards: self walkerDestination ]
		
	
]

{ #category : 'behavior' }
BSWalkerAlone >> moveToDestination [

self previousCell: self patch.
self moveInDirectionOf: walkerDestination constraintOnPath: [ :cell | cell type = 'Land' or: [ cell type = 'Home' ] ]
]

{ #category : 'behavior' }
BSWalkerAlone >> moveWalking [

	| candidates |
	(self walkerAction = 'Out') ifTrue: [ ^ self ].
	
	candidates := (self patch neighbourhood select: [ :cell | 
		               cell = self walkerPath first ]) first.

	self moveTo: candidates.
	self patch stomping: self patch stomping + self groupSize.
	self walkerPath remove: candidates
]

{ #category : 'pov' }
BSWalkerAlone >> pov [
 <pov>
	self walkerAction = 'Out' ifTrue: [ ^ CMPointOfView color: Color black size: 0.0001 ].
	self walkerAction = 'Walking' ifTrue: [ ^ CMPointOfView color: Color red shape: #circle size: 0.7 ].
	self walkerAction = 'Observation' ifTrue: [ ^ CMPointOfView color: Color red shape: #square size: 0.7 ].
	
	^ CMPointOfView color: Color red size: 0.7
]

{ #category : 'behavior' }
BSWalkerAlone >> uTurn [

|dest|
dest:= self previousCell.
self walkerDestination: dest.
]
