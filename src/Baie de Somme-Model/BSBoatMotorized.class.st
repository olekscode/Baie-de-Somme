"BSBoatMotorized represents a motorized boat in the Baie de Somme simulation.
This class specializes the BSBoat class to implement behaviors specific to motorized boats, including:
- Navigation along predefined routes with stops
- Seal observation from a distance
- Following a fixed schedule of stops
- Less flexible movement compared to kayaks"

Class {
	#name : #BSBoatMotorized,
	#superclass : #BSBoat,
	#category : #'Baie de Somme-Model'
}

{ #category : #behavior }
BSBoatMotorized >> changeActionToObservation [
	"Change the boat's action to observation mode:
	- Remove the current target from the destination list
	- Set action to 'Observation'"
	| target |
	target := self boatDestination first.
	self boatDestination: (self boatDestination reject: [ :cell | cell = target]).
]

{ #category : #behavior }
BSBoatMotorized >> checkPosition [ 
	"Check the current position of the boat"
	^ self
]

{ #category : #pov }
BSBoatMotorized >> pov [
	"Return the color representation of the motorized boat:
	- White color"
	^ Color white
]

{ #category : #stepping }
BSBoatMotorized >> step [
	"Execute one step of the motorized boat's behavior:
	- If no destinations left, check if action is 'Ending'
	- Update vision and seal detection
	- If in navigation mode, execute navigation behavior"
	self boatDestination ifEmpty: [ ^ self boatAction = 'Ending' ].
	self defineVision.
	self lookForSeals.
	(self siteWithSeal isNotEmpty) ifTrue: [ satisfaction := satisfaction +1 ].
	(self patch hasOccupantsOfClass: BSSeal) ifTrue: [ satisfaction := satisfaction + 1 ].
	
	(self boatAction = 'Navigate') ifTrue: [ self stepNavigation ].
]

{ #category : #stepping }
BSBoatMotorized >> stepNavigation [
	"Execute navigation behavior:
	- If at target, change to observation mode
	- Otherwise, move towards target following sea paths
	- Move three times in one step to simulate faster movement"
	| target |
	target := self boatDestination first.

	(self patch = target) ifTrue: [ ^ self changeActionToObservation ].

	self moveTowards: target constraintOnPath: [ :cell | cell accessRule = 'Sea' ].
	self moveTowards: target constraintOnPath: [ :cell | cell accessRule = 'Sea' ].
	self moveTowards: target constraintOnPath: [ :cell | cell accessRule = 'Sea' ].
]
