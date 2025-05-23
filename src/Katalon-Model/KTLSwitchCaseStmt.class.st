"
I represent a switch case


"
Class {
	#name : 'KTLSwitchCaseStmt',
	#superclass : 'KTLStatement',
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLSwitchCaseStmt class >> annotation [

	<FMClass: #SwitchCaseStmt super: #KTLStatement>
	<package: #'Katalon-Model'>
	<generated>
	^ self
]

{ #category : 'api' }
KTLSwitchCaseStmt >> exportWith: aKTLModelExporter [
	^ aKTLModelExporter exportKTLSwitchCaseStmt: self. 
]
