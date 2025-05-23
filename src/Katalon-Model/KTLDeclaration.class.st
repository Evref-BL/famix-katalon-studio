"
## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `variable` | `KTLDeclaration` | `declaration` | `KTLLocalVar` | a global variable|



"
Class {
	#name : 'KTLDeclaration',
	#superclass : 'KTLStatement',
	#instVars : [
		'#variable => FMOne type: #KTLLocalVar opposite: #declaration'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLDeclaration class >> annotation [

	<FMClass: #Declaration super: #KTLStatement>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
KTLDeclaration >> variable [
	"Relation named: #variable type: #KTLLocalVar opposite: #declaration"

	<generated>
	<FMComment: 'a global variable'>
	^ variable
]

{ #category : 'accessing' }
KTLDeclaration >> variable: anObject [

	<generated>
	variable := anObject
]
