"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `customKeywordClass` | `KTLCustomKeyword` | `customKeywords` | `KTLCustomKeywordClass` | |
| `project` | `KTLCustomKeyword` | `customKeywords` | `KTLProject` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `testSteps` | `KTLCustomKeyword` | `customKeywords` | `KTLTestStep` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `identifierPath` | `String` | nil | |

"
Class {
	#name : 'KTLCustomKeyword',
	#superclass : 'KTLmethodDef',
	#instVars : [
		'#customKeywordClass => FMOne type: #KTLCustomKeywordClass opposite: #customKeywords',
		'#identifierPath => FMProperty',
		'#project => FMOne type: #KTLProject opposite: #customKeywords'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLCustomKeyword class >> annotation [

	<FMClass: #CustomKeyword super: #KTLmethodDef>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
KTLCustomKeyword >> addTestStep: anObject [
	<generated>
	^ self testSteps add: anObject
]

{ #category : 'accessing' }
KTLCustomKeyword >> customKeywordClass [
	"Relation named: #customKeywordClass type: #KTLCustomKeywordClass opposite: #customKeywords"

	<generated>
	<container>
	^ customKeywordClass
]

{ #category : 'accessing' }
KTLCustomKeyword >> customKeywordClass: anObject [

	<generated>
	customKeywordClass := anObject
]

{ #category : 'navigation' }
KTLCustomKeyword >> customKeywordClassGroup [
	<generated>
	<navigation: 'CustomKeywordClass'>
	^ MooseSpecializedGroup with: self customKeywordClass
]

{ #category : 'accessing' }
KTLCustomKeyword >> identifierPath [

	<FMProperty: #identifierPath type: #String>
	<generated>
	^ identifierPath
]

{ #category : 'accessing' }
KTLCustomKeyword >> identifierPath: anObject [
	<generated>
	identifierPath := anObject
]

{ #category : 'accessing' }
KTLCustomKeyword >> project [
	"Relation named: #project type: #KTLProject opposite: #customKeywords"

	<generated>
	<container>
	^ project
]

{ #category : 'accessing' }
KTLCustomKeyword >> project: anObject [

	<generated>
	project := anObject
]

{ #category : 'navigation' }
KTLCustomKeyword >> projectGroup [
	<generated>
	<navigation: 'Project'>
	^ MooseSpecializedGroup with: self project
]

{ #category : 'accessing' }
KTLCustomKeyword >> testSteps [
	"Relation named: #testSteps type: #KTLTestStep opposite: #customKeywords"

	<generated>
	<derived>
	^ testSteps
]

{ #category : 'accessing' }
KTLCustomKeyword >> testSteps: anObject [

	<generated>
	testSteps value: anObject
]
