/* -----------------------------------------------------------------------------
CONSTRUCCION BASE PARA CALCULAR DEMANDA DE DINERO ECUADOR 
--------------------------------------------------------------------------------
Sara Brborich
Emilio Touma
--------------------------------------------------------------------------------
This version:				Noviebre 2023
Years covered:				2001 - 2023
------------------------------------------------------------------------------*/

/* -----------------------------------------------------------------------------
--- INITIAL SETUP 
------------------------------------------------------------------------------*/

global desktop_sara = "C:\Users\slbrb\OneDrive - Universidad San Francisco de Quito\Escritorio\Universidades\USFQ\7mo Semestre\Política Monetaria y Fiscal\Proyecto Final\Money_Demand\data"

cd "$desktop_sara"

/* -----------------------------------------------------------------------------
--- Para calcular la demanda de dinero se necesitan varias variables, entre las
	cuales se entuentran el PIB, el IPC, la oferta monetaria (M1) y la 
	variacion anual del IPC. Todas estas variables se usaran de manera
	trimestral.	
------------------------------------------------------------------------------*/


/* -----------------------------------------------------------------------------
	PIB TRIMESTRAL
------------------------------------------------------------------------------*/
clear all

do "..\do\pib.do"

tempfile gdp
save `gdp'


/* -----------------------------------------------------------------------------
	IPC y VARIACION
------------------------------------------------------------------------------*/
clear all

do "..\do\ipc.do"

tempfile ipc
save `ipc'


/* -----------------------------------------------------------------------------
	OFERTA MONETARIA
------------------------------------------------------------------------------*/
clear all

do "..\do\M1.do"

tempfile M1
save `M1'


/* -----------------------------------------------------------------------------
--- Ahora se deben unir las bases para crear la base de datos completa
------------------------------------------------------------------------------*/

use `gdp', clear

merge 1:1 quarter_date using `ipc'
keep if _merge == 3
drop _merge

merge 1:1 quarter_date using `M1'
keep if _merge == 3
drop _merge

rename quarter_date date

order date gdp M1

/* -----------------------------------------------------------------------------
	NUEVAS VARIABLES
------------------------------------------------------------------------------*/

* --- PIB REAL
gen real_gdp = gdp * ipc / 100
label var real_gdp "Real GDP, base 2014"

* --- M1 REAL
gen real_M1 = M1 * ipc / 100
label var real_M1 "Real M1, base 2014"

* --- Logaritmos
gen ln_gdp = ln(real_gdp)
gen ln_M1 = ln(real_M1)

label var ln_gdp "Log real GDP"
label var ln_M1 "Log real M1"

* --- Tasa de inflacion esperada
rename an_ipc_var ex_in_r
label var ex_in_r "Expected inflation rate"

* --- Tendencia
gen trend = _n
label var trend "Trend"

* --- Quedarse solo con las variables que se usaran en el modelo
keep date ln_gdp ln_M1 ex_in_r trend
order date ln_gdp ln_M1 ex_in_r trend

save "..\data\dtas\DataFinal.dta", replace