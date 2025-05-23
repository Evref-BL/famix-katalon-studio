Class {
	#name : 'KTLEntity',
	#superclass : 'MooseEntity',
	#traits : 'TEntityMetaLevelDependency',
	#classTraits : 'TEntityMetaLevelDependency classTrait',
	#category : 'Katalon-Model-Entities',
	#package : 'Katalon-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
KTLEntity class >> annotation [

	<FMClass: #Entity super: #MooseEntity>
	<package: #'Katalon-Model'>
	<generated>
	<abstract>
	^ self
]

{ #category : 'testing' }
KTLEntity class >> isAbstract [

	<generated>
	^ self == KTLEntity
]

{ #category : 'meta' }
KTLEntity class >> metamodel [

	<generated>
	^ KTLModel metamodel
]
