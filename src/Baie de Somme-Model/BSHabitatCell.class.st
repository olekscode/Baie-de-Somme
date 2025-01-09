Class {
	#name : 'BSHabitatCell',
	#superclass : 'CMSpatialEntityElement',
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
	#category : 'Baie de Somme-Model',
	#package : 'Baie de Somme-Model'
}

{ #category : 'accessing' }
BSHabitatCell >> accessRule [

	^ accessRule
]

{ #category : 'accessing' }
BSHabitatCell >> accessRule: anObject [

	accessRule := anObject
]

{ #category : 'accessing' }
BSHabitatCell >> boatWay [

	^ boatWay
]

{ #category : 'accessing' }
BSHabitatCell >> boatWay: anObject [

	boatWay := anObject
]

{ #category : 'as yet unclassified' }
BSHabitatCell >> defineNumberOfWalker [

(self hasOccupantsOfClass: BSWalker) 
	ifTrue: [self theOccupants do: [ :each | each do: [ :each2 | numberOfWalker:= numberOfWalker + each2 groupSize ]]]
	ifFalse: [ numberOfWalker:= 0 ]
]

{ #category : 'as yet unclassified' }
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

{ #category : 'initialization' }
BSHabitatCell >> initialize [

	super initialize.

	self threatLevel: 0.
	self numberOfWalker: 0.
	self stomping: 0.
]

{ #category : 'accessing' }
BSHabitatCell >> kayakWay [

	^ kayakWay
]

{ #category : 'accessing' }
BSHabitatCell >> kayakWay: anObject [

	kayakWay := anObject
]

{ #category : 'accessing' }
BSHabitatCell >> numberOfWalker [

	^ numberOfWalker
]

{ #category : 'accessing' }
BSHabitatCell >> numberOfWalker: anObject [

	numberOfWalker := anObject
]

{ #category : 'pov' }
BSHabitatCell >> povAccessRule [
	<pov>
	
		self accessRule  = 'Sea' ifTrue: [ ^ CMPointOfView color: Color blue ].
		self accessRule  = 'Land' ifTrue: [ ^ CMPointOfView color: Color yellow ].
]

{ #category : 'pov' }
BSHabitatCell >> povBoatWay [
	<pov>

	self boatWay  = 'Way' ifTrue: [ ^ CMPointOfView color: Color red   ].
	self boatWay  = 'Not' ifTrue: [ ^ CMPointOfView color: Color black  ].
	self boatWay  = 'Sea' ifTrue: [ ^ CMPointOfView color: Color blue  ].
	self boatWay  = 'Land' ifTrue: [ ^ CMPointOfView color: Color yellow  ].
	self boatWay  = 'Stop 1' ifTrue: [ ^ CMPointOfView color: Color pink  ].
	self boatWay  = 'Stop 2' ifTrue: [ ^ CMPointOfView color: Color pink  ].
	self boatWay  = 'Stop 3' ifTrue: [ ^ CMPointOfView color: Color pink  ].
	self boatWay  = 'Stop 4' ifTrue: [ ^ CMPointOfView color: Color pink  ].
	self boatWay  = 'Stop 5' ifTrue: [ ^ CMPointOfView color: Color pink  ].
	self boatWay  = 'Stop 6' ifTrue: [ ^ CMPointOfView color: Color pink  ].
]

{ #category : 'pov' }
BSHabitatCell >> povHabitatType [
	<pov>
	
	self type = 'Home' ifTrue: [ ^ CMPointOfView color: Color black  ].
	
	self type = 'Land' ifTrue: [ ^ CMPointOfView color: Color brown ].
	
	self type = 'Sea' ifTrue: [ ^ CMPointOfView color: Color blue ].
	
	self type = 'Home Sea' ifTrue: [ ^ CMPointOfView color: Color black ].
	
	self type = 'Schorre' ifTrue: [ ^ CMPointOfView color: Color green ].
	
	self type = 'Sand' ifTrue: [ ^ CMPointOfView color: Color orange ].
	
	self type = 'Beach' ifTrue: [ ^ CMPointOfView color: Color yellow ].
	
	self type = 'City' ifTrue: [ ^ CMPointOfView color: Color black ].
	
	
		 
]

{ #category : 'pov' }
BSHabitatCell >> povKayakWay [
	<pov>

	self kayakWay  = 'Way' ifTrue: [ ^ CMPointOfView color: Color red   ].
	self kayakWay  = 'Not' ifTrue: [ ^ CMPointOfView color: Color black  ].
	self kayakWay  = 'Sea' ifTrue: [ ^ CMPointOfView color: Color blue  ].
	self kayakWay  = 'Land' ifTrue: [ ^ CMPointOfView color: Color yellow  ].
]

{ #category : 'pov' }
BSHabitatCell >> povRestingPlace [
	<pov>

	self sealRestingPlace  = 'R1' ifTrue: [ ^ CMPointOfView color: Color green ].
	self sealRestingPlace  = 'BH' ifTrue: [ ^ CMPointOfView color: Color yellow ].
	self sealRestingPlace  = 'R2' ifTrue: [ ^ CMPointOfView color: Color orange ].
	self sealRestingPlace  = 'R3 Nord' ifTrue: [ ^ CMPointOfView color: Color green ].
	self sealRestingPlace  = 'R3 Sud' ifTrue: [ ^ CMPointOfView color: Color green ].
	self sealRestingPlace  = 'R3' ifTrue: [ ^ CMPointOfView color: Color green ].
	self sealRestingPlace  = 'R4' ifTrue: [ ^ CMPointOfView color: Color blue ].
	self sealRestingPlace  = 'R5 Nord' ifTrue: [ ^ CMPointOfView color: Color red ].
	self sealRestingPlace  = 'R5 Centre' ifTrue: [ ^ CMPointOfView color: Color red ].
	self sealRestingPlace  = 'R5 Pointe' ifTrue: [ ^ CMPointOfView color: Color red ].
	self sealRestingPlace  = 'R5 Mollière' ifTrue: [ ^ CMPointOfView color: Color red ].
	self sealRestingPlace  = 'R5' ifTrue: [ ^ CMPointOfView color: Color red ].
	self sealRestingPlace  = 'R6' ifTrue: [ ^ CMPointOfView color: Color pink ].
	self sealRestingPlace  = 'R7 Virage' ifTrue: [ ^ CMPointOfView color: Color purple ].
	self sealRestingPlace  = 'R7 Apres Passe' ifTrue: [ ^ CMPointOfView color: Color purple ].
	self sealRestingPlace  = 'R7 Reste' ifTrue: [ ^ CMPointOfView color: Color purple ].
	self sealRestingPlace  = 'R7' ifTrue: [ ^ CMPointOfView color: Color purple ].
	self sealRestingPlace  = 'R8' ifTrue: [ ^ CMPointOfView color: Color magenta ].
	self sealRestingPlace  = 'FM' ifTrue: [ ^ CMPointOfView color: Color cyan ].
	self sealRestingPlace  = 'Observatory' ifTrue: [ ^ CMPointOfView color: Color yellow ].
	self sealRestingPlace  = 'Not' ifTrue: [ ^ CMPointOfView color: Color black ].
	self sealRestingPlace  = 'Empty' ifTrue: [ ^ CMPointOfView color: Color black ].
	self sealRestingPlace  = 'Land' ifTrue: [ ^ CMPointOfView color: Color brown ].
	self sealRestingPlace  = 'Sea' ifTrue: [ ^ CMPointOfView color: Color black ].
	self sealRestingPlace = 'Home' ifTrue: [ ^ CMPointOfView color: Color black ].
]

{ #category : 'pov' }
BSHabitatCell >> povWays [
	<pov>

		self way  = 'Sea' ifTrue: [ ^ CMPointOfView color: Color blue ].
		self way  = 'Land' ifTrue: [ ^ CMPointOfView color: Color yellow ].
		self way  = 'Maye' ifTrue: [ ^ CMPointOfView color: Color red ].
		self way  = 'Crotoy' ifTrue: [ ^ CMPointOfView color: Color red ].
		self way  = 'Hourdel' ifTrue: [ ^ CMPointOfView color: Color red ].
		self way  = 'Hourdel Promenade' ifTrue: [ ^ CMPointOfView color: Color cyan ].
		self way  = 'Molliere' ifTrue: [ ^ CMPointOfView color: Color cyan ].
]

{ #category : 'accessing' }
BSHabitatCell >> sealRestingPlace [

	^ sealRestingPlace
]

{ #category : 'accessing' }
BSHabitatCell >> sealRestingPlace: anObject [

	sealRestingPlace := anObject
]

{ #category : 'stepping' }
BSHabitatCell >> step [

(self type = 'Land')
ifTrue: [self defineThreatLevelLand].
]

{ #category : 'accessing' }
BSHabitatCell >> stomping [

	^ stomping
]

{ #category : 'accessing' }
BSHabitatCell >> stomping: anObject [

	stomping := anObject
]

{ #category : 'accessing' }
BSHabitatCell >> threatLevel [

	^ threatLevel
]

{ #category : 'accessing' }
BSHabitatCell >> threatLevel: anObject [

	threatLevel := anObject
]

{ #category : 'accessing' }
BSHabitatCell >> type [

	^ type
]

{ #category : 'accessing' }
BSHabitatCell >> type: anObject [

	type := anObject
]

{ #category : 'accessing' }
BSHabitatCell >> way [

	^ way
]

{ #category : 'accessing' }
BSHabitatCell >> way: anObject [

	way := anObject
]
