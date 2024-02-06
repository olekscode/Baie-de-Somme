Class {
	#name : #BSWalkerGuide,
	#superclass : #BSWalker,
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
BSWalkerGuide >> moveToASeal [

self moveTowards: (self walkerDestination) constraintOnPath: [:cell | cell type = 'Land' ].
	


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
