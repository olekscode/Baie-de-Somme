Class {
	#name : 'BSWalkerGuide',
	#superclass : 'BSWalker',
	#instVars : [
		'observatoryMemory'
	],
	#category : 'Baie de Somme-Model',
	#package : 'Baie de Somme-Model'
}

{ #category : 'accessing' }
BSWalkerGuide class >> entityName [

	^ 'PromeneurGuide'
]

{ #category : 'behavior' }
BSWalkerGuide >> checkPosition [

	self patch = self walkerDestination ifFalse: [ ^ self ].
	(self way select: [ :x | x = self patch ]) ifNotEmpty: [ 
		self way remove: self patch.
		^ self changeActionToObservation ]
]

{ #category : 'as yet unclassified' }
BSWalkerGuide >> defineDestination [

self way ifEmpty: [ self walkerDestination: self home ]
 ifNotEmpty: [ self walkerDestination: self way first ].

self walkerPath: (self patch wayTo: (self walkerDestination) constraint: [ :cell | cell accessRule = 'Land' ]).

self walkerPath remove: self patch.
]

{ #category : 'initialization' }
BSWalkerGuide >> initialize [ 

| arg |

	super initialize.
	arg := Random new next.

	(arg < 0.33) 
		ifTrue: [ groupSize := (Random new next * 10 + 1) rounded ] 
		ifFalse: [(arg > 0.66) 
			ifTrue: [ groupSize := (Random new next * 10 + 21) rounded ]
			ifFalse: [groupSize := (Random new next * 10 + 11) rounded]].

	sealExpectation := 4.
	

]

{ #category : 'behavior' }
BSWalkerGuide >> lookForSpot [

| distanceToObservatory potentialDestination|

	((self walkerDestination sealRestingPlace = 'Observatory') & (observatoryMemory contains: [ :x | x = self walkerDestination])) ifTrue: [ ^ self ].

	potentialDestination := Dictionary new.
	distanceToObservatory := OrderedCollection new.

	self observatoryMemory isEmpty ifTrue: [ self energy: 0. ^ self walkerDestination: self home ].
	self observatoryMemory do: [ :cell | potentialDestination at: (self patch distanceTo: cell constraintOnPath: [ :x | x type = 'Land']) put: cell ].
	"distanceToObservatory isEmpty ifTrue: [ ^ self moveAlongBeach ]."
	potentialDestination keysDo: [ :x | distanceToObservatory add: x].
	distanceToObservatory := distanceToObservatory asSortedCollection: [ :x :y | x < y ].
	self walkerDestination: (potentialDestination at: (distanceToObservatory first)).
]

{ #category : 'behavior' }
BSWalkerGuide >> moveToASeal [

self moveTowards: (self walkerDestination) constraintOnPath: [:cell | (cell type = 'Land') or: [ cell type = 'Home' ] ].
	


]

{ #category : 'behavior' }
BSWalkerGuide >> moveToDestination [

(self walkerDestination sealRestingPlace = 'Observatory')
ifTrue: [ self moveTowards: walkerDestination constraintOnPath: [:cell | cell type = 'Land' or: [ cell type = 'Home' ] ] ]
ifFalse: [ self moveInDirectionOf: walkerDestination constraintOnPath: [:cell | cell type = 'Land' or: [ cell type = 'Home' ] ]].

energy := energy - 1.

]

{ #category : 'behavior' }
BSWalkerGuide >> moveWalking [

	| candidates |
	candidates := (self patch neighbourhood select: [ :cell | 
		               cell = self walkerPath first ]) first.

	self moveTo: candidates.
	self patch stomping: self patch stomping + self groupSize.
	self walkerPath remove: candidates
]

{ #category : 'accessing' }
BSWalkerGuide >> observatoryMemory [

	^ observatoryMemory
]

{ #category : 'accessing' }
BSWalkerGuide >> observatoryMemory: anObject [

	observatoryMemory := anObject
]

{ #category : 'pov' }
BSWalkerGuide >> pov [
 <pov>
	
	self walkerAction = 'Out' ifTrue: [ ^ CMPointOfView color: Color black size: 0.0001 ].
	self walkerAction = 'Walking' ifTrue: [ ^ CMPointOfView color: Color blue shape: #circle size: 0.7 ].
	self walkerAction = 'Observation' ifTrue: [ ^ CMPointOfView color: Color blue shape: #square size: 0.7 ].
	
	^ CMPointOfView color: Color blue size: 0.7
]

{ #category : 'behavior' }
BSWalkerGuide >> uTurn [

|dest|
dest:= self previousCell.
self previousCell: self patch;
moveTo: dest.
]
