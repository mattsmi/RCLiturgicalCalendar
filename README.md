RCLiturgicalCalendar
====================
Uses the CLIPS rules engine (BRE) to calculate the dates of feasts, fasts, etc., for use in the Roman Catholic liturgy.
Several general and local calendars are supported today: 
 - the General Roman Calandar (base calendar for all others), 
 - the USA local calendar
 - Australia
 - New Zealand
 - Ireland
 - England
 - Scotland
 - Wales.

There are several technologies in use for this solution. 

The CLIPS globals, templates, functions, facts, and rules hold all the necessary information and can be used stand-alone within a CLIPS environment (or command-line interface). The resultant facts ("RCcalThisYear") represent all celebrations for the year based on the local calendar and language chosen.

To implement the whole system as it is today, you will need:
 - PHP 5 with at least the SQLite
 - [php-clips](https://github.com/guitarpoet/php-clips.git).

Earlier versions of this system used Python and ZMQueue--neither is now required.

A running copy of the system can be found here: [Roman Catholic Liturgical Calendar](http://www.liturgy.guide/RCcal/RCLitCal.html).

Lastly, ensure there is write permission to both the `data` directory and the `RomanKeys.db3` database. The requirement for the directory is a PHP quirk/gift.

