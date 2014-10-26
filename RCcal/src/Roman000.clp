;####################################################################################
;Assumes version 6.24 of CLIPS (15 June 2006) as a minimum.
;;;;;; To print out the facts use: (printout t (facts) crlf) .

;;; This batch file should issue commands and load constructs as necessary.
;;;   Execute this script by (batch* "Roman000.clp") or (eval "(batch* \"Roman000.clp\")") .

;;;The script loads files of both rules and facts.
;;; The rules are managed by phases and within each phase by salience.
;;;  This subject matter is very hierarchical, and so needs more than usual control
;;;    over the order of facts on the agenda.

(clear)
(reset)
(defglobal ?*yearSought* = 2014)
(defglobal ?*calendarInUse* = "AU") ; could be nil, which means we only use the "GEN" calendar.

;;Batch script begins here.
(load "RomanGlobals01.clp")
(load "RomanTemplates01.clp")
(load "RomanFuncs01.clp")
(load "RomanFuncs02.clp")
(load "RomanRules01.clp")
(run) ; execute now to instantiate the unset globals, such as the date of Easter
(load "RomanFuncs03.clp")
(load "RomanFuncs04.clp")
(eval "(batch* \"CalendarGEN.clp\")")
(eval "(batch* \"CalendarOTHER.clp\")")
(eval "(batch* \"ReplacesInGen.clp\")")
(eval "(batch* \"MovedToSundays.clp\")")
(load "RomanRules02.clp")
(load "RomanRules03.clp")
(run)

;;;Test output
(defglobal ?*sFileName* = (str-cat "harry" (random) ".txt"))
(save-facts ?*sFileName* local RCcalThisYear)
(printout t "FINIS!" crlf)
;Saving output to file and processing gets around node-clips' lack of ability to return fact data.
;(system "ls -l " ?*sFileName*) ; then execute a string to process the file, then (remove ?*sFileName*)


;***Some of these functions (e.g. do-for-all-facts, find-fact) depend on a compile-time switch.
;*** See here for an explanation: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=508946 .
;(do-for-all-facts
;    ((?r RCcalThisYear))
;    (neq ?r:Date_this_year nil)
;    (do-for-all-facts
;        ((?c CalendarFact))
;        (eq ?r:TypeIndex ?c:TypeIndex)
;        (printout t (unmakeDate ?r:Date_this_year) " : " ?c:TypeIndex " : " ?c:Short_name_en crlf)
;    )
;)
;; find specific facts and values
;(do-for-all-facts
;    ((?c CalendarFact))
;    (and (neq ?c:Date_this_year nil) (eq ?c:Rank "Feast") (neq ?c:Lit_rank 5))
;    (do-for-all-facts
;        ((?r RCcalThisYear))
;        (and (neq ?r:Date_this_year nil) (eq ?r:TypeIndex ?c:TypeIndex))
;        (printout t (unmakeDate ?c:Date_this_year) " : " ?c:TypeIndex " : " ?c:Short_name_en "||| AT: " (unmakeDate ?r:Date_this_year) crlf))
;)
    
;(do-for-all-facts
;    ((?m RCcalThisYear))
;    (and (neq ?m:Date_this_year nil) (eq (sub-string 1 3 ?m:TypeIndex) "MOV"))
;    (printout t (unmakeDate ?m:Date_this_year) " : " ?m:TypeIndex crlf))

;;Find a specific Fact
;(find-fact ((?m CalendarFact)) (eq ?m:TypeIndex "MOV115"))
;;Pretty print of the fact, its slots, and their values
;(do-for-fact ((?m CalendarFact)) (eq ?m:TypeIndex "VAR002") (ppfact ?m t TRUE))
;;Print out the value of all defglobals. Similar to (show-defglobals)
;(progn$ (?field (get-defglobal-list)) (printout t ?field " : " (eval (sym-cat "?*" ?field "*")) crlf))

;To run with PyClips, use Python 2, not 3.
;import os
;import sys
;import clips
;clips.Reset()
;clips.Eval("(batch* \"Roman000.clp\")")
