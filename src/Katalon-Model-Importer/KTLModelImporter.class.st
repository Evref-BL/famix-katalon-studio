Class {
	#name : 'KTLModelImporter',
	#superclass : 'Object',
	#instVars : [
		'parser',
		'model',
		'visitor',
		'resolver',
		'currentNode',
		'sourcesStack',
		'metadata'
	],
	#category : 'Katalon-Model-Importer',
	#package : 'Katalon-Model-Importer'
}

{ #category : 'pretreatment' }
KTLModelImporter >> copyFolder: originalFolder to: movedFolder [

	originalFolder asFileReference allChildren do: [ :file |
		| relativePath |
		relativePath := ('/' join:
			                 file absolutePath segments
			                 \ originalFolder asPath segments) withoutAccent.
		relativePath ifNotEmpty: [ "(movedFolder / relativePath) ensureCreateFile ."
			[
			file copyTo:
				(movedFolder / relativePath) asAbsolute asFileReference ]
				on: FileExists
				do: [
					Transcript show: ('Duplicated file :'
						,
						(movedFolder / relativePath) asAbsolute asFileReference
							printString, String cr). ] ] ].

	^ movedFolder
]

{ #category : 'pretreatment' }
KTLModelImporter >> createFolderCopy: aString [

	| movedFolder |
	movedFolder := { '/' }
	               , aString asFileReference asPath segments allButLast
	               ,
	               { (aString asFileReference asPath segments last
	                , '-copy') }.
	movedFolder := ('/' join: movedFolder) asFileReference.
	(movedFolder exists and: [ movedFolder hasChildren ]) ifTrue: [
		^ movedFolder ].
	movedFolder ensureCreateDirectory.
	"FileSystem new copyDirectory: (aString asFileReference) toReference:  (('/' join: movedFolder) asFileReference )."
	"Copy all files and subdirectories from source to target"

	"	aString asFileLocatorOrReference copyAllTo: movedFolder."
	self copyFolder: aString to: movedFolder.

	self treatGroovyFilesInFolder: movedFolder.
	self treatGlblFilesInFolder: movedFolder.
	self treatRsFilesInFolder: movedFolder.


	^ movedFolder
]

{ #category : 'as yet unclassified' }
KTLModelImporter >> currentNode: aTsNode [
 currentNode := aTsNode .
]

{ #category : 'as yet unclassified' }
KTLModelImporter >> ensureGlobalVariable: aVarName [ 
	
	^ (model allWithType: KTLGlobalVar) detect: [ :glbVar |
		glbVar name = aVarName
		 ] ifNone: [ 
		model newGlobalVar name: aVarName; varProfiles: Dictionary new; yourself.
		
		 ]
]

{ #category : 'ensure' }
KTLModelImporter >> ensureObjectDeclarationForIdentifier: aString [ 
	|objtDecl|
	objtDecl := KTLObjectDeclaration new
					identifierPath: aString;
		            yourself.
	^ (model allWithType: KTLObjectDeclaration)
		            detect: [ :obj | 
			"self haltIf: [ (obj identifierPath = aString) and: [ obj name isNil ] ]."
			obj identifierPath = aString ]
		            ifNone: [ model add: objtDecl ].
		
]

{ #category : 'ensure' }
KTLModelImporter >> ensureStep: aKTLStep [ 
	|step|
	step :=	model add: aKTLStep. 
	step index: sourcesStack top testSteps size + 1.
	step sourceText:  (currentNode textFromSourceText: (sourcesStack top filePath contents)).
	step treeSitterNode: currentNode. 
	sourcesStack top addTestStep: step.

	^ aKTLStep
]

{ #category : 'ensure' }
KTLModelImporter >> ensureTestCase: aKTLCase [ 
	model add: aKTLCase.
	^ aKTLCase
]

{ #category : 'filtering' }
KTLModelImporter >> filterObjectCandidates: aMooseGroup [ 
	|notTrueCandidates candidates|
	candidates := aMooseGroup asOrderedCollection.
	notTrueCandidates := Set new. 
	
	candidates do: [ :a |
		candidates do: [ :b |
			(a = b) ifFalse:[
			
				
				((a identifierPath includesSubstring: b identifierPath) 
					and: [(b identifierPath includesSubstring: a identifierPath) not ]) 
						ifTrue: [
							notTrueCandidates add: b. 
					]. 
				]	
			 ] 
		].
		
	
	^ candidates removeAll: notTrueCandidates; yourself. 
]

{ #category : 'parsing' }
KTLModelImporter >> importCustomKeywordFromFile: aFileReference [


	self parseCustomKeywordFile: aFileReference.


]

{ #category : 'importer' }
KTLModelImporter >> importFromString: aGroovyString [

	self importFromTreeSitterTree: (parser parseString: aGroovyString cleanToParse ).
]

{ #category : 'importer' }
KTLModelImporter >> importFromTreeSitterTree: aTSTree [ 
	| ktlEntity cursor |
	
	cursor := aTSTree rootNode cursor. 	
	cursor firstChild. 
	[ 
		ktlEntity := self newEntityFrom: cursor currentNode. 
		ktlEntity ifNotNil: [: e | e accept: self]. 
		cursor nextSibling. 
	 ] whileTrue.
	
	
	
	^ model.

	
]

{ #category : 'import' }
KTLModelImporter >> importGlobalVariableOfProject: aKTLProject [ 
	|path|
		path := aKTLProject directoryPath asFileLocatorOrReference allChildren detect: [ :f | f path segments last = 'Profiles' ] ifNone: [ nil ].
	path isDirectory ifFalse: [ ^ {} ].
	
	"search among all profils with default"
	self flag: 'do imports profils for global variable first'.
	^ self importProfilesOfProject: aKTLProject inFolder: path.
	
	
]

{ #category : 'import' }
KTLModelImporter >> importKTLAssignment: aKTLAssignment [

	| assignment properties |
	assignment := self ensureStep: aKTLAssignment.

	"assigment can have two child (binary op a = 0); or one child (unary op ++ / --)"
	properties := assignment treeSitterNode collectNamedChild.

	properties size = 1 ifTrue: [
		assignment item: ( (properties at: 1) textFromSourceText:
			 sourcesStack top filePath contents) ].

	properties size = 2 ifTrue: [
		assignment item: ( (properties at: 1) textFromSourceText:
			 sourcesStack top filePath contents).
		assignment input:
			( (properties at: 2) textFromSourceText:
			 sourcesStack top filePath contents) ].

	^ assignment
]

{ #category : 'import' }
KTLModelImporter >> importKTLDecisionStmt: aKTLDecisionStmt [ 
	^ self ensureStep: aKTLDecisionStmt.
]

{ #category : 'import' }
KTLModelImporter >> importKTLDeclaration: aKTLDeclaration [ 
	|declaration properties variable |
	declaration := self ensureStep: aKTLDeclaration.
	
	properties := aKTLDeclaration treeSitterNode collectFieldNameOfNamedChild.
	declaration item: ((properties at: #name) textFromSourceText: sourcesStack top filePath contents ) .
	declaration input: ((properties at: #value ifPresent: [:v | v textFromSourceText: sourcesStack top filePath contents  ] ifAbsent: [ nil ])  ) .
	

	variable := self importLocalVariableFromDeclaration: declaration. 
	sourcesStack top addVar: variable.
		
		
	^ declaration 
]

{ #category : 'import' }
KTLModelImporter >> importKTLSwitchDecisionStmt: aKTLSwitchDecisionStmt [ 
	self shouldBeImplemented.
]

{ #category : 'import' }
KTLModelImporter >> importLocalVariableFromDeclaration: aKTLDeclaration [ 
	|localVar properties|
	
	properties := aKTLDeclaration treeSitterNode collectFieldNameOfNamedChild.
	
	localVar := KTLLocalVar new 
								name: ((properties at: #name) textFromSourceText: (sourcesStack top filePath contents )); 
								type: (properties at: #type ifPresent: [ :v | v textFromSourceText: (sourcesStack top filePath contents ) ] ifAbsent: [ '' ] ); 
								initValue: (properties at: #value ifPresent: [ :v | v textFromSourceText: (sourcesStack top filePath contents ) ] ifAbsent: [ '' ] ); 
								declaration: aKTLDeclaration.
	model add: localVar. 
	
	^ localVar 
]

{ #category : 'import' }
KTLModelImporter >> importProfilesOfProject: aKTLProject inFolder: aFileReference [

	| glblFiles |
	glblFiles := Set new.


	glblFiles := aFileReference allChildren select: [ :f |
		             f isFile and: [ f extension = 'glbl' ] ].
	metadata at: #globalVariableFile put: glblFiles size.

	glblFiles do: [ :file |
		(self parseProfileFromGlblFile: file) ifNotNil: [ :objs |
			objs do: [ :obj | aKTLProject addGlobalVar: obj ] ] ].

	^ aKTLProject
]

{ #category : 'importer' }
KTLModelImporter >> importStepsOfCase: aKTLCase [ 
	|cursor steps|
	steps := OrderedCollection new.
	cursor := currentNode cursor.
	cursor firstChild. 
	
	[ |ktlEntity node| 
	
	ktlEntity := self newEntityFrom: cursor currentNode.
	ktlEntity ifNotNil: [ :e| steps add: (e accept: self) ]. 
	
	cursor nextSibling.
	 ] whileTrue. 
	
	steps do: [ :step |
		aKTLCase addStep: step. 
		 ].
	^ aKTLCase 


]

{ #category : 'importer' }
KTLModelImporter >> importTestCase: aKTLCase [ 
	|case|
	case := self ensureTestCase: aKTLCase. 
	self importStepsOfCase: case. 
	^ case. 
]

{ #category : 'import' }
KTLModelImporter >> importsCustomKeywordOfProject: aKTLProject [

	| customKeywords path customKeywordsFiles |
	path := aKTLProject directoryPath asFileLocatorOrReference
		        allChildren
		        detect: [ :f | f path segments last = 'Keywords' ]
		        ifNone: [ nil ].
	path isDirectory ifFalse: [ ^ {  } ].

	customKeywordsFiles := path allChildren select: [ :f |
		                       f extension = 'groovy' and: [
			                       (f contents lines
				                        detect: [ :l | l trim = '@Keyword' ]
				                        ifNone: [ nil ]) isNotNil ] ].

	metadata at: #customKeywordsFiles put: customKeywordsFiles size.

	customKeywordsFiles do: [ :keywordFile |
		self importCustomKeywordFromFile: keywordFile ].

	^ customKeywords
]

{ #category : 'imports' }
KTLModelImporter >> importsFromFolder: aPathOrString [ 
	
	|path ktlproject objectRepo |
	
	
	path := aPathOrString asPath. 
	ktlproject := model newProject name: (path segments last).
	ktlproject directoryPath: path. 
	
	objectRepo := self importsObjectRepositoryOfProject: ktlproject.
	self importsObjectDeclarationOfRepository: objectRepo. 
	
	self importsTestCasesOfProject: ktlproject.
	self flag: 'TODO: imports custom keywords declaration'.
	self importsCustomKeywordOfProject: ktlproject.
	
	self flag: 'TODO: imports global variable declaration'.
	self importGlobalVariableOfProject: ktlproject.
	
	self resolve. 
	
	^ ktlproject 
]

{ #category : 'as yet unclassified' }
KTLModelImporter >> importsImportStmt: aKTLImport [
	
	self importsStep: aKTLImport.
	
	
	^ aKTLImport
	
]

{ #category : 'imports' }
KTLModelImporter >> importsMethodCall: aKTLmethodCall [ 
	self importsStep: aKTLmethodCall.
	
	aKTLmethodCall item: ((aKTLmethodCall treeSitterNode namedChildAt: 1) textFromSourceText: sourcesStack top filePath contents ) .
	aKTLmethodCall input: ((aKTLmethodCall treeSitterNode namedChildAt: 2) textFromSourceText: sourcesStack top filePath contents ) .
	
	^ aKTLmethodCall.

]

{ #category : 'imports' }
KTLModelImporter >> importsMethodDef: aKTLmethodDef [ 
	| nodeIdentifier nodeParameters |
	self importsStep: aKTLmethodDef.
	  
	nodeIdentifier := aKTLmethodDef treeSitterNode namedChildAt: 1.
	nodeParameters := aKTLmethodDef treeSitterNode namedChildAt: 2.
	 
	aKTLmethodDef name: (nodeIdentifier textFromSourceText: sourcesStack top filePath contents).
	aKTLmethodDef parameters: (nodeParameters textFromSourceText: sourcesStack top filePath contents).
	 
	^ aKTLmethodDef.
	
]

{ #category : 'imports' }
KTLModelImporter >> importsObjectDeclarationOfRepository: aKTLObjectRepository [

	| filelocator rsFiles |
	rsFiles := Set new.

	filelocator := aKTLObjectRepository directoryPath
		               asFileLocatorOrReference.

	rsFiles := filelocator allChildren select: [ :f |
		           f isFile and: [ f extension = 'rs' ] ].
	
	metadata at: #objectRepositoryFiles put: rsFiles size.
	
	rsFiles do: [ :fileRs |
		(self parseObjectDeclarationFromRsFile: fileRs) ifNotNil: [ :obj |
			aKTLObjectRepository objectDeclarations add: obj ] ].


	^ aKTLObjectRepository objectDeclarations
]

{ #category : 'imports' }
KTLModelImporter >> importsObjectRepositoryOfProject: aKTLProject [ 
	|objectRepo path|
	
	path := aKTLProject directoryPath asFileLocatorOrReference allChildren detect: [ :f | f path segments last = 'Object Repository' ] ifNone: [ self error: 'no Object Repository found. Ensure this folder is a Katalon Project' ].
	
	path isDirectory ifTrue: [ 
		objectRepo := model newObjectRepository.
		objectRepo directoryPath: path.
		aKTLProject objectRepository: objectRepo. 
		 ] ifFalse: [self error: 'Object Repository is not a directory'].
	
	^ objectRepo 
	
]

{ #category : 'importer' }
KTLModelImporter >> importsStep: aKTLStep [ 
	^ self ensureStep: aKTLStep. 
	
]

{ #category : 'imports' }
KTLModelImporter >> importsTestCasesOfProject: aKTLProject [

	| scriptRepo scriptFiles |
	scriptRepo := aKTLProject directoryPath asFileLocatorOrReference
		              allChildren
		              detect: [ :f | f path segments last = 'Scripts' ]
		              ifNone: [
			              self error:
				              'no Scripts Repository found. Ensure this folder is a Katalon Project' ].

	scriptFiles := scriptRepo allChildren select: [ :f |
		               f extension = 'groovy' ].
	metadata at:#testCaseFiles put: scriptFiles size. 
	
	scriptFiles do: [ :groovyFile |
		aKTLProject addTestCase:
			(self parseTestCaseFromGroovyFile: groovyFile) ].
	^ aKTLProject testCases
]

{ #category : 'imports' }
KTLModelImporter >> importsTestStepOfScript: aKTLScriptGroovy [ 
	|testCaseImporter|
	
	testCaseImporter := KTLTestCaseImporter newFrom: self.
	testCaseImporter entityStack: Stack new.
	sourcesStack push: aKTLScriptGroovy. 
	
	testCaseImporter entityStack push: aKTLScriptGroovy testCase.
	testCaseImporter  importFromString: (aKTLScriptGroovy filePath asFileReference readStreamEncoded: 'utf8') contents.
	sourcesStack pop.  
	
	
]

{ #category : 'initialization' }
KTLModelImporter >> initialize [

	super initialize.
	metadata := Dictionary new. 
	parser := TSParser new.
	parser language: TSLanguage groovy..

	sourcesStack := Stack new. 
	resolver := Stack new
]

{ #category : 'accessing' }
KTLModelImporter >> metadata [
	^ metadata
]

{ #category : 'accessing' }
KTLModelImporter >> model [

	^ model
]

{ #category : 'accessing' }
KTLModelImporter >> model: anObject [

	model := anObject
]

{ #category : 'instance creation' }
KTLModelImporter >> newEntityFrom: aTSNode [ 
	|entity|
	
	"aTSNode textFromSourceText: sourcesStack top filePath contents".
	entity := (KTLFactory newFromType: aTSNode type).
	entity ifNotNil: [ currentNode := aTSNode ].
	^  entity . 
]

{ #category : 'parsing' }
KTLModelImporter >> parseCustomKeywordFile: aFileReference [

	| keywordClass importer |
	"use groovy parse on keyword declaraiton"
	keywordClass := KTLCustomKeywordClass new filePath: aFileReference.
	importer := KTLCostumKeywordImporterV3 newFrom: self.
	importer entityStack: Stack new.

	"importer entityStack: keywordClass."
	importer sourcesStack push: keywordClass.
	importer importFromTreeSitterTree:
		(importer parser parseString: aFileReference contents cleanToParse).

	importer sourcesStack pop
]

{ #category : 'parsing' }
KTLModelImporter >> parseObjectDeclarationFromRsFile: aFileReference [

	| objectName objtDecl identifier xmlDocument |
	xmlDocument := XMLDOMParser parse: aFileReference contents.
	xmlDocument root name = #WebElementEntity ifFalse: [
		self flag: 'current version only consider WebElementEntity object'.
		^ nil ].

	objectName := aFileReference path segments last copyUpToSubstring:
		              '.rs'.
	"objtDecl := KTLObjectDeclaration new
		            filePath: aFileReference;
		            name: objectName;
		            yourself.
	objtDecl := (model allWithType: KTLObjectDeclaration)
		            detect: [ :obj | obj filePath = aFileReference ]
		            ifNone: [ model add: objtDecl ]."
	identifier := ('/' join: (aFileReference path segments
			                copyFrom:
			                (aFileReference path segments indexOf:
				                 'Object Repository') + 1
			                to: aFileReference path segments size))
		              copyUpToSubstring: '.rs'.

	objtDecl := self ensureObjectDeclarationForIdentifier: identifier.
	objtDecl
		name: objectName;
		filePath: aFileReference.
	objtDecl identifierPath: identifier.


	[
	self parseXML: xmlDocument forLocaltorOfObject: objtDecl.
	self parseXML: xmlDocument forParentRefOfObject: objtDecl ]
		on: Exception
		do: [
			
		('Error when parsing XML' , aFileReference printString) traceCr
		 ].



	^ objtDecl
]

{ #category : 'parsing' }
KTLModelImporter >> parseProfileFromGlblFile: aFileReference [ 
	
	"parse object locator"
	| xmlDocument profileName|
	xmlDocument := XMLDOMParser parse: aFileReference contents.

	"check if its a global val only"
	xmlDocument root name = #GlobalVariableEntities ifFalse: [ 
		self flag: 'current version only consider GlobalVariableEntities'.
		^ nil ].

	profileName := (aFileReference pathSegments last withoutSuffix: '.glbl').	
	
	
	^ (xmlDocument root nodes elementsAt: #GlobalVariableEntity) collect: [ :elmt |
		|varName initValue description glbVar|
		
		varName := (elmt nodes elementAt: #name) nodes ifEmpty: [''] ifNotEmpty: [ :list | list first string ].
		initValue := (elmt nodes elementAt: #initValue) nodes ifEmpty: [''] ifNotEmpty: [ :list | list first ifNotNil: #string ].
		description := (elmt nodes elementAt: #description) nodes ifEmpty: [''] ifNotEmpty: [ :list | list first ifNotNil: #string ].
		

		glbVar := self ensureGlobalVariable: varName. 
		glbVar description: description.
		glbVar varProfiles at: profileName put: initValue.
		
		glbVar .
		
		 ].
]

{ #category : 'parsing' }
KTLModelImporter >> parseTestCaseFromGroovyFile: aGroovyFile [ 
	|script testCase testCaseName|
	script := KTLScriptGroovy new filePath: aGroovyFile; extension: 'groovy' ; yourself.
	script := (model allWithType: KTLScriptGroovy) detect: [ :obj | obj filePath = aGroovyFile ] ifNone: [ model add: script ].
	
	testCaseName := aGroovyFile path segments nextToLast  .
	testCase := KTLTestCase new name: testCaseName ;yourself.
	testCase := (model allWithType: KTLTestCase ) detect: [ :obj | obj name = testCaseName ] ifNone: [ model add: testCase ].

	testCase scriptGroovy: script.
	
	self importsTestStepOfScript: script.
	^ testCase 

]

{ #category : 'parsing' }
KTLModelImporter >> parseXML: xmlDocument forLocaltorOfObject: objtDecl [

	| selectMethod selectorCollection |
	selectorCollection := (((xmlDocument root elementAt:
		                         #selectorCollection) nodes elementsAt:
		                        #entry) collect: [ :anEntry |
		                       | key value |
		                       key := (anEntry elementAt: #key) nodes first
			                              string.
		                       value := (anEntry elementAt: #key)
			                                nextElement ifNotNil: [ :valueNode |
			                                valueNode nodes
				                                ifEmpty: [ nil ]
				                                ifNotEmpty: [ :nodes |
				                                nodes first string trim ] ].

		                       key -> value ]) asDictionary. "Access elements in the XML"

	"if a xpath value begins with only one slash, add another one"
	selectorCollection at: #XPATH ifPresent: [ :xpath |
		xpath ifNotNil: [
			((xpath beginsWith: '/') and: [ (xpath beginsWith: '//') not ])
				ifTrue: [ selectorCollection at: #XPATH put: '/' , xpath ] ] ].

	selectMethod := (xmlDocument root elementAt: #selectorMethod) nodes
		                first string.


	objtDecl locator: (selectorCollection
			 at: selectMethod
			 ifAbsent: [ selectorCollection anyOne ]).
	objtDecl locatorMethod: selectMethod.
	^ objtDecl. 
]

{ #category : 'parsing' }
KTLModelImporter >> parseXML: aXMLDocument forParentRefOfObject: aKTLObjectDeclaration [ 
		| webElementProperties parent|


		webElementProperties := (aXMLDocument root elementsAt:
		                         #webElementProperties) .
		
		"try to find a parent element in XML doc"
		webElementProperties do: [:aPropertyNode | 
			|ref|
			ref := aPropertyNode contentStringAt: #name.
			(ref = #'ref_element') ifTrue: [ 
										|elmtidentifier|
										elmtidentifier := aPropertyNode contentStringAt: #value.
										elmtidentifier := elmtidentifier withoutPrefix: 'Object Repository/'.
										parent := self ensureObjectDeclarationForIdentifier: elmtidentifier. 
										parent isShadow: false; isIFrame: true. 
										aKTLObjectDeclaration refObjParent: parent.
										 ]
			 ].
		
		"verify is parent is a shadow or an iFrame"
		parent ifNotNil: [ 
			webElementProperties do: [:aPropertyNode | 
			|ref|
			ref := aPropertyNode contentStringAt: #name.
			(ref = #'ref_element_is_shadow_root') ifTrue: [ 
				parent isShadow: true; isIFrame: false. 
			 ].
		].
	].

	^ aKTLObjectDeclaration. 
	
]

{ #category : 'accessing' }
KTLModelImporter >> parser [

	^ parser
]

{ #category : 'accessing' }
KTLModelImporter >> parser: anObject [

	parser := anObject
]

{ #category : 'pretreatment' }
KTLModelImporter >> pretreatAndImportsFromFolder: aString [ 

	^ self importsFromFolder: (self treatFolder: aString). 
	

]

{ #category : 'navigating' }
KTLModelImporter >> resolve [
	self resolveTestCaseReferencesInStep.
	self resolveObjectReferencesInStep. 
	self resolveLocalVariableAssignment. 
	self resolveGlobalVariableAssignment .
	self resolveLocalVariableRealDeclaration.
	self resolveCustomKeywordReferencesInStep.
	
]

{ #category : 'resolver' }
KTLModelImporter >> resolveCustomKeywordReferencesInStep [

	| steps customKeywords |
	steps := ((model allWithSubTypesOf: KTLTestStep) reject: [:step | step isKindOf: KTLStepBlock ]) select: [ :aStep |
		         aStep sourceText includesSubstring: 'CustomKeywords' ].
	steps := steps reject: [ :step | step isKindOf:KTLCommentStmt ].

	customKeywords := model allWithSubTypesOf: KTLCustomKeyword.

	steps do: [ :step |
		| candidate identifierPathInStep pkgName className keywordName code|
		self haltIf: [ step sourceText isNil ].
		code := step sourceText copyFrom: (step sourceText indexOfSubCollection: 'CustomKeywords') to: step sourceText size.
		
		identifierPathInStep := code trim withoutPrefix:
			                        'CustomKeywords.'''.
		identifierPathInStep := identifierPathInStep withoutPrefix:
			                        'CustomKeywords."'.
		identifierPathInStep := identifierPathInStep withoutSuffix: ''''.
		identifierPathInStep := identifierPathInStep withoutSuffix: '"'.

		identifierPathInStep := identifierPathInStep splitOn: '.'.

		identifierPathInStep size = 3 ifTrue: [
			pkgName := identifierPathInStep first ].
		className := identifierPathInStep nextToLast.
		keywordName := identifierPathInStep last.

		candidate := customKeywords
			             detect: [ :customKeyword |
				             | first |
				             first := customKeyword name = keywordName and: [
					                      customKeyword customKeywordClass name
					                      = className ].

				             customKeyword customKeywordClass package
					             ifNil: [ first ]
					             ifNotNil: [
					             first and: [
						             customKeyword customKeywordClass package = pkgName ] ] ]
			             ifNone: [ nil ].

		candidate ifNotNil: [ step addCustomKeyword: candidate ] ]
]

{ #category : 'resolve' }
KTLModelImporter >> resolveGlobalVariableAssignment [
	
	|assignments allVars|
	
	assignments := model allWithType: KTLAssignment.
	allVars := model allWithSubTypesOf: KTLGlobalVar .
	(assignments select: [:assign | assign item includesSubstring: 'GlobalVariable.' ]) do: [ :assign |
		| varName |

		varName := (assign item splitOn: '.') second  .

		allVars detect: [ :ktlVar | (ktlVar name = varName)   ] 
			ifFound: [ :ktlVar | assign addVariable: ktlVar.]  
			ifNone: [ self flag: 'global variable not declared'.].
		 ].
]

{ #category : 'resolve' }
KTLModelImporter >> resolveLocalVariableAssignment [
	
	|assignments allVars|
	
	assignments := model allWithType: KTLAssignment.
	allVars := model allWithSubTypesOf: KTLLocalVar.
	assignments do: [ :assign |
		| varName script|
	
		varName := assign item trim .
		script := assign scriptGroovy.
		"local variable are assignment where they are declared"
		allVars detect: [ :ktlVar | (ktlVar name = varName) and: [ script = ktlVar scriptGroovy ]  ] 
			ifFound: [ :ktlVar | assign addVariable: ktlVar.]  
			ifNone: [ 
				|varIdentifier var|
				varIdentifier := assign item trim.
				(varIdentifier includesSubstring: 'GlobalVariable.') 
					ifFalse: [ 
						"some katalon local var can be declared direcly from an assignment" 
						var := KTLLocalVar new 
								name: varIdentifier ; 
								type: ''; 
								initValue: assign input; 
								yourself .
							var assignments add: assign .
						model add: var. 
					 ].
			].
		 ].
]

{ #category : 'resolve' }
KTLModelImporter >> resolveLocalVariableRealDeclaration [
	
	| localVars|
	

	localVars := model allWithSubTypesOf: KTLLocalVar .
	
	(localVars select: [ :var | var declaration isNil ]) do: [ :var |
		|assignements|

		assignements := var assignments sort: [ :a :b | a index < b index ].
		assignements first isDeclaration: true.
		
		 ].
	
	
]

{ #category : 'resolver' }
KTLModelImporter >> resolveObjectReferencesInStep [

	| stepsFindTestObjects allObjectDecl |
	stepsFindTestObjects := ((model allWithSubTypesOf: KTLTestStep) reject: [ :step | step isKindOf: KTLStepBlock ])
		                        select: [ :step |
		                        step sourceText includesSubstring:
			                        'findTestObject(' ].

	allObjectDecl := model allWithSubTypesOf: KTLObjectDeclaration.


	stepsFindTestObjects do: [ :step |
		| candidateObject withoutFunctionKeyword |
		withoutFunctionKeyword := step sourceText.				                         

		candidateObject := allObjectDecl select: [ :obj |
			                   withoutFunctionKeyword
				                   includesSubstring: obj identifierPath
				                   caseSensitive: false ].


		"objets can have similar prefix in their name, but only the longest machting name object is kept."
		candidateObject := self filterObjectCandidates: candidateObject.

		candidateObject isEmpty ifTrue: [
			Transcript show: step sourceText , String cr ].

		candidateObject do: [ :candidate | "self haltIf: [ step sourceText includesSubstring: 'dragAndDropToObject' ]."
			candidate addTestStep: step ] ]
]

{ #category : 'resolve' }
KTLModelImporter >> resolveTestCaseReferencesInStep [

	| steps testCases |
	steps := ((model allWithSubTypesOf: KTLTestStep) reject: [ :step | step isKindOf: KTLStepBlock ]) select: [ :step |
		         step sourceText includesSubstring: 'findTestCase(' ].

	testCases := model allWithSubTypesOf: KTLTestCase.

	steps do: [ :aStep |
		| candidates |
		candidates := testCases select: [ :aTestCase |
			              |  |
			              "we include the final quotes to remove candidates with partial name included. 
				For instance: findTestCase('Commons_KDC/Login_KDC_site') --> Commons_KDC/Login_KDC or Commons_KDC/Login_KDC_site"
			              (aStep sourceText includesSubstring:
				               (aTestCase orginalIdentifierPath , '''' )caseSensitive: false) or: [
				              aStep sourceText includesSubstring:
					              (aTestCase orginalIdentifierPath, '"') caseSensitive:false ] ].
		candidates do: [ :aTestCase | aStep addTestCase: aTestCase ] ]
]

{ #category : 'accessing' }
KTLModelImporter >> sourcesStack [
	^ sourcesStack
]

{ #category : 'treat' }
KTLModelImporter >> treatFilesOfFolder: movedFolder [ 
		self treatGroovyFilesInFolder: movedFolder.
		self treatGlblFilesInFolder: movedFolder.
		self treatRsFilesInFolder: movedFolder.
		^ movedFolder
]

{ #category : 'traitement' }
KTLModelImporter >> treatFolder: originalFolder [ 
	|movedFolder|
	movedFolder := {''}, (originalFolder asFileReference asPath segments allButLast) , {(originalFolder asFileReference asPath segments last, '-copy')}.
	movedFolder := ('/' join: movedFolder) asFileReference.
	(movedFolder exists and: [ movedFolder hasChildren ]) ifFalse: [ 
		self copyFolder: originalFolder to: movedFolder. 
		self treatFilesOfFolder: movedFolder.
	].
	
	^ movedFolder
	
	
]

{ #category : 'pretreatment' }
KTLModelImporter >> treatGlblFilesInFolder: aFolder [ 
	"clean the global variable files"
	|files| 
	files := aFolder asFileLocatorOrReference allChildren select: [:f | f isFile and: [f extension = 'glbl']].
	files do: [ :file |
				file replaceContentWith: file contents withoutAccent.
		 ].
]

{ #category : 'pretreatment' }
KTLModelImporter >> treatGroovyFilesInFolder: aFolder [

	| groovyFiles |
	groovyFiles := aFolder asFileLocatorOrReference allChildren select: [
		               :f | f isFile and: [ f extension = 'groovy' ] ].


	groovyFiles do: [ :fileGroovy |
		| contents |
		contents := String crlf join:
			            (fileGroovy contents lines collect: [ :line |
				             | loc |
				             loc := line.
				             "some imports ending with semi-colon seems to cause troubles to the parser"
				             ((line trim beginsWith: 'import') and: [
					              line trim endsWith: ';' ]) ifTrue: [
					             loc := line trim removeSuffix: ';' ].
				             "Katalon groovy has keyword description using simple quote instead of //"
				             ((line trim beginsWith: '''') and: [
					              line trim endsWith: '''' ]) ifTrue: [
					             loc := '// ' , line trim ].
				              (loc trim beginsWith: '/**') ifTrue: [ 
					             loc := '/* ' , (loc trim allButFirst: 3) ].
									

				             "turns identifier in dotted identifier for function call"
				             "case of println"
				             (loc trim beginsWith: 'println') ifTrue: [
					             loc := 'System.out.' , loc trim ].


				             "FOR METADATA"
				             line = loc ifFalse: [
					             metadata
						             at: #treated_Groovy_LoC
						             ifPresent: [ :v |
						             metadata at: #treated_Groovy_LoC put: v + 1 ]
						             ifAbsentPut: [ 1 ] ].


				             loc ]).

		fileGroovy replaceContentWith: contents withoutAccent ]
]

{ #category : 'pretreatment' }
KTLModelImporter >> treatRsFilesInFolder: aFolder [ 
	
	|files| 
	files := aFolder asFileLocatorOrReference allChildren select: [:f | f isFile and: [f extension = 'rs']].
	files do: [ :file |
				file replaceContentWith: file contents withoutAccent.
		 ].
]

{ #category : 'accessing' }
KTLModelImporter >> visitor [

	^ visitor
]

{ #category : 'accessing' }
KTLModelImporter >> visitor: anObject [

	visitor := anObject
]
