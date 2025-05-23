Class {
	#name : 'BaselineOfKatalon',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfKatalon',
	#package : 'BaselineOfKatalon'
}

{ #category : 'baselines' }
BaselineOfKatalon >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self defineDependencies: spec.
		self definePackages: spec.
		self defineGroups: spec ]
]

{ #category : 'baselines' }
BaselineOfKatalon >> defineDependencies: spec [
	"dependency"

	spec
		baseline: 'TreeSitter'
		with: [
		spec repository: 'github://Evref-BL/Pharo-Tree-Sitter:develop/src' ].
	
	spec
		baseline: 'GitlabAPI'
		with: [
		spec repository: 'github://Evref-BL/Gitlab-Pharo-API:develop' ].
]

{ #category : 'baselines' }
BaselineOfKatalon >> defineGroups: spec [

	
]

{ #category : 'baselines' }
BaselineOfKatalon >> definePackages: spec [

	spec
		package: 'Katalon-Model' with: [ spec requires: #( 'Katalon-Model-Generator' ) ];
		package: 'Katalon-Model-Generator';
		package: 'Katalon-Model-Exporter' with: [ spec requires: #( 'Katalon-Model-Generator' 'Katalon-Model' ) ];
		package: 'Katalon-Model-Importer' .
]
