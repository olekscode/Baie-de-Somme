"BSHabitatCell represents a cell in the Baie de Somme simulation environment.
This class defines the characteristics and behaviors of different types of habitat cells, including:
- Land and sea areas
- Access rules for different types of boats and walkers
- Seal resting places
- Navigation paths for kayaks and motorized boats
- Environmental impact tracking (stomping)
- Threat level assessment for seals"

Class {
	#name : #BSHabitatCell,
	#superclass : #CMSpatialEntityElement,
	#instVars : [
		'type',			"Type of habitat (Land, Sea, Beach, etc.)"
		'stomping',		"Environmental impact from walkers"
		'accessRule',	"Access rules for different agents"
		'kayakWay',		"Navigation path for kayaks"
		'boatWay',		"Navigation path for motorized boats"
		'sealRestingPlace',	"Designated resting place for seals"
		'threatLevel',	"Current threat level for seals"
		'numberOfWalker',	"Number of walkers in the cell"
		'way'			"General navigation path"
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSHabitatCell >> accessRule [
	"Return the access rule for this cell"
	^ accessRule
]

{ #category : #accessing }
BSHabitatCell >> accessRule: anObject [
	"Set the access rule for this cell"
	accessRule := anObject
]

{ #category : #accessing }
BSHabitatCell >> boatWay [
	"Return the boat navigation path designation"
	^ boatWay
]

{ #category : #accessing }
BSHabitatCell >> boatWay: anObject [
	"Set the boat navigation path designation"
	boatWay := anObject
]

{ #category : #'as yet unclassified' }
BSHabitatCell >> defineNumberOfWalker [
	"Count the number of walkers in this cell and its occupants"
	(self hasOccupantsOfClass: BSWalker) 
		ifTrue: [self theOccupants do: [ :each | each do: [ :each2 | numberOfWalker:= numberOfWalker + each2 groupSize ]]]
		ifFalse: [ numberOfWalker:= 0 ]
]

{ #category : #'as yet unclassified' }
BSHabitatCell >> defineThreatLevelLand [
	"Calculate the threat level for seals based on:
	- Number of walkers in the cell
	- Presence of unleashed dogs in neighboring cells
	The threat level ranges from 0 to 4, where:
	- 0: No walkers
	- 2: 1-4 walkers
	- 3: 5-20 walkers
	- 4: More than 20 walkers
	Additional +1 if there are unleashed dogs nearby"
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
	"Initialize a new habitat cell with default values:
	- Set threat level to 0
	- Set number of walkers to 0
	- Set stomping impact to 0"
	super initialize.

	self threatLevel: 0.
	self numberOfWalker: 0.
	self stomping: 0.
]

{ #category : #initialization }
BSHabitatCell >> initializeWithRandomHabitat [
	"Initialize the cell with a random habitat type:
	- 50% chance of being Land
	- 50% chance of being Sea"
	(Cormas random * 100 < 50) ifTrue: [ self type: 'Land' ] ifFalse: [ self type: 'Sea' ].
]

{ #category : #accessing }
BSHabitatCell >> kayakWay [
	"Return the kayak navigation path designation"
	^ kayakWay
]

{ #category : #accessing }
BSHabitatCell >> kayakWay: anObject [
	"Set the kayak navigation path designation"
	kayakWay := anObject
]

{ #category : #accessing }
BSHabitatCell >> numberOfWalker [
	"Return the number of walkers in this cell"
	^ numberOfWalker
]

{ #category : #accessing }
BSHabitatCell >> numberOfWalker: anObject [
	"Set the number of walkers in this cell"
	numberOfWalker := anObject
]

{ #category : #pov }
BSHabitatCell >> povAccessRule [
	"Return the color representation of the access rule:
	- Blue for Sea
	- Yellow for Land"
	self accessRule  = 'Sea' ifTrue: [ ^ Color blue ].
	self accessRule  = 'Land' ifTrue: [ ^ Color yellow ].
]

{ #category : #pov }
BSHabitatCell >> povBoatWay [
	"Return the color representation of the boat way:
	- Red for Way
	- Black for Not
	- Blue for Sea
	- Yellow for Land
	- Pink for Stop points (1-6)"
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
	"Return the color representation of the habitat type:
	- Black for Home and City
	- Brown for Land
	- Blue for Sea
	- Green for Schorre
	- Orange for Sand
	- Yellow for Beach"
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
	"Return the color representation of the kayak way:
	- Red for Way
	- Black for Not
	- Blue for Sea
	- Yellow for Land"
	self kayakWay  = 'Way' ifTrue: [ ^ Color red   ].
	self kayakWay  = 'Not' ifTrue: [ ^ Color black  ].
	self kayakWay  = 'Sea' ifTrue: [ ^ Color blue  ].
	self kayakWay  = 'Land' ifTrue: [ ^ Color yellow  ].
]

{ #category : #pov }
BSHabitatCell >> povRestingPlace [
	"Return the color representation of the seal resting place:
	- Different colors for different resting areas (R1-R8, BH, FM, etc.)
	- Black for non-resting areas"
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
	"Return the color representation of the general navigation ways:
	- Blue for Sea
	- Yellow for Land
	- Red for Maye, Crotoy, and Hourdel
	- Cyan for Hourdel Promenade and Molliere"
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
	"Return the seal resting place designation"
	^ sealRestingPlace
]

{ #category : #accessing }
BSHabitatCell >> sealRestingPlace: anObject [
	"Set the seal resting place designation"
	sealRestingPlace := anObject
]

{ #category : #stepping }
BSHabitatCell >> step [
	"Execute one step of the habitat cell's behavior:
	- If the cell is on land, update the threat level"
	(self type = 'Land')
	ifTrue: [self defineThreatLevelLand].
]

{ #category : #accessing }
BSHabitatCell >> stomping [
	"Return the stomping impact value"
	^ stomping
]

{ #category : #accessing }
BSHabitatCell >> stomping: anObject [
	"Set the stomping impact value"
	stomping := anObject
]

{ #category : #accessing }
BSHabitatCell >> threatLevel [
	"Return the current threat level"
	^ threatLevel
]

{ #category : #accessing }
BSHabitatCell >> threatLevel: anObject [
	"Set the threat level"
	threatLevel := anObject
]

{ #category : #accessing }
BSHabitatCell >> type [
	"Return the habitat type"
	^ type
]

{ #category : #accessing }
BSHabitatCell >> type: anObject [
	"Set the habitat type"
	type := anObject
]

{ #category : #accessing }
BSHabitatCell >> way [
	"Return the general navigation path designation"
	^ way
]

{ #category : #accessing }
BSHabitatCell >> way: anObject [
	"Set the general navigation path designation"
	way := anObject
]
