"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `testSteps` | `KTLScriptGroovy` | `scriptGroovy` | `KTLTestStep` | |
| `vars` | `KTLScriptGroovy` | `scriptGroovy` | `KTLVar` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `testCase` | `KTLScriptGroovy` | `scriptGroovy` | `KTLTestCase` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `extension` | `String` | 'groovy' | |
| `filePath` | `Object` | nil | |

"
Class {
	#name : 'KTLScriptGroovy',
	#superclass : 'KTLEntity',
	#instVars : [
		'#filePath => FMProperty',
		'#extension => FMProperty defaultValue: \'groovy\'',
		'#testCase => FMOne type: #KTLTestCase opposite: #scriptGroovy',
		'#testSteps => FMMany type: #KTLTestStep opposite: #scriptGroovy',
		'#vars => FMMany type: #KTLVar opposite: #scriptGroovy'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLScriptGroovy class >> annotation [

	<FMClass: #ScriptGroovy super: #KTLEntity>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
KTLScriptGroovy >> addTestStep: anObject [
	<generated>
	^ self testSteps add: anObject
]

{ #category : 'adding' }
KTLScriptGroovy >> addVar: anObject [
	<generated>
	^ self vars add: anObject
]

{ #category : 'accessing' }
KTLScriptGroovy >> extension [

	<FMProperty: #extension type: #String defaultValue: 'groovy'>
	<generated>
	^ extension ifNil: [ extension := 'groovy' ]
]

{ #category : 'accessing' }
KTLScriptGroovy >> extension: anObject [
	<generated>
	extension := anObject
]

{ #category : 'accessing' }
KTLScriptGroovy >> filePath [

	<FMProperty: #filePath type: #Object>
	<generated>
	^ filePath
]

{ #category : 'accessing' }
KTLScriptGroovy >> filePath: anObject [
	<generated>
	filePath := anObject
]

{ #category : 'accessing' }
KTLScriptGroovy >> testCase [
	"Relation named: #testCase type: #KTLTestCase opposite: #scriptGroovy"

	<generated>
	<derived>
	^ testCase
]

{ #category : 'accessing' }
KTLScriptGroovy >> testCase: anObject [

	<generated>
	testCase := anObject
]

{ #category : 'accessing' }
KTLScriptGroovy >> testSteps [
	"Relation named: #testSteps type: #KTLTestStep opposite: #scriptGroovy"

	<generated>
	<derived>
	^ testSteps
]

{ #category : 'accessing' }
KTLScriptGroovy >> testSteps: anObject [

	<generated>
	testSteps value: anObject
]

{ #category : 'navigation' }
KTLScriptGroovy >> testStepsGroup [
	<generated>
	<navigation: 'TestSteps'>
	^ MooseSpecializedGroup withAll: self testSteps asSet
]

{ #category : 'accessing' }
KTLScriptGroovy >> vars [
	"Relation named: #vars type: #KTLVar opposite: #scriptGroovy"

	<generated>
	<derived>
	^ vars
]

{ #category : 'accessing' }
KTLScriptGroovy >> vars: anObject [

	<generated>
	vars value: anObject
]

{ #category : 'navigation' }
KTLScriptGroovy >> varsGroup [
	<generated>
	<navigation: 'Vars'>
	^ MooseSpecializedGroup withAll: self vars asSet
]
