Class {
	#name : #BSModel,
	#superclass : #CMAbstractModel,
	#instVars : [
		'theHabitatTypes',
		'thePromeneurGuides',
		'thePromeneurSeuls',
		'theSeals',
		'numberOfRows',
		'numberOfColumns',
		'home',
		'restingPlaces'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #'- probes' }
BSModel class >> colorOfProbe_numberOfPromeneurGuides [
  ^ (Color r: 1.0 g: 0.20234604105571846 b: 0.0 alpha: 1.0)
]

{ #category : #'simulation settings' }
BSModel class >> defaultInit [

	^ #simpleEnvironment
]

{ #category : #accessing }
BSModel class >> initialNumberOfPromeneurGuides [

	^10
]

{ #category : #accessing }
BSModel class >> initialNumberOfPromeneurSeuls [

	^2
]

{ #category : #'as yet unclassified' }
BSModel >> accessRuleMatrix [

	| matrix |
	
	matrix := #(
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 1 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 1 1 0 0)
		(0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0)
		(0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0)
		(0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)).
		
	(matrix size = numberOfRows and: [ matrix allSatisfy: [ :row | row size = numberOfColumns ] ])
		ifFalse: [ self error: 'Matrix has the wrong dimensions' ].
		
	^ matrix
]

{ #category : #'as yet unclassified' }
BSModel >> habitatTypeMatrix [

	| matrix |
	
	matrix := #(
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 1 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 1 1 0 0)
		(0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0)
		(0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0)
		(0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)).
		
	(matrix size = numberOfRows and: [ matrix allSatisfy: [ :row | row size = numberOfColumns ] ])
		ifFalse: [ self error: 'Matrix has the wrong dimensions' ].
		
	^ matrix
]

{ #category : #accessing }
BSModel >> home [

	^ home
]

{ #category : #accessing }
BSModel >> home: anObject [

	home := anObject
]

{ #category : #initialization }
BSModel >> initialize [ 

	super initialize.
	
	numberOfRows := 30.
	numberOfColumns:= 30.
	
	thePromeneurGuides := OrderedCollection new.
	thePromeneurSeuls := OrderedCollection new.
	theSeals := OrderedCollection new.
	theHabitatTypes := OrderedCollection new.
]

{ #category : #initialization }
BSModel >> initializeAccessRuleFromMatrix [

	| matrixCellValue modelCell |
	1 to: numberOfRows do: [ :i | 
		1 to: numberOfColumns do: [ :j | 
			matrixCellValue := (self accessRuleMatrix at: i) at: j.
			modelCell := self pickCellAt: j @ i.
			matrixCellValue = 0 ifTrue: [ modelCell accessRule:  'Forbidden' ].
			matrixCellValue = 1 ifTrue: [ modelCell accessRule:  'Accessible' ].
			] ]
]

{ #category : #'init entities' }
BSModel >> initializeAgents [ 

	self
		createN: "self class initialNumberOfPromeneurGuides" 5
		entity: BSWalkerGuide.
		self thePromeneurGuides do: [ :guide | self initializeWalkerGuide: guide ].
		
	self
		createN: "self class initialNumberOfPromeneurSeuls" 7
		entity: BSWalkerAlone.
		self thePromeneurSeuls do: [ :alone | self initializeWalkerAlone: alone ].
		
	self createN: 50 randomlyLocatedEntities: BSSeal constrainedBy: [:c | c type = 'Sea' ].
]

{ #category : #initialization }
BSModel >> initializeHabitatTypeFromMatrix [

	| matrixCellValue modelCell |
	1 to: numberOfRows do: [ :i | 
		1 to: numberOfColumns do: [ :j | 
			matrixCellValue := (self habitatTypeMatrix at: i) at: j.
			modelCell := self pickCellAt: j @ i.
			matrixCellValue = 0 ifTrue: [ modelCell type: 'Sea' ].
			matrixCellValue = 1 ifTrue: [ modelCell type: 'Land' ].
			matrixCellValue = 2 ifTrue: [ modelCell type: 'Home' ].
			] ]
]

{ #category : #initialization }
BSModel >> initializeSealRestingPlacesFromMatrix [

	| matrixCellValue modelCell |
	1 to: numberOfRows do: [ :i | 
		1 to: numberOfColumns do: [ :j | 
			matrixCellValue := (self sealRestingPlaceMatrix at: i) at: j.
			modelCell := self pickCellAt: j @ i.
			matrixCellValue = 0 ifTrue: [ modelCell sealRestingPlace:  'Not' ].
			matrixCellValue = 1 ifTrue: [ modelCell sealRestingPlace:  'R1' ].
			matrixCellValue = 2 ifTrue: [ modelCell sealRestingPlace:  'R2' ].
			matrixCellValue = 3 ifTrue: [ modelCell sealRestingPlace:  'R3' ].
			matrixCellValue = 4 ifTrue: [ modelCell sealRestingPlace:  'O1' ].
			matrixCellValue = 5 ifTrue: [ modelCell sealRestingPlace:  'O2' ].
			matrixCellValue = 6 ifTrue: [ modelCell sealRestingPlace:  'O3' ].
			] ]
]

{ #category : #'init entities' }
BSModel >> initializeWalkerAlone: walker [

|potentialDestination arg|

	walker home: self home.
	
	potentialDestination := theHabitatTypes select: [ :cell | cell type = 'Sea' ].
	
	walker walkerDestination:  potentialDestination atRandom.
	
	arg:= Cormas random.
	(arg < 0.05) 
		ifTrue: [ walker withDog: 'leashed'] 
		ifFalse: [ (arg < 0.35) 
				ifTrue: [ walker withDog: 'unleashed' ]
				ifFalse: [ walker withDog: 'no' ] 
				].
			
	arg:= Cormas random.
	(arg < 0.2) 
		ifTrue: [ walker withBinoculars: 'yes'] 
		ifFalse: [ walker withBinoculars: 'no'].
		
	arg:= Cormas random.
	(arg < 0.2) 
		ifTrue: [ walker sealAwareness: 'yes'] 
		ifFalse: [ walker sealAwareness: 'no'].
]

{ #category : #'init entities' }
BSModel >> initializeWalkerGuide: guide [

|arg|

	guide home: self home.
	
	arg:= Cormas random.
	
	(arg < 0.33) ifTrue: [ ^ guide walkerDestination: (theHabitatTypes select: [ :cell | cell sealRestingPlace = 'O1' ]) first ].
	(arg > 0.66) ifTrue: [ ^ guide walkerDestination: (theHabitatTypes select: [ :cell | cell sealRestingPlace = 'O2' ]) first ].
	guide walkerDestination: (theHabitatTypes select: [ :cell | cell sealRestingPlace = 'O3' ]) first.

	arg:= Cormas random.
	(arg < 0.5) 
		ifTrue: [ guide sealAwareness: 'yes'] 
		ifFalse: [ guide sealAwareness: 'no'].

]

{ #category : #probes }
BSModel >> numberOfPromeneurGuides [

	<probe>
	^ self thePromeneurGuides size
]

{ #category : #accessing }
BSModel >> restingPlaces [

	^ restingPlaces
]

{ #category : #accessing }
BSModel >> restingPlaces: anObject [

	restingPlaces := anObject
]

{ #category : #'as yet unclassified' }
BSModel >> sealRestingPlaceMatrix [

	| matrix |
	
	matrix := #(
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 6 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 5 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 3 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 3 3 0 0)
		(0 0 0 0 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 0 0)
		(0 0 0 0 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 0 0)
		(0 0 0 0 0 0 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)).
		
	(matrix size = numberOfRows and: [ matrix allSatisfy: [ :row | row size = numberOfColumns ] ])
		ifFalse: [ self error: 'Matrix has the wrong dimensions' ].
		
	^ matrix
]

{ #category : #init }
BSModel >> simpleEnvironment [

	self
		createGridLines: numberOfRows
		columns: numberOfColumns
		neighbourhood: 8
		closed: true.

	"self theHabitatTypes do: [ :each | each initializeWithRandomHabitat ]."
	"(self theHabitatTypes at: 1) type: 'Home'."
	self initializeHabitatTypeFromMatrix.
	self initializeAccessRuleFromMatrix.
	self initializeSealRestingPlacesFromMatrix.
	self home: (theHabitatTypes detect: [ :cell | cell type = 'Home' ]).
	self restingPlaces: #('R1' 'R2' 'R3').

	self initializeAgents.
	self thePromeneurGuides do: [ :guide | guide moveTo: home ].
	self thePromeneurSeuls do: [ :guide | guide moveTo: home ].
	self theSeals do: [ :seal | (Cormas random < 0.5) ifTrue: [ seal randomJumpConstrainedBy: [ :cell | cell sealRestingPlace = seal restingPlace ] ] ].
	
	self
		displayPov: #povHabitatType of: BSHabitatCell;
		displayPov: #defaultPOV of:  BSWalker;
		displayPov: #defaultPOV of: BSSeal.
]

{ #category : #control }
BSModel >> step: anObject [

	self askRandom: BSWalker toDo: #step.
	self askRandom: BSHabitatCell toDo: #step.
	self askRandom: BSSeal toDo: #step.
]

{ #category : #accessing }
BSModel >> theHabitatTypes [
	<getterFor: #BSHabitatCell>

	^ theHabitatTypes
]

{ #category : #accessing }
BSModel >> theHabitatTypes: anObject [

	theHabitatTypes := anObject
]

{ #category : #accessing }
BSModel >> thePromeneurGuides [
	<getterFor: #BSWalkerGuide>	

	^ thePromeneurGuides
]

{ #category : #accessing }
BSModel >> thePromeneurGuides: anObject [

	thePromeneurGuides := anObject
]

{ #category : #accessing }
BSModel >> thePromeneurSeuls [
	<getterFor: #BSWalkerAlone>

	^ thePromeneurSeuls
]

{ #category : #accessing }
BSModel >> thePromeneurSeuls: anObject [

	thePromeneurSeuls := anObject
]

{ #category : #accessing }
BSModel >> theSeals [
<getterFor: #BSSeal >
	^ theSeals
]

{ #category : #accessing }
BSModel >> theSeals: anObject [

	theSeals := anObject
]

{ #category : #probes }
BSModel >> totalSatisfaction [

	<probe>
	^ (self thePromeneurGuides sum: [ :each | each satisfaction ]) + (self thePromeneurSeuls sum: [ :each | each satisfaction ])
]
