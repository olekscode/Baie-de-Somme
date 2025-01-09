Class {
	#name : #BSBoatKayak,
	#superclass : #BSBoat,
	#category : #'Baie de Somme-Model'
}

{ #category : #'as yet unclassified' }
BSBoatKayak >> changeActionToNavigate [

self boatAction: 'Navigate'.
self boatDirection: self wayMemory.
self actionCount: 10.




]

{ #category : #'as yet unclassified' }
BSBoatKayak >> changeActionToObservation [

"Cette méthode fait basculer le kayak dans une autre activité: il voit des phoques sur un reposoir et décide de les observer un peu mieux"
| rand |


self boatAction: 'Observation'. "Le kayak redéfinit son action"
self wayMemory: self patch. "Le kayak se souvient d'où il en est de son parcours"
self actionCount: (Cormas random * 10 + 10) rounded. "Le kayak décide combien de temps il va rester observer"
self boatDirection: (self siteWithSeal atRandom). "Le kayak définit son objectif d'observation"
self restingPlaceMemory: (self restingPlaceMemory reject: [ :restingPlace | restingPlace = boatDirection sealRestingPlace  ]).

"Selon sa connaissance de ce qu'il faut faire ou ne pas faire, il peut décider d'aller jusqu'à monter sur le reposoir"
rand:= Cormas random.
((self sealAwareness > 1) & (rand > 0.66))
	ifTrue: [ ^ self changeActionToRepository ].
	
self stepObservation.


]

{ #category : #'as yet unclassified' }
BSBoatKayak >> changeActionToOnLand [

self boatDirection: self patch.
self boatAction: 'On Land'.
self stepOnLandBoat.
]

{ #category : #'as yet unclassified' }
BSBoatKayak >> changeActionToRepository [

self boatAction: 'Repository'.
(self actionCount = 0) ifTrue: [ self actionCount: (Cormas random * 10 + 5) rounded ].
sealAwareness := sealAwareness - 1.
self stepRepository.
]

{ #category : #behavior }
BSBoatKayak >> kayakMoveAroundRepository [

"Cette méthode définit le comportement de déplacement du kayakiste autour du reposoir qu'il a décidé d'observer de plus près"
| candidate |

(actionCount > 0) ifTrue: [ actionCount := actionCount - 1 ].
"S'il n'est pas tout proche de la plage il s'en rapproche"
(self patch neighbourhood allSatisfy: [ :cell | cell sealRestingPlace ~= self boatDirection sealRestingPlace ]) ifTrue: [ ^ self moveTowards: boatDirection ].
"Sinon il choisit d'aller vers un point qui longe la plage"
candidate := self patch neighbourhood select: [ :cell | (cell type = 'Sea') and: [ cell neighbourhood anySatisfy: [ :x | x sealRestingPlace = self boatDirection sealRestingPlace ] ] ].
(candidate isNotEmpty)
	ifTrue: [ self moveTo: candidate atRandom ].

]

{ #category : #behavior }
BSBoatKayak >> kayakMoveInWater [

	"Le déplacement du kayakiste est simple. Il suit un chemin qui l'amène à son objectif puis l'amène à rentrer s'il a atteint son objectif"

	"S'il n'est pas à l'eau il y va"

	self patch type = 'Beach' ifTrue: [ 
		^ self moveTo:
			  (self patch neighbourhoodAndSelf detect: [ :x | x type = 'Sea' ]) ].
	"S'il n'est pas sur son chemin il y retourne"
	self patch kayakWay ~= 'Way' ifTrue: [ 
		^ self
			  moveTowards: boatDirection
			  constraintOnPath: [ :cell | cell type = 'Sea' ] ].
	"S'il a atteint son objectif, il avance vers sa prochaine étape"
	(self patch = self boatDestination) ifTrue: [ 
		self boatDestination: self way first.
		self way remove: self boatDestination ].
	"Il avance vers son objectif en suivant son chemin"
	self
		moveTowards: self boatDestination
		constraintOnPath: [ :cell | cell kayakWay = 'Way' ]
]

{ #category : #behavior }
BSBoatKayak >> kayakMoveOnLand [
"Cette méthode définit le mouvement des kayakistes sur la plage"
| candidates|

actionCount := actionCount - 1.
"S'il voient des phoques sur la plage, le kayakiste se dirige vers eux"
candidates := siteWithSeal select: [ :cell | (self patch wayTo: cell constraint: [ :x | x type = 'Beach' ]) isNotEmpty ].
(candidates isNotEmpty)
	ifTrue: [ ^ self moveTowards: (candidates atRandom) constraintOnPath: [ :x | x type = 'Beach' ] ].
"Sinon il déambule le long de la plage autour de son kayak"
candidates:= self patch neighbourhood select: [ :cell | (cell type = 'Beach') & (cell neighbourhood anySatisfy: [:x|x type = 'Sea']) ].
self moveTo: candidates atRandom.
]

{ #category : #behavior }
BSBoatKayak >> kayakMoveToBeach [

self moveTowards: boatDirection.

(self actionCount > 0) ifTrue: [ actionCount := actionCount - 1 ].
]

{ #category : #'as yet unclassified' }
BSBoatKayak >> kayakPrepareToLeave [
"Si le temps qu'il a passé sur la plage arrive à son terme, il se rapproche de son kayak et se prépare à repartir"
((self patch = boatDirection) and: [ self actionCount = 0 ])
ifTrue: [ ^ self changeActionToNavigate ] "Si le temps est arrivé à son terme et qu'il a rejoint son kayak, il repart"
ifFalse: [ self moveTowards: boatDirection constraintOnPath: [ :cell | cell type = 'Beach' ] ]. "Sinon il se dirige vers son kayak"
(self actionCount > 0) ifTrue: [ actionCount := actionCount  - 1 ].


]

{ #category : #'as yet unclassified' }
BSBoatKayak >> kayakUpdateMemory [

| tempMemory |

self boatDirection ifNil: [ ^ self].

tempMemory := self wayMemory select: [ :cell | cell sealRestingPlace ~= self boatDirection ].

self wayMemory: tempMemory.
]

{ #category : #behavior }
BSBoatKayak >> lookAtSealsFromSea [ 

"Le kayak sensibilisé navigue autour des phoques qu'il observe sans les déranger"
| candidatePatch |
candidatePatch := OrderedCollection new.
"Il choisit de se déplacer sur les patch qui respectent une distance de sécurité avec les phoques"
(self siteWithSeal) 
ifNotEmpty: [ self siteWithSeal  do: [ :cell | self patch neighbourhoodAndSelf do: [ :cell2 | ((cell distanceTo: cell2) > 1) ifTrue: [ candidatePatch add: cell2 ] ] ]]
ifEmpty: [ self patch neighbourhoodAndSelf do: [ :cell | ((cell distanceTo: self boatDirection) > 1) ifTrue: [ candidatePatch add: cell ] ]].
candidatePatch := (candidatePatch select: [ :cell | cell type = 'Sea' ]).
self moveTo: candidatePatch atRandom.
"Cela diminue le temps passé à observer"
(actionCount > 0) ifTrue: [ actionCount := actionCount - 1 ].
]

{ #category : #pov }
BSBoatKayak >> pov [

	self boatAction = 'Out' ifTrue: [ ^ Color blue ].

	^ Color pink
]

{ #category : #stepping }
BSBoatKayak >> step [

	self patch = home & (self energy = 0) ifTrue: [ ^ self boatAction: 'Out' ].
	"Au début de chaque tour on définit ce que voit le bateau"
	self defineVision.
	self lookForSeals.

	"Ensuite le kayak entre dans la méthode propre à l'action qu'il est en train de faire"
	self boatAction = 'Navigate' ifTrue: [ self stepNavigation ].

	self boatAction = 'Repository' ifTrue: [ self stepRepository ].

	self boatAction = 'Observation' ifTrue: [ self stepObservation ].

	self boatAction = 'On Land' ifTrue: [ self stepOnLandBoat ].

	"A la fin du tour son énergie diminue"
	self energy > 0 ifTrue: [ energy := energy - 1 ]
]

{ #category : #stepping }
BSBoatKayak >> stepNavigation [

"Cette méthode définit le comportement du kayak en train de faire sa ballade et de regarder s'il voit des phoques."
"S'il voit des phoques sur un reposoir et que ce n'est pas l'heure de rentrer il peut décider d'aller passer plus de temps à les voir."
(self energy = 0) ifTrue: [ ^ self kayakMoveInWater ].

((self siteWithSeal isNotEmpty) & (self actionCount = 0))
	ifTrue: [ ^ self changeActionToObservation ].

"S'il ne voit pas de phoque il continue sa route"
self kayakMoveInWater.
(self actionCount > 0) ifTrue: [ actionCount := actionCount - 1 ].
]

{ #category : #stepping }
BSBoatKayak >> stepObservation [

"Si le kayak a épuisé son temps d'observation il retourne sur son parcours"
(self actionCount = 0) ifTrue: [ ^ self changeActionToNavigate ].

"En fonction de sa connaissance de ce qu'il faut faire, le kayak peut avoir deux sortes de comportements"
(self sealAwareness = 0)
ifTrue: [ self lookAtSealsFromSea ] "Regarder les phoques depuis la mer en restant à bonne distance"
ifFalse: [ self kayakMoveAroundRepository ]. "S'approcher du reposoir pour voir les phoques de plus près"
]

{ #category : #stepping }
BSBoatKayak >> stepOnLandBoat [ 
"Durant cette phase, le kayakiste regarde les phoques dans l'eau autour de lui"
(self patch neighbourhood anySatisfy: [ :cell | cell hasOccupantsOfClass: BSSeal ])
	ifTrue: [ satisfaction := satisfaction + 1 ].

"Suivant le temps qu'il a passé sur la plage il se prépare à repartir ou se ballade à la recherche de phoques"
(self actionCount < 5)
ifTrue: [ self kayakPrepareToLeave ]
ifFalse: [ self kayakMoveOnLand ].


]

{ #category : #stepping }
BSBoatKayak >> stepRepository [

"On est dans le cas où le kayak décide de s'approcher et d'aller acoster sur le reposoir pour mieux voir les phoques"

(self patch type = 'Beach')
	ifTrue: [ self changeActionToOnLand ] "S'il est sur la plage, il va marcher sur la plage et change d'action"
	ifFalse: [ self kayakMoveToBeach ] "S'il est sur l'eau, il s'approche"
]

{ #category : #stepping }
BSBoatKayak >> stepStart [ 

self actionCount: 0.
self changeActionToNavigate.

]
