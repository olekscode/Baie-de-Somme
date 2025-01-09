Class {
	#name : #BSRepository,
	#superclass : #CMAgent,
	#instVars : [
		'name',
		'cell',
		'theSeals',
		'alertLevel',
		'alertCounter',
		'alarmCounter',
		'interactionOnGoing'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #adding }
BSRepository >> addSeal: aSeal [

self theSeals add: aSeal.
]

{ #category : #accessing }
BSRepository >> alarmCounter [

	^ alarmCounter
]

{ #category : #accessing }
BSRepository >> alarmCounter: anObject [

	alarmCounter := anObject
]

{ #category : #accessing }
BSRepository >> alertCounter [

	^ alertCounter
]

{ #category : #accessing }
BSRepository >> alertCounter: anObject [

	alertCounter := anObject
]

{ #category : #accessing }
BSRepository >> alertLevel [

	^ alertLevel
]

{ #category : #accessing }
BSRepository >> alertLevel: anObject [

	alertLevel := anObject
]

{ #category : #accessing }
BSRepository >> cell [

	^ cell
]

{ #category : #accessing }
BSRepository >> cell: anObject [

	cell := anObject
]

{ #category : #initialization }
BSRepository >> initialize [ 

super initialize.

self alarmCounter: 0.
self alertCounter: 0.

self alertLevel: 0.

self theSeals: OrderedCollection new.
]

{ #category : #accessing }
BSRepository >> interactionOnGoing [

	^ interactionOnGoing
]

{ #category : #accessing }
BSRepository >> interactionOnGoing: anObject [

	interactionOnGoing := anObject
]

{ #category : #initialization }
BSRepository >> isAlarmed [

self alarmCounter: self alarmCounter + 1.

self sealAlarmInteraction.
]

{ #category : #initialization }
BSRepository >> isAlerted [

self alertLevel: 1.
]

{ #category : #accessing }
BSRepository >> name [

	^ name
]

{ #category : #accessing }
BSRepository >> name: anObject [

	name := anObject
]

{ #category : #'as yet unclassified' }
BSRepository >> sealAlarmInteraction [

self theSeals do: [ :each | each escapeInSea ].

"self cell do: [ :each | 
	each theOccupants do: [ :occupant | occupant do: [ :seal | (self class = BSSeal) ifTrue: [ seal currentStatus: 'Alarmed' ]]  ]"
	 
		"(each hasOccupantsOfClass: BSSeal)
		ifTrue: [ each theOccupants do: [ :occupant |
				occupant do: [ :seal | (self class = BSSeal) ifTrue: [ seal currentStatus: 'Alarmed' ] ] 
				] ] 
		]"
]

{ #category : #'as yet unclassified' }
BSRepository >> sealAlertInteraction [

self alertCounter: (self alertCounter + 1).
]

{ #category : #initialization }
BSRepository >> step [

interactionOnGoing ifTrue: [ 
(self alertLevel = 0) ifTrue: [ self interactionOnGoing: false ].
(self alertLevel = 1) ifTrue: [ self sealAlertInteraction ].
(self alertLevel = 2) ifTrue: [ self sealAlarmInteraction ]
]


]

{ #category : #accessing }
BSRepository >> theSeals [

	^ theSeals
]

{ #category : #accessing }
BSRepository >> theSeals: anObject [

	theSeals := anObject
]
