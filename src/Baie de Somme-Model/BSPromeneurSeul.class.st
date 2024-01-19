Class {
	#name : #BSPromeneurSeul,
	#superclass : #BSPromeneur,
	#category : #'Baie de Somme-Model'
}

{ #category : #accessing }
BSPromeneurSeul class >> entityName [

	^ 'PromeneurSeul'
]

{ #category : #pov }
BSPromeneurSeul >> pov [

	^ Color red  
]

{ #category : #pov }
BSPromeneurSeul >> povEnergy [	

	^ self
		  povAttribute: #energy
		  min: 0
		  max: 180
		  color: Color red 
]

{ #category : #pov }
BSPromeneurSeul >> povSatisfaction [	

	^ self
		  povAttribute: #satisfaction
		  min: 0
		  max: 180
		  color: Color red 
]
