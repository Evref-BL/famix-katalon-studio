Extension { #name : 'KTLTestStep' }

{ #category : '*Katalon-Model-Exporter' }
KTLTestStep >> exportWith: aKTLModelExporter [ 
	^ aKTLModelExporter exportKTLStatement: self. 
]
