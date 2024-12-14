/* -----------------------------------------------------------------------------
	RELATIVE PRICE 
------------------------------------------------------------------------------*/

* --- Producer Price Index

import excel "..\data\excel\PPI.xlsx", sheet("ecu") firstrow clear


* --- Clean base
label var year "Year"

rename IPP_base2014 ipp
label var ipp "IPP, base 2014"

* --- Create quarterly variable 
gen month = mod(_n - 1, 12) + 1 

keep if month == 3 | month == 6 |month == 9 | month == 12

gen quarter = mod(_n - 1, 4) + 1 
g quarter_date =yq(year,quarter)
format quarter_date %tq

label var quarter_date "Quarters"

order quarter_date
keep quarter_date ipp

tempfile ipp1
save `ipp1'

* --- Costumer Price Index

import excel "..\data\excel\IPC_anual_base_2014.xlsx", sheet("Sheet1") firstrow clear

* --- Clean base
drop C

* --- Create quarterly variable 
gen month = mod(_n - 1, 12) + 1 

keep if month == 3 | month == 6 |month == 9 | month == 12

gen quarter = mod(_n - 1, 4) + 1 
g quarter_date =yq(year,quarter)
format quarter_date %tq

label var quarter_date "Quarters"

order quarter_date
keep quarter_date ipc


merge 1:1 quarter_date using `ipp1'
keep if _merge == 3
drop _merge

label var ipc "IPC, base 2014"

* --- Relative price calculation
gen TNT = ipc/ipp
label var TNT "Relative price of nontraded and traded goods"