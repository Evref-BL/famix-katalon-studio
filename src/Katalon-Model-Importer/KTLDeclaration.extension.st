Extension { #name : 'KTLDeclaration' }

{ #category : '*Katalon-Model-Importer' }
KTLDeclaration >> accept: aImporter [

	^ aImporter importKTLDeclaration: self
]
