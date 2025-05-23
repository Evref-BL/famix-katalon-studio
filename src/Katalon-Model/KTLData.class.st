"
I represent the data used in a Test

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `testSteps` | `KTLData` | `datas` | `KTLTestStep` | |



"
Class {
	#name : 'KTLData',
	#superclass : 'KTLEntity',
	#instVars : [
		'#testSteps => FMMany type: #KTLTestStep opposite: #datas'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLData class >> annotation [

	<FMClass: #Data super: #KTLEntity>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
KTLData >> addTestStep: anObject [
	<generated>
	^ self testSteps add: anObject
]

{ #category : 'accessing' }
KTLData >> testSteps [
	"Relation named: #testSteps type: #KTLTestStep opposite: #datas"

	<generated>
	^ testSteps
]

{ #category : 'accessing' }
KTLData >> testSteps: anObject [

	<generated>
	testSteps value: anObject
]
