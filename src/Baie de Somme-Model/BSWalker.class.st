Class {
	#name : 'BSWalker',
	#superclass : 'CMAgent',
	#traits : 'TCMLocated',
	#classTraits : 'TCMLocated classTrait',
	#instVars : [
		'home',
		'way',
		'satisfaction',
		'energy',
		'previousCell',
		'sight',
		'walkerAction',
		'sealExpectation',
		'groupSize',
		'siteWithSeal',
		'walkerDestination',
		'walkerPath',
		'sealAwareness',
		'actionCount',
		'withBinoculars'
	],
	#category : 'Baie de Somme-Model',
	#package : 'Baie de Somme-Model'
}

{ #category : 'accessing' }
BSWalker >> actionCount [

	^ actionCount
]

{ #category : 'accessing' }
BSWalker >> actionCount: anObject [

	actionCount := anObject
]

{ #category : 'control' }
BSWalker >> changeActionToEnded [

self walkerAction: 'Ended'.
]

{ #category : 'control' }
BSWalker >> changeActionToObservation [ 

self walkerAction: 'Observation'.

self siteWithSeal ifEmpty: [ self actionCount: (Random new next * 10 + 10) rounded ]
 ifNotEmpty: [ self actionCount: (Random new next * 10 + 30) rounded ].


]

{ #category : 'control' }
BSWalker >> changeActionToWalking [

self walkerAction: 'Walking'.

self defineDestination.
	
self actionCount: 1.
]

{ #category : 'behavior' }
BSWalker >> checkPosition [

self subclassResponsibility.
]

{ #category : 'behavior' }
BSWalker >> defineDestination [ 

self subclassResponsibility.
]

{ #category : 'behavior' }
BSWalker >> defineVision [

|scope1 scope2|
	scope1 := OrderedCollection new.
	scope2 := OrderedCollection new.
	scope1 := patch neighbourhoodAndSelf.
	scope2 := scope1 asOrderedCollection.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope1 := scope2.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	self sight: scope2.
]

{ #category : 'accessing' }
BSWalker >> energy [

	^ energy
]

{ #category : 'accessing' }
BSWalker >> energy: anObject [

	energy := anObject
]

{ #category : 'behavior' }
BSWalker >> goBackHome [
	
	self moveTowards: home constraintOnPath: [ :cell | (cell type = 'Land') or: [cell type = 'Home']].
	
]

{ #category : 'accessing' }
BSWalker >> groupSize [

	^ groupSize
]

{ #category : 'accessing' }
BSWalker >> groupSize: anObject [

	groupSize := anObject
]

{ #category : 'accessing' }
BSWalker >> home [

	^ home
]

{ #category : 'accessing' }
BSWalker >> home: anObject [

	home := anObject
]

{ #category : 'initialization' }
BSWalker >> initialize [ 

	| arg |
	
	super initialize.
	satisfaction := 0.
	
	siteWithSeal := OrderedCollection new. 
	self walkerAction: 'Starting'.
	
	arg:= Random new next.
	(arg < 0.5) 
		ifTrue: [ self sealAwareness: 1 ] 
		ifFalse: [ self sealAwareness: 0].
]

{ #category : 'printing' }
BSWalker >> interestingDetails [
	"Answer a Collection>of interesting receiver's attributes, from a modeler point of view, to display in a popup for example "

	^ super interestingDetails , { 
		'Energy: ' -> (self energy asString)
		}
]

{ #category : 'behavior' }
BSWalker >> lookAtSeals [

| seals people |
seals := 0.
people := 0.

self siteWithSeal isNotEmpty ifTrue: [ seals := 1 ].

((self sight anySatisfy: [ :cell | cell hasOccupantsOfClass: BSWalker ]) or: [ self sight anySatisfy: [ :cell | cell hasOccupantsOfClass: BSBoat ]]) ifTrue: [ people := 1].

(self sealAwareness = 'yes')
	ifTrue: [ ^ self lookAtSealsAware ]
	ifFalse: [ ^ self lookAtSealsNotAware ]
]

{ #category : 'behavior' }
BSWalker >> lookAtSealsAware [

"| numberOfWalkers|
numberOfWalkers := 0.
	
self patch allOccupants do: [ :walker | numberOfWalkers := numberOfWalkers + walker groupSize ].
	
(numberOfWalkers < (self groupSize + 1)) 
	ifTrue: [ satisfaction := satisfaction + 2 ]
	ifFalse: [ satisfaction := satisfaction + 1 ].
	self walkerDestination: self patch."
]

{ #category : 'behavior' }
BSWalker >> lookAtSealsNotAware [

"On contrôle si le promeneur voit toujours des phoques sur le reposoir"
(self siteWithSeal)
	ifNotEmpty: [ self moveTowards: (self siteWithSeal atRandom) constraintOnPath: [ :cell | cell accessRule = 'Land' ] ] "S'il voit des phoques il se rapproche"
	ifEmpty: [ self moveOnRepository ]. "S'il ne voit pas de phoque il bouge sur le reposoir"
]

{ #category : 'behavior' }
BSWalker >> lookForSeals [

self siteWithSeal: (self sight select: [ :cell | (cell hasOccupantsOfClass: BSSeal) & (cell type = 'Land') ]).

"Si le promeneur voit des phoques il gagne de la satisfaction"
(self siteWithSeal isNotEmpty) ifTrue: [ satisfaction := satisfaction +1 ].
]

{ #category : 'behavior' }
BSWalker >> lookForSpot [

	self subclassResponsibility

]

{ #category : 'moving' }
BSWalker >> moveInDirectionOf: aCell constraintOnPath: aBlock [
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

{ #category : 'behavior' }
BSWalker >> moveOnRepository [

| candidates |

candidates := self patch neighbourhood select: [ :cell | 
	cell neighbourhoodAndSelf anySatisfy: [ :each | 
		each type = 'Sea' ] ].

candidates := candidates select: [ :cell |
	cell accessRule = 'Land' ].

candidates
	ifEmpty: [ candidates := self sight select: [ :cell | cell type = 'Sea' ] ].

candidates 
	ifEmpty: [ self randomWalkConstrainedBy: [ :cell | cell accessRule = 'Land' ] ] 
	ifNotEmpty: [ self moveTo: candidates atRandom ]
]

{ #category : 'behavior' }
BSWalker >> moveToASeal [

	
]

{ #category : 'behavior' }
BSWalker >> moveToDestination [
]

{ #category : 'behavior' }
BSWalker >> moveWalking [

self subclassResponsibility.
]

{ #category : 'pov' }
BSWalker >> pov [
	<pov>
	self subclassResponsibility
]

{ #category : 'accessing' }
BSWalker >> previousCell [

	^ previousCell
]

{ #category : 'accessing' }
BSWalker >> previousCell: anObject [

	previousCell := anObject
]

{ #category : 'accessing' }
BSWalker >> satisfaction [

	^ satisfaction
]

{ #category : 'accessing' }
BSWalker >> satisfaction: anObject [

	satisfaction := anObject
]

{ #category : 'accessing' }
BSWalker >> sealAwareness [

	^ sealAwareness
]

{ #category : 'accessing' }
BSWalker >> sealAwareness: anObject [

	sealAwareness := anObject
]

{ #category : 'accessing' }
BSWalker >> sealExpectation [

	^ sealExpectation
]

{ #category : 'accessing' }
BSWalker >> sealExpectation: anObject [

	sealExpectation := anObject
]

{ #category : 'as yet unclassified' }
BSWalker >> selectFarthestLandOnWayToSeaFrom: position to: potentialDestination [

| distanceToSpot temporaryDestination finalDestination|
temporaryDestination:= OrderedCollection new.
distanceToSpot := 0.

temporaryDestination := potentialDestination select: [ :site | (position wayTo: site constraint: [ :cell | cell type = 'Land' ]) isNotEmpty].
(temporaryDestination isNotEmpty) ifTrue: [ finalDestination := potentialDestination atRandom. ^finalDestination ].

potentialDestination do: [ :cell | temporaryDestination addAll: (position wayTo: cell)].
temporaryDestination := temporaryDestination select: [ :site | (position wayTo: site constraint: [ :cell | cell type = 'Land' ]) isNotEmpty ].
temporaryDestination := temporaryDestination removeDuplicates.
temporaryDestination := temporaryDestination select: [ :cell | cell type = 'Land' ].
"(temporaryDestination isEmpty) ifTrue: [ self walkerDestination: self patch ]."
temporaryDestination do: [ :dest |  ((position distanceTo: dest) >= distanceToSpot) ifTrue: [ finalDestination := dest. distanceToSpot := position distanceTo: dest ]].
^finalDestination 
]

{ #category : 'behavior' }
BSWalker >> setDestinationToSeal [

self walkerDestination: self siteWithSeal atRandom.
]

{ #category : 'accessing' }
BSWalker >> sight [

	^ sight
]

{ #category : 'accessing' }
BSWalker >> sight: anObject [

	sight := anObject
]

{ #category : 'accessing' }
BSWalker >> siteWithSeal [

	^ siteWithSeal
]

{ #category : 'accessing' }
BSWalker >> siteWithSeal: anObject [

	^ siteWithSeal := anObject
]

{ #category : 'control' }
BSWalker >> step [
	"Test si le groupe de promenade a fini sa ballade"
	(self walkerAction = 'Out') ifTrue: [ ^ self ].
	self way ifEmpty: [ self patch = self home ifTrue: [ ^ self walkerAction: 'Out' ] ].
	((self patch = home) & (self energy = 0)) ifTrue: [ ^ self walkerAction: 'Out' ].

	"Définit ce que voit le groupe guidé"
	self defineVision.
	self lookForSeals.

	"Ensuite le promeneur entre dans la méthode propre à l'action qu'il est en train de faire"	
	self walkerAction = 'Walking' ifTrue: [ ^ self stepWalking ].

	self walkerAction = 'Starting' ifTrue: [ ^ self stepStarting ].

	self walkerAction = 'Observation' ifTrue: [ ^ self stepObservation ]
]

{ #category : 'control' }
BSWalker >> stepObservation [

	"Si le kayak a épuisé son temps d'observation il retourne sur son parcours"

	(self actionCount = 0) ifTrue: [ ^ self changeActionToWalking ].
	self actionCount: self actionCount - 1.
	
	"En fonction de sa connaissance de ce qu'il faut faire, le promeneur peut avoir deux sortes de comportements"
	(self sealAwareness = 0)
		ifTrue: [ self lookAtSealsAware ] "Regarder les phoques en restant à bonne distance"
		ifFalse: [ self lookAtSealsNotAware ]. "S'approcher du reposoir pour voir les phoques de plus près"

	
]

{ #category : 'control' }
BSWalker >> stepStarting [

"Cette méthode permet au promeneur de définir sa destination à partir de son point de départ"
self defineDestination.

self changeActionToWalking.

]

{ #category : 'control' }
BSWalker >> stepWalking [

"Cette méthode définit le comportement du promeneur guidé en train de faire sa ballade et de regarder s'il voit des phoques."
(self actionCount < 1) ifTrue: [ ^ self actionCount: 1 ].

"Il contrôle sa position"
self checkPosition.
(self walkerAction = 'Out') ifTrue: [ ^ self ].

"Il se déplace"		
(self walkerAction = 'Observation') ifTrue: [ ^ self ].
self moveWalking.

self actionCount: 0.

]

{ #category : 'accessing' }
BSWalker >> walkerAction [

	^ walkerAction
]

{ #category : 'accessing' }
BSWalker >> walkerAction: anObject [

	walkerAction := anObject
]

{ #category : 'accessing' }
BSWalker >> walkerDestination [

	^ walkerDestination
]

{ #category : 'accessing' }
BSWalker >> walkerDestination: anObject [

	walkerDestination := anObject
]

{ #category : 'accessing' }
BSWalker >> walkerPath [

	^ walkerPath
]

{ #category : 'accessing' }
BSWalker >> walkerPath: anObject [

	walkerPath := anObject
]

{ #category : 'accessing' }
BSWalker >> way [

	^ way
]

{ #category : 'accessing' }
BSWalker >> way: anObject [

	way := anObject
]

{ #category : 'accessing' }
BSWalker >> withBinoculars [

	^ withBinoculars
]

{ #category : 'accessing' }
BSWalker >> withBinoculars: anObject [

	withBinoculars := anObject
]
