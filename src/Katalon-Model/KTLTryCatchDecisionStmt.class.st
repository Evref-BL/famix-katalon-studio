"
I represent a try/catch

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `catches` | `KTLTryCatchDecisionStmt` | `tryCatchStatement` | `KTLCatchStmt` | represents the multiples catch blocks|
| `finally` | `KTLTryCatchDecisionStmt` | `tryStatement` | `KTLStepBlock` | represents the steps in a finally|
| `try` | `KTLTryCatchDecisionStmt` | `tryStatement` | `KTLStepBlock` | represents the steps in a try|



"
Class {
	#name : 'KTLTryCatchDecisionStmt',
	#superclass : 'KTLDecisionStmt',
	#instVars : [
		'#try => FMOne type: #KTLStepBlock opposite: #tryStatement',
		'#catches => FMMany type: #KTLCatchStmt opposite: #tryCatchStatement',
		'#finally => FMOne type: #KTLStepBlock opposite: #tryStatement'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLTryCatchDecisionStmt class >> annotation [

	<FMClass: #TryCatchDecisionStmt super: #KTLDecisionStmt>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
KTLTryCatchDecisionStmt >> addCatch: anObject [
	<generated>
	^ self catches add: anObject
]

{ #category : 'accessing' }
KTLTryCatchDecisionStmt >> catches [
	"Relation named: #catches type: #KTLCatchStmt opposite: #tryCatchStatement"

	<generated>
	<FMComment: 'represents the multiples catch blocks'>
	<derived>
	^ catches
]

{ #category : 'accessing' }
KTLTryCatchDecisionStmt >> catches: anObject [

	<generated>
	catches value: anObject
]

{ #category : 'navigation' }
KTLTryCatchDecisionStmt >> catchesGroup [
	<generated>
	<navigation: 'Catches'>
	^ MooseSpecializedGroup withAll: self catches asSet
]

{ #category : 'accessing' }
KTLTryCatchDecisionStmt >> finally [
	"Relation named: #finally type: #KTLStepBlock opposite: #tryStatement"

	<generated>
	<FMComment: 'represents the steps in a finally'>
	^ finally
]

{ #category : 'accessing' }
KTLTryCatchDecisionStmt >> finally: anObject [

	<generated>
	finally := anObject
]

{ #category : 'navigation' }
KTLTryCatchDecisionStmt >> finallyGroup [
	<generated>
	<navigation: 'Finally'>
	^ MooseSpecializedGroup with: self finally
]

{ #category : 'accessing' }
KTLTryCatchDecisionStmt >> try [
	"Relation named: #try type: #KTLStepBlock opposite: #tryStatement"

	<generated>
	<FMComment: 'represents the steps in a try'>
	^ try
]

{ #category : 'accessing' }
KTLTryCatchDecisionStmt >> try: anObject [

	<generated>
	try := anObject
]

{ #category : 'navigation' }
KTLTryCatchDecisionStmt >> tryGroup [
	<generated>
	<navigation: 'Try'>
	^ MooseSpecializedGroup with: self try
]
