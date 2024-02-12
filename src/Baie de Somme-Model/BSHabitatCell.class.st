Class {
	#name : #BSHabitatCell,
	#superclass : #CMSpatialEntityElement,
	#instVars : [
		'type',
		'accessRule',
		'sealRestingPlace',
		'walkerObservatory',
		'threatLevel',
		'numberOfWalker'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSHabitatCell >> accessRule [

	^ accessRule
]

{ #category : #accessing }
BSHabitatCell >> accessRule: anObject [

	accessRule := anObject
]

{ #category : #'as yet unclassified' }
BSHabitatCell >> defineNumberOfWalker [

(self hasOccupantsOfClass: BSWalker) 
	ifTrue: [self theOccupants do: [ :each | each do: [ :each2 | numberOfWalker:= numberOfWalker + each2 groupSize ]]]
	ifFalse: [ numberOfWalker:= 0 ]
]

{ #category : #'as yet unclassified' }
BSHabitatCell >> defineThreatLevelLand [

| arg1 arg2 selec |

self defineNumberOfWalker.

selec := OrderedCollection new.
arg1:=0.
(self numberOfWalker > 0)
	ifTrue: [ (numberOfWalker < 5) 
		ifTrue: [ arg1:= 2 ]
		ifFalse: [ (numberOfWalker > 20) ifTrue: [ arg1:= 4 ] ifFalse: [arg1:= 3]]. ]
	ifFalse: [ arg1:= 0 ].

arg2:=0.
self neighbourhood do: [ :cell | cell theOccupants 
	do: [ :collecOfOccup | collecOfOccup 
		do: [ :eachOccupant | (eachOccupant className = BSWalkerGuide) 
			ifTrue: [ (eachOccupant withDog = 'unleashed') 
				ifTrue: [arg2:=1]
			]
		]
	]
].

self threatLevel: (arg1 + arg2).
]

{ #category : #initialization }
BSHabitatCell >> initialize [ 
	
	super initialize.
	
	self threatLevel: 0.
	self numberOfWalker: 0.
]

{ #category : #initialization }
BSHabitatCell >> initializeWithRandomHabitat [

	(Cormas random * 100 < 50) ifTrue: [ self type: 'Land' ] ifFalse: [ self type: 'Sea' ].
	

]

{ #category : #accessing }
BSHabitatCell >> numberOfWalker [

	^ numberOfWalker
]

{ #category : #accessing }
BSHabitatCell >> numberOfWalker: anObject [

	numberOfWalker := anObject
]

{ #category : #pov }
BSHabitatCell >> povHabitatType [

	self type = 'Home' ifTrue: [ ^ Color black  ].
	
	self type = 'Land' ifTrue: [ ^ Color yellow ].
	
	self type = 'Sea' ifTrue: [ ^ Color blue ].
		 
]

{ #category : #pov }
BSHabitatCell >> povLegalStatus [

	self accessRule = 'Accessible' ifTrue: [ ^ Color pink  ].
	
	self accessRule = 'Forbidden' ifTrue: [ ^ Color black ].
	
		 
]

{ #category : #pov }
BSHabitatCell >> povRestingPlace [

	self sealRestingPlace  = 'R1' ifTrue: [ ^ Color green ].
	self sealRestingPlace  = 'R2' ifTrue: [ ^ Color green ].
	self sealRestingPlace  = 'R3' ifTrue: [ ^ Color green ].
	self sealRestingPlace  = 'Observatory' ifTrue: [ ^ Color yellow ].
	self sealRestingPlace  = 'Not' ifTrue: [ ^ Color black ].
]

{ #category : #pov }
BSHabitatCell >> povThreatLevel [

		^ self
		povAttribute: #threatLevel
		min: 0
		max: 4
		color: Color red
]

{ #category : #accessing }
BSHabitatCell >> sealRestingPlace [

	^ sealRestingPlace
]

{ #category : #accessing }
BSHabitatCell >> sealRestingPlace: anObject [

	sealRestingPlace := anObject
]

{ #category : #stepping }
BSHabitatCell >> step [

(self type = 'Land')
ifTrue: [self defineThreatLevelLand].
]

{ #category : #accessing }
BSHabitatCell >> threatLevel [

	^ threatLevel
]

{ #category : #accessing }
BSHabitatCell >> threatLevel: anObject [

	threatLevel := anObject
]

{ #category : #accessing }
BSHabitatCell >> type [

	^ type
]

{ #category : #accessing }
BSHabitatCell >> type: anObject [

	type := anObject
]
