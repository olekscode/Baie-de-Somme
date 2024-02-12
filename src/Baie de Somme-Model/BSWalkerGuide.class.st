Class {
	#name : #BSWalkerGuide,
	#superclass : #BSWalker,
	#instVars : [
		'observatoryMemory'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSWalkerGuide class >> entityName [

	^ 'PromeneurGuide'
]

{ #category : #'as yet unclassified' }
BSWalkerGuide >> defineVision [

|scope1 scope2|
	scope1 := OrderedCollection new.
	scope2 := OrderedCollection new.
	scope1 := patch neighbourhoodAndSelf.
	scope2 := scope1.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope1 := scope2.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	scope1 := scope2.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	self sight: scope2.
]

{ #category : #initialization }
BSWalkerGuide >> initialize [ 

| arg |

	super initialize.
	arg := Cormas random.

	(arg < 0.33) 
		ifTrue: [ groupSize := (Cormas random * 10 + 1) rounded ] 
		ifFalse: [(arg > 0.66) 
			ifTrue: [ groupSize := (Cormas random * 10 + 21) rounded ]
			ifFalse: [groupSize := (Cormas random * 10 + 11) rounded]].

	sealExpectation := 4.
	

]

{ #category : #behavior }
BSWalkerGuide >> moveAlongBeach [
	
	|dest potentialDest|
(self patch neighbourhood size < 8) ifTrue: [ ^ self uTurn ].

potentialDest := self patch neighbourhood select: [ :cell | cell neighbourhoodAndSelf allSatisfy: [ :y | y ~= self previousCell ]].

dest := potentialDest select: [ :cell | (cell type = 'Land') & (cell neighbourhood anySatisfy: [:y | y type = 'Sea'])].
(dest isEmpty) ifTrue: [ (Cormas random < 0.5) ifTrue: [dest:= self patch neighbourE]  ifFalse: [dest:= self patch neighbourW]] ifFalse: [ dest := dest first ].
self previousCell: self patch.
self moveTo: dest.
]

{ #category : #behavior }
BSWalkerGuide >> moveToASeal [

self moveTowards: (self walkerDestination) constraintOnPath: [:cell | (cell type = 'Land') or: [ cell type = 'Home' ] ].
	


]

{ #category : #accessing }
BSWalkerGuide >> observatoryMemory [

	^ observatoryMemory
]

{ #category : #accessing }
BSWalkerGuide >> observatoryMemory: anObject [

	observatoryMemory := anObject
]

{ #category : #pov }
BSWalkerGuide >> pov [

	^ Color green  
]

{ #category : #pov }
BSWalkerGuide >> povEnergy [

	^ self
		  povAttribute: #energy
		  min: 0
		  max: 180
		  color: Color blue 
]

{ #category : #pov }
BSWalkerGuide >> povSatisfaction [	

	^ self
		  povAttribute: #satisfaction
		  min: 0
		  max: 180
		  color: Color blue 
]

{ #category : #behavior }
BSWalkerGuide >> setDestination [

(self patch sealRestingPlace = 'Observatory' and: [self patch = walkerDestination ])
	ifTrue: [ ((self observatoryMemory select: [:x|x = self patch]) isNotEmpty)
		ifTrue: [  
			self observatoryMemory remove: self walkerDestination].
		self walkerDestination: 0. 
		self lookForSeals
	].
(self walkerDestination ~= 0) ifTrue: [ ^ self ].
	
(self siteWithSeal isNotEmpty)
	ifTrue: [ self setDestinationToSeal ]
	ifFalse: [ self setDestinationToOther ]
]

{ #category : #behavior }
BSWalkerGuide >> setDestinationToOther [

	| distanceToObservatory potentialDestination|
	potentialDestination := Dictionary new.
	distanceToObservatory := OrderedCollection new.
	self halt.
	self observatoryMemory isEmpty ifTrue: [ ^ self energy: 0 ].
	self observatoryMemory do: [ :cell | potentialDestination at: (self patch distanceTo: cell constraintOnPath: [ :x | x type = 'Land']) put: cell ].
	"distanceToObservatory isEmpty ifTrue: [ ^ self moveAlongBeach ]."
	potentialDestination keysDo: [ :x | distanceToObservatory add: x].
	distanceToObservatory := distanceToObservatory asSortedCollection: [ :x :y | x < y ].
	self walkerDestination: (potentialDestination keyAtValue: (distanceToObservatory first)).
]

{ #category : #behavior }
BSWalkerGuide >> uTurn [

|dest|
dest:= self previousCell.
self previousCell: self patch;
moveTo: dest.
]
