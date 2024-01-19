Class {
	#name : #BaselineOfBSModel,
	#superclass : #BaselineOf,
	#category : #'BaselineOfBaie de Somme-Model'
}

{ #category : #baselines }
BaselineOfBSModel >> baseline: spec [

	<baseline>
	spec for: #common do: [
		"Dependencies"
		self loadCormas: spec.

		"Packages"
		spec
			package: 'Baie de Somme-Model' with: [ spec requires: #(Cormas) ];
			package: 'Baie de Somme Model-Model-Tests' with: [ spec requires: #( 'ECEC-Model' ) ] ]
]

{ #category : #dependencies }
BaselineOfBSModel >> loadCormas: spec [

	spec
		baseline: 'Cormas'
		with: [ spec loads: #(Core); repository: 'github://cormas/cormas' ]
]
