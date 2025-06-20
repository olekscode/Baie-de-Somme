Class {
	#name : 'BSPromeneurTest',
	#superclass : 'TestCase',
	#instVars : [
		'promeneurGuide',
		'promeneurSeul'
	],
	#category : 'Baie de Somme-Model-Tests',
	#package : 'Baie de Somme-Model-Tests'
}

{ #category : 'initialization' }
BSPromeneurTest >> setUp [

	super setUp.
	promeneurGuide := BSWalkerGuide  new.
	promeneurSeul := BSWalkerAlone new.
	
]

{ #category : 'initialization' }
BSPromeneurTest >> testPov [

	self assert: (promeneurGuide pov isKindOf: CMPointOfView).
	self assert: (promeneurSeul pov isKindOf: CMPointOfView).
	self deny: promeneurGuide pov equals: promeneurSeul pov.
]
