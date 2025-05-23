Extension { #name : 'KTLTestCase' }

{ #category : '*Katalon-Model-Importer' }
KTLTestCase >> orginalIdentifierPath [
	|ogFile idPath|
	ogFile := self scriptGroovy filePath.
	idPath := ogFile asPath segments 
								copyFrom: (ogFile asPath segments indexOf: 'Scripts')+1 
								to: (ogFile asPath segments indexOf: self name).
	^ '/' join: idPath.
				
]
