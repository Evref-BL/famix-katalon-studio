Extension { #name : 'KTLTestCase' }

{ #category : '*Katalon-Model-Exporter' }
KTLTestCase >> isCalledTestCase [
	^ self testSteps isNotEmpty
]
