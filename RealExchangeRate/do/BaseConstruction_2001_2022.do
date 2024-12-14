/* -----------------------------------------------------------------------------
CONSTRUCCION BASE PARA CALCULAR LOS DETERMINANTES DEL TIPO DE CAMBIO REAL EN 
ECUADOR
--------------------------------------------------------------------------------
Sara Brborich
Emilio Touma
--------------------------------------------------------------------------------
This version:				Noviembre 2023
Years covered:				2001 - 2019
------------------------------------------------------------------------------*/

/* -----------------------------------------------------------------------------
--- INITIAL SETUP 
------------------------------------------------------------------------------*/

global desktop_sara = "C:\Users\slbrb\OneDrive - Universidad San Francisco de Quito\Escritorio\Universidades\USFQ\7mo Semestre\Política Monetaria y Fiscal\Proyecto Final\Real_Exchange_Rate\data"

cd "$desktop_sara"

/* -----------------------------------------------------------------------------
--- Para calcular los determinantes del tipo de cambio real se necesitan varias 
	variables, entre las cuales se entuentran:
	
	1. real exchange rate base 2014=100
	2. relative price: ratio of the consumer price index base 2014=100 and the 
		producer price index. base 2015=100
	3. real interest rate differential: differential of the country's real 
		interest rate for the real interest rate of the United States
	4. monetary aggregates: money supply (M1) as a percentage of GDP
	5. economic growth per capita
	
	Todas las variables tendran una frecuancia trimestral.
------------------------------------------------------------------------------*/

/* -----------------------------------------------------------------------------
	REAL EXCHANGE RATE, BASE 2014 = 100
------------------------------------------------------------------------------*/
clear all

do "..\do\real_ex_rate.do"

tempfile temp_rexrai
save `temp_rexrai', replace

/* -----------------------------------------------------------------------------
	REAL INTEREST RATE DIFFERENTIAL
------------------------------------------------------------------------------*/

clear all

do "..\do\real_int_rate_d.do"

tempfile temp_rird
save `temp_rird', replace

/* -----------------------------------------------------------------------------
	MONETARY AGGREGATES
------------------------------------------------------------------------------*/

clear all

do "..\do\mon_agg.do"

tempfile temp_mona
save `temp_mona', replace

/* -----------------------------------------------------------------------------
	ECONOMIC GROWTH PER CAPITA
------------------------------------------------------------------------------*/

clear all

do "..\do\ec_gr_pc.do"

tempfile temp_ecgr
save `temp_ecgr', replace

/* -----------------------------------------------------------------------------
	RELATIVE PRICE 
------------------------------------------------------------------------------*/

clear all

do "..\do\rel_price.do"

tempfile temp_price
save `temp_price', replace


/* -----------------------------------------------------------------------------
--- Ahora se deben unir las bases para crear la base de datos completa
------------------------------------------------------------------------------*/

use `temp_rexrai', clear


merge 1:1 quarter_date using `temp_mona'
keep if _merge == 3
drop _merge

merge 1:1 quarter_date using `temp_ecgr'
keep if _merge == 3
drop _merge

merge 1:1 quarter_date using `temp_price'
keep if _merge == 3
drop _merge

merge 1:1 quarter_date using `temp_rird'
keep if _merge == 3
drop _merge



* --- Quedarse solo con las variables que se usaran en el modelo
drop ipc gdp M1 ipp real_M1 real_gdp

save "..\data\dtas\DataFinal.dta", replace