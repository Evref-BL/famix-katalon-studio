"
I represent a catch

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `tryCatchStatement` | `KTLCatchStmt` | `catches` | `KTLTryCatchDecisionStmt` | link to a try catch|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `catch` | `KTLCatchStmt` | `catchStatement` | `KTLStepBlock` | represents the steps in a catch|
| `exception` | `KTLCatchStmt` | `catchStatement` | `KTLTestStep` | represents the exeception of a catch|



"
Class {
	#name : 'KTLCatchStmt',
	#superclass : 'KTLStatement',
	#instVars : [
		'#tryCatchStatement => FMOne type: #KTLTryCatchDecisionStmt opposite: #catches',
		'#exception => FMOne type: #KTLTestStep opposite: #catchStatement',
		'#catch => FMOne type: #KTLStepBlock opposite: #catchStatement'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLCatchStmt class >> annotation [

	<FMClass: #CatchStmt super: #KTLStatement>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
KTLCatchStmt >> catch [
	"Relation named: #catch type: #KTLStepBlock opposite: #catchStatement"

	<generated>
	<FMComment: 'represents the steps in a catch'>
	^ catch
]

{ #category : 'accessing' }
KTLCatchStmt >> catch: anObject [

	<generated>
	catch := anObject
]

{ #category : 'navigation' }
KTLCatchStmt >> catchGroup [
	<generated>
	<navigation: 'Catch'>
	^ MooseSpecializedGroup with: self catch
]

{ #category : 'accessing' }
KTLCatchStmt >> exception [
	"Relation named: #exception type: #KTLTestStep opposite: #catchStatement"

	<generated>
	<FMComment: 'represents the exeception of a catch'>
	^ exception
]

{ #category : 'accessing' }
KTLCatchStmt >> exception: anObject [

	<generated>
	exception := anObject
]

{ #category : 'navigation' }
KTLCatchStmt >> exceptionGroup [
	<generated>
	<navigation: 'Exception'>
	^ MooseSpecializedGroup with: self exception
]

{ #category : 'accessing' }
KTLCatchStmt >> tryCatchStatement [
	"Relation named: #tryCatchStatement type: #KTLTryCatchDecisionStmt opposite: #catches"

	<generated>
	<FMComment: 'link to a try catch'>
	<container>
	^ tryCatchStatement
]

{ #category : 'accessing' }
KTLCatchStmt >> tryCatchStatement: anObject [

	<generated>
	tryCatchStatement := anObject
]

{ #category : 'navigation' }
KTLCatchStmt >> tryCatchStatementGroup [
	<generated>
	<navigation: 'TryCatchStatement'>
	^ MooseSpecializedGroup with: self tryCatchStatement
]
