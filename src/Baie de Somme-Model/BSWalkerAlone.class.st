Class {
	#name : #BSWalkerAlone,
	#superclass : #BSWalker,
	#instVars : [
		'destinationMemory'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSWalkerAlone class >> entityName [

	^ 'PromeneurSeul'
]

{ #category : #behavior }
BSWalkerAlone >> checkPosition [

(self patch neighbourhood select: [ :each | each type = 'Sea' ]) isEmpty
		ifFalse: [ ^ self destinationMemory removeAll ]
]

{ #category : #behavior }
BSWalkerAlone >> defineVision [

(self withBinoculars = 'yes')
	ifTrue: [ self defineVisionWihtBinolucars ]
	ifFalse: [ self defineVisionWihtoutBinolucars ]
]

{ #category : #behavior }
BSWalkerAlone >> defineVisionWihtBinolucars [

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

{ #category : #behavior }
BSWalkerAlone >> defineVisionWihtoutBinolucars [

|scope1 scope2|
	scope1 := OrderedCollection new.
	scope2 := OrderedCollection new.
	scope1 := patch neighbourhoodAndSelf.
	scope2 := scope1.
	scope1 do: [ :cell | scope2 addAll: cell neighbourhoodAndSelf ].
	scope2 removeDuplicates.
	self sight: scope2.
]

{ #category : #accessing }
BSWalkerAlone >> destinationMemory [

	^ destinationMemory
]

{ #category : #accessing }
BSWalkerAlone >> destinationMemory: anObject [

	destinationMemory := anObject
]

{ #category : #initialization }
BSWalkerAlone >> initialize [ 

| arg |

	super initialize.
	arg := Cormas random.

	(arg < 0.5) 
		ifTrue: [ groupSize := (Cormas random * 5 + 1) rounded ] 
		ifFalse: [(arg > 0.9) 
			ifTrue: [ groupSize := (Cormas random * 5 + 11) rounded ]
			ifFalse: [groupSize := (Cormas random * 5 + 6) rounded]].
	
	sealExpectation := 3.
	
]

{ #category : #behavior }
BSWalkerAlone >> lookForSpot [

self destinationMemory isNotEmpty
ifTrue: [ ^ self walkerDestination: self destinationMemory atRandom ].

self moveAlongBeach.
]

{ #category : #behavior }
BSWalkerAlone >> moveAlongBeach [
	
	|potentialDest|
potentialDest := self patch neighbourhood select: [ :cell | cell ~= self previousCell ].
potentialDest := potentialDest select: [ :cell | (cell type = 'Land') and: [ cell neighbourhood anySatisfy: [:y | y type = 'Sea'] ] ].

potentialDest isEmpty ifTrue: [ ^ self uTurn ].

self walkerDestination: potentialDest atRandom.
]

{ #category : #behavior }
BSWalkerAlone >> moveToASeal [

	(self patch neighbourhood select: [ :each | each type = 'Sea' ]) isEmpty
		ifFalse: [ ^ self moveAlongBeach ]
		ifTrue: [ ^ self previousCell: self patch; moveTowards: self walkerDestination ]
		
	
]

{ #category : #behavior }
BSWalkerAlone >> moveToDestination [

self previousCell: self patch.
self moveInDirectionOf: walkerDestination constraintOnPath: [ :cell | cell type = 'Land' or: [ cell type = 'Home' ] ]
]

{ #category : #pov }
BSWalkerAlone >> pov [

	^ Color red  
]

{ #category : #pov }
BSWalkerAlone >> povEnergy [	

	^ self
		  povAttribute: #energy
		  min: 0
		  max: 180
		  color: Color red 
]

{ #category : #pov }
BSWalkerAlone >> povSatisfaction [	

	^ self
		  povAttribute: #satisfaction
		  min: 0
		  max: 180
		  color: Color red 
]

{ #category : #behavior }
BSWalkerAlone >> uTurn [

|dest|
dest:= self previousCell.
self walkerDestination: dest.
]
