Extension { #name : 'Character' }

{ #category : '*Katalon-Extension' }
Character >> withoutAccent [
	
	|dico|
    dico := Dictionary newFrom: {
        $À -> $A. $Á -> $A. $Â -> $A. $Ã -> $A. $Ä -> $A. $Å -> $A.
        $à -> $a. $á -> $a. $â -> $a. $ã -> $a. $ä -> $a. $å -> $a.
        $È -> $E. $É -> $E. $Ê -> $E. $Ë -> $E.
        $è -> $e. $é -> $e. $ê -> $e. $ë -> $e.
        $Ì -> $I. $Í -> $I. $Î -> $I. $Ï -> $I.
        $ì -> $i. $í -> $i. $î -> $i. $ï -> $i.
        $Ò -> $O. $Ó -> $O. $Ô -> $O. $Õ -> $O. $Ö -> $O. $Ø -> $O.
        $ò -> $o. $ó -> $o. $ô -> $o. $õ -> $o. $ö -> $o. $ø -> $o.
        $Ù -> $U. $Ú -> $U. $Û -> $U. $Ü -> $U.
        $ù -> $u. $ú -> $u. $û -> $u. $ü -> $u.
        $Ç -> $C. $ç -> $c.
        $Ñ -> $N. 
		  $ñ -> $n.
        $Ý -> $Y. $Ÿ -> $y.
		  $ý -> $y. $ÿ -> $y
    }.

	^ dico at: self ifAbsent: [self].
]

{ #category : '*Katalon-Extension' }
Character >> withoutSpecialFeature [

	^ self asciiValue < 128
		  ifTrue: [ self ]
		  ifFalse: [ "retourne $? pour un caractère inconnu" $# ]
]
