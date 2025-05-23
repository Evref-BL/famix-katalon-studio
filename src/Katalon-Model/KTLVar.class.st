"
I represent an abstract variable

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `scriptGroovy` | `KTLVar` | `vars` | `KTLScriptGroovy` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `assignments` | `KTLVar` | `variable` | `KTLAssignment` | the katalon assignments of a variable (local of global)|
| `references` | `KTLVar` | `variables` | `KTLTestStep` | the katalon references of a variable (local of global) inside any steps|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `initValue` | `String` | nil | |
| `name` | `String` | nil | |
| `type` | `String` | nil | |

"
Class {
	#name : 'KTLVar',
	#superclass : 'KTLEntity',
	#instVars : [
		'#name => FMProperty',
		'#type => FMProperty',
		'#initValue => FMProperty',
		'#assignments => FMMany type: #KTLAssignment opposite: #variable',
		'#references => FMMany type: #KTLTestStep opposite: #variables',
		'#scriptGroovy => FMOne type: #KTLScriptGroovy opposite: #vars'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLVar class >> annotation [

	<FMClass: #Var super: #KTLEntity>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
KTLVar >> addAssignment: anObject [
	<generated>
	^ self assignments add: anObject
]

{ #category : 'adding' }
KTLVar >> addReference: anObject [
	<generated>
	^ self references add: anObject
]

{ #category : 'accessing' }
KTLVar >> assignments [
	"Relation named: #assignments type: #KTLAssignment opposite: #variable"

	<generated>
	<FMComment: 'the katalon assignments of a variable (local of global)'>
	<derived>
	^ assignments
]

{ #category : 'accessing' }
KTLVar >> assignments: anObject [

	<generated>
	assignments value: anObject
]

{ #category : 'accessing' }
KTLVar >> initValue [

	<FMProperty: #initValue type: #String>
	<generated>
	^ initValue
]

{ #category : 'accessing' }
KTLVar >> initValue: anObject [
	<generated>
	initValue := anObject
]

{ #category : 'accessing' }
KTLVar >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name
]

{ #category : 'accessing' }
KTLVar >> name: anObject [
	<generated>
	name := anObject
]

{ #category : 'accessing' }
KTLVar >> references [
	"Relation named: #references type: #KTLTestStep opposite: #variables"

	<generated>
	<FMComment: 'the katalon references of a variable (local of global) inside any steps'>
	^ references
]

{ #category : 'accessing' }
KTLVar >> references: anObject [

	<generated>
	references value: anObject
]

{ #category : 'accessing' }
KTLVar >> scriptGroovy [
	"Relation named: #scriptGroovy type: #KTLScriptGroovy opposite: #vars"

	<generated>
	<container>
	^ scriptGroovy
]

{ #category : 'accessing' }
KTLVar >> scriptGroovy: anObject [

	<generated>
	scriptGroovy := anObject
]

{ #category : 'navigation' }
KTLVar >> scriptGroovyGroup [
	<generated>
	<navigation: 'ScriptGroovy'>
	^ MooseSpecializedGroup with: self scriptGroovy
]

{ #category : 'accessing' }
KTLVar >> type [

	<FMProperty: #type type: #String>
	<generated>
	^ type
]

{ #category : 'accessing' }
KTLVar >> type: anObject [
	<generated>
	type := anObject
]
