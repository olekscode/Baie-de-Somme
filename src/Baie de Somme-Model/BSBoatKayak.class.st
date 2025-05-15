"BSBoatKayak represents a kayak in the Baie de Somme simulation.
This class specializes the BSBoat class to implement behaviors specific to kayaks, including:
- Navigation along predefined kayak paths
- Seal observation from water
- Energy management during paddling
- Memory of seal resting places and navigation routes"

Class {
	#name : #BSBoatKayak,
	#superclass : #BSBoat,
	#category : #'Baie de Somme-Model'
}

{ #category : #'as yet unclassified' }
BSBoatKayak >> changeActionToNavigate [
	"Change the boat's action to navigation mode:
	- Set action to 'Navigate'
	- Store current direction in memory
	- Set action count to 10 steps"
	self boatAction: 'Navigate'.
	self boatDirection: self wayMemory.
	self actionCount: 10.
]

{ #category : #'as yet unclassified' }
BSBoatKayak >> changeActionToObservation [
	"Change the boat's action to observation mode when seals are spotted:
	- Set action to 'Observation'
	- Store current position in memory
	- Set random observation duration (10-20 steps)
	- Select a random seal location as observation target
	- Remove the target location from resting place memory
	- If seal awareness is high (>1) and random chance > 0.66, move to repository
	- Otherwise, start observation behavior"
	| rand |
	self boatAction: 'Observation'.
	self wayMemory: self patch.
	self actionCount: (Cormas random * 10 + 10) rounded.
	self boatDirection: (self siteWithSeal atRandom).
	self restingPlaceMemory: (self restingPlaceMemory reject: [ :restingPlace | restingPlace = boatDirection sealRestingPlace  ]).

	rand:= Cormas random.
	((self sealAwareness > 1) & (rand > 0.66))
		ifTrue: [ ^ self changeActionToRepository ].
		
	self stepObservation.
]

{ #category : #'as yet unclassified' }
BSBoatKayak >> changeActionToOnLand [
	"Change the boat's action to on-land mode:
	- Set direction to current position
	- Set action to 'On Land'
	- Start on-land behavior"
	self boatDirection: self patch.
	self boatAction: 'On Land'.
	self stepOnLandBoat.
]

{ #category : #'as yet unclassified' }
BSBoatKayak >> changeActionToRepository [
	"Change the boat's action to repository mode:
	- Set action to 'Repository'
	- If action count is 0, set random duration (5-15 steps)
	- Decrease seal awareness
	- Start repository behavior"
	self boatAction: 'Repository'.
	(self actionCount = 0) ifTrue: [ self actionCount: (Cormas random * 10 + 5) rounded ].
	sealAwareness := sealAwareness - 1.
	self stepRepository.
]

{ #category : #behavior }
BSBoatKayak >> kayakMoveAroundRepository [
	"Define the kayak's movement behavior around a seal repository:
	- Decrease action count if > 0
	- If not near the beach, move towards target
	- Otherwise, move to a random valid cell near the beach"
	| candidate |
	(actionCount > 0) ifTrue: [ actionCount := actionCount - 1 ].
	(self patch neighbourhood allSatisfy: [ :cell | cell sealRestingPlace ~= self boatDirection sealRestingPlace ]) ifTrue: [ ^ self moveTowards: boatDirection ].
	candidate := self patch neighbourhood select: [ :cell | (cell type = 'Sea') and: [ cell neighbourhood anySatisfy: [ :x | x sealRestingPlace = self boatDirection sealRestingPlace ] ] ].
	(candidate isNotEmpty)
		ifTrue: [ self moveTo: candidate atRandom ].
]

{ #category : #behavior }
BSBoatKayak >> kayakMoveInWater [
	"Define the kayak's movement behavior in water:
	- If on beach, move to adjacent sea cell
	- If not on path, return to path
	- If reached destination, set next destination
	- Move towards destination following kayak paths"
	self patch type = 'Beach' ifTrue: [ 
		^ self moveTo:
			  (self patch neighbourhoodAndSelf detect: [ :x | x type = 'Sea' ]) ].
	self patch kayakWay ~= 'Way' ifTrue: [ 
		^ self
			  moveTowards: boatDirection
			  constraintOnPath: [ :cell | cell type = 'Sea' ] ].
	(self patch = self boatDestination) ifTrue: [ 
		self boatDestination: self way first.
		self way remove: self boatDestination ].
	self
		moveTowards: self boatDestination
		constraintOnPath: [ :cell | cell kayakWay = 'Way' ]
]

{ #category : #behavior }
BSBoatKayak >> kayakMoveOnLand [
	"Define the kayak's movement behavior on land:
	- Decrease action count
	- If seals visible, move towards them
	- Otherwise, wander along beach near water"
	| candidates|
	actionCount := actionCount - 1.
	candidates := siteWithSeal select: [ :cell | (self patch wayTo: cell constraint: [ :x | x type = 'Beach' ]) isNotEmpty ].
	(candidates isNotEmpty)
		ifTrue: [ ^ self moveTowards: (candidates atRandom) constraintOnPath: [ :x | x type = 'Beach' ] ].
	candidates:= self patch neighbourhood select: [ :cell | (cell type = 'Beach') & (cell neighbourhood anySatisfy: [:x|x type = 'Sea']) ].
	self moveTo: candidates atRandom.
]

{ #category : #behavior }
BSBoatKayak >> kayakMoveToBeach [
	"Move the kayak towards the beach:
	- Move in direction of target
	- Decrease action count if > 0"
	self moveTowards: boatDirection.
	(self actionCount > 0) ifTrue: [ actionCount := actionCount - 1 ].
]

{ #category : #'as yet unclassified' }
BSBoatKayak >> kayakPrepareToLeave [
	"Prepare to leave the beach:
	- If at target and action count is 0, change to navigation
	- Otherwise, move towards target
	- Decrease action count if > 0"
	((self patch = boatDirection) and: [ self actionCount = 0 ])
	ifTrue: [ ^ self changeActionToNavigate ]
	ifFalse: [ self moveTowards: boatDirection constraintOnPath: [ :cell | cell type = 'Beach' ] ].
	(self actionCount > 0) ifTrue: [ actionCount := actionCount  - 1 ].
]

{ #category : #'as yet unclassified' }
BSBoatKayak >> kayakUpdateMemory [
	"Update the kayak's memory of navigation paths:
	- Remove current target location from memory"
	| tempMemory |
	self boatDirection ifNil: [ ^ self].
	tempMemory := self wayMemory select: [ :cell | cell sealRestingPlace ~= self boatDirection ].
	self wayMemory: tempMemory.
]

{ #category : #behavior }
BSBoatKayak >> lookAtSealsFromSea [ 
	"Observe seals from the sea while maintaining safe distance:
	- Select cells that maintain distance > 1 from seals
	- Move to random valid sea cell
	- Decrease action count if > 0"
	| candidatePatch |
	candidatePatch := OrderedCollection new.
	(self siteWithSeal) 
	ifNotEmpty: [ self siteWithSeal  do: [ :cell | self patch neighbourhoodAndSelf do: [ :cell2 | ((cell distanceTo: cell2) > 1) ifTrue: [ candidatePatch add: cell2 ] ] ]]
	ifEmpty: [ self patch neighbourhoodAndSelf do: [ :cell | ((cell distanceTo: self boatDirection) > 1) ifTrue: [ candidatePatch add: cell ] ]].
	candidatePatch := (candidatePatch select: [ :cell | cell type = 'Sea' ]).
	self moveTo: candidatePatch atRandom.
	(actionCount > 0) ifTrue: [ actionCount := actionCount - 1 ].
]

{ #category : #pov }
BSBoatKayak >> pov [
	"Return the color representation of the kayak:
	- Blue if action is 'Out'
	- Pink otherwise"
	self boatAction = 'Out' ifTrue: [ ^ Color blue ].
	^ Color pink
]

{ #category : #stepping }
BSBoatKayak >> step [
	"Execute one step of the kayak's behavior:
	- If at home with no energy, set action to 'Out'
	- Update vision and seal detection
	- Execute behavior based on current action
	- Decrease energy if > 0"
	self patch = home & (self energy = 0) ifTrue: [ ^ self boatAction: 'Out' ].
	self defineVision.
	self lookForSeals.

	self boatAction = 'Navigate' ifTrue: [ self stepNavigation ].
	self boatAction = 'Repository' ifTrue: [ self stepRepository ].
	self boatAction = 'Observation' ifTrue: [ self stepObservation ].
	self boatAction = 'On Land' ifTrue: [ self stepOnLandBoat ].

	self energy > 0 ifTrue: [ energy := energy - 1 ]
]

{ #category : #stepping }
BSBoatKayak >> stepNavigation [
	"Execute navigation behavior:
	- If no energy, move in water
	- If seals visible and action count is 0, change to observation
	- Otherwise, continue moving in water
	- Decrease action count if > 0"
	(self energy = 0) ifTrue: [ ^ self kayakMoveInWater ].
	((self siteWithSeal isNotEmpty) & (self actionCount = 0))
		ifTrue: [ ^ self changeActionToObservation ].
	self kayakMoveInWater.
	(self actionCount > 0) ifTrue: [ actionCount := actionCount - 1 ].
]

{ #category : #stepping }
BSBoatKayak >> stepObservation [
	"Execute observation behavior:
	- If action count is 0, return to navigation
	- If seal awareness is 0, observe from sea
	- Otherwise, move around repository"
	(self actionCount = 0) ifTrue: [ ^ self changeActionToNavigate ].
	(self sealAwareness = 0)
	ifTrue: [ self lookAtSealsFromSea ]
	ifFalse: [ self kayakMoveAroundRepository ].
]

{ #category : #stepping }
BSBoatKayak >> stepOnLandBoat [ 
	"Execute on-land behavior:
	- Increase satisfaction if seals visible
	- If action count < 5, prepare to leave
	- Otherwise, move on land"
	(self patch neighbourhood anySatisfy: [ :cell | cell hasOccupantsOfClass: BSSeal ])
		ifTrue: [ satisfaction := satisfaction + 1 ].
	(self actionCount < 5)
	ifTrue: [ self kayakPrepareToLeave ]
	ifFalse: [ self kayakMoveOnLand ].
]

{ #category : #stepping }
BSBoatKayak >> stepRepository [
	"Execute repository behavior:
	- If on beach, change to on-land mode
	- Otherwise, move towards beach"
	(self patch type = 'Beach')
		ifTrue: [ self changeActionToOnLand ]
		ifFalse: [ self kayakMoveToBeach ]
]

{ #category : #stepping }
BSBoatKayak >> stepStart [ 
	"Initialize the kayak's behavior:
	- Set action count to 0
	- Change to navigation mode"
	self actionCount: 0.
	self changeActionToNavigate.
]
