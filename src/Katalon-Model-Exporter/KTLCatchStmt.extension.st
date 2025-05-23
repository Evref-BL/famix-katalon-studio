Extension { #name : 'KTLCatchStmt' }

{ #category : '*Katalon-Model-Exporter' }
KTLCatchStmt >> exportWith: aKTLModelExporter [

	^ aKTLModelExporter exportKTLCatch: self
]
