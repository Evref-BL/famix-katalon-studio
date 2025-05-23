"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `catchStatement` | `KTLStepBlock` | `catch` | `KTLCatchStmt` | link to an catch block|
| `ifStatement` | `KTLStepBlock` | `else` | `KTLIfDecisionStmt` | link to an else block|
| `ifStatement` | `KTLStepBlock` | `if` | `KTLIfDecisionStmt` | link to an if block|
| `loopStmt` | `KTLStepBlock` | `loopBody` | `KTLLoopingStmt` | link to an loop|
| `switchStatement` | `KTLStepBlock` | `body` | `KTLSwitchDecisionStmt` | link to an the switch |
| `tryStatement` | `KTLStepBlock` | `finally` | `KTLTryCatchDecisionStmt` | link to an finally block|
| `tryStatement` | `KTLStepBlock` | `try` | `KTLTryCatchDecisionStmt` | link to a try catch|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `steps` | `KTLStepBlock` | `block` | `KTLTestStep` | represents the steps inside this block|



"
Class {
	#name : 'KTLStepBlock',
	#superclass : 'KTLStatement',
	#instVars : [
		'#ifStatement => FMOne type: #KTLIfDecisionStmt opposite: #if',
		'#loopStmt => FMOne type: #KTLLoopingStmt opposite: #loopBody',
		'#steps => FMMany type: #KTLTestStep opposite: #block',
		'#switchStatement => FMOne type: #KTLSwitchDecisionStmt opposite: #body',
		'#tryStatement => FMOne type: #KTLTryCatchDecisionStmt opposite: #try'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLStepBlock class >> annotation [

	<FMClass: #StepBlock super: #KTLStatement>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'adding' }
KTLStepBlock >> addStep: anObject [
	<generated>
	^ self steps add: anObject
]

{ #category : 'accessing' }
KTLStepBlock >> catchStatement [
	"Relation named: #catchStatement type: #KTLCatchStmt opposite: #catch"

	<generated>
	<FMComment: 'link to an catch block'>
	<container>
	<derived>
	^ catchStatement
]

{ #category : 'accessing' }
KTLStepBlock >> catchStatement: anObject [

	<generated>
	catchStatement := anObject
]

{ #category : 'navigation' }
KTLStepBlock >> catchStatementGroup [
	<generated>
	<navigation: 'CatchStatement'>
	^ MooseSpecializedGroup with: self catchStatement
]

{ #category : 'accessing' }
KTLStepBlock >> ifStatement [
	"Relation named: #ifStatement type: #KTLIfDecisionStmt opposite: #if"

	<generated>
	<FMComment: 'link to an if block'>
	<container>
	<derived>
	^ ifStatement
]

{ #category : 'accessing' }
KTLStepBlock >> ifStatement: anObject [

	<generated>
	ifStatement := anObject
]

{ #category : 'navigation' }
KTLStepBlock >> ifStatementGroup [
	<generated>
	<navigation: 'IfStatement'>
	^ MooseSpecializedGroup with: self ifStatement
]

{ #category : 'accessing' }
KTLStepBlock >> loopStmt [
	"Relation named: #loopStmt type: #KTLLoopingStmt opposite: #loopBody"

	<generated>
	<FMComment: 'link to an loop'>
	<container>
	<derived>
	^ loopStmt
]

{ #category : 'accessing' }
KTLStepBlock >> loopStmt: anObject [

	<generated>
	loopStmt := anObject
]

{ #category : 'navigation' }
KTLStepBlock >> loopStmtGroup [
	<generated>
	<navigation: 'LoopStmt'>
	^ MooseSpecializedGroup with: self loopStmt
]

{ #category : 'accessing' }
KTLStepBlock >> steps [
	"Relation named: #steps type: #KTLTestStep opposite: #block"

	<generated>
	<FMComment: 'represents the steps inside this block'>
	<derived>
	^ steps
]

{ #category : 'accessing' }
KTLStepBlock >> steps: anObject [

	<generated>
	steps value: anObject
]

{ #category : 'navigation' }
KTLStepBlock >> stepsGroup [
	<generated>
	<navigation: 'Steps'>
	^ MooseSpecializedGroup withAll: self steps asSet
]

{ #category : 'accessing' }
KTLStepBlock >> switchStatement [
	"Relation named: #switchStatement type: #KTLSwitchDecisionStmt opposite: #body"

	<generated>
	<FMComment: 'link to an the switch '>
	<container>
	<derived>
	^ switchStatement
]

{ #category : 'accessing' }
KTLStepBlock >> switchStatement: anObject [

	<generated>
	switchStatement := anObject
]

{ #category : 'navigation' }
KTLStepBlock >> switchStatementGroup [
	<generated>
	<navigation: 'SwitchStatement'>
	^ MooseSpecializedGroup with: self switchStatement
]

{ #category : 'accessing' }
KTLStepBlock >> tryStatement [
	"Relation named: #tryStatement type: #KTLTryCatchDecisionStmt opposite: #try"

	<generated>
	<FMComment: 'link to a try catch'>
	<container>
	<derived>
	^ tryStatement
]

{ #category : 'accessing' }
KTLStepBlock >> tryStatement: anObject [

	<generated>
	tryStatement := anObject
]

{ #category : 'navigation' }
KTLStepBlock >> tryStatementGroup [
	<generated>
	<navigation: 'TryStatement'>
	^ MooseSpecializedGroup with: self tryStatement
]
