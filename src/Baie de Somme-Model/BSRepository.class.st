"BSRepository represents a seal resting place in the Baie de Somme simulation.
This class manages the behavior and state of seal repositories, including:
- Tracking seals present in the repository
- Managing alert levels and interactions
- Coordinating seal responses to disturbances
- Monitoring visitor interactions"

Class {
	#name : #BSRepository,
	#superclass : #CMAgent,
	#instVars : [
		'name',			"Name of the repository"
		'cell',			"Location of the repository"
		'theSeals',		"Collection of seals in the repository"
		'alertLevel',		"Current alert level (0-2)"
		'alertCounter',		"Counter for alert state duration"
		'alarmCounter',		"Counter for alarm state duration"
		'interactionOnGoing'	"Flag indicating active interaction"
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #adding }
BSRepository >> addSeal: aSeal [
	"Add a seal to this repository's collection"
	self theSeals add: aSeal.
]

{ #category : #accessing }
BSRepository >> alarmCounter [
	"Return the current alarm counter value"
	^ alarmCounter
]

{ #category : #accessing }
BSRepository >> alarmCounter: anObject [
	"Set the alarm counter to the specified value"
	alarmCounter := anObject
]

{ #category : #accessing }
BSRepository >> alertCounter [
	"Return the current alert counter value"
	^ alertCounter
]

{ #category : #accessing }
BSRepository >> alertCounter: anObject [
	"Set the alert counter to the specified value"
	alertCounter := anObject
]

{ #category : #accessing }
BSRepository >> alertLevel [
	"Return the current alert level (0-2)"
	^ alertLevel
]

{ #category : #accessing }
BSRepository >> alertLevel: anObject [
	"Set the alert level to the specified value (0-2)"
	alertLevel := anObject
]

{ #category : #accessing }
BSRepository >> cell [
	"Return the cell where this repository is located"
	^ cell
]

{ #category : #accessing }
BSRepository >> cell: anObject [
	"Set the cell where this repository is located"
	cell := anObject
]

{ #category : #initialization }
BSRepository >> initialize [ 
	"Initialize a new repository with default values:
	- Set alarm and alert counters to 0
	- Set initial alert level to 0
	- Create an empty collection for seals"
	super initialize.

	self alarmCounter: 0.
	self alertCounter: 0.
	self alertLevel: 0.
	self theSeals: OrderedCollection new.
]

{ #category : #accessing }
BSRepository >> interactionOnGoing [
	"Return whether there is an ongoing interaction"
	^ interactionOnGoing
]

{ #category : #accessing }
BSRepository >> interactionOnGoing: anObject [
	"Set whether there is an ongoing interaction"
	interactionOnGoing := anObject
]

{ #category : #initialization }
BSRepository >> isAlarmed [
	"Increase the alarm counter and trigger seal alarm interaction"
	self alarmCounter: self alarmCounter + 1.
	self sealAlarmInteraction.
]

{ #category : #initialization }
BSRepository >> isAlerted [
	"Set the alert level to 1 (alerted state)"
	self alertLevel: 1.
]

{ #category : #accessing }
BSRepository >> name [
	"Return the name of this repository"
	^ name
]

{ #category : #accessing }
BSRepository >> name: anObject [
	"Set the name of this repository"
	name := anObject
]

{ #category : #'as yet unclassified' }
BSRepository >> sealAlarmInteraction [
	"Trigger alarm response for all seals in the repository:
	- Make all seals escape to the sea
	- Update their status to 'Alarmed'"
	self theSeals do: [ :each | each escapeInSea ].
]

{ #category : #'as yet unclassified' }
BSRepository >> sealAlertInteraction [
	"Increase the alert counter when seals are alerted"
	self alertCounter: (self alertCounter + 1).
]

{ #category : #initialization }
BSRepository >> step [
	"Execute one step of the repository's behavior:
	- If there is an ongoing interaction:
	  * Level 0: End the interaction
	  * Level 1: Trigger alert interaction
	  * Level 2: Trigger alarm interaction"
	interactionOnGoing ifTrue: [ 
		(self alertLevel = 0) ifTrue: [ self interactionOnGoing: false ].
		(self alertLevel = 1) ifTrue: [ self sealAlertInteraction ].
		(self alertLevel = 2) ifTrue: [ self sealAlarmInteraction ]
	]
]

{ #category : #accessing }
BSRepository >> theSeals [
	"Return the collection of seals in this repository"
	^ theSeals
]

{ #category : #accessing }
BSRepository >> theSeals: anObject [
	"Set the collection of seals in this repository"
	theSeals := anObject
]
