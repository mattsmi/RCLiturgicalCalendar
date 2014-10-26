<?php
if(! defined('page_include_allowed'))
{
	//Force 404 error by seeking a non-existant dummy page.
	$host = $_SERVER['HTTP_HOST'];
	$uri = rtrim(dirname($_SERVER['PHP_SELF']));
	$dummypage = 'somepage.html';
	header("Location: http://$host$uri/$dummypage");
	exit();

}

//set the default timezone
date_default_timezone_set('UTC');

function pF10_CalcEaster($iYearArg, $iEDM = 3)
{
	//Constants required for the Easter functions
	$iEDM_JULIAN = 1;
	$iEDM_ORTHODOX = 2;
	$iEDM_WESTERN = 3;
	$iFIRST_EASTER_YEAR = 326;
	$iFIRST_VALID_GREGORIAN_YEAR = 1583;
	$iLAST_VALID_GREGORIAN_YEAR = 4099;	
	$iYearToFind = intval($iYearArg);
	$iDatingMethod = intval($iEDM);
	//Check values of arguments
	if(($iYearToFind < $iFIRST_EASTER_YEAR) || ($iYearToFind > $iLAST_VALID_GREGORIAN_YEAR))
	{
		return FALSE;
	}
	if(($iEDM < $iEDM_JULIAN) || ($iEDM > $iEDM_WESTERN))
	{
		return FALSE;
	}
	
	$dDate = pF15_CalcDateOfEaster($iYearArg, $iEDM);
	if(! $dDate)
	{
		//We have an error
		return FALSE;
	} else 
	{
		return $dDate;
	}
}

function pF15_CalcDateOfEaster($iYearArg, $iEDM = 3)
{
	//Constants required for the Easter functions
	$iEDM_JULIAN = 1;
	$iEDM_ORTHODOX = 2;
	$iEDM_WESTERN = 3;
	$iFIRST_EASTER_YEAR = 326;
	$iFIRST_VALID_GREGORIAN_YEAR = 1583;
	$iLAST_VALID_GREGORIAN_YEAR = 4099;
	
	$iYearToFind = intval($iYearArg);
	$iDatingMethod = intval($iEDM);
	//Check values of arguments
	if(($iYearToFind < $iFIRST_EASTER_YEAR) || ($iYearToFind > $iLAST_VALID_GREGORIAN_YEAR))
	{
		return FALSE;
	}
	if(($iEDM < $iEDM_JULIAN) || ($iEDM > $iEDM_WESTERN))
	{
		return FALSE;
	}
	
	//Set up Default Values for calculations
	$imDay = 0;
	$imMonth = 0;
	$iFirstDig = 0;
	$iRemain19 = 0;
	$iTempNum = 0;
	$iTableA = 0;
	$iTableB = 0;
	$iTableC = 0;
	$iTableD = 0;
	$iTableE = 0;
	
	//Calculate Easter Sunday date
	// first 2 digits of year (integer division)
	$iFirstDig = floor($iYearToFind / 100);
	// remainder of year / 19
	$iRemain19 = $iYearToFind % 19;

	if(($iDatingMethod == $iEDM_JULIAN) || ($iDatingMethod == $iEDM_ORTHODOX))
	{
		//Calculate the Paschal Full Moon date
		$iTableA = ((225 - 11 * $iRemain19) % 30) + 21;
		
		//Find the next Sunday
		$iTableB = ($iTableA - 19) % 7;
		$iTableC = (40 - $iFirstDig) % 7;
		
		$iTempNum = $iYearToFind % 100;
		$iTableD = ($iTempNum + floor($iTempNum / 4)) % 7;
		
		$iTableE = ((20 - $iTableB - $iTableC - $iTableD) % 7) + 1;
		$imDay = $iTableA + $iTableE;
		
		//Convert Julian to Gregorian date
		if($iDatingMethod == $iEDM_ORTHODOX)
		{
			//Ten days were skipped in the Gregorian calendar
			//   from 5 - 14 October 1582.
			$iTempNum = 10;
			if($iYearToFind > 1600)
			{
				//Only every fourth century year is a leap year in the Gregorian calendar;
				//   every century was a leap year in the Julian.
				$iTempNum = $iTempNum + $iFirstDig - 16 - floor(($iFirstDig - 16) / 4);
			}
			$imDay = $imDay + $iTempNum;
		}
		
	} else {
		//That is $iDatingMethod == $iEDM_WESTERN
		# Calculate the Paschal Full Moon Date
		$iTempNum = floor(($iFirstDig - 15) / 2) + 202 - (11 * $iRemain19);
		$lFirstList = array(21, 24, 25, 27, 28, 29, 30, 31, 32, 34, 35, 38);
		$lSecondList = array(33, 36, 37, 39, 40);
		if(isset($lFirstList[intval($iFirstDig)]))
		{
			$iTempNum = $iTempNum - 1;
		} elseif(isset($lSecondList[intval($iFirstDig)]))
		{
			$iTempNum = $iTempNum - 2;
		}
		$iTempNum = $iTempNum % 30;
		
		$iTableA = $iTempNum + 21;
		if($iTempNum == 29)
		{
			$iTableA = $iTableA - 1;
		}
		if(($iTempNum == 28) && ($iRemain19 > 10))
		{
			$iTableA = $iTableA - 1;
		}
	
		//Find the next Sunday
		$iTableB = ($iTableA - 19) % 7;
		
		$iTableC = (40 - $iFirstDig) % 4;
		if($iTableC == 3)
		{
			$iTableC = $iTableC + 1;
		}
		if($iTableC > 1)
		{
			$iTableC = $iTableC + 1;
		}
		
		$iTempNum = $iYearToFind % 100;
		$iTableD = ($iTempNum + floor($iTempNum / 4)) % 7;
		
		$iTableE = ((20 - $iTableB - $iTableC - $iTableD) % 7) + 1;
		$imDay = $iTableA + $iTableE;
	}
	
	//Return the date
	if($imDay > 61)
	{
		$imDay = $imDay - 61;
		$imMonth = 5;
		//Easter may occur in May for $iEDM_ORTHODOX
	} elseif($imDay > 31)
	{
		$imDay = $imDay - 31;
		$imMonth = 4;
	} else {
		$imMonth = 3;
	}
	
	$dDate = mktime(0, 0, 0, $imMonth, $imDay, $iYearToFind);
	return $dDate;
}