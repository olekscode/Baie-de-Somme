Class {
	#name : #BSWalker,
	#superclass : #CMAgent,
	#traits : 'TCMLocated',
	#classTraits : 'TCMLocated classTrait',
	#instVars : [
		'home',
		'satisfaction',
		'energy',
		'sight',
		'sealExpectation',
		'groupSize',
		'siteWithSeal',
		'walkerDestination',
		'previousCell',
		'sealAwareness',
		'withDog',
		'withBinoculars'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #behavior }
BSWalker >> checkPosition [

	self subclassResponsibility
]

{ #category : #behavior }
BSWalker >> defineVision [

	self subclassResponsibility
]

{ #category : #accessing }
BSWalker >> energy [

	^ energy
]

{ #category : #accessing }
BSWalker >> energy: anObject [

	energy := anObject
]

{ #category : #behavior }
BSWalker >> goBackHome [
	
	self moveTowards: home constraintOnPath: [ :cell | (cell type = 'Land') or: [cell type = 'Home']].
	
]

{ #category : #accessing }
BSWalker >> groupSize [

	^ groupSize
]

{ #category : #accessing }
BSWalker >> groupSize: anObject [

	groupSize := anObject
]

{ #category : #accessing }
BSWalker >> home [

	^ home
]

{ #category : #accessing }
BSWalker >> home: anObject [

	home := anObject
]

{ #category : #initialization }
BSWalker >> initialize [ 

	super initialize.
	satisfaction := 0.
	energy := (Cormas random * 100) rounded.
	siteWithSeal := OrderedCollection new. 
]

{ #category : #printing }
BSWalker >> interestingDetails [
	"Answer a Collection>of interesting receiver's attributes, from a modeler point of view, to display in a popup for example "

	^ super interestingDetails , { 
		'Energy: ' -> (self energy asString)
		}
]

{ #category : #behavior }
BSWalker >> lookAtSeals [

(self sealAwareness = 'yes')
	ifTrue: [ ^ self lookAtSealsAware ]
	ifFalse: [ ^ self lookAtSealsNotAware ]
]

{ #category : #behavior }
BSWalker >> lookAtSealsAware [

| numberOfWalkers|
numberOfWalkers := 0.
	
self patch allOccupants do: [ :walker | numberOfWalkers := numberOfWalkers + walker groupSize ].
	
(numberOfWalkers < (self groupSize + 1)) 
	ifTrue: [ satisfaction := satisfaction + 2 ]
	ifFalse: [ satisfaction := satisfaction + 1 ].
	self walkerDestination: self patch.
]

{ #category : #behavior }
BSWalker >> lookAtSealsNotAware [

| numberOfWalkers|
numberOfWalkers := 0.
	
self patch allOccupants do: [ :walker | numberOfWalkers := numberOfWalkers + walker groupSize ].
	
(numberOfWalkers < (self groupSize + 1)) 
	ifTrue: [ satisfaction := satisfaction + 1 ]
	"ifFalse: [ satisfaction := satisfaction + 1 ]".
self setDestinationToSeal.
]

{ #category : #behavior }
BSWalker >> lookForSeals [

self siteWithSeal: (self sight select: [ :cell | (cell hasOccupantsOfClass: BSSeal) & (cell type = 'Land') ]).
	
]

{ #category : #behavior }
BSWalker >> lookForSpot [

	self subclassResponsibility

]

{ #category : #moving }
BSWalker >> moveInDirectionOf: aCell constraintOnPath: aBlock [
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
BSWalker >> moveToASeal [

	
]

{ #category : #behavior }
BSWalker >> moveToDestination [
]

{ #category : #pov }
BSWalker >> pov [

	self subclassResponsibility
]

{ #category : #accessing }
BSWalker >> previousCell [

	^ previousCell
]

{ #category : #accessing }
BSWalker >> previousCell: anObject [

	previousCell := anObject
]

{ #category : #accessing }
BSWalker >> satisfaction [

	^ satisfaction
]

{ #category : #accessing }
BSWalker >> satisfaction: anObject [

	satisfaction := anObject
]

{ #category : #accessing }
BSWalker >> sealAwareness [

	^ sealAwareness
]

{ #category : #accessing }
BSWalker >> sealAwareness: anObject [

	sealAwareness := anObject
]

{ #category : #accessing }
BSWalker >> sealExpectation [

	^ sealExpectation
]

{ #category : #accessing }
BSWalker >> sealExpectation: anObject [

	sealExpectation := anObject
]

{ #category : #'as yet unclassified' }
BSWalker >> selectFarthestLandOnWayToSeaFrom: position to: potentialDestination [

| distanceToSpot temporaryDestination finalDestination|
temporaryDestination:= OrderedCollection new.
distanceToSpot := 0.

temporaryDestination := potentialDestination select: [ :site | (position wayTo: site constraint: [ :cell | cell type = 'Land' ]) isNotEmpty].
(temporaryDestination isNotEmpty) ifTrue: [ finalDestination := potentialDestination atRandom. ^finalDestination ].

potentialDestination do: [ :cell | temporaryDestination addAll: (position wayTo: cell)].
temporaryDestination := temporaryDestination select: [ :site | (position wayTo: site constraint: [ :cell | cell type = 'Land' ]) isNotEmpty ].
temporaryDestination := temporaryDestination removeDuplicates.
temporaryDestination := temporaryDestination select: [ :cell | cell type = 'Land' ].
"(temporaryDestination isEmpty) ifTrue: [ self walkerDestination: self patch ]."
temporaryDestination do: [ :dest |  ((position distanceTo: dest) >= distanceToSpot) ifTrue: [ finalDestination := dest. distanceToSpot := position distanceTo: dest ]].
^finalDestination 
]

{ #category : #behavior }
BSWalker >> setDestinationToSeal [

self walkerDestination: self siteWithSeal atRandom.
]

{ #category : #accessing }
BSWalker >> sight [

	^ sight
]

{ #category : #accessing }
BSWalker >> sight: anObject [

	sight := anObject
]

{ #category : #accessing }
BSWalker >> siteWithSeal [

	^ siteWithSeal
]

{ #category : #accessing }
BSWalker >> siteWithSeal: anObject [

	^ siteWithSeal := anObject
]

{ #category : #stepping }
BSWalker >> step [

	self checkPosition.
	(energy = 0) ifTrue: [ ^ self goBackHome ].
	(self siteWithSeal isNotEmpty) 
	ifTrue: [ self lookAtSeals ]
	ifFalse: [ self lookForSpot ].
	self moveToDestination.
	self defineVision.
	self lookForSeals.
	


]

{ #category : #accessing }
BSWalker >> walkerDestination [

	^ walkerDestination
]

{ #category : #accessing }
BSWalker >> walkerDestination: anObject [

	walkerDestination := anObject
]

{ #category : #accessing }
BSWalker >> withBinoculars [

	^ withBinoculars
]

{ #category : #accessing }
BSWalker >> withBinoculars: anObject [

	withBinoculars := anObject
]

{ #category : #accessing }
BSWalker >> withDog [

	^ withDog
]

{ #category : #accessing }
BSWalker >> withDog: anObject [

	withDog := anObject
]
