"
I represent a switch

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `body` | `KTLSwitchDecisionStmt` | `switchStatement` | `KTLStepBlock` | represents the body in a switch case|



"
Class {
	#name : 'KTLSwitchDecisionStmt',
	#superclass : 'KTLDecisionStmt',
	#instVars : [
		'#body => FMOne type: #KTLStepBlock opposite: #switchStatement'
	],
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLSwitchDecisionStmt class >> annotation [

	<FMClass: #SwitchDecisionStmt super: #KTLDecisionStmt>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'accessing' }
KTLSwitchDecisionStmt >> body [
	"Relation named: #body type: #KTLStepBlock opposite: #switchStatement"

	<generated>
	<FMComment: 'represents the body in a switch case'>
	^ body
]

{ #category : 'accessing' }
KTLSwitchDecisionStmt >> body: anObject [

	<generated>
	body := anObject
]

{ #category : 'navigation' }
KTLSwitchDecisionStmt >> bodyGroup [
	<generated>
	<navigation: 'Body'>
	^ MooseSpecializedGroup with: self body
]
