Class {
	#name : 'KTLCostumKeywordImporterV3',
	#superclass : 'KTLModelImporter',
	#instVars : [
		'lastNode',
		'cursor',
		'entityStack',
		'customKeywordClassEntity'
	],
	#category : 'Katalon-Model-Importer',
	#package : 'Katalon-Model-Importer'
}

{ #category : 'instance creation' }
KTLCostumKeywordImporterV3 class >> newFromType: aTsNode [
	|aTypeName|
	aTypeName := aTsNode type.
	
	aTypeName = #source_file ifTrue: [ 
		^ KTLModel new newCase.
		 ].
	aTypeName = #groovy_import ifTrue: [ 
		^ KTLModel new newImport.
		 ].
	aTypeName = #function_definition ifTrue: [ 
		^ KTLModel new newmethodDef .
		 ].
	aTypeName = #function_call ifTrue: [ 
		^ KTLModel new newmethodCall.
		 ].
	aTypeName = #declaration ifTrue: [ 
		^ KTLModel new  newDeclaration .
		 ].
	aTypeName = #assignment  ifTrue: [ 
		^ KTLModel new newAssignment .
		 ].
	aTypeName = #comment ifTrue: [ 
		^ KTLModel new newStatement .
		 ].
	aTypeName = #if_statement ifTrue: [ 
		^ KTLModel new newDecisionStmt .
		 ].
	aTypeName = #ERROR ifTrue: [ 
		^ KTLModel new newParsingError .
		 ].
	aTypeName = #dotted_identifier ifTrue: [ 
		self flag: 'possible customKeyword to capture here'.
		^ KTLModel new newStatement .
		 ].
	aTypeName = #juxt_function_call ifTrue: [ 
		self flag: 'possible customKeyword to capture here'.
		^ KTLModel new newStatement .
		 ].
	aTypeName = #';' ifTrue: [ 
		self flag: 'possible parsing error ?'.
		^ nil "KTLModel new newParsingError" .
		 ].
	aTypeName = #'groovy_package' ifTrue: [ 
		1 halt. 
		^ KTLModel new newStatement .
		 ]
	ifFalse: [ 
		 1 halt. 
		 ]
	 
	
	
]

{ #category : 'as yet unclassified' }
KTLCostumKeywordImporterV3 >> customKeywordEntity: aKTLCustomKeyword [ 
	customKeywordClassEntity := aKTLCustomKeyword
]

{ #category : 'ensure' }
KTLCostumKeywordImporterV3 >> ensureStep: aKTLStep [ 
	|step|
	step :=	model add: aKTLStep. 
	"step index: sourcesStack top testSteps size + 1."
	step sourceText:  (currentNode textFromSourceText: (sourcesStack top filePath contents)).
	step treeSitterNode: currentNode. 
	"sourcesStack top addTestStep: step."

	^ aKTLStep
]

{ #category : 'accessing' }
KTLCostumKeywordImporterV3 >> entityStack: aStack [ 
	entityStack := aStack
]

{ #category : 'importer' }
KTLCostumKeywordImporterV3 >> importFromTreeSitterTree: aTSTree [

	| sourceCode |
	sourceCode := (self sourcesStack top filePath asFileReference
		               readStreamEncoded: 'utf8') contents.

	cursor := aTSTree rootNode cursor.

	visitor := KTLCustomKeywordVisitor new
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
			"self sourcesStack top testCase hasParsingError" ]
]

{ #category : 'as yet unclassified' }
KTLCostumKeywordImporterV3 >> importKTLCustomKeywordClass: aKTLCustomKeywordClass [

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
KTLCostumKeywordImporterV3 >> importKTLDecisionStmt: aKTLDecisionStmt [ 
	|properties declaration |
	declaration := self ensureStep: aKTLDecisionStmt.
	properties := aKTLDecisionStmt treeSitterNode collectFieldNameOfNamedChild.
	entityStack push: aKTLDecisionStmt.
	
	(self visitCursor: (properties at: #body) cursor).
	
	^ entityStack pop.
]

{ #category : 'import' }
KTLCostumKeywordImporterV3 >> importKTLDeclaration: aKTLDeclaration [

	| declaration properties variable |
	declaration := self ensureStep: aKTLDeclaration.

	properties := aKTLDeclaration treeSitterNode
		              collectFieldNameOfNamedChild.
	declaration item: ((properties at: #name) textFromSourceText:
			 sourcesStack top filePath contents).

	properties at: #value ifPresent: [
		declaration input: ((properties at: #value) textFromSourceText:
				 sourcesStack top filePath contents) ].


	variable := self importLocalVariableFromDeclaration: declaration.
	"	entityStack top addVariable: variable."


	^ declaration
]

{ #category : 'import' }
KTLCostumKeywordImporterV3 >> importKTLIfDecisionStmt: aKTLDecisionStmt [ 
	|properties declaration |
	declaration := self ensureStep: aKTLDecisionStmt.
	properties := aKTLDecisionStmt treeSitterNode collectFieldNameOfNamedChild.
	
	entityStack push: aKTLDecisionStmt.
	
	aKTLDecisionStmt if: (model newStepBlock).
	aKTLDecisionStmt if steps: ((properties at: #body) collectNamedChild collect: [ :childNode |
		|step|
		step := (self visitCursor: childNode cursor).
		((model allWithSubTypesOf: KTLTestStep) includes: step) ifFalse: [model add: step].
		step
		 ]).
	"an optional else block detect"
	properties at: #else_body ifPresent: [ 
		aKTLDecisionStmt else: (model newStepBlock).
		aKTLDecisionStmt else steps: ((properties at: #else_body) collectNamedChild collect: [ :childNode |
		|step|
		step := (self visitCursor: childNode cursor).
		((model allWithSubTypesOf: KTLTestStep) includes: step) ifFalse: [model add: step].
		step
		 ])].

	^ entityStack pop.
]

{ #category : 'import - block' }
KTLCostumKeywordImporterV3 >> importKTLStepBlock: aKTLStepBlock [ 
			| properties|
	
	"self importsStep: aKTLmethodDef."
	properties := currentNode collectFieldNameOfNamedChild.
	self flag: 'dont know if should be implemented...'
]

{ #category : 'import' }
KTLCostumKeywordImporterV3 >> importKTLSwitchDecisionStmt: aKTLDecisionStmt [ 
	|properties declaration cases|
	declaration := self ensureStep: aKTLDecisionStmt.
	properties := aKTLDecisionStmt treeSitterNode collectFieldNameOfNamedChild.
	entityStack push: aKTLDecisionStmt.
	
	
	"visit switch cases"
	cases := (properties at: #body) collectNamedChild do: [ :childNode |
		|case|
		case := model newStepBlock.
		case steps: (childNode collectNamedChild collect: [ :caseStmtNode |
			self visitCursor: caseStmtNode cursor. 
			 ]).
		
		childNode collectFieldNameOfNamedChild at: #value ifPresent: [ aKTLDecisionStmt addCase: case.  ] ifAbsent: [ aKTLDecisionStmt default: case.  ]
		
		 ].
	
	^ entityStack pop.
]

{ #category : 'import' }
KTLCostumKeywordImporterV3 >> importKTLTryDecisionStmt: aKTLDecisionStmt [

	| properties declaration |
	declaration := self ensureStep: aKTLDecisionStmt.
	properties := aKTLDecisionStmt treeSitterNode
		              collectFieldNameOfNamedChild.

	entityStack push: aKTLDecisionStmt.


	1 halt. 
	aKTLDecisionStmt try: model newStepBlock.
	aKTLDecisionStmt try steps:
		((properties at: #body) collectNamedChild collect: [ :childNode |
			 self visitCursor: childNode cursor ]).
	aKTLDecisionStmt catch: model newStepBlock.
	aKTLDecisionStmt catch steps:
		((properties at: #catch_body) collectNamedChild collect: [
			 :childNode | self visitCursor: childNode cursor ]).
	properties at: #finally_body ifPresent: [
		aKTLDecisionStmt finally: model newStepBlock.
		aKTLDecisionStmt finally steps:
			((properties at: #finally_body) collectNamedChild collect: [
				 :childNode | self visitCursor: childNode cursor ]) ].

	aKTLDecisionStmt exception:
		(self visitCursor: (properties at: #catch_exception) cursor).


	^ entityStack pop
]

{ #category : 'imports' }
KTLCostumKeywordImporterV3 >> importsMethodCall: aKTLmethodCall [

	self importsStep: aKTLmethodCall.

	aKTLmethodCall item: (visitor sourceTextOfNode:
			 (aKTLmethodCall treeSitterNode namedChildAt: 1)).
	aKTLmethodCall input: (visitor sourceTextOfNode:
			 (aKTLmethodCall treeSitterNode namedChildAt: 2)).

	^ aKTLmethodCall
]

{ #category : 'imports' }
KTLCostumKeywordImporterV3 >> importsMethodDef: aKTLmethodDef [

	| properties |
	"self importsStep: aKTLmethodDef."
	self ensureStep: aKTLmethodDef.


	properties := aKTLmethodDef treeSitterNode
		              collectFieldNameOfNamedChild.

	aKTLmethodDef name:
		(self visitor sourceTextOfNode: (properties at: #function)).
	aKTLmethodDef parameters:
		(self visitor sourceTextOfNode: (properties at: #parameters)).
	aKTLmethodDef returnType: (properties
			 at: #type
			 ifPresent: [ :v | self visitor sourceTextOfNode: v ]
			 ifAbsent: [ 'def' ]).

	entityStack push: aKTLmethodDef.

	"collect step in closure"
	(properties at: #body) collectNamedChild do: [ :childNode |
		| step |
		step := childNode accept: self visitor.
		aKTLmethodDef addTestStep: step ].

	self flag: 'remove stack'.
	^ entityStack pop
]

{ #category : 'initialization' }
KTLCostumKeywordImporterV3 >> initialize [ 
	entityStack := Stack new. 
]

{ #category : 'as yet unclassified' }
KTLCostumKeywordImporterV3 >> newFromType: aTsNode [
	|aTypeName |
	aTypeName := aTsNode type.
	currentNode := aTsNode.
	
	aTypeName = #groovy_import ifTrue: [ 
		^ nil
		 ].
	aTypeName = #function_definition ifTrue: [ 
		(entityStack top isKindOf: KTLCustomKeywordClass) ifTrue: [ 	
			^ KTLCustomKeyword new accept: self.
			 ].
		^ nil.
		 ].
	aTypeName = #function_call ifTrue: [ 
		
			^ KTLmethodCall new accept: self. 		
		 ].
	aTypeName = #declaration ifTrue: [ 
		
		(entityStack top isKindOf: KTLCustomKeywordClass) ifTrue: [ 
				^ KTLCustomKeywordClassAttribute new accept: self. 
			 ].
		(entityStack top isKindOf: KTLCustomKeyword) ifTrue: [ 
			^ KTLDeclaration new accept: self. 
			 ].
		(entityStack top isKindOf: KTLDecisionStmt ) ifTrue: [ 
			^ KTLDeclaration new accept: self. 
			 ].
			1 halt. 
		^ nil .
		 ].
	aTypeName = #assignment  ifTrue: [ 
			^ KTLAssignment new accept: self. 
		 ].
	aTypeName = #comment ifTrue: [ 
		^ KTLStatement new accept: self .
		 ].
	aTypeName = #ERROR ifTrue: [ 
		^ KTLParsingError new accept: self .
		 ].
	aTypeName = #dotted_identifier ifTrue: [ 
		self flag: 'possible customKeyword to capture here'.
		^ KTLStatement new accept: self .
		 ].
	aTypeName = #juxt_function_call ifTrue: [ 
		self flag: 'possible customKeyword to capture here'.
		^ KTLStatement new accept: self ..
		 ].
	aTypeName = #';' ifTrue: [ 
		self flag: 'possible parsing error ?'.
		^ KTLParsingError new accept: self .
		 ].
	aTypeName = #'groovy_package' ifTrue: [  
		self flag: 'handle by importCustomKeywordClass'.
		"1 halt. "
		^ nil .
		 ].
	aTypeName = #'access_modifier' ifTrue: [ 
		self flag: 'possible parsing error ?'.
		^ nil .
		 ].
	aTypeName = #'class' ifTrue: [ 
		self flag: 'possible parsing error ?'.
		^ nil .
		 ].
	aTypeName = #'identifier' ifTrue: [ 
			^ KTLStatement new accept: self .
		 ].
	aTypeName = #'closure' ifTrue: [ 
		self flag: 'should be handle by imports individually'.
		"1 halt.  "
		(lastNode isNotNil and: [ lastNode isKindOf: KTLDeclaration ]) ifTrue: [ 
			^ KTLStatement new accept: self .
			 ].
		^ KTLStepBlock new accept: self .
		 ].
	
	aTypeName = #'class_definition' ifTrue: [ 
		 	self flag: 'handle by importCustomKeywordClass'.
			^ KTLCustomKeywordClass new accept: self .
		 ].
	aTypeName = #'qualified_name' ifTrue: [ 
		^ nil .
		 ].
	aTypeName = #'binary_op' ifTrue: [ 
		 
		^ KTLStatement new accept: self.  .
		 ].
	aTypeName = #'switch_statement' ifTrue: [ 
			^ KTLSwitchDecisionStmt new accept: self. 
		 ].
	aTypeName = #'try_statement' ifTrue: [ 
			^ KTLTryCatchDecisionStmt new accept: self. 
		 ].
	aTypeName = #if_statement ifTrue: [ 
			^ KTLIfDecisionStmt new accept: self. 
			
		 ].
	aTypeName = #'return' ifTrue: [ 
			^ KTLStatement new accept: self. 
		 ].

	aTypeName = #'switch_block' ifTrue: [ 
			^ KTLStatement new accept: self. 
		 ].
	aTypeName = #'groovy_doc' ifTrue: [ 
		|step|
		self flag: 'todo: support groovy doc imports'.	

		^ nil .
		 ].
	aTypeName = #'parameter_list' ifTrue: [ 
		|step|
		^ nil .
		 ].
	aTypeName = #'argument_list' ifTrue: [ 
		|step|
		^ nil .
		 ].
	aTypeName = #'number_literal' ifTrue: [ 
		
		^ KTLStatement new accept: self. 
		 ].
	aTypeName = #'break' ifTrue: [ 
		^ KTLStatement new accept: self. 
		 ].
	aTypeName = #'string' ifTrue: [ 
		^ KTLStatement new accept: self. 
		 ].
	aTypeName = #'unary_op' ifTrue: [ 
		^ KTLStatement new accept: self. 
		 ]
	ifFalse: [ 
		 1 halt. 
		 ].
	 
	
	
]

{ #category : 'visiting' }
KTLCostumKeywordImporterV3 >> visitCursor: aTSTreeCursor [ 
	| entity |
	

	cursor := aTSTreeCursor.
	 
	aTSTreeCursor currentNode isNamed ifFalse: [ ^ nil ].
	entity := (self newFromType: aTSTreeCursor currentNode).
	
	^ entity . 

	
]
