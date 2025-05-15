"BSBoat represents a boat (typically a kayak) in the Baie de Somme simulation.
This class implements the behavior of boats navigating through the bay, including:
- Navigation between destinations
- Seal observation and awareness
- Energy and satisfaction management
- Memory of visited locations and routes"

Class {
	#name : #BSBoat,
	#superclass : #CMAgent,
	#traits : 'TCMLocated',
	#classTraits : 'TCMLocated classTrait',
	#instVars : [
		'home',			"Home location of the boat"
		'satisfaction',		"Current satisfaction level (increases when seeing seals)"
		'energy',		"Current energy level (decreases with movement)"
		'siteWithSeal',		"Collection of cells where seals are currently visible"
		'sight',		"Visual range of the boat"
		'boatDestination',	"Current destination the boat is moving towards"
		'boatDirection',	"Current direction of movement"
		'boatAction',		"Current action being performed (e.g., 'Navigate')"
		'actionCount',		"Counter for current action"
		'sealAwareness',	"Level of awareness/interest in seals (0-2)"
		'wayMemory',		"Memory of navigation paths"
		'restingPlaceMemory',	"Memory of seal resting places"
		'way'			"Current navigation path"
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSBoat >> actionCount [
	"Return the counter for the current action"
	^ actionCount
]

{ #category : #accessing }
BSBoat >> actionCount: anObject [

	actionCount := anObject
]

{ #category : #accessing }
BSBoat >> boatAction [
	"Return the current action being performed by the boat"
	^ boatAction
]

{ #category : #accessing }
BSBoat >> boatAction: anObject [

	boatAction := anObject
]

{ #category : #accessing }
BSBoat >> boatDestination [
	"Return the current destination the boat is moving towards"
	^ boatDestination
]

{ #category : #accessing }
BSBoat >> boatDestination: anObject [

	boatDestination := anObject
]

{ #category : #accessing }
BSBoat >> boatDirection [
	"Return the current direction of movement"
	^ boatDirection
]

{ #category : #accessing }
BSBoat >> boatDirection: anObject [

	boatDirection := anObject
]

{ #category : #behavior }
BSBoat >> defineVision [
	"Define the visual range of the boat by expanding the neighborhood in two steps:
	1. Get immediate neighborhood and self
	2. Expand to include neighbors of neighbors
	3. Remove duplicates
	4. Store the final collection in sight"
	|scope1 scope2|
	scope1 := OrderedCollection new.
	scope2 := OrderedCollection new.
	scope1 := patch neighbourhoodAndSelf.
	scope2 := scope1 asOrderedCollection.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope1 := scope2.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	self sight: scope2.
]

{ #category : #accessing }
BSBoat >> energy [
	"Return the current energy level of the boat"
	^ energy
]

{ #category : #accessing }
BSBoat >> energy: anObject [

	energy := anObject
]

{ #category : #accessing }
BSBoat >> home [
	"Return the home location of the boat"
	^ home
]

{ #category : #accessing }
BSBoat >> home: anObject [
	"Set the home location of the boat to aLocation"
	home := anObject
]

{ #category : #initialization }
BSBoat >> initialize [ 
	"Initialize a new boat with default values:
	- Satisfaction starts at 0
	- Energy is randomly set between 0-100
	- Empty collection for visible seals
	- Initial action set to 'Navigate'
	- Action count starts at 0
	- Seal awareness is randomly set:
	  * 20% chance of no awareness (0)
	  * 60% chance of moderate awareness (1)
	  * 20% chance of high awareness (2)"
	|arg|
	super initialize.
	satisfaction := 0.
	energy := (Cormas random * 100) rounded.
	siteWithSeal := OrderedCollection new.
	self boatAction: 'Navigate'.
	actionCount := 0.
	
	arg:= Cormas random.
	(arg < 0.2) 
		ifTrue: [ self sealAwareness: 0] 
		ifFalse: [ 
			(arg > 0.8) 
				ifTrue: [self sealAwareness: 2]
				ifFalse: [ self sealAwareness: 1 ]].
]

{ #category : #behavior }
BSBoat >> lookForSeals [
	"Search for seals in the boat's visual range and update satisfaction:
	1. Find all cells with seals that are on beaches
	2. If seals are found, increase satisfaction by 1
	3. If seals are in the current cell, increase satisfaction by 1"
	self siteWithSeal: (self sight select: [ :cell | ((cell hasOccupantsOfClass: BSSeal) & (cell type = 'Beach'))]).

	(self siteWithSeal isNotEmpty) ifTrue: [ satisfaction := satisfaction +1 ].
	(self patch hasOccupantsOfClass: BSSeal) ifTrue: [ satisfaction := satisfaction + 1 ].
]

{ #category : #moving }
BSBoat >> moveInDirectionOf: aCell constraintOnPath: aBlock [
	"Move the boat one cell closer to the destination while respecting path constraints.
	Arguments:
	- aCell: The target destination cell
	- aBlock: A condition that must be true for each cell in the path
	The boat will move to a random valid cell within a distance of 3 from the current position"
	| path candidate dist|
	dist:=3.
	
	self isSituated ifTrue: [
		self patch = aCell ifFalse: [
			path := self patch wayTo: aCell.
			
			path do: [ :cell | (self patch distanceTo: cell) < dist ifTrue: 
				[ candidate := cell asOrderedCollection. dist := self patch distanceTo: cell ] ].
			
			candidate:= candidate select: [ :c | aBlock value: c ].
			candidate isNotEmpty ifTrue: [ self moveTo: candidate atRandom ]] ]
]

{ #category : #behavior }
BSBoat >> moveToDestination [ 
	"Move the boat towards its current destination, following valid kayak paths"
	self moveInDirectionOf: boatDestination constraintOnPath: [ :cell | cell kayakWay = 'Way']
]

{ #category : #pov }
BSBoat >> pov [
	"Return the point of view of the boat. This method is meant to be implemented by subclasses"
	self subclassResponsibility
]

{ #category : #accessing }
BSBoat >> restingPlaceMemory [
	"Return the memory of seal resting places"
	^ restingPlaceMemory
]

{ #category : #accessing }
BSBoat >> restingPlaceMemory: anObject [

	restingPlaceMemory := anObject
]

{ #category : #accessing }
BSBoat >> satisfaction [
	"Return the current satisfaction level of the boat"
	^ satisfaction
]

{ #category : #accessing }
BSBoat >> satisfaction: anObject [
	"Set the satisfaction level of the boat to aNumber"
	satisfaction := anObject
]

{ #category : #accessing }
BSBoat >> sealAwareness [
	"Return the level of awareness/interest in seals (0-2)"
	^ sealAwareness
]

{ #category : #accessing }
BSBoat >> sealAwareness: anObject [
	"Set the seal awareness level to aNumber (0-2)"
	sealAwareness := anObject
]

{ #category : #accessing }
BSBoat >> sight [
	"Return the visual range of the boat"
	^ sight
]

{ #category : #accessing }
BSBoat >> sight: anObject [
	"Set the visual range of the boat to aNumber"
	sight := anObject
]

{ #category : #accessing }
BSBoat >> siteWithSeal [
	"Return the collection of cells where seals are currently visible"
	^ siteWithSeal
]

{ #category : #accessing }
BSBoat >> siteWithSeal: anObject [
	"Set the collection of cells where seals are visible to aCollection"
	siteWithSeal := anObject
]

{ #category : #stepping }
BSBoat >> step [
	"Execute one step of the boat's behavior. This method is meant to be implemented by subclasses"
	self subclassResponsibility
]

{ #category : #accessing }
BSBoat >> way [
	"Return the current navigation path"
	^ way
]

{ #category : #accessing }
BSBoat >> way: anObject [
	"Set the current navigation path to aPath"
	way := anObject
]

{ #category : #accessing }
BSBoat >> wayMemory [
	"Return the memory of navigation paths"
	^ wayMemory
]

{ #category : #accessing }
BSBoat >> wayMemory: anObject [

	wayMemory := anObject
]
