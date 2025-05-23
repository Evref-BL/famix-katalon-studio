"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `customKeywords` | `KTLProject` | `project` | `KTLCustomKeyword` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `globalVars` | `KTLProject` | `project` | `KTLGlobalVar` | |
| `objectRepository` | `KTLProject` | `project` | `KTLObjectRepository` | |
| `testCases` | `KTLProject` | `project` | `KTLTestCase` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `directoryPath` | `Object` | nil | |
| `name` | `String` | nil | |

"
Class {
	#name : 'KTLProject',
	#superclass : 'KTLEntity',
	#instVars : [
		'#name => FMProperty',
		'#directoryPath => FMProperty',
		'#objectRepository => FMOne type: #KTLObjectRepository opposite: #project',
		'#testCases => FMMany type: #KTLTestCase opposite: #project',
		'#customKeywords => FMMany type: #KTLCustomKeyword opposite: #project',
		'#globalVars => FMMany type: #KTLGlobalVar opposite: #project'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLProject class >> annotation [

	<FMClass: #Project super: #KTLEntity>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
KTLProject >> addCustomKeyword: anObject [
	<generated>
	^ self customKeywords add: anObject
]

{ #category : 'adding' }
KTLProject >> addGlobalVar: anObject [
	<generated>
	^ self globalVars add: anObject
]

{ #category : 'adding' }
KTLProject >> addTestCase: anObject [
	<generated>
	^ self testCases add: anObject
]

{ #category : 'accessing' }
KTLProject >> customKeywords [
	"Relation named: #customKeywords type: #KTLCustomKeyword opposite: #project"

	<generated>
	<derived>
	^ customKeywords
]

{ #category : 'accessing' }
KTLProject >> customKeywords: anObject [

	<generated>
	customKeywords value: anObject
]

{ #category : 'navigation' }
KTLProject >> customKeywordsGroup [
	<generated>
	<navigation: 'CustomKeywords'>
	^ MooseSpecializedGroup withAll: self customKeywords asSet
]

{ #category : 'accessing' }
KTLProject >> directoryPath [

	<FMProperty: #directoryPath type: #Object>
	<generated>
	^ directoryPath
]

{ #category : 'accessing' }
KTLProject >> directoryPath: anObject [
	<generated>
	directoryPath := anObject
]

{ #category : 'accessing' }
KTLProject >> globalVars [
	"Relation named: #globalVars type: #KTLGlobalVar opposite: #project"

	<generated>
	<derived>
	^ globalVars
]

{ #category : 'accessing' }
KTLProject >> globalVars: anObject [

	<generated>
	globalVars value: anObject
]

{ #category : 'accessing' }
KTLProject >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name
]

{ #category : 'accessing' }
KTLProject >> name: anObject [
	<generated>
	name := anObject
]

{ #category : 'accessing' }
KTLProject >> objectRepository [
	"Relation named: #objectRepository type: #KTLObjectRepository opposite: #project"

	<generated>
	^ objectRepository
]

{ #category : 'accessing' }
KTLProject >> objectRepository: anObject [

	<generated>
	objectRepository := anObject
]

{ #category : 'accessing' }
KTLProject >> testCases [
	"Relation named: #testCases type: #KTLTestCase opposite: #project"

	<generated>
	<derived>
	^ testCases
]

{ #category : 'accessing' }
KTLProject >> testCases: anObject [

	<generated>
	testCases value: anObject
]
