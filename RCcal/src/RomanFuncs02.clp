;####################################################################################
;;;;;; To print out the facts use: (printout t (facts) crlf) .

;;;These functions calculate the date of Easter, including the Easter falling before or after a given date.

;;;Rules and functions start here
(deffunction F10_CalcEaster
    (?imYear ?imMethod)
    
    ;validate the arguments
    (if (or (< ?imMethod ?*iEDM_JULIAN*) (> ?imMethod ?*iEDM_WESTERN*)) then
        (return nil)
    )
    (if (and (= ?imMethod ?*iEDM_JULIAN*) (< ?imYear ?*iFIRST_EASTER_YEAR*)) then
        (return nil)
    )
    (if (and (or (= ?imMethod ?*iEDM_ORTHODOX*) (= ?imMethod ?*iEDM_WESTERN*)) (or (< ?imYear ?*iFIRST_VALID_GREGORIAN_YEAR*) (> ?imYear ?*iLAST_VALID_GREGORIAN_YEAR*))) then
        (return nil)
    )

    (if (or (= ?imMethod ?*iEDM_JULIAN*) (= ?imMethod ?*iEDM_ORTHODOX*)) then
        ;Using the formula by Jean Meeus in his book Astronomical Algorithms (1991, p. 69)
        (bind ?iA (mod ?imYear 4))
        (bind ?iB (mod ?imYear 7))
        (bind ?iC (mod ?imYear 19))
        (bind ?iD (mod (+ (* 19 ?iC) 15) 30))
        (bind ?iE (mod (+ (- (+ (* 2 ?iA) (* 4 ?iB)) ?iD) 34) 7))
        (bind ?iMonth (floor (/ (+ ?iD ?iE 114) 31)))
        (bind ?iDay (+ (mod (+ ?iD ?iE 114) 31) 1))
        (bind ?dTemp (mkDate ?imYear ?iMonth ?iDay))
        (if (= ?imMethod ?*iEDM_ORTHODOX*) then
            (bind ?iTemp (pJulianToCJDN ?imYear ?iMonth ?iDay))
            (bind ?dTemp (pCJDNToMilankovic ?iTemp))
            (return ?dTemp)
        else
            ;return Julian date for Easter
            (return ?dTemp)
        )
    )
    
    (if (= ?imMethod ?*iEDM_WESTERN*) then
        ;Using the Meeus/Jones/Butcher algorithm; Jean Meeus, Astronomical Algorithms (1991, pp. 67-68).
        (bind ?iA (mod ?imYear 19))
        (bind ?iB (floor (/ ?imYear 100)))
        (bind ?iC (mod ?imYear 100))
        (bind ?iD (floor (/ ?iB 4)))
        (bind ?iE (mod ?iB 4))
        (bind ?iF (floor (/ (+ ?iB 8) 25)))
        (bind ?iG (floor (/ (+ (- ?iB ?iF) 1) 3)))
        (bind ?iH (mod (- (+ (* 19 ?iA) ?iB 15) ?iD ?iG) 30))
        (bind ?iI (floor (/ ?iC 4)))
        (bind ?iK (mod ?iC 4))
        (bind ?iL (mod (- (+ 32 (* 2 ?iE) (* 2 ?iI)) ?iH ?iK) 7))
        (bind ?iM (floor (/ (+ ?iA (* 11 ?iH) (* 22 ?iL)) 451)))
        (bind ?iMonth (floor (/ (- (+ ?iH ?iL 114) (* 7 ?iM)) 31)))
        (bind ?iDay (+ (mod (- (+ ?iH ?iL 114) (* 7 ?iM)) 31) 1))
        (bind ?dTemp (mkDate ?imYear ?iMonth ?iDay))
        ;return Gregorian date for Easter
        (return ?dTemp)
    )

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
