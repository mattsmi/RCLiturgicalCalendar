;####################################################################################
;;;;;; To print out the facts use: (printout t (facts) crlf) .



;;;Rules and functions start here
(deffunction findLastWordInString
    (?fmString)
    
    ;Ensure any symbol passed in, is treated as a string.
    (bind ?sString (str-cat ?fmString))
    
    ;Finds the last word in a string of words, separated by spaces.
    (bind ?sSeparator " ")
    (if (not (str-index ?sSeparator ?sString)) then
        ;If there is no separator, then the string consists of a single word.
        (return ?sString)
    else
        ;We now know there is a space, we pass the right-most part
        (findLastWordInString (sub-string  (+ (str-index ?sSeparator ?sString) 1) (str-length ?sString) ?sString))
    )   
)
(deffunction findFact
        (?fName)
    ;This fact finds a fact in the list of facts with a given name.
    ;   It returns the address of the fact found

        (bind ?fAddress nil) ; Default, if Fact not found.
	(progn$ (?f (get-fact-list))
		(if (eq (fact-relation ?f) ?fName) then
			(bind ?fAddress  ?f)
                        (break)
                )
        )
	?fAddress
)
(deffunction printFactSlots
        (?fName)
    ;This fact finds a fact in the list of facts with a given name.
    ;   It prints the name of the fact and then all slots and values.

        (progn$ (?f (get-fact-list))
            (if (eq (fact-relation ?f) ?fName) then
                (progn$ (?s (fact-slot-names ?f))
                    (printout t (fact-relation ?f) " -- " crlf)
                    (printout t "   " ?s ": " (fact-slot-value ?f ?s) crlf)
                )
                (printout t crlf)
            )
        ) 
)
(deffunction findFactWithSlot
        (?fName ?sSlotToFind ?sValueToFind)
    ;This fact finds a fact in the list of facts with a given name.
    ;   It returns the address of the fact found

        (bind ?fAddress nil) ; Default, if Fact not found.
	(progn$ (?f (get-fact-list))
		(if (eq (fact-relation ?f) ?fName) then
                    (progn$ (?s (fact-slot-names ?f))
                        (if (eq ?s ?sSlotToFind) then
                            (if (eq (fact-slot-value ?f ?s) ?sValueToFind) then
                                (bind ?fAddress  ?f)
                                (break)
                            )
                        )
                    )
                )
        )
	?fAddress
)

(deffunction isThisALeapYear
    (?baseYear)
    
    ;As a yardstick, knowing that dates are expressed as an integer number of seconds
    ;   after 01 January 1970, 00.00 UTC, we accept no date earlier than that.
    ;We assume the following definition of a Leap Year (or intercalary or bissextile year),
    ;   as defined in the Gregorian Calendar:
    ;      1. February has 28 days each year, but 29 in a Leap Year.
    ;      2. All years, except century years, that are evenly divisible by 4 are Leap Years.
    ;      3. Only century years evenly divisible by 400 are Leap Years.
    ;We ignore the fact that the Gregorian calendar began in 1582 and in other years for
    ;   some countries, as our system date does not allow dates before 1970.
    
    ;Check that the argument is numeric
    (if (not (integerp ?baseYear)) then
        (return nil)
    )
    ;Check for legal values
    (if (< ?baseYear 1970) then
        (return nil)
    )
    
    ;Check for leap centuries, then leap years that are not centuries.
    (if (= (mod ?baseYear 400) 0) then
        ;We have a Leap Year century
        (return TRUE)
    )
    (if (= (mod ?baseYear 100) 0) then
        ;We have a standar year century
        (return FALSE)
    )
    (if (= (mod ?baseYear 4) 0) then
        ;We have a leap year that is not a century.
        (return TRUE)
    )
    
    ;If not a leap year, we fall out here.
    (return FALSE)
    
)

(deffunction yearFromDateINT
    (?dDate)
    (if (not (integerp ?dDate)) then
        (return nil)
    )

    ;Due to assuming that dates are expressed as an integer number of seconds
    ;   after 01 January 1970, 00.00 UTC, we accept no date earlier than that.
    
    ;To save some calculation time, we pre-calculate these base variables
    (bind ?yearSeconds 31536000) ; 365 * 24 * 60 * 60 . Number of seconds in a standard calendar year.
    (bind ?leapYearSeconds 31622400) ; 366 * 24 * 60 * 60 . Number of seconds in a leap year.
    (bind ?baseDate 0) ; 01 January 1970, 00.00 UTC.

    
    ;Check that the arguments are numeric
    (if (not (integerp ?dDate)) then
        (return nil)
    )
    ;Check that date is later than the epoch date
    (if (< ?dDate 0) then
        (return nil)
    )
    
    ;Loop through subtracting years until we find the year
    (bind ?iYear 1970) ; we assume beginning year to be 1970
    (bind ?iCounter ?dDate)
    (while (>= ?iCounter ?yearSeconds)
        (bind ?iYear (+ ?iYear 1))
        (bind ?bIsThisALeapYear (isThisALeapYear (- ?iYear 1)))
        (if (eq ?bIsThisALeapYear TRUE) then
            (bind ?iCounter (- ?iCounter ?leapYearSeconds))
        else
            (bind ?iCounter (- ?iCounter ?yearSeconds))
        )
        (if (< ?iCounter 0) then
            (bind ?iYear (- ?iYear 1))
        )
    )

    ?iYear
    
)

(deffunction monthFromDateINT
    (?dDate)
    (if (not (integerp ?dDate)) then
        (return nil)
    )

    ;Due to assuming that dates are expressed as an integer number of seconds
    ;   after 01 January 1970, 00.00 UTC, we accept no date earlier than that.
    
    ;To save some calculation time, we pre-calculate these base variables
    (bind ?yearSeconds 31536000) ; 365 * 24 * 60 * 60 . Number of seconds in a standard calendar year.
    (bind ?leapYearSeconds 31622400) ; 366 * 24 * 60 * 60 . Number of seconds in a leap year.
    (bind ?baseDate 0) ; 01 January 1970, 00.00 UTC.
    ;Pre-calculated: months of 31 days have 2678400 seconds; months of 30 days have 2592000 seconds.
    ;                months of 29 days have 2505600 seconds; months of 28 days have 2419200 seconds.
    (bind ?month31days 2678400)
    (bind ?month30days 2592000)
    (bind ?month29days 2505600)
    (bind ?month28days 2419200)
    
    ;Check that the arguments are numeric
    (if (not (integerp ?dDate)) then
        (return nil)
    )
    ;Check that date is later than the epoch date
    (if (< ?dDate 0) then
        (return nil)
    )
    
    ;Loop through subtracting years until we find the year
    (bind ?iYear 1970) ; we assume beginning year to be 1970
    (bind ?iCounter ?dDate)
    (while (>= ?iCounter ?yearSeconds)
        (bind ?iYear (+ ?iYear 1))
        (bind ?bIsThisALeapYear (isThisALeapYear (- ?iYear 1)))
        (if (eq ?bIsThisALeapYear TRUE) then
            (bind ?iCounter (- ?iCounter ?leapYearSeconds))
        else
            (bind ?iCounter (- ?iCounter ?yearSeconds))
        )
        (if (< ?iCounter 0) then
            (bind ?iYear (- ?iYear 1))
        )
    )

    ;Reset Is this a Leap Year to this year, as we are now processing the months.
    (bind ?bIsThisALeapYear (isThisALeapYear ?iYear))
    (bind ?iCounter (+ ?iCounter 1)) ; push it into the next day by one second, so the real date is obvious
    ;Subtract the values for months until we have the month
    (bind ?iMonth 01)
    (if (<= ?iCounter ?month31days) then
        (bind ?iMonth 01) ; January
    else
        (bind ?iCounter (- ?iCounter ?month31days))        
        (if (eq ?bIsThisALeapYear TRUE) then
            (if (<= ?iCounter ?month29days) then
                (bind ?iMonth 02) ; February
            else
                (bind ?iCounter (- ?iCounter ?month29days))
                (if (<= ?iCounter ?month31days) then
                    (bind ?iMonth 03) ; March
                else
                    (bind ?iCounter (- ?iCounter ?month31days))
                    (if (<= ?iCounter ?month30days) then
                        (bind ?iMonth 04) ; April
                    else
                        (bind ?iCounter (- ?iCounter ?month30days))
                        (if (<= ?iCounter ?month31days) then
                            (bind ?iMonth 05) ; May
                        else
                            (bind ?iCounter (- ?iCounter ?month31days))
                            (if (<= ?iCounter ?month30days) then
                                (bind ?iMonth 06) ; June
                            else
                                (bind ?iCounter (- ?iCounter ?month30days))
                                 (if (<= ?iCounter ?month31days) then
                                    (bind ?iMonth 07) ; July
                                else
                                    (bind ?iCounter (- ?iCounter ?month31days))
                                    (if (<= ?iCounter ?month31days) then
                                        (bind ?iMonth 08) ; August
                                    else
                                        (bind ?iCounter (- ?iCounter ?month31days))
                                         (if (<= ?iCounter ?month30days) then
                                            (bind ?iMonth 09) ; September
                                        else
                                            (bind ?iCounter (- ?iCounter ?month30days))
                                             (if (<= ?iCounter ?month31days) then
                                                (bind ?iMonth 10) ; October
                                            else
                                                (bind ?iCounter (- ?iCounter ?month31days))
                                                 (if (<= ?iCounter ?month30days) then
                                                    (bind ?iMonth 11) ; November
                                                else
                                                    (bind ?iCounter (- ?iCounter ?month30days))
                                                     (if (<= ?iCounter ?month31days) then
                                                        (bind ?iMonth 12) ; December
                                                    else
                                                        ;Should never get here!
                                                        (return nil)
                                                    )
                                               )
                                           )
                                       )
                                   )
                                )
                           )
                        )
                    )
                )
            )
        else
            (if (<= ?iCounter ?month28days) then
                (bind ?iMonth 02) ; February
            else
                (bind ?iCounter (- ?iCounter ?month28days))
                (if (<= ?iCounter ?month31days) then
                    (bind ?iMonth 03) ; March
                else
                    (bind ?iCounter (- ?iCounter ?month31days))
                    (if (<= ?iCounter ?month30days) then
                        (bind ?iMonth 04) ; April
                    else
                        (bind ?iCounter (- ?iCounter ?month30days))
                        (if (<= ?iCounter ?month31days) then
                            (bind ?iMonth 05) ; May
                        else
                            (bind ?iCounter (- ?iCounter ?month31days))
                            (if (<= ?iCounter ?month30days) then
                                (bind ?iMonth 06) ; June
                            else
                                (bind ?iCounter (- ?iCounter ?month30days))
                                 (if (<= ?iCounter ?month31days) then
                                    (bind ?iMonth 07) ; July
                                else
                                    (bind ?iCounter (- ?iCounter ?month31days))
                                    (if (<= ?iCounter ?month31days) then
                                        (bind ?iMonth 08) ; August
                                    else
                                        (bind ?iCounter (- ?iCounter ?month31days))
                                         (if (<= ?iCounter ?month30days) then
                                            (bind ?iMonth 09) ; September
                                        else
                                            (bind ?iCounter (- ?iCounter ?month30days))
                                             (if (<= ?iCounter ?month31days) then
                                                (bind ?iMonth 10) ; October
                                            else
                                                (bind ?iCounter (- ?iCounter ?month31days))
                                                 (if (<= ?iCounter ?month30days) then
                                                    (bind ?iMonth 11) ; November
                                                else
                                                    (bind ?iCounter (- ?iCounter ?month30days))
                                                     (if (<= ?iCounter ?month31days) then
                                                        (bind ?iMonth 12) ; December
                                                    else
                                                        ;Should never get here!
                                                        (return nil)
                                                    )
                                               )
                                           )
                                       )
                                   )
                                )
                           )
                        )
                    )
                )
            )
        )
    )

    ?iMonth
)

(deffunction dayFromDateINT
    (?dDate)
    (if (not (integerp ?dDate)) then
        (return nil)
    )

    ;Due to assuming that dates are expressed as an integer number of seconds
    ;   after 01 January 1970, 00.00 UTC, we accept no date earlier than that.
    
    ;To save some calculation time, we pre-calculate these base variables
    (bind ?yearSeconds 31536000) ; 365 * 24 * 60 * 60 . Number of seconds in a standard calendar year.
    (bind ?leapYearSeconds 31622400) ; 366 * 24 * 60 * 60 . Number of seconds in a leap year.
    (bind ?baseDate 0) ; 01 January 1970, 00.00 UTC.
    ;Pre-calculated: months of 31 days have 2678400 seconds; months of 30 days have 2592000 seconds.
    ;                months of 29 days have 2505600 seconds; months of 28 days have 2419200 seconds.
    (bind ?month31days 2678400)
    (bind ?month30days 2592000)
    (bind ?month29days 2505600)
    (bind ?month28days 2419200)
    
    ;Check that the arguments are numeric
    (if (not (integerp ?dDate)) then
        (return nil)
    )
    ;Check that date is later than the epoch date
    (if (< ?dDate 0) then
        (return nil)
    )
    
    ;Loop through subtracting years until we find the year
    (bind ?iYear 1970) ; we assume beginning year to be 1970
    (bind ?iCounter ?dDate)
    (while (>= ?iCounter ?yearSeconds)
        (bind ?iYear (+ ?iYear 1))
        (bind ?bIsThisALeapYear (isThisALeapYear (- ?iYear 1)))
        (if (eq ?bIsThisALeapYear TRUE) then
            (bind ?iCounter (- ?iCounter ?leapYearSeconds))
        else
            (bind ?iCounter (- ?iCounter ?yearSeconds))
        )
        (if (< ?iCounter 0) then
            (bind ?iYear (- ?iYear 1))
        )
    )
    
    ;Reset Is this a Leap Year to this year, as we are now processing the months.
    (bind ?bIsThisALeapYear (isThisALeapYear ?iYear))
    (bind ?iCounter (+ ?iCounter 1)) ; push it into the next day by one second, so the real date is obvious
    ;Subtract the values for months until we have the month
    (bind ?iMonth 01)
    (if (<= ?iCounter ?month31days) then
        (bind ?iMonth 01) ; January
    else
        (bind ?iCounter (- ?iCounter ?month31days))        
        (if (eq ?bIsThisALeapYear TRUE) then
            (if (<= ?iCounter ?month29days) then
                (bind ?iMonth 02) ; February
            else
                (bind ?iCounter (- ?iCounter ?month29days))
                (if (<= ?iCounter ?month31days) then
                    (bind ?iMonth 03) ; March
                else
                    (bind ?iCounter (- ?iCounter ?month31days))
                    (if (<= ?iCounter ?month30days) then
                        (bind ?iMonth 04) ; April
                    else
                        (bind ?iCounter (- ?iCounter ?month30days))
                        (if (<= ?iCounter ?month31days) then
                            (bind ?iMonth 05) ; May
                        else
                            (bind ?iCounter (- ?iCounter ?month31days))
                            (if (<= ?iCounter ?month30days) then
                                (bind ?iMonth 06) ; June
                            else
                                (bind ?iCounter (- ?iCounter ?month30days))
                                 (if (<= ?iCounter ?month31days) then
                                    (bind ?iMonth 07) ; July
                                else
                                    (bind ?iCounter (- ?iCounter ?month31days))
                                    (if (<= ?iCounter ?month31days) then
                                        (bind ?iMonth 08) ; August
                                    else
                                        (bind ?iCounter (- ?iCounter ?month31days))
                                         (if (<= ?iCounter ?month30days) then
                                            (bind ?iMonth 09) ; September
                                        else
                                            (bind ?iCounter (- ?iCounter ?month30days))
                                             (if (<= ?iCounter ?month31days) then
                                                (bind ?iMonth 10) ; October
                                            else
                                                (bind ?iCounter (- ?iCounter ?month31days))
                                                 (if (<= ?iCounter ?month30days) then
                                                    (bind ?iMonth 11) ; November
                                                else
                                                    (bind ?iCounter (- ?iCounter ?month30days))
                                                     (if (<= ?iCounter ?month31days) then
                                                        (bind ?iMonth 12) ; December
                                                    else
                                                        ;Should never get here!
                                                        (return nil)
                                                    )
                                               )
                                           )
                                       )
                                   )
                                )
                           )
                        )
                    )
                )
            )
        else
            (if (<= ?iCounter ?month28days) then
                (bind ?iMonth 02) ; February
            else
                (bind ?iCounter (- ?iCounter ?month28days))
                (if (<= ?iCounter ?month31days) then
                    (bind ?iMonth 03) ; March
                else
                    (bind ?iCounter (- ?iCounter ?month31days))
                    (if (<= ?iCounter ?month30days) then
                        (bind ?iMonth 04) ; April
                    else
                        (bind ?iCounter (- ?iCounter ?month30days))
                        (if (<= ?iCounter ?month31days) then
                            (bind ?iMonth 05) ; May
                        else
                            (bind ?iCounter (- ?iCounter ?month31days))
                            (if (<= ?iCounter ?month30days) then
                                (bind ?iMonth 06) ; June
                            else
                                (bind ?iCounter (- ?iCounter ?month30days))
                                 (if (<= ?iCounter ?month31days) then
                                    (bind ?iMonth 07) ; July
                                else
                                    (bind ?iCounter (- ?iCounter ?month31days))
                                    (if (<= ?iCounter ?month31days) then
                                        (bind ?iMonth 08) ; August
                                    else
                                        (bind ?iCounter (- ?iCounter ?month31days))
                                         (if (<= ?iCounter ?month30days) then
                                            (bind ?iMonth 09) ; September
                                        else
                                            (bind ?iCounter (- ?iCounter ?month30days))
                                             (if (<= ?iCounter ?month31days) then
                                                (bind ?iMonth 10) ; October
                                            else
                                                (bind ?iCounter (- ?iCounter ?month31days))
                                                 (if (<= ?iCounter ?month30days) then
                                                    (bind ?iMonth 11) ; November
                                                else
                                                    (bind ?iCounter (- ?iCounter ?month30days))
                                                     (if (<= ?iCounter ?month31days) then
                                                        (bind ?iMonth 12) ; December
                                                    else
                                                        ;Should never get here!
                                                        (return nil)
                                                    )
                                               )
                                           )
                                       )
                                   )
                                )
                           )
                        )
                    )
                )
            )
        )
    )
    
    ;Now count the days within the month.
    ;   We add two to the result: one for the day from midnight; one because we count starting from one not zero.
    (bind ?iDay (+ (div ?iCounter (* 24 60 60)) 0)) ; ignore the time of day.
    (if (> (mod ?iCounter (* 24 60 60)) 0) then
        (bind ?iDay (+ ?iDay 1))
    )
    
    ?iDay    
)

(deffunction unmakeDate
    (?dDate)
    (if (not (integerp ?dDate)) then
        (return nil)
    )

    ;Due to assuming that dates are expressed as an integer number of seconds
    ;   after 01 January 1970, 00.00 UTC, we accept no date earlier than that.
    
    ;To save some calculation time, we pre-calculate these base variables
    (bind ?yearSeconds 31536000) ; 365 * 24 * 60 * 60 . Number of seconds in a standard calendar year.
    (bind ?leapYearSeconds 31622400) ; 366 * 24 * 60 * 60 . Number of seconds in a leap year.
    (bind ?baseDate 0) ; 01 January 1970, 00.00 UTC.
    ;Pre-calculated: months of 31 days have 2678400 seconds; months of 30 days have 2592000 seconds.
    ;                months of 29 days have 2505600 seconds; months of 28 days have 2419200 seconds.
    (bind ?month31days 2678400)
    (bind ?month30days 2592000)
    (bind ?month29days 2505600)
    (bind ?month28days 2419200)
    
    ;Check that the arguments are numeric
    (if (not (integerp ?dDate)) then
        (return nil)
    )
    ;Check that date is later than the epoch date
    (if (< ?dDate 0) then
        (return nil)
    )
    
    ;Loop through subtracting years until we find the year
    (bind ?iYear 1970) ; we assume beginning year to be 1970
    (bind ?iCounter ?dDate)
    (while (>= ?iCounter ?yearSeconds)
        (bind ?iYear (+ ?iYear 1))
        (bind ?bIsThisALeapYear (isThisALeapYear (- ?iYear 1)))
        (if (eq ?bIsThisALeapYear TRUE) then
            (bind ?iCounter (- ?iCounter ?leapYearSeconds))
        else
            (bind ?iCounter (- ?iCounter ?yearSeconds))
        )
        (if (< ?iCounter 0) then
            (bind ?iYear (- ?iYear 1))
        )
    )
    (bind ?sTempDate ?iYear) ; Begin setting up the string form of the date.
    
    ;Reset Is this a Leap Year to this year, as we are now processing the months.
    (bind ?bIsThisALeapYear (isThisALeapYear ?iYear))
    (bind ?iCounter (+ ?iCounter 1)) ; push it into the next day by one second, so the real date is obvious
    ;Subtract the values for months until we have the month
    (bind ?iMonth 01)
    (if (<= ?iCounter ?month31days) then
        (bind ?iMonth 01) ; January
    else
        (bind ?iCounter (- ?iCounter ?month31days))        
        (if (eq ?bIsThisALeapYear TRUE) then
            (if (<= ?iCounter ?month29days) then
                (bind ?iMonth 02) ; February
            else
                (bind ?iCounter (- ?iCounter ?month29days))
                (if (<= ?iCounter ?month31days) then
                    (bind ?iMonth 03) ; March
                else
                    (bind ?iCounter (- ?iCounter ?month31days))
                    (if (<= ?iCounter ?month30days) then
                        (bind ?iMonth 04) ; April
                    else
                        (bind ?iCounter (- ?iCounter ?month30days))
                        (if (<= ?iCounter ?month31days) then
                            (bind ?iMonth 05) ; May
                        else
                            (bind ?iCounter (- ?iCounter ?month31days))
                            (if (<= ?iCounter ?month30days) then
                                (bind ?iMonth 06) ; June
                            else
                                (bind ?iCounter (- ?iCounter ?month30days))
                                 (if (<= ?iCounter ?month31days) then
                                    (bind ?iMonth 07) ; July
                                else
                                    (bind ?iCounter (- ?iCounter ?month31days))
                                    (if (<= ?iCounter ?month31days) then
                                        (bind ?iMonth 08) ; August
                                    else
                                        (bind ?iCounter (- ?iCounter ?month31days))
                                         (if (<= ?iCounter ?month30days) then
                                            (bind ?iMonth 09) ; September
                                        else
                                            (bind ?iCounter (- ?iCounter ?month30days))
                                             (if (<= ?iCounter ?month31days) then
                                                (bind ?iMonth 10) ; October
                                            else
                                                (bind ?iCounter (- ?iCounter ?month31days))
                                                 (if (<= ?iCounter ?month30days) then
                                                    (bind ?iMonth 11) ; November
                                                else
                                                    (bind ?iCounter (- ?iCounter ?month30days))
                                                     (if (<= ?iCounter ?month31days) then
                                                        (bind ?iMonth 12) ; December
                                                    else
                                                        ;Should never get here!
                                                        (return nil)
                                                    )
                                               )
                                           )
                                       )
                                   )
                                )
                           )
                        )
                    )
                )
            )
        else
            (if (<= ?iCounter ?month28days) then
                (bind ?iMonth 02) ; February
            else
                (bind ?iCounter (- ?iCounter ?month28days))
                (if (<= ?iCounter ?month31days) then
                    (bind ?iMonth 03) ; March
                else
                    (bind ?iCounter (- ?iCounter ?month31days))
                    (if (<= ?iCounter ?month30days) then
                        (bind ?iMonth 04) ; April
                    else
                        (bind ?iCounter (- ?iCounter ?month30days))
                        (if (<= ?iCounter ?month31days) then
                            (bind ?iMonth 05) ; May
                        else
                            (bind ?iCounter (- ?iCounter ?month31days))
                            (if (<= ?iCounter ?month30days) then
                                (bind ?iMonth 06) ; June
                            else
                                (bind ?iCounter (- ?iCounter ?month30days))
                                 (if (<= ?iCounter ?month31days) then
                                    (bind ?iMonth 07) ; July
                                else
                                    (bind ?iCounter (- ?iCounter ?month31days))
                                    (if (<= ?iCounter ?month31days) then
                                        (bind ?iMonth 08) ; August
                                    else
                                        (bind ?iCounter (- ?iCounter ?month31days))
                                         (if (<= ?iCounter ?month30days) then
                                            (bind ?iMonth 09) ; September
                                        else
                                            (bind ?iCounter (- ?iCounter ?month30days))
                                             (if (<= ?iCounter ?month31days) then
                                                (bind ?iMonth 10) ; October
                                            else
                                                (bind ?iCounter (- ?iCounter ?month31days))
                                                 (if (<= ?iCounter ?month30days) then
                                                    (bind ?iMonth 11) ; November
                                                else
                                                    (bind ?iCounter (- ?iCounter ?month30days))
                                                     (if (<= ?iCounter ?month31days) then
                                                        (bind ?iMonth 12) ; December
                                                    else
                                                        ;Should never get here!
                                                        (return nil)
                                                    )
                                               )
                                           )
                                       )
                                   )
                                )
                           )
                        )
                    )
                )
            )
        )
    )
    (bind ?sMonth (str-cat "000" ?iMonth))
    (if (= (str-length ?sMonth) 5) then
        (bind ?sMonth (sub-string 4 5 ?sMonth))
    else
        (bind ?sMonth (sub-string 3 4 ?sMonth))
    )
    (bind ?sTempDate (str-cat ?sTempDate "-" ?sMonth "-"))
    
    ;Now count the days within the month.
    ;   We add two to the result: one for the day from midnight; one because we count starting from one not zero.
    (bind ?iDay (+ (div ?iCounter (* 24 60 60)) 0)) ; ignore the time of day.
    (if (> (mod ?iCounter (* 24 60 60)) 0) then
        (bind ?iDay (+ ?iDay 1))
    )
    (bind ?sDay (str-cat "000" ?iDay))
    (if (= (str-length ?sDay) 5) then
        (bind ?sDay (sub-string 4 5 ?sDay))
    else
        (bind ?sDay (sub-string 3 4 ?sDay))
    )
    (bind ?sTempDate (str-cat ?sTempDate ?sDay))
    
    ?sTempDate    
)

(deffunction DoW
    (?dDate)
    
    (if (not (integerp ?dDate)) then
        (return nil)
    )
    
    ;Convert UNIX date to text date for formulae
    (bind ?iYear (yearFromDateINT ?dDate))
    (bind ?iMonth (monthFromDateINT ?dDate))
    (bind ?iDay (dayFromDateINT ?dDate))
       
    (if (< ?iMonth 3) then
        (bind ?iMonth (+ ?iMonth 12))
        (bind ?iYear (- ?iYear 1))
    )
    (bind ?iCentury (div ?iYear 100))
    (bind ?iYearInCentury (mod ?iYear 100))
    (bind ?iA (- (div ?iCentury 4) (* 2 ?iCentury) 1))
    (bind ?iB (div (* 5 ?iYearInCentury) 4))
    (bind ?iAB (+ ?iA ?iB))
    (bind ?iC (div (* 26 (+ ?iMonth 1)) 10))
    (bind ?iABC (+ ?iAB ?iC))
    (bind ?iD (+ ?iABC ?iDay))
    (bind ?iE (mod ?iD 7))
    (if (< ?iE 0) then
        (bind ?iCalcDay (+ ?iE 7))
    else
        (bind ?iCalcDay ?iE)
    )
    
    
    ;Make Sunday 7, not 0, to align with ISO 8601 (and Tcl) standards.
    (if (= ?iCalcDay 0) then
        (bind ?iCalcDay 7)
    else
        ?iCalcDay
    )
    
    ?iCalcDay
)

(deffunction clFindSun
    (?dStartDate ?dEndDate)

    (if (or (not (integerp ?dStartDate)) (not (integerp ?dEndDate))) then
        (return nil)
    )
    (if (> ?dStartDate ?dEndDate) then
        (return nil)
    )
    
    ;Find the day of the week for the start day.
    (bind ?TempDoW (DoW ?dStartDate))
    (if (= ?TempDoW 7) then
        (return ?dStartDate)
    )
    
    ;Find difference and calculate day difference.
    (bind ?dTempDate (+ (* (- 7 ?TempDoW) 24 60 60) ?dStartDate))
    
    ;Final check that we are still within the range.
    (if (<= ?dTempDate ?dEndDate) then
        (return ?dTempDate)
    else
        (return nil)
    )
    
    ?dTempDate
)

(deffunction clFindSat
    (?dStartDate ?dEndDate)

    (if (or (not (integerp ?dStartDate)) (not (integerp ?dEndDate))) then
        (return nil)
    )
    (if (> ?dStartDate ?dEndDate) then
        (return nil)
    )
    
    ;Find the day of the week for the start day.
    (bind ?TempDoW (DoW ?dStartDate))
    (if (= ?TempDoW 6) then
        (return ?dStartDate)
    )
    ;Check if it is a Sunday, and then all the other days of the week.
    (if (= ?TempDoW 7) then
        (bind ?dTempDate (+ (* 7 24 60 60) ?dStartDate))
    else
        ;Find difference and calculate day difference.
        (bind ?dTempDate (+ (* (- 6 ?TempDoW) 24 60 60) ?dStartDate))
    )
    
    ;Final check that we are still within the range.
    (if (<= ?dTempDate ?dEndDate) then
        (return ?dTempDate)
    else
        (return nil)
    )
    
    ?dTempDate
)

(deffunction makeTwoDigits
    (?num)

    ;in case we get passed a (non-numeric) character, send it back straight away.
    (if (not (integerp ?num)) then
        (return ?num)
    )
    
    ;if the number comes through as numeric and not a string
    (if (< ?num 10) then
        (return (str-cat "0" ?num))
    )
    (if (>= ?num 10) then
        (return ?num)
    )
    
    ;lastly, we check for a string
    (if (= (str-length ?num) 2) then
        (return ?num)
    else
        (return (str-cat "0" ?num))
    )
    
    ?num
)

(deffunction daysAdd
    (?baseDate ?daysToAddToBase)
    
    ;We assume the base date to be an integer number of seconds.
    ;This is the usual case on a UNIX system, or as sent in from Tcl.
    ;In Python, we 'import time' and then use 'time.time()' to report a similar number of seconds as does Tcl.
    ;It usually expresses time as an integer number of seconds after the
    ;   Epoch Date of 01 January 1970, 00.00 UTC.
    
    ;Check that both arguments are numeric
    (if (not (integerp ?daysToAddToBase)) then
        (return 0)
    )
    (if (not (integerp ?baseDate)) then
        (return 0)
    )
    
    ;return the result. The second argument must be converted to seconds (= * 24 * 60 * 60).
    (return (+ ?baseDate (* ?daysToAddToBase 24 60 60)))
)

(deffunction mkDate
    (?baseYear ?baseMonth ?baseDay)
    
    ;Due to assuming that dates are expressed as an integer number of seconds
    ;   after 01 January 1970, 00.00 UTC, we accept no date earlier than that.
    
    ;To save some calculation time, we pre-calculate these base variables
    (bind ?yearSeconds 31536000) ; 365 * 24 * 60 * 60 . Number of seconds in a standard calendar year.
    (bind ?leapYearSeconds 31622400) ; 366 * 24 * 60 * 60 . Number of seconds in a leap year.

    
    ;Check that the arguments are numeric
    (if (not (integerp ?baseYear)) then
        (return 0)
    )
    (if (not (integerp ?baseMonth)) then
        (return 0)
    )
    (if (not (integerp ?baseDay)) then
        (return 0)
    )
    
    ;Check for legal values
    (if (< ?baseYear 1970) then
        (return 0)
    )
    (if (or (< ?baseMonth 1) (> ?baseMonth 12)) then
        (return 0)
    )
    (if (or (< ?baseDay 1) (> ?baseDay 31)) then
        (return 0)
    )
    (if (and (or (= ?baseMonth 9) (= ?baseMonth 4) (= ?baseMonth 6) (= ?baseMonth 11)) (> ?baseDay 30)) then
        (return 0)
    )
    (if (= ?baseMonth 2) then
        (if (isThisALeapYear ?baseYear) then
            (if (> ?baseDay 29) then
                (return 0)
            )
        else
            (if (> ?baseDay 28) then
                (return 0)
            )
        )
    )
    
    ;Loop through the years since the Epoch Date,
    ;   adding the number of seconds required for the years before the year requested.
    (bind ?tmpYear 1970)
    (bind ?Counter 0)
    (while (< ?tmpYear ?baseYear)
        (if (isThisALeapYear ?tmpYear) then
            (bind ?Counter (+ ?Counter ?leapYearSeconds))
        else
            (bind ?Counter (+ ?Counter ?yearSeconds))
        )
        (bind ?tmpYear (+ ?tmpYear 1))
    )
    
    ;Now add seconds for the months before the month requested.
    (bind ?prevMonth (- ?baseMonth 1))
    ;Pre-calculated: months of 31 days have 2678400 seconds; months of 30 days have 2592000 seconds.
    ;                months of 29 days have 2505600 seconds; months of 28 days have 2419200 seconds.
    (if (isThisALeapYear ?baseYear) then
        (switch ?prevMonth
            (case 1 then (bind ?Counter (+ ?Counter 2678400)))
            (case 2 then (bind ?Counter (+ ?Counter 5184000)))
            (case 3 then (bind ?Counter (+ ?Counter 7862400)))
            (case 4 then (bind ?Counter (+ ?Counter 10454400)))
            (case 5 then (bind ?Counter (+ ?Counter 13132800)))
            (case 6 then (bind ?Counter (+ ?Counter 15724800)))
            (case 7 then (bind ?Counter (+ ?Counter 18403200)))
            (case 8 then (bind ?Counter (+ ?Counter 21081600)))
            (case 9 then (bind ?Counter (+ ?Counter 23673600)))
            (case 10 then (bind ?Counter (+ ?Counter 26352000)))
            (case 11 then (bind ?Counter (+ ?Counter 28944000)))
            (default none)
        )
    else
        (switch ?prevMonth
            (case 1 then (bind ?Counter (+ ?Counter 2678400)))
            (case 2 then (bind ?Counter (+ ?Counter 5097600)))
            (case 3 then (bind ?Counter (+ ?Counter 7776000)))
            (case 4 then (bind ?Counter (+ ?Counter 10368000)))
            (case 5 then (bind ?Counter (+ ?Counter 13046400)))
            (case 6 then (bind ?Counter (+ ?Counter 15638400)))
            (case 7 then (bind ?Counter (+ ?Counter 18316800)))
            (case 8 then (bind ?Counter (+ ?Counter 20995200)))
            (case 9 then (bind ?Counter (+ ?Counter 23587200)))
            (case 10 then (bind ?Counter (+ ?Counter 26265600)))
            (case 11 then (bind ?Counter (+ ?Counter 28857600)))
            (default none)
        )
    )
    
    ;Lastly add the days of the month sought.
    (bind ?Counter (+ ?Counter (* (- ?baseDay 1) 24 60 60)))
    
    (return ?Counter)
)
