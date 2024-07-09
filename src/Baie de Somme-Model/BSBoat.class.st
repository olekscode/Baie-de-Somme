Class {
	#name : #BSBoat,
	#superclass : #CMAgent,
	#traits : 'TCMLocated',
	#classTraits : 'TCMLocated classTrait',
	#instVars : [
		'home',
		'satisfaction',
		'energy',
		'siteWithSeal',
		'sight',
		'boatDestination',
		'boatDirection',
		'boatAction',
		'actionCount',
		'sealAwareness',
		'wayMemory',
		'restingPlaceMemory'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSBoat >> actionCount [

	^ actionCount
]

{ #category : #accessing }
BSBoat >> actionCount: anObject [

	actionCount := anObject
]

{ #category : #accessing }
BSBoat >> boatAction [

	^ boatAction
]

{ #category : #accessing }
BSBoat >> boatAction: anObject [

	boatAction := anObject
]

{ #category : #accessing }
BSBoat >> boatDestination [

	^ boatDestination
]

{ #category : #accessing }
BSBoat >> boatDestination: anObject [

	boatDestination := anObject
]

{ #category : #accessing }
BSBoat >> boatDirection [

	^ boatDirection
]

{ #category : #accessing }
BSBoat >> boatDirection: anObject [

	boatDirection := anObject
]

{ #category : #behavior }
BSBoat >> defineVision [

	|scope1 scope2|
	scope1 := OrderedCollection new.
	scope2 := OrderedCollection new.
	scope1 := patch neighbourhoodAndSelf.
	scope2 := scope1.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope2 := scope1.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	self sight: scope2.
]

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

|arg|
	super initialize.
	satisfaction := 0.
	energy := (Cormas random * 100) rounded.
	siteWithSeal := OrderedCollection new.
	self boatAction: 'Navigate'.
	actionCount := 0.
	
	arg:= Cormas random.
	(arg < 0.2) 
		ifTrue: [ self sealAwareness: 0] 
		ifFalse: [ 
			(arg > 0.8) 
				ifTrue: [self sealAwareness: 2]
				ifFalse: [ self sealAwareness: 1 ]].
				
]

{ #category : #behavior }
BSBoat >> lookForSeals [

self siteWithSeal: (self sight select: [ :cell | ((cell hasOccupantsOfClass: BSSeal) & (cell type = 'Beach'))]).
	
]

{ #category : #moving }
BSBoat >> moveInDirectionOf: aCell constraintOnPath: aBlock [
	"Purpose: moves one cell in direction of a given location, taking a specified constraint on each cell of the path to destination.
Argument: aCell = <SpatialEntityElement>
Example: self moveTowards: self house patch constraintOnPath: [:c | c isClosed not]"

	| path candidate dist|
	dist:=3.
	
	self isSituated ifTrue: [
		self patch = aCell ifFalse: [
			path := self patch wayTo: aCell.
			"path remove: self patch."
			
			path do: [ :cell | (self patch distanceTo: cell) < dist ifTrue: 
				[ candidate := cell asOrderedCollection. dist := self patch distanceTo: cell ] ].
			
			candidate:= candidate select: [ :c | aBlock value: c ].
			candidate isNotEmpty ifTrue: [ self moveTo: candidate atRandom ]] ]
]

{ #category : #behavior }
BSBoat >> moveToDestination [ 

"self previousCell: self patch."
self moveInDirectionOf: boatDestination constraintOnPath: [ :cell | cell kayakWay = 'Way']
]

{ #category : #pov }
BSBoat >> pov [

	self subclassResponsibility
]

{ #category : #accessing }
BSBoat >> restingPlaceMemory [

	^ restingPlaceMemory
]

{ #category : #accessing }
BSBoat >> restingPlaceMemory: anObject [

	restingPlaceMemory := anObject
]

{ #category : #accessing }
BSBoat >> satisfaction [

	^ satisfaction
]

{ #category : #accessing }
BSBoat >> satisfaction: anObject [

	satisfaction := anObject
]

{ #category : #accessing }
BSBoat >> sealAwareness [

	^ sealAwareness
]

{ #category : #accessing }
BSBoat >> sealAwareness: anObject [

	sealAwareness := anObject
]

{ #category : #accessing }
BSBoat >> sight [

	^ sight
]

{ #category : #accessing }
BSBoat >> sight: anObject [

	sight := anObject
]

{ #category : #accessing }
BSBoat >> siteWithSeal [

	^ siteWithSeal
]

{ #category : #accessing }
BSBoat >> siteWithSeal: anObject [

	siteWithSeal := anObject
]

{ #category : #stepping }
BSBoat >> step [

self subclassResponsibility.



	
]

{ #category : #accessing }
BSBoat >> wayMemory [

	^ wayMemory
]

{ #category : #accessing }
BSBoat >> wayMemory: anObject [

	wayMemory := anObject
]
