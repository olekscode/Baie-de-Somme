Class {
	#name : #BSBoatMotorized,
	#superclass : #BSBoat,
	#category : #'Baie de Somme-Model'
}

{ #category : #behavior }
BSBoatMotorized >> checkPosition [ 
	
^ self
]

{ #category : #pov }
BSBoatMotorized >> pov [

	^ Color purple
]

{ #category : #accessing }
BSBoatMotorized >> step [
	^ self shouldBeImplemented
]
