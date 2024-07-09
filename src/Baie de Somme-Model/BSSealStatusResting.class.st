Class {
	#name : #BSSealStatusResting,
	#superclass : #BSSealStatus,
	#instVars : [
		'alertLevel'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSSealStatusResting >> alertLevel [

	^ alertLevel
]

{ #category : #accessing }
BSSealStatusResting >> alertLevel: anObject [

	alertLevel := anObject
]

{ #category : #behavior }
BSSealStatusResting >> escapeInSea [ 


]

{ #category : #behavior }
BSSealStatusResting >> isAlerted [

self holder isAlerted.
]

{ #category : #behavior }
BSSealStatusResting >> monitorSurroundingsOnRepository [

(holder sight anySatisfy: [ :cell | (cell hasOccupantsOfClass: BSWalker) or: [ cell hasOccupantsOfClass: BSBoat ] ])
	ifTrue: [ ^ self isAlerted ].
	
self alertLevel: 0.
]

{ #category : #stepping }
BSSealStatusResting >> step [ 

self monitorSurroundingsOnRepository.

(self alertLevel > 3) ifTrue: self escapeInSea.
]
