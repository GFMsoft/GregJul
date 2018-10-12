; Ferdiannd Marx - GFMSOFT - 11.10.2018 - 1.2.1
; Usage: _Dateumrechnen(DD.MM.YYYY)


;example
Global $DATE
$DATE="05.05.2005"
_DATEumrechnen($DATE)



func _DATEumrechnen($DATE)

	; Berechnung von gregorianischem Kalender zu julianischem Datum
	; Calc from Gregorian date to julian date.

	; For more information (German):
	;~ http://de.wikipedia.org/wiki/Umrechnung_zwischen_julianischem_Datum_und_gregorianischem_Kalender

	;~ SK - Schaltjahr beachten
	;~  SK = 1    (für Schaltjahre, wenn der Monat später als März liegt (M>2))
	;~  SK = 0    (sonst)
	;~ Die Monatskorrektur (MK) ergibt sich aus der Tabelle:

	;~   M    MK    Monatsname      M    MK    Monatsname      M    MK    Monatsname
	;~  ----------------------     ----------------------     ----------------------
	;~   1    -1    Januar          5    -1    Mai             9    +2    September
	;~   2     0    Februar         6     0    Juni           10    +2    Oktober
	;~   3    -2    März            7     0    Juli           11    +3    November
	;~   4    -1    April           8    +1    August         12    +3    Dezember
;~ ##############################################################################
	Local $sk=0,$mk,$LT,$LJ,$N400,$split, $FinalDATE

	if StringInStr($date,".")=false Then
		Return MsgBox(16,"Fehler","Das eingegebene Datum stimmt nicht.")
	EndIf

	;Eingehende Daten korrekt auf die Vars aufteilen
	;Check incoming Data - move data into vars

	$split=StringSplit($date,".")
	$y=$split[3]
	$m=$split[2]
	$t=$split[1]

	if $y/4 = floor($y/4) Then
		if $m >2 Then
			$sk=1
		EndIf
	EndIf

	if $m = 1 Then $mk = -1
	if $m = 2 Then $mk = 0
	if $m = 3 Then $mk = -2
	if $m = 4 Then $mk = -1
	if $m = 5 Then $mk = -1
	if $m = 6 Then $mk = 0
	if $m = 7 Then $mk = 0
	if $m = 8 Then $mk = 1
	if $m = 9 Then $mk = 2
	if $m = 10 Then $mk = 2
	if $m = 11 Then $mk = 3
	if $m = 12 Then $mk = 3

	$LT = $t + 30*($m-1) + $sk + $mk
	$LJ = $y - 1


	;#########################
	;~ Ab hier Restberechnungen
	$n400 = $LJ/400


	global $Wert, $rest

	if $n400 <> Floor($n400) Then
		;Da ein Rest vorhanden ist muss dieser bestimmt werden
		$Wert = Floor($n400) * 400
		$rest = $LJ - $Wert
	Else
		;Rest ist 0
		$rest = 0
	EndIf

	;Setze R400 aus Rest
	$r400=$rest
	;##########################

	$n100=$r400/100

	$Wert=0
	$rest=0

	if $n100 <> Floor($n100) Then
		;Rest ermitteln
		$wert = Floor($n100) * 100
		$rest = $r400 - $wert
	Else
		$rest=0
	EndIf

	;Setze r100 aus Rest
	$r100=$rest

	;###########################

	$n4 = $r100/4

	$wert=0
	$rest=0

	if $n4 <> Floor($n4) Then
		;Rest ermitteln FÜR N1
		$wert=Floor($n4)*4
		$rest=$r100 - $wert
	Else
		$rest = 0
	EndIf

	$n1 = $rest

	$jd0=1721426

	$JD = $jd0 + Floor($n400)*146097+Floor($n100)*36524+Floor($n4)*1461+$n1*365+$LT

	$FinalDATE=$JD
	Return ConsoleWrite($FinalDATE&@CRLF)
EndFunc