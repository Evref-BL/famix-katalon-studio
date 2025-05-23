Extension { #name : 'TSNode' }

{ #category : '*Katalon-Extension' }
TSNode >> accept: aTSVisitor [
  ^ aTSVisitor visitNode: self

]
