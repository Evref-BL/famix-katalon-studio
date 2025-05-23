Class {
	#name : 'KTLCostumKeywordImporter',
	#superclass : 'KTLModelImporter',
	#instVars : [
		'customKeywordEntity',
		'lastNode',
		'cursor',
		'entityStack'
	],
	#category : 'Katalon-Model-Importer',
	#package : 'Katalon-Model-Importer'
}

{ #category : 'instance creation' }
KTLCostumKeywordImporter class >> newFromType: aTsNode [
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
KTLCostumKeywordImporter >> customKeywordEntity: aKTLCustomKeyword [ 
	customKeywordEntity := aKTLCustomKeyword
]

{ #category : 'ensure' }
KTLCostumKeywordImporter >> ensureStep: aKTLStep [ 
	|step|
	step :=	model add: aKTLStep. 
	"step index: sourcesStack top testSteps size + 1."
	step sourceText:  (currentNode textFromSourceText: (sourcesStack top filePath contents)).
	step treeSitterNode: currentNode. 
	"sourcesStack top addTestStep: step."

	^ aKTLStep
]

{ #category : 'accessing' }
KTLCostumKeywordImporter >> entityStack: aStack [ 
	entityStack := aStack
]

{ #category : 'importer' }
KTLCostumKeywordImporter >> importFromTreeSitterTree: aTSTree [

	cursor := aTSTree rootNode cursor.

	entityStack push: KTLCustomKeywordClass new.
	self visitCursor: cursor.

]

{ #category : 'import' }
KTLCostumKeywordImporter >> importKTLDecisionStmt: aKTLDecisionStmt [ 
	|properties declaration |
	declaration := self ensureStep: aKTLDecisionStmt.
	properties := aKTLDecisionStmt treeSitterNode collectFieldNameOfNamedChild.
	entityStack push: aKTLDecisionStmt.
	
	(self visitCursor: (properties at: #body) cursor).
	
	^ entityStack pop.
]

{ #category : 'import' }
KTLCostumKeywordImporter >> importKTLDeclaration: aKTLDeclaration [ 
	|declaration properties variable |

	declaration := self ensureStep: aKTLDeclaration.
	
	properties := aKTLDeclaration treeSitterNode collectFieldNameOfNamedChild.
	declaration item: ((properties at: #name) textFromSourceText: sourcesStack top filePath contents ) .
	declaration input: ((properties at: #value) textFromSourceText: sourcesStack top filePath contents ) .
	

	variable := self importLocalVariableFromDeclaration: declaration. 
"	entityStack top addVariable: variable."
		
		
	^ declaration 
]

{ #category : 'import' }
KTLCostumKeywordImporter >> importKTLIfDecisionStmt: aKTLDecisionStmt [ 
	|properties declaration |
	declaration := self ensureStep: aKTLDecisionStmt.
	properties := aKTLDecisionStmt treeSitterNode collectFieldNameOfNamedChild.
	entityStack push: aKTLDecisionStmt.
	
	(self visitCursor: (properties at: #body) cursor).
	
	^ entityStack pop.
]

{ #category : 'import' }
KTLCostumKeywordImporter >> importKTLSwitchDecisionStmt: aKTLDecisionStmt [ 
	|properties declaration |
	declaration := self ensureStep: aKTLDecisionStmt.
	properties := aKTLDecisionStmt treeSitterNode collectFieldNameOfNamedChild.
	1 halt.
	entityStack push: aKTLDecisionStmt.
	
	(self visitCursor: (properties at: #body) cursor).
	
	^ entityStack pop.
]

{ #category : 'import' }
KTLCostumKeywordImporter >> importKTLTryDecisionStmt: aKTLDecisionStmt [ 
	|properties declaration |
	declaration := self ensureStep: aKTLDecisionStmt.
	properties := aKTLDecisionStmt treeSitterNode collectFieldNameOfNamedChild.
	1 halt. 
	entityStack push: aKTLDecisionStmt.
	
	(self visitCursor: (properties at: #body) cursor).
	(self visitCursor: (properties at: #catch_body) cursor).
	
	properties at: #finally_body ifPresent: [ (self visitCursor: (properties at: #finally_body) cursor).  ].
	

	^ entityStack pop.
]

{ #category : 'imports' }
KTLCostumKeywordImporter >> importsMethodCall: aKTLmethodCall [ 

	self importsStep: aKTLmethodCall.
	
	aKTLmethodCall item: ((aKTLmethodCall treeSitterNode namedChildAt: 1) textFromSourceText: sourcesStack top filePath contents ) .
	aKTLmethodCall input: ((aKTLmethodCall treeSitterNode namedChildAt: 2) textFromSourceText: sourcesStack top filePath contents ) .
	
	^ aKTLmethodCall.

]

{ #category : 'imports' }
KTLCostumKeywordImporter >> importsMethodDef: aKTLmethodDef [ 
	| properties|
	
	"self importsStep: aKTLmethodDef."
	aKTLmethodDef sourceText:  (currentNode textFromSourceText: (sourcesStack top filePath contents)).
	aKTLmethodDef treeSitterNode: currentNode. 
	
	properties := aKTLmethodDef treeSitterNode collectFieldNameOfNamedChild.
	
	aKTLmethodDef name: ((properties at:#function) textFromSourceText: sourcesStack top filePath contents) .
	aKTLmethodDef parameters: ((properties at:#parameters) textFromSourceText: sourcesStack top filePath contents).
	aKTLmethodDef returnType: (properties at:#type ifPresent: [:v | v textFromSourceText: sourcesStack top filePath contents] ifAbsent: ['def']).
	
	entityStack push: aKTLmethodDef. 
	self visitCursor: (properties at: #body) cursor. 
	
	^ entityStack pop.
	
]

{ #category : 'initialization' }
KTLCostumKeywordImporter >> initialize [ 
	entityStack := Stack new. 
]

{ #category : 'as yet unclassified' }
KTLCostumKeywordImporter >> newEntityFrom: aTSNode [ 
	|entity|
	
	aTSNode isNamed ifFalse: [ ^ nil ]
	
	"aTSNode textFromSourceText: sourcesStack top filePath contents".
	entity := (self newFromType: aTSNode).
	lastNode := aTSNode.
	entity ifNotNil: [ currentNode := aTSNode ].
	^  entity . 
]

{ #category : 'as yet unclassified' }
KTLCostumKeywordImporter >> newFromType: aTsNode [
	|aTypeName |
	aTypeName := aTsNode type.
	
	aTypeName = #source_file ifTrue: [ 
		|custKeywordClass|
		custKeywordClass := entityStack top filePath: sourcesStack top filePath ; yourself.
		custKeywordClass name: (sourcesStack top filePath pathSegments last withoutSuffix: ('.', sourcesStack top filePath extension )). 
		^ true
		 ].
	aTypeName = #groovy_import ifTrue: [ 
		^ nil
		 ].
	aTypeName = #function_definition ifTrue: [ 
		(entityStack top isKindOf: KTLCustomKeywordClass) ifTrue: [ 	
			|KtlKeyword|
			
			currentNode := aTsNode.
			KtlKeyword := KTLCustomKeyword new accept: self.
			entityStack top customKeywordsGroup detect: [ :kw | kw name = KtlKeyword name] ifNone: [entityStack top addCustomKeyword: KtlKeyword. model add: KtlKeyword].	
			^ nil. 
			 ].
		
		 ].
	aTypeName = #function_call ifTrue: [ 
		|step|
			currentNode := aTsNode.
			step := KTLmethodCall new accept: self. 
			entityStack top addTestStep: step. 
			model add: step.
		^ nil
		 ].
	aTypeName = #declaration ifTrue: [ 
			|step|
			currentNode := aTsNode.

		(entityStack top isKindOf: KTLCustomKeywordClass) ifTrue: [ 
				step := KTLCustomKeywordClassAttribute new accept: self. 
				entityStack top customKeywordClassAttributes add: step. 
				model add: step.
			 ].
		(entityStack top isKindOf: KTLCustomKeyword) ifTrue: [ 
			step := KTLDeclaration new accept: self. 
			entityStack top addTestStep: step. 
			model add: step.
			 ].
		(entityStack top isKindOf: KTLDecisionStmt ) ifTrue: [ 
			step := KTLDeclaration new accept: self. 
			entityStack top addTestStep: step. 
			model add: step.
			 ].
			
		^ nil .
		 ].
	aTypeName = #assignment  ifTrue: [ 
		|step|
			currentNode := aTsNode.
			step := KTLAssignment new accept: self. 
			entityStack top addTestStep: step. 
			model add: step.
		^ nil .
		 ].
	aTypeName = #comment ifTrue: [ 
		^ KTLModel new newStatement .
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
		|packageName| 
		packageName := (aTsNode detectNamedChild: #qualified_name ifNone: [ nil ] ).
		packageName := packageName ifNotNil: [ :pckNode | pckNode textFromSourceText: sourcesStack top filePath contents ].
		entityStack top package: packageName.
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
			
		^ nil .
		 ].
	aTypeName = #'closure' ifTrue: [ 
		
		(entityStack top isKindOf: KTLCustomKeywordClass) ifTrue: [ 
			^ true. 
			 ].
		(entityStack top isKindOf: KTLCustomKeyword) ifTrue: [ 
			^ true. 
			 ].
		(entityStack top isKindOf: KTLDecisionStmt ) ifTrue: [ 
			^ true. 
			 ].
		^ nil .
		 ].
	aTypeName = #'class_definition' ifTrue: [ 
		  customKeywordEntity := (model allWithType: KTLCustomKeywordClass) detect: [ :obj | obj filePath = sourcesStack top filePath ] ifNone: [ model add: entityStack top ].
			aTsNode collectFieldNameOfNamedChild.
			lastNode := aTsNode .
			
		^ true .
		 ].
	aTypeName = #'qualified_name' ifTrue: [ 
		^ nil .
		 ].
	aTypeName = #'binary_op' ifTrue: [ 
		1 halt. 
		^ nil .
		 ].
	aTypeName = #'switch_statement' ifTrue: [ 
		|step|
		1 halt.
			currentNode := aTsNode.
			step := KTLSwitchDecisionStmt new accept: self. 
			entityStack top addTestStep: step. 
			model add: step.
		^ nil .
		 ].
	aTypeName = #'try_statement' ifTrue: [ 
		|step|
		1 halt.
			currentNode := aTsNode.
			step := KTLTryCatchDecisionStmt new accept: self. 
			entityStack top addTestStep: step. 
			model add: step.
		^ nil .
		 ].
	aTypeName = #if_statement ifTrue: [ 
		|step|
		
			currentNode := aTsNode.
			step := KTLIfDecisionStmt new accept: self. 
			entityStack top addTestStep: step. 
			model add: step.
			
		^ nil .
		 ].
	aTypeName = #'return' ifTrue: [ 
		|step|
			currentNode := aTsNode.
			step := KTLStatement new accept: self. 
			entityStack top addTestStep: step. 
			model add: step.
		^ nil .
		 ].
	aTypeName = #'switch_block' ifTrue: [ 
		|step|
			currentNode := aTsNode.
			step := KTLStatement new accept: self. 
			entityStack top addTestStep: step. 
			model add: step.
		^ nil .
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
		 ]
	ifFalse: [ 
		 1 halt. 
		 ].
	 
	
	
]

{ #category : 'visiting' }
KTLCostumKeywordImporter >> visitCursor: aTSTreeCursor [ 
	| entity children|
	children := OrderedCollection new. 
	cursor := aTSTreeCursor.
	aTSTreeCursor currentNode isNamed ifFalse: [ ^ nil ].
	entity := (self newFromType: aTSTreeCursor currentNode).
	"entity ifNotNil: [ entity acceptVisitorKeyword: self ]."
	
	"first node shoud be a source_file"
	entity ifNotNil: [ 
		aTSTreeCursor currentNode collectNamedChild do: [ :childNode | 
		cursor := childNode cursor.
		children add: (self visitCursor: cursor).
	 ]. 
	].

	^ {(#entity -> entity).
		(#children -> children ) } asDictionary . 

	
]
