Class {
	#name : #BSHabitatCell,
	#superclass : #CMSpatialEntityElement,
	#instVars : [
		'type',
		'accessRule',
		'sealRestingPlace',
		'walkerObservatory'
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

{ #category : #initialization }
BSHabitatCell >> initialize [ 
	
	super initialize.
]

{ #category : #initialization }
BSHabitatCell >> initializeWithRandomHabitat [

	(Cormas random * 100 < 50) ifTrue: [ self type: 'Land' ] ifFalse: [ self type: 'Sea' ].
	

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

	self sealRestingPlace = 'R1' ifTrue: [ ^ Color white  ].
	
	self sealRestingPlace = 'R2' ifTrue: [ ^ Color white  ].
	
	self sealRestingPlace = 'R3' ifTrue: [ ^ Color white  ].
	
	self sealRestingPlace = 'Not' ifTrue: [ ^ Color black  ].
	
	self sealRestingPlace = 'O1' ifTrue: [ ^ Color blue  ].
	
	self sealRestingPlace = 'O2' ifTrue: [ ^ Color blue  ].
	
	self sealRestingPlace = 'O3' ifTrue: [ ^ Color blue  ].
		 
]

{ #category : #pov }
BSHabitatCell >> povWalkerSight [

	(self hasOccupantsOfClass: BSWalker)
		ifTrue: [ ^ self  povHabitatType ].
		
	(self neighbourhood anySatisfy: [ :each | each hasOccupantsOfClass: BSWalker ])
		ifTrue: [ ^ self  povHabitatType ].
		
	^ Color black
]

{ #category : #accessing }
BSHabitatCell >> sealRestingPlace [

	^ sealRestingPlace
]

{ #category : #accessing }
BSHabitatCell >> sealRestingPlace: anObject [

	sealRestingPlace := anObject
]

{ #category : #accessing }
BSHabitatCell >> type [

	^ type
]

{ #category : #accessing }
BSHabitatCell >> type: anObject [

	type := anObject
]
