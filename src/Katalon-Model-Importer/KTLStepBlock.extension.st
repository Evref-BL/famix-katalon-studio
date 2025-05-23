Extension { #name : 'KTLStepBlock' }

{ #category : '*Katalon-Model-Importer' }
KTLStepBlock >> accept: anImporter [

	^ anImporter importKTLStepBlock: self
]
