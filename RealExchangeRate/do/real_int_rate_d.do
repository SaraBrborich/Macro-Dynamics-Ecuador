/* -----------------------------------------------------------------------------
	REAL INTEREST RATE DIFFERENTIAL
------------------------------------------------------------------------------*/

/* -----------------------------------------------------------------------------
	For this variable we would need the 'TASAS DE INTERÉS EFECTIVAS VIGENTES' 
	from Ecuador, and the Real interest rate from USA.
------------------------------------------------------------------------------*/

* --- Real interest rate from USA

import excel "..\data\excel\real_interest_rate_USA.xlsx", sheet("FRED Graph") cellrange(A11:B285) firstrow clear

rename REAINTRATREARAT10Y real_interest_rate_USA

* --- Create quarterly variable 
gen year = cond(_n <= 12, 2001, 2001 + floor((_n - 1) / 12))
gen month = mod(_n - 1, 12) + 1 

keep if month == 3 | month == 6 |month == 9 | month == 12

gen quarter = mod(_n - 1, 4) + 1 
g quarter_date =yq(year,quarter)
format quarter_date %tq
label var quarter_date "Quarters"

drop observation_date year month quarter 

replace real_interest_rate_USA = real_interest_rate_USA/100
rename real_interest_rate_USA r_usa
label var r_usa "Real Interest Rate USA"

tempfile rusa
save `rusa'

* --- Real interest rate from Ecuador

import excel "..\data\excel\tasa_interes_efectiva.xlsx", sheet("tasa_interes_efectiva_serie") firstrow clear

gen interest_rate = interest_rate_percent/100
drop interest_rate_percent

* --- Create quarterly variable 
gen quarter = mod(_n - 1, 4) + 1 
g quarter_date =yq(year,quarter)
format quarter_date %tq
label var quarter_date "Quarters"

drop year month quarter

rename interest_rate r_ecu
label var r_ecu "Interest rate Ecuador" 

tempfile recu
save `recu'

* --- Merge data to create interest rate differential
use `rusa', clear
merge 1:1 quarter_date using `recu'
drop _merge

gen in_r_d = r_ecu - r_usa
label var in_r_d "Interest rate diffetential"

order quarter_date
keep quarter_date in_r_d