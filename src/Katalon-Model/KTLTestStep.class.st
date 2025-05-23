"
I represent a katalon Test step

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `block` | `KTLTestStep` | `steps` | `KTLStepBlock` | the associated block|
| `catchStatement` | `KTLTestStep` | `exception` | `KTLCatchStmt` | link to an catch|
| `scriptGroovy` | `KTLTestStep` | `testSteps` | `KTLScriptGroovy` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `customKeywords` | `KTLTestStep` | `testSteps` | `KTLCustomKeyword` | |
| `datas` | `KTLTestStep` | `testSteps` | `KTLData` | |
| `objectDeclarations` | `KTLTestStep` | `testSteps` | `KTLObjectDeclaration` | |
| `statements` | `KTLTestStep` | `testSteps` | `KTLStatement` | |
| `testCases` | `KTLTestStep` | `testSteps` | `KTLTestCase` | |
| `variables` | `KTLTestStep` | `references` | `KTLVar` | a set of variables|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `index` | `Number` | nil | |
| `input` | `Object` | nil | |
| `item` | `Object` | nil | |
| `object` | `Object` | nil | |
| `output` | `Object` | nil | |
| `sourceText` | `String` | nil | |
| `stepDescription` | `String` | nil | |
| `treeSitterNode` | `Object` | nil | |

"
Class {
	#name : 'KTLTestStep',
	#superclass : 'KTLEntity',
	#instVars : [
		'#index => FMProperty',
		'#sourceText => FMProperty',
		'#treeSitterNode => FMProperty',
		'#item => FMProperty',
		'#object => FMProperty',
		'#input => FMProperty',
		'#output => FMProperty',
		'#stepDescription => FMProperty',
		'#scriptGroovy => FMOne type: #KTLScriptGroovy opposite: #testSteps',
		'#datas => FMMany type: #KTLData opposite: #testSteps',
		'#objectDeclarations => FMMany type: #KTLObjectDeclaration opposite: #testSteps',
		'#testCases => FMMany type: #KTLTestCase opposite: #testSteps',
		'#statements => FMMany type: #KTLStatement opposite: #testSteps',
		'#block => FMOne type: #KTLStepBlock opposite: #steps',
		'#catchStatement => FMOne type: #KTLCatchStmt opposite: #exception',
		'#customKeywords => FMMany type: #KTLCustomKeyword opposite: #testSteps',
		'#variables => FMMany type: #KTLVar opposite: #references'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLTestStep class >> annotation [

	<FMClass: #TestStep super: #KTLEntity>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
KTLTestStep >> addCustomKeyword: anObject [
	<generated>
	^ self customKeywords add: anObject
]

{ #category : 'adding' }
KTLTestStep >> addData: anObject [
	<generated>
	^ self datas add: anObject
]

{ #category : 'adding' }
KTLTestStep >> addObjectDeclaration: anObject [
	<generated>
	^ self objectDeclarations add: anObject
]

{ #category : 'adding' }
KTLTestStep >> addStatement: anObject [
	<generated>
	^ self statements add: anObject
]

{ #category : 'adding' }
KTLTestStep >> addTestCase: anObject [
	<generated>
	^ self testCases add: anObject
]

{ #category : 'adding' }
KTLTestStep >> addVariable: anObject [
	<generated>
	^ self variables add: anObject
]

{ #category : 'accessing' }
KTLTestStep >> block [
	"Relation named: #block type: #KTLStepBlock opposite: #steps"

	<generated>
	<FMComment: 'the associated block'>
	<container>
	^ block
]

{ #category : 'accessing' }
KTLTestStep >> block: anObject [

	<generated>
	block := anObject
]

{ #category : 'navigation' }
KTLTestStep >> blockGroup [
	<generated>
	<navigation: 'Block'>
	^ MooseSpecializedGroup with: self block
]

{ #category : 'accessing' }
KTLTestStep >> catchStatement [
	"Relation named: #catchStatement type: #KTLCatchStmt opposite: #exception"

	<generated>
	<FMComment: 'link to an catch'>
	<container>
	<derived>
	^ catchStatement
]

{ #category : 'accessing' }
KTLTestStep >> catchStatement: anObject [

	<generated>
	catchStatement := anObject
]

{ #category : 'navigation' }
KTLTestStep >> catchStatementGroup [
	<generated>
	<navigation: 'CatchStatement'>
	^ MooseSpecializedGroup with: self catchStatement
]

{ #category : 'accessing' }
KTLTestStep >> customKeywords [
	"Relation named: #customKeywords type: #KTLCustomKeyword opposite: #testSteps"

	<generated>
	^ customKeywords
]

{ #category : 'accessing' }
KTLTestStep >> customKeywords: anObject [

	<generated>
	customKeywords value: anObject
]

{ #category : 'accessing' }
KTLTestStep >> datas [
	"Relation named: #datas type: #KTLData opposite: #testSteps"

	<generated>
	<derived>
	^ datas
]

{ #category : 'accessing' }
KTLTestStep >> datas: anObject [

	<generated>
	datas value: anObject
]

{ #category : 'accessing' }
KTLTestStep >> index [

	<FMProperty: #index type: #Number>
	<generated>
	^ index
]

{ #category : 'accessing' }
KTLTestStep >> index: anObject [
	<generated>
	index := anObject
]

{ #category : 'accessing' }
KTLTestStep >> input [

	<FMProperty: #input type: #Object>
	<generated>
	^ input
]

{ #category : 'accessing' }
KTLTestStep >> input: anObject [
	<generated>
	input := anObject
]

{ #category : 'accessing' }
KTLTestStep >> item [

	<FMProperty: #item type: #Object>
	<generated>
	^ item
]

{ #category : 'accessing' }
KTLTestStep >> item: anObject [
	<generated>
	item := anObject
]

{ #category : 'accessing' }
KTLTestStep >> object [

	<FMProperty: #object type: #Object>
	<generated>
	^ object
]

{ #category : 'accessing' }
KTLTestStep >> object: anObject [
	<generated>
	object := anObject
]

{ #category : 'accessing' }
KTLTestStep >> objectDeclarations [
	"Relation named: #objectDeclarations type: #KTLObjectDeclaration opposite: #testSteps"

	<generated>
	<derived>
	^ objectDeclarations
]

{ #category : 'accessing' }
KTLTestStep >> objectDeclarations: anObject [

	<generated>
	objectDeclarations value: anObject
]

{ #category : 'accessing' }
KTLTestStep >> output [

	<FMProperty: #output type: #Object>
	<generated>
	^ output
]

{ #category : 'accessing' }
KTLTestStep >> output: anObject [
	<generated>
	output := anObject
]

{ #category : 'accessing' }
KTLTestStep >> scriptGroovy [
	"Relation named: #scriptGroovy type: #KTLScriptGroovy opposite: #testSteps"

	<generated>
	<container>
	^ scriptGroovy
]

{ #category : 'accessing' }
KTLTestStep >> scriptGroovy: anObject [

	<generated>
	scriptGroovy := anObject
]

{ #category : 'navigation' }
KTLTestStep >> scriptGroovyGroup [
	<generated>
	<navigation: 'ScriptGroovy'>
	^ MooseSpecializedGroup with: self scriptGroovy
]

{ #category : 'accessing' }
KTLTestStep >> sourceText [

	<FMProperty: #sourceText type: #String>
	<generated>
	^ sourceText
]

{ #category : 'accessing' }
KTLTestStep >> sourceText: anObject [
	<generated>
	sourceText := anObject
]

{ #category : 'accessing' }
KTLTestStep >> statements [
	"Relation named: #statements type: #KTLStatement opposite: #testSteps"

	<generated>
	<derived>
	^ statements
]

{ #category : 'accessing' }
KTLTestStep >> statements: anObject [

	<generated>
	statements value: anObject
]

{ #category : 'accessing' }
KTLTestStep >> stepDescription [

	<FMProperty: #stepDescription type: #String>
	<generated>
	^ stepDescription
]

{ #category : 'accessing' }
KTLTestStep >> stepDescription: anObject [
	<generated>
	stepDescription := anObject
]

{ #category : 'accessing' }
KTLTestStep >> testCases [
	"Relation named: #testCases type: #KTLTestCase opposite: #testSteps"

	<generated>
	<derived>
	^ testCases
]

{ #category : 'accessing' }
KTLTestStep >> testCases: anObject [

	<generated>
	testCases value: anObject
]

{ #category : 'accessing' }
KTLTestStep >> treeSitterNode [

	<FMProperty: #treeSitterNode type: #Object>
	<generated>
	^ treeSitterNode
]

{ #category : 'accessing' }
KTLTestStep >> treeSitterNode: anObject [
	<generated>
	treeSitterNode := anObject
]

{ #category : 'accessing' }
KTLTestStep >> variables [
	"Relation named: #variables type: #KTLVar opposite: #references"

	<generated>
	<FMComment: 'a set of variables'>
	<derived>
	^ variables
]

{ #category : 'accessing' }
KTLTestStep >> variables: anObject [

	<generated>
	variables value: anObject
]
