"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `objectRepository` | `KTLObjectDeclaration` | `objectDeclarations` | `KTLObjectRepository` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `refObjChildren` | `KTLObjectDeclaration` | `refObjParent` | `KTLObjectDeclaration` | a object can have children references|
| `refObjParent` | `KTLObjectDeclaration` | `refObjChildren` | `KTLObjectDeclaration` | a object can have a parent reference|
| `testSteps` | `KTLObjectDeclaration` | `objectDeclarations` | `KTLTestStep` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `filePath` | `Object` | nil | |
| `identifierPath` | `String` | nil | |
| `idx` | `Number` | nil | |
| `isIFrame` | `Boolean` | false | |
| `isShadow` | `Boolean` | false | |
| `locator` | `String` | nil | |
| `locatorMethod` | `String` | nil | |
| `name` | `String` | nil | |

"
Class {
	#name : 'KTLObjectDeclaration',
	#superclass : 'KTLEntity',
	#instVars : [
		'#filePath => FMProperty',
		'#idx => FMProperty',
		'#name => FMProperty',
		'#identifierPath => FMProperty',
		'#locator => FMProperty',
		'#locatorMethod => FMProperty',
		'#isShadow => FMProperty defaultValue: false',
		'#isIFrame => FMProperty defaultValue: false',
		'#objectRepository => FMOne type: #KTLObjectRepository opposite: #objectDeclarations',
		'#testSteps => FMMany type: #KTLTestStep opposite: #objectDeclarations',
		'#refObjParent => FMOne type: #KTLObjectDeclaration opposite: #refObjChildren',
		'#refObjChildren => FMMany type: #KTLObjectDeclaration opposite: #refObjParent'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLObjectDeclaration class >> annotation [

	<FMClass: #ObjectDeclaration super: #KTLEntity>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
KTLObjectDeclaration >> addRefObjChildren: anObject [
	<generated>
	^ self refObjChildren add: anObject
]

{ #category : 'adding' }
KTLObjectDeclaration >> addTestStep: anObject [
	<generated>
	^ self testSteps add: anObject
]

{ #category : 'accessing' }
KTLObjectDeclaration >> filePath [

	<FMProperty: #filePath type: #Object>
	<generated>
	^ filePath
]

{ #category : 'accessing' }
KTLObjectDeclaration >> filePath: anObject [
	<generated>
	filePath := anObject
]

{ #category : 'accessing' }
KTLObjectDeclaration >> identifierPath [

	<FMProperty: #identifierPath type: #String>
	<generated>
	^ identifierPath
]

{ #category : 'accessing' }
KTLObjectDeclaration >> identifierPath: anObject [
	<generated>
	identifierPath := anObject
]

{ #category : 'accessing' }
KTLObjectDeclaration >> isIFrame [

	<FMProperty: #isIFrame type: #Boolean defaultValue: false>
	<generated>
	^ isIFrame ifNil: [ isIFrame := false ]
]

{ #category : 'accessing' }
KTLObjectDeclaration >> isIFrame: anObject [
	<generated>
	isIFrame := anObject
]

{ #category : 'accessing' }
KTLObjectDeclaration >> isShadow [

	<FMProperty: #isShadow type: #Boolean defaultValue: false>
	<generated>
	^ isShadow ifNil: [ isShadow := false ]
]

{ #category : 'accessing' }
KTLObjectDeclaration >> isShadow: anObject [
	<generated>
	isShadow := anObject
]

{ #category : 'accessing' }
KTLObjectDeclaration >> locator [

	<FMProperty: #locator type: #String>
	<generated>
	^ locator
]

{ #category : 'accessing' }
KTLObjectDeclaration >> locator: anObject [
	<generated>
	locator := anObject
]

{ #category : 'accessing' }
KTLObjectDeclaration >> locatorMethod [

	<FMProperty: #locatorMethod type: #String>
	<generated>
	^ locatorMethod
]

{ #category : 'accessing' }
KTLObjectDeclaration >> locatorMethod: anObject [
	<generated>
	locatorMethod := anObject
]

{ #category : 'accessing' }
KTLObjectDeclaration >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name
]

{ #category : 'accessing' }
KTLObjectDeclaration >> name: anObject [
	<generated>
	name := anObject
]

{ #category : 'accessing' }
KTLObjectDeclaration >> objectRepository [
	"Relation named: #objectRepository type: #KTLObjectRepository opposite: #objectDeclarations"

	<generated>
	<container>
	^ objectRepository
]

{ #category : 'accessing' }
KTLObjectDeclaration >> objectRepository: anObject [

	<generated>
	objectRepository := anObject
]

{ #category : 'navigation' }
KTLObjectDeclaration >> objectRepositoryGroup [
	<generated>
	<navigation: 'ObjectRepository'>
	^ MooseSpecializedGroup with: self objectRepository
]

{ #category : 'accessing' }
KTLObjectDeclaration >> refObjChildren [
	"Relation named: #refObjChildren type: #KTLObjectDeclaration opposite: #refObjParent"

	<generated>
	<FMComment: 'a object can have children references'>
	<derived>
	^ refObjChildren
]

{ #category : 'accessing' }
KTLObjectDeclaration >> refObjChildren: anObject [

	<generated>
	refObjChildren value: anObject
]

{ #category : 'accessing' }
KTLObjectDeclaration >> refObjParent [
	"Relation named: #refObjParent type: #KTLObjectDeclaration opposite: #refObjChildren"

	<generated>
	<FMComment: 'a object can have a parent reference'>
	^ refObjParent
]

{ #category : 'accessing' }
KTLObjectDeclaration >> refObjParent: anObject [

	<generated>
	refObjParent := anObject
]

{ #category : 'accessing' }
KTLObjectDeclaration >> testSteps [
	"Relation named: #testSteps type: #KTLTestStep opposite: #objectDeclarations"

	<generated>
	^ testSteps
]

{ #category : 'accessing' }
KTLObjectDeclaration >> testSteps: anObject [

	<generated>
	testSteps value: anObject
]
