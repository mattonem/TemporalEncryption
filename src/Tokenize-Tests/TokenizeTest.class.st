"
A TokenizeTest is a test class for testing the behavior of Tokenize
"
Class {
	#name : #TokenizeTest,
	#superclass : #TestCase,
	#category : #'Tokenize-Tests'
}

{ #category : #tests }
TokenizeTest >> testTokenize [
	| d tok obj |
	d := Tokenize key: 'privateKey' asByteArray.
	tok := d encode: true time: (DateAndTime now).
	self assert: (d decode: tok).
	tok := d encode: 'Lige is strange' time: (DateAndTime now - 30 minutes).
	obj := d decode: tok.
	self assert: obj equals: 'Lige is strange'.
	tok := d encode: 'Lige is strange' time: (DateAndTime now - 2 hours).
	self should: [d decode: tok ] raise: TokCannotDecode.
	
	
]
