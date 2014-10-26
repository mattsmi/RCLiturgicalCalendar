;####################################################################################
;;;;;; To print out the facts use: (printout t (facts) crlf) .



;;;Rules and functions start here
(deffunction string-to-integer
    (?sNumber)
    

    ;We assume a string of integers only.
    ; As soon as we strike a character that is not an integer, bail and return nil.
    (bind ?iLen (str-length ?sNumber))
    (bind ?iNum 0)
    (bind ?iCount ?iLen)
    (while (> ?iCount 0)
	(switch (sub-string ?iCount ?iCount ?sNumber)
	    (case "0" then (bind ?iDigit 0))
	    (case "1" then (bind ?iDigit 1))
	    (case "2" then (bind ?iDigit 2))
	    (case "3" then (bind ?iDigit 3))
	    (case "4" then (bind ?iDigit 4))
	    (case "5" then (bind ?iDigit 5))
	    (case "6" then (bind ?iDigit 6))
	    (case "7" then (bind ?iDigit 7))
	    (case "8" then (bind ?iDigit 8))
	    (case "9" then (bind ?iDigit 9))
	    (default (return nil))
	)
	;Get the sum of each newly found digit multiplied by the appropriate power of ten.
	(bind ?iNum (+ (integer (* ?iDigit (** 10 (- ?iLen ?iCount)))) ?iNum))
	(bind ?iCount (- ?iCount 1))
    )
    
    ?iNum
)

