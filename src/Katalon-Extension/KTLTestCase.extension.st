Extension { #name : 'KTLTestCase' }

{ #category : '*Katalon-Extension' }
KTLTestCase >> hasParsingError [

	^ parsingError := true
]

{ #category : '*Katalon-Extension' }
KTLTestCase >> ifParsingError: aConstantBlockClosure [

	^ parsingError ifTrue: aConstantBlockClosure
]

{ #category : '*Katalon-Extension' }
KTLTestCase >> ifParsingError: aFullBlockClosure ifNot: aFullBlockClosure2 [ 
	^ parsingError ifTrue: aFullBlockClosure ifFalse: aFullBlockClosure2
]

{ #category : '*Katalon-Extension' }
KTLTestCase >> initialize [
	super initialize. 
	parsingError := false
]

{ #category : '*Katalon-Extension' }
KTLTestCase >> isWithParsingError [
	^ parsingError
]
