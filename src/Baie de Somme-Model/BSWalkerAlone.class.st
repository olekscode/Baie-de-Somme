"BSWalkerAlone represents an independent walker in the Baie de Somme simulation.
This class specializes the BSWalker class to implement behaviors specific to individual visitors.
Independent walkers explore the bay on their own, following less structured paths than guided tours."

Class {
	#name : #BSWalkerAlone,
	#superclass : #BSWalker,
	#instVars : [
		'destinationMemory'	"Memory of previously visited destinations"
	],
	#category : #'Baie de Somme-Model'
}

"Returns the entity name used in the simulation interface"
{ #category : #accessing }
BSWalkerAlone class >> entityName [
	^ 'PromeneurSeul'
]

"Checks the current position and updates the walker's state accordingly.
If the walker has reached their destination, they will define a new one.
If they have returned home, they will end their walk."
{ #category : #behavior }
BSWalkerAlone >> checkPosition [
	self walkerPath ifNotEmpty: [ ^ self ].
	(self patch = self home) ifTrue: [ ^ self walkerAction: 'Out' ].
	self way remove: self patch.
	self defineDestination
]

"Defines the next destination for the independent walker.
The destination is chosen from available paths, with preference for beaches and seal resting places.
A valid path to reach the destination is calculated."
{ #category : #behavior }
BSWalkerAlone >> defineDestination [
	self way ifNotEmpty: [ 
		self walkerDestination: way first.
		self walkerPath: (self patch
				 wayTo: self walkerDestination
				 constraint: [ :cell | 
				 cell type = 'Beach' or: [ cell sealRestingPlace = 'Home' ] ]) ].
	self walkerPath remove: self patch
]

"Defines the visual range of the walker when using binoculars.
Extends the normal sight range by including cells in a wider radius."
{ #category : #behavior }
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

"Defines the visual range of the walker without binoculars.
Uses a smaller radius than the binocular-enhanced vision."
{ #category : #behavior }
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

"Returns the walker's memory of previously visited destinations"
{ #category : #accessing }
BSWalkerAlone >> destinationMemory [
	^ destinationMemory
]

"Sets the walker's memory of previously visited destinations"
{ #category : #accessing }
BSWalkerAlone >> destinationMemory: anObject [
	destinationMemory := anObject
]

"Initializes a new independent walker with specific characteristics:
- Randomly assigns a group size (small: 1-5, medium: 6-10, large: 11-15)
- Sets a moderate seal expectation level (3)
- Inherits basic walker initialization from superclass"
{ #category : #initialization }
BSWalkerAlone >> initialize [ 
	| arg |
	super initialize.
	arg := Cormas random.
	(arg < 0.5) 
		ifTrue: [ groupSize := (Cormas random * 5 + 1) rounded ] 
		ifFalse: [(arg > 0.9) 
			ifTrue: [ groupSize := (Cormas random * 5 + 11) rounded ]
			ifFalse: [groupSize := (Cormas random * 5 + 6) rounded]].
	sealExpectation := 3.
]

"Looks for a new spot to visit.
Uses destination memory if available, otherwise moves along the beach."
{ #category : #behavior }
BSWalkerAlone >> lookForSpot [
	self destinationMemory isNotEmpty
		ifTrue: [ ^ self walkerDestination: self destinationMemory atRandom ].
	self moveAlongBeach.
]

"Moves the walker along the beach, following the coastline.
Selects a new destination from available beach cells."
{ #category : #behavior }
BSWalkerAlone >> moveAlongBeach [
	|potentialDest|
	potentialDest := self patch neighbourhood select: [ :cell | cell ~= self previousCell ].
	potentialDest := potentialDest select: [ :cell | (cell type = 'Land') and: [ cell neighbourhood anySatisfy: [:y | y type = 'Sea'] ] ].
	potentialDest isEmpty ifTrue: [ ^ self uTurn ].
	self walkerDestination: potentialDest atRandom.
]

"Moves the walker towards a seal observation spot.
If near the sea, moves along the beach; otherwise moves towards the destination."
{ #category : #behavior }
BSWalkerAlone >> moveToASeal [
	(self patch neighbourhood select: [ :each | each type = 'Sea' ]) isEmpty
		ifFalse: [ ^ self moveAlongBeach ]
		ifTrue: [ ^ self previousCell: self patch; moveTowards: self walkerDestination ]
]

"Moves the walker towards their destination.
Only moves on land or home cells to protect the environment."
{ #category : #behavior }
BSWalkerAlone >> moveToDestination [
	self previousCell: self patch.
	self moveInDirectionOf: walkerDestination constraintOnPath: [ :cell | cell type = 'Land' or: [ cell type = 'Home' ] ]
]

"Moves the walker along their planned path.
Updates the path and tracks the group's impact on the environment (stomping)."
{ #category : #behavior }
BSWalkerAlone >> moveWalking [
	| candidates |
	(self walkerAction = 'Out') ifTrue: [ ^ self ].
	candidates := (self patch neighbourhood select: [ :cell | 
		cell = self walkerPath first ]) first.
	self moveTo: candidates.
	self patch stomping: self patch stomping + self groupSize.
	self walkerPath remove: candidates
]

"Returns the color used to represent the walker in the visualization (red)"
{ #category : #pov }
BSWalkerAlone >> pov [
	^ Color red  
]

"Returns the visualization settings for the walker's energy level"
{ #category : #pov }
BSWalkerAlone >> povEnergy [	
	^ self
		povAttribute: #energy
		min: 0
		max: 180
		color: Color red 
]

"Returns the visualization settings for the walker's satisfaction level"
{ #category : #pov }
BSWalkerAlone >> povSatisfaction [	
	^ self
		povAttribute: #satisfaction
		min: 0
		max: 180
		color: Color red 
]

"Makes the walker turn around and go back the way they came"
{ #category : #behavior }
BSWalkerAlone >> uTurn [
	|dest|
	dest:= self previousCell.
	self walkerDestination: dest.
]
