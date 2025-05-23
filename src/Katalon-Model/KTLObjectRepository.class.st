"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `objectDeclarations` | `KTLObjectRepository` | `objectRepository` | `KTLObjectDeclaration` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `project` | `KTLObjectRepository` | `objectRepository` | `KTLProject` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `directoryPath` | `Object` | nil | |
| `register` | `Object` | nil | |

"
Class {
	#name : 'KTLObjectRepository',
	#superclass : 'KTLEntity',
	#instVars : [
		'#directoryPath => FMProperty',
		'#register => FMProperty',
		'#project => FMOne type: #KTLProject opposite: #objectRepository',
		'#objectDeclarations => FMMany type: #KTLObjectDeclaration opposite: #objectRepository'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLObjectRepository class >> annotation [

	<FMClass: #ObjectRepository super: #KTLEntity>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
KTLObjectRepository >> addObjectDeclaration: anObject [
	<generated>
	^ self objectDeclarations add: anObject
]

{ #category : 'accessing' }
KTLObjectRepository >> directoryPath [

	<FMProperty: #directoryPath type: #Object>
	<generated>
	^ directoryPath
]

{ #category : 'accessing' }
KTLObjectRepository >> directoryPath: anObject [
	<generated>
	directoryPath := anObject
]

{ #category : 'accessing' }
KTLObjectRepository >> objectDeclarations [
	"Relation named: #objectDeclarations type: #KTLObjectDeclaration opposite: #objectRepository"

	<generated>
	<derived>
	^ objectDeclarations
]

{ #category : 'accessing' }
KTLObjectRepository >> objectDeclarations: anObject [

	<generated>
	objectDeclarations value: anObject
]

{ #category : 'navigation' }
KTLObjectRepository >> objectDeclarationsGroup [
	<generated>
	<navigation: 'ObjectDeclarations'>
	^ MooseSpecializedGroup withAll: self objectDeclarations asSet
]

{ #category : 'accessing' }
KTLObjectRepository >> project [
	"Relation named: #project type: #KTLProject opposite: #objectRepository"

	<generated>
	<derived>
	^ project
]

{ #category : 'accessing' }
KTLObjectRepository >> project: anObject [

	<generated>
	project := anObject
]
