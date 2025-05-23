Extension { #name : 'KTLTestStep' }

{ #category : '*Katalon-Model-Importer' }
KTLTestStep >> accept: anImporter [

	^ anImporter importsStep: self
]

{ #category : '*Katalon-Model-Importer' }
KTLTestStep >> name [ 
 ^ self sourceText ifNotNil: [ :text | text contractTo: 50 ] ifNil: ['a statement']
]
