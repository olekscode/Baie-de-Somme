Class {
	#name : #BSHabitatCell,
	#superclass : #CMSpatialEntityElement,
	#instVars : [
		'type',
		'legalStatus'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #initialization }
BSHabitatCell >> initialize [ 
	
	super initialize.
	legalStatus := 'Public'
]

{ #category : #initialization }
BSHabitatCell >> initializeWithRandomHabitat [

	(Cormas random * 100 < 50) ifTrue: [ self type: 'Land' ] ifFalse: [ self type: 'Sea' ].
	

]

{ #category : #accessing }
BSHabitatCell >> legalStatus [

	^ legalStatus
]

{ #category : #accessing }
BSHabitatCell >> legalStatus: anObject [

	legalStatus := anObject
]

{ #category : #pov }
BSHabitatCell >> povHabitatType [

	self type = 'Home' ifTrue: [ ^ Color black  ].
	
	self type = 'Land' ifTrue: [ ^ Color yellow ].
	
	self type = 'Sea' ifTrue: [ ^ Color blue ].
		 
]

{ #category : #pov }
BSHabitatCell >> povLegalStatus [

	self legalStatus = 'Public' ifTrue: [ ^ Color pink  ].
	
	self legalStatus = 'Private' ifTrue: [ ^ Color black ].
	
		 
]

{ #category : #accessing }
BSHabitatCell >> type [

	^ type
]

{ #category : #accessing }
BSHabitatCell >> type: anObject [

	type := anObject
]
