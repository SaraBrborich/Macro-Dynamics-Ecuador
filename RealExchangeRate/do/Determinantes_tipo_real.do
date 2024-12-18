/* -----------------------------------------------------------------------------
DETERMINANTES DEL TIPO DE CAMBIO REAL
--------------------------------------------------------------------------------
Sara Brborich
Emilio Touma
--------------------------------------------------------------------------------
This version:				Noviembre 2023
Years covered:				2001 - 2022
------------------------------------------------------------------------------*/

/* -----------------------------------------------------------------------------
--- INITIAL SETUP 
------------------------------------------------------------------------------*/
clear all
*Cargar la base de datos "DataFinal.dta"
tsset quarter_date

/* -----------------------------------------------------------------------------
	1.1. DETERMINANTES
------------------------------------------------------------------------------*/
newey rexrai L(0/2).mo_agg L(0/2).ecg_perc L(0/2).TNT L(0/2).in_r_d L(1/2).rexrai, lag(0)


/* -----------------------------------------------------------------------------
	1.2. Gráfico
------------------------------------------------------------------------------*/
tsline rexrai
