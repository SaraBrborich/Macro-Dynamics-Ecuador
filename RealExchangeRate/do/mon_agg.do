/* -----------------------------------------------------------------------------
	MONETARY AGGREGATES
------------------------------------------------------------------------------*/

/* -----------------------------------------------------------------------------
	This variable is the result of the money supply (M1) as a percentage of GDP.
------------------------------------------------------------------------------*/

/* -----------------------------------------------------------------------------
	PIB TRIMESTRAL
------------------------------------------------------------------------------*/
import excel "..\data\excel\pib_anual.xlsx",sheet("Equilibrio-global k2007 niveles") cellrange(A9:B150) firstrow clear

* --- Clean base
rename Variables date

rename PIB gdp
label var gdp "Trimestral GPD" 

drop if gdp == .

* --- Keep only trimestral data 
gen temp = strlen(date)
drop if temp == 4
drop temp

* --- Create quarterly variable 
gen year = cond(_n <= 4, 2000, 2000 + floor((_n - 1) / 4))

gen quarter = mod(_n - 1, 4) + 1 
g quarter_date =yq(year,quarter)
format quarter_date %tq
label var quarter_date "Quarters"

drop date year quarter 

* --- Given thar gdp is in thousends of dollars, we need to multiply gdp by 1000
replace gdp = gdp * 1000
format gdp %20.0f

order quarter_date

tempfile pib
save `pib'

/* -----------------------------------------------------------------------------
	M1
------------------------------------------------------------------------------*/

import excel "..\data\excel\Oferta monetaria_mensual.xlsx", sheet("Mensual") cellrange(B8:H316) firstrow clear

* --- Clean base
rename eabcd M1
drop if M1 == .

rename B year
label var year "Year"

keep year  M1 
destring year, replace

* --- Create quarterly variable 
replace year = cond(_n <= 12, 2000, 2000 + floor((_n - 1) / 12))
gen month = mod(_n - 1, 12) + 1 

keep if month == 3 | month == 6 |month == 9 | month == 12

gen quarter = mod(_n - 1, 4) + 1 
g quarter_date =yq(year,quarter)
format quarter_date %tq

label var quarter_date "Quarters"
label var M1 "Monetary Offer"

order quarter_date
keep M1 quarter_date

* --- Given thar M1 is in millions of dollars, we need to multiply M1 by 1000000
replace M1 = M1 * 1000000
format M1 %20.0f

tempfile m1
save `m1'

/* -----------------------------------------------------------------------------
	MONEY SUPPLY AS A PERCENTAGE OF THE GDP
------------------------------------------------------------------------------*/

use `pib', clear
merge 1:1 quarter_date using `m1'
keep if _merge == 3
drop _merge

tempfile temp2
save `temp2'

* --- REAL MONEY SUPPLY AND GDP 
* --- We need the IPC to deflact the data, so it's comparable with the other 
*     variables.
clear 

import excel "..\data\excel\IPC_anual_base_2014.xlsx", sheet("Sheet1") firstrow clear
drop C 

* --- Create quarterly variable 
gen month = mod(_n - 1, 12) + 1 

keep if month == 3 | month == 6 |month == 9 | month == 12

gen quarter = mod(_n - 1, 4) + 1 
g quarter_date =yq(year,quarter)
format quarter_date %tq

label var quarter_date "Quarters"

order quarter_date
keep ipc quarter_date

merge 1:1 quarter_date using `temp2'
keep if _merge == 3
drop _merge

label var ipc "IPC base 2014 = 100"

* --- M1 REAL
gen real_M1 = M1 * ipc / 100
label var real_M1 "Real M1, base 2014"
format real_M1 %20.0f

* --- PIB REAL
gen real_gdp = gdp * ipc / 100
label var real_gdp "Real GDP, base 2014"
format real_gdp %20.0f

* --- Monetary aggregates
gen mo_agg = (real_M1 / real_gdp) * 100
label var mo_agg "Monetary Aggregates"