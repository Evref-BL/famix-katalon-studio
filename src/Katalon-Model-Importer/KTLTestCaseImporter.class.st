Class {
	#name : 'KTLTestCaseImporter',
	#superclass : 'KTLModelImporter',
	#instVars : [
		'lastNode',
		'cursor',
		'entityStack'
	],
	#category : 'Katalon-Model-Importer',
	#package : 'Katalon-Model-Importer'
}

{ #category : 'instance creation' }
KTLTestCaseImporter class >> newFromType: aTsNode [

	| aTypeName |
	aTypeName := aTsNode type.

	aTypeName = #source_file ifTrue: [ ^ KTLModel new newTestCase ].
	aTypeName = #groovy_import ifTrue: [ ^ KTLModel new newImport ].
	aTypeName = #function_definition ifTrue: [
		^ KTLModel new newmethodDef ].
	aTypeName = #function_call ifTrue: [ ^ KTLModel new newmethodCall ].
	aTypeName = #declaration ifTrue: [ ^ KTLModel new newDeclaration ].
	aTypeName = #assignment ifTrue: [ ^ KTLModel new newAssignment ].
	aTypeName = #comment ifTrue: [ ^ KTLModel new newStatement ].
	aTypeName = #if_statement ifTrue: [ ^ KTLModel new newDecisionStmt ].
	aTypeName = #ERROR ifTrue: [ ^ KTLModel new newParsingError ].
	aTypeName = #dotted_identifier ifTrue: [
		self flag: 'possible customKeyword to capture here'.
		^ KTLModel new newStatement ].
	aTypeName = #juxt_function_call ifTrue: [
		self flag: 'possible customKeyword to capture here'.
		^ KTLModel new newStatement ].
	aTypeName = #';' ifTrue: [
		self flag: 'possible parsing error ?'.
		^ nil "KTLModel new newParsingError" ].
	aTypeName = #groovy_package
		ifTrue: [
			1 halt.
			^ KTLModel new newStatement ]
		ifFalse: [ 1 halt ]
]

{ #category : 'ensure' }
KTLTestCaseImporter >> ensureStep: aKTLStep [

	| step |
	step := model add: aKTLStep.
	"step index: sourcesStack top testSteps size + 1."
	step sourceText:
		(visitor sourceTextOfNode: currentNode ).
	step treeSitterNode: currentNode.
	"sourcesStack top addTestStep: step."

	^ aKTLStep
]

{ #category : 'as yet unclassified' }
KTLTestCaseImporter >> entityStack [

	^ entityStack 
]

{ #category : 'accessing' }
KTLTestCaseImporter >> entityStack: aStack [ 
	entityStack := aStack
]

{ #category : 'importer' }
KTLTestCaseImporter >> importFromTreeSitterTree: aTSTree [

	| sourceCode |
	sourceCode := (self sourcesStack top filePath asFileReference
		               readStreamEncoded: 'utf8') contents.

	cursor := aTSTree rootNode cursor.

	visitor := KTLTestCaseVisitor new
		           importer: self;
		           sourceText: sourceCode;
		           yourself.

	[ "block" aTSTree rootNode accept: visitor ]
		on: TSParsingError
		do: [ "	aTSTree rootNode type = #source_file
		ifTrue: [ aTSTree rootNode accept: visitor ]
		ifFalse: [
			aTSTree rootNode collectNamedChild do: [ :node |
				node accept: visitor ] ]"
			self sourcesStack top testCase hasParsingError ]
]

{ #category : 'as yet unclassified' }
KTLTestCaseImporter >> importKTLCustomKeywordClass: aKTLCustomKeywordClass [

	| custKeywordClass properties packageName |
	custKeywordClass := aKTLCustomKeywordClass
		                    filePath: sourcesStack top filePath;
		                    yourself.
	entityStack push: custKeywordClass.

	properties := cursor currentNode collectFieldNameOfNamedChild.

	aKTLCustomKeywordClass name:
		((properties at: #name) textFromSourceText:
			 sourcesStack top filePath contents).

	(self parser parseString: sourcesStack top filePath contents)
		rootNode detectNamedChild: #groovy_package ifOne: [ :package |
		package detectNamedChild: #qualified_name ifOne: [ :pckNode |
			packageName := pckNode textFromSourceText:
				               sourcesStack top filePath contents.
			custKeywordClass package: packageName ] ].

	"visit declaration of this groovy class for custom keyword declaration and attributs"
	(properties at: #body) collectNamedChild do: [ :child |
		| elmt |
		elmt := self visitCursor: child cursor.

		(elmt isKindOf: KTLCustomKeyword) ifTrue: [
			aKTLCustomKeywordClass customKeywordsGroup
				detect: [ :kw | kw name = elmt name ]
				ifNone: [
					aKTLCustomKeywordClass addCustomKeyword: elmt.
					model add: elmt ] ].

		(elmt isKindOf: KTLCustomKeywordClass) ifTrue: [
			aKTLCustomKeywordClass subClasses
				detect: [ :kw | kw name = elmt name ]
				ifNone: [
					aKTLCustomKeywordClass addSubClass: elmt.
				] ].

		(elmt isKindOf: KTLCustomKeywordClassAttribute) ifTrue: [
			aKTLCustomKeywordClass customKeywordClassAttributes
				detect: [ :kw | kw name = elmt name ]
				ifNone: [
					aKTLCustomKeywordClass addCustomKeywordClassAttribute: elmt.
					model add: elmt ] ] ].

	^ model add: entityStack pop
]

{ #category : 'import' }
KTLTestCaseImporter >> importKTLDecisionStmt: aKTLDecisionStmt [ 
	|properties declaration |
	declaration := self ensureStep: aKTLDecisionStmt.
	properties := aKTLDecisionStmt treeSitterNode collectFieldNameOfNamedChild.
	entityStack push: aKTLDecisionStmt.
	
	(self visitCursor: (properties at: #body) cursor).
	
	^ entityStack pop.
]

{ #category : 'import' }
KTLTestCaseImporter >> importKTLDeclaration: aKTLDeclaration [

	| declaration properties variable |
	declaration := self ensureStep: aKTLDeclaration.

	properties := aKTLDeclaration treeSitterNode
		              collectFieldNameOfNamedChild.
	declaration item: (self visitor sourceTextOfNode: (properties at: #name)).

	properties at: #value ifPresent: [
		declaration input: (self visitor sourceTextOfNode:(properties at: #value))].


	variable := self importLocalVariableFromDeclaration: declaration.
	"	entityStack top addVariable: variable."


	^ declaration
]

{ #category : 'import' }
KTLTestCaseImporter >> importKTLIfDecisionStmt: aKTLDecisionStmt [ 
	|properties declaration |
	declaration := self ensureStep: aKTLDecisionStmt.
	properties := aKTLDecisionStmt treeSitterNode collectFieldNameOfNamedChild.
	
	entityStack push: aKTLDecisionStmt.
	
	aKTLDecisionStmt if: (model newStepBlock).
	aKTLDecisionStmt if steps: ((properties at: #body) collectNamedChild collect: [ :childNode |
		|step|
		step := (childNode accept: self visitor).
		((model allWithSubTypesOf: KTLTestStep) includes: step) ifFalse: [model add: step].
		step
		 ]).
	"an optional else block detect"
	properties at: #else_body ifPresent: [ 
		aKTLDecisionStmt else: (model newStepBlock).
		aKTLDecisionStmt else steps: ((properties at: #else_body) collectNamedChild collect: [ :childNode |
		|step|

		step := (childNode accept: self visitor).
		((model allWithSubTypesOf: KTLTestStep) includes: step) ifFalse: [model add: step].
		step
		 ])].

	^ entityStack pop.
]

{ #category : 'as yet unclassified' }
KTLTestCaseImporter >> importKTLLoopingStmt: aKTLLoopingStmt [

	| properties declaration |
	declaration := self ensureStep: aKTLLoopingStmt.
	properties := aKTLLoopingStmt treeSitterNode
		              collectFieldNameOfNamedChild.
		
	^ aKTLLoopingStmt
]

{ #category : 'import - block' }
KTLTestCaseImporter >> importKTLStepBlock: aKTLStepBlock [ 
			| properties|
	
	"self importsStep: aKTLmethodDef."
	properties := currentNode collectFieldNameOfNamedChild.
	self flag: 'dont know if should be implemented...'.
	
	1 halt.
	^ aKTLStepBlock
]

{ #category : 'import' }
KTLTestCaseImporter >> importKTLSwitchDecisionStmt: aKTLDecisionStmt [ 
	|properties declaration cases|
	declaration := self ensureStep: aKTLDecisionStmt.
	properties := aKTLDecisionStmt treeSitterNode collectFieldNameOfNamedChild.
	entityStack push: aKTLDecisionStmt.
	
	
	"visit switch cases"
	cases := (properties at: #body) collectNamedChild do: [ :childNode |
		|case|
		case := model newStepBlock.
		case steps: (childNode collectNamedChild collect: [ :caseStmtNode |
			
			caseStmtNode accept: self visitor. 
			 ]).
		
		childNode collectFieldNameOfNamedChild at: #value ifPresent: [ aKTLDecisionStmt addCase: case.  ] ifAbsent: [ aKTLDecisionStmt default: case.  ]
		
		 ].
	
	^ entityStack pop.
]

{ #category : 'import' }
KTLTestCaseImporter >> importKTLTryDecisionStmt: aKTLDecisionStmt [

	| properties declaration |
	declaration := self ensureStep: aKTLDecisionStmt.
	properties := aKTLDecisionStmt treeSitterNode
		              collectFieldNameOfNamedChild.

	entityStack push: aKTLDecisionStmt.



	aKTLDecisionStmt try: model newStepBlock.
	aKTLDecisionStmt try steps:
		((properties at: #body) collectNamedChild collect: [ :childNode |
			 childNode accept: self visitor ]).
	
	"catches (multiples possible)"
	aKTLDecisionStmt exception:
		((properties at: #catch_exception) accept: self visitor).
	1 halt. 
	aKTLDecisionStmt catch: model newStepBlock.
	aKTLDecisionStmt catch steps:
		((properties at: #catch_body) collectNamedChild collect: [
			 :childNode | childNode accept: self visitor ]).
		
	"finally"
	properties at: #finally_body ifPresent: [
		aKTLDecisionStmt finally: model newStepBlock.
		aKTLDecisionStmt finally steps:
			((properties at: #finally_body) collectNamedChild collect: [
				 :childNode | childNode accept: self visitor ]) ].


	

	^ entityStack pop
]

{ #category : 'imports' }
KTLTestCaseImporter >> importsMethodCall: aKTLmethodCall [ 

	self importsStep: aKTLmethodCall.
	
	aKTLmethodCall item: (visitor sourceTextOfNode: (aKTLmethodCall treeSitterNode namedChildAt: 1) ) .
	aKTLmethodCall input: (visitor sourceTextOfNode:(aKTLmethodCall treeSitterNode namedChildAt: 2) ) .
	
	^ aKTLmethodCall.

]

{ #category : 'imports' }
KTLTestCaseImporter >> importsMethodDef: aKTLmethodDef [ 
	| properties|
	
	"self importsStep: aKTLmethodDef."
	self ensureStep: aKTLmethodDef.

	
	properties := aKTLmethodDef treeSitterNode collectFieldNameOfNamedChild.
	
	aKTLmethodDef name: (self visitor sourceTextOfNode: (properties at:#function)) .
	aKTLmethodDef parameters: (self visitor sourceTextOfNode: (properties at:#parameters) ).
	aKTLmethodDef returnType: (properties at:#type ifPresent: [:v | self visitor sourceTextOfNode: v ] ifAbsent: ['def']).
	
	entityStack push: aKTLmethodDef. 
	
	"collect step in closure"
	(properties at: #body) collectNamedChild do: [ :childNode |
		|step|
		step := childNode accept: self visitor. 
		aKTLmethodDef addTestStep: step. 
		 ].

	self flag: 'remove stack'.
	^ entityStack pop.
	
]

{ #category : 'initialization' }
KTLTestCaseImporter >> initialize [

	entityStack := Stack new.
	visitor := KTLVisitor new. 
]

{ #category : 'visiting' }
KTLTestCaseImporter >> visitCursor: aTSTreeCursor [ 
	| entity |
	

	cursor := aTSTreeCursor.
	 
	aTSTreeCursor currentNode isNamed ifFalse: [ ^ nil ].
	aTSTreeCursor currentNode textFromSourceText: sourcesStack top filePath contents.
	entity := (self newFromType: aTSTreeCursor currentNode).
	
	^ entity . 

	
]
