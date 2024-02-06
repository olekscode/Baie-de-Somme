Class {
	#name : #BSSeal,
	#superclass : #CMAgent,
	#traits : 'TCMLocated',
	#classTraits : 'TCMLocated classTrait',
	#instVars : [
		'restingPlace',
		'sightSea',
		'sightLand',
		'alertLevel'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSSeal >> alertLevel [

	^ alertLevel
]

{ #category : #accessing }
BSSeal >> alertLevel: anObject [

	alertLevel := anObject
]

{ #category : #behavior }
BSSeal >> defineVision [

self defineVisionLand.
self defineVisionSea.
]

{ #category : #behavior }
BSSeal >> defineVisionLand [

|scope1 scope2|
	scope1 := OrderedCollection new.
	scope2 := OrderedCollection new.
	scope1 := patch neighbourhoodAndSelf.
	scope2 := scope1 select: [ :cell | cell type = 'Land' ].
	scope1 := scope2.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope2 := scope1 select: [ :cell | cell type = 'Land' ].
	scope1 := scope2.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope2 := scope1 select: [ :cell | cell type = 'Land' ].
	self sightLand: scope2.
]

{ #category : #behavior }
BSSeal >> defineVisionSea [

|scope1 scope2|
	scope1 := OrderedCollection new.
	scope2 := OrderedCollection new.
	scope1 := patch neighbourhoodAndSelf.
	scope2 := scope1 select: [ :cell | cell type = 'Sea' ].
	scope1 := scope2.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope2 := scope1 select: [ :cell | cell type = 'Sea' ].
	scope1 := scope2.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope2 := scope1 select: [ :cell | cell type = 'Sea' ].
	self sightSea: scope2.
]

{ #category : #behavior }
BSSeal >> escapeInSea [

self randomWalkConstrainedBy: 	[ :cell | cell type = 'Sea' ].
]

{ #category : #initialization }
BSSeal >> initialize [
| a |
	super initialize.
	self alertLevel: 0.
	"restingPlace := OrderedCollection new."
	
	a:= Cormas random.
	(a < 0.33) ifTrue: [ ^ self restingPlace: 'R1' ].
	(a > 0.66) ifTrue: [ ^ self restingPlace: 'R2' ].
	self restingPlace: 'R3'.
]

{ #category : #behavior }
BSSeal >> isAlerted [

(self alertLevel > 0)
	ifTrue: [ self escapeInSea ]
	ifFalse: [ self alertLevel: 1 ].
]

{ #category : #behavior }
BSSeal >> monitorSurroundings [


(self sightLand anySatisfy: [:cell | cell threatLevel > ((self patch distanceTo: cell))])
	ifTrue: [ self isAlerted ].
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

{ #category : #accessing }
BSSeal >> sightLand [

	^ sightLand
]

{ #category : #accessing }
BSSeal >> sightLand: anObject [

	sightLand := anObject
]

{ #category : #accessing }
BSSeal >> sightSea [

	^ sightSea
]

{ #category : #accessing }
BSSeal >> sightSea: anObject [

	sightSea := anObject
]

{ #category : #stepping }
BSSeal >> step [

	self selectRestingPlace.
	
	(self patch type = 'Sea') 
		ifTrue: [ self stepInSea ]
		ifFalse: [ self stepOnLand ].
]

{ #category : #stepping }
BSSeal >> stepInSea [

self randomWalkConstrainedBy: [ :cell | cell type = 'Sea' ].


]

{ #category : #stepping }
BSSeal >> stepOnLand [

self defineVision.
self monitorSurroundings.
]
