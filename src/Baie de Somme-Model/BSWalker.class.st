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
		'walkerDestination'
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
	
	self moveTowards: home "constraintOnPath: [ :cell | cell type ~= 'Land' ]".
	
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

|distance1 distance2 numberOfWalkers|
distance1 := SortedCollection new.
numberOfWalkers := 0.

self siteWithSeal do: [ :cell | distance1 add: (cell distanceTo: self patch) ].
	distance2 := distance1 first.
	
	
	(distance2 > sealExpectation) ifTrue: [ ^ self moveTowards: siteWithSeal ].
	
	(self patch allOccupants do: [ :walker | numberOfWalkers := numberOfWalkers + walker groupSize ]).
	
	(numberOfWalkers < (self groupSize + 1)) ifTrue: [ satisfaction := satisfaction + 2 ].
]

{ #category : #behavior }
BSWalker >> lookForSeals [

siteWithSeal := self sight select: [ :cell | cell hasOccupantsOfClass: BSSeal ].
	
	
	
]

{ #category : #behavior }
BSWalker >> moveToASeal [

	self randomWalkConstrainedBy: [ :cell | cell type = 'Land' ].
]

{ #category : #pov }
BSWalker >> pov [

	self subclassResponsibility
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
BSWalker >> sealExpectation [

	^ sealExpectation
]

{ #category : #accessing }
BSWalker >> sealExpectation: anObject [

	sealExpectation := anObject
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
	self lookForSeals.
	(self siteWithSeal size > 0) 
		ifTrue: [ self lookAtSeals ]
		ifFalse: [ self moveToASeal ].
		
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
