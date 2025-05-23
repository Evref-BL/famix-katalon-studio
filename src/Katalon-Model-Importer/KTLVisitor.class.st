Class {
	#name : 'KTLVisitor',
	#superclass : 'Object',
	#instVars : [
		'importer',
		'stackScope'
	],
	#category : 'Katalon-Model-Importer',
	#package : 'Katalon-Model-Importer'
}

{ #category : 'initialization' }
KTLVisitor >> initialize [ 
	super initialize.
	stackScope := Stack new
]
