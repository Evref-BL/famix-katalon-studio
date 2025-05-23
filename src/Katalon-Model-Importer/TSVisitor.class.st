Class {
	#name : 'TSVisitor',
	#superclass : 'Object',
	#instVars : [
		'importer',
		'sourceText'
	],
	#category : 'Katalon-Model-Importer',
	#package : 'Katalon-Model-Importer'
}

{ #category : 'accessing' }
TSVisitor >> importer: anKTLImporter [
 	importer := anKTLImporter 
]

{ #category : 'accessing' }
TSVisitor >> sourceText [

	^ sourceText
]

{ #category : 'accessing' }
TSVisitor >> sourceText: anObject [

	sourceText := anObject
]

{ #category : 'as yet unclassified' }
TSVisitor >> sourceTextOfNode: aTSNode [
	^ aTSNode textFromSourceText: self sourceText.
]

{ #category : 'visiting' }
TSVisitor >> visitNode: aTSNode [

	aTSNode collectNamedChild do: [ :child | child accept: self ]
]
