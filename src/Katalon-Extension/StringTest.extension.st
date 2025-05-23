Extension { #name : 'StringTest' }

{ #category : '*Katalon-Extension' }
StringTest >> testSplitOnCaseSensitive [
	|txt split|
	split := 'test'.
	txt := 'foo TEST bar test toto'.
	self assert: (txt splitOn: split caseSensitive: false) size equals: 3.  
]

{ #category : '*Katalon-Extension' }
StringTest >> testSplitOnCaseSensitiveFalse [

	| txt split |
	split := 'test'.
	txt := 'foo TEST bar test toto'.
	self assert: (txt splitOn: split caseSensitive: false) size equals: 3
]

{ #category : '*Katalon-Extension' }
StringTest >> testSplitOnCaseSensitiveNoMatchFalse [

	| txt split |
	split := '123'.
	txt := 'foo TEST bar test toto'.
	self
		assert: (txt splitOn: split caseSensitive: true) first
		equals: txt
]

{ #category : '*Katalon-Extension' }
StringTest >> testSplitOnCaseSensitiveNoMatchTrue [

	| txt split |
	split := '123'.
	txt := 'foo TEST bar test toto'.
	self assert: (txt splitOn: split caseSensitive: true) first equals: txt 
]

{ #category : '*Katalon-Extension' }
StringTest >> testSplitOnCaseSensitiveNoSplitValue [

	| txt split |
	split := ''.
	txt := 'foo TEST bar test toto'.
	self
		assert: (txt splitOn: split caseSensitive: true) first
		equals: txt
]

{ #category : '*Katalon-Extension' }
StringTest >> testSplitOnCaseSensitiveTrue [

	| txt split |
	split := 'test'.
	txt := 'foo TEST bar test toto'.
	self assert: (txt splitOn: split caseSensitive: true) size equals: 2
]
