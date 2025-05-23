Class {
	#name : 'KTLFactory',
	#superclass : 'Object',
	#category : 'Katalon-Model-Importer',
	#package : 'Katalon-Model-Importer'
}

{ #category : 'instance creation' }
KTLFactory class >> newFromType: aTypeName [

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
	aTypeName = #groovy_package ifTrue: [
		self flag: 'possible parsing error ?'.
		^ KTLModel new newStatement ].
	aTypeName = #for_loop ifTrue: [ ^ KTLModel new newStatement ].
	aTypeName = #label ifTrue: [ ^ KTLModel new newStatement ].
	aTypeName = #binary_op ifTrue: [ ^ KTLModel new newStatement ].
	aTypeName = #assertion ifTrue: [ ^ KTLModel new newStatement ].
	aTypeName = #identifier ifTrue: [ ^ KTLModel new newStatement ].
	aTypeName = #try_statement ifTrue: [ ^ KTLModel new newStatement ].
	aTypeName = #while_loop ifTrue: [ ^ KTLModel new newStatement ].
	aTypeName = #closure ifTrue: [ ^ KTLModel new newStatement ].
	aTypeName = #if ifTrue: [ ^ KTLModel new newStatement ].
	aTypeName = #groovy_doc ifTrue: [ ^ KTLModel new newStatement ].
	aTypeName = #switch_statement
		ifTrue: [ ^ KTLModel new newStatement ].
	aTypeName = #'access_op'
		ifTrue: [ ^ KTLModel new newStatement ]
		ifFalse: [ 1 halt ]
]
