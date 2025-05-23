Class {
	#name : 'KTLModelExporter',
	#superclass : 'Object',
	#instVars : [
		'katalonProject',
		'model',
		'exportFolder',
		'objectDirectoryPath',
		'scriptsRepositoryPath',
		'exportWithOriginalLines',
		'exportWithDebug',
		'customKeywordRepositoryPath',
		'gitlabApi',
		'objectRegistery'
	],
	#category : 'Katalon-Model-Exporter',
	#package : 'Katalon-Model-Exporter'
}

{ #category : 'adding' }
KTLModelExporter >> addLibFiles [

	| libFolder failureFile keysFile webUiFile |
	libFolder := self ensureSubDirectory: 'tests/Lib'.
	failureFile := (libFolder / 'FailureHandling.ts') asFileReference
		               ensureCreateFile.
	keysFile := (libFolder / 'Keys.ts') asFileReference ensureCreateFile.
	webUiFile := (libFolder / 'WebUI.ts') asFileReference
		             ensureCreateFile.


	failureFile replaceContentWith: (gitlabApi
			 getRawFile: 'tests/Ex_migration/Lib/FailureHandling.ts'
			 ofProject: 6891).
	keysFile replaceContentWith: (gitlabApi
			 getRawFile: 'tests/Ex_migration/Lib/Keys.ts'
			 ofProject: 6891).
	webUiFile replaceContentWith: (gitlabApi
			 getRawFile: 'tests/Ex_migration/Lib/WebUI.ts'
			 ofProject: 6891)
]

{ #category : 'export' }
KTLModelExporter >> collectImportsForCustomKeywordClass: aKTLCustomKeywordClass [

	| testSteps |
	testSteps := aKTLCustomKeywordClass customKeywords flatCollect: [ :ck |
		             ck testSteps ].

	^ String crlf join: {
			  (self exportImportDeclarationForSubClassCustomKeywords:
				   aKTLCustomKeywordClass subClasses).
			  (self exportImportDeclarationForObjects:
				   (testSteps flatCollect: #objectDeclarations)).
			  (self exportImportDeclarationForTestCase:
				   (testSteps flatCollect: #testCases)) }
]

{ #category : 'create-file' }
KTLModelExporter >> createTsConfigJson [
	|tsFile|
	tsFile := exportFolder / ('tsconfig.json').
	tsFile asFileReference ensureCreateFile.
	tsFile writeStreamDo: [ :stream | stream nextPutAll: '{
    "compilerOptions": {
      "baseUrl": ".", 
      "paths": {
        "Object Repository/*": ["./tests/Object Repository/*"],
        "Lib/*": ["./tests/Lib/*"],
        "GlobalVariable": ["./tests/GlobalVariable"],
        "CustomKeywords/*": ["./tests/CustomKeywords/*"],
		  "Scripts/*": ["./tests/Scripts/*"],
      },      
    }
}' ].
]

{ #category : 'export - error' }
KTLModelExporter >> ensureErrorFileForTestCase: aTestCase [ 
		| specTsFile tsFile specTsfileContent objectDeclToImport ogFile ogPath testCaseToImport customKeywordImport |
	
	
		specTsfileContent := String new writeStreamDo: [:s |
			s << '// ***********************************************************'; cr.
			s << '//              /!\         WARNING             /!\           '; cr.
			s << '//                   KATALON2PLAYWRIGHT TOOL                  '; cr.
			s << '//  ERROR WHEN PARSING THIS FILE ! MANUAL MIGRATION REQUIRED'; cr.
			s << '//         SEE ORGINAL GROOVY CONTENT BELOW. sorry'; cr.
			s << '// ************************************************************'; cr.
			s cr; cr.
			s << aTestCase scriptGroovy filePath contents
			].
	
	"remettre laborescence de fichier d origine"
	ogFile := aTestCase scriptGroovy filePath.
	ogPath := ogFile asPath segments
		          copyFrom: (ogFile asPath segments indexOf: 'Scripts') + 1
		          to: (ogFile asPath segments indexOf: aTestCase name) - 1.

	specTsFile := scriptsRepositoryPath.
	ogPath ifNotEmpty: [
		specTsFile := scriptsRepositoryPath / ('/' join: ogPath) ].

	"optional file contening the export test function"
	tsFile := specTsFile / (aTestCase name , '.ts').

	"mandatory file contening the testCase"
	specTsFile := specTsFile / (aTestCase name , '.spec.ts').

	specTsFile asFileReference ensureCreateFile.
	specTsFile writeStreamDo: [ :stream |
		stream nextPutAll: specTsfileContent contents ].

	^ specTsFile
]

{ #category : 'export' }
KTLModelExporter >> ensureFileForCustomKeywordClass: aKTLCustomKeywordClass [

	| tsFile fileContent objectDeclToImport |
	objectDeclToImport := self collectImportsForCustomKeywordClass:
		                      aKTLCustomKeywordClass.


	fileContent := String new writeStream.
	fileContent
		<< 'import { test, expect } from ''@playwright/test'';';
		cr;
		<< 'import { GlobalVariable } from ''GlobalVariable'';';
		cr;
		<< 'import { WebUILib } from ''Lib/WebUI'';';
		cr;
		<< 'import {FailureHandling} from ''Lib/FailureHandling'';';
		cr;
		<< 'import { Keys } from ''Lib/Keys'';';
		cr;
		cr.


	fileContent
		<< objectDeclToImport;
		cr;
		cr.

	fileContent
	<< (self exportCustomKeywordClassContent: aKTLCustomKeywordClass)
			contents.


	tsFile := customKeywordRepositoryPath.
	aKTLCustomKeywordClass package isNotNil
		ifTrue: [
			tsFile := tsFile / aKTLCustomKeywordClass package
			          / (aKTLCustomKeywordClass name , '.ts') ]
		ifFalse: [ tsFile := tsFile / (aKTLCustomKeywordClass name , '.ts') ].

	tsFile asFileReference ensureCreateFile.
	tsFile writeStreamDo: [ :stream |
		stream nextPutAll: fileContent contents ].

	^ tsFile
]

{ #category : 'export' }
KTLModelExporter >> ensureGlobalVarFileFor: globalVars [

	| tsFile contents exportedVarNames profileDico exportVarProfiles |
	globalVars isEmpty ifTrue: [ ^ self ].

	contents := String new writeStream.
	contents
		nextPutAll: 'export class GlobalVariable {';
		cr.

	tsFile := exportFolder / 'tests' / 'GlobalVariable.ts'.
	tsFile asFileReference ensureCreateFile.

	"order var by profile for export"
	profileDico := self orderGlobalVarsByProfile: globalVars.

	"first write all var name"
	exportedVarNames := String new writeStream.
	globalVars do: [ :var |
		exportedVarNames
			nextPutAll: 'static ';
			<< var name;
			<< ';';
			cr ].
	contents
		nextPutAll: exportedVarNames contents;
		cr;
		cr.

	"then each static profile starting with default"
	exportVarProfiles := String new writeStream.
	exportVarProfiles
		nextPutAll: 'static {';
		cr;
		<< ' //default value';
		cr.
	profileDico at: #default ifPresent: [:value|
		value do: [ :var |
		exportVarProfiles
			<< String tab;
			<< 'this.';
			<< var name;
			<< ' = ';
			<< (var varProfiles at: #default);
			<< ';';
			cr ].
	profileDico removeKey: #default.
	].


	exportVarProfiles
		<< ' switch(process.env.profil) {';
		cr.
	profileDico associationsDo: [ :assoc |
		| profileName itsVars |
		(exportVarProfiles << String tab)
			<< '//value for each profile';
			cr.
		profileName := assoc key.
		itsVars := assoc value.
		exportVarProfiles
			<< 'case "';
			<< profileName;
			<< '" :';
			cr.
		itsVars do: [ :var |
			exportVarProfiles
				<< String tab;
				<< String tab;
				<< 'this.';
				<< var name;
				<< ' = ';
				<< (var varProfiles at: profileName);
				<< ';';
				cr ].
		exportVarProfiles
			<< 'break';
			cr ].

	contents
		<< exportVarProfiles contents;
		cr;
		<< '}';
		cr.

	"closes the static"
	contents
		cr;
		<< '}'.

	"closes export class GlobalVariable"
	contents
		cr;
		<< '}'.


	tsFile replaceContentWith: contents contents
]

{ #category : 'as yet unclassified' }
KTLModelExporter >> ensureObjectRepositoryFileForObjects: objets withName: objectIdentifier [

	| tsFile objectStmt fileContent objGrpName parentsToImport importStmts |
	parentsToImport := Set new.
	
	"objGrpName := (objectIdentifier splitOn: '/') last ""'PageBergerLevraultCcede3010ConectadoE41650'""."
	objGrpName := objets first groupName "'PageBergerLevraultCcede3010ConectadoE41650'".

	objectStmt := objets collect: [ :object |
		              | objectName objectLocator loc |
		              objectName := object name normalizeIdentifier.
		              objectLocator := object locator ifNil: [
			                               'TODO object locator' ].
		              objectLocator := '\"' join:
			                               (objectLocator splitOn: '"').
		              objectLocator := '' join:
			                               (objectLocator lines collect: #trim).


		              object hasRefParent
			              ifTrue: [
				              | parent |
				              parent := object refObjParent.
				              parentsToImport add: parent.
				              parent isIFrame ifTrue: [
					              loc := objectName
					                     ,
					                     ' : async (WebUI : WebUILib) => {return (await '
					                     , ('.' join: {
								                      parent groupName.
								                      parent name normalizeIdentifier })
					                     , '(WebUI)).contentFrame().locator("'
					                     , objectLocator , '"); }' ].
				              parent isShadow ifTrue: [
					              self flag: 'TODO  Shadow export '.
					              loc := objectName
					                     ,
					                     ' : async (WebUI : WebUILib) => {return (await '
					                     , 'TODO_SHADOW_EXPORT'
					                     , '(WebUI)).locator("' , objectLocator
					                     , '"); }' ] ]
			              ifFalse: [
				              loc := objectName
				                     ,
				                     ' : async (WebUI : WebUILib) => {return WebUI.getPage().locator("'
				                     , objectLocator , '"); }' ].
		              loc ].

	objectStmt := ',' , String crlf join: objectStmt asSet.

	importStmts := self exportImportDeclarationForObjects:
		               (parentsToImport reject: [ :prt |
			                prt groupName = objGrpName ]).

	fileContent := String new writeStream.
	fileContent
		nextPutAll: 'import { Page } from ''@playwright/test''; ';
		cr;
		nextPutAll: 'import { WebUILib } from ''Lib/WebUI'';';
		cr;
		nextPutAll: importStmts;
		cr;
		cr;
		cr;
		nextPutAll: 'export const ';
		nextPutAll: objGrpName , ' = { ';
		cr;
		nextPutAll: objectStmt;
		cr;
		nextPutAll: '}'.


	"remettre laborescence de fichier d origine"
	"ogFile := objets anyOne filePath. 
	ogPath := ogFile asPath segments copyFrom: (ogFile asPath segments indexOf: #'Object Repository')+1 to: (ogFile asPath segments size -2)."
	"tsFile := objectDirectoryPath."
	"ogPath ifNotEmpty: [ tsFile := objectDirectoryPath / ('/' join: ogPath ).  ]."

	tsFile := objectDirectoryPath / (objectIdentifier , '.ts').
	tsFile asFileReference ensureCreateFile.
	tsFile writeStreamDo: [ :stream |
		stream nextPutAll: fileContent contents ].

	^ tsFile
]

{ #category : 'testcase' }
KTLModelExporter >> ensureScriptFilesForTestCases: aTestCaseCollection [

	aTestCaseCollection do: [ :testCase |
		
	"	self haltIf: [ testCase name = '24_Crear_un_registro_de_entrada_a_un_puesto_o_cargo_unidad_organica_cert' ]."
		
		testCase
			ifParsingError: [ self ensureErrorFileForTestCase: testCase ]
			ifNot: [
				testCase isCalledTestCase
					ifTrue: [ "must create two file:  spec.ts and a ts file "
						self exportSpecAndTSFileForTestCase: testCase ]
					ifFalse: [ self ensureUnifySpecTsFileForTestCase: testCase ] ] ]
]

{ #category : 'testcase' }
KTLModelExporter >> ensureSpecTsFileForTestCase: aKTLTestCase [

	| specTsFile specTsfileContent ogFile ogPath |
	specTsfileContent := String new writeStream.


	specTsfileContent
		<< self genericImportDeclaration;
		cr;
		<< (self exportImportDeclarationForTestCase: { aKTLTestCase });
		cr;
		cr;
		<< ('// Katalon ' , aKTLTestCase scriptGroovy filePath printString);
		cr;
		<< (self exportTestCaseSignatureDecl: aKTLTestCase);
		cr;
		<< 'const WebUI = new WebUILib(page)';
		cr;
		<< ('await ' , aKTLTestCase name normalizeIdentifier , '(WebUI);');
		cr;
		<< '});';
		cr;
		cr.

	"remettre laborescence de fichier d origine"
	ogFile := aKTLTestCase scriptGroovy filePath.
	ogPath := ogFile asPath segments
		          copyFrom: (ogFile asPath segments indexOf: 'Scripts') + 1
		          to:
		          (ogFile asPath segments indexOf: aKTLTestCase name) - 1.

	specTsFile := scriptsRepositoryPath.
	ogPath ifNotEmpty: [
		specTsFile := scriptsRepositoryPath / ('/' join: ogPath) ].


	"mandatory file contening the testCase"
	specTsFile := specTsFile / (aKTLTestCase name , '.spec.ts').

	specTsFile asFileReference ensureCreateFile.
	specTsFile writeStreamDo: [ :stream |
		stream nextPutAll: specTsfileContent contents ].


	^ specTsFile
]

{ #category : 'testcase' }
KTLModelExporter >> ensureSpecTsFilesForTestCase: aTestCase [

	| specTsFile tsFile specTsfileContent objectDeclToImport ogFile ogPath testCaseToImport customKeywordImport |
	self
		deprecated:
		'Use ensureUnifySpecTsFileForTestCase: instead of current one'
		on: '23 January 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1546.sha.30427d35e51ff0351e1dc860306faf36d9d8931c (64 Bit)'.
	objectDeclToImport := (aTestCase scriptGroovy testSteps flatCollect: [
		                       :step | step objectDeclarations ]) asSet.
	testCaseToImport := (aTestCase scriptGroovy testSteps flatCollect: [
		                     :step | step testCases ]) asSet.
	customKeywordImport := (aTestCase scriptGroovy testSteps
		                        flatCollect: [ :step | step customKeywords ])
		                       asSet.


	1 halt.
	specTsfileContent := String new writeStream.
	specTsfileContent
		<< self genericImportDeclaration;
		<< (self exportImportDeclarationForObjects: objectDeclToImport);
		cr;
		cr;
		<< (self exportImportDeclarationForTestCase: testCaseToImport);
		cr;
		cr;
		<<
			(self exportImportDeclarationForCustomKeywords: customKeywordImport);
		cr;
		cr;
		<< ('// Katalon ' , aTestCase scriptGroovy filePath printString);
		cr.

	specTsfileContent << (self exportSpecTsTestCaseScriptBody: aTestCase).


	"remettre laborescence de fichier d origine"
	ogFile := aTestCase scriptGroovy filePath.
	ogPath := ogFile asPath segments
		          copyFrom: (ogFile asPath segments indexOf: 'Scripts') + 1
		          to: (ogFile asPath segments indexOf: aTestCase name) - 1.

	specTsFile := scriptsRepositoryPath.
	ogPath ifNotEmpty: [
		specTsFile := scriptsRepositoryPath / ('/' join: ogPath) ].

	"optional file contening the export test function"
	tsFile := specTsFile / (aTestCase name , '.ts').

	"mandatory file contening the testCase"
	specTsFile := specTsFile / (aTestCase name , '.spec.ts').

	specTsFile asFileReference ensureCreateFile.
	specTsFile writeStreamDo: [ :stream |
		stream nextPutAll: specTsfileContent contents ].


	^ specTsFile
]

{ #category : 'as yet unclassified' }
KTLModelExporter >> ensureSubDirectory: aString [ 
	|rootDir|

	rootDir := exportFolder asFileLocatorOrReference.
	
	(aString splitOn: '/') do: [:dir |
		rootDir := (rootDir asFileLocatorOrReference / dir) createDirectory
		].
	
	^ rootDir
	
]

{ #category : 'testcase' }
KTLModelExporter >> ensureTsExportFunctionFileForTestCase: aKTLTestCase [

	| specTsFile specTsfileContent objectDeclToImport ogFile ogPath testCaseToImport customKeywordImport |
	objectDeclToImport := (aKTLTestCase scriptGroovy testSteps
		                       flatCollect: [ :step |
		                       step objectDeclarations ]) asSet.



	self resolveMultipleNamingOfObjects: objectDeclToImport.
	

	testCaseToImport := (aKTLTestCase scriptGroovy testSteps
		                     flatCollect: [ :step | step testCases ]) asSet.
	customKeywordImport := (aKTLTestCase scriptGroovy testSteps
		                        flatCollect: [ :step | step customKeywords ])
		                       asSet.


	specTsfileContent := String new writeStream.
	specTsfileContent
		<< self genericImportDeclaration;
		<< (self exportImportDeclarationForObjects: objectDeclToImport);
		cr;
		cr;
		<< (self exportImportDeclarationForTestCase: testCaseToImport);
		cr;
		cr;
		<<
			(self exportImportDeclarationForCustomKeywords: customKeywordImport);
		cr;
		cr;
		<< '// EXPORT FUNCTION';
		cr;
		<< ('// of Test Case ' , aKTLTestCase name , '.spec.ts');
		cr.
	specTsfileContent
	<< (self exportTestCaseBodyAsExportFunction: aKTLTestCase).



	"remettre laborescence de fichier d origine"
	ogFile := aKTLTestCase scriptGroovy filePath.
	ogPath := ogFile asPath segments
		          copyFrom: (ogFile asPath segments indexOf: 'Scripts') + 1
		          to:
		          (ogFile asPath segments indexOf: aKTLTestCase name) - 1.

	specTsFile := scriptsRepositoryPath.
	ogPath ifNotEmpty: [
		specTsFile := scriptsRepositoryPath / ('/' join: ogPath) ].


	"mandatory file contening the testCase"
	specTsFile := specTsFile / (aKTLTestCase name , '.ts').

	specTsFile asFileReference ensureCreateFile.
	specTsFile writeStreamDo: [ :stream |
		stream nextPutAll: specTsfileContent contents ].

	self resetMultipleNamingOfObjects: objectDeclToImport.

	^ specTsFile
]

{ #category : 'testcase' }
KTLModelExporter >> ensureUnifySpecTsFileForTestCase: aTestCase [

	| specTsFile tsFile specTsfileContent objectDeclToImport ogFile ogPath testCaseToImport customKeywordImport |
	objectDeclToImport := ((aTestCase scriptGroovy allToAnyScope:
		                        KTLTestStep allSubclasses) flatCollect: [
		                       :step | step objectDeclarations ]) asSet.


	self resolveMultipleNamingOfObjects: objectDeclToImport.


	testCaseToImport := ((aTestCase scriptGroovy allToAnyScope:
		                      KTLTestStep allSubclasses) flatCollect: [
		                     :step | step testCases ]) asSet.

	customKeywordImport := ((aTestCase scriptGroovy allToAnyScope:
		                         KTLTestStep allSubclasses) flatCollect: [
		                        :step | step customKeywords ]) asSet.

	specTsfileContent := String new writeStream.
	specTsfileContent
		<< self genericImportDeclaration;
		<< (self exportImportDeclarationForObjects: objectDeclToImport);
		cr;
		cr;
		<< (self exportImportDeclarationForTestCase: testCaseToImport);
		cr;
		cr;
		<<
			(self exportImportDeclarationForCustomKeywords: customKeywordImport);
		cr;
		cr;
		<< ('// Katalon ' , aTestCase scriptGroovy filePath printString);
		cr.

	specTsfileContent << (self exportSpecTsTestCaseScriptBody: aTestCase).



	"remettre laborescence de fichier d origine"
	ogFile := aTestCase scriptGroovy filePath.
	ogPath := ogFile asPath segments
		          copyFrom: (ogFile asPath segments indexOf: 'Scripts') + 1
		          to: (ogFile asPath segments indexOf: aTestCase name) - 1.

	specTsFile := scriptsRepositoryPath.
	ogPath ifNotEmpty: [
		specTsFile := scriptsRepositoryPath / ('/' join: ogPath) ].

	"optional file contening the export test function"
	tsFile := specTsFile / (aTestCase name , '.ts').

	"mandatory file contening the testCase"
	specTsFile := specTsFile / (aTestCase name , '.spec.ts').

	specTsFile asFileReference ensureCreateFile.
	specTsFile writeStreamDo: [ :stream |
		stream nextPutAll: specTsfileContent contents ].

	self resetMultipleNamingOfObjects: objectDeclToImport.
	^ specTsFile
]

{ #category : 'public' }
KTLModelExporter >> export [

	self createTsConfigJson.

	self exportObjectRepository.

	self exportScripts.

	self exportGlobalVariables.

	self exportCustomKeywords.
	
	gitlabApi ifNotNil: [ self addLibFiles ].
	 
]

{ #category : 'export' }
KTLModelExporter >> exportAssignment: aKTLAssignment [ 
	|loc type|
	
	
	type := aKTLAssignment isDeclaration ifTrue: [ 'var ' ] ifFalse: [ '' ].
	loc := type ,  (self exportFindStmtInStep: aKTLAssignment) .
	
	^ loc
]

{ #category : 'as yet unclassified' }
KTLModelExporter >> exportCustomKeywordAsString: aKTLCustomKeyword [

	| stmts parameters |
	

	
	stmts := String new writeStream.

	parameters := '('
	              ,
	              (self exportCustomKeywordParmeters: aKTLCustomKeyword)
	              , ')'.


	stmts
		<< aKTLCustomKeyword name;
		<< ': async ';
		<< parameters;
		<< (' : Promise<' , aKTLCustomKeyword returnType , '> => {');
		cr.

	stmts
		<< (self exportstepsAsString: aKTLCustomKeyword testSteps);
		cr.
	stmts << '}'.

	^ stmts contents
]

{ #category : 'as yet unclassified' }
KTLModelExporter >> exportCustomKeywordClassContent: aKTLCustomKeywordClass [
	"comment stating purpose of instance-side method"

	"scope: class-variables  &  instance-variables"

	| fileContent customKeywordStmt customKeywordAttribut |
	fileContent := String new writeStream.
	fileContent
		<< ('export const ' , aKTLCustomKeywordClass identifier , ' = {');
		cr.

	customKeywordAttribut := aKTLCustomKeywordClass
		                         customKeywordClassAttributes collect: [
		                         :keyword |
		                         self exportKTLDeclaration: keyword ].

	customKeywordStmt := aKTLCustomKeywordClass customKeywords collect: [
		                     :keyword |
		                     self exportCustomKeywordAsString: keyword ].


	fileContent
		<< customKeywordAttribut;
		cr.
	fileContent
	<< (',' , String crlf , String crlf join: customKeywordStmt).



	fileContent
		<< '};';
		cr.

	^ fileContent
]

{ #category : 'export' }
KTLModelExporter >> exportCustomKeywordInLoc: aString fromStep: aStep [

	| loc |
	loc := aString.

	aStep customKeywords do: [ :kw |
		| invocation splits prefix suffix |
		invocation := self rebuildCustomKeywordInvocation: kw.
		splits := loc splitOn: invocation.
		prefix := splits first withoutSuffix: 'CustomKeywords.'''.
		suffix := splits last withoutPrefix: '''('.

		suffix trim first = $) ifFalse: [ 
			suffix :=  (', ', suffix). 
			 ].

		loc := '{1}{2}.{3}(WebUI {4}' format: {
				       prefix.
				       kw customKeywordClass identifier.
				       kw name.
				       suffix } ].


	^ loc
]

{ #category : 'as yet unclassified' }
KTLModelExporter >> exportCustomKeywordParmeters: aKTLCustomKeyword [

	| parameters |
	parameters := ((aKTLCustomKeyword parameters withoutPrefix: '(')
		               withoutSuffix: ')') trim
		              ifEmpty: [ 'WebUI: WebUILib' ]
		              ifNotEmpty: [ :v |
			              ',' join: {
					              'WebUI: WebUILib' . v } ].
	^ parameters
]

{ #category : 'export' }
KTLModelExporter >> exportCustomKeywords [
	|keywords|
		customKeywordRepositoryPath := self ensureSubDirectory: 'tests/CustomKeywords'.
		keywords := katalonProject mooseModel allWithType: KTLCustomKeywordClass.
		keywords do: [ :keywordClass |
			self ensureFileForCustomKeywordClass: keywordClass.
			 ].
		
]

{ #category : 'export' }
KTLModelExporter >> exportFindStmtInStep: step [

	| loc  |
	loc := '' join: (step sourceText lines collect: #trim).
	
^ self exportFindStmtInStep: step withLoc: loc.
]

{ #category : 'export' }
KTLModelExporter >> exportFindStmtInStep: step withLoc: original [

	| loc |
	loc := original.

	"	self haltIf: [
		step sourceText includesSubstring:
			'WebUI.setText(findTestObject(''formerror/input_Formulaire_Prenom''), WebUI.getAttribute(findTestObject(''formerror/input_Formulaire_Prenom'')' ]."

	loc := self newExportFindTestObjectInLoc: loc fromStep: step.
	loc := self newExportFindTestCaseInLoc: loc fromStep: step.
	loc := self exportCustomKeywordInLoc: loc fromStep: step.
	loc := self removeFNKeywordInLoC: loc fromStep: step.


	^ ('await WebUI.' join: (loc splitOn: 'WebUI.')) , ';'
]

{ #category : 'export' }
KTLModelExporter >> exportFindTestCaseInLoc: aString fromStep: aStep [

	| loc |
	self
		deprecated:
		'Use newExportFindTestCaseInLoc:fromStep: instead of current one'
		on: '27 February 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1546.sha.30427d35e51ff0351e1dc860306faf36d9d8931c (64 Bit)'.

	^ self newExportFindTestCaseInLoc: aString fromStep: aStep.

	loc := aString.
	(loc includesSubstring: 'findTestCase(') ifFalse: [ ^ loc ].


	"some steps could have multiple calls to findTestObject()"
	"transform findTestObject statement into an TS object call"
	aStep testCases do: [ :aTestCase |
		| splits prefix suffix |
		splits := loc splitOn: aTestCase orginalIdentifierPath.
		prefix := ((splits at: 1) withoutSuffix:
			           'WebUI.callTestCase(findTestCase(''') withoutSuffix:
			          'WebUI.callTestCase(findTestCase("'.
		suffix := ((splits at: 2) withoutPrefix: '"') withoutPrefix: ''''.

		loc := '{1} {2}(WebUI)' format: {
				       prefix.
				       aTestCase name normalizeIdentifier } ].
	^ loc
]

{ #category : 'export' }
KTLModelExporter >> exportFindTestObjectInLoc: aString fromStep: aStep [

	| loc |
	
	^ self newExportFindTestObjectInLoc: aString fromStep: aStep.
	
	loc := aString.
	(loc includesSubstring: 'findTestObject(') ifFalse: [ ^ loc ].

	(loc includesSubstring: 'Object Repository/') ifTrue: [
		loc := loc copyReplaceAll: 'Object Repository/' with: '' ].
	(loc includesSubstring: 'findTestObject(null)') ifTrue: [
		loc := loc copyReplaceAll: 'findTestObject(null)' with: 'null' ].

	"some steps could have multiple calls to findTestObject()"
	"transform findTestObject statement into an TS object call"
	aStep objectDeclarations do: [ :objectDecl |
		| objectId splits prefix suffix |
		objectId := objectDecl identifierPath splitOn: '/'.

		splits := loc splitOn: objectDecl identifierPath.
		prefix := ((splits at: 1) withoutSuffix: 'findTestObject("')
			          withoutSuffix: 'findTestObject('''.
		suffix := ((splits at: 2) withoutPrefix: '"') withoutPrefix: ''''.

		loc := ' {1} await {2}.{3}(WebUI{4}' format: {
				       prefix.
				       objectId nextToLast normalizeIdentifier.
				       objectId last normalizeIdentifier.
				       suffix } ].
	^ loc
]

{ #category : 'accessing' }
KTLModelExporter >> exportFolder [
	^ exportFolder .
]

{ #category : 'accessing' }
KTLModelExporter >> exportFolder: aPath [
	aPath asFileReference createDirectory .
	exportFolder := aPath asFileReference.

	 
	
]

{ #category : 'accessing' }
KTLModelExporter >> exportGlobalVariables [
		| globalVars |
	scriptsRepositoryPath := self ensureSubDirectory: 'tests'.
		globalVars := katalonProject globalVars.
		self ensureGlobalVarFileFor: globalVars. 
		
]

{ #category : 'export' }
KTLModelExporter >> exportImportDeclarationForCustomKeywords: aTestStepCollection [

	| imports |
	
	
	imports := aTestStepCollection collect: [ :obj |
		           | objectPath |
		           objectPath := '/' join: ({
				                          'CustomKeywords'.
				                          obj customKeywordClass package.
				                          obj customKeywordClass name } reject:
				                          #isNil).
		           'import { ' , obj customKeywordClass identifier
		           , ' } from ''' , objectPath , ''';' ].

	imports := String crlf join: imports asSet.


	^ imports
]

{ #category : 'export' }
KTLModelExporter >> exportImportDeclarationForObjects: aKTLobjectDeclarations [

	| imports objExports|
	
	objExports := Dictionary new. 

	
	imports := aKTLobjectDeclarations collect: [ :obj |
		           | objectGrp objectPath |
		
		           objectGrp := obj groupName.
		
		 			  "objExports at: [ objectGrp ] ifPresent: [  ] ifAbsentPut: [ obj ]"
		           objectPath := 'Object Repository/' , ('/' join:
			                          ((obj identifierPath splitOn: '/')
				                           allButLast collect: [ :path |
				                           path normalizeIdentifier ])).

		           'import { ' , obj printForImportStmt
		           , ' } from ''' , objectPath , ''';' ].

	imports := String crlf join: imports asSet.

	^ imports
]

{ #category : 'export - import' }
KTLModelExporter >> exportImportDeclarationForSubClassCustomKeywords: aCollection [ 

	| imports |
	
	
	imports := aCollection collect: [ :obj |
		           | objectPath |
		           objectPath := '/' join: ({
				                          'CustomKeywords'.
				                          obj  package.
				                          obj  name } reject:
				                          #isNil).
		           'import { ' , obj identifier , ' as ',  obj name
		           , ' } from ''' , objectPath , ''';' ].

	imports := String crlf join: imports asSet.


	^ imports
]

{ #category : 'export' }
KTLModelExporter >> exportImportDeclarationForTestCase: aTestCaseCollection [

	| imports |
	imports := aTestCaseCollection collect: [ :obj |
		           | objectPath |
		           objectPath := 'Scripts/' , obj orginalIdentifierPath.
		           'import { ' , obj name normalizeIdentifier , ' } from '''
		           , objectPath , ''';' ].

	imports := String crlf join: imports asSet.


	^ imports
]

{ #category : 'export - try/catch' }
KTLModelExporter >> exportKTLCatch: aKTLCatchStmt [

	| export |
	export := String new writeStreamDo: [ :st |
		          st
			          << 'catch ( ';
			          << aKTLCatchStmt exception sourceText;
			          << ' )'.
		          st
			          << (aKTLCatchStmt catch exportWith: self);
			          << String cr ].

	^ export contents
]

{ #category : 'as yet unclassified' }
KTLModelExporter >> exportKTLClosure: aKTLClosure [
	^ (String new writeStreamDo: [ :st |
		st << '{'; cr.
		st <<	(String cr join: (aKTLClosure steps collect: [ :step | step exportWith: self ])); cr.
		st << '}';cr.
		 ]) contents.
]

{ #category : 'export' }
KTLModelExporter >> exportKTLComment: aKTLComment [

	^  aKTLComment sourceText .
]

{ #category : 'export' }
KTLModelExporter >> exportKTLDeclaration: aKTLDeclaration [ 
	|loc var |


	var := aKTLDeclaration variable ifNil: [1 halt. ^ aKTLDeclaration sourceText].
	
	loc := 'var ', var name , ' = ' , (self exportFindStmtInStep: aKTLDeclaration withLoc: (var initValue)). 
	
	^ loc
]

{ #category : 'export - loop' }
KTLModelExporter >> exportKTLForStmt: aKTLForStmt [ 
	|export|
	export := String new writeStreamDo: [ :st |
		st << 'for'; << aKTLForStmt condition.
		 ].
	
	export << (self exportKTLLoop: aKTLForStmt).
	
	^ export contents. 
	
	
]

{ #category : 'export' }
KTLModelExporter >> exportKTLIfDecisionStmt: aKTLIfDecisionStmt [

	| export condition ifBlock elseBlock |
	export := String new writeStream.

	condition := aKTLIfDecisionStmt sourceText
		             copyFrom: 1
		             to:
		             (aKTLIfDecisionStmt sourceText indexOfSubCollection:
			              ')')+1.
	export
		<< condition;
		<< String crlf.

	"change to exportWith: closure"
	ifBlock := aKTLIfDecisionStmt if exportWith: self.
	export
		<< ifBlock;
		<< String crlf.

	aKTLIfDecisionStmt else ifNotNil: [
		elseBlock := aKTLIfDecisionStmt else exportWith: self.
		(export << 'else')
			<< String crlf;
			<< elseBlock;
			<< String crlf ].

	^ export contents
]

{ #category : 'export - loop' }
KTLModelExporter >> exportKTLLoop: aKTLLoop [ 
	|export |
	
	
	^ aKTLLoop loopBody exportWith: self. 
	
	
]

{ #category : 'export' }
KTLModelExporter >> exportKTLStatement: aKTLStatement [ 
	aKTLStatement treeSitterNode type = #comment ifTrue: [ 
		self flag: 'comment in TS and Groovy are syntaxicaly the same with // '.
		^  aKTLStatement sourceText ].
	
	^ self exportFindStmtInStep: aKTLStatement. 
]

{ #category : 'export - case' }
KTLModelExporter >> exportKTLSwitchCaseStmt: aKTLSwitchCaseStmt [ 
	
	|export|
	
	export := String new writeStreamDo: [ :st |
		
		st << 'case '; << (aKTLSwitchCaseStmt testSteps first sourceText); cr.
		
		 ].
	
	export  << (String crlf join: (aKTLSwitchCaseStmt testSteps allButFirst collect: [ :step | step exportWith: self ] )); cr.
		
	^ export contents. 
]

{ #category : 'export' }
KTLModelExporter >> exportKTLSwitchDecisionStmt: aKTLSwitchDecisionStmt [ 
	|condition casesBlock default export|
	export := String new writeStream.
	condition := aKTLSwitchDecisionStmt sourceText.
	
	^ export << 'switch '; << condition; <<String crlf; << (aKTLSwitchDecisionStmt body exportWith: self) contents.
	
	"
	casesBlock := aKTLSwitchDecisionStmt cases collect: [ :block |
		|exp |
		exp := String new writeStream.
		exp << 'case '; << (block steps first sourceText); << ' :'; << String crlf .
		2 to: block steps size do: [ :i | 
			exp << ((block steps at: i) exportWith: self); << String crlf  ].
		exp contents
		 ].
	export << (String cr join: casesBlock); <<String crlf ; <<String crlf.
	
	default := aKTLSwitchDecisionStmt default ifNotNil: [ :block |
		|exp |
		exp := String new writeStream.
		exp << 'default : '; << String crlf .
		 block steps do: [ :step| 
			exp << (step exportWith: self); << String crlf  ].
		exp contents		
		] ifNil: [''].
	export << default; <<String crlf ; << '}'; <<String crlf.

	^ export contents"
]

{ #category : 'export' }
KTLModelExporter >> exportKTLTryDecisionStmt: aKTLTryCatchDecisionStmt [ 
	|tryBlock exception catchBlock finallyBlock export|
	
	
	export := String new writeStream.
	"TRY"
	
	export << 'try '; << String crlf.
	export << (aKTLTryCatchDecisionStmt try exportWith: self); <<String crlf.

	"CATCH"

	export << (String cr join: (aKTLTryCatchDecisionStmt catches collect: [:catch | catch exportWith: self])); <<String crlf.
	
	"FINALLY"
	aKTLTryCatchDecisionStmt finally ifNotNil: [ 

	export << 'finally '; << (aKTLTryCatchDecisionStmt finally exportWith: self); << String crlf.
		 ].

	^ export contents .
]

{ #category : 'export - loop' }
KTLModelExporter >> exportKTLWhileStmt: aKTLWhileStmt [ 
	
		| export |
	export := String new writeStreamDo: [ :st |
		          st
			          << 'while';
			          << aKTLWhileStmt condition ].

	export << (self exportKTLLoop: aKTLWhileStmt).

	^ export contents
]

{ #category : 'export' }
KTLModelExporter >> exportKTlMethodDef: aKTLmethodDef [ 
	|codeLines|
	
	codeLines := (aKTLmethodDef sourceText).
	
	"codeLines := ((aKTLmethodDef sourceText lines) copyFrom: 2 to: (aKTLmethodDef sourceText lines size) ) collect: [:line |
		(line, ';')
		]."
	
	^ '// TODO MUST REWRITE IN TS', String crlf, codeLines 
	
]

{ #category : 'export' }
KTLModelExporter >> exportMethodCall: aKTLmethodCall [ 

	^ self exportFindStmtInStep: aKTLmethodCall.
]

{ #category : 'export' }
KTLModelExporter >> exportObjectRepository [
	|objects objectsGroup|
	
	objectDirectoryPath := self ensureSubDirectory: #'tests/Object Repository'.
	
	objects := katalonProject objectRepository objectDeclarationsGroup.
	
	objectsGroup := self groupObjects: objects .
	self exportObjectsGroups: objectsGroup .
	
	
]

{ #category : 'export' }
KTLModelExporter >> exportObjectsGroups:  objectsGroup [
	"create one file per group of object"

	objectsGroup associationsDo: [ :assoc |
		|groupName itsObjects|
		"here the group name can actualy be a system path"
		groupName := (assoc key).
		itsObjects := assoc value. 
		
		self ensureObjectRepositoryFileForObjects: itsObjects withName: groupName.
		
		  ].
	
]

{ #category : 'export' }
KTLModelExporter >> exportScripts [
	| testCases |
	scriptsRepositoryPath := self ensureSubDirectory: 'tests/Scripts'.
	
	testCases := katalonProject testCases.
	self ensureScriptFilesForTestCases: testCases.
	
	self flag: 'check how to export utils'. 
]

{ #category : 'as yet unclassified' }
KTLModelExporter >> exportSpecAndTSFileForTestCase: aTestCase [

	self ensureSpecTsFileForTestCase: aTestCase.
	self ensureTsExportFunctionFileForTestCase: aTestCase
]

{ #category : 'testcase' }
KTLModelExporter >> exportSpecTsTestCaseScriptBody: aKTLTestCase [

	| scripStmt content scriptFunctions |
	content := String new writeStream.

	scripStmt := self exportstepsAsString:
		             (aKTLTestCase scriptGroovy testSteps reject: [ :step |
			              step class = KTLImport ]).


	scriptFunctions := String new writeStream.
	"creates a wrapping function for the test"
	aKTLTestCase isCalledTestCase ifFalse: [
		content
			<< (self exportTestCaseSignatureDecl: aKTLTestCase);
			cr;
			<< 'const WebUI = new WebUILib(page)';
			cr;
			<< scripStmt;
			cr;
			<< '});' ].

	^ content contents
]

{ #category : 'testcase' }
KTLModelExporter >> exportTestCaseBodyAsExportFunction: aKTLTestCase [ 
	
	| scripStmt content scriptFunctions |
	content := String new writeStream.
	
	scripStmt := self exportstepsAsString:
		             (aKTLTestCase scriptGroovy testSteps reject: [ :step |
			              step class = KTLImport ]).

	scriptFunctions := String new writeStream.
	"creates a wrapping function for the test"
	aKTLTestCase isCalledTestCase
		ifTrue: [
			content
				<<
					('export async function ' , aKTLTestCase name normalizeIdentifier
					 , '(WebUI) {');
				cr;
				<< scripStmt;
				cr;
				<< '}' ].

	^ content contents
]

{ #category : 'testcase' }
KTLModelExporter >> exportTestCaseScriptBody: aKTLTestCase [

	| scripStmt content scriptFunctions zephyrTag |
	content := String new writeStream.

	scripStmt := self exportstepsAsString:
		             (aKTLTestCase scriptGroovy testSteps reject: [ :step |
			              step class = KTLImport ]).

	scriptFunctions := String new writeStream.

	zephyrTag := aKTLTestCase zephyrId
		             ifNil: [ '' ]
		             ifNotNil: [ '[' , aKTLTestCase zephyrId , '] ' ].

	"creates a wrapping function for the test"
	aKTLTestCase isCalledTestCase
		ifTrue: [
			content
				<< ('test(''' , zephyrTag , aKTLTestCase name
					 , ''', async ({ page }) => {');
				cr;
				<< 'const WebUI = new WebUILib(page)';
				cr;
				<< ('await ' , aKTLTestCase name normalizeIdentifier , '(WebUI);');
				cr;
				<< '});';
				cr;
				cr;
				cr.

			content
				<<
					('export async function ' , aKTLTestCase name normalizeIdentifier
					 , '(WebUI) {');
				cr;
				<< scripStmt;
				cr;
				<< '}' ]
		ifFalse: [
			content
				<< ('test(''' , zephyrTag , aKTLTestCase name
					 , ''', async ({ page }) => {');
				cr;
				<< 'const WebUI = new WebUILib(page)';
				cr;
				<< scripStmt;
				cr;
				<< '});' ].

	^ content contents
]

{ #category : 'testcase' }
KTLModelExporter >> exportTestCaseSignatureDecl: aKTLTestCase [

	^ 'test(''' , (self exportZephyTag:
		  aKTLTestCase) , aKTLTestCase name , ''', async ({ page }) => {'
]

{ #category : 'accessing' }
KTLModelExporter >> exportWithDebug [
	^ exportWithDebug := true.
]

{ #category : 'gitlab' }
KTLModelExporter >> exportWithLibFolderFromGitLabApi: aGitlabRepositories [ 
	gitlabApi :=	aGitlabRepositories 
	

]

{ #category : 'accessing' }
KTLModelExporter >> exportWithOriginalLines [
	exportWithOriginalLines:= true. 
]

{ #category : 'zephyr' }
KTLModelExporter >> exportWithZephyrTags: zephyrTestCasesInfos [

	zephyrTestCasesInfos do: [ :zephyInfo |
		katalonProject testCases
			detect: [ :t | t name = (zephyInfo at: #name) ]
			ifFound: [ :testcase | testcase zephyrId: (zephyInfo at: #key) ] ]
]

{ #category : 'as yet unclassified' }
KTLModelExporter >> exportZephyTag: aKTLTestCase [

^ aKTLTestCase zephyrId
		             ifNil: [ '' ]
		             ifNotNil: [ '[' , aKTLTestCase zephyrId , '] ' ].
]

{ #category : 'export' }
KTLModelExporter >> exportstepsAsString: aCollectionOfSteps [
	|stepsExported| 
	stepsExported := aCollectionOfSteps collect: [ :step |
			|ogComment tsLines|
			"self haltIf: [ step sourceText includesSubstring: 'String valorDocumentoAlPunlsarRepetir' ]."
			ogComment := exportWithOriginalLines ifTrue: ['//Katalon OG Line: ', ('\n' join: step sourceText lines)] ifFalse: ['']. 
			ogComment := exportWithDebug ifTrue: [ ogComment , ' ' ,  step class name] ifFalse: [ogComment].
			tsLines := step exportWith: self. 
			ogComment, String cr, tsLines.
		 ].
	
	^ (String crlf) join: stepsExported.
]

{ #category : 'export' }
KTLModelExporter >> genericImportDeclaration [

	| export globalVarImport |
	
	globalVarImport := katalonProject globalVars isNotEmpty ifTrue: ['import { GlobalVariable } from ''GlobalVariable'';'] ifFalse: [''].
	
	export := String new writeStream.
	export
		<< 'import { test, expect } from ''@playwright/test'';';
		cr;
		<< globalVarImport ;
		cr;
		<< 'import { WebUILib } from ''Lib/WebUI'';';
		cr;
		<< 'import {FailureHandling} from ''Lib/FailureHandling'';';
		cr;
		<< 'import { Keys } from ''Lib/Keys'';';
		cr.
	^ export contents
]

{ #category : 'refactor' }
KTLModelExporter >> groupObjects: aMooseSpecializedGroup [ 
	
	|dic|
	dic := Dictionary new. 
	"group object base on their identifier path"
	aMooseSpecializedGroup do: [ :obj |
		|identifierPath|
		
		identifierPath := (obj identifierPath splitOn: '/') allButLast.
		identifierPath := ('/' join: (identifierPath collect: #normalizeIdentifier ) ).
		dic at: (identifierPath ) 
			ifPresent: [ :collection | collection add: obj.  ] 
			ifAbsentPut: [ OrderedCollection new add: obj; yourself ]
		 ].
	
^ dic. 
]

{ #category : 'initialization' }
KTLModelExporter >> initialize [ 
	super initialize.
	exportWithOriginalLines := false. 
	exportWithDebug  := false. 
]

{ #category : 'accessing' }
KTLModelExporter >> katalonProject [

	^ katalonProject
]

{ #category : 'accessing' }
KTLModelExporter >> katalonProject: anObject [

	katalonProject := anObject
]

{ #category : 'accessing' }
KTLModelExporter >> model [

	^ model
]

{ #category : 'accessing' }
KTLModelExporter >> model: anObject [

	model := anObject
]

{ #category : 'export' }
KTLModelExporter >> newExportFindTestCaseInLoc: aString fromStep: aStep [

	| loc |
	loc := aString.
	(loc includesSubstring: 'findTestCase(') ifFalse: [ ^ loc ].


	aStep testCases do: [ :aTestCase |
		(loc
			 includesSubstring: aTestCase orginalIdentifierPath
			 caseSensitive: false) ifTrue: [
			^ '{1}(WebUI)' format: { aTestCase name normalizeIdentifier } ] ].
	^ loc.
 


	"DEAD CODE IN CASE THE PROBLEM NEEDS IT..."
	"seems that their can be only one call to FindTestCase per lines"
	"transform findTestObject statement into an TS object call"
	"aStep testCases do: [ :aTestCase |
		| splits prefix |
		splits := loc splitOn: aTestCase orginalIdentifierPath.

		""remove unsed quotes""
		splits := splits collect: [ :split |
			          (split trim withoutPrefix: '""') withoutPrefix: '''' ].

		""change the split with findTestObject except for the last, but add it in the end""
		loc := '' join: (splits
				        collect: [ :split |
					        | res |
					        res := split trim.
					        (split includesSubstring: 'findTestCase(') ifTrue: [
						        prefix := (res withoutSuffix:
							                   'WebUI.callTestCase(findTestCase(''')
							                  withoutSuffix:
							                  'WebUI.callTestCase(findTestCase(""'.
						        res := '{1} {2}(WebUI)' format: {
								               prefix.
								               aTestCase name normalizeIdentifier } ].
					        res ]
				        from: 1
				        to: splits size - 1) "", { splits last }"" ].

	^ loc"
]

{ #category : 'instance creation' }
KTLModelExporter >> newExportFindTestObjectInLoc: aString fromStep: aStep [

	| loc |
	loc := aString.

	"self haltIf: [
		aStep sourceText includesSubstring:
			'getAttribute(findTestObject' ]."

	"pre-treatment to remove some edge cases"
	(loc includesSubstring: 'findTestObject(') ifFalse: [ ^ loc ].

	(loc includesSubstring: 'Object Repository/') ifTrue: [
		loc := loc copyReplaceAll: 'Object Repository/' with: '' ].


	(loc includesSubstring: 'findTestObject(null)') ifTrue: [
		loc := loc copyReplaceAll: 'findTestObject(null)' with: 'null' ].

	"some steps could have multiple calls to findTestObject()"
	"transform findTestObject statement into an TS object call"

	"detect each instance of findTestObject in the loc"
	"find each instance matching each instances"
	"replace in loc"
	aStep objectDeclarations do: [ :objectDecl |
		| objectId splits prefix |
		objectId := objectDecl identifierPath splitOn: '/'.

		splits := loc
			          splitOn: objectDecl identifierPath
			          caseSensitive: false.
		splits := splits collect: [ :split |
			          (split trim withoutPrefix: '"') withoutPrefix: '''' ].

		loc := '' join: (splits
				        collect: [ :split |
					        | res |
					        res := split trim.
					        (split includesSubstring: 'findTestObject') ifTrue: [
						        prefix := (res withoutSuffix: 'findTestObject("')
							                  withoutSuffix: 'findTestObject('''.
						        res := '{1} await {2}.{3}(WebUI' format: {
								               prefix.
								               objectDecl printImportVar.
								               objectId last normalizeIdentifier } ].
					        res ]
				        from: 1
				        to: splits size - 1) , { splits last } ].
	^ loc
]

{ #category : 'normalizer' }
KTLModelExporter >> normalizeIdentifier: aString [
 	^ aString normalizeIdentifier 
]

{ #category : 'ordering' }
KTLModelExporter >> orderGlobalVarsByProfile: globalVars [ 
	|dico|
	dico := Dictionary new. 
	
	globalVars do: [ :var |
		var varProfiles associationsDo: [:assoc|
			|profileName |
			profileName := assoc key. 
			dico at: profileName ifPresent: [ :vars | vars add: var ] ifAbsentPut: [Set new add: var; yourself ]. 
			].
		 ].
		
	^dico

]

{ #category : 'rebuild' }
KTLModelExporter >> rebuildCustomKeywordInvocation: aKTLCustomKeyword [ 
	^  ('.' join: (({ aKTLCustomKeyword customKeywordClass package . aKTLCustomKeyword customKeywordClass name . aKTLCustomKeyword name }) reject: #isNil) ) 
]

{ #category : 'removing' }
KTLModelExporter >> removeFNKeywordInLoC: aString fromStep: aKTLmethodCall [

	| loc |
	loc := aString.

	(loc trim beginsWith: 'fn.') ifTrue: [ loc := loc allButFirst: 3 ].
	
	^loc.
]

{ #category : 'initialization' }
KTLModelExporter >> resetMultipleNamingOfObjects: aKTLObjectDeclarationCollection [ 
	aKTLObjectDeclarationCollection do: [ :obj | obj idx: nil ].
	^ aKTLObjectDeclarationCollection.
]

{ #category : 'resolver' }
KTLModelExporter >> resolveMultipleNamingOfObjects: aKTLObjectDeclarationsCollection [

	| dicGrpName dicPath |
	dicGrpName := Dictionary new.
	dicPath := Dictionary new.

	aKTLObjectDeclarationsCollection do: [ :obj |
		dicGrpName
			at: obj groupName
			ifPresent: [ :items |
				items
					add: obj;
					yourself ]
			ifAbsentPut: [
				OrderedCollection new
					add: obj;
					yourself ] ].

	"	aKTLObjectDeclarationsCollection do: [ :obj |
		|objectPath|
		objectPath := 'Object Repository/' , ('/' join:
			                          ((obj identifierPath splitOn: '/')
				                           allButLast collect: [ :path |
				                           path normalizeIdentifier ])).
		
		dicPath at: objectPath ifPresent: [ :items | items add: obj; yourself ] ifAbsentPut: [OrderedCollection new add: obj; yourself].
		 ]."


	dicGrpName do: [ :aValueCollection |
		| idx |
		dicPath := Dictionary new.
		aValueCollection do: [ :obj |
			| objectPath |
			objectPath := 'Object Repository/' , ('/' join:
				               ((obj identifierPath splitOn: '/') allButLast
					                collect: [ :path | path normalizeIdentifier ])).

			dicPath
				at: objectPath
				ifPresent: [ :items |
					items
						add: obj;
						yourself ]
				ifAbsentPut: [
					OrderedCollection new
						add: obj;
						yourself ] ].


		idx := 1.
		dicPath associations size >= 2 ifTrue: [
			dicPath associationsDo: [ :assoc |
				| value |
				assoc value do: [ :obj | obj idx: idx ].
				idx := idx + 1 ] ] ]
]
