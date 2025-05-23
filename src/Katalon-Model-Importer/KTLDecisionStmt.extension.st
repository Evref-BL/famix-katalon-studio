Extension { #name : 'KTLDecisionStmt' }

{ #category : '*Katalon-Model-Importer' }
KTLDecisionStmt >> accept: anImporter [

	^ anImporter importKTLDecisionStmt: self
]
