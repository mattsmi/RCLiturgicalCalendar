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

//   Fasting: modern Melkite interpretation
define('sFAST_PRODIGAL_SON_WEEK', 'No fasting this week, in preparation for the Great Fast.');
define('sFAST_STRICT', 'Fast and strict abstinence');
define('sMELKITE_ABSTINENCE', 'We refrain from eating meat and meat products.');
define('sMELKITE_FAST_TXT', 'Fast + Fish, wine, oil allowed');
define('sMELKITE_FAST', 'We neither eat nor drink from midnight to noon.');
define('sFASTING_TODAY', 'Fasting today:');
define('sABSTINENCE_TODAY', 'Abstinence today:');
define('sPRODIGAL_WEEK_FAST', 'Prodigal Son Week');
define('sFASTFREE', 'Fast Free!');
define('sNO_FAST', 'No fast today:');
define('sFASTFREEa', 'We celebrate by neither fasting nor abstaining at all.');
define('sSTRICT', 'Strict abstinence');
define('sFAST_WINE', 'Wine, oil allowed');
define('sFAST_OIL', 'Fast + Wine allowed');
define('sFAST_CHEESE', 'Dairy, eggs, fish, wine, oil allowed');
define('sFAST_FISH', 'Fish, wine, oil allowed');
define('sFAST_STRICTa', 'Refrain from eating until noon, strict abstinence (xerophagy) thereafter.');
define('sSTRICTa', 'Strict abstinence (xerophagy) thereafter.');
define('sFAST_WINEa', 'Abstain from meat, meat products, milk, cheese, eggs, dairy foods, and fish.');
define('sFAST_OILa', 'Wine is permitted after the Vesperal Liturgy.');
define('sFAST_CHEESEa', 'Abstain from meat and meat products only.');
define('sFAST_FISHa', 'Abstain from meat, meat products, milk, cheese, eggs, and dairy foods.');
define('sFASTING_NA_MELKITE', 'No applicable fasting information for Melkites');
define('sFASTING_NA', 'No applicable fasting information');
define('sTRAD_FAST1', 'If, however, you follow the traditional fasting discipline:');

function pGetFastingInfo($sTodaysRec, $sLang) {
	$sTempMelkFastText = '';
	$sTempCalData = $sTodaysRec['Melkite_fasting'];
	if(($sTempCalData != NULL) && (mb_strlen($sTempCalData) > 0))
	{
		if($sTempCalData == 'Fast + Strict abstinence')
		{
			$sTempMelkFastText = pGetKnownTranslation(sFAST_STRICT);
		}
		if($sTempCalData == sMELKITE_FAST_TXT)
		{
			$sTempMelkFastText = pGetKnownTranslation(sFASTING_TODAY) . ' ' . pGetKnownTranslation(sMELKITE_FAST) . ' ' . pGetKnownTranslation(sMELKITE_ABSTINENCE);
		} elseif($sTempCalData == sFASTFREE)
		{
			$sTempMelkFastText = pGetKnownTranslation(sNO_FAST) . ' -- ' . pGetKnownTranslation(sFASTFREEa);
		} else {
			$sTempMelkFastText = pGetKnownTranslation(sABSTINENCE_TODAY);
			if($sTempCalData == sPRODIGAL_WEEK_FAST)
			{
				$sTempMelkFastText = $sTempMelkFastText . '  ' . pGetKnownTranslation(sFAST_PRODIGAL_SON_WEEK);
			} else {
				$sTempMelkFastText = $sTempMelkFastText . '  ' . pGetKnownTranslation(sMELKITE_ABSTINENCE);
			}
		}
	}

	//   Fasting: traditional method
	$sTempTradFastText = '';
	$sTempCalData = $sTodaysRec['Trad_Fasting'];
	if(($sTempCalData != NULL) && (mb_strlen($sTempCalData) > 0))
	{
		if($sTempCalData == 'Fast + Strict abstinence')
		{
			$sTempTradFastText = pGetKnownTranslation(sFAST_STRICT) . ' -- ' . pGetKnownTranslation(sFAST_STRICTa);
		} elseif($sTempCalData == sSTRICT)
		{
			$sTempTradFastText = pGetKnownTranslation(sSTRICTa);
		} elseif($sTempCalData == sFAST_WINE)
		{
			$sTempTradFastText = pGetKnownTranslation(sFAST_WINEa);
		} elseif($sTempCalData == sFAST_OIL)
		{
			$sTempTradFastText = pGetKnownTranslation(sFAST_OILa);
		} elseif($sTempCalData == sFAST_CHEESE)
		{
			$sTempTradFastText = pGetKnownTranslation(sFAST_CHEESEa);
		} elseif($sTempCalData == sFAST_FISH)
		{
			$sTempTradFastText = pGetKnownTranslation(sFAST_FISHa);
		} elseif($sTempCalData == sPRODIGAL_WEEK_FAST)
		{
			$sTempTradFastText = pGetKnownTranslation(sPRODIGAL_WEEK_FAST);
		} elseif($sTempCalData == sFASTFREE)
		{
			$sTempTradFastText = pGetKnownTranslation(sFASTFREEa);
		}

		#   fasting message about both fasting traditions
		if(mb_strlen($sTempMelkFastText) == 0)
			$sTempMelkFastText = pGetKnownTranslation(sFASTING_NA_MELKITE);
	} else {
		if(mb_strlen($sTempMelkFastText) > 0)
			#   fasting message about both fasting traditions
			$sTempTradFastText = pGetKnownTranslation(sFASTING_NA);
	}

	//   now print if anything found
	$sTempText = '';
	if(mb_strlen($sTempMelkFastText) > 0)
		$sTempText = $sTempMelkFastText . "\n";
	if(mb_strlen($sTempTradFastText) > 0)
		$sTempText = $sTempText . pGetKnownTranslation(sTRAD_FAST1) . ' ' . $sTempTradFastText;
	if(mb_strlen($sTempText) > 0)
		return $sTempText;
}

?>