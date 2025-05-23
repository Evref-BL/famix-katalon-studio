"
## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `variable` | `KTLAssignment` | `assignments` | `KTLVar` | a variable|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `isDeclaration` | `Boolean` | false | |

"
Class {
	#name : 'KTLAssignment',
	#superclass : 'KTLStatement',
	#instVars : [
		'#isDeclaration => FMProperty defaultValue: false',
		'#variable => FMOne type: #KTLVar opposite: #assignments'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLAssignment class >> annotation [

	<FMClass: #Assignment super: #KTLStatement>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
KTLAssignment >> isDeclaration [

	<FMProperty: #isDeclaration type: #Boolean defaultValue: false>
	<generated>
	^ isDeclaration ifNil: [ isDeclaration := false ]
]

{ #category : 'accessing' }
KTLAssignment >> isDeclaration: anObject [
	<generated>
	isDeclaration := anObject
]

{ #category : 'accessing' }
KTLAssignment >> variable [
	"Relation named: #variable type: #KTLVar opposite: #assignments"

	<generated>
	<FMComment: 'a variable'>
	^ variable
]

{ #category : 'accessing' }
KTLAssignment >> variable: anObject [

	<generated>
	variable := anObject
]
