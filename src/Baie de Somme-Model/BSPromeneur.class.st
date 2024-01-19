Class {
	#name : #BSPromeneur,
	#superclass : #CMAgent,
	#traits : 'TCMLocated',
	#classTraits : 'TCMLocated classTrait',
	#instVars : [
		'satisfaction',
		'energy'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSPromeneur >> energy [

	^ energy
]

{ #category : #accessing }
BSPromeneur >> energy: anObject [

	energy := anObject
]

{ #category : #initialization }
BSPromeneur >> initialize [ 

	super initialize.
	satisfaction := 0.
	energy := 10.
]

{ #category : #printing }
BSPromeneur >> interestingDetails [
	"Answer a Collection>of interesting receiver's attributes, from a modeler point of view, to display in a popup for example "

	^ super interestingDetails , { 
		'Energy: ' -> (self energy asString)
		}
]

{ #category : #pov }
BSPromeneur >> pov [

	self subclassResponsibility
]

{ #category : #moving }
BSPromeneur >> rentre [
	| candidatePatches |

	patch ifNil: [ ^ self ].
	
	candidatePatches := self patch neighbourhoodAndSelf select: [ :each | each type = 'Land' ].
	
	candidatePatches ifEmpty: [ ^ self ].
	
	self moveTowards: patch type = 'Home' constraintOnPath: [ :each | each type = 'Land' ].
]

{ #category : #accessing }
BSPromeneur >> satisfaction [

	^ satisfaction
]

{ #category : #accessing }
BSPromeneur >> satisfaction: anObject [

	satisfaction := anObject
]

{ #category : #stepping }
BSPromeneur >> step [

	(energy = 0) ifTrue: [ self rentre ].


]
