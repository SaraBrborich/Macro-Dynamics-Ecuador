/* -----------------------------------------------------------------------------
	OFERTA MONETARIA
------------------------------------------------------------------------------*/

import excel "..\data\excel\Oferta monetaria_mensual.xlsx", sheet("Mensual") cellrange(B8:H316) firstrow clear

* --- Clean base
rename eabcd M1
label var M1 "Monetary Offer"
drop if M1 == .

rename B year
rename C Mes

keep year Mes M1 
destring year, replace
replace year = cond(_n <= 12, 2000, 2000 + floor((_n - 1) / 12))

* --- Keep only March, June, September and Dicember for quarterly data
keep if Mes == "Marzo" | Mes == "Junio" | Mes == "Septiembre" | Mes == "Diciembre" 
drop Mes

* --- Create quarterly variable 
gen quarter = mod(_n - 1, 4) + 1 

g quarter_date =yq(year,quarter)
format quarter_date %tq
label var quarter_date "Quarters"

drop year quarter
order quarter_date 

* --- Given that M1 is in millions of dollars, we need to multiply M1 by 1000000
replace M1 = M1 * 1000000
format M1 %20.0f