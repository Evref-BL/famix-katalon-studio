"
A KTLModelExporterTest is a test class for testing the behavior of KTLModelExporter
"
Class {
	#name : 'KTLModelExporterTest',
	#superclass : 'TestCase',
	#instVars : [
		'object',
		'step',
		'exporter',
		'object2',
		'testcase',
		'testcase2',
		'project',
		'object3'
	],
	#category : 'Katalon-Model-Exporter-Tests',
	#package : 'Katalon-Model-Exporter-Tests'
}

{ #category : 'running' }
KTLModelExporterTest >> setUp [

	super setUp.

	project := KTLProject new.

	object := KTLObjectDeclaration new.
	object2 := KTLObjectDeclaration new.
	object3 := KTLObjectDeclaration new.


	testcase := KTLTestCase new.
	testcase2 := KTLTestCase new.

	step := KTLTestStep new.

	exporter := KTLModelExporter new
]

{ #category : 'tests' }
KTLModelExporterTest >> testExportFindStmtInStep [

	object identifierPath: 'formerror/input_Formulaire_Prenom'. 
	
	step sourceText: 'WebUI.setText(findTestObject(''formerror/input_Formulaire_Prenom''), WebUI.getAttribute(findTestObject(''formerror/input_Formulaire_Prenom''), ''testlabel''))'.
	step addObjectDeclaration: object. 
	
	self assert: (exporter exportFindStmtInStep: step) trim
		equals: 'await WebUI.setText( await Formerror.InputFormulairePrenom(WebUI), await WebUI.getAttribute( await Formerror.InputFormulairePrenom(WebUI), ''testlabel''));' trim.
	
	
]

{ #category : 'tests' }
KTLModelExporterTest >> testExportFindStmtInStep2 [

	step sourceText:
		'WebUI.openBrowser('''')'.

	self
		assert: (exporter exportFindStmtInStep: step) trim
		equals:
			'await WebUI.openBrowser('''');'
				trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testExportFindStmtInStep3 [

	object identifierPath: 'formerror/toast_EnvoiFormulaireReussi'.

	step sourceText:
		'WebUI.verifyElementVisible(findTestObject(''formerror/toast_EnvoiFormulaireReussi''))'.
	step addObjectDeclaration: object.

	self
		assert: (exporter exportFindStmtInStep: step) trim
		equals:
			'await WebUI.verifyElementVisible( await Formerror.ToastEnvoiFormulaireReussi(WebUI));'
				trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testExportFindStmtInStep4 [

	object identifierPath: 'formerror/input_FormulaireAddressL1'.

	step sourceText:
		'WebUI.sendKeys(findTestObject(''formerror/input_FormulaireAddressL1''), ''rue des anciens combattants'')'.
	step addObjectDeclaration: object.

	self
		assert: (exporter exportFindStmtInStep: step) trim
		equals:
			'await WebUI.sendKeys( await Formerror.InputFormulaireAddressL1(WebUI), ''rue des anciens combattants'');'
				trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testExportFindStmtInStep5 [

	object identifierPath: 'Page_AvenirGF/Authentification/input_password_crypt'.

	step sourceText:
		'WebUI.setEncryptedText(findTestObject(''Page_AvenirGF/Authentification/input_password_crypt''), GlobalVariable.pwAvenirGFQA)'.
	step addObjectDeclaration: object.

	self
		assert: (exporter exportFindStmtInStep: step) trim
		equals:
			'await WebUI.setEncryptedText( await Authentification.InputPasswordCrypt(WebUI), GlobalVariable.pwAvenirGFQA);'
				trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testExportFindStmtInStep6 [

	object identifierPath:
		'Page_AvenirGF/Authentification/input_password_crypt'.

	step := KTLDeclaration new variable: (KTLLocalVar new
			         name: 't';
			         initValue:
				         'WebUI.setEncryptedText(findTestObject(''Page_AvenirGF/Authentification/input_password_crypt''), GlobalVariable.pwAvenirGFQA)').
	step sourceText:
		'String t = WebUI.setEncryptedText(findTestObject(''Page_AvenirGF/Authentification/input_password_crypt''), GlobalVariable.pwAvenirGFQA)'.
	step addObjectDeclaration: object.

	self
		assert: (step exportWith: exporter) trim
		equals:
			'var t = await WebUI.setEncryptedText( await Authentification.InputPasswordCrypt(WebUI), GlobalVariable.pwAvenirGFQA);'
				trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testExportFindStmtInStep7 [

	object identifierPath:
		'Page_AvenirGF/Authentification/input_password_crypt'.

	step := KTLDeclaration new variable: (KTLLocalVar new
			         name: 't';
			         initValue:
				         'WebUI.setEncryptedText(findTestObject(''Page_AvenirGF/Authentification/input_password_crypt''), GlobalVariable.pwAvenirGFQA)').
	step sourceText:
		'int t = WebUI.setEncryptedText(findTestObject(''Page_AvenirGF/Authentification/input_password_crypt''), GlobalVariable.pwAvenirGFQA)'.
	step addObjectDeclaration: object.

	self
		assert: (step exportWith: exporter) trim
		equals:
			'var t = await WebUI.setEncryptedText( await Authentification.InputPasswordCrypt(WebUI), GlobalVariable.pwAvenirGFQA);'
				trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testExportImport [

	| res expected |
	object identifierPath: 'un/deux/trois'.
	object2 identifierPath: 'deux/deux'.

	step
		addObjectDeclaration: object;
		addObjectDeclaration: object2.

	testcase scriptGroovy: (KTLScriptGroovy new
			 addTestStep: step;
			 yourself).


	object groupName.

	exporter resolveMultipleNamingOfObjects: {
			object.
			object2 }.

	res := exporter exportImportDeclarationForObjects: {
			       object.
			       object2 }.

	exporter resetMultipleNamingOfObjects: {
			object.
			object2 }.


	expected := 'import { Deux as DeuxV1 } from ''Object Repository/Deux'';
import { Deux as DeuxV2 } from ''Object Repository/Un/Deux'';'.

	self assert: res lines size equals: expected lines size.
	self assert: res lines first equals: expected lines first.
	self assert: res lines second equals: expected lines second.
]

{ #category : 'tests' }
KTLModelExporterTest >> testExportImportMultipleObjet [

	| res expected |
	object identifierPath: 'un/deux/trois'.
	object2 identifierPath: 'deux/quatre'.
	object3 identifierPath: 'deux/cinq'.

	step
		addObjectDeclaration: object;
		addObjectDeclaration: object2;
		addObjectDeclaration: object3.

	testcase scriptGroovy: (KTLScriptGroovy new
			 addTestStep: step;
			 yourself).


	object groupName.

	exporter resolveMultipleNamingOfObjects: {
			object.
			object2. object3 }.

	res := exporter exportImportDeclarationForObjects: {
			       object.
			       object2 }.

	exporter resetMultipleNamingOfObjects: {
			object.
			object2 . object3}.


	expected := 'import { Deux as DeuxV1 } from ''Object Repository/Deux'';
import { Deux as DeuxV2 } from ''Object Repository/Un/Deux'';'.

	
	self assert: res lines size equals: expected lines size.
	self assert: res lines first equals: expected lines first.
]

{ #category : 'tests' }
KTLModelExporterTest >> testExportImportMultipleObjet2time [

	| res expected object4 |
	object identifierPath: 'un/deux/trois'.
	object4 := KTLObjectDeclaration new identifierPath: 'un/deux/six'; yourself.
	object2 identifierPath: 'deux/quatre'.
	object3 identifierPath: 'deux/cinq'.

	step
		addObjectDeclaration: object;
		addObjectDeclaration: object2;
		addObjectDeclaration: object3;
		addObjectDeclaration: object4.

	testcase scriptGroovy: (KTLScriptGroovy new
			 addTestStep: step;
			 yourself).


	object groupName.

	exporter resolveMultipleNamingOfObjects: {
			object.
			object2.
			object3 . object4}.

	res := exporter exportImportDeclarationForObjects: {
			       object.
			       object2 . object4}.

	exporter resetMultipleNamingOfObjects: {
			object.
			object2.
			object3 . object4}.


	expected := 'import { Deux as DeuxV1 } from ''Object Repository/Deux'';
import { Deux as DeuxV2 } from ''Object Repository/Un/Deux'';'.


	self assert: res lines size equals: expected lines size.
	self assert: res lines first equals: expected lines first
]

{ #category : 'tests' }
KTLModelExporterTest >> testExportImportNoIssue [

	| res expected |
	object identifierPath: 'un/deux/trois'.
	object2 identifierPath: 'quatre/deux'.

	step
		addObjectDeclaration: object;
		addObjectDeclaration: object2.

	testcase scriptGroovy: (KTLScriptGroovy new
			 addTestStep: step;
			 yourself).


	object groupName.

	exporter resolveMultipleNamingOfObjects: {
			object.
			object2 }.

	res := exporter exportImportDeclarationForObjects: {
			       object.
			       object2 }.

	exporter resetMultipleNamingOfObjects: {
			object.
			object2 }.


	expected := 'import { Deux } from ''Object Repository/Un/Deux'';
import { Quatre } from ''Object Repository/Quatre'';'.

	self assert: res lines size equals: expected lines size.
	self assert: res lines first equals: expected lines first.
	self assert: res lines second equals: expected lines second
]

{ #category : 'tests' }
KTLModelExporterTest >> testNewExportFindTestCaseInLocFromStep [

	| res |
	testcase scriptGroovy: (KTLScriptGroovy new filePath:
			 '/Scripts/Commons_KDC/MakeAppointment_KDC_protectedVariables_Declare/Script1720606303305.groovy'
				 asFileReference); name: 'MakeAppointment_KDC_protectedVariables_Declare' .

	step sourceText:
		'WebUI.callTestCase(findTestCase(''Commons_KDC/MakeAppointment_KDC_protectedVariables_Declare''), [:])'.
	step addTestCase: testcase.

	res := exporter
		       newExportFindTestCaseInLoc: step sourceText
		       fromStep: step.
	self
		assert: res trim
		equals: 'MakeAppointmentKDCProtectedVariablesDeclare(WebUI)' trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testNewExportFindTestCaseInLocFromStepCaseSensitive [

	| res |
	testcase
		scriptGroovy: (KTLScriptGroovy new filePath:
					 '/Scripts/Commons_KDC/MakeAppointment_KDC_protectedVariables_Declare/Script1720606303305.groovy'
						 asFileReference);
		name: 'MakeAppointment_KDC_protectedVariables_Declare'.

	step sourceText:
		'WebUI.callTestCase(findTestCase(''Commons_KDC/MAkEAPpOINtMeNT_KDC_pRoTeCtedVariables_Declare''), [:])'.
	step addTestCase: testcase.

	res := exporter
		       newExportFindTestCaseInLoc: step sourceText
		       fromStep: step.
	self
		assert: res trim
		equals: 'MakeAppointmentKDCProtectedVariablesDeclare(WebUI)' trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testNewExportFindTestCaseInLocFromStepDifferentTestCase [

	| res |
	testcase
		scriptGroovy: (KTLScriptGroovy new filePath:
					 '/Scripts/Commons_KDC/MakeAppointment_KDC_protectedVariables_Declare/Script1720606303305.groovy'
						 asFileReference);
		name: 'MakeAppointment_KDC_protectedVariables_Declare'.

	step sourceText:
		'WebUI.callTestCase(findTestCase(''Toto/Toto''), [:])'.
	step addTestCase: testcase.

	res := exporter
		       newExportFindTestCaseInLoc: step sourceText
		       fromStep: step.
	self assert: res trim equals: 'WebUI.callTestCase(findTestCase(''Toto/Toto''), [:])' trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testNewExportFindTestCaseInLocFromStepNoTestCase [

	| res |

	step sourceText:
		'WebUI.callTestCase(findTestCase(''Toto/Toto''), [:])'.

	res := exporter
		       newExportFindTestCaseInLoc: step sourceText
		       fromStep: step.
	self
		assert: res trim
		equals: 'WebUI.callTestCase(findTestCase(''Toto/Toto''), [:])' trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testNewExportFindTestObjectInLocFromStep [

	| res |
	object identifierPath: 'leftmenu/leftmenu_home'.

	step sourceText:
		'WebUI.click(findTestObject(''leftmenu/leftmenu_home''))'.
	step addObjectDeclaration: object.

	res := exporter
		       newExportFindTestObjectInLoc: step sourceText
		       fromStep: step.
	self
		assert: res trim
		equals: 'WebUI.click( await Leftmenu.LeftmenuHome(WebUI))' trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testNewExportFindTestObjectInLocFromStep2Objects [

	| res |
	object identifierPath: 'formerror/input_Formulaire_Prenom'.
	object2 identifierPath: 'leftmenu/leftmenu_home'.

	step sourceText:
		'WebUI.setText(findTestObject(''formerror/input_Formulaire_Prenom''), WebUI.getAttribute(findTestObject(''leftmenu/leftmenu_home''), ''testlabel''))'.
	step addObjectDeclaration: object.
	step addObjectDeclaration: object2.

	res := exporter
		       newExportFindTestObjectInLoc: step sourceText
		       fromStep: step.
	self
		assert: res trim
		equals:
			'WebUI.setText( await Formerror.InputFormulairePrenom(WebUI), WebUI.getAttribute( await Leftmenu.LeftmenuHome(WebUI), ''testlabel''))'
				trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testNewExportFindTestObjectInLocFromStep2TimesObjects [

	| res |
	object identifierPath: 'formerror/input_Formulaire_Prenom'.

	step sourceText:
		'WebUI.setText(findTestObject(''formerror/input_Formulaire_Prenom''), WebUI.getAttribute(findTestObject(''formerror/input_Formulaire_Prenom''), ''testlabel''))'.
	step addObjectDeclaration: object.

	res := exporter
		       newExportFindTestObjectInLoc: step sourceText
		       fromStep: step.
	self
		assert: res trim
		equals:
		'WebUI.setText( await Formerror.InputFormulairePrenom(WebUI), WebUI.getAttribute( await Formerror.InputFormulairePrenom(WebUI), ''testlabel''))' trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testNewExportFindTestObjectInLocFromStep2TimesObjects1UnkwonObject [

	| res |
	object identifierPath: 'formerror/input_Formulaire_Prenom'.

	step sourceText:
		'WebUI.setText(findTestObject(''formerror/input_Formulaire_Prenom''), WebUI.getAttribute(findTestObject(''formerror/input_Formulaire_Prenom''), WebUI.getAttribute(findTestObject(''toto/tototo''), ''testlabel''))'.
	step addObjectDeclaration: object.

	res := exporter
		       newExportFindTestObjectInLoc: step sourceText
		       fromStep: step.
	self
		assert: res trim
		equals:
			'WebUI.setText( await Formerror.InputFormulairePrenom(WebUI), WebUI.getAttribute( await Formerror.InputFormulairePrenom(WebUI), WebUI.getAttribute(findTestObject(''toto/tototo''), ''testlabel''))'
				trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testNewExportFindTestObjectInLocFromStepCaseSensitive [

	| res |
	object identifierPath: 'leftmenu/leftmenu_home'.

	step sourceText:
		'WebUI.click(findTestObject(''leftmenu/lEfTmEnU_HoMe''))'.
	step addObjectDeclaration: object.

	res := exporter
		       newExportFindTestObjectInLoc: step sourceText
		       fromStep: step.
	self
		assert: res trim
		equals: 'WebUI.click( await Leftmenu.LeftmenuHome(WebUI))' trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testNewExportFindTestObjectInLocFromStepInDragAndDropStmt [

	| res |
	object identifierPath: 'Page_The Internet/div_draggable'.
	object2 identifierPath: 'Page_The Internet/div_droppable'.

	step sourceText:
		'WebUI.dragAndDropToObject(findTestObject(''Page_The Internet/div_draggable''), findTestObject(''Page_The Internet/div_droppable''))'.
	step addObjectDeclaration: object; addObjectDeclaration: object2 .
	
	res := exporter
		       newExportFindTestObjectInLoc: step sourceText
		       fromStep: step.
	self
		assert: res trim
		equals:
			'WebUI.dragAndDropToObject( await PageTheInternet.DivDraggable(WebUI),  await PageTheInternet.DivDroppable(WebUI))'
				trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testNewExportFindTestObjectInLocFromStepNoStmt [

	| res |
	object identifierPath: 'leftmenu/leftmenu_home'.

	step sourceText:
		'WebUI.click(toto)'.
	step addObjectDeclaration: object.

	res := exporter
		       newExportFindTestObjectInLoc: step sourceText
		       fromStep: step.
	self
		assert: res trim
		equals: 'WebUI.click(toto)' trim
]

{ #category : 'tests' }
KTLModelExporterTest >> testNewExportFindTestObjectInLocFromStepWithFunctionKeyword [

	| res |
	object identifierPath: 'leftmenu/leftmenu_home'.

	step sourceText:
		'WebUI.click(findTestObject(''leftmenu/funcionalKeyword.leftmenu_home''))'.
	step addObjectDeclaration: object.

	res := exporter
		       newExportFindTestObjectInLoc: step sourceText
		       fromStep: step.
	self
		assert: res trim
		equals: 'WebUI.click( await Leftmenu.LeftmenuHome(WebUI))' trim
]
