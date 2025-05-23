Extension { #name : 'KTLImport' }

{ #category : '*Katalon-Model-Importer' }
KTLImport >> accept: anImporter [

	^ anImporter importsImportStmt: self
]
