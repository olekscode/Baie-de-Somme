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

{ #category : #behavior }
BSWalkerGuide >> checkPosition [

(self patch sealRestingPlace = 'Observatory')
	ifTrue: [ ((self observatoryMemory select: [:x|x = self patch]) isNotEmpty)
		ifTrue: [  
			self observatoryMemory remove: self patch].
	].
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
BSWalkerGuide >> lookForSpot [

| distanceToObservatory potentialDestination|

	((self walkerDestination sealRestingPlace = 'Observatory') & (observatoryMemory contains: [ :x | x = self walkerDestination])) ifTrue: [ ^ self ].

	potentialDestination := Dictionary new.
	distanceToObservatory := OrderedCollection new.

	self observatoryMemory isEmpty ifTrue: [ self energy: 0. ^ self walkerDestination: self home ].
	self observatoryMemory do: [ :cell | potentialDestination at: (self patch distanceTo: cell constraintOnPath: [ :x | x type = 'Land']) put: cell ].
	"distanceToObservatory isEmpty ifTrue: [ ^ self moveAlongBeach ]."
	potentialDestination keysDo: [ :x | distanceToObservatory add: x].
	distanceToObservatory := distanceToObservatory asSortedCollection: [ :x :y | x < y ].
	self walkerDestination: (potentialDestination at: (distanceToObservatory first)).
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

{ #category : #behavior }
BSWalkerGuide >> moveToDestination [

(self walkerDestination sealRestingPlace = 'Observatory')
ifTrue: [ self moveTowards: walkerDestination constraintOnPath: [:cell | cell type = 'Land' or: [ cell type = 'Home' ] ] ]
ifFalse: [ self moveInDirectionOf: walkerDestination constraintOnPath: [:cell | cell type = 'Land' or: [ cell type = 'Home' ] ]].

energy := energy - 1.

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
BSWalkerGuide >> uTurn [

|dest|
dest:= self previousCell.
self previousCell: self patch;
moveTo: dest.
]
