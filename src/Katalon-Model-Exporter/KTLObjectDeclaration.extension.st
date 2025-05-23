Extension { #name : 'KTLObjectDeclaration' }

{ #category : '*Katalon-Model-Exporter' }
KTLObjectDeclaration >> groupName [

	^ self cacheAt: #idGroupName ifAbsentPut: [
		|splits|
		  splits := (self identifierPath splitOn: '/') .
			splits size > 1 ifTrue: [splits nextToLast normalizeIdentifier] ifFalse: [splits first].
		 
		 "		  | splits grpName id |
			  splits := self identifierPath splitOn: '/'.
			  grpName := splits nextToLast normalizeIdentifier.
			  id := '' join: (splits collect: [ :segment |
					         segment normalizeIdentifier contractTo: 3 ]).

			  grpName , id " ]
]

{ #category : '*Katalon-Model-Exporter' }
KTLObjectDeclaration >> hasRefParent [
	^ self refObjParent isNotNil and: [self refObjParent name isNotNil]
]

{ #category : '*Katalon-Model-Exporter' }
KTLObjectDeclaration >> idx [

	<FMProperty: #idx type: #Number>
	<generated>
	^ idx
]

{ #category : '*Katalon-Model-Exporter' }
KTLObjectDeclaration >> idx: anInteger [ 
	idx:= anInteger .
]

{ #category : '*Katalon-Model-Exporter' }
KTLObjectDeclaration >> printForImportStmt [
	^ idx ifNotNil: [ self groupName, ' as ', self printImportVar ] ifNil: [self groupName] 
]

{ #category : '*Katalon-Model-Exporter' }
KTLObjectDeclaration >> printImportVar [

	^ idx
		  ifNotNil: [ self groupName , 'V' , idx printString ]
		  ifNil: [ self groupName ] 
]
