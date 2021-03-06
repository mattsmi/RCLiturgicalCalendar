;####################################################################################
;;;;;; To print out the facts use: (printout t (facts) crlf) .
(deftemplate RCcalThisYear
 (slot Date_this_year (default ?NONE))
 (slot Date_ISO8601 (default nil))
 (slot TypeIndex (default nil))
 (slot Optional1 (default nil))
 (slot Optional2 (default nil))
 (slot Optional3 (default nil))
 (slot OptMemBVM (default nil))
 (slot CurrentCycle (default nil))
 (slot TableLitDayRank (default nil))
 (slot FastingToday (default nil))
 (slot AbstinenceToday (default nil))
 (slot ForWhichCal (default nil))
 (slot PsalterWeek (default nil))
 (slot EDM (default nil))
 (slot PrintOnCal (default nil))
)
(deftemplate YearlyCycle
 (slot Year (default ?NONE))
 (slot CycleStarts (default nil))
 (slot SundayCycle (default nil))
 (slot WeekdayCycle (default nil))
)
(deftemplate DailyLiturgyDetails
 (slot TypeIndex (default nil))
 (slot Date_this_year (default nil))
 (slot Feast_en (default nil))
 (slot Feast_la (default nil))
 (slot Short_name_en (default nil))
 (slot Short_name_la (default nil))
 (slot Lit_rank (default nil))
 (slot Rank (default nil))
 (slot FeastType (default nil))
 (slot EP1_PC_Ant1 (default nil))
 (slot EP1_PC_Ant2 (default nil))
 (slot EP1_PC_Ant3 (default nil))
 (slot EP1_Reading (default nil))
 (slot EP1_Responsory (default nil))
 (slot EP1_AntM (default nil))
 (slot EP1_Petitions (default nil))
 (slot EP1_Concluding (default nil))
 (slot Invitatory (default nil))
 (slot Read_P_Ant1 (default nil))
 (slot Read_P_Ant2 (default nil))
 (slot Read_P_Ant3 (default nil))
 (slot MP_PC_Ant1 (default nil))
 (slot MP_PC_Ant2 (default nil))
 (slot MP_PC_Ant3 (default nil))
 (slot MP_Reading (default nil))
 (slot MP_Responsory (default nil))
 (slot MP_AntB (default nil))
 (slot MP_Intercessions (default nil))
 (slot MP_Concluding (default nil))
 (slot PDD_Ant1 (default nil))
 (slot PDD_Ant2 (default nil))
 (slot PDD_Ant3 (default nil))
 (slot Terce_Ant1 (default nil))
 (slot Sext_Ant1 (default nil))
 (slot None_Ant1 (default nil))
 (slot Terce_Reading (default nil))
 (slot Sext_Reading (default nil))
 (slot None_Reading (default nil))
 (slot Terce_Responsory (default nil))
 (slot Sext_Responsory (default nil))
 (slot None_Responsory (default nil))
 (slot EP2_PC_Ant1 (default nil))
 (slot EP2_PC_Ant2 (default nil))
 (slot EP2_PC_Ant3 (default nil))
 (slot EP2_Reading (default nil))
 (slot EP2_Responsory (default nil))
 (slot EP2_AntM (default nil))
 (slot EP2_Petitions (default nil))
 (slot EP2_Concluding (default nil))
 (slot EP1_Hymn (default nil))
 (slot EP1_PC1 (default nil))
 (slot EP1_PC2 (default nil))
 (slot EP1_PC3 (default nil))
 (slot Read_Hymn (default nil))
 (slot Read_P1 (default nil))
 (slot Read_P2 (default nil))
 (slot Read_P3 (default nil))
 (slot MP_Hymn (default nil))
 (slot MP_PC1 (default nil))
 (slot MP_PC2 (default nil))
 (slot MP_PC3 (default nil))
 (slot PDD_Hymn (default nil))
 (slot PDD_PC1 (default nil))
 (slot PDD_PC2 (default nil))
 (slot PDD_PC3 (default nil))
 (slot EP2_Hymn (default nil))
 (slot EP2_PC1 (default nil))
 (slot EP2_PC2 (default nil))
 (slot EP2_PC3 (default nil))
 (slot R1YA (default nil))
 (slot R1YB (default nil))
 (slot R1YC (default nil))
 (slot R2YA (default nil))
 (slot R2YB (default nil))
 (slot R2YC (default nil))
 (slot RespPsYA (default nil))
 (slot RespPsYB (default nil))
 (slot RespPsYC (default nil))
 (slot GospelA (default nil))
 (slot GospelB (default nil))
 (slot GospelC (default nil))
 (slot GosAcclA (default nil))
 (slot GosAcclB (default nil))
 (slot GosAcclC (default nil))
 (slot VestmentColour (default nil))
 (slot CalType (default nil))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;These may be autogenerated in the facts files, and so should be removed from here, or there.
;(deftemplate MovedToSundaysFact
;	(slot TypeIndex (default nil))
; (slot Feast_en (default nil))
; (slot CalendarGEN (default nil))
; (slot CalType (default nil))
; (slot IfNotMoved (default nil))
;)
;(deftemplate ReplacesInGenFact
;	(slot TypeIndex (default nil))
; (slot CalType (default nil))
; (slot ReplacesInGEN (default nil))
;)
