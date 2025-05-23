"
## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `name` | `String` | nil | |
| `parameters` | `Object` | nil | |
| `returnType` | `String` | nil | |

"
Class {
	#name : 'KTLmethodDef',
	#superclass : 'KTLStatement',
	#instVars : [
		'#name => FMProperty',
		'#returnType => FMProperty',
		'#parameters => FMProperty'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLmethodDef class >> annotation [

	<FMClass: #methodDef super: #KTLStatement>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
KTLmethodDef >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name
]

{ #category : 'accessing' }
KTLmethodDef >> name: anObject [
	<generated>
	name := anObject
]

{ #category : 'accessing' }
KTLmethodDef >> parameters [

	<FMProperty: #parameters type: #Object>
	<generated>
	^ parameters
]

{ #category : 'accessing' }
KTLmethodDef >> parameters: anObject [
	<generated>
	parameters := anObject
]

{ #category : 'accessing' }
KTLmethodDef >> returnType [

	<FMProperty: #returnType type: #String>
	<generated>
	^ returnType
]

{ #category : 'accessing' }
KTLmethodDef >> returnType: anObject [
	<generated>
	returnType := anObject
]
