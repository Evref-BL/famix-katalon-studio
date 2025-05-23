Class {
	#name : 'KTLCustomKeywordVisitor',
	#superclass : 'GroovyVisitor',
	#category : 'Katalon-Model-Importer',
	#package : 'Katalon-Model-Importer'
}

{ #category : 'visiting' }
KTLCustomKeywordVisitor >> visitGroovyClassDefinition: aTSNode withFields: fields [

	| entity |
	
	self flag: 'consider changing for class parsing'.
	importer currentNode: aTSNode.

	"1 halt. "
	entity := KTLCustomKeywordClass new
		          filePath: importer sourcesStack top filePath;
		          yourself.
	entity name: (self visitKey: 'name' inDictionnary: fields) sourceText.
	

	(importer parser parseString:
		 importer sourcesStack top filePath contents) rootNode
		detectNamedChild: #groovy_package
		ifOne: [ :package |
			| packageName |
			package detectNamedChild: #qualified_name ifOne: [ :pckNode |
				packageName := pckNode textFromSourceText:
					               importer sourcesStack top filePath contents.
				entity package: packageName ] ].

	(self visitKey: 'body' inDictionnary: fields) steps do: [ :elmt |
		(elmt isKindOf: KTLCustomKeyword) ifTrue: [
			entity customKeywordsGroup
				detect: [ :kw | kw name = elmt name ]
				ifNone: [
					entity addCustomKeyword: elmt.
					importer model add: elmt ] ].

		(elmt isKindOf: KTLCustomKeywordClass) ifTrue: [
			entity subClasses
				detect: [ :kw | kw name = elmt name ]
				ifNone: [ entity addSubClass: elmt ] ].

		(elmt isKindOf: KTLDeclaration) ifTrue: [
			| attribut |
			attribut := KTLCustomKeywordClassAttribute newFrom: elmt.
			entity customKeywordClassAttributes
				detect: [ :kw | kw name = attribut name ]
				ifNone: [
					entity addCustomKeywordClassAttribute: attribut.
					importer model add: attribut ] ] ].


	"
		  (self visitKey: 'name' inDictionnary: fields).
		  (self visitKey: 'body' inDictionnary: fields) "

	importer model add: entity. 
	^ entity
]

{ #category : 'visiting' }
KTLCustomKeywordVisitor >> visitGroovyDeclaration: aTSNode withFields: fields [

	| entity |
	importer currentNode: aTSNode.
	"
	^ {
		  (self visitKey: 'type' inDictionnary: fields).
		  (self visitKey: 'name' inDictionnary: fields).
		  (self visitKey: 'value' inDictionnary: fields) }"
	^ self lastEntity: (KTLModel new newDeclaration accept: importer)
]

{ #category : 'visiting' }
KTLCustomKeywordVisitor >> visitGroovyFunctionDefinition: aTSNode withFields: fields [

	| entity |
	importer currentNode: aTSNode.
	entity := (KTLModel new newmethodDef accept: importer). 

	aTSNode
		detectNamedChild: #annotation
		ifOne: [ :a | 
			"look for annotation @Keyword"
			((self sourceTextOfNode: a) = #'@Keyword') ifTrue: [
				entity := KTLCustomKeyword newFrom: entity.
				].
			].

	^ self lastEntity: entity
	"^ {
		  (self visitKey: 'function' inDictionnary: fields).
		  (self visitKey: 'parameters' inDictionnary: fields).
		  (self visitKey: 'body' inDictionnary: fields) }"
]

{ #category : 'visiting' }
KTLCustomKeywordVisitor >> visitGroovyGroovyPackage: aTSNode withFields: fields [
		|packageName|
	"1 halt. 
	importer currentNode: aTSNode.	

	
		
		aTSNode detectNamedChild: #qualified_name ifOne: [ :pckNode |
			packageName := self sourceTextOfNode: pckNode.
			importer sourcesStack top package: packageName ] ."
	
	^ nil 
	
	

]
