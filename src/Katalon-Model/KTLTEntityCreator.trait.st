"
This trait is used by Famix models.
It provides an API for creating entities and adding them to the model.


"
Trait {
	#name : 'KTLTEntityCreator',
	#category : 'Katalon-Model-Model',
	#package : 'Katalon-Model',
	#tag : 'Model'
}

{ #category : 'meta' }
KTLTEntityCreator classSide >> annotation [

	<FMClass: #TEntityCreator super: #Object>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newAssertStmt [

	<generated>
	^ self add: KTLAssertStmt new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newAssignment [

	<generated>
	^ self add: KTLAssignment new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newBinaryStmt [

	<generated>
	^ self add: KTLBinaryStmt new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newBranchingStmt [

	<generated>
	^ self add: KTLBranchingStmt new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newCatchStmt [

	<generated>
	^ self add: KTLCatchStmt new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newCommentStmt [

	<generated>
	^ self add: KTLCommentStmt new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newCustomKeyword [

	<generated>
	^ self add: KTLCustomKeyword new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newCustomKeywordClass [

	<generated>
	^ self add: KTLCustomKeywordClass new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newCustomKeywordClassAttribute [

	<generated>
	^ self add: KTLCustomKeywordClassAttribute new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newData [

	<generated>
	^ self add: KTLData new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newDecisionStmt [

	<generated>
	^ self add: KTLDecisionStmt new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newDeclaration [

	<generated>
	^ self add: KTLDeclaration new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newForStmt [

	<generated>
	^ self add: KTLForStmt new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newFunction [

	<generated>
	^ self add: KTLFunction new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newGlobalVar [

	<generated>
	^ self add: KTLGlobalVar new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newIfDecisionStmt [

	<generated>
	^ self add: KTLIfDecisionStmt new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newImport [

	<generated>
	^ self add: KTLImport new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newLocalVar [

	<generated>
	^ self add: KTLLocalVar new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newLoopingStmt [

	<generated>
	^ self add: KTLLoopingStmt new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newObject [

	<generated>
	^ self add: KTLObject new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newObjectDeclaration [

	<generated>
	^ self add: KTLObjectDeclaration new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newObjectRepository [

	<generated>
	^ self add: KTLObjectRepository new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newParsingError [

	<generated>
	^ self add: KTLParsingError new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newProject [

	<generated>
	^ self add: KTLProject new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newScriptGroovy [

	<generated>
	^ self add: KTLScriptGroovy new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newStatement [

	<generated>
	^ self add: KTLStatement new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newStepBlock [

	<generated>
	^ self add: KTLStepBlock new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newSwitchCaseStmt [

	<generated>
	^ self add: KTLSwitchCaseStmt new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newSwitchDecisionStmt [

	<generated>
	^ self add: KTLSwitchDecisionStmt new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newTestCase [

	<generated>
	^ self add: KTLTestCase new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newTestStep [

	<generated>
	^ self add: KTLTestStep new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newTryCatchDecisionStmt [

	<generated>
	^ self add: KTLTryCatchDecisionStmt new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newVar [

	<generated>
	^ self add: KTLVar new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newWhileStmt [

	<generated>
	^ self add: KTLWhileStmt new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newmethodCall [

	<generated>
	^ self add: KTLmethodCall new
]

{ #category : 'entity creation' }
KTLTEntityCreator >> newmethodDef [

	<generated>
	^ self add: KTLmethodDef new
]
