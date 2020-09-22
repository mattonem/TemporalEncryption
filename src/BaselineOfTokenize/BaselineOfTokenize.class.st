Class {
	#name : #BaselineOfTokenize,
	#superclass : #BaselineOf,
	#category : #BaselineOfTokenize
}

{ #category : #baselines }
BaselineOfTokenize >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			 spec
				baseline: 'Cryptography'
				with: [ spec
						repository: 'github://pharo-contributions/Cryptography:master/repository';
						loads: #core ].
			spec package: 'Tokenize'.
			spec package: 'Tokenize-Tests' with: [ spec requires: #(#Tokenize) ] ]
]
