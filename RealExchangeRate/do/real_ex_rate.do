/* -----------------------------------------------------------------------------
	REAL EXCHANGE RATE, BASE 2014 = 100
------------------------------------------------------------------------------*/

import excel "..\data\excel\trimestral_rexrai.xlsx", sheet("Tipo De Cambio Real Mensual")firstrow clear

* --- Clean base
rename Año year
rename Mes month

destring month, replace
destring year, replace
keep if month == 3 | month == 6 |month == 9 | month == 12

label var year "Year"

* --- Create quarterly variable 
gen quarter = mod(_n - 1, 4) + 1 

g quarter_date =yq(year,quarter)
format quarter_date %tq
label var quarter_date "Quarters"

drop year month quarter

* --- Keep only necessary values
rename ValordelEfectivoRealMensua rexrai
label variable rexrai "Real Exchange Rate Index"

order quarter_date rexrai
keep quarter_date rexrai