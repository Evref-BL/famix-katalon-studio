"
I represent a specific katalon test case

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `project` | `KTLTestCase` | `testCases` | `KTLProject` | |
| `scriptGroovy` | `KTLTestCase` | `testCase` | `KTLScriptGroovy` | |
| `testSteps` | `KTLTestCase` | `testCases` | `KTLTestStep` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `name` | `String` | nil | |
| `parsingError` | `Boolean` | false | |
| `zephyrId` | `String` | nil | |

"
Class {
	#name : 'KTLTestCase',
	#superclass : 'KTLEntity',
	#instVars : [
		'#name => FMProperty',
		'#zephyrId => FMProperty',
		'#parsingError => FMProperty defaultValue: false',
		'#project => FMOne type: #KTLProject opposite: #testCases',
		'#scriptGroovy => FMOne type: #KTLScriptGroovy opposite: #testCase',
		'#testSteps => FMMany type: #KTLTestStep opposite: #testCases'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLTestCase class >> annotation [

	<FMClass: #TestCase super: #KTLEntity>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
KTLTestCase >> addTestStep: anObject [
	<generated>
	^ self testSteps add: anObject
]

{ #category : 'accessing' }
KTLTestCase >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name
]

{ #category : 'accessing' }
KTLTestCase >> name: anObject [
	<generated>
	name := anObject
]

{ #category : 'accessing' }
KTLTestCase >> parsingError [

	<FMProperty: #parsingError type: #Boolean defaultValue: false>
	<generated>
	^ parsingError ifNil: [ parsingError := false ]
]

{ #category : 'accessing' }
KTLTestCase >> parsingError: anObject [
	<generated>
	parsingError := anObject
]

{ #category : 'accessing' }
KTLTestCase >> project [
	"Relation named: #project type: #KTLProject opposite: #testCases"

	<generated>
	^ project
]

{ #category : 'accessing' }
KTLTestCase >> project: anObject [

	<generated>
	project := anObject
]

{ #category : 'accessing' }
KTLTestCase >> scriptGroovy [
	"Relation named: #scriptGroovy type: #KTLScriptGroovy opposite: #testCase"

	<generated>
	^ scriptGroovy
]

{ #category : 'accessing' }
KTLTestCase >> scriptGroovy: anObject [

	<generated>
	scriptGroovy := anObject
]

{ #category : 'accessing' }
KTLTestCase >> testSteps [
	"Relation named: #testSteps type: #KTLTestStep opposite: #testCases"

	<generated>
	^ testSteps
]

{ #category : 'accessing' }
KTLTestCase >> testSteps: anObject [

	<generated>
	testSteps value: anObject
]

{ #category : 'accessing' }
KTLTestCase >> zephyrId [

	<FMProperty: #zephyrId type: #String>
	<generated>
	^ zephyrId
]

{ #category : 'accessing' }
KTLTestCase >> zephyrId: anObject [
	<generated>
	zephyrId := anObject
]
