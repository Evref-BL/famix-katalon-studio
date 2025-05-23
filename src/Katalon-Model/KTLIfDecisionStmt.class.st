"
I represent a if

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `else` | `KTLIfDecisionStmt` | `ifStatement` | `KTLStepBlock` | represents the steps in a else|
| `if` | `KTLIfDecisionStmt` | `ifStatement` | `KTLStepBlock` | represents the steps in a if|



"
Class {
	#name : 'KTLIfDecisionStmt',
	#superclass : 'KTLDecisionStmt',
	#instVars : [
		'#if => FMOne type: #KTLStepBlock opposite: #ifStatement',
		'#else => FMOne type: #KTLStepBlock opposite: #ifStatement'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLIfDecisionStmt class >> annotation [

	<FMClass: #IfDecisionStmt super: #KTLDecisionStmt>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
KTLIfDecisionStmt >> else [
	"Relation named: #else type: #KTLStepBlock opposite: #ifStatement"

	<generated>
	<FMComment: 'represents the steps in a else'>
	^ else
]

{ #category : 'accessing' }
KTLIfDecisionStmt >> else: anObject [

	<generated>
	else := anObject
]

{ #category : 'navigation' }
KTLIfDecisionStmt >> elseGroup [
	<generated>
	<navigation: 'Else'>
	^ MooseSpecializedGroup with: self else
]

{ #category : 'accessing' }
KTLIfDecisionStmt >> if [
	"Relation named: #if type: #KTLStepBlock opposite: #ifStatement"

	<generated>
	<FMComment: 'represents the steps in a if'>
	^ if
]

{ #category : 'accessing' }
KTLIfDecisionStmt >> if: anObject [

	<generated>
	if := anObject
]

{ #category : 'navigation' }
KTLIfDecisionStmt >> ifGroup [
	<generated>
	<navigation: 'If'>
	^ MooseSpecializedGroup with: self if
]
