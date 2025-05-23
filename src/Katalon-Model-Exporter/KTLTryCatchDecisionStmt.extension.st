Extension { #name : 'KTLTryCatchDecisionStmt' }

{ #category : '*Katalon-Model-Exporter' }
KTLTryCatchDecisionStmt >> exportWith: aKTLModelExporter [
	^ aKTLModelExporter exportKTLTryDecisionStmt: self. 
	
]
