Extension { #name : 'String' }

{ #category : '*Katalon-Model-Generator' }
String >> normalizeIdentifier [

	| newString |
	newString := self collect: [ :c |
		             (c isLetter or: [ c isDigit ])
			             ifTrue: [ c asCharacter ]
			             ifFalse: [ Character space ] ].
	newString first isDigit ifTrue: [ newString:= ('T', newString) ].

	^ newString asCamelCase
]
