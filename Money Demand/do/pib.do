/* -----------------------------------------------------------------------------
	PIB TRIMESTRAL
------------------------------------------------------------------------------*/

import excel "..\data\excel\pib_anual.xlsx",sheet("Equilibrio-global k2007 niveles") cellrange(A9:B150) firstrow

* --- Clean base
rename Variables date

rename PIB gdp
label var gdp "Quarterly GPD" 

drop if gdp == .

* --- Keep only quarterly data 
gen temp = strlen(date)
drop if temp == 4
drop temp

* --- Create quarterly variable 
gen year = substr(date, 1, 4)
destring year, replace
gen quarter = mod(_n - 1, 4) + 1 

g quarter_date =yq(year,quarter)
format quarter_date %tq
label var quarter_date "Quarters"

drop date year quarter
order quarter_date 

* --- Given thar gdp is in thousends of dollars, we need to multiply gdp by 1000
replace gdp = gdp * 1000
format gdp %20.0f