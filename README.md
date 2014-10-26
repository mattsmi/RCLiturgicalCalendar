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

There are several technologies in use for this solution. It needn't be so complex, if you are only interested in the data. The complexity comes about in presenting the information and automating the generation of the calendar based on the rule set.

The CLIPS globals, templates, functions, facts, and rules hold all the necessary information and can be used stand-alone within a CLIPS environment (or command-line interface). The resultant facts ("RCcalThisYear") represent all celebrations for the year based on the local calendar and language chosen.

To implement the whole system as it is today, you will need:
 - PHP 5 with at least the SQLite and ZMQ packages
 - Python 2.6 or 2.7 with both the PyCLIPS and ZMQ packages \(on Debian systems: python-clips and python-zmq\).

I have also set up a cron job to check whether the Python ZMQ server is still running, and to relaunch it, if it is not running. Another weekly job kills the Python ZMQ server process to allow the system to clean up.

A running copy of the system can be found here: (Roman Catholic Liturgical Calendar)[http://www.liturgy.guide/RCcal/RCLitCal.html].
