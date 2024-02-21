Class {
	#name : #BSBoat,
	#superclass : #CMAgent,
	#traits : 'TCMLocated',
	#classTraits : 'TCMLocated classTrait',
	#instVars : [
		'home',
		'satisfaction',
		'energy'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSBoat >> energy [

	^ energy
]

{ #category : #accessing }
BSBoat >> energy: anObject [

	energy := anObject
]

{ #category : #accessing }
BSBoat >> home [

	^ home
]

{ #category : #accessing }
BSBoat >> home: anObject [

	home := anObject
]

{ #category : #initialization }
BSBoat >> initialize [ 

	super initialize.
	satisfaction := 0.
	energy := (Cormas random * 100) rounded.
	"siteWithSeal := OrderedCollection new."
]

{ #category : #pov }
BSBoat >> pov [

	self subclassResponsibility
]

{ #category : #accessing }
BSBoat >> satisfaction [

	^ satisfaction
]

{ #category : #accessing }
BSBoat >> satisfaction: anObject [

	satisfaction := anObject
]

{ #category : #stepping }
BSBoat >> step [

self randomWalkConstrainedBy: [ :cell | cell type = 'Sea' ]
]
