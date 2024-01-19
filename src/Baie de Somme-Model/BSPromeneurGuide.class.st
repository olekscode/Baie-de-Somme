Class {
	#name : #BSPromeneurGuide,
	#superclass : #BSPromeneur,
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSPromeneurGuide class >> entityName [

	^ 'PromeneurGuide'
]

{ #category : #pov }
BSPromeneurGuide >> pov [

	^ Color green  
]

{ #category : #pov }
BSPromeneurGuide >> povEnergy [

	^ self
		  povAttribute: #energy
		  min: 0
		  max: 180
		  color: Color blue 
]

{ #category : #pov }
BSPromeneurGuide >> povSatisfaction [	

	^ self
		  povAttribute: #satisfaction
		  min: 0
		  max: 180
		  color: Color blue 
]
