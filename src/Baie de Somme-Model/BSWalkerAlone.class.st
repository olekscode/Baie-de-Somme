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
BSWalkerAlone >> moveToASeal [

	self randomWalkConstrainedBy: [ :cell | cell type = 'Land' ].
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
