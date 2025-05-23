Extension { #name : 'FileReference' }

{ #category : '*Katalon-Model-Exporter' }
FileReference >> replaceContentWith: aString [
	
	| encoded|
	self delete.
	self asFileReference ensureCreateFile.
	encoded := self writeStreamEncoded: 'utf8'.
	encoded nextPutAll: aString.
	"self writeStreamDo: [ :st | st nextPutAll: aString ]"
	encoded close.
]
