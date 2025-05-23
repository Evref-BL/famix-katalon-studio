"
I represent a script statement in groovy

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `testSteps` | `KTLStatement` | `statements` | `KTLTestStep` | |



"
Class {
	#name : 'KTLStatement',
	#superclass : 'KTLTestStep',
	#instVars : [
		'#testSteps => FMMany type: #KTLTestStep opposite: #statements'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLStatement class >> annotation [

	<FMClass: #Statement super: #KTLTestStep>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
KTLStatement >> addTestStep: anObject [
	<generated>
	^ self testSteps add: anObject
]

{ #category : 'accessing' }
KTLStatement >> testSteps [
	"Relation named: #testSteps type: #KTLTestStep opposite: #statements"

	<generated>
	^ testSteps
]

{ #category : 'accessing' }
KTLStatement >> testSteps: anObject [

	<generated>
	testSteps value: anObject
]
