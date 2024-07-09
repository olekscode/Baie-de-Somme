Class {
	#name : #BSSealStatusSwimming,
	#superclass : #BSSealStatus,
	#classVars : [
		'nextStatus'
	],
	#category : #'Baie de Somme-Model'
}

{ #category : #stepping }
BSSealStatusSwimming >> step [ 

(self timer = 0)
	ifTrue: [ self swimTowardRepository ]
	ifFalse: [ self swimInWater ]
]

{ #category : #'as yet unclassified' }
BSSealStatusSwimming >> swimInWater [

| candidates |

candidates := holder patch neighbourhoodAndSelf select: [ :cell | cell type = 'Sea' ].

holder moveTo: candidates atRandom.
self timer: (timer - 1).
]

{ #category : #'as yet unclassified' }
BSSealStatusSwimming >> swimTowardRepository [

holder moveTowards: holder myRestingPlace constraintOnPath: [ :cell | (cell type = 'Sea') or: [ cell sealRestingPlace = holder myRestingPlace sealRestingPlace ] ].

(holder patch neighbourhood anySatisfy: [ :cell | cell sealRestingPlace = holder myRestingPlace sealRestingPlace ]) ifTrue: [ self changeStatusOf: holder To: nextStatus ].
]
