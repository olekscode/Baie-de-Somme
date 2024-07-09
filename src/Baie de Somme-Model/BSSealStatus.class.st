Class {
	#name : #BSSealStatus,
	#superclass : #CMAgent,
	#instVars : [
		'timer',
		'holder'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #'as yet unclassified' }
BSSealStatus class >> changeStatusOf: aSeal To: aStatus [

aSeal changeStatusTo: aStatus. 
]

{ #category : #accessing }
BSSealStatus >> holder [

	^ holder
]

{ #category : #accessing }
BSSealStatus >> holder: anObject [

	holder := anObject
]

{ #category : #accessing }
BSSealStatus >> timer [

	^ timer
]

{ #category : #accessing }
BSSealStatus >> timer: anObject [

	timer := anObject
]
