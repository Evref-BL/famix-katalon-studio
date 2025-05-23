Extension { #name : 'KTLmethodDef' }

{ #category : '*Katalon-Model-Exporter' }
KTLmethodDef >> exportWith: aKTLModelExporter [ 
	
	^ aKTLModelExporter exportKTlMethodDef: self. 
]
