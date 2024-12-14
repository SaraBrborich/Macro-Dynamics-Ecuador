/* -----------------------------------------------------------------------------
	IPC y VARIACION
------------------------------------------------------------------------------*/

import excel "..\data\excel\IPC_base_2014.xlsx", sheet("Export") cellrange(A2:H275) firstrow clear

* --- Clean base
drop Ciudad Nivel CódCCIF DescripciónCCIF

rename Año year
rename Indicador ipc
rename H an_ipc_var

label var ipc "IPC base 2014"
label var an_ipc_var "Annual IPC varation"

* --- Keep only March, June, September and Dicember for quarterly data
keep if Mes == "Marzo" | Mes == "Junio" | Mes == "Septiembre" | Mes == "Diciembre" 
drop Mes

* --- Create quarterly variable 
destring year, replace
gen quarter = mod(_n - 1, 4) + 1 

g quarter_date =yq(year,quarter)
format quarter_date %tq
label var quarter_date "Quarters"

drop year quarter
order quarter_date 