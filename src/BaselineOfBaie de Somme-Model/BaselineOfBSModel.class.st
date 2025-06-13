Class {
	#name : 'BaselineOfBSModel',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfBaie de Somme-Model',
	#package : 'BaselineOfBaie de Somme-Model'
}

{ #category : 'baselines' }
BaselineOfBSModel >> baseline: spec [

	<baseline>
	spec for: #common do: [
		"Packages"
		spec
			package: 'Baie de Somme-Model';
			package: 'Baie de Somme Model-Model-Tests' with: [ spec requires: #( 'Baie de Somme-Model' ) ] ]
]
