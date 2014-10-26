;####################################################################################
;;;;;; To print out the facts use: (printout t (facts) crlf) .



;;;Rules and functions start here
(deffunction F10_CalcEaster
    (?imYear ?imMethod)
    
    ; default values for invalid arguments
    (bind ?imDay 0)
    (bind ?imMonth 0)
    ; intermediate results (all integers)
    (bind ?iFirstDig 0)
    (bind ?iRemain19 0)
    (bind ?iTempNum 0)
    ; tables A to E results (all integers)
    (bind ?iTableA 0)
    (bind ?iTableB 0)
    (bind ?iTableC 0)
    (bind ?iTableD 0)
    (bind ?iTableE 0)
    ;Default return value indicating error.
    (bind ?ipReturn 0)
    
    ;validate the arguments
    (if (or (< ?imMethod ?*iEDM_JULIAN*) (> ?imMethod ?*iEDM_WESTERN*)) then
        (return ?ipReturn)
    )
    (if (and (= ?imMethod ?*iEDM_JULIAN*) (< ?imYear ?*iFIRST_EASTER_YEAR*)) then
        (return ?ipReturn)
    )
    (if (and (or (= ?imMethod ?*iEDM_ORTHODOX*) (= ?imMethod ?*iEDM_WESTERN*)) (or (< ?imYear ?*iFIRST_VALID_GREGORIAN_YEAR*) (> ?imYear ?*iLAST_VALID_GREGORIAN_YEAR*))) then
        (return ?ipReturn)
    )
    
    ;Calculate Easter Sunday date
    ;   first two digits of the year
    (bind ?iFirstDig (div ?imYear 100))
    (bind ?iRemain19 (mod ?imYear 19))
    
    (if (or (= ?imMethod ?*iEDM_JULIAN*) (= ?imMethod ?*iEDM_ORTHODOX*)) then
        ;Calulate the PFM date
        (bind ?iTableA (+ (mod (- 225 (* 11 ?iRemain19)) 30) 21))
        
        ;Find the next Sunday
        (bind ?iTableB (mod (- ?iTableA 19) 7))
        (bind ?iTableC (mod (- 40 ?iFirstDig) 7))
        
        (bind ?iTempNum (mod ?imYear 100))
        (bind ?iTableD (mod (+ ?iTempNum (div ?iTempNum 4)) 7))
        
        (bind ?iTableE (+ (mod (- 20 ?iTableB ?iTableC ?iTableD) 7) 1))
        (bind ?imDay (+ ?iTableA ?iTableE))
        
        ;Convert Julian to Gregorian date
        (if (= ?imMethod ?*iEDM_ORTHODOX*) then
            ;Ten days were skipped in the Gregorian between 5 - 14 October 1582.
            (bind ?iTempNum 10)
            ;Only one in every four century years are leaps years in the Gregorian calendar.
            ;   Every century year is a leap year in the Julian calendar.
            (if (> ?imYear 1600) then
                (bind ?iTempNum (+ ?iTempNum (- ?iFirstDig 16 (div (- ?iFirstDig 16) 4))))
            )
            (bind ?imDay (+ ?imDay ?iTempNum))
        )
    )
    (if (= ?imMethod ?*iEDM_WESTERN*) then
        ;Calculate PFM date
        (bind ?iTempNum (- (+ (div (- ?iFirstDig 15) 2) 202) (* 11 ?iRemain19)))
        (switch ?iTempNum
            (case 21 then (bind ?iTempNum (- ?iTempNum 1)))
            (case 24 then (bind ?iTempNum (- ?iTempNum 1)))
            (case 25 then (bind ?iTempNum (- ?iTempNum 1)))
            (case 27 then (bind ?iTempNum (- ?iTempNum 1)))
            (case 28 then (bind ?iTempNum (- ?iTempNum 1)))
            (case 29 then (bind ?iTempNum (- ?iTempNum 1)))
            (case 30 then (bind ?iTempNum (- ?iTempNum 1)))
            (case 31 then (bind ?iTempNum (- ?iTempNum 1)))
            (case 32 then (bind ?iTempNum (- ?iTempNum 1)))
            (case 34 then (bind ?iTempNum (- ?iTempNum 1)))
            (case 35 then (bind ?iTempNum (- ?iTempNum 1)))
            (case 38 then (bind ?iTempNum (- ?iTempNum 1)))
            (case 33 then (bind ?iTempNum (- ?iTempNum 2)))
            (case 36 then (bind ?iTempNum (- ?iTempNum 2)))
            (case 37 then (bind ?iTempNum (- ?iTempNum 2)))
            (case 39 then (bind ?iTempNum (- ?iTempNum 2)))
            (case 40 then (bind ?iTempNum (- ?iTempNum 2)))
            (default none)
        )
        (bind ?iTempNum (mod ?iTempNum 30))

        (bind ?iTableA (+ ?iTempNum 21))
        (if (= ?iTempNum 29) then
            (bind ?iTableA (- ?iTableA 1))
        )
        (if (and (= ?iTempNum 28) (> ?iRemain19 10)) then
            (bind ?iTableA (- ?iTableA 1))
        )

        ;Find the next Sunday
        (bind ?iTableB (mod (- ?iTableA 19) 7))
        
        (bind ?iTableC (mod (- 40 ?iFirstDig) 4))
        (if (= ?iTableC 3) then
            (bind ?iTableC (+ ?iTableC 1))
        )
        (if (> ?iTableC 1) then
            (bind ?iTableC (+ ?iTableC 1))
        )
        
        (bind ?iTempNum (mod ?imYear 100))
        (bind ?iTableD (mod (+ ?iTempNum (div ?iTempNum 4)) 7))
        
        (bind ?iTableE (+ (mod (- 20 ?iTableB ?iTableC ?iTableD) 7) 1))
	(bind ?imDay (+ ?iTableA ?iTableE))
    )
    
    ;Return the date of Easter
    (if (> ?imDay 61) then
        (bind ?imDay (- ?imDay 61))
        ;Easter can occur in May for ?*iEDM_ORTHODOX*.
        (bind ?imMonth 5)
    else
        (if (> ?imDay 31) then
            (bind ?imDay (- ?imDay 31))
            (bind ?imMonth 4)
        else
            (bind ?imMonth 3)
        )
    )
    
    (return (mkDate ?imYear ?imMonth ?imDay))
)
(deffunction F09_CalcPreviousEaster
    (?dDate ?iDateMethod)
    
    ;Check arguments
    (bind ?iYearTemp (yearFromDateINT ?dDate))
    (if (or (not (integerp ?dDate)) (not (integerp ?iDateMethod))) then
        (return nil)
    )
    (if (or (< ?iDateMethod ?*iEDM_JULIAN*) (> ?iDateMethod ?*iEDM_WESTERN*)) then
        (return nil)
    )
    
    (bind ?dDateHolder (F10_CalcEaster ?iYearTemp ?iDateMethod))
    (if (< ?dDateHolder ?dDate) then
        (return ?dDateHolder)
    else
        (return (F10_CalcEaster (- ?iYearTemp 1) ?iDateMethod))
    )
)
(deffunction F11_CalcNextEaster
    (?dDate ?iDateMethod)
    
    
    ;Check arguments
    (bind ?iYearTemp (yearFromDateINT ?dDate))
    (if (or (not (integerp ?dDate)) (not (integerp ?iDateMethod))) then
        (return nil)
    )
    (if (or (< ?iDateMethod ?*iEDM_JULIAN*) (> ?iDateMethod ?*iEDM_WESTERN*)) then
        (return nil)
    )
    
    (bind ?dDateHolder (F10_CalcEaster ?iYearTemp ?iDateMethod))
    (if (> ?dDateHolder ?dDate) then
        (return ?dDateHolder)
    else
        (return (F10_CalcEaster (+ ?iYearTemp 1) ?iDateMethod))
    )
)
