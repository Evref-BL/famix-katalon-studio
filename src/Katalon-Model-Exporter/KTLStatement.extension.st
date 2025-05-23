Extension { #name : 'KTLStatement' }

{ #category : '*Katalon-Model-Exporter' }
KTLStatement >> exportWith: aKTLModelExporter [
	^ aKTLModelExporter exportKTLStatement: self. 
]
