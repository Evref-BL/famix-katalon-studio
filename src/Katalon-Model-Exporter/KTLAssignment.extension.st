Extension { #name : 'KTLAssignment' }

{ #category : '*Katalon-Model-Exporter' }
KTLAssignment >> exportWith: aKTLModelExporter [ 
	^ aKTLModelExporter exportAssignment: self.
]
