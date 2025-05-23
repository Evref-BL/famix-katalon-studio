Extension { #name : 'KTLDeclaration' }

{ #category : '*Katalon-Model-Exporter' }
KTLDeclaration >> exportWith: aKTLModelExporter [ 
	^ aKTLModelExporter exportKTLDeclaration: self .
]
