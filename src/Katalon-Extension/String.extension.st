Extension { #name : 'String' }

{ #category : '*Katalon-Extension' }
String >> cleanToParse [
	|cleaner|
	cleaner := self copy.
	cleaner := cleaner collect: #withoutAccent.
	cleaner := cleaner collect: #withoutSpecialFeature.
	^ cleaner 
]

{ #category : '*Katalon-Extension' }
String >> splitOn: aString caseSensitive: isCaseSentitive [

	isCaseSentitive
		ifTrue: [ ^ self splitOn: aString ]
		ifFalse: [
			| splits |
			splits := OrderedCollection new.
			self asLowercase
				splitOn: aString asLowercase
				indicesDo: [ :start :end |
				splits add: (self copyFrom: start to: end) ].
			^ splits ]
]

{ #category : '*Katalon-Extension' }
String >> withoutAccent [
	^ self collect: #withoutAccent
]
