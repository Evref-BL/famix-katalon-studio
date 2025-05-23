Extension { #name : 'KTLStepBlock' }

{ #category : '*Katalon-Model-Exporter' }
KTLStepBlock >> exportWith: anExpoter [

	^ anExpoter exportKTLClosure: self
]
