"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `customKeywordClassAttributes` | `KTLCustomKeywordClass` | `customKeywordClass` | `KTLCustomKeywordClassAttribute` | |
| `customKeywords` | `KTLCustomKeywordClass` | `customKeywordClass` | `KTLCustomKeyword` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentClass` | `KTLCustomKeywordClass` | `subClasses` | `KTLCustomKeywordClass` | parent class of current declaration|
| `subClasses` | `KTLCustomKeywordClass` | `parentClass` | `KTLCustomKeywordClass` | inner subclass|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `filePath` | `String` | nil | |
| `name` | `String` | nil | |
| `package` | `String` | nil | |
| `sourceText` | `String` | nil | |

"
Class {
	#name : 'KTLCustomKeywordClass',
	#superclass : 'KTLEntity',
	#instVars : [
		'#name => FMProperty',
		'#package => FMProperty',
		'#sourceText => FMProperty',
		'#filePath => FMProperty',
		'#customKeywords => FMMany type: #KTLCustomKeyword opposite: #customKeywordClass',
		'#customKeywordClassAttributes => FMMany type: #KTLCustomKeywordClassAttribute opposite: #customKeywordClass',
		'#subClasses => FMMany type: #KTLCustomKeywordClass opposite: #parentClass',
		'#parentClass => FMOne type: #KTLCustomKeywordClass opposite: #subClasses'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLCustomKeywordClass class >> annotation [

	<FMClass: #CustomKeywordClass super: #KTLEntity>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
KTLCustomKeywordClass >> addCustomKeyword: anObject [
	<generated>
	^ self customKeywords add: anObject
]

{ #category : 'adding' }
KTLCustomKeywordClass >> addCustomKeywordClassAttribute: anObject [
	<generated>
	^ self customKeywordClassAttributes add: anObject
]

{ #category : 'adding' }
KTLCustomKeywordClass >> addSubClass: anObject [
	<generated>
	^ self subClasses add: anObject
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> customKeywordClassAttributes [
	"Relation named: #customKeywordClassAttributes type: #KTLCustomKeywordClassAttribute opposite: #customKeywordClass"

	<generated>
	<derived>
	^ customKeywordClassAttributes
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> customKeywordClassAttributes: anObject [

	<generated>
	customKeywordClassAttributes value: anObject
]

{ #category : 'navigation' }
KTLCustomKeywordClass >> customKeywordClassAttributesGroup [
	<generated>
	<navigation: 'CustomKeywordClassAttributes'>
	^ MooseSpecializedGroup withAll: self customKeywordClassAttributes asSet
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> customKeywords [
	"Relation named: #customKeywords type: #KTLCustomKeyword opposite: #customKeywordClass"

	<generated>
	<derived>
	^ customKeywords
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> customKeywords: anObject [

	<generated>
	customKeywords value: anObject
]

{ #category : 'navigation' }
KTLCustomKeywordClass >> customKeywordsGroup [
	<generated>
	<navigation: 'CustomKeywords'>
	^ MooseSpecializedGroup withAll: self customKeywords asSet
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> filePath [

	<FMProperty: #filePath type: #String>
	<generated>
	^ filePath
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> filePath: anObject [
	<generated>
	filePath := anObject
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> name: anObject [
	<generated>
	name := anObject
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> package [

	<FMProperty: #package type: #String>
	<generated>
	^ package
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> package: anObject [
	<generated>
	package := anObject
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> parentClass [
	"Relation named: #parentClass type: #KTLCustomKeywordClass opposite: #subClasses"

	<generated>
	<FMComment: 'parent class of current declaration'>
	^ parentClass
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> parentClass: anObject [

	<generated>
	parentClass := anObject
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> sourceText [

	<FMProperty: #sourceText type: #String>
	<generated>
	^ sourceText
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> sourceText: anObject [
	<generated>
	sourceText := anObject
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> subClasses [
	"Relation named: #subClasses type: #KTLCustomKeywordClass opposite: #parentClass"

	<generated>
	<FMComment: 'inner subclass'>
	<derived>
	^ subClasses
]

{ #category : 'accessing' }
KTLCustomKeywordClass >> subClasses: anObject [

	<generated>
	subClasses value: anObject
]
