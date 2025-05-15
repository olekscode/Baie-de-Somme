"BSWalkerGuide represents a guided tour leader in the Baie de Somme simulation.
This class specializes the BSWalker class to implement behaviors specific to guided tours.
Guided walkers lead groups of visitors along predefined paths and have specific knowledge about seal observation spots."

Class {
	#name : #BSWalkerGuide,
	#superclass : #BSWalker,
	#instVars : [
		'observatoryMemory'	"Memory of good observation spots for seals"
	],
	#category : #'Baie de Somme-Model'
}

"Returns the entity name used in the simulation interface"
{ #category : #accessing }
BSWalkerGuide class >> entityName [
	^ 'PromeneurGuide'
]

"Checks the current position and updates the walker's state accordingly.
If the walker has reached their destination, they will start observing.
If they are on their path, they will remove the current position from their remaining path."
{ #category : #behavior }
BSWalkerGuide >> checkPosition [
	self patch = self walkerDestination ifFalse: [ ^ self ].
	(self way select: [ :x | x = self patch ]) ifNotEmpty: [ 
		self way remove: self patch.
		^ self changeActionToObservation ]
]

"Defines the next destination for the guided walker.
The destination is set to the first point in their predefined path,
and a valid path to reach it is calculated."
{ #category : #'as yet unclassified' }
BSWalkerGuide >> defineDestination [
	self walkerDestination: self way first.
	self walkerPath: (self patch wayTo: (self walkerDestination) constraint: [ :cell | cell accessRule = 'Land' ]).
	self walkerPath remove: self patch.
]

"Initializes a new guided walker with specific characteristics:
- Randomly assigns a group size (small: 1-10, medium: 11-20, large: 21-30)
- Sets a high seal expectation level (4)
- Inherits basic walker initialization from superclass"
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

"Looks for a good observation spot for seals.
Uses the observatory memory to find known good spots, or returns home if no memory exists."
{ #category : #behavior }
BSWalkerGuide >> lookForSpot [
	| distanceToObservatory potentialDestination|
	((self walkerDestination sealRestingPlace = 'Observatory') & (observatoryMemory contains: [ :x | x = self walkerDestination])) ifTrue: [ ^ self ].
	potentialDestination := Dictionary new.
	distanceToObservatory := OrderedCollection new.
	self observatoryMemory isEmpty ifTrue: [ self energy: 0. ^ self walkerDestination: self home ].
	self observatoryMemory do: [ :cell | potentialDestination at: (self patch distanceTo: cell constraintOnPath: [ :x | x type = 'Land']) put: cell ].
	potentialDestination keysDo: [ :x | distanceToObservatory add: x].
	distanceToObservatory := distanceToObservatory asSortedCollection: [ :x :y | x < y ].
	self walkerDestination: (potentialDestination at: (distanceToObservatory first)).
]

"Moves the walker along the beach, following the coastline.
If the beach ends, the walker will make a U-turn."
{ #category : #behavior }
BSWalkerGuide >> moveAlongBeach [
	|dest potentialDest|
	(self patch neighbourhood size < 8) ifTrue: [ ^ self uTurn ].
	potentialDest := self patch neighbourhood select: [ :cell | cell neighbourhoodAndSelf allSatisfy: [ :y | y ~= self previousCell ]].
	dest := potentialDest select: [ :cell | (cell type = 'Land') & (cell neighbourhood anySatisfy: [:y | y type = 'Sea']) ].
	(dest isEmpty) ifTrue: [ (Cormas random < 0.5) ifTrue: [dest:= self patch neighbourE]  ifFalse: [dest:= self patch neighbourW]] ifFalse: [ dest := dest first ].
	self previousCell: self patch.
	self moveTo: dest.
]

"Moves the walker towards a seal observation spot.
Only moves on land or home cells to protect the environment."
{ #category : #behavior }
BSWalkerGuide >> moveToASeal [
	self moveTowards: (self walkerDestination) constraintOnPath: [:cell | (cell type = 'Land') or: [ cell type = 'Home' ] ].
]

"Moves the walker towards their destination.
Uses different movement strategies based on whether the destination is an observatory or not.
Decreases energy with each move."
{ #category : #behavior }
BSWalkerGuide >> moveToDestination [
	(self walkerDestination sealRestingPlace = 'Observatory')
		ifTrue: [ self moveTowards: walkerDestination constraintOnPath: [:cell | cell type = 'Land' or: [ cell type = 'Home' ] ] ]
		ifFalse: [ self moveInDirectionOf: walkerDestination constraintOnPath: [:cell | cell type = 'Land' or: [ cell type = 'Home' ] ]].
	energy := energy - 1.
]

"Moves the walker along their planned path.
Updates the path and tracks the group's impact on the environment (stomping)."
{ #category : #behavior }
BSWalkerGuide >> moveWalking [
	| candidates |
	candidates := (self patch neighbourhood select: [ :cell | 
		cell = self walkerPath first ]) first.
	self moveTo: candidates.
	self patch stomping: self patch stomping + self groupSize.
	self walkerPath remove: candidates
]

"Returns the walker's memory of good observation spots"
{ #category : #accessing }
BSWalkerGuide >> observatoryMemory [
	^ observatoryMemory
]

"Sets the walker's memory of good observation spots"
{ #category : #accessing }
BSWalkerGuide >> observatoryMemory: anObject [
	observatoryMemory := anObject
]

"Returns the color used to represent the walker in the visualization (blue)"
{ #category : #pov }
BSWalkerGuide >> pov [
	^ Color blue
]

"Returns the visualization settings for the walker's energy level"
{ #category : #pov }
BSWalkerGuide >> povEnergy [
	^ self
		povAttribute: #energy
		min: 0
		max: 180
		color: Color blue 
]

"Returns the visualization settings for the walker's satisfaction level"
{ #category : #pov }
BSWalkerGuide >> povSatisfaction [	
	^ self
		povAttribute: #satisfaction
		min: 0
		max: 180
		color: Color blue 
]

"Makes the walker turn around and go back the way they came"
{ #category : #behavior }
BSWalkerGuide >> uTurn [
	|dest|
	dest:= self previousCell.
	self previousCell: self patch;
	moveTo: dest.
]
