Class {
	#name : #BSPromeneurTest,
	#superclass : #TestCase,
	#instVars : [
		'promeneurGuide',
		'promeneurSeul'
	],
	#category : #'Baie de Somme-Model-Tests'
}

{ #category : #initialization }
BSPromeneurTest >> setUp [

	super setUp.
	promeneurGuide := BSPromeneurGuide  new.
	promeneurSeul := BSPromeneurSeul new.
	
]

{ #category : #initialization }
BSPromeneurTest >> testPov [

	self assert: promeneurGuide pov isColor.
	self assert: promeneurSeul pov isColor.
	self deny: promeneurGuide pov equals: promeneurSeul pov.
]
