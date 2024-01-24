Class {
	#name : #BSSeal,
	#superclass : #CMAgent,
	#traits : 'TCMLocated',
	#classTraits : 'TCMLocated classTrait',
	#instVars : [
		'restingPlace'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #initialization }
BSSeal >> initialize [
| a |
	super initialize.

	"restingPlace := OrderedCollection new."
	
	a:= Cormas random.
	(a < 0.33) ifTrue: [ ^ self restingPlace: 'R1' ].
	(a > 0.66) ifTrue: [ ^ self restingPlace: 'R2' ].
	self restingPlace: 'R3'.
]

{ #category : #pov }
BSSeal >> pov [

	^ Color black 
]

{ #category : #accessing }
BSSeal >> restingPlace [

	^ restingPlace
]

{ #category : #accessing }
BSSeal >> restingPlace: anObject [

	restingPlace := anObject
]

{ #category : #behavior }
BSSeal >> selectRestingPlace [

 ^self
]

{ #category : #stepping }
BSSeal >> step [

	self selectRestingPlace.
]
