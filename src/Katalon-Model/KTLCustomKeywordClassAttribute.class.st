"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `customKeywordClass` | `KTLCustomKeywordClassAttribute` | `customKeywordClassAttributes` | `KTLCustomKeywordClass` | |



"
Class {
	#name : 'KTLCustomKeywordClassAttribute',
	#superclass : 'KTLDeclaration',
	#instVars : [
		'#customKeywordClass => FMOne type: #KTLCustomKeywordClass opposite: #customKeywordClassAttributes'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLCustomKeywordClassAttribute class >> annotation [

	<FMClass: #CustomKeywordClassAttribute super: #KTLDeclaration>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
KTLCustomKeywordClassAttribute >> customKeywordClass [
	"Relation named: #customKeywordClass type: #KTLCustomKeywordClass opposite: #customKeywordClassAttributes"

	<generated>
	<container>
	^ customKeywordClass
]

{ #category : 'accessing' }
KTLCustomKeywordClassAttribute >> customKeywordClass: anObject [

	<generated>
	customKeywordClass := anObject
]

{ #category : 'navigation' }
KTLCustomKeywordClassAttribute >> customKeywordClassGroup [
	<generated>
	<navigation: 'CustomKeywordClass'>
	^ MooseSpecializedGroup with: self customKeywordClass
]
