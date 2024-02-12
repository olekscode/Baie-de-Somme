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
]

{ #category : #behavior }
BSWalker >> lookAtSealsNotAware [

| numberOfWalkers|
numberOfWalkers := 0.
	
self patch allOccupants do: [ :walker | numberOfWalkers := numberOfWalkers + walker groupSize ].
	
(numberOfWalkers < (self groupSize + 1)) 
	ifTrue: [ satisfaction := satisfaction + 2 ]
	ifFalse: [ satisfaction := satisfaction + 1 ].
self moveToASeal.
]

{ #category : #behavior }
BSWalker >> lookForSeals [

siteWithSeal := self sight select: [ :cell | (cell hasOccupantsOfClass: BSSeal) & (cell type = 'Land') ].
	
]

{ #category : #behavior }
BSWalker >> moveToASeal [

	
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

{ #category : #behavior }
BSWalker >> setDestination [

(self siteWithSeal isNotEmpty)
	ifTrue: [ self setDestinationToSeal ]
	ifFalse: [ self setDestinationToOther ]
	
]

{ #category : #behavior }
BSWalker >> setDestinationToOther [


]

{ #category : #behavior }
BSWalker >> setDestinationToSeal [

| potentialDestination distanceToSeal|
distanceToSeal := 0.

potentialDestination := siteWithSeal select: [ :site | (self patch wayTo: site constraint: [ :cell | cell type = 'Land' ]) isNotEmpty ].

(potentialDestination isNotEmpty) ifTrue: [ ^ self walkerDestination: potentialDestination atRandom ].

self siteWithSeal do: [ :cell | potentialDestination addAll: (self patch wayTo: cell)].
self siteWithSeal do: [ :cell | potentialDestination remove: cell ].
potentialDestination := potentialDestination removeDuplicates.
"potentialDestination := potentialDestination remove: [ :x | x = self patch ]."
potentialDestination := potentialDestination select: [ :cell | cell type = 'Land' ].
(potentialDestination isEmpty) ifTrue: [ ^ self walkerDestination: self patch ].
potentialDestination do: [ :dest |  ((self patch distanceTo: dest) >= distanceToSeal) ifTrue: [ self walkerDestination: dest. distanceToSeal := self patch distanceTo: dest ]].
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

	self defineVision.
	
	(energy = 0) ifTrue: [ ^ self goBackHome ].
	
	self setDestination.
	
	(self siteWithSeal isEmpty) ifTrue: [ ^ self moveToASeal ].
	
	self lookAtSeals.
	
	energy := energy - 1.
	


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
