Class {
	#name : 'ZephyrAPI',
	#superclass : 'Object',
	#instVars : [
		'client',
		'hostUrl',
		'privateToken',
		'output'
	],
	#category : 'Zephyr-API-Core',
	#package : 'Zephyr-API-Core'
}

{ #category : 'accessing' }
ZephyrAPI >> client [

	^ client
]

{ #category : 'accessing' }
ZephyrAPI >> client: anObject [

	client := anObject
]

{ #category : 'accessing' }
ZephyrAPI >> get: endPoint withParams: paramsDict [

	| response |
	self client path: self hostUrl , endPoint.
	paramsDict keysAndValuesDo: [ :key :value |
		self client queryAt: key put: value ].

	response := self client get.

	self output = 'json' ifTrue: [ ^ response ].

	^ NeoJSONReader fromString: response
]

{ #category : 'accessing' }
ZephyrAPI >> getAll: endpoint withParams: paramsDict [

	| currentIndex maxResult results |
	currentIndex := 0.
	maxResult := 100.
	results := nil.

	[
	| response |
	response := self
		            getStartingAt: currentIndex
		            maxResults: maxResult
		            from: endpoint
		            withParams: paramsDict.


	self output = 'json'
		ifTrue: [ results add: response ]
		ifFalse: [
			results
				ifNil: [
					results := response.
					results
						at: #values
						put: (response at: #values) asOrderedCollection ]
				ifNotNil: [
					(results at: #values) addAll:
						(response at: #values) asOrderedCollection ] ].
	currentIndex := currentIndex + maxResult.

	response at: #isLast ] whileFalse.

	^ results
]

{ #category : 'accessing' }
ZephyrAPI >> getStartingAt: index maxResults: maxRes from: endpoint withParams: paramsDict [

	| newParams |
	newParams := Dictionary new.
	newParams at: #startAt put: index.
	newParams at: #maxResults put: maxRes.

	paramsDict keysAndValuesDo: [ :key :value |
		newParams at: key put: value ].

	^ self get: endpoint withParams: newParams
]

{ #category : 'accessing' }
ZephyrAPI >> hostUrl [

	^ hostUrl
]

{ #category : 'accessing' }
ZephyrAPI >> hostUrl: anObject [

	hostUrl := anObject
]

{ #category : 'accessing' }
ZephyrAPI >> initialize [

	client := ZnClient new
		          accept: ZnMimeType applicationJson;
		          yourself.
	hostUrl := 'https://api.zephyrscale.smartbear.com/v2'.
	self privateBearerToken:
		'aPrivateToken'
]

{ #category : 'accessing' }
ZephyrAPI >> output [

	^ output
]

{ #category : 'accessing' }
ZephyrAPI >> output: anObject [

	output := anObject
]

{ #category : 'accessing' }
ZephyrAPI >> privateBearerToken: aBearerToken [

	client setBearerAuthentication: aBearerToken.
	privateToken := aBearerToken
]

{ #category : 'accessing' }
ZephyrAPI >> testcases: projectKey [
	"https://docs.gitlab.com/ee/api/merge_requests.html#list-project-merge-requests"

	| endpoint |
	endpoint := '/testcases'.

	^ self
		  getAll: endpoint
		  withParams: { (#projectKey -> projectKey asString) } asDictionary
]
