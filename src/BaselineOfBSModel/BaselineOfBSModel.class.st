Class {
	#name : 'BaselineOfBSModel',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfBSModel',
	#package : 'BaselineOfBSModel'
}

{ #category : 'baselines' }
BaselineOfBSModel >> baseline: spec [

	<baseline>
	spec for: #common do: [
		"Packages"
		spec
			package: 'Baie de Somme-Model';
			package: 'Baie de Somme-Model-Tests' with: [ spec requires: #( 'Baie de Somme-Model' ) ] ]
]
