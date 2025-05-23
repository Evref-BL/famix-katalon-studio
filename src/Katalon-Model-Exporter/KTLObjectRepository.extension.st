Extension { #name : 'KTLObjectRepository' }

{ #category : '*Katalon-Model-Exporter' }
KTLObjectRepository >> register [

	register ifNil: [ register := Dictionary new ].
	^ register 
]

{ #category : '*Katalon-Model-Exporter' }
KTLObjectRepository >> register: anObject [
	<generated>
	register := anObject
]
