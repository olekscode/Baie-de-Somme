Class {
	#name : 'BSBoatMotorized',
	#superclass : 'BSBoat',
	#category : 'Baie de Somme-Model',
	#package : 'Baie de Somme-Model'
}

{ #category : 'behavior' }
BSBoatMotorized >> changeActionToObservation [

| target |

target := self boatDestination first.

"self boatAction: 'Observation'."

self boatDestination: (self boatDestination reject: [ :cell | cell = target]).
]

{ #category : 'behavior' }
BSBoatMotorized >> checkPosition [ 
	
^ self
]

{ #category : 'pov' }
BSBoatMotorized >> pov [

	self boatAction = 'Out' ifTrue: [ ^ CMPointOfView color: Color blue size: 0.1 ].
	self boatAction = 'Navigate' ifTrue: [ ^ CMPointOfView color: Color white shape: #circle size: 0.7 ].
	self boatAction = 'Repository' ifTrue: [ ^ CMPointOfView color: Color white shape: #diamond size: 0.7 ].
	self boatAction = 'Observation' ifTrue: [ ^ CMPointOfView color: Color white shape: #square size: 0.7 ].
	self boatAction = 'On Land' ifTrue: [ ^ CMPointOfView color: Color white shape: #star size: 0.7 ].
	
	^ CMPointOfView color: Color white size: 0.7
	
]

{ #category : 'stepping' }
BSBoatMotorized >> step [
self boatDestination ifEmpty: [ ^ self boatAction = 'Out' ].
"Au début de chaque tour on définit ce que voit le bateau"
self defineVision.
self lookForSeals.
"Si le kayak voit des phoques il gagne de la satisfaction"
(self siteWithSeal isNotEmpty) ifTrue: [ satisfaction := satisfaction +1 ].
(self patch hasOccupantsOfClass: BSSeal) ifTrue: [ satisfaction := satisfaction + 1 ].
	
	(self boatAction = 'Navigate') ifTrue: [ self stepNavigation ].
]

{ #category : 'stepping' }
BSBoatMotorized >> stepNavigation [

| target |

target := self boatDestination first.

(self patch = target) ifTrue: [ ^ self changeActionToObservation ].

self moveTowards: target constraintOnPath: [ :cell | cell accessRule = 'Sea' ].
self moveTowards: target constraintOnPath: [ :cell | cell accessRule = 'Sea' ].
self moveTowards: target constraintOnPath: [ :cell | cell accessRule = 'Sea' ].

(self patch = self home and:[ self boatDestination isEmpty ]) ifTrue: [ self boatAction: 'Out' ].
]
