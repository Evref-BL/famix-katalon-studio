"
I represent a global variable accessible by all entites of a test

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `project` | `KTLGlobalVar` | `globalVars` | `KTLProject` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `description` | `String` | nil | |
| `varProfiles` | `Object` | nil | |

"
Class {
	#name : 'KTLGlobalVar',
	#superclass : 'KTLVar',
	#instVars : [
		'#description => FMProperty',
		'#varProfiles => FMProperty',
		'#project => FMOne type: #KTLProject opposite: #globalVars'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLGlobalVar class >> annotation [

	<FMClass: #GlobalVar super: #KTLVar>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
KTLGlobalVar >> description [

	<FMProperty: #description type: #String>
	<generated>
	^ description
]

{ #category : 'accessing' }
KTLGlobalVar >> description: anObject [
	<generated>
	description := anObject
]

{ #category : 'accessing' }
KTLGlobalVar >> project [
	"Relation named: #project type: #KTLProject opposite: #globalVars"

	<generated>
	^ project
]

{ #category : 'accessing' }
KTLGlobalVar >> project: anObject [

	<generated>
	project := anObject
]

{ #category : 'accessing' }
KTLGlobalVar >> varProfiles [

	<FMProperty: #varProfiles type: #Object>
	<generated>
	^ varProfiles
]

{ #category : 'accessing' }
KTLGlobalVar >> varProfiles: anObject [
	<generated>
	varProfiles := anObject
]
