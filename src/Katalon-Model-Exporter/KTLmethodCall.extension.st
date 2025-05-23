Extension { #name : 'KTLmethodCall' }

{ #category : '*Katalon-Model-Exporter' }
KTLmethodCall >> exportWith: aKTLModelExporter [ 
	^ aKTLModelExporter exportMethodCall: self .
]
