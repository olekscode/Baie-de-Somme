Class {
	#name : #BSBoatMotorized,
	#superclass : #BSBoat,
	#category : #'Baie de Somme-Model'
}

{ #category : #behavior }
BSBoatMotorized >> changeActionToObservation [

| target |

target := self boatDestination first.

"self boatAction: 'Observation'."

self boatDestination: (self boatDestination reject: [ :cell | cell = target]).
]

{ #category : #behavior }
BSBoatMotorized >> checkPosition [ 
	
^ self
]

{ #category : #pov }
BSBoatMotorized >> pov [

	^ Color white
]

{ #category : #stepping }
BSBoatMotorized >> step [
self boatDestination ifEmpty: [ ^ self boatAction = 'Ending' ].
"Au début de chaque tour on définit ce que voit le bateau"
self defineVision.
self lookForSeals.
"Si le kayak voit des phoques il gagne de la satisfaction"
(self siteWithSeal isNotEmpty) ifTrue: [ satisfaction := satisfaction +1 ].
(self patch hasOccupantsOfClass: BSSeal) ifTrue: [ satisfaction := satisfaction + 1 ].
	
	(self boatAction = 'Navigate') ifTrue: [ self stepNavigation ].
]

{ #category : #stepping }
BSBoatMotorized >> stepNavigation [

| target |

target := self boatDestination first.

(self patch = target) ifTrue: [ ^ self changeActionToObservation ].

self moveTowards: target constraintOnPath: [ :cell | cell accessRule = 'Sea' ].
self moveTowards: target constraintOnPath: [ :cell | cell accessRule = 'Sea' ].
self moveTowards: target constraintOnPath: [ :cell | cell accessRule = 'Sea' ].
]
