Extension { #name : 'KTLImport' }

{ #category : '*Katalon-Model-Exporter' }
KTLImport >> exportWith: aKTLModelExporter [ 
	^ aKTLModelExporter exportKTLImport: self.  .
]
