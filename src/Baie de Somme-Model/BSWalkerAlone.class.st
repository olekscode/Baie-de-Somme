Class {
	#name : #BSWalkerAlone,
	#superclass : #BSWalker,
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSWalkerAlone class >> entityName [

	^ 'PromeneurSeul'
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
BSWalkerAlone >> moveAlongBeach [
	
	|dest potentialDest|
(self patch neighbourhood size < 8) ifTrue: [ ^ self uTurn ].

potentialDest := self patch neighbourhood select: [ :cell | cell neighbourhoodAndSelf allSatisfy: [ :y | y ~= self previousCell ]].

dest := potentialDest select: [ :cell | (cell type = 'Land') & (cell neighbourhood anySatisfy: [:y | y type = 'Sea'])].
(dest isEmpty) ifTrue: [ (Cormas random < 0.5) ifTrue: [dest:= self patch neighbourE]  ifFalse: [dest:= self patch neighbourW]] ifFalse: [ dest := dest first ].
self previousCell: self patch.
self moveTo: dest.
]

{ #category : #behavior }
BSWalkerAlone >> moveToASeal [

	(self patch neighbourhood select: [ :each | each type = 'Sea' ]) isEmpty
		ifFalse: [ ^ self moveAlongBeach ]
		ifTrue: [ ^ self previousCell: self patch; moveTowards: self walkerDestination ]
		
	
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
self previousCell: self patch;
moveTo: dest.
]
