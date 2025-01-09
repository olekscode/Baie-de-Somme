Class {
	#name : #BSHabitatCell,
	#superclass : #CMSpatialEntityElement,
	#instVars : [
		'type',
		'stomping',
		'accessRule',
		'kayakWay',
		'boatWay',
		'sealRestingPlace',
		'threatLevel',
		'numberOfWalker',
		'way'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSHabitatCell >> accessRule [

	^ accessRule
]

{ #category : #accessing }
BSHabitatCell >> accessRule: anObject [

	accessRule := anObject
]

{ #category : #accessing }
BSHabitatCell >> boatWay [

	^ boatWay
]

{ #category : #accessing }
BSHabitatCell >> boatWay: anObject [

	boatWay := anObject
]

{ #category : #'as yet unclassified' }
BSHabitatCell >> defineNumberOfWalker [

(self hasOccupantsOfClass: BSWalker) 
	ifTrue: [self theOccupants do: [ :each | each do: [ :each2 | numberOfWalker:= numberOfWalker + each2 groupSize ]]]
	ifFalse: [ numberOfWalker:= 0 ]
]

{ #category : #'as yet unclassified' }
BSHabitatCell >> defineThreatLevelLand [

| arg1 arg2 selec |

self defineNumberOfWalker.

selec := OrderedCollection new.
arg1:=0.
(self numberOfWalker > 0)
	ifTrue: [ (numberOfWalker < 5) 
		ifTrue: [ arg1:= 2 ]
		ifFalse: [ (numberOfWalker > 20) ifTrue: [ arg1:= 4 ] ifFalse: [arg1:= 3]]. ]
	ifFalse: [ arg1:= 0 ].

arg2:=0.
self neighbourhood do: [ :cell | cell theOccupants 
	do: [ :collecOfOccup | collecOfOccup 
		do: [ :eachOccupant | (eachOccupant className = BSWalkerGuide) 
			ifTrue: [ (eachOccupant withDog = 'unleashed') 
				ifTrue: [arg2:=1]
			]
		]
	]
].

self threatLevel: (arg1 + arg2).
]

{ #category : #initialization }
BSHabitatCell >> initialize [

	super initialize.

	self threatLevel: 0.
	self numberOfWalker: 0.
	self stomping: 0.
]

{ #category : #initialization }
BSHabitatCell >> initializeWithRandomHabitat [

	(Cormas random * 100 < 50) ifTrue: [ self type: 'Land' ] ifFalse: [ self type: 'Sea' ].
	

]

{ #category : #accessing }
BSHabitatCell >> kayakWay [

	^ kayakWay
]

{ #category : #accessing }
BSHabitatCell >> kayakWay: anObject [

	kayakWay := anObject
]

{ #category : #accessing }
BSHabitatCell >> numberOfWalker [

	^ numberOfWalker
]

{ #category : #accessing }
BSHabitatCell >> numberOfWalker: anObject [

	numberOfWalker := anObject
]

{ #category : #pov }
BSHabitatCell >> povAccessRule [

		self accessRule  = 'Sea' ifTrue: [ ^ Color blue ].
		self accessRule  = 'Land' ifTrue: [ ^ Color yellow ].
]

{ #category : #pov }
BSHabitatCell >> povBoatWay [

	self boatWay  = 'Way' ifTrue: [ ^ Color red   ].
	self boatWay  = 'Not' ifTrue: [ ^ Color black  ].
	self boatWay  = 'Sea' ifTrue: [ ^ Color blue  ].
	self boatWay  = 'Land' ifTrue: [ ^ Color yellow  ].
	self boatWay  = 'Stop 1' ifTrue: [ ^ Color pink  ].
	self boatWay  = 'Stop 2' ifTrue: [ ^ Color pink  ].
	self boatWay  = 'Stop 3' ifTrue: [ ^ Color pink  ].
	self boatWay  = 'Stop 4' ifTrue: [ ^ Color pink  ].
	self boatWay  = 'Stop 5' ifTrue: [ ^ Color pink  ].
	self boatWay  = 'Stop 6' ifTrue: [ ^ Color pink  ].
]

{ #category : #pov }
BSHabitatCell >> povHabitatType [

	self type = 'Home' ifTrue: [ ^ Color black  ].
	
	self type = 'Land' ifTrue: [ ^ Color brown ].
	
	self type = 'Sea' ifTrue: [ ^ Color blue ].
	
	self type = 'Home Sea' ifTrue: [ ^ Color black ].
	
	self type = 'Schorre' ifTrue: [ ^ Color green ].
	
	self type = 'Sand' ifTrue: [ ^ Color orange ].
	
	self type = 'Beach' ifTrue: [ ^ Color yellow ].
	
	self type = 'City' ifTrue: [ ^ Color black ].
		 
]

{ #category : #pov }
BSHabitatCell >> povKayakWay [

	self kayakWay  = 'Way' ifTrue: [ ^ Color red   ].
	self kayakWay  = 'Not' ifTrue: [ ^ Color black  ].
	self kayakWay  = 'Sea' ifTrue: [ ^ Color blue  ].
	self kayakWay  = 'Land' ifTrue: [ ^ Color yellow  ].
]

{ #category : #pov }
BSHabitatCell >> povRestingPlace [

	self sealRestingPlace  = 'R1' ifTrue: [ ^ Color green ].
	self sealRestingPlace  = 'BH' ifTrue: [ ^ Color yellow ].
	self sealRestingPlace  = 'R2' ifTrue: [ ^ Color orange ].
	self sealRestingPlace  = 'R3 Nord' ifTrue: [ ^ Color green ].
	self sealRestingPlace  = 'R3 Sud' ifTrue: [ ^ Color green ].
	self sealRestingPlace  = 'R3' ifTrue: [ ^ Color green ].
	self sealRestingPlace  = 'R4' ifTrue: [ ^ Color blue ].
	self sealRestingPlace  = 'R5 Nord' ifTrue: [ ^ Color red ].
	self sealRestingPlace  = 'R5 Centre' ifTrue: [ ^ Color red ].
	self sealRestingPlace  = 'R5 Pointe' ifTrue: [ ^ Color red ].
	self sealRestingPlace  = 'R5 Mollière' ifTrue: [ ^ Color red ].
	self sealRestingPlace  = 'R5' ifTrue: [ ^ Color red ].
	self sealRestingPlace  = 'R6' ifTrue: [ ^ Color pink ].
	self sealRestingPlace  = 'R7 Virage' ifTrue: [ ^ Color purple ].
	self sealRestingPlace  = 'R7 Apres Passe' ifTrue: [ ^ Color purple ].
	self sealRestingPlace  = 'R7 Reste' ifTrue: [ ^ Color purple ].
	self sealRestingPlace  = 'R7' ifTrue: [ ^ Color purple ].
	self sealRestingPlace  = 'R8' ifTrue: [ ^ Color magenta ].
	self sealRestingPlace  = 'FM' ifTrue: [ ^ Color cyan ].
	self sealRestingPlace  = 'Observatory' ifTrue: [ ^ Color yellow ].
	self sealRestingPlace  = 'Not' ifTrue: [ ^ Color black ].
	self sealRestingPlace  = 'Empty' ifTrue: [ ^ Color black ].
	self sealRestingPlace  = 'Land' ifTrue: [ ^ Color brown ].
	self sealRestingPlace  = 'Sea' ifTrue: [ ^ Color black ].
	self sealRestingPlace = 'Home' ifTrue: [ ^ Color black ].
]

{ #category : #pov }
BSHabitatCell >> povWays [

		self way  = 'Sea' ifTrue: [ ^ Color blue ].
		self way  = 'Land' ifTrue: [ ^ Color yellow ].
		self way  = 'Maye' ifTrue: [ ^ Color red ].
		self way  = 'Crotoy' ifTrue: [ ^ Color red ].
		self way  = 'Hourdel' ifTrue: [ ^ Color red ].
		self way  = 'Hourdel Promenade' ifTrue: [ ^ Color cyan ].
		self way  = 'Molliere' ifTrue: [ ^ Color cyan ].
]

{ #category : #accessing }
BSHabitatCell >> sealRestingPlace [

	^ sealRestingPlace
]

{ #category : #accessing }
BSHabitatCell >> sealRestingPlace: anObject [

	sealRestingPlace := anObject
]

{ #category : #stepping }
BSHabitatCell >> step [

(self type = 'Land')
ifTrue: [self defineThreatLevelLand].
]

{ #category : #accessing }
BSHabitatCell >> stomping [

	^ stomping
]

{ #category : #accessing }
BSHabitatCell >> stomping: anObject [

	stomping := anObject
]

{ #category : #accessing }
BSHabitatCell >> threatLevel [

	^ threatLevel
]

{ #category : #accessing }
BSHabitatCell >> threatLevel: anObject [

	threatLevel := anObject
]

{ #category : #accessing }
BSHabitatCell >> type [

	^ type
]

{ #category : #accessing }
BSHabitatCell >> type: anObject [

	type := anObject
]

{ #category : #accessing }
BSHabitatCell >> way [

	^ way
]

{ #category : #accessing }
BSHabitatCell >> way: anObject [

	way := anObject
]
