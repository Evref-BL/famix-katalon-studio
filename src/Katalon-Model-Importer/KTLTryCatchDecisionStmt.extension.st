Extension { #name : 'KTLTryCatchDecisionStmt' }

{ #category : '*Katalon-Model-Importer' }
KTLTryCatchDecisionStmt >> accept: anImporter [

	^ anImporter importKTLTryDecisionStmt: self
]
