Class {
	#name : 'KatalonMetamodelGenerator',
	#superclass : 'FamixMetamodelGenerator',
	#instVars : [
		'testStep',
		'testCase',
		'variable',
		'globalVar',
		'localVar',
		'objectDeclaration',
		'script',
		'objectRepo',
		'katalonProject',
		'statement',
		'import',
		'assignment',
		'declaration',
		'function',
		'object',
		'data',
		'decisionMaking',
		'looping',
		'branching',
		'binary',
		'assert',
		'methodCall',
		'methodDef',
		'customKeyword',
		'parsingError',
		'customKeywordClass',
		'customKeywordClassAttribute',
		'ifStmt',
		'switchStmt',
		'stepBlock',
		'forStmt',
		'whileStmt',
		'comment',
		'tryCatchStmt',
		'catchStmt',
		'switchCaseStmt'
	],
	#category : 'Katalon-Model-Generator',
	#package : 'Katalon-Model-Generator'
}

{ #category : 'accessing' }
KatalonMetamodelGenerator class >> packageName [

	^ #'Katalon-Model'
]

{ #category : 'accessing' }
KatalonMetamodelGenerator class >> prefix [
	^ #'KTL'
]

{ #category : 'accessing' }
KatalonMetamodelGenerator class >> submetamodels [ 

	^ {FamixMooseQueryGenerator }
]

{ #category : 'definition' }
KatalonMetamodelGenerator >> defineClasses [

	super defineClasses.

	testStep := builder
		            newClassNamed: #TestStep
		            comment: 'I represent a katalon Test step'.
	testCase := builder
		            newClassNamed: #TestCase
		            comment: 'I represent a specific katalon test case'.

	variable := builder
		            newClassNamed: #Var
		            comment: 'I represent an abstract variable'.
	globalVar := builder
		             newClassNamed: #GlobalVar
		             comment:
		             'I represent a global variable accessible by all entites of a test'.
	localVar := builder
		            newClassNamed: #LocalVar
		            comment:
		            'I represent a local variable accessible by all step of a test'.

	objectDeclaration := builder newClassNamed: #ObjectDeclaration.
	script := builder newClassNamed: #ScriptGroovy.
	objectRepo := builder newClassNamed: #ObjectRepository.
	katalonProject := builder newClassNamed: #Project.

	statement := builder
		             newClassNamed: #Statement
		             comment: 'I represent a script statement in groovy'.
	import := builder newClassNamed: #Import.
	assignment := builder newClassNamed: #Assignment.
	declaration := builder newClassNamed: #Declaration.


	function := builder
		            newClassNamed: #Function
		            comment:
		            'I represent a local function accessible by all step of a test'.
	object := builder
		          newClassNamed: #Object
		          comment:
		          'I represent the user interface elements with which the test interacts'.

	data := builder
		        newClassNamed: #Data
		        comment: 'I represent the data used in a Test'.


	decisionMaking := builder
		                  newClassNamed: #DecisionStmt
		                  comment: 'I represent a decision making statement'.
	looping := builder newClassNamed: #LoopingStmt.
	forStmt := builder newClassNamed: #ForStmt.
	whileStmt := builder newClassNamed: #WhileStmt.

	branching := builder newClassNamed: #BranchingStmt.
	binary := builder newClassNamed: #BinaryStmt.
	assert := builder newClassNamed: #AssertStmt.
	comment := builder newClassNamed: #CommentStmt.
	parsingError := builder newClassNamed: #ParsingError.

	ifStmt := builder
		          newClassNamed: #IfDecisionStmt
		          comment: 'I represent a if'.

	tryCatchStmt := builder
		                newClassNamed: #TryCatchDecisionStmt
		                comment: 'I represent a try/catch'.

	catchStmt := builder
		             newClassNamed: #CatchStmt
		             comment: 'I represent a catch'.

	switchStmt := builder
		              newClassNamed: #SwitchDecisionStmt
		              comment: 'I represent a switch'.
	switchCaseStmt := builder
		              newClassNamed: #SwitchCaseStmt
		              comment: 'I represent a switch case'.

	"method call and method define in katalon"
	methodCall := builder newClassNamed: #methodCall.
	methodDef := builder newClassNamed: #methodDef.

	"custom keyword: a custom keyword is defined a groovy file as a Class"
	customKeywordClass := builder newClassNamed: #CustomKeywordClass.
	customKeywordClassAttribute := builder newClassNamed:
		                               #CustomKeywordClassAttribute.
	customKeyword := builder newClassNamed: #CustomKeyword.

	stepBlock := builder newClassNamed: #StepBlock
]

{ #category : 'as yet unclassified' }
KatalonMetamodelGenerator >> defineCustomKeyWordRelations [

	katalonProject <>-* customKeyword.
	customKeywordClass <>-* customKeyword.
	customKeywordClass <>-* customKeywordClassAttribute.
	customKeyword *-* testStep.

	((customKeywordClass property: #subClasses) comment:
		 'inner subclass')
	-* ((customKeywordClass property: #parentClass) comment: 'parent class of current declaration').
]

{ #category : 'definition' }
KatalonMetamodelGenerator >> defineHierarchy [

	super defineHierarchy.
	(builder ensureClassNamed: #Entity) --|> #TEntityMetaLevelDependency.


	globalVar --|> variable.
	localVar --|> variable.


	testStep <|-- statement.

	statement <|-- import.
	statement <|-- assignment.
	statement <|-- declaration.
	statement <|-- methodCall.
	statement <|-- methodDef.
	statement <|-- decisionMaking.
	statement <|-- parsingError.
	statement <|-- looping.
	statement <|-- comment.
	statement <|-- stepBlock.
	statement <|-- switchCaseStmt. 

	methodDef <|-- customKeyword.


	"custom keyword specific"
	declaration <|-- customKeywordClassAttribute.

	decisionMaking <|-- ifStmt.
	decisionMaking <|-- tryCatchStmt.
	decisionMaking <|-- switchStmt.

	statement <|-- catchStmt.


	looping <|-- forStmt.
	looping <|-- whileStmt
]

{ #category : 'as yet unclassified' }
KatalonMetamodelGenerator >> defineObjectRepoRelations [
	"DECLARATION"
	"declaration of local var"
	((objectDeclaration property: #refObjParent) comment: 'a object can have a parent reference')
        *-
    ((objectDeclaration property: #refObjChildren) comment: 'a object can have children references').
]

{ #category : 'definition' }
KatalonMetamodelGenerator >> defineProperties [

	super defineProperties.

	katalonProject property: #name type: #String.
	katalonProject property: #directoryPath type: #Object.

	objectRepo property: #directoryPath type: #Object.
	objectRepo property: #register type: #Object.

	objectDeclaration property: #filePath type: #Object.
	objectDeclaration property: #idx type: #Number.
	objectDeclaration property: #name type: #String.
	objectDeclaration property: #identifierPath type: #String.
	objectDeclaration property: #locator type: #String.
	objectDeclaration property: #locatorMethod type: #String.
	objectDeclaration
		property: #isShadow
		type: #Boolean
		defaultValue: false.
	objectDeclaration
		property: #isIFrame
		type: #Boolean
		defaultValue: false.

	script property: #filePath type: #Object.
	script property: #extension type: #String defaultValue: 'groovy'.

	testCase property: #name type: #String.
	testCase property: #zephyrId type: #String.
	testCase property: #parsingError type: #Boolean defaultValue: false.

	testStep property: #index type: #Number.
	testStep property: #sourceText type: #String.
	testStep property: #treeSitterNode type: #Object.

	testStep property: #item type: #Object.
	testStep property: #object type: #Object.
	testStep property: #input type: #Object.
	testStep property: #output type: #Object.
	testStep property: #stepDescription type: #String.

	assignment
		property: #isDeclaration
		type: #Boolean
		defaultValue: false.


	variable property: #name type: #String.
	variable property: #type type: #String.
	variable property: #initValue type: #String.

	globalVar property: #description type: #String.
	globalVar property: #varProfiles type: #Object.


	methodDef property: #name type: #String.
	methodDef property: #returnType type: #String.
	methodDef property: #parameters type: #Object.

	customKeywordClass property: #name type: #String.
	customKeywordClass property: #package type: #String.
	customKeywordClass property: #sourceText type: #String.
	customKeywordClass property: #filePath type: #String.

	customKeyword property: #identifierPath type: #String.

	looping property: #condition type: #String.
	
]

{ #category : 'definition' }
KatalonMetamodelGenerator >> defineRelations [
    super defineRelations.
	
	katalonProject - objectRepo.

	

	objectRepo <>-* objectDeclaration.
	katalonProject -* testCase .
	testCase - script.
	
	"a test step is an action inside a test case"
	script <>-* testStep.
	
	
	" a step can access to the data, a data can appears in multiple step"
	testStep *-* data.
	"a step involve an object, which can appears in multiple steps"
	testStep *-* objectDeclaration.
	testStep *-* testCase. 
	"global and local variables can be use in a test case"
	testStep *-* statement. 
	
	self defineStatementRelations.

	self defineCustomKeyWordRelations.
	
	self defineVariablesRelations. 
	
	self defineObjectRepoRelations. 
	
	
]

{ #category : 'as yet unclassified' }
KatalonMetamodelGenerator >> defineStatementRelations [
	"Block"

	((stepBlock property: #steps) comment:
		 'represents the steps inside this block')
	<>-* ((testStep property: #block) comment: 'the associated block').

	"If DecisionStmt"
	((ifStmt property: #if) comment: 'represents the steps in a if')
	<>- ((stepBlock property: #ifStatement) comment: 'link to an if block').
	((ifStmt property: #else) comment: 'represents the steps in a else')
	<>-
	((stepBlock property: #ifStatement) comment: 'link to an else block').


	"try decision"
	((tryCatchStmt property: #try) comment:
		 'represents the steps in a try')
	<>-
	((stepBlock property: #tryStatement) comment: 'link to a try catch').

	((tryCatchStmt property: #catches) comment:
		 'represents the multiples catch blocks')
	<>-* ((catchStmt property: #tryCatchStatement) comment:
			 'link to a try catch').

	((tryCatchStmt property: #finally) comment:
		 'represents the steps in a finally')
	<>- ((stepBlock property: #tryStatement) comment:
			 'link to an finally block').


	"specific property of a catch"
	((catchStmt property: #exception) comment:
		 'represents the exeception of a catch')
	<>- ((testStep property: #catchStatement) comment: 'link to an catch').

	((catchStmt property: #catch) comment:
		 'represents the steps in a catch')
	<>- ((stepBlock property: #catchStatement) comment:
			 'link to an catch block').


	"switch"
	((switchStmt property: #body) comment:
		 'represents the body in a switch case')
	<>- ((stepBlock property: #switchStatement) comment:
			 'link to an the switch ').


	"loop stmt"
	((looping property: #loopBody) comment:
		 'represents the steps in a loop')
	<>- ((stepBlock property: #loopStmt) comment: 'link to an loop')
]

{ #category : 'definition' }
KatalonMetamodelGenerator >> defineVariablesRelations [
	 
	"DECLARATION"
	"declaration of local var"
	((declaration property: #variable) comment: 'a global variable')
        -
    ((localVar property: #declaration) comment: 'a katalon declaration of a local variable').


	"ASSIGNMENT"
	((assignment property: #variable) comment: 'a variable')
        *-
   ((variable  property: #assignments) comment: 'the katalon assignments of a variable (local of global)').


	"REFERENCES"
	((testStep property: #variables) comment: 'a set of variables')
        *-*
   ((variable property: #references) comment: 'the katalon references of a variable (local of global) inside any steps').
	
	"this relations store each variable that are use in a test"
	script <>-* variable. 
	
	"a project access all global var"
	katalonProject -* globalVar .
	
]
