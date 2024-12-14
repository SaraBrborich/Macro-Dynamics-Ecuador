/* -----------------------------------------------------------------------------
	ECONOMIC GROWTH PER CAPITA
------------------------------------------------------------------------------*/

import excel "..\data\excel\pib__timertral.xlsx", sheet("Equilibrio O-U k2007 (t-1)") cellrange(A9:J154) firstrow clear

* --- Clean base
keep Variables PIB
drop if PIB == .

rename PIB ecg_perc
rename Variables date

* --- Keep only quarterly data 
gen temp = strlen(date)
drop if temp == 4
drop temp

* --- Create quarterly variable 
gen year = cond(_n <= 4, 2000, 2000 + floor((_n - 1) / 4))

gen quarter = mod(_n - 1, 4) + 1 
g quarter_date =yq(year,quarter)
format quarter_date %tq
label var quarter_date "Quarters"

order quarter_date
keep ecg_perc quarter_date

label var ecg_perc "Economic growth per capita"