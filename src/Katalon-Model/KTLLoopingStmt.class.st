"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `loopBody` | `KTLLoopingStmt` | `loopStmt` | `KTLStepBlock` | represents the steps in a loop|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `condition` | `String` | nil | |

"
Class {
	#name : 'KTLLoopingStmt',
	#superclass : 'KTLStatement',
	#instVars : [
		'#condition => FMProperty',
		'#loopBody => FMOne type: #KTLStepBlock opposite: #loopStmt'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLLoopingStmt class >> annotation [

	<FMClass: #LoopingStmt super: #KTLStatement>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
KTLLoopingStmt >> condition [

	<FMProperty: #condition type: #String>
	<generated>
	^ condition
]

{ #category : 'accessing' }
KTLLoopingStmt >> condition: anObject [
	<generated>
	condition := anObject
]

{ #category : 'accessing' }
KTLLoopingStmt >> loopBody [
	"Relation named: #loopBody type: #KTLStepBlock opposite: #loopStmt"

	<generated>
	<FMComment: 'represents the steps in a loop'>
	^ loopBody
]

{ #category : 'accessing' }
KTLLoopingStmt >> loopBody: anObject [

	<generated>
	loopBody := anObject
]

{ #category : 'navigation' }
KTLLoopingStmt >> loopBodyGroup [
	<generated>
	<navigation: 'LoopBody'>
	^ MooseSpecializedGroup with: self loopBody
]
