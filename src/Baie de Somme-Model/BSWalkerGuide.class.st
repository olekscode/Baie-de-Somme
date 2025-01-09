Class {
	#name : #BSWalkerGuide,
	#superclass : #BSWalker,
	#instVars : [
		'observatoryMemory'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSWalkerGuide class >> entityName [

	^ 'PromeneurGuide'
]

{ #category : #behavior }
BSWalkerGuide >> checkPosition [

	self patch = self walkerDestination ifFalse: [ ^ self ].
	(self way select: [ :x | x = self patch ]) ifNotEmpty: [ 
		self way remove: self patch.
		^ self changeActionToObservation ]
]

{ #category : #'as yet unclassified' }
BSWalkerGuide >> defineDestination [

self walkerDestination: self way first.

self walkerPath: (self patch wayTo: (self walkerDestination) constraint: [ :cell | cell accessRule = 'Land' ]).

self walkerPath remove: self patch.
]

{ #category : #initialization }
BSWalkerGuide >> initialize [ 

| arg |

	super initialize.
	arg := Cormas random.

	(arg < 0.33) 
		ifTrue: [ groupSize := (Cormas random * 10 + 1) rounded ] 
		ifFalse: [(arg > 0.66) 
			ifTrue: [ groupSize := (Cormas random * 10 + 21) rounded ]
			ifFalse: [groupSize := (Cormas random * 10 + 11) rounded]].

	sealExpectation := 4.
	

]

{ #category : #behavior }
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

{ #category : #behavior }
BSWalkerGuide >> moveAlongBeach [
	
	|dest potentialDest|
(self patch neighbourhood size < 8) ifTrue: [ ^ self uTurn ].

potentialDest := self patch neighbourhood select: [ :cell | cell neighbourhoodAndSelf allSatisfy: [ :y | y ~= self previousCell ]].

dest := potentialDest select: [ :cell | (cell type = 'Land') & (cell neighbourhood anySatisfy: [:y | y type = 'Sea'])].
(dest isEmpty) ifTrue: [ (Cormas random < 0.5) ifTrue: [dest:= self patch neighbourE]  ifFalse: [dest:= self patch neighbourW]] ifFalse: [ dest := dest first ].
self previousCell: self patch.
self moveTo: dest.
]

{ #category : #behavior }
BSWalkerGuide >> moveToASeal [

self moveTowards: (self walkerDestination) constraintOnPath: [:cell | (cell type = 'Land') or: [ cell type = 'Home' ] ].
	


]

{ #category : #behavior }
BSWalkerGuide >> moveToDestination [

(self walkerDestination sealRestingPlace = 'Observatory')
ifTrue: [ self moveTowards: walkerDestination constraintOnPath: [:cell | cell type = 'Land' or: [ cell type = 'Home' ] ] ]
ifFalse: [ self moveInDirectionOf: walkerDestination constraintOnPath: [:cell | cell type = 'Land' or: [ cell type = 'Home' ] ]].

energy := energy - 1.

]

{ #category : #behavior }
BSWalkerGuide >> moveWalking [

	| candidates |
	candidates := (self patch neighbourhood select: [ :cell | 
		               cell = self walkerPath first ]) first.

	self moveTo: candidates.
	self patch stomping: self patch stomping + self groupSize.
	self walkerPath remove: candidates
]

{ #category : #accessing }
BSWalkerGuide >> observatoryMemory [

	^ observatoryMemory
]

{ #category : #accessing }
BSWalkerGuide >> observatoryMemory: anObject [

	observatoryMemory := anObject
]

{ #category : #pov }
BSWalkerGuide >> pov [

	^ Color blue
]

{ #category : #pov }
BSWalkerGuide >> povEnergy [

	^ self
		  povAttribute: #energy
		  min: 0
		  max: 180
		  color: Color blue 
]

{ #category : #pov }
BSWalkerGuide >> povSatisfaction [	

	^ self
		  povAttribute: #satisfaction
		  min: 0
		  max: 180
		  color: Color blue 
]

{ #category : #behavior }
BSWalkerGuide >> uTurn [

|dest|
dest:= self previousCell.
self previousCell: self patch;
moveTo: dest.
]
