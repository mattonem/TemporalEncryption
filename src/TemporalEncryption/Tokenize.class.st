Class {
	#name : #Tokenize,
	#superclass : #Object,
	#instVars : [
		'key'
	],
	#category : #'TemporalEncryption-Core'
}

{ #category : #'instance creation' }
Tokenize class >> key: aCollection [
	^ self new
		key: aCollection;
		yourself
]

{ #category : #'as yet unclassified' }
Tokenize >> decode: aCollection [
	^ self decode: aCollection timeOut: self timeout
]

{ #category : #'as yet unclassified' }
Tokenize >> decode: aCollection time: aDateAndTime [
	| d string |
	d := self newCipherAtTime: aDateAndTime.
	string := (d decrypt: aCollection) asString.
	^ (STON fromString: string) at: 'data'
]

{ #category : #'as yet unclassified' }
Tokenize >> decode: aCollection timeOut: aDuration [
	| now |
	now := self truncateTime: (DateAndTime now + 1 minute).
	^ (now - aDuration to: now by: 1 minute) dateAndTimes reverse
		detect: [ :aMinute | 
			| ret |
			[ ret := true.
			self decode: aCollection time: aMinute ]
				on: Error
				do: [ ret := false ].
			ret ]
		ifFound: [ :theMinute | self decode: aCollection time: theMinute ]
		ifNone: [ TECouldNotDecode signal ]
]

{ #category : #processing }
Tokenize >> encode: anObject [
	^ self encode: anObject time: DateAndTime now.
]

{ #category : #'as yet unclassified' }
Tokenize >> encode: anObject time: aDateAndTime [
	| d time data |
	time := self truncateTime: aDateAndTime.
	d := DES key: (self genKeyAtTime: time).
	data := STON
		toString:
			{('rand' -> UUIDGenerator next).
			('data' -> anObject)} asDictionary.
	^ d encrypt: data asByteArray
]

{ #category : #'as yet unclassified' }
Tokenize >> genKeyAtTime: aDateAndTime [
	^ SHA256 hashMessage: (STON toString: aDateAndTime) asByteArray , key
]

{ #category : #accessing }
Tokenize >> key: aCollection [ 
	key := aCollection
]

{ #category : #'as yet unclassified' }
Tokenize >> newCipherAtTime: aDateAndTime [
	^ DES key: (self genKeyAtTime: aDateAndTime)
]

{ #category : #'as yet unclassified' }
Tokenize >> timeout [
	^ 1 hour
]

{ #category : #'as yet unclassified' }
Tokenize >> truncateTime: aDateAndTime [
	| time |
	time := aDateAndTime truncated.
	time := time - time seconds.
	^ time
]
