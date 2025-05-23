Class {
	#name : 'GroovyVisitor',
	#superclass : 'TSVisitor',
	#instVars : [
		'lastEntity'
	],
	#category : 'Katalon-Model-Importer',
	#package : 'Katalon-Model-Importer'
}

{ #category : 'generic - visiting' }
GroovyVisitor >> createVisitMethod: aMessage [

	| fields aTSNode |
	aTSNode := aMessage arguments first.
	fields := aMessage arguments second.

	^ String streamContents: [ :str |
		  str << self visitorType .
		  ($_ split: aTSNode type) do: [ :word | str << word capitalized ].
		  str << ': aTSNode withFields: fields
	^{
'.

		  fields keysDo: [ :key |
			  str
				  << '		self visitKey: ''';
				  << key;
				  << ''' inDictionnary: fields.';
				  cr ].
		  str
			  << '	}';
			  cr ]
]

{ #category : 'reflective operations' }
GroovyVisitor >> doesNotUnderstand: aMessage [

	"super doesNotUnderstand: aMessage."

	(aMessage selector beginsWith: self visitorType) ifFalse: [
		super doesNotUnderstand: aMessage ].

	self class
		compile: (self createVisitMethod: aMessage)
		classified: #visiting.

	self
		perform: aMessage selector
		with: aMessage arguments first
		with: aMessage arguments second
]

{ #category : 'accessing' }
GroovyVisitor >> lastEntity [

	^ lastEntity
]

{ #category : 'accessing' }
GroovyVisitor >> lastEntity: entity [

	^ lastEntity := entity
]

{ #category : 'generic - visiting' }
GroovyVisitor >> visitGroovyAbstractNode: aTSNode [
  ^super visitNode: aTSNode
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyAccessOp: aTSNode withFields: fields [

	| entity |
	importer currentNode: aTSNode.

	entity := KTLModel new newStatement
		          sourceText: (self sourceTextOfNode: aTSNode);
		          treeSitterNode: aTSNode.
	importer model add: entity.
	^ entity.

"	^ { (self visitKey: '<unnamedChild>' inDictionnary: fields) }"
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyArgumentList: aTSNode withFields: fields [

	| entity |
	importer currentNode: aTSNode.
	^ entity := KTLModel new newStatement accept: importer.

	"^ { (self visitKey: '<unnamedChild>' inDictionnary: fields) }"
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyArrayType: aTSNode withFields: fields [

	

	^ { (self visitKey: '<unnamedChild>' inDictionnary: fields) }
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyAssertion: aTSNode withFields: fields [

	| entity |
	importer currentNode: aTSNode.

	^ lastEntity := KTLModel new newStatement accept: importer.
	"^ { (self visitKey: '<unnamedChild>' inDictionnary: fields) }"
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyAssignment: aTSNode withFields: fields [
	"	self sourceTextOfNode: aTSNode. "

	importer currentNode: aTSNode.

	^ lastEntity := KTLModel new newAssignment accept: importer.



	"^ { (self visitKey: '<unnamedChild>' inDictionnary: fields) }"
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyBinaryOp: aTSNode withFields: fields [

	| entity |
	importer currentNode: aTSNode.

	^ lastEntity := KTLModel new newStatement accept: importer.

	"^ { (self visitKey: '<unnamedChild>' inDictionnary: fields) }"
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyBooleanLiteral: aTSNode withFields: fields [

	| entity |
	importer currentNode: aTSNode.
	^ entity := KTLModel new newStatement accept: importer.

	"^ {  }"
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyBreak: aTSNode withFields: fields [

	importer currentNode: aTSNode.

	^ lastEntity := KTLModel new newStatement accept: importer.

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyBuiltintype: aTSNode withFields: fields [

	| entity |
	importer currentNode: aTSNode.

	^ entity := KTLModel new newStatement accept: importer.


]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyCase: aTSNode withFields: fields [
	|entity value stmts|
	importer currentNode: aTSNode.
	entity := (KTLModel new newSwitchCaseStmt) treeSitterNode: aTSNode.
	importer model add: entity.
	lastEntity := entity. 
	
	value := (self visitKey: 'value' inDictionnary: fields).
	stmts := (self visitKey: '<unnamedChild>' inDictionnary: fields).
	
	stmts isCollection ifFalse: [ stmts := { stmts } ] .
	
	entity sourceText:	(value ifNil:['default'] ifNotNil: #sourceText).
	entity testSteps: ({ value ifNil: [ (KTLModel new newStatement) sourceText: 'default' ] },	stmts).
	
	^ entity
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyCatchException: aTSNode withFields: fields [
	|entity|
	importer currentNode: aTSNode.
	
	entity := (KTLModel new newCatchStmt) sourceText: ''; treeSitterNode: aTSNode. 
	importer model add: entity. 
	lastEntity := entity.
	
	entity  exception: (self visitKey: 'catch_expression' inDictionnary: fields).
	entity  catch:	(self visitKey: 'catch_body' inDictionnary: fields).
	
	^ entity.
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyClosure: aTSNode withFields: fields [

	| entity stmts |
	importer currentNode: aTSNode.
	
	self sourceTextOfNode: aTSNode.
	
	entity := (KTLModel new newStepBlock) sourceText: ''; treeSitterNode: aTSNode .
	importer model add: entity.
	lastEntity := entity.
	stmts := self visitKey: '<unnamedChild>' inDictionnary: fields.

	( stmts isCollection )
		ifTrue: [ entity steps: stmts ]
		ifFalse: [ stmts ifNotNil: [ entity addStep: stmts] ].
	^ entity
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyComment: aTSNode withFields: fields [

	| entity |
	importer currentNode: aTSNode.
	entity := (KTLModel new newCommentStmt ) sourceText: (self sourceTextOfNode: aTSNode ); treeSitterNode: aTSNode.
	importer model add: entity.
	 ^ entity.


]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyConstructorDefinition: aTSNode withFields: fields [

	|entity|
	self sourceTextOfNode: aTSNode.
	importer currentNode: aTSNode.

	"^ {
		  (self visitKey: 'function' inDictionnary: fields).
		  (self visitKey: 'parameters' inDictionnary: fields).
		  (self visitKey: '<unnamedChild>' inDictionnary: fields).
		  (self visitKey: 'body' inDictionnary: fields) }"
	^ self lastEntity: (KTLModel new newmethodDef accept: importer).
	
	

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyContinue: aTSNode withFields: fields [

	importer currentNode: aTSNode.
	^ self lastEntity: (KTLModel new newStatement accept: importer).
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyDeclaration: aTSNode withFields: fields [

	| entity |
	importer currentNode: aTSNode.


"
	^ {
		  (self visitKey: 'type' inDictionnary: fields).
		  (self visitKey: 'name' inDictionnary: fields).
		  (self visitKey: 'value' inDictionnary: fields) }"

	^ self lastEntity: (KTLModel new newDeclaration accept: importer).

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyDottedIdentifier: aTSNode withFields: fields [

	| entity |
	importer currentNode: aTSNode.


	"^ { (self visitKey: '<unnamedChild>' inDictionnary: fields) }"

	^ self lastEntity: (KTLModel new newStatement accept: importer).

	
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyERROR: aTSNode withFields: fields [

	self sourceTextOfNode: aTSNode.

	{
		aTSNode startPoint row >0 ifTrue: [ (self sourceText lines at: aTSNode startPoint row). ] ifFalse: [''].
		(self sourceText lines at: aTSNode startPoint row + 1).
		(self sourceText lines at: aTSNode startPoint row + 2) }.

	('Error when parsing '
	 , importer sourcesStack top filePath printString) traceCr.
	('[L:' , (aTSNode startPoint row + 1) printString , '] '
	 , (self sourceText lines at: aTSNode startPoint row + 1)) traceCr.
	('') traceCr. 


	TSParsingError new signal: 'mon erreur'.


	^ nil
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyEscapeSequence: aTSNode withFields: fields [
	^{
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyFirstLine: aTSNode withFields: fields [
		|entity|
		entity := (KTLModel new newCommentStmt ) sourceText: (self sourceTextOfNode: aTSNode ); treeSitterNode: aTSNode.
	importer model add: entity.
	 ^ entity.

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyForInLoop: aTSNode withFields: fields [

	| entity var collection |
	importer currentNode: aTSNode.

	entity := KTLModel new newForStmt
		          treeSitterNode: aTSNode;
		          sourceText: (self sourceTextOfNode: aTSNode);
		          yourself.
	importer model add: entity.
	lastEntity := entity.

	var := self visitKey: 'variable' inDictionnary: fields.
	collection := self visitKey: 'collection' inDictionnary: fields.

	entity condition: ('( {1} in {2} )' format: {
				 var sourceText.
				 collection sourceText }).

	entity loopBody: (self visitKey: 'body' inDictionnary: fields).

	^ entity
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyForLoop: aTSNode withFields: fields [

	| entity |
	
	importer currentNode: aTSNode.

	 entity:= (KTLModel new newForStmt) treeSitterNode: aTSNode; sourceText: (self sourceTextOfNode: aTSNode); yourself.
	 importer model add: entity. 
	lastEntity:= entity.
	
	
	entity condition: '(', (	', ' join:  ((self visitKey: '<unnamedChild>' inDictionnary: fields) collect: [:e  | e ifNil: [ 'ERROR' ] ifNotNil: #sourceText]) ),')'.
	entity loopBody:	  (self visitKey: 'body' inDictionnary: fields).
	^ entity
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyForParameters: aTSNode withFields: fields [
	^{
		self visitKey: 'initializer' inDictionnary: fields.
		self visitKey: 'condition' inDictionnary: fields.
		self visitKey: 'increment' inDictionnary: fields.
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyForWithIterator: aTSNode withFields: fields [

	| type var collection closure entity |
	importer currentNode: aTSNode.
	entity := (KTLModel new newForStmt) treeSitterNode:aTSNode; sourceText: (self sourceTextOfNode:aTSNode); yourself..
	importer model add: entity. 
	lastEntity := entity.


	type := self visitKey: 'type' inDictionnary: fields.
	var := self visitKey: 'variable' inDictionnary: fields.
	collection := self visitKey: 'collection' inDictionnary: fields.
	closure := self visitKey: 'body' inDictionnary: fields.

	entity condition: ('( {1} {2} : {3} )' format: {
				 type ifNil: ['def'] ifNotNil: #sourceText.
				 var sourceText.
				 collection sourceText }).

	entity loopBody: closure.

	^ entity
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyFunctionCall: aTSNode withFields: fields [

	importer currentNode: aTSNode.
	
	"^ {
		  (self visitKey: 'function' inDictionnary: fields).
		  (self visitKey: 'args' inDictionnary: fields) }"
	
	^ self lastEntity: (KTLModel new newmethodCall accept: importer).


	
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyFunctionCallWithClosure: aTSNode withFields: fields [
	|entity|
	importer currentNode: aTSNode. 
	entity := KTLModel new newmethodCall 
						treeSitterNode: aTSNode; 
						sourceText: (self sourceTextOfNode: aTSNode).
	
		self visitKey: 'function' inDictionnary: fields.
	entity block: (	self visitKey: 'closure' inDictionnary: fields).
	
	^entity 

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyFunctionDeclaration: aTSNode withFields: fields [

	| entity |
	importer currentNode: aTSNode.
	self flag: 'investigate proper type'.

	"entity := KTLModel new newmethodDef sourceText: (self sourceTextOfNode: aTSNode); treeSitterNode: aTSNode; yourself"
	entity := KTLModel new newmethodDef accept: importer.

	^ lastEntity := entity.

"	importer model add: entity.

	self visitKey: 'type' inDictionnary: fields.
	self visitKey: 'function' inDictionnary: fields.
	self visitKey: 'parameters' inDictionnary: fields"
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyFunctionDefinition: aTSNode withFields: fields [

	| entity |
	importer currentNode: aTSNode.

	^ self lastEntity: (KTLModel new newmethodDef accept: importer).


	"^ {
		  (self visitKey: 'function' inDictionnary: fields).
		  (self visitKey: 'parameters' inDictionnary: fields).
		  (self visitKey: 'body' inDictionnary: fields) }"
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyGenerics: aTSNode withFields: fields [
	^{
		self visitKey: '<unnamedChild>' inDictionnary: fields.
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyGroovyDoc: aTSNode withFields: fields [

	| entity |
	importer currentNode: aTSNode.

	^ self lastEntity: (KTLModel new newStatement accept: importer).

"	^ { (self visitKey: '<unnamedChild>' inDictionnary: fields) }"
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyGroovyDocAtText: aTSNode withFields: fields [
	^{
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyGroovyDocParam: aTSNode withFields: fields [
	^{
		self visitKey: '<unnamedChild>' inDictionnary: fields.
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyGroovyImport: aTSNode withFields: fields [

	^ nil.

"	^ {
		  (self visitKey: '<unnamedChild>' inDictionnary: fields).
		  (self visitKey: 'import' inDictionnary: fields) }"
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyIdentifier: aTSNode withFields: fields [
	importer currentNode: aTSNode. 
	^ self lastEntity: (KTLModel new newStatement accept: importer)
	

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyIfStatement: aTSNode withFields: fields [

	| entity ifStmts elseStmts |
	importer currentNode: aTSNode.
	entity := KTLModel new newIfDecisionStmt
		          treeSitterNode: aTSNode;
		          sourceText: (self sourceTextOfNode: aTSNode).
	lastEntity := entity.


	self flag:
		'improve by adding condition in the importer. currently handle by the exporter with sourcetext'.
	"entity condition:  (self visitKey: 'condition' inDictionnary: fields)."
	ifStmts := self visitKey: 'body' inDictionnary: fields.
	ifStmts ifNotNil: [
		(ifStmts isKindOf: KTLStepBlock)
			ifTrue: [ entity if: ifStmts ]
			ifFalse: [
				| block |
				block := (KTLModel new newStepBlock) sourceText: ''.
				importer model add: block.
				block addStep: ifStmts.
				entity if: block ] ].
	elseStmts := self visitKey: 'else_body' inDictionnary: fields.
	elseStmts ifNotNil: [
		(elseStmts isKindOf: KTLStepBlock)
			ifTrue: [ entity else: elseStmts ]
			ifFalse: [
				| block |
				block := (KTLModel new newStepBlock) sourceText: '' .
				importer model add: block.
				block addStep: elseStmts.
				entity else: block ] ].

	^ entity
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyImport: aTSNode withFields: fields [
	^{
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyIncrementOp: aTSNode withFields: fields [

	importer currentNode: aTSNode.
	^ self lastEntity: (KTLModel new newStatement accept: importer).
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyIndex: aTSNode withFields: fields [
	^{
		self visitKey: '<unnamedChild>' inDictionnary: fields.
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyInterpolation: aTSNode withFields: fields [
	^{
		self visitKey: '<unnamedChild>' inDictionnary: fields.
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyJuxtFunctionCall: aTSNode withFields: fields [
	
	|entity|
	importer currentNode: aTSNode.
	entity := KTLModel new newmethodCall
		          treeSitterNode: aTSNode;
		          sourceText: (self sourceTextOfNode: aTSNode).
	importer model add: entity. 
	lastEntity:= entity.
	
	^ entity.
	"^{
		self visitKey: 'function' inDictionnary: fields.
		self visitKey: '<unnamedChild>' inDictionnary: fields.
		self visitKey: 'args' inDictionnary: fields.
	}
"
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyLabel: aTSNode withFields: fields [
	
	importer currentNode: aTSNode. 
	^ self lastEntity:( KTLModel new newStatement accept: importer).  

	^ { (self visitKey: 'name' inDictionnary: fields) }
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyList: aTSNode withFields: fields [
	^ {  }
	
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyMap: aTSNode withFields: fields [
	^{
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyModifier: aTSNode withFields: fields [
	^{
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyNull: aTSNode withFields: fields [
	^{
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyNumberLiteral: aTSNode withFields: fields [
	| entity |
	importer currentNode: aTSNode.

	^ lastEntity := KTLModel new newStatement accept: importer.


]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyParameter: aTSNode withFields: fields [
	^{
		self visitKey: 'type' inDictionnary: fields.
		self visitKey: 'name' inDictionnary: fields.
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyParameterList: aTSNode withFields: fields [
	
	(lastEntity isKindOf: KTLStepBlock) ifTrue: [ 
		importer currentNode:  aTSNode.
		^ KTLModel new newStatement accept: importer
		].
	
	
	^ {
		self visitKey: '<unnamedChild>' inDictionnary: fields.
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyQualifiedName: aTSNode withFields: fields [
	^{
		self visitKey: '<unnamedChild>' inDictionnary: fields.
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyQuotedFunctionCall: aTSNode withFields: fields [
	|entity|
	importer currentNode: aTSNode.
	entity:= (KTLModel new newmethodCall) treeSitterNode:aTSNode; sourceText: (self sourceTextOfNode: aTSNode) .
	importer model add: entity.
	lastEntity := entity.
	^ entity

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyQuotedFunctionIdentifier: aTSNode withFields: fields [
	^{
		self visitKey: 'identifier' inDictionnary: fields.
		self visitKey: 'quoted_name' inDictionnary: fields.
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyReturn: aTSNode withFields: fields [
	
	importer currentNode: aTSNode.
	^ self lastEntity: (KTLModel new newStatement accept: importer).
	
	^{
		self visitKey: '<unnamedChild>' inDictionnary: fields.
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovySourceFile: aTSNode withFields: fields [

	| entity |
	(importer sourcesStack top isKindOf: KTLScriptGroovy) ifTrue: [
		entity := importer sourcesStack top.
		entity testSteps:
			((self visitKey: '<unnamedChild>' inDictionnary: fields)
				 asOrderedCollection reject: #isNil) ].

	(importer sourcesStack top isKindOf: KTLCustomKeywordClass) ifTrue: [
		entity := importer sourcesStack top.
		self visitKey: '<unnamedChild>' inDictionnary: fields .
		].




	^ entity
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyString: aTSNode withFields: fields [
	
	importer currentNode: aTSNode.
	^ self lastEntity: (KTLModel new newStatement accept: importer).
	^{
		self visitKey: '<unnamedChild>' inDictionnary: fields.
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyStringContent: aTSNode withFields: fields [
	^{
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovySwitchBlock: aTSNode withFields: fields [
	 
	^ self visitGroovyClosure: aTSNode withFields: fields
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovySwitchStatement: aTSNode withFields: fields [

	| entity |
	importer currentNode: aTSNode.


	self sourceTextOfNode: aTSNode.
	entity := KTLModel new newSwitchDecisionStmt
		          sourceText: (self sourceTextOfNode: aTSNode);
		          treeSitterNode: aTSNode.
	importer model add: entity.
	lastEntity := entity.

	"entity condition: (self visitKey: 'value' inDictionnary: fields) sourceText."
	
	entity sourceText: (entity sourceText copyFrom: (entity sourceText indexOfSubCollection: '(') to: ( (entity sourceText indexOfSubCollection: '{') -1 )) trim.	

	entity body: (self visitKey: 'body' inDictionnary: fields).

	^ entity
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyTernaryOp: aTSNode withFields: fields [
	^{
		self visitKey: 'condition' inDictionnary: fields.
		self visitKey: 'then' inDictionnary: fields.
		self visitKey: 'else' inDictionnary: fields.
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyTryStatement: aTSNode withFields: fields [

	| entity catches|
	importer currentNode: aTSNode.
	entity := (KTLModel new newTryCatchDecisionStmt) sourceText: ''; treeSitterNode:
		          aTSNode.
	importer model add: entity.
	lastEntity := entity.

	entity try: (self visitKey: 'body' inDictionnary: fields).
	catches := (self visitKey: '<unnamedChild>' inDictionnary: fields).
	catches isCollection ifFalse: [ catches := { catches } ].
	
	(catches reject: #isNil) do: [ :catch | 
		entity addCatch: catch  .
		 ].
	
	entity finally: (self visitKey: 'finally_body' inDictionnary: fields).

	^ entity
]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyTypeWithGenerics: aTSNode withFields: fields [
	^{
		self visitKey: '<unnamedChild>' inDictionnary: fields.
	}

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyUnaryOp: aTSNode withFields: fields [
	^self visitKey: '<unnamedChild>' inDictionnary: fields.
	

]

{ #category : 'visiting' }
GroovyVisitor >> visitGroovyWhileLoop: aTSNode withFields: fields [
	
	|entity condition closure|
	importer currentNode: aTSNode.
	entity:= (KTLModel new newWhileStmt) treeSitterNode:aTSNode; sourceText: (self sourceTextOfNode:aTSNode); yourself.
	importer model add: entity. 
	lastEntity := entity.
	
	condition:=	(self visitKey: 'condition' inDictionnary: fields) sourceText.
	closure :=	(self visitKey: 'body' inDictionnary: fields) .


	entity condition: condition .

	entity loopBody: closure.


	^ entity
]

{ #category : 'generic - visiting' }
GroovyVisitor >> visitKey: aKey inDictionnary: childrenDictionnary [
  | child |
  child := childrenDictionnary at: aKey ifAbsent: [^nil].

  ^child isCollection
    ifTrue: [ child collect: [ :c | (c accept: self) "isCollection ifTrue: [1 halt] ifFalse: [c]" ] ]
    ifFalse: [ child accept: self. ]
]

{ #category : 'generic - visiting' }
GroovyVisitor >> visitNode: aTSNode [
  | selector |
  selector := String streamContents: [ :st |
      st << self visitorType .
    ($_ split: aTSNode type) do: [ :word | st << word capitalized ].
    st << ':withFields:'
  ].

  ^self
    perform: selector asSymbol
    with: aTSNode
    with: aTSNode collectFieldNameOfNamedChild
]

{ #category : 'generic - visiting' }
GroovyVisitor >> visitorType [
	^ 'visitGroovy'
]
