"
I represent a local variable accessible by all step of a test

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `declaration` | `KTLLocalVar` | `variable` | `KTLDeclaration` | a katalon declaration of a local variable|



"
Class {
	#name : 'KTLLocalVar',
	#superclass : 'KTLVar',
	#instVars : [
		'#declaration => FMOne type: #KTLDeclaration opposite: #variable'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLLocalVar class >> annotation [

	<FMClass: #LocalVar super: #KTLVar>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
KTLLocalVar >> declaration [
	"Relation named: #declaration type: #KTLDeclaration opposite: #variable"

	<generated>
	<FMComment: 'a katalon declaration of a local variable'>
	<derived>
	^ declaration
]

{ #category : 'accessing' }
KTLLocalVar >> declaration: anObject [

	<generated>
	declaration := anObject
]
