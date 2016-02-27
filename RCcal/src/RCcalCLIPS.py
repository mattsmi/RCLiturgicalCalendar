import os, sys, json
import sqlite3
import clips
import datetime
import zmq

#Global variables
bYearChecked = False #Check whether the data is already present, and we do not need to process.
sDirPath = os.path.dirname(os.path.realpath(__file__))
sPath = os.path.join(sDirPath, '../../generic/data/RCcalData.db3')
oConn = None
sLocalCal = None


def pCheckAndUpdateDatabase(sClipsFact, bForceUpdate=False):
    global bYearChecked
    global sPath
    global oConn
    global oCursor
    global sLocalCal
    
    lSplitFact = sClipsFact.split()
    
    #Check whether it is one of the Facts that we seek.
    if((lSplitFact[0] != '(RCcalThisYear') and (lSplitFact[0] != '(YearlyCycle')):
        return True # Go back and keep reading through the facts

    #Check to see whether data for the Year already exists in the database
    if not bYearChecked:
        bYearChecked = True
        if(lSplitFact[0] == '(RCcalThisYear'):
            sTempYear = lSplitFact[4][1:5]
        elif(lSplitFact[0] == '(YearlyCycle'):
            sTempYear = lSplitFact[2][0:4]
        else:
            sys.exit('Data problems: more than two types of Facts.')
            return False #return and cease reading through the facts
        #Check database for that year
        sTemp = "'" + sTempYear + "%'"
        oCursor.execute("select Date_this_year, ForWhichCal from RCcalThisYear where (Date_this_year like ?) and (ForWhichCal = ?)", (sTemp, sLocalCal))
        oRows = oCursor.fetchone() 
        if oRows != None:
            #We have some data
            if(oRows[0][0:4] == sTempYear):
                if not bForceUpdate:
                    return False #return and cease processing the facts
                else:
                    #Remove the old data and insert into the tables
                    oCursor.execute("delete from RCcalThisYear where (Date_this_year like %s) and (ForWhichCal = '%s')" % (sTemp, sLocalCal))
                    oCursor.execute("delete from YearlyCycle where Year = %s" % sTempYear)
        else:
            oCursor.execute("delete from YearlyCycle where Year = %s" % sTempYear)
            
    #Process CLIPS fact and insert the data
    if(lSplitFact[0] == '(YearlyCycle'):
        sFactYear = lSplitFact[2][0:4]
        sFactStarts = datetime.datetime.fromtimestamp(int(lSplitFact[4][:-1])).strftime('%Y-%m-%d')
        sFactSunday = lSplitFact[6][1:-2]
        sFactWeekday = lSplitFact[8][:-2]
        sSQL = "insert into YearlyCycle (Year, CycleStarts, SundayCycle, WeekdayCycle) values (?, ?, ?, ?)"
        oCursor.execute(sSQL, (sFactYear, sFactStarts, sFactSunday, sFactWeekday))
    elif(lSplitFact[0] == '(RCcalThisYear'):
        sDate = lSplitFact[4][1:-2]
        sTypeIndex = lSplitFact[6][1:-2].replace('"','')
        if(lSplitFact[8][0:-1] == 'nil'):
            sOpt1 = None
        else:
            sOpt1 = lSplitFact[8][0:-1].replace('"','')
        if(lSplitFact[10][0:-1] == 'nil'):
            sOpt2 = None
        else:
            sOpt2 = lSplitFact[10][0:-1].replace('"','')
        if(lSplitFact[12][0:-1] == 'nil'):
            sOpt3 = None
        else:
            sOpt3 = lSplitFact[12][0:-1].replace('"','')
        if(lSplitFact[14][0:-1] == 'nil'):
            sOptMemBVM = None
        else:
            if(lSplitFact[14][0:-1] == 'FALSE'):
                sOptMemBVM = 0
            else:
                sOptMemBVM = 1
        if(lSplitFact[16][0:-1] == 'nil'):
            sCurrentCycle = None
        else:
            sCurrentCycle = lSplitFact[16][0:-1].replace('"','')
        if(lSplitFact[18][0:-1] == 'nil'):
            sTableRank = None
        else:
            sTableRank = lSplitFact[18][0:-1]
        if(lSplitFact[20][0:-1] == 'nil'):
            iFastingToday = None
        else:
            iFastingToday = lSplitFact[20][0:-1]
        if(lSplitFact[22][0:-1] == 'nil'):
            iAbstinenceToday = None
        else:
            iAbstinenceToday = lSplitFact[22][0:-1]
        if(lSplitFact[24][0:-3] == 'nil'):
            sForWhichCal = None
        else:
            sForWhichCal = lSplitFact[24][0:-1].replace('"','').replace(')','')
        if(lSplitFact[26][0:-1] == 'nil'):
            sPsalterWeek = None
        else:
            sPsalterWeek = lSplitFact[26][0:-1].replace('"','').replace(')','')
            
        sSQL = "insert into RCcalThisYear (Date_this_year, TypeIndex, Optional1, Optional2, Optional3, OptMemBVM, CurrentCycle, TableLitDayRank, FastingToday, AbstinenceToday, ForWhichCal, PsalterWeek) "
        sSQL = sSQL + "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
        oCursor.execute(sSQL, (sDate, sTypeIndex, sOpt1, sOpt2, sOpt3, sOptMemBVM, sCurrentCycle, sTableRank, iFastingToday, iAbstinenceToday, sForWhichCal, sPsalterWeek))

    return True             

### SCRIPT STARTS HERE ###
#Set up the ZeroMQ (ZMQ) server to receive requests
oContext = zmq.Context()
oSocket = oContext.socket(zmq.REP)
oSocket.bind("tcp://*:5556")

#CLIPS test
#Change path for when this script is called by another PHP page from a different directory.
os.chdir(sDirPath)

while True:
    #Open the database connection
    oConn = sqlite3.connect(sPath)
    oCursor = oConn.cursor()
    oMessage = oSocket.recv()
    lMessage = oMessage[1:-1].split(",")
    #print "Received request: ", oMessage , type(oMessage)
    
    #We expect to receive values for ?*yearSought* , ?*EDM* , and ?*calendarInUse*
    clips.Clear()
    clips.Reset()
    clips.Build(lMessage[0][1:-1])
    clips.Build(lMessage[1][1:-1])
    sTemp = lMessage[2][1:-1].replace('\\','')
    sLocalCal = sTemp.split()
    sLocalCal = sLocalCal[3].replace('"','').replace(')','')
    clips.Build(sTemp)
    clips.Eval("(batch* \"" + os.path.join(sDirPath, "RomanCal00.clp") + "\")")
    
    #sFactAddr = clips.Eval("(findFactWithSlot RCcalThisYear Date_ISO8601 \"2014-11-29\")")
    bYearChecked = False
    lFacts = clips.FactList()
    for oFact in lFacts:
        if not pCheckAndUpdateDatabase(oFact.CleanPPForm(), True):
            break
    oConn.commit()
    oConn.close()
    oSocket.send("SUCCESS")
    #break
    #print json.dumps(result)

oConn.close()
  
        